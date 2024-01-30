/**
 * @name product2Trigger
 * @description Trigger to notify staff of low levels of inventory
**/
trigger product2Trigger on Product2 (
    after update   
) {
    try {
        
        Product2Helper.AfterUpdate( trigger.old,trigger.new);
    } catch ( Exception e ){
        //A good developer would do something with this Exception!
    }
}