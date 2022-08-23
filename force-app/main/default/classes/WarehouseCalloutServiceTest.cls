@isTest
private class WarehouseCalloutServiceTest {
  @isTest
  static void test1() {
    Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

    Test.startTest();
    System.enqueueJob(new WarehouseCalloutService());
    Test.stopTest();

    System.assertEquals(2, [SELECT COUNT() FROM Product2]);
  }
}
