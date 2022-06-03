import { LightningElement, api } from 'lwc';

export default class Clock extends LightningElement {
  timestamp = new Date();

  @api
  refresh() {
    this.timestamp = new Date();
  }
  connectedCallback() {
    this.refresh();
    setInterval(() => {
      this.refresh();
    }, 1000);
  }
}
