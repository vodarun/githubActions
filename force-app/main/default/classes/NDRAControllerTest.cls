/**
 * Not covering the entire scenarios due to time factor reasons :(      
*/

@isTest
public class NDRAControllerTest {
	@testSetup  
    static void setup(){
        List<Lead> leadsLst = new List<Lead>();
        for(Integer i=1; i<20; i++){
            Lead ld = new Lead();
            ld.firstname = 'Test FName' + i;
            ld.lastName= 'Test LastName ' + i ;
            ld.company='TEST-COmpany ' + i;
            ld.status = 'Open - Not Contacted';
            leadsLst.add(ld);
        }
        insert leadsLst;
        
        List<Opportunity> oppLst = new List<Opportunity>();
        for(Integer i=1; i<5; i++){
            Opportunity opp = new Opportunity();
            opp.Name = 'John Snow Opp ' + i;
            opp.StageName = 'Closed Won';
            opp.CloseDate  = Date.today()+5*i;
            opp.Amount = i * 100;
            oppLst.add(opp);
        }
        insert oppLst;
    }
    
    /**
     * This testmethod checks for the data returned for a month.
     * Expected: 19 Leads, 4 Opps, Total Opp val = 1000...
	*/
    @isTest 
    static void testMethod1() {
        List<NDRAController.TableDataWrapper> tableData = NDRAController.fetchTableData('2019-04-24', '2019-05-24');
        Test.startTest();
        System.assertEquals(tableData[0].leadCount, 19, 'For 1 month the lead count should be 19 as per test data');
        System.assertEquals(tableData[0].totalOpps, 4, 'Opps should be 4.');
        System.assertEquals(tableData[0].totalValue, (1+2+3+4)*100, 'Total Opp values not matching.');
        // Assert for other data ...
        Test.stopTest();
   	} 
    
    /**
     * This testmethod shouldn't return any data as it doesn't have any opps.
	*/
    @isTest 
    static void testMethod2() {
        List<NDRAController.TableDataWrapper> tableData = NDRAController.fetchTableData('2019-04-24', '2019-04-25');
        Test.startTest();
        System.assertEquals(tableData.size(), 0, 'No data expected, but returned result has.');
        Test.stopTest();
   	} 
}