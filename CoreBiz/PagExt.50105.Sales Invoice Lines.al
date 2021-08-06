pageextension 50105 PostedSalesInvoiceSubformExt extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter(Description)
        {
            field(Attributes; Rec.Attributes)
            {
                Caption = 'Attributes';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}