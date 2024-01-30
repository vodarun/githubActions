global class UpdateAccountAddresses implements Database.Batchable<sObject>, Database.Stateful{
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            //' SELECT ID, Contact__c, HouseHold__c, '+ 
            //' HouseHold__r.ShippingStreet, HouseHold__r.ShippingCity, HouseHold__r.ShippingState, HouseHold__r.ShippingPostalCode,'+            
            //' Override__c, Start_Date__c, End_Date__c, Street__c, State__c,City__c, Zip_Code__c   From Addresses__c ' +
           // ' WHERE Override__c = false AND HouseHold__c != null'
            
            'SELECT ID, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode, '  +
            ' (SELECT ID, AccountId, MailingStreet, MailingCity, MailingState, MailingPostalCode FROM Contacts ), ' +
            ' (SELECT ID, Household__c, Start_Date__c,End_Date__c, Override__c, ValidAddress__c, Street__c, City__c, State__c, Zip_Code__c ' + 
            ' 	FROM Addresses__r WHERE Override__c = false ) ' +                	 
            'FROM Account  '
            //  To DO: See if we can add the filter in query 
            // ' AND Date.today() >= Start_Date__c && Date.today() <= End_Date__c ) ' 
        );
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope){
        List<Contact> conToUpdate = new List<Contact>();
        List<Account> accToUpdate = new List<Account>();
        List<Addresses__c> addressesToUpdate = new List<Addresses__c>();
        Map<ID,Addresses__c > accToAdrsMap = new Map<ID,Addresses__c>();
        SYSTEM.debug('SCOPE ***'+ scope);
        
        for(Account acc : scope){
            for(Addresses__c adrs : acc.Addresses__r ){
                if(Date.today() >= adrs.Start_Date__c && Date.today() <= adrs.End_Date__c){
                    if(!adrs.Override__c ){// DO NOT process the logic when this flag is checked
                        // check if the account address is same as seasonal address, to avoid updating with same address details
                        if(adrs.Street__c != acc.ShippingStreet || adrs.City__c != acc.ShippingCity ||
                           adrs.State__c != acc.ShippingState || adrs.Zip_Code__c != acc.ShippingPostalCode ){
                               acc.ID = adrs.Household__c;
                               acc.ShippingStreet = adrs.Street__c;
                               acc.ShippingCity = adrs.City__c;
                               acc.ShippingState = adrs.State__c;
                               acc.ShippingPostalCode = adrs.Zip_Code__c;                         
                               accToUpdate.add(acc);
                               accToAdrsMap.put(acc.ID, adrs); 
                               
                               Addresses__c addrs = new Addresses__c(ID = adrs.ID, ValidAddress__c= true );
                               addressesToUpdate.add(addrs);
                        }
                    } 
                }
                
            }
            // Now loop through contacts and see if the address needs to be copied                        
            for(Contact con : acc.Contacts){
                if(accToAdrsMap.keySet().contains(con.AccountId)){ // process the contacts only under accounts that are to be updated
                    if(con.MailingStreet != accToAdrsMap.get(con.AccountId).Street__c || con.MailingCity != accToAdrsMap.get(con.AccountId).City__c||
                       con.MailingState != accToAdrsMap.get(con.AccountId).State__c || con.MailingPostalCode != accToAdrsMap.get(con.AccountId).Zip_Code__c )
                    {
                        Contact cont = new Contact();
                        cont.ID = con.ID;
                        cont.MailingStreet = accToAdrsMap.get(con.AccountId).Street__c; 
                        cont.MailingCity = accToAdrsMap.get(con.AccountId).City__c;
                        cont.MailingState = accToAdrsMap.get(con.AccountId).State__c;
                        cont.MailingPostalCode = accToAdrsMap.get(con.AccountId).Zip_Code__c;
                        conToUpdate.add(cont);
                    }
                }
            }
            
            SYSTEM.debug('Accounts to Update *** '+ accToUpdate );
            SYSTEM.debug('Contacts to Update *** '+ conToUpdate );
            SYSTEM.debug('Addresses to Update *** '+ addressesToUpdate );
            
            if(!conToUpdate.isEmpty()){
                update conToUpdate;
            }
            if(!accToUpdate.isEmpty()){
                update accToUpdate;
            }
            if(!addressesToUpdate.isEmpty()){
                update addressesToUpdate;
            }
            
        }
    }
    
    global void finish(Database.BatchableContext bc){
        // Send Notifications
    }
}