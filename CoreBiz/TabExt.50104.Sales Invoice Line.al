tableextension 50104 SalesInvoiceLine extends "Sales Invoice Line"
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