import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import REVENUE_FIELD from '@salesforce/schema/Account.AnnualRevenue';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import First_Name__c from '@salesforce/schema/Account.First_Name__c';
import Last_Name__c from '@salesforce/schema/Account.Last_Name__c';
export default class AccountCreator extends LightningElement {
  objectApiName = ACCOUNT_OBJECT;
  fields = [First_Name__c, Last_Name__c, NAME_FIELD, REVENUE_FIELD, INDUSTRY_FIELD];
  handleSuccess(event) {
    const toastEvent = new ShowToastEvent({
      title: 'Account created',
      message: 'Record ID: ' + event.detail.id,
      variant: 'success'
    });
    this.dispatchEvent(toastEvent);
  }
}
