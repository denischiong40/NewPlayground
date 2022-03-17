import { LightningElement, wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Contact.FirstName';
import LastName from '@salesforce/schema/Contact.LastName';
import Email from '@salesforce/schema/Contact.Email';
import getContacts from '@salesforce/apex/ContactController.getContactsException';
import { reduceErrors } from 'c/ldsUtils';
const COLUMNS = [
  { label: 'FirstName', fieldName: NAME_FIELD.fieldApiName, type: 'text' },
  { label: 'LastName', fieldName: LastName.fieldApiName, type: 'text' },
  { label: 'Email', fieldName: Email.fieldApiName, type: 'email' }
];
export default class ContactList extends LightningElement {
  columns = COLUMNS;
  @wire(getContacts)
  contacts;
  get errors() {
    return this.contacts.error ? reduceErrors(this.contacts.error) : [];
  }
}
