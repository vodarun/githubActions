public with sharing class SeasonalAdrsTriggerHandler {
    
    public class customException extends Exception{ }

	public static void handleTrigger(Map<Id,Addresses__c> workingRecords, Map<Id,Addresses__c> oldRecords, 
                                     List<Addresses__c> triggerNewRecords,	System.TriggerOperation triggerEvent ) {   
        switch on triggerEvent {        
            when AFTER_INSERT, AFTER_UPDATE {
                
            }
            when BEFORE_INSERT,BEFORE_UPDATE {
                 doValidations(triggerNewRecords);
                 doOveridelogic(triggerNewRecords);
                // doBusinessLogic(workingRecords, oldRecords);
            }
            when AFTER_DELETE {
                //prevent deletion of sensitive data
            }
            when else {
                //do nothing for AFTER_UNDELETE, BEFORE_DELETE, or BEFORE_UPDATE
            }
        }
    }
    
    // Validations
    // UAC 4. A start and end date overlap is prevented by the system
    // UAC 8. Handle addresses going out of range
    public static void doValidations(List<Addresses__c> triggerNewRecords){
        Set<ID> accIds = new Set<ID>();        
        for(Addresses__c adrs : triggerNewRecords){                 
            if(!adrs.Country__c.equalsIgnoreCase('USA')){
                throw new customException('*** Addresses cannot be outside USA ***' );
            }
            accIds.add(adrs.Household__c );
        }     
        if(accIds.isEmpty()){return;}
        Map<Id,List<Addresses__c>> existingAddrssesMap = new Map<Id,List<Addresses__c>>();// get all the addresses under the Contact        
        for(Account acc: [SELECT ID, (SELECT ID,Name,Start_Date__c, End_Date__c,Contact__c,Household__c  From Addresses__r) 
                              FROM Account WHERE ID IN : accIds]){
       		List<Addresses__c> availableAddresses = new List<Addresses__c>();
            availableAddresses.addAll(acc.Addresses__r);
            existingAddrssesMap.put(acc.ID, availableAddresses );                      
        }            
        for(Addresses__c adrs : triggerNewRecords){
            List<Addresses__c> exisitngAddrsLst = existingAddrssesMap.get(adrs.Household__c) == null ?
                									new List<Addresses__c>() :
            										existingAddrssesMap.get(adrs.Household__c);
            //exisitngAddrsLst = existingAddrssesMap.get(adrs.Household__c);
            SYSTEM.debug('*** exisitngAddrsLst ***' + exisitngAddrsLst);
            if(exisitngAddrsLst.isEmpty()){ continue; }
            for(Addresses__c exstAdrs : exisitngAddrsLst ){
                if(exstAdrs.ID != adrs.ID){
                    if(adrs.Start_Date__c >= exstAdrs.Start_Date__c && adrs.End_Date__c <= exstAdrs.End_Date__c){                    
                        throw new customException('*** There is duplicate address within the same date range under the contact with Name ' + exstAdrs.Name + ' ***');
                    }
                }                
            }
        }
    }
    
    // UAC 5. I can override a start date and end date and force an address onto Contact manually.
    public static void doOveridelogic(List<Addresses__c> triggerNewRecords){
        List<Contact> conToUpdate = new List<Contact>();
        for(Addresses__c adrs : triggerNewRecords){            
            if(adrs.Override__c && adrs.Contact__c != null){
                Contact con = new Contact();
                con.ID = adrs.Contact__c;
                con.MailingStreet = adrs.Street__c;
                con.MailingCity = adrs.City__c;
                con.MailingState = adrs.State__c;
                con.MailingPostalCode = adrs.Zip_Code__c;
                
                conToUpdate.add(con);                
            }
        }  
        
        if(!conToUpdate.isEmpty()){
            update conToUpdate;
        }
    }
	
   	/**
   	// Business logic: If the current date is in Seasonal Date Range, populate it on the account and Contact
    public static void doBusinessLogic(Map<Id,Addresses__c> workingRecords, Map<Id,Addresses__c> oldRecords){
        Set<ID> accIds = new Set<ID>();
        Map<ID,Boolean> validAddresses = new Map<ID, Boolean>();
        for(Addresses__c adrs : workingRecords.values()){
            accIds.add(adrs.Household__c );
        }
        if(accIds.isEmpty()){
            //throw exception
        }
        List<Account> accts = [SELECT ID, Name, ShippingStreet, ShippingCity, ShippingCountry, ShippingPostalCode, 
                               	(SELECT ID,Start_Date__c, End_Date__c, Street__c,State__c,City__c,Zip_Code__c   From Addresses__r) 
                               FROM Account WHERE ID IN : accIds];
        List<Account> acctToUpdate = new List<Account>();
        
        for(Account acc : accts ){            
            for(Addresses__c adrs : acc.Addresses__r){
                if(Date.today() >= adrs.Start_Date__c && Date.today() <= adrs.End_Date__c){
                    // mark the addrs as valid, and copy it to account 
                    validAddresses.put(adrs.Id, true);                    
                    acc.ShippingStreet = adrs.Street__c;
                    acc.ShippingCity = adrs.City__c;
                    acc.ShippingState = adrs.State__c;
                    acc.ShippingState = adrs.Zip_Code__c;
					acctToUpdate.add(acc);                   
                    break;// Break when a first match is found. Validation rules will restict overlapping dates, so only one match should be found ideally.
                }
            }
        }
        
        //Loop through the 
        for(Addresses__c adrs : workingRecords.values()){
            for(ID ValidAdrsId : validAddresses.keySet()){
                if(adrs.ID == ValidAdrsId ){
                    adrs.Valid__c = true; 
                }
            }
        }
        
        if(!acctToUpdate.isEmpty()){
            update acctToUpdate;
        }
    } 
	*/
}