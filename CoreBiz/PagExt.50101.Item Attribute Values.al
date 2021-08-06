pageextension 50101 ItemAttributeValuesExt extends "Item Attribute Values"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnClosePage()
    var
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        ItemAttributeValue.Reset();
        If ItemAttributeValue.FindSet() then
            ItemAttributeValue.ModifyAll(Enabled, false);

        CurrPage.SetSelectionFilter(ItemAttributeValue);
        If ItemAttributeValue.FindFirst() then
            repeat
                ItemAttributeValue.Enabled := true;
                ItemAttributeValue.Modify();
            until ItemAttributeValue.Next() = 0;
    end;

    var
        myInt: Integer;
}