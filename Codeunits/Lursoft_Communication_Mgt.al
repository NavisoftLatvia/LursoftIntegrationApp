codeunit 25028829 "Lursoft Communication Mgt."
{
    trigger OnRun();
    begin
        // 'nsoft_xml', 'Navi$oft2017LS'
        Message(StartLursoftSession());
    end;
    local procedure ErrorIfNoUserName(LursoftStp: Record "Lursoft Communication Setup")
    begin
        LursoftStp.TestField(User);
    end;
    local procedure ErrorINoPassword(LursoftStp: Record "Lursoft Communication Setup")
    begin
        LursoftStp.TestField(Password);
    end;
    local procedure CallWebService(var Arguments: Record "REST Web Service Arguments" temporary) Success : Boolean
    var
        RESTWebService: Codeunit "REST Web Service Management";
    begin
        Success := RESTWebService.CallRESTWebService(Arguments);
    end;
    local procedure TestAndSaveResult(var Arguments: Record "REST Web Service Arguments") Response: Text;
    begin
        Response := Arguments.GetResponseContentAsText();
    end;
    local procedure InitArguments(var Arguments: Record "REST Web Service Arguments" temporary; data: Text; LursoftCommunicationSetup: Record "Lursoft Communication Setup")
    var
        RequestContent: HttpContent;
        RequestHeaders: HttpHeaders;
    begin
        Arguments.URL := 'https://www.lursoft.lv/server3';
        Arguments.RestMethod := Arguments.RestMethod::post;
        
        RequestContent.WriteFrom(data);
        RequestContent.GetHeaders(RequestHeaders);
        RequestHeaders.Remove('Content-Type');
        RequestHeaders.Add('Content-Type','application/x-www-form-urlencoded');
        
        Arguments.SetRequestContent(RequestContent);
    end;
    //_baseUrl := 'https://www.lursoft.lv/server3?act=LOGINXML&Userid=' + _userID + '&Password=' + _password + '&utf=1';
    local procedure StartLursoftSession() SessionKey : Text;
    
    var
        Arguments: Record "REST Web Service Arguments";
        LursoftCommunicationSetup: Record "Lursoft Communication Setup";
        JSONMethods: Codeunit "JSON Methods";
        TypeHelper: Codeunit "Type Helper";
        JSONResult: JsonObject;
        _xlmElement: XmlElement;
        _xmlNodeList: XmlNodeList;
        _xmlDoc: XmlDocument;
        _xmlNode: XmlNode;
        _xmlProcessor: XmlNamespaceManager;
        ct: Integer;
        curr: Integer;
        data: Text;
        info: Text;
        MessageText: Text;
        password: Text;
        ResponseText: Text;
    begin
        LursoftCommunicationSetup.Get();
        ErrorIfNoUserName(LursoftCommunicationSetup);
        ErrorINoPassword(LursoftCommunicationSetup);
        password := LursoftCommunicationSetup.GetPassword();
        
        data := StrSubstNo('act=LOGINXML&Userid=%1&Password=%2&utf=1',
                TypeHelper.UrlEncode(LursoftCommunicationSetup.User),
                TypeHelper.UrlEncode(password)
                );
        InitArguments(Arguments,data,LursoftCommunicationSetup);
        if not CallWebService(Arguments) then
            exit;
            
        ResponseText := TestAndSaveResult(Arguments);
        Message('1:\' + ResponseText);
        
        if not XmlDocument.ReadFrom(ResponseText,_xmlDoc) then
            Error('Text is not valid XML!');
            
        _xmlProcessor.NameTable(_xmlDoc.NameTable());
        _xmlProcessor.AddNamespace('soap','http://www.w3.org/2001/09/soap-envelope');
        _xmlProcessor.AddNamespace('Lursoft','x-schema:/schemas/lursoft_header.xsd');
        if not _xmlDoc.SelectNodes('//Lursoft:SessionId',_xmlProcessor,_xmlNodeList) then
            Error('Response does not contains any Session Key');
            
        foreach _xmlNode in _xmlNodeList do begin
            SessionKey += _xmlNode.AsXmlElement.InnerText;
        end;
        
        exit(SessionKey);       
    end;
}