trigger AccountTrigger1 on Account ( before Insert ,Before Update , After Insert, After Update) {
    AccountTriggerHandler.handleTrigger(trigger.newMap,trigger.oldMap,Trigger.operationType); 
}