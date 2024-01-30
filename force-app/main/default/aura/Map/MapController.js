({
    jsLoaded: function(component) {
        component.set("v.jsLoaded", true);
    },

    onPlotMapMarker: function(component, event, helper) {

    	console.log("IN MAP COMPONENT CONTROLLER");

        var id = event.getParam('sObjectId');
        var latitude = event.getParam('lat');
        var longitude = event.getParam('long');
        var label = event.getParam('label');
        //component.set("v.location", {'latitude' : latitude, 'longitude' : longitude});
        component.set('v.location', {
            'lat' : latitude, 
            'long' : longitude
        });
        
        console.log('latitude !!',latitude);
        
        
    }
})