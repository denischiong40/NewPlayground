@IsTest
public class AccountManagerTest {
  @isTest
  static void testGetCaseById() {
    Id recordId = createTestRecord();
    // Set up a test request
    RestRequest request = new RestRequest();
    request.requestUri = 'https://yourInstance.my.salesforce.com/services/apexrest/Accounts/' + recordId + '/contacts';
    request.httpMethod = 'GET';
    RestContext.request = request;
    // Call the method to test
    Account thisAcc = AccountManager.getAccount();
    // Verify results
    System.assert(thisAcc != null);
    System.assertEquals('Test account record', thisAcc.Name);
  }

  // Helper method
  static Id createTestRecord() {
    // Create test record
    Account acctest = new Account(Name = 'Test account record');
    insert acctest;
    Contact contactTest = new Contact(Lastname = 'Test contact record');
    contactTest.AccountId = acctest.Id;
    insert contactTest;
    return acctest.Id;
  }
}
