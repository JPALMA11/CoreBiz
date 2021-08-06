pageextension 50102 "ItemAttributeFactboxExt" extends "Item Attributes Factbox"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    begin
        LoadMultiValue();
    end;

    trigger OnAfterGetCurrRecord();
    begin
        LoadMultiValue();
    end;

    var
        ItemAttCode2: Code[30];

    procedure InitItemNo(pItemNo: Code[30])
    begin
        ItemAttCode2 := pItemNo;
    end;

    local procedure LoadMultiValue()
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
    begin
        ItemAttributeValueMapping.Reset();
        ItemAttributeValueMapping.SetRange("No.", ItemAttCode2);
        if ItemAttributeValueMapping.FindFirst() then
            repeat
                ItemAttribute.get(ItemAttributeValueMapping."Item Attribute ID");
                if ItemAttribute.Type = ItemAttribute.Type::Option then begin
                    Rec.Reset();
                    Rec.SetRange("Attribute ID", ItemAttribute.ID);
                    if Rec.FindFirst() then begin
                        if ItemAttributeValueMapping."Value Name" <> '' then begin
                            Rec.Value := ItemAttributeValueMapping."Value Name";
                            Rec.Modify();
                        end;
                    end;
                    Rec.Reset();
                end;
            until ItemAttributeValueMapping.Next() = 0;
    end;
}