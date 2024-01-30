({
	clickCreateItem  : function(component, event, helper) {
		var allValid = component.find("campaignform").reduce(function(validSoFar, inputCmp){
			inputCmp.showHelpMessageIfInvalid();
			return validSoFar && inputCmp.get("v.validity").valid;
		},true);
		var itemsList = component.get("v.newItem");
			console.log("ItemsList "+ itemsList);
		if(allValid){

			helper.createItem(component,component.get("v.newItem"));

			/*var itemsList = component.get("v.items");
			console.log("ItemsList before adding "+ itemsList);

			var itemToAdd = component.get("v.newItem");
			console.log("Item to add "+ itemToAdd.Name);

			console.log("JSON "+ JSON.stringify(itemToAdd));
			console.log("PARSED JSON "+ JSON.parse(JSON.stringify(itemToAdd)));

			itemsList.push(JSON.parse(JSON.stringify(itemToAdd)));

			//set list
			component.set("v.items",itemsList);

			console.log("List So Far"+itemsList[0].Name);

			var newItemObj = {'sobjectType': 'Camping_Item__c','Quantity__c':0,'Price__c':0, };

			// set the record to hold blank after adding to list
			component.set("v.newItem",newItemObj);*/
		} else{
			/*alert('PLease update the invalid fields.');*/
		}
	},

	doInit : function(component, evenet, helper){

		var action = component.get("c.getItems");

		action.setCallback(this, function(response){
		 	var state = response.getState();
		 	if(state === 'SUCCESS'){
		 		component.set("v.items", response.getReturnValue());
		 	}else{
		 		console.log("Failed with state: " + state);
		 	}
		});

		 $A.enqueueAction(action);
		},

		handleAdditem : function(component, event, helper){
			var action = component.get("c.saveItem");
    		action.setParams({"item": newItem});
    		action.setCallback(this, function(response){
        		var state = response.getState();
        		if (component.isValid() && state === "SUCCESS") {
            		// all good, nothing to do.
        		}
    		});
    		$A.enqueueAction(action);
    		helper.createCampings(component, event.getParam("item"));
		}


})