codeunit 25028827 "REST Web Service Management"
{
    procedure CallRESTWebService(var Parameters : Record "REST Web Service Arguments") : Boolean
    var
        TempBlob: Record TempBlob temporary;
        Client: HttpClient;
        Content: HttpContent;
        AuthHeaderValue: HttpHeaders;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage ;
        ResponseMessage: HttpResponseMessage;
        AuthText: Text;
        ntv : Text;
        jsn : JsonArray;
        jsno : JsonObject;
    begin
        RequestMessage.Method := Format(Parameters.RestMethod);
        RequestMessage.SetRequestUri(Parameters.URL);
        
        RequestMessage.GetHeaders(Headers);
        
        if Parameters.Accept <> '' then
            Headers.Add('Accept',Parameters.Accept);
            
        if Parameters.UserName <> '' then begin
            AuthText := StrSubstNo('%1:%2',Parameters.UserName,Parameters.Password);
            TempBlob.WriteAsText(AuthText,TextEncoding::Windows);
            Headers.Add('Authorization',StrSubstNo('Basic %1',TempBlob.ToBase64String()));
        end;
        
        if Parameters.ETag <> '' then
            Headers.Add('If-Match',Parameters.ETag);
            
        if Parameters.HasRequestContent then begin
            Parameters.GetRequestContent(Content);
            RequestMessage.Content := Content;
        end;
             
        Client.Send(RequestMessage,ResponseMessage);
        
        Headers := ResponseMessage.Headers;
        Parameters.SetResponseHeaders(Headers);
        
        Content := ResponseMessage.Content;

        Parameters.SetResponseContent(Content);
        
        exit(ResponseMessage.IsSuccessStatusCode);
    end;
}

