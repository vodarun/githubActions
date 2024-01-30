({
	doSearch : function(component, event, helper) {
		helper.onSearch(component);
	},

	search: function(component, event, helper){
        var params = event.getParam('arguments');
        console.log("boatTypeId extracted: " + params.boatTypeId);
        component.set("v.boatTypeId", params.boatTypeId);
        helper.onSearch(component);
        return "search complete.";
    },

    onBoatSelect : function(component, event, helper) {
        var boatId = event.getParam("boatId");
        console.log(boatId);
        component.set("v.selectedBoatId",boatId);
    }
})