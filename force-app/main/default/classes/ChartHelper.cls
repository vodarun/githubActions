public without sharing class ChartHelper {

  

    @Auraenabled
    public static List<chartData> GetInventory(){
        List<chartData> cht = new List<chartData>();
        //ToDo: Perform a calculation that aggregates active Products that have a positive Quantity_Remaining__c
        //  And return a list of chartData
        //  Where the name is the Product Family and the Qty is the sum of the Quantity_Remaining__c
        for(AggregateResult ar : [Select Family, SUM(Quantity_Remaining__c) qtyRem
                                        From Product2 
                                        Where Quantity_Remaining__c > 0 
                                            And IsActive = true
                                        Group By Family] ){

          cht.add(new ChartData((String) ar.get('Family'), (Decimal) ar.get('qtyRem')));  

        }
       
        return cht;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }

}