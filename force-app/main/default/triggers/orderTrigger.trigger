/**
 * @name orderTrigger
 * @description
**/
trigger orderTrigger On Order (after update) {
                            
    try {
        if ( trigger.New != null ){
            OrderHelper.AfterUpdate(trigger.new, trigger.old);            
        }
    }catch ( Exception e ){
    
    }
}