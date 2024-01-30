({
    doInit : function(component, event, helper) {
        console.log(" In NESTED Component..........");
        $A.createComponent(
        	"lightning:input",
            {
                "aura:id" : "nestedInput",
                "label" : "Text from nestedInput handler....",
                "value" : " This came from nestedInput do Init....",
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