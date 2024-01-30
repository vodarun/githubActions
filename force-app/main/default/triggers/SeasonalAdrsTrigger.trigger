trigger SeasonalAdrsTrigger on Addresses__c (before insert,after insert, before update,after update,
                                            	before delete) {
	
	SeasonalAdrsTriggerHandler.handleTrigger(trigger.newMap,trigger.oldMap, trigger.new, Trigger.operationType);
}