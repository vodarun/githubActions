({
    doInit: function(component,event,helper){
        console.log("Initialized");
        console.log((2500).toLocaleString("en-US",{Style:"currency"})); 
   		var x = component.get("v.Number1"); 
        console.log("Number value X-->" + x);
               
        if(x < 0){
            component.set("v.showNumberInParenthesis",  true );
            component.set("v.Number2", "$"+ _negativeParser.getValue(x) );
            console.log("$"+component.get("v.Number2"));
        }
    },
    
	handleSaveRecord : function(component, event, helper) {
        console.log("In handleclick event" + event);
        
      console.log((2500).toLocaleString("en-US",{Style:"currency"}));  
        //var x =component.get("v.Number1");
       // if(x < 0){
         //   console.log('X-->' + x +'counter'+_counter.getValue(x)_negativeParser.getValue(x));
		//	component.set("v.Number1",  _negativeParser.getValue(x) );
        //}
        component.set("v.showNumberInParenthesis",  false );
	},
    
    
    doAction: function(component, event, helper){
        console.log("Invoked by method");
		var params = event.getParam('arguments');
        //if (params) {
          //  var param1 = params.param1;
            // add your code here
           // if(param1 < 0){
            //     component.set("v.showNumberInParenthesis",  true );
            //     component.set("v.Number2",  _negativeParser.getValue(x) );
            //} 
       // }
    }
})