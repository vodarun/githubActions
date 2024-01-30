({
	// Your renderer method overrides go here
    render : function(component, helper){
        let ret = this.superRender();
        console.log(ret);
        $A.createComponent(
            "lightning:input",
            {
                "aura:id" : "inputFromRender",
                "label" : "Text from Render",
                "value" : component.get("v.attribute1") + " This came from render"
            },
            function(newInput, status, errorMessage){
                if(status === "SUCCESS"){
                    var body = component.get("v.body");
                    body.push(newInput);
                    component.set("v.body", body);
                }
                else if (status === "INCOMPLETE") {
                	console.log("Incomplete: " + errorMessage);
                }
                else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
        return ret;
    },
    
    rerender :function(component, helper){
        console.log("** In Rerenderer **"); 

        //
    }
})