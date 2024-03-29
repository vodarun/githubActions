public with sharing class AccountTriggerHandler { 

    public static void handleTrigger(Map<Id,Account> workingRecords, Map<Id,Account> oldRecords, System.TriggerOperation triggerEvent ) {
    
        switch on triggerEvent {
        
            when AFTER_INSERT, AFTER_UPDATE {
                //create related records
            }
            when BEFORE_INSERT {
                //set value on record create
            }
            when AFTER_DELETE {
                //prevent deletion of sensitive data
            }
            when else {
                //do nothing for AFTER_UNDELETE, BEFORE_DELETE, or BEFORE_UPDATE
            }
        }
    }
}