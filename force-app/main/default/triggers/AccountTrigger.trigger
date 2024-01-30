trigger AccountTrigger on Account ( before insert ) {
    if(trigger.isBefore && trigger.isInsert){
        for(Account a : trigger.new ){
            a.name = 'TRIGGER NAME FROM BEFORE INSERT';
        }
    }
}