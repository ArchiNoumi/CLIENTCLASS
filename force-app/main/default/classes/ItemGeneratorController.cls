public with sharing class ItemGeneratorController {
    private static String BASE_URL = URL.getOrgDomainURL().toExternalForm();
    private static String CONNECTED_APP_CONSUMER_KEY = '3MVG9DREgiBqN9WkNC9lbkCo3Fl1fsMbYy7Tj8b8N0DuL2rQAWQmR8O6EUjuyZz9IJVmb6Vfwu.ON1nitrn1v';
    private static String CONNECTED_APP_CONSUMER_SECRET = '25AE0421E253897DA86D0D3EA76D3FB6E40D29567BAC0B908110B4197A79E38C';

    @AuraEnabled
    public static String generateItem(String payload) {
        String objectName = 'ApexClass';
        String className = 'ATestMessage';
        String classBody = 'public class ATestMessage {public String SayHello() {return \'Hello\';}}';

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('Name', className);
        requestBody.put('Body', classBody);

        return createSobject(objectName, JSON.serialize(requestBody));
        // return getAllSobjects();

        // return getAccessToken();
    }

    public static String createSobject(String objectName, String payload) {
        HTTPRequest httpRequest = new HTTPRequest();
        httpRequest.setEndpoint(BASE_URL + '/services/data/v60.0/sobjects/' + objectName);
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
        httpRequest.setHeader('Accept', 'application/json');
        httpRequest.setHeader('Authorization', 'Bearer ' + getAccessToken());
        httpRequest.setBody(payload);

        Http http = new Http();
        HTTPResponse httpResponse = http.send(httpRequest);

        return httpResponse.getBody();
    }

    public static String getAllSobjects() {
        HTTPRequest httpRequest = new HTTPRequest();
        httpRequest.setEndpoint(BASE_URL + '/services/data/v60.0/sobjects/');
        httpRequest.setMethod('GET');
        httpRequest.setHeader('Authorization', 'Bearer ' + getAccessToken());

        Http http = new Http();
        HTTPResponse httpResponse = http.send(httpRequest);

        return httpResponse.getBody();
    }

    public static String getAccessToken() {
        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('grant_type', 'client_credentials');
        requestBody.put('client_id', CONNECTED_APP_CONSUMER_KEY);
        requestBody.put('client_secret', CONNECTED_APP_CONSUMER_SECRET);
        String payload = '';
        for (String key : requestBody.keySet()) {
            payload +=
                EncodingUtil.urlDecode(key, 'UTF-8') +
                '=' +
                EncodingUtil.urlDecode(requestBody.get(key), 'UTF-8') +
                '&';
        }
        payload = payload.substring(0, payload.length() - 1);

        HTTPRequest httpRequest = new HTTPRequest();
        httpRequest.setEndpoint(BASE_URL + '/services/oauth2/token');
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        httpRequest.setBody(payload);

        Http http = new Http();
        HTTPResponse httpResponse = http.send(httpRequest);

        Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(
            httpResponse.getBody()
        );
        return (String) responseBody.get('access_token');

        // return UserInfo.getSessionId();
    }
}