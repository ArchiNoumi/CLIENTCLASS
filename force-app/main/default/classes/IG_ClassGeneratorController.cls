public with sharing class IG_ClassGeneratorController {
    public static String BASE_URL = IG_TokenGenerator.BASE_URL;

    @AuraEnabled
    public static String createApexClass(String payload) {
        String objectName = 'ApexClass';
        Map<String, Object> parsedPayload = (Map<String, Object>) JSON.deserializeUntyped(payload);

        Map<String, String> requestBody = new Map<String, String>();
        requestBody.put('name', (String) parsedPayload.get('name'));
        requestBody.put('body', (String) parsedPayload.get('body'));

        return createSobject(objectName, requestBody);
    }

    public static String createSobject(String objectName, Map<String, String> requestBody) {
        HTTPRequest httpRequest = new HTTPRequest();
        httpRequest.setEndpoint(BASE_URL + '/services/data/v60.0/sobjects/' + objectName);
        httpRequest.setMethod('POST');
        httpRequest.setHeader('Content-Type', 'application/json; charset=UTF-8');
        httpRequest.setHeader('Accept', 'application/json');
        httpRequest.setHeader('Authorization', 'Bearer ' + IG_TokenGenerator.getAccessToken());
        httpRequest.setBody(JSON.serialize(requestBody));

        Http http = new Http();
        HTTPResponse httpResponse = http.send(httpRequest);

        return httpResponse.getBody();
    }
}