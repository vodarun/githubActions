public with sharing class BoatSearchResults {
	
	@AuraEnabled
	public static List<Boat__c> getBoats(String boatTypeId ){

		if(boatTypeId != null && boatTypeId != '' ){
			System.debug('0-----------boatTypeId:'+boatTypeId);
			return [Select Id,Name,Contact__r.Name,Picture__c,Geolocation__Latitude__s,Geolocation__Longitude__s,BoatType__r.Id From Boat__c Where BoatType__r.Id =:boatTypeId];
			//System.debug([Select Id,Name,Contact__r.Name,Picture__c,BoatType__c From Boat__c Where BoatType__r.Id =:boatTypeId]);
		}else{
			System.debug('0-----------boatTypeId:'+boatTypeId);
			return [Select Id,Name,Contact__r.Name,Picture__c,BoatType__c,Geolocation__Latitude__s,Geolocation__Longitude__s From Boat__c ];
			//System.debug([Select Id,Name,Contact__r.Name,Picture__c,BoatType__c From Boat__c ]);
		}
	}
}