// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'Enter_your_name_here';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);

// method to update the Address of all related Contact when a Account change
public static void updateContactAddress(Account account) {
  // get the Contact Ids of the Account
  List<Contact> contacts = [
    SELECT Id, Name, Address, City, State, PostalCode, Country
    FROM Contact
    WHERE AccountId = :account.Id
  ];
  for (Contact contact : contacts) {
    // update the Address of the Contact
    contact.Address = account.BillingStreet;
    contact.City = account.BillingCity;
    contact.State = account.BillingState;
    contact.PostalCode = account.BillingPostalCode;
    contact.Country = account.BillingCountry;
    contact.save();
  }
}
