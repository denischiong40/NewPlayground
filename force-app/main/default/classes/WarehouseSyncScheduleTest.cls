@isTest
public with sharing class WarehouseSyncScheduleTest {
  @isTest
  static void test1() {
    Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

    Test.startTest();
    Id jobId = System.schedule('WarehouseSyncScheduleJobTesting', '0 0 1 * * ?', new WarehouseSyncSchedule());
    Test.stopTest();

    System.assertEquals(jobId != null, true, 'JobId different of null');
  }
}
