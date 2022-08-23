@IsTest
private class ProjectCalloutServiceTest {
  @TestSetup
  static void setupData() {
    Account testAcct = new Account();
    testAcct.name = 'denis testing';
    testAcct.type = 'Customer - Direct';
    insert testAcct;

    Opportunity testOpp = new Opportunity();
    testOpp.name = 'Test denis Opp';
    testOpp.AccountId = testAcct.id;
    testOpp.type = 'New Project';
    testOpp.CloseDate = system.today();
    testOpp.StageName = 'Negotiation/Review';
    testOpp.Amount = 500000;
    insert testOpp;

    ServiceTokens__c tokenSetting = new ServiceTokens__c();
    tokenSetting.Name = 'Token';
    tokenSetting.Token__c = 'c5365ff0-46e8-4960-88d3-7518bf4aaa7b';
    insert tokenSetting;
  }

  @IsTest
  static void test1Positive() {
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());

    Opportunity oppUpdated = [SELECT Id, StageName FROM Opportunity][0];
    oppUpdated.StageName = 'Closed Won';
    Test.startTest();
    update oppUpdated;
    Test.stopTest();

    Opportunity updatedOpp = [SELECT Id, StageName, Type FROM Opportunity][0];
    System.assertEquals(updatedOpp.StageName, 'Submitted Project');

    List<AsyncApexJob> listJobs = [SELECT Status, NumberOfErrors FROM AsyncApexJob];
    System.assert(listJobs.size() > 0);
  }

  @IsTest
  static void test2Negative() {
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());

    Opportunity oppUpdated = [SELECT Id, StageName FROM Opportunity][0];
    oppUpdated.StageName = 'Closed Won';
    Test.startTest();
    update oppUpdated;
    Test.stopTest();

    Opportunity updatedOpp = [SELECT Id, StageName, Type FROM Opportunity][0];
    System.assertEquals(updatedOpp.StageName, 'Resubmit Project');

    List<AsyncApexJob> listJobs = [SELECT Status, NumberOfErrors FROM AsyncApexJob];
    System.assert(listJobs.size() > 0);
  }
}
