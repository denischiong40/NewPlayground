public with sharing class AccountHandler {
  //method insertAccount nclude a parameter for the number of new accounts to be created
  /**
 * Add a public static method to the class:
Name: insertAccount
Include a parameter for the number of new accounts:
Data type: Integer
Create a list of Account records:
List name: addAccounts
Use a while loop to add N new Accounts to the list, where N is a value that is incremented by 1 during each iteration of the loop:
Name: Acme Inc N
AccountNumber: A000n
 */
  //method insertAccount nclude a parameter for the number of new accounts to be created
  public static void insertAccount(Integer numAccounts) {
    List<Account> addAccounts = new List<Account>();
    Integer n = 1;
    while (n <= numAccounts) {
      Account acmeIncN = new Account(Name = 'Acme Inc ' + n, AccountNumber = 'A000' + n);
      addAccounts.add(acmeIncN);
      n++;
    }
  }
  //method insertAccount nclude a parameter for the number of new accounts to be created
}
