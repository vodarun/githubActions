({
	handleClick : function(component, event, helper) {
        var action = component.get("c.saveAccount");
        action.setParams({
            "s": component.get("v.sampleText")           
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                 $A.get('e.force:refreshView').fire();
                window.location.reload();
            } else if(response.getState() === "ERROR"){
                toastEvent.setParams({
                    "type": "error",
                    "title": "Server Error",
                    "message": "Error in fetching the data from server."
                });
            }
        });
        $A.enqueueAction(action);
	}
})