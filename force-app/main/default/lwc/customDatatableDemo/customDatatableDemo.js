/* eslint-disable no-console */
import { LightningElement, track, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
//import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import ACCOUNT_SOURCE from '@salesforce/schema/Account.AccountSource';

export default class CustomDatatableDemo extends LightningElement {
    @track picklistValues;
    @wire(getPicklistValues, { recordTypeId: '012f4000000uAqnAAE', fieldApiName: ACCOUNT_SOURCE })
    wiredPickListValue({data,error}){
        if(data){
            console.log(`Picklist values are `, data.values);

            this.picklistValues = data.values;
            console.log(`Picklist values are `, this.picklistValues)
            this.error = undefined;
        }
        if(error){
            console.log(`Error: ${error}`);
            this.picklistValues = undefined;
        }
    }

    @track data = [];

    connectedCallback() {
        this.columns = [
            { label: 'Record Id', fieldName: 'Id' },
            { label: 'Name', fieldName: 'Name' },
            {
                label: 'Rating', fieldName: 'AccountSource', type: 'picklist', 
                typeAttributes: { 
                    options: this.picklistValues,
                    value: { fieldName: 'Rating' } // default value for picklist
                    , context: { fieldName: 'Id' } // binding account Id with context variable to be returned back
                }
            }
        ];

        //sample data
        this.data = [{ 'Id': '001f400000OTdGkAAL', 'Name': 'Acme',  'AccountSource': 'Purchased List' }
        ]
    }

    //listener handler to get the context and data
    //updates datatable
    picklistChanged(event) {
        event.stopPropagation();
        let dataRecieved = event.detail.data;
        this.data.forEach(element => {
            if (element.Id === dataRecieved.context) {
                element.Rating = dataRecieved.value;
            }
        });
    }
}