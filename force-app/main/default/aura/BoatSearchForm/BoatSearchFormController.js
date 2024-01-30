({
	
	doinit: function(component, event, helper){

		// set show new button to true 
		var createRecordEvent = $A.get('e.force:createRecord');
		if (createRecordEvent) {
        		component.set("v.showNewButton", true);
    	}
		
		var action = component.get("c.getBoatTypes");
		
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === "SUCCESS") {
				var boatMapWithId = new Map();

                component.set("v.typesOfBoats", response.getReturnValue());
                
                for( var j in component.get("v.typesOfBoats")){                	             
                	boatMapWithId.set(component.get("v.typesOfBoats")[j].Name, component.get("v.typesOfBoats")[j].Id );            
                	//console.log('$$$$$'+boatMapWithId.get('Sailboat'));
                }
                component.set("v.boatTypeMap",boatMapWithId); 
            }else{
            	console.log("Failed with State: "+ state);
            }	
           // console.log("@#@#"+component.get("v.boatTypeMap").get("Sailboat"));		
		});

		$A.enqueueAction(action, true);
	},

	createRecord: function(component, event, helper){
		var createRecordEvent = $A.get("e.force:createRecord");
		var selectedBoatType = component.get("v.selectedBoat");
		var boatTypeId = component.get("v.boatTypeMap").get("Sailboat");
		//console.log('^^^^'+selectedBoatType);

		createRecordEvent.setParams({
		 	"entityApiName": "Boat__c",
		 	"defaultFieldValues":{
		 		"BoatType__c": component.get("v.boatTypeMap").get(selectedBoatType)
		 	}
		});
		createRecordEvent.fire();
	},

	updateBoatTypeSelection: function(component, event, helper){
		var typeName = component.find('boatSelectionId').get('v.value');
		component.set("v.selectedBoat", typeName); 
	},

	onFormSubmit : function(component, event, helper){
		var selectedBoatType = component.get("v.selectedBoat");
		var boatTypeId = component.get("v.boatTypeMap").get(selectedBoatType);
		console.log('#$#$#'+boatTypeId);

		var formSubmit2 = component.getEvent("formSubmit");
		console.log('%%%%%%%%%%: '+formSubmit2);
        formSubmit2.setParams({"formData":
                              {"boatTypeId" : boatTypeId}
                             });

		//formSubmit2.setParams({"boatTypeId" : boatTypeId});                       
        

        formSubmit2.fire();
	}
})