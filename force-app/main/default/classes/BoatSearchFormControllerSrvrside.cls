public with sharing class BoatSearchFormControllerSrvrside {
	@Auraenabled
	public static List<BoatType__c> getBoatTypes(){
		
		String query = 'Select Id,Name From BoatType__c Limit 100 ';
		

		System.debug(query);
		SYstem.debug(Database.query(query));
		return Database.query(query);
	}
}