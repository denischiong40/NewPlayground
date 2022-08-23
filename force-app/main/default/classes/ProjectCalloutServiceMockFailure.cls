@IsTest
public class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
  public HttpResponse respond(HttpRequest req) {
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody('{"example":"fail"}');
    res.setStatusCode(500);
    res.setStatus('Failure');
    return res;
  }
}
