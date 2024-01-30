({
	
    onBoatClick : function(component, event, helper) {
        console.log('onBoatClick___________');


        var cmpEvent = component.getEvent("BoatSelect");
        var boat = component.get("v.boat");

        cmpEvent.setParams({
            "boatId" : boat.Id
        });
        cmpEvent.fire();



        var appEvent = $A.get("e.c:BoatSelected");          
        appEvent.setParams({
            "boat": component.get("v.boat")
        });
        appEvent.fire();  

        var latitude = boat.Geolocation__Latitude__s;
        var longitude = boat.Geolocation__Longitude__s;
        var label = boat.Name;

        console.log(boat.Geolocation__Latitude__s);
        var createEvent = $A.get("e.c:PlotMapMarker");

        createEvent.setParams({
            "sObjectId" : boat.id,
            "lat" : latitude,
            "long" : longitude,
            "label" : label,
        });
        createEvent.fire();

    }
	
})