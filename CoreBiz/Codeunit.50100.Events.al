
codeunit 50100 Events
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnAfterUpdateUnitPrice', '', false, false)]
    local procedure PopulateAttributes(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
        Values: Text;
    begin
        If SalesLine.Type = SalesLine.Type::Item then begin
            ItemAttributeValueMapping.Reset();
            ItemAttributeValueMapping.SetRange("No.", SalesLine."No.");
            if ItemAttributeValueMapping.FindFirst() then
                repeat
                    ItemAttribute.Get(ItemAttributeValueMapping."Item Attribute ID");
                    Values += ItemAttribute.Name + ',';
                until ItemAttributeValueMapping.Next() = 0;

            IF Values <> '' then begin
                Values := CopyStr(Values, 1, StrLen(Values) - 1);
                SalesLine.Attributes := Values;
            end else begin
                SalesLine.Attributes := 'N/A';
            end;

        end else begin
            SalesLine.Attributes := 'N/A';
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure OnBeforeVerifyFieldNotChanged(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean)
    begin
        SalesInvLine.Attributes := SalesLine.Attributes;
    end;

    var
        myInt: Integer;
}