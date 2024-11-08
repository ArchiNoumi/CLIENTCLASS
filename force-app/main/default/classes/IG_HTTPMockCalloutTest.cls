@IsTest
global class IG_HTTPMockCalloutTest implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse res = new HttpResponse();

        if (req.getEndpoint().contains('/services/oauth2/token')) {
            res.setStatusCode(200);
            res.setBody('{"access_token":"fake_access_token"}');
        }

        if (req.getEndpoint().contains('/service/data/v60.0/sobject/')) {
            res.setStatusCode(200);
            res.setBody('{}');
        }

        if (req.getEndpoint().contains('/service/data/v60.0/sobject/ApexClass')) {
            res.setStatusCode(200);
            res.setBody('{"key":"value"}');
        }

        return res;
    }
}