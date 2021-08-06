tableextension 50101 ItemAttributeValueExt extends "Item Attribute Value"
{
    fields
    {
        field(50000; "Enabled"; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}