({
    init: function(component, event, helper) {
        component.set("v.enableFullDetails", $A.get("e.force:navigateToSObject"));
    },
    onFullDetails: function(component, event, helper) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": component.get("v.boat.Id")
        });
        navEvt.fire();
    },    
    onBoatSelected : function(component, event, helper) {
        var boatSelected = event.getParam("boat");
        component.set("v.id",boatSelected.Id);
        var service = component.find("service");
        service.reloadRecord() ;
    },
    onRecordUpdated : function(component, event, helper) {
    },
    
    onBoatReviewAdded : function(component, event, helper) {
		console.log('Event received');
		component.find("details").set("v.selectedTabId", "boatreviewtab");
        //invoke refresh() method
        var reviewsCmp = component.find("boatReviewsCmp");
        console.log("reviewsCmp: " + reviewsCmp);
        if(reviewsCmp) {
            reviewsCmp.refresh();
        }
	}
    
})