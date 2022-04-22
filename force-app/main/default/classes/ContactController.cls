public with sharing class ContactController {
  @AuraEnabled(cacheable=true)
  public static List<Contact> getContacts() {
    return [SELECT FirstName, LastName, Email FROM Contact WITH SECURITY_ENFORCED ORDER BY Name];
  }

  @AuraEnabled(cacheable=true)
  public static void getContactsException() {
    throw new AuraHandledException('Testing error');
  }
}