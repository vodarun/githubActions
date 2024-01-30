import { LightningElement,api } from 'lwc';

export default class HelloWebComponent extends LightningElement {
    varb = 'var1';
    @api strName;
    data = [];

    get columns(){
        let cols;
        if(this.strName ==='var1'){
            cols = [
                
                { label: 'Website', fieldName: 'website', type: 'url' },
                { label: 'Phone', fieldName: 'phone', type: 'phone' },
                { label: 'Balance', fieldName: 'amount', type: 'currency' },
                { label: 'Close At', fieldName: 'closeAt', type: 'date' },
            ];
        }else if(this.strName ==='var2'){
            cols = [
                { label: 'Website', fieldName: 'website', type: 'url' },
                { label: 'Website', fieldName: 'website', type: 'url' },
                { label: 'Phone', fieldName: 'phone', type: 'phone' },
                { label: 'Balance', fieldName: 'amount', type: 'currency' },
                { label: 'Close At', fieldName: 'closeAt', type: 'date' },
            ];
        }

        return cols;
    }

}