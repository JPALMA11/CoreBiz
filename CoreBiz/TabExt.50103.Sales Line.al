tableextension 50103 SalesLineExt extends "Sales Line"
{
    fields
    {
        field(50000; Attributes; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}