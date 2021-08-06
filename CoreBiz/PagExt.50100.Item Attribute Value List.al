pageextension 50100 ItemAttributeValueListExt extends "Item Attribute Value List"
{
    layout
    {
        modify(Value)
        {
            Enabled = false;
            Visible = false;
        }
        addafter("Attribute Name")
        {
            field(Enabled; Rec."Value 2")
            {
                Caption = 'Value';
                ApplicationArea = All;

                trigger OnLookup(var Text: Text): Boolean
                var
                    ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                    ItemAttributeValue: Record "Item Attribute Value";
                    ItemAttribute: Record "Item Attribute";
                    Values: Text;
                begin
                    ItemAttribute.Get(Rec."Attribute ID");
                    if ItemAttribute.Type = ItemAttribute.Type::Option then begin
                        ItemAttributeValue.Reset();
                        ItemAttributeValue.SetRange("Attribute ID", Rec."Attribute ID");
                        if ItemAttributeValue.FindSet() then begin
                            if Page.RunModal(Page::"Item Attribute Values", ItemAttributevalue) = Action::LookupOK then begin
                                ItemAttributeValue.Reset();
                                ItemAttributeValue.SetRange(Enabled, true);
                                if ItemAttributeValue.FindFirst() then
                                    repeat
                                        Values += ItemAttributeValue.Value + ',';
                                    until ItemAttributeValue.Next() = 0;
                                Values := CopyStr(Values, 1, StrLen(Values) - 1);

                                ItemAttributeValueMapping.SetRange("Table ID", DATABASE::Item);
                                ItemAttributeValueMapping.SetRange("No.", RelatedRecordCode);
                                ItemAttributeValueMapping.SetRange("Item Attribute ID", ItemAttributeValue."Attribute ID");
                                if ItemAttributeValueMapping.FindFirst then begin
                                    ItemAttributeValueMapping."Value Name" := Values;
                                    ItemAttributeValueMapping.Modify();
                                end;
                                Rec."Value 2" := Values;


                            end;
                        end;
                    end;
                end;

                trigger OnValidate()
                var
                    ItemAttributeValue: Record "Item Attribute Value";
                    ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                    ItemAttribute: Record "Item Attribute";
                begin
                    Rec.Value := Rec."Value 2";
                    Rec.Modify(true);

                    if not FindAttributeValue(ItemAttributeValue) then
                        InsertItemAttributeValue(ItemAttributeValue, Rec);

                    ItemAttributeValueMapping.SetRange("Table ID", DATABASE::Item);
                    ItemAttributeValueMapping.SetRange("No.", RelatedRecordCode);
                    ItemAttributeValueMapping.SetRange("Item Attribute ID", ItemAttributeValue."Attribute ID");
                    if ItemAttributeValueMapping.FindFirst then begin
                        ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                        ItemAttributeValueMapping.Modify();
                    end;

                    ItemAttribute.Get("Attribute ID");
                    if ItemAttribute.Type <> ItemAttribute.Type::Option then
                        if FindAttributeValueFromRecord(ItemAttributeValue, xRec) then
                            if not ItemAttributeValue.HasBeenUsed then
                                ItemAttributeValue.Delete();
                end;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
    begin
        UpdateValueName(RelatedRecordCode);

        ItemAttributeValueMapping.Reset();
        ItemAttributeValueMapping.SetRange("No.", RelatedRecordCode);
        if ItemAttributeValueMapping.FindFirst() then
            repeat
                Rec.Reset();
                Rec.SetRange("Attribute ID", ItemAttributeValueMapping."Item Attribute ID");
                if Rec.FindFirst() then begin
                    Rec."Value 2" := ItemAttributeValueMapping."Value Name";
                    Rec.Modify();
                end;
            until ItemAttributeValueMapping.Next() = 0;

        Rec.Reset();
    end;

    local procedure UpdateValueName(pItemNo: Code[50])
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttributValue: Record "Item Attribute Value";
        ItemAttribute: Record "Item Attribute";
    begin
        ItemAttributeValueMapping.Reset();
        ItemAttributeValueMapping.SetRange("No.", pItemNo);
        if ItemAttributeValueMapping.FindFirst() then
            repeat
                ItemAttributValue.Reset();
                ItemAttributValue.SetRange("Attribute ID", ItemAttributeValueMapping."Item Attribute ID");
                ItemAttributValue.SetRange(ID, ItemAttributeValueMapping."Item Attribute Value ID");
                if ItemAttributValue.FindFirst() then begin
                    ItemAttribute.get(ItemAttributeValueMapping."Item Attribute ID");
                    if ItemAttribute.Type <> ItemAttribute.Type::Option then begin
                        ItemAttributeValueMapping."Value Name" := ItemAttributValue.Value;
                        ItemAttributeValueMapping.Modify();
                    end else begin
                        if ItemAttributeValueMapping."Value Name" = '' then begin
                            ItemAttributeValueMapping."Value Name" := ItemAttributValue.Value;
                            ItemAttributeValueMapping.Modify();
                        end;
                    end;
                end;
            until ItemAttributeValueMapping.Next() = 0;
    end;

    var
        myInt: Integer;
}