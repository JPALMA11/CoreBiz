tableextension 50100 ItemAttributeValueSelectionExt extends "Item Attribute Value Selection"
{
    fields
    {
        field(50000; "Value 2"; Text[250])
        {
            Caption = 'Value';

            trigger OnValidate()
            var
                ItemAttributeValue: Record "Item Attribute Value";
                ItemAttribute: Record "Item Attribute";
                DecimalValue: Decimal;
                IntegerValue: Integer;
                DateValue: Date;
            begin
                if Value = '' then
                    exit;

                ItemAttribute.Get("Attribute ID");
                if FindItemAttributeValueCaseSensitive(ItemAttributeValue) then
                    CheckIfValueBlocked(ItemAttributeValue);

                case "Attribute Type" of
                    "Attribute Type"::Option:
                        begin
                            if ItemAttributeValue.Value = '' then begin
                                if not FindItemAttributeValueCaseInsensitive(ItemAttributeValue) then
                                    Error(AttributeValueDoesntExistErr, Value);
                                CheckIfValueBlocked(ItemAttributeValue);
                            end;
                            AdjustAttributeValue(ItemAttributeValue);
                        end;
                    "Attribute Type"::Decimal:
                        If Not Evaluate(DecimalValue, "Value 2") then
                            Error(AttributeValueTypeMismatchErr, "Value 2", ItemAttribute.Type);
                    "Attribute Type"::Integer:
                        If Not Evaluate(IntegerValue, "Value 2") then
                            Error(AttributeValueTypeMismatchErr, "Value 2", ItemAttribute.Type);
                    "Attribute Type"::Date:
                        If Not Evaluate(DateValue, "Value 2") then
                            Error(AttributeValueTypeMismatchErr, "Value 2", ItemAttribute.Type);
                end;
            end;
        }
    }
    local procedure FindItemAttributeValueCaseSensitive(var ItemAttributeValue: Record "Item Attribute Value"): Boolean
    begin
        ItemAttributeValue.SetRange("Attribute ID", "Attribute ID");
        ItemAttributeValue.SetRange(Value, Value);
        exit(ItemAttributeValue.FindFirst);
    end;

    local procedure FindItemAttributeValueCaseInsensitive(var ItemAttributeValue: Record "Item Attribute Value"): Boolean
    var
        AttributeValue: Text[250];
    begin
        ItemAttributeValue.SetRange("Attribute ID", "Attribute ID");
        ItemAttributeValue.SetRange(Value);
        if ItemAttributeValue.FindSet then begin
            AttributeValue := LowerCase(Value);
            repeat
                if LowerCase(ItemAttributeValue.Value) = AttributeValue then
                    exit(true);
            until ItemAttributeValue.Next() = 0;
        end;
        exit(false);
    end;

    local procedure CheckIfValueBlocked(ItemAttributeValue: Record "Item Attribute Value")
    begin
        if ItemAttributeValue.Blocked then
            Error(AttributeValueBlockedErr, ItemAttributeValue.Value);
    end;

    local procedure AdjustAttributeValue(var ItemAttributeValue: Record "Item Attribute Value")
    begin
        if Value <> ItemAttributeValue.Value then
            Value := ItemAttributeValue.Value;
    end;

    var
        AttributeValueBlockedErr: Label 'The item attribute value ''%1'' is blocked.', Comment = '%1 - arbitrary name';
        AttributeValueDoesntExistErr: Label 'The item attribute value ''%1'' doesn''t exist.', Comment = '%1 - arbitrary name';
        AttributeValueTypeMismatchErr: Label 'The value ''%1'' does not match the item attribute of type %2.', Comment = ' %1 is arbitrary string, %2 is type name';
}