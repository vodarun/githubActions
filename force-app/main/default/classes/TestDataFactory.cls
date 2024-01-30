/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup myGroup = new CollaborationGroup();
        myGroup.Name='TEST'+ Constants.INVENTORY_ANNOUNCEMENTS;
        myGroup.CollaborationType='Public'; //can be 'Public' or 'Private'                   
        return myGroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Product2> prdLst = new List<Product2>();

        for(Integer i=0; i<cnt; i++){
            Product2  p = new Product2();
            p.Name = 'TEST PRODUCT' + i;
            if(i > 3){
              p.Family = Constants.PRODUCT_FAMILY[0].getValue();
            }else{
                 p.Family = Constants.PRODUCT_FAMILY[i].getValue();
            }
            p.Initial_Inventory__c=10;
            p.IsActive=true;
            prdLst.add(p);
        }
        return prdLst;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PriceBookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PriceBookEntry> pbeLst = new List<PriceBookEntry>();
        for(Product2 p : prods){
           PriceBookEntry pbe = new PriceBookEntry();
           pbe.Product2Id= p.Id;
           pbe.UnitPrice = 2;
           pbe.IsActive = true;
           pbe.Pricebook2Id =Constants.STANDARD_PRICEBOOK_ID;
           pbeLst.add(pbe);
        }
        return pbeLst;      
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> accLst = new List<Account>();
        for(Integer i=0; i<cnt; i++){
            Account a = new Account();
            a.name = 'TEST Account' +i;
            accLst.add(a);
        }
        return accLst;     
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> conLst = new List<Contact>();
        for(Integer i=0; i<cnt; i++){
            contact con = new contact();
            con.LastName = 'Contact'+i;
            con.AccountId = accts.get(i).id;
            conLst.add(con);
        }
        return conLst;     
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> ordrLst = new List<Order>();
        for(Integer i=0; i<cnt; i++){
            Order ord = new Order();
            ord.EffectiveDate = System.Today();
            ord.PriceBook2Id = Constants.STANDARD_PRICEBOOK_ID;
            ord.AccountId = accts[i].Id;
            ord.Status = Constants.DRAFT_ORDER_STATUS;
            ordrLst.add(ord);
        }
        return ordrLst;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> orderitemsLst = new List<OrderItem>();
        for(Integer i=0; i<cnt; i++){
            OrderItem oi = new OrderItem();
            oi.Quantity = Constants.DEFAULT_ROWS;
            oi.OrderId = ords[i].Id;
            oi.PricebookEntryId = Pbes[i].Id;
            oi.UnitPrice = 30;
            orderitemsLst.add(oi);
        }
        return orderitemsLst;
    }
    
    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
     try{
            CollaborationGroup colG=ConstructCollaborationGroup();
            insert colG;
            
           List<Account> a=ConstructAccounts(cnt);
            insert a;
            
           List<Contact> c=ConstructContacts(cnt, a);
            insert c;
            
           List<Product2> p= ConstructProducts(cnt);
            insert p;
            
            List<PriceBookEntry> pbe=ConstructPricebookEntries(p);
            insert pbe;
           
            List<Order> o=ConstructOrders(cnt, a);
            insert o;
                  
           List<OrderItem> oi=ConstructOrderItems(cnt, pbe, o);
            insert oi;
        }catch(Exception e){
            System.debug('Excepiton: ' +e.getMessage() + ' at Line ' +e.getLineNumber());
        }
       
    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered){
        System.assertEquals(originalProduct.Quantity_Ordered__c + qtyOrdered , updatedProduct.Quantity_Ordered__c,'Qunatity not matching.' );
    }


}