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
        Arguments : Record "REST Web Service Arguments";
        LursoftCommunicationSetup : Record "Lursoft Communication Setup";
        JSONMethods : Codeunit "JSON Methods";
        TypeHelper : Codeunit "Type Helper";
        JSONResult : JsonObject;
        _xmlNode : XmlNode;
        _xmlNodeList : XmlNodeList;
        _xlmElement : XmlElement;
        _xmlDoc : XmlDocument;
        _xmlProcessor : XmlNamespaceManager;
        data : Text;
        info : Text;
        MessageText : Text;
        password : Text;
        ResponseText : Text;
        ct : Integer;
        curr : Integer;
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
        MESSAGE(ResponseText);
        
        if not XmlDocument.ReadFrom(ResponseText, _xmlDoc) then
          error('Text is not valid XML!');

        _xmlDoc.GetChildNodes().Get(1, _xmlNode);  
        
        ResponseText := _xmlNode.AsXmlElement.NamespaceUri;

_xmlProcessor.NameTable(_xmlDoc.NameTable());
_xmlProcessor.AddNamespace('', _xmlNode.AsXmlElement.NamespaceUri);
//_xmlDoc.NameTable.Get('SessionId', info);

 _xmlDoc.SelectNodes('Lursoft:SessionId', _xmlProcessor, _xmlNodeList);
/*
ct := _xmlNodeList.Count();

repeat
  info += _xmlNode.AsXmlElement.InnerText;
  curr += 1;
until curr = ct; 
*/

Message(info);
    exit(ResponseText);
        
    end;
}