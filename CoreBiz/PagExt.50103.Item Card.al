pageextension 50103 "ItemCardExt" extends "Item Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.ItemAttributesFactbox.Page.InitItemNo(Rec."No.");
    end;

    var
        myInt: Integer;
}