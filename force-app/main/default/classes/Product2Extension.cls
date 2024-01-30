public without sharing class Product2Extension {

    public List<Product2> finalPrdlst {get;set;}
    public List<PricebookEntry> pbeLst = new List<PricebookEntry>();
    public List<ProductWrapper> productsToInsert {get;set;}
    public String selectedFamily {get;set;}
    private static Integer dRows = Constants.DEFAULT_ROWS;

    public Product2Extension(ApexPages.StandardController controller){
        finalPrdlst = new List<Product2>();
        productsToInsert = new List<ProductWrapper>();
        addRows();
    }

    public void AddRows(){
        for ( Integer i=0; i<dRows; i++ ){
            productsToInsert.add( new ProductWrapper() );
        }
    }

    public List<ChartHelper.ChartData> GetInventory(){
        return ChartHelper.GetInventory();
    }

    public PageReference Save(){
        Boolean successFlag = true;
        Savepoint sp = Database.setSavepoint();
        
        for(ProductWrapper pw : productsToInsert){
            System.debug(pw);
            System.debug(pw.productRecord.Family);

            if(pw.productRecord.Name != null && pw.productRecord.Family!= null  
                ){

                finalPrdlst.add(pw.productRecord);

                PricebookEntry pbe = new PricebookEntry();
                pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
                pbe.UnitPrice = pw.pricebookEntryRecord.UnitPrice;
                pbeLst.add(pbe);
            }
        }

        try{
            System.debug(finalPrdlst);
            insert finalPrdlst;

            for(Integer i=0; i<pbeLst.size();i++){
                pbeLst[i].Product2Id = finalPrdlst[i].Id;
            }

            insert pbeLst;

            //If successful clear the list and display an informational message
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,finalPrdlst.size()+' Inserted'));
            finalPrdlst.clear();   //Do not remove
            addRows();  //Do not remove
        }catch (Exception e){
            Database.rollback(sp);
            apexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,constants.ERROR_MESSAGE));
        }
        return null;
    }

    public List<SelectOption> GetFamilyOptions(){
        List<SelectOption> familyOptions = new List<SelectOption>();
        familyOptions.add((new SelectOption(Constants.SELECT_ONE,Constants.SELECT_ONE)));
        for(Schema.PicklistEntry s : Constants.PRODUCT_FAMILY){
            familyOptions.add((new SelectOption( s.getValue(),s.getValue() )));
        }       
        return familyOptions;
    }

    // Wrapper Class
    public class ProductWrapper{
        public Product2 productRecord {get;set;}
        public PriceBookEntry pricebookEntryRecord {get;set;}

        public ProductWrapper(){
            productRecord = new Product2();
            pricebookEntryRecord = new PriceBookEntry();
        }
    }

}