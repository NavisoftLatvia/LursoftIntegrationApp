table 25028832 "REST Web Service Arguments"
{

    fields
    {
        field(1;PrimaryKey;Integer) {}
        field(2;RestMethod;Option)
        {
            OptionMembers=Get,post,delete,patch,put;
        }
        field(3;URL;Text[250]) {}
        field(4;Accept;Text[30]) {}
        field(5;ETag;Text[250]) {}
        field(6;UserName;Text[50]) {}
        field(7;Password;Text[50]) {}
        field(100;Blob;Blob) {}
    }
    
    keys
    {
        key(PK;PrimaryKey)
        {
            Clustered = true;
        }
    }
    
    var
        RequestContent: HttpContent;
        ResponseHeaders: HttpHeaders;
        RequestContentSet: Boolean;
    procedure SetRequestContent(var value: HttpContent)
    begin
        RequestContent := value;
        RequestContentSet := true;
    end;
    
    procedure HasRequestContent() : Boolean
    begin
        exit(RequestContentSet);
    end;
    
    procedure GetRequestContent(var _value : HttpContent)
    begin
        _value := RequestContent;
    end;
    
    procedure SetResponseContent(var _value: HttpContent)
    var
        InStr: InStream;
        OutStr: OutStream;
    begin
        Blob.CreateInStream(InStr);
        _value.ReadAs(InStr);
        
        Blob.CreateOutStream(OutStr);
        CopyStream(OutStr,InStr);
        
    end;
    procedure HasResponseContent() : Boolean
    begin
        exit(Blob.HasValue);
    end;
    
    procedure GetResponseContent(var _value : HttpContent)
    var
        InStr: InStream;
    begin
        Blob.CreateInStream(InStr);
        _value.Clear();
        _value.WriteFrom(InStr);
    end;
    
    procedure GetResponseContentAsText() ReturnValue : Text
    var
        InStr: InStream;
        Line: Text;
    begin
        if not HasResponseContent then
            exit;
            
        Blob.CreateInStream(InStr);
        InStr.ReadText(ReturnValue);
        
        while not InStr.EOS do begin
            InStr.ReadText(Line);
            ReturnValue += Line;
        end;
    end;
    
    procedure SetResponseHeaders(var _value : HttpHeaders)
    begin
        ResponseHeaders := _value;
    end;
    
    procedure GetResponseHeaders(var _value : HttpHeaders)
    begin
        _value := ResponseHeaders;
    end;
    
}