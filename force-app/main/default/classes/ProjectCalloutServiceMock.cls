@IsTest
public class ProjectCalloutServiceMock implements HttpCalloutMock {
  public HttpResponse respond(HttpRequest req) {
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody('{"example":"success"}');
    res.setStatusCode(201);
    res.setStatus('Success');
    return res;
  }
}
