@isTest
public class SeasonalAdrsTriggerHandler_Test {
	private static List<Account> accLst;
    private static List<Contact> conLst;
    Private Static List<Addresses__c> addrslst;
    
    @testSetup
    static void testDataSetup(){
       // Accounts
       accLst = new List<Account>();
       for(Integer i=1; i<5; i++){
            Account acc = new Account();
            acc.Name = 'Test Account ' + i;
            accLst.add(acc);            
        }
        insert accLst;
       
        // Contacts
        conLst = new List<Contact>(); 
        for(Integer i=1; i<5; i++){
           Contact con = new Contact();
           con.AccountID = accLst[i-1].ID;
           con.LastName = 'LastName ' + i;
           con.FirstName = 'FirstName ' + i;
           conLst.add(con);
        }
        insert conLst;
        
        //Addresses
        addrslst = new List<Addresses__c>();
        for(Integer i=1; i<5; i++){
          Addresses__c addrs = new Addresses__c();
          addrs.Household__c = accLst[i-1].ID;
          addrs.country__c = 'USA';
          addrs.Start_Date__c =  Date.today();
          addrs.End_Date__c = Date.today() + 7;  
          addrslst.add(addrs);
        }
        insert addrslst;
    }
    
    static void querySetupData(){
       accLst = [SELECT ID, Name, ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode FROM Account]; 
       conLst = [SELECT ID, Name, AccountId, MailingStreet, MailingCity, MailingState, MailingPostalCode  FROM Contact]; 
       addrslst = [SELECT ID, Household__c, Start_Date__c,End_Date__c, Override__c, ValidAddress__c, Street__c, City__c, State__c, Zip_Code__c 
                   FROM Addresses__c ]; 
            		
    }
    
    // Validations Test
    // Inserting an address with country != USA should thorw and error
    @isTest
    static void validationsTest1() {     	
    	Addresses__c addrs = new Addresses__c();
        addrs.country__c = 'CANADA';
        addrs.Start_Date__c =  Date.today();
        addrs.End_Date__c = Date.today() + 7;
        Test.startTest();
        try{
            insert addrs;
        }catch (Exception ex){
            System.assertEquals(true, ex.getMessage().contains('*** Addresses cannot be outside USA ***'));
        }
        Test.stopTest();        
    }
    
    // Inserting an address with overlapping dateshould thorw and error
    @isTest
    static void validationsTest2() {  
        querySetupData();
        Test.startTest();
        Addresses__c addrs2 = new Addresses__c();
        addrs2.Household__c = accLst[0].Id;
        addrs2.country__c = 'USA';
        addrs2.Start_Date__c =  Date.today();
        addrs2.End_Date__c = Date.today() + 7;         
        
        System.debug([SELECT ID, NAME, Start_Date__c,End_Date__c,Household__c  FROM Addresses__c WHERE Household__c = :accLst[0].Id ]);
        try{
            insert addrs2;
        }catch (Exception ex){
            System.assertEquals(true, ex.getMessage().contains('*** There is duplicate address'));
        }
        Test.stopTest();        
    }
	
    //Inserting a valid address should copy it to Account and Contact
    @isTest
    static void batchJobTest1() {  
        querySetupData();
        delete addrslst; // delete existing addresses and create a new one
    	Addresses__c addrs = new Addresses__c();
        addrs.Household__c = accLst[0].Id;
        addrs.Street__c = '123 Test Street';
        addrs.State__c = 'Virginia';
        addrs.City__c = 'Herndon';
        addrs.Zip_Code__c = '12345';
        addrs.country__c = 'USA';
        addrs.Start_Date__c =  Date.today() ;
        addrs.End_Date__c = Date.today() + 60;
        insert addrs;
        
        Test.startTest();
        Id batchJobId = Database.executeBatch(new UpdateAccountAddresses());
        Test.stopTest();
        querySetupData();
        System.debug('**accLst**' + accLst);
        System.debug('**addrsLst**' + addrslst);
        System.assertEquals(addrs.Street__c,accLst[0].ShippingStreet);
        System.assertEquals(addrs.City__c,accLst[0].ShippingCity);
        System.assertEquals(addrs.State__c,accLst[0].ShippingState);
        System.assertEquals(addrs.Zip_Code__c,accLst[0].ShippingPostalCode);
        // check contacts addrs
        System.assertEquals(addrs.Street__c,conLst[0].MailingStreet);
        System.assertEquals(addrs.City__c,conLst[0].MailingCity);
		//Batch job logic should mark the address.valid == true when in season 
		System.assertEquals(true,addrslst[0].ValidAddress__c);    
    }
}