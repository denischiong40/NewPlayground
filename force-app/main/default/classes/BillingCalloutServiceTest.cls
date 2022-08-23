@isTest
private class BillingCalloutServiceTest {
  @TestSetup
  public static void prepareData() {
    Account testAcct = new Account();
    testAcct.name = 'Test denis Account';
    testAcct.type = 'Customer - Direct';
    insert testAcct;

    Opportunity testOpp = new Opportunity();
    testOpp.name = 'Test denis Opportunity';
    testOpp.AccountId = testAcct.id;
    testOpp.type = 'New Project';
    testOpp.CloseDate = system.today();
    testOpp.StageName = 'Negotiation/Review';
    testOpp.Amount = 500000;
    insert testOpp;

    Project__c projNew = new Project__c();
    projNew.Status__c = 'Running';
    projNew.Opportunity__c = testOpp.Id;
    insert projNew;

    //Fill custom setting for the SOAP callout
    ServiceCredentials__c cred = new ServiceCredentials__c();
    cred.Name = 'BillingServiceCredential';
    cred.Username__c = 'bsUser1';
    cred.Password__c = 'bsPass1';
    insert cred;
  }

  @IsTest
  public static void callBillingServiceTest() {
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());
    Project__c projUpdated = [SELECT Id, Status__c FROM Project__c LIMIT 1];
    projUpdated.Status__c = 'Billable';

    Test.startTest();
    update projUpdated;
    Test.stopTest();

    projUpdated = [SELECT Id, Status__c FROM Project__c LIMIT 1];
    System.assert(projUpdated.Status__c == 'Billed');
  }

  @IsTest
  public static void callBillingServiceNegativeTest() {
    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMockFailure());
    Project__c projUpdated = [SELECT Id, Status__c FROM Project__c LIMIT 1];
    projUpdated.Status__c = 'Billable';

    Test.startTest();
    update projUpdated;
    Test.stopTest();

    projUpdated = [SELECT Id, Status__c FROM Project__c LIMIT 1];
    System.assert(projUpdated.Status__c != 'Billed');
  }
}
