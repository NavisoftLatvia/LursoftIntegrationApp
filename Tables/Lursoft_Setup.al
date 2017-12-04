table 25028831 "Lursoft Communication Setup"
{
    CaptionML = ENU='Lursoft Communication Setup', LVI='Lursoft komunikācijas uzstādījumi';

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            CaptionML = ENU='Primary Key', LVI='Primārā atslēga';
        }
        field(2; User; text[250])
        {
            CaptionML = ENU='User Name', LVI='Lietotājvārds';
        }
        field(3; Password; Guid)
        {
            CaptionML = ENU='Password', LVI='Parole';
            Editable = false;
        }
    }

    keys
    {
        key(PK;PrimaryKey)
        {
            Clustered = true;
        }
    }

    procedure SetPassword(Value: Text)
    var
        ServicePassword: Record "Service Password";
    begin
        if IsNullGuid(Password) or not ServicePassword.get(Password) then begin
            ServicePassword.SavePassword(Value);
            ServicePassword.Insert(true);
            Password := ServicePassword."Key";
        end else begin
            ServicePassword.SavePassword(Value);
            ServicePassword.Modify;
        end;
    end;

    procedure GetPassword(): Text
    var
        ServicePassword: Record "Service Password";
    begin
        if not IsNullGuid(Password) then
            if ServicePassword.get(Password) then
                exit(ServicePassword.GetPassword());
    end;
}