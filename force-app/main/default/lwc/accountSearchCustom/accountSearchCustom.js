import getAccountList from '@salesforce/apex/AccountSearch.getAccountList';
import getAccountListFirst100 from '@salesforce/apex/AccountSearch.getAccountListFirst100';
import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import deleteAccount from '@salesforce/apex/AccountSearch.deleteAccount';
import getRelatedContacts from '@salesforce/apex/AccountSearch.getRelatedContacts';
const actions = [
  { label: 'Show Contacts', name: 'show_contacts' },
  { label: 'Delete', name: 'delete' }
];
const columns = [
  { label: 'Name', fieldName: 'Name' },
  { label: 'Phone', fieldName: 'Phone', type: 'phone' },
  {
    type: 'action',
    typeAttributes: { rowActions: actions }
  }
];

const contactsColumns = [
  { label: 'Name', fieldName: 'Name' },
  { label: 'Phone', fieldName: 'Phone', type: 'phone' },
  { label: 'Email', fieldName: 'Email' }
];

export default class AccountSearch extends LightningElement {
  data = [];
  dataContacts = [];
  columns = columns;
  contactsColumns = contactsColumns;
  @api searchTerm = '';

  // eslint-disable-next-line @lwc/lwc/no-async-await
  async connectedCallback() {
    const data = await getAccountListFirst100();
    this.data = data;
  }

  handleAccountNameChange(event) {
    this.searchTerm = event.target.value;
    // this.handleSearch();
  }

  handleRowAction(event) {
    const actionName = event.detail.action.name;
    const row = event.detail.row;
    switch (actionName) {
      case 'delete':
        this.deleteRow(row);
        break;
      case 'show_contacts':
        this.showRowcontacts(row);
        break;
      default:
    }
  }

  showRowcontacts(row) {
    getRelatedContacts({ accountId: row.Id })
      .then((result) => {
        this.dataContacts = result;
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Error getting related contacts',
            message: error.body.message,
            variant: 'error'
          })
        );
      });
  }

  deleteRow(row) {
    deleteAccount({ accountId: row.Id })
      .then(() => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Success',
            message: 'Account deleted',
            variant: 'success'
          })
        );
        this.data = this.data.filter((item) => item.Id !== row.Id);
      })
      .catch((error) => {
        this.dispatchEvent(
          new ShowToastEvent({
            title: 'Error deleting record',
            message: error.body.message,
            variant: 'error'
          })
        );
      });
  }

  handleSearch() {
    if (this.searchTerm !== '') {
      getAccountList({
        searchKey: this.searchTerm
      })
        .then((result) => {
          this.data = result;
        })
        .catch((error) => {
          const event = new ShowToastEvent({
            title: 'Error',
            variant: 'error',
            message: error.body.message
          });
          this.dispatchEvent(event);
          // reset contacts var with null
          this.data = null;
        });
    } else {
      const data = getAccountListFirst100();
      this.data = data;
    }
  }
}
