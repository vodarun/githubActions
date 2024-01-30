/**
 *   
*/
public with sharing class NDRAController {
	@AuraEnabled
	public static List<TableDataWrapper> fetchTableData(String leadCreatedDate, String oppCLosedDate){       
        Map<String,TableDataWrapper> tableDataWrapperMap = new Map<String,TableDataWrapper>();         
        //get the lead aggregates
		Date d1 = Date.valueOf(leadCreatedDate);
		String queryStringForLead =  ' SELECT Owner.Name owner, COUNT(Id) leadCount FROM Lead WHERE CreatedDate > :d1 GROUP BY  Owner.Name' ;
		//SYSTEM.debug('queryStringForLead ==>> ' + queryStringForLead);
		List<AggregateResult> leadAggregates = Database.query(queryStringForLead);
		//SYSTEM.debug('leadAggregates ==>> ' + leadAggregates);		
		// get opportunity aggregates
		Date d2 = Date.valueOf(oppCLosedDate);
		String queryStringForopportunity = 'SELECT Owner.Name owner, COUNT(Id) oppCount, MAX(CloseDate) maxDate, SUM(Amount) oppAmt FROM Opportunity ';
		       queryStringForopportunity += ' WHERE StageName = \'Closed Won\' ';
			   queryStringForopportunity += ' And CloseDate < : d2 ';
			   queryStringForopportunity += ' GROUP BY  Owner.Name ' ;        
		List<AggregateResult> oppAggregates = Database.query(queryStringForopportunity);
        //SYSTEM.debug('oppAggregates ==>> ' + oppAggregates);
        //prepare the aggregates map               
        for(AggregateResult ldAgg : leadAggregates){           
            TableDataWrapper tableData1 =  new TableDataWrapper();
            tableData1.ownerName = (String)ldAgg.get('owner');
            tableData1.leadCount = (Integer)ldAgg.get('leadCount');           
            tableDataWrapperMap.put(tableData1.ownerName, tableData1);
        }
        // Now as we have the lead aggreates loop through Opp aggrgates and construct the table data
        for(AggregateResult oppAgg : oppAggregates){  
            TableDataWrapper tableData1 =  new TableDataWrapper();
            if(tableDataWrapperMap.containsKey( (String)oppAgg.get('owner'))){
                tableData1 = tableDataWrapperMap.get((String)oppAgg.get('owner'));
                tableData1.totalOpps = (Integer)oppAgg.get('oppCount');
                Datetime dt = (Datetime)oppAgg.get('maxDate');
                tableData1.maxCreatedDate = dt == null? null : dt.date();
                tableData1.totalValue = (Decimal)oppAgg.get('oppAmt');
            }else{
                tableData1.ownerName = (String)oppAgg.get('owner');
                tableData1.totalOpps = (Integer)oppAgg.get('oppCount');
                Datetime dt = (Datetime)oppAgg.get('maxDate');
                tableData1.maxCreatedDate = dt == null? null : dt.date();
                tableData1.totalValue = (Decimal)oppAgg.get('oppAmt');
                tableDataWrapperMap.put((String)oppAgg.get('owner') , tableData1 );
            }           
        }
        System.debug(tableDataWrapperMap);
        calculateConversionRate(tableDataWrapperMap.values());
		return removeEmptyRows(tableDataWrapperMap.values());
	}
	//
	@Auraenabled
    public static void saveAccount(String s){
        Account acc = new Account();
        acc.Id= '001f400000FpdTOAAZ';
        acc.Description = s;
        update acc;
    }
        
	        
    //calculate conversionRate
    public static void calculateConversionRate(List<TableDataWrapper> tableData){        
        for(TableDataWrapper tdw : tableData ){           
            if(tdw.totalOpps != null && tdw.leadCount != null ){               
               tdw.conversionRate =  tdw.totalOpps/tdw.leadCount;                
            }else{
                tdw.conversionRate =0;
            }
        }
    }
    
    //remove empty column rows
    public static List<TableDataWrapper> removeEmptyRows(List<TableDataWrapper> tableData){
        Integer i =0;
        while(i < tableData.size()){
            if(tableData.get(i).totalOpps == null || tableData.get(i).leadCount == null || 
               tableData.get(i).maxCreatedDate == null || tableData.get(i).totalValue == null ){                   
                 tableData.remove(i);
                   System.debug(tableData);
               }else{
                   i++;
               }
        }
        return tableData;
    }
	
    // Wrapper class to hold the data structure
    public class TableDataWrapper {
        @AuraEnabled 
        public String ownerName{get;set;}
        @AuraEnabled 
        public Double leadCount{get;set;}
        @AuraEnabled 
        public Double totalOpps{get;set;}
        @AuraEnabled 
        public Decimal conversionRate{get;set;}
        @AuraEnabled 
        public Date maxCreatedDate{get;set;}
        @AuraEnabled 
        public Decimal totalValue{get;set;}
    }  
    
    
}