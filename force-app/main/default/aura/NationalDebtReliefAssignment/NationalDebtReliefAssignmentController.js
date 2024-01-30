({
	doInit : function(component, event, helper) {
		// cerate columns
		component.set("v.columns", [
            {
				label: 'Owner Name', fieldName: 'ownerName', type: 'text',sortable: true
			},
            {
				label: 'Total Leads', fieldName: 'leadCount', type: 'number',sortable: true
			},
            {
				label: 'Total Opps.', fieldName: 'totalOpps', type: 'number',sortable: true
			},
            {
				label: 'conv Rate', fieldName: 'conversionRate', type: 'percent',sortable: true
			},
            {
				label: 'Max Created Date(Opp)', fieldName: 'maxCreatedDate', type: 'date-local',sortable: true, 
                typeAttributes:{
                    month: "2-digit",
                    day: "2-digit"
        		}
			},           
            {
                label: 'Total Val(Opp)', fieldName: 'totalValue', type: 'currency',sortable: true
			},
        ]			
		);
	},	
    
    getData : function(component, event, helper) {
		// get the dates entered if not throw validation error
		let validationMsg = '';
		let createdDate = component.find("leadCreatedDate").get("v.value");
		let closedDate = component.find("oppClosedDate").get("v.value");
        let date1 = new Date(component.get("v.createdDate"));
        let date2 = new Date(component.get("v.closedDate"));
        // time difference
        let timeDiff = Math.abs(date1.getTime() - date2.getTime());
        // days difference
        let diffDays = Math.ceil(timeDiff / (1000 * 3600 * 24));
         // validations   
		if(!(createdDate || closedDate)){
            validationMsg = "Please enter the dates.";
		}else if( !validationMsg && date1 > date2){
            validationMsg = "Start Date must be less than End date.";
        }else if(!validationMsg && diffDays > 31 ){
            validationMsg = "End Date must not be more than 31 days from Start Date.";
        } 
		// call the server and get data if no error
        if(validationMsg){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
            "type": "error",
            "title": "Validation Error",
            "message": validationMsg
            });
            toastEvent.fire();
        }else{
			var action = component.get("c.fetchTableData");
			action.setParams({
				"leadCreatedDate": createdDate ,
				"oppCLosedDate": closedDate
			});
			action.setCallback(this,function(response){
				if(response.getState() === "SUCCESS"){
					component.set("v.data",response.getReturnValue());
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
	},
            
	updateColumnSorting: function (component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
            
	waiting: function(component, event, helper) {
    	document.getElementById("Accspinner").style.display = "block";
 	},
            
   	doneWaiting: function(component, event, helper) {
   		document.getElementById("Accspinner").style.display = "none";
 	}
})