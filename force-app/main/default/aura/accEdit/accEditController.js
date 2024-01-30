({
	handleSaveRecord : function(cmp, event, helper) {
		cmp.find("id1").saveRecord( $A.getCallback(function(saveResult){
			 if (saveResult.state === "ERROR") {
			 	var errMsg = "";
			 	for (var i = 0; i < saveResult.error.length; i++) {
			 		 errMsg += saveResult.error[i].message + "\n";

			 	}
			 	cmp.set("v.recordSaveError", errMsg);

			 }else{
			 	cmp.set("v.recordSaveError", "");

			 }
		}

			)
		);
	},

	handleRecordUpdated: function(component, event, helper) {
		var eventParams = event.getParams();
		if(eventParams.changeType === "CHANGED") {
			var changedFields = eventParams.changedFields;
			var resultsToast = $A.get("e.force:showToast");
			resultsToast.setParams({
				"title": "Saved",
				"message": "The record was updated."

			});
			resultsToast.fire();

		}else if(eventParams.changeType === "ERROR"){
			console.log('Error: ' + component.get("v.error"));

		}

	}

})