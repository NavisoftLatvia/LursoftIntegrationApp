pageextension 25028828 MyExtension extends "Customer List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }
    
    var
        lcm : Codeunit "Lursoft Communication Mgt.";
lsp : Page "Lursoft Communication Setup";
    trigger OnOpenPage();
    begin
lsp.runmodal;
lcm.run();

    end;
}