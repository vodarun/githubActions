@isTest 
private class OrderTests {
    @testSetup
    public static void SetupTestData(){
        TestDataFactory.insertTestData(10);
    }
    
    public static testMethod void OrderUpdate_UnitTest(){
        List<Order> orderList = new List<Order>();
        orderList = [Select Id, Name, Status From Order Limit 1000];
        List<Product2> originalProduct = [Select Id, Name, Initial_Inventory__c, Quantity_Ordered__c From Product2 Limit 1000];
        System.debug('#### orderList  '+orderList );
        for(Order ord : orderList){
            ord.Status = Constants.ACTIVATED_ORDER_STATUS;
        }
        update orderList;
        List<Product2> updatedProduct = [Select Id, Name, Initial_Inventory__c, Quantity_Ordered__c From Product2 Limit 1000];
        for(Integer I =0; I < originalProduct.size(); I++ ){
            TestDataFactory.VerifyQuantityOrdered(originalProduct[i], updatedProduct[i], Constants.DEFAULT_ROWS);
        }
    }
    public static testMethod void OrderExtension_UnitTest(){
        Account testAccount = new Account();
        testAccount.Name = 'test';
        insert testAccount;
        
        List<Schema.PicklistEntry> familyEntries = Constants.PRODUCT_FAMILY;
        Integer familySize = familyEntries.size();
        
         List<Account> ConstructAccounts = TestDataFactory.constructAccounts(Constants.DEFAULT_ROWS);
        insert ConstructAccounts;
        // Insert Order
        List<Order> ConstructOrders = TestDataFactory.constructOrders(Constants.DEFAULT_ROWS, ConstructAccounts);
        insert ConstructOrders;
        
        List<Product2> productList = new List<product2>();
        // Insert Product 
        List<Product2> productsList = TestDataFactory.constructProducts(Constants.DEFAULT_ROWS);
        insert productsList;
        
        List<PricebookEntry> ConstructPricebookEntries = TestDataFactory.constructPricebookEntries(productsList);
        insert ConstructPricebookEntries;
        
        List<OrderItem> ConstructOrderItems = TestDataFactory.constructOrderItems(Constants.DEFAULT_ROWS, ConstructPricebookEntries, ConstructOrders);
        insert ConstructOrderItems;

        orderExtension ext = new orderExtension(new apexPages.standardController(ConstructOrders[0]));
        ext.orderRecord.AccountId = testAccount.Id;
        ext.orderRecord.EffectiveDate = system.today();
        ext.orderRecord.Status = constants.DRAFT_ORDER_STATUS;
        ext.orderRecord.Pricebook2Id = constants.STANDARD_PRICEBOOK_ID;
        ext.orderItemList[0].Quantity = 1;
        ext.orderItemList[0].UnitPrice = 1;
        ext.orderItemList[1].Quantity = 2;
        ext.orderItemList[1].UnitPrice = 2;
        ext.save();
        
        List<Order> savedOrders = [SELECT Id, (SELECT Quantity, UnitPrice FROM OrderItems ORDER BY Quantity) FROM Order WHERE AccountId = :testAccount.Id];
        system.assert( savedOrders.size() == 1 );
        system.assert( savedOrders[0].OrderItems.size() == 2 );
        
        ext.GetFamilyOptions();
        ext.selectedFamily =  familyEntries[(familySize - 1) - Math.mod(1, familySize)].value;
        ext.SelectFamily();
        ext.orderItemList[0].Quantity = 10;
        ext.OnFieldChange();
        ext.First();
        ext.Next();
        ext.Previous();
        ext.Last();
        ext.GetHasPrevious();
        ext.GetHasNext();
        ext.GetTotalPages();
        ext.GetPageNumber();
    }

}