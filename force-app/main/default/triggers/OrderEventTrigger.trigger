trigger OrderEventTrigger on Order_Event__e (after insert) {
    List<Task> taskLst = new List<Task>();
    for(Order_Event__e oe : trigger.new){
        if(oe.Has_Shipped__c == true){
            Task t = new Task();
            t.Subject = 'Follow up on shipped order ' + oe.Order_Number__c;
            t.Priority = 'Medium';
            t.OwnerId = oe.CreatedById;
            tasklst.add(t);
        }       
    }
    
    insert tasklst;
}