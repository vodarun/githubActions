({
	doInit : function(component, event, helper) {
		$A.createComponent(
            "lightning:input",
            {
                "aura:id" : "inputFromdoInit",
                "label" : "Text from doInit handler....",
                "value" : " This came from do Init....",
                "disabled" : true
            },
            function(newInput, status, errorMessage){
                if(status === "SUCCESS"){
                    var body = component.get("v.body");
                    body.push(newInput);
                    component.set("v.body", body);
                    console.log(body);
                }
                else if (status === "INCOMPLETE") {
                	console.log("Incomplete: " + errorMessage);
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
	},
    
    addComponent : function(component, event, helper){
        $A.createComponent(
            "lightning:input",
            {
                "aura:id" : "cmpAfterBlur",
                "label" : "-------------.",
                "value" : " This came from ------...",
                "disabled" : true
            },
            function(newInput, status, errorMessage){
                if(status === "SUCCESS"){
                    var body = component.get("v.body");
                    body.push(newInput);
                    component.set("v.body", body);
                    console.log(body);
                }
                else if (status === "INCOMPLETE") {
                	console.log("Incomplete: " + errorMessage);
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
    }
})