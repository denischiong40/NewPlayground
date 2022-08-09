public with sharing class AccountSearch {
  @AuraEnabled(cacheable=true)
  public static list<Account> getAccountList(string searchKey) {
    string searchKeyword = '%' + searchKey + '%';

    // create Account list to store search result
    list<Account> accountListRecord = new List<Account>();

    // query Account records
    for (Account accObj : [SELECT Id, Name, Phone FROM Account WHERE Name LIKE :searchKeyword]) {
      accountListRecord.add(accObj);
    }

    if (accountListRecord.size() == 0) {
      throw new AuraHandledException('No Record Found..');
    }

    return accountListRecord;
  }

  @AuraEnabled(cacheable=true)
  public static list<Account> getAccountListFirst100() {
    // create Account list to store search result
    list<Account> accountListRecord = new List<Account>();

    // query Account records
    for (Account accObj : [SELECT Id, Name, Phone FROM Account LIMIT 100]) {
      accountListRecord.add(accObj);
    }

    if (accountListRecord.size() == 0) {
      throw new AuraHandledException('No Record Found..');
    }

    return accountListRecord;
  }

  //method getRelatedContacts from AccountId
  @AuraEnabled(cacheable=true)
  public static list<Contact> getRelatedContacts(string accountId) {
    // create Contact list to store search result
    list<Contact> contactListRecord = [
      SELECT Id, FirstName, LastName, Name, Phone, Email
      FROM Contact
      WHERE AccountId = :accountId
    ];

    if (contactListRecord.size() == 0) {
      throw new AuraHandledException('No Record Found..');
    }

    return contactListRecord;
  }

  //Method delete Account
  @AuraEnabled
  public static void deleteAccount(string accountId) {
    // query Account records
    List<Account> accountListRecord = [SELECT Id, Name, Phone FROM Account WHERE Id = :accountId];
    Database.delete(accountListRecord);
  }
}
