/**
	Trailhead: Seperation of Concern(SOC)
*/
public with sharing class CaseService {

	public class CaseServiceException extends Exception {} 

	public CaseService() {
		
	}

	public static void closeCases(Set<Id> caseIDs, String closeReason){

		if(caseIDs.size() == 0 || caseIDs == null){
			throw new CaseServiceException('Pass the case ids, damn it!!!');
		}

		List<Case> caseLst = new List<Case>();

		for(Id i : caseIDs ){
			Case c = new Case(Id = i);
            c.Reason = closeReason;
            c.Status = 'Closed';

            caseLst.add(c); 
		}

		// Update the database
        SavePoint sp = Database.setSavePoint();
        
        try{
        	update caseLst;       	
       	} catch(Exception ex){
       		// Rollback
            Database.rollback(sp);
            // Throw exception on to caller
            throw ex;
        }

	} 
}