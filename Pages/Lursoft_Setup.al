page 25028827 "Lursoft Communication Setup"
{
    PageType = Card;
    SourceTable = "Lursoft Communication Setup";
    CaptionML = ENU='Lursoft Communication Setup';

    layout
    {
        area(content)
        {
            group(General)
            {
                CaptionML = ENU='General';
                
                field(User;User) {}
                field(PasswordTemp;PasswordTemp)
                {
                    CaptionML = ENU='Password';
                    ExtendedDatatype = Masked;
                    trigger OnValidate()
                    begin
                        SetPassword(PasswordTemp);
                        Commit;
                        CurrPage.Update;
                    end;
                }
            }
        }
    }
    var
        PasswordTemp : Text;

    trigger OnOpenPage()
    begin
        Reset;
        if not get then begin
            Init;
            Insert;
            User := 'nsoft_xml';
            SetPassword('Navi$oft2017LS');
            Modify;
        end;
    end;

    trigger OnAfterGetRecord()
    begin
        PasswordTemp := '';
        if (User <> '') and (not IsNullGuid(Password)) then
            PasswordTemp := '***************';
    end;

}