({
	packItem : function(component,event,helper) {
        var i = component.get("v.item",true);
		i.Packed__c = true;
	 	component.set("v.item",i);
		var btn = event.getSource();
		btn.set("v.disabled",true);
	}
})