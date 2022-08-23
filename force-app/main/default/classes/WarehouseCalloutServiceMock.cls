public class WarehouseCalloutServiceMock implements HttpCalloutMock {
  private String responseJson =
    '[' +
    '{"_id":"55d66226726b611100aaf741","replacement":false,"quantity":5,"name":"BMW","maintenanceperiod":365,"lifespan":120,"cost":5000,"sku":"132"},' +
    '{"_id":"55d66226726b611100aaf742","replacement":true,"quantity":183,"name":"LAda","maintenanceperiod":0,"lifespan":0,"cost":300,"sku":"99"}' +
    ']';

  // Implement this interface method
  public HTTPResponse respond(HTTPRequest request) {
    // Create a fake response
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setBody(responseJson);
    response.setStatusCode(200);
    return response;
  }
}
