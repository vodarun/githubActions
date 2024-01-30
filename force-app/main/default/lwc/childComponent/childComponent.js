import { LightningElement,api } from 'lwc';

export default class ChildComponent extends LightningElement {
    @api recordId;
    urlparam = window.location.href.searchParams;

    constructor(){
        super();
        console.log(` >> Child constructor.`);
    }

    connectedCallback(){
        console.log(` >> Child connectedCallback.`);   
    }

    renderedCallback(){
        console.log(` >> Child renderedCallback.`); 
    }

    disconnectedCallback(){
        console.log(` >> Child disconnectedCallback.`); 
    }

    errorCallback(){
        console.log(` >> Child errorCallback.`); 
    }
}