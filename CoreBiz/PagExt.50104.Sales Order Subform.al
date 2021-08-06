pageextension 50104 SalesOrderSubformExt extends "Sales Order Subform"
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