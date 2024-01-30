({
    onSearch : function(component) {
        var action = component.get("c.getBoats");
        console.log('@@@@@@@@@@@@@@@@@@@'+ String(component.get("v.boatTypeId")));
        action.setParams({'boatTypeId': component.get("v.boatTypeId")});
        action.setCallback(this, function(response){
        var status = response.getState();
            if(status === "SUCCESS"){
             if(! $A.util.isEmpty(response.getReturnValue())){
                console.log('&*&*&*&*'+response.getReturnValue());
                    component.set("v.boats",response.getReturnValue()); 
                } else {
                    console.log('&*&*&*&*'+response.getReturnValue());
                     component.set("v.recordError","No boats found");
                }
            }
        });
        $A.enqueueAction(action);
    }
})