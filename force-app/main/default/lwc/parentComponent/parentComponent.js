import { LightningElement,api } from 'lwc';


export default class ParentComponent extends LightningElement {
    @api recordId;
    urlparam = window.location.href;

    constructor(){
        super();
        console.log(` > Parent constructor.`);
    }

    connectedCallback(){
        console.log(` > Parent connectedCallback.`);   
    }

    renderedCallback(){
        console.log(` > Parent renderedCallback.`); 
    }

    disconnectedCallback(){
        console.log(` > Parent disconnectedCallback.`); 
    }

    errorCallback(){
        console.log(` > Parent errorCallback.`); 
    }
}