public with sharing class AccountController {

	private Map<Id, Account> accLst{get;set;}

	public AccountController(ApexPages.StandardController controller) {
		
		accLst = new Map<Id,Account>([Select Id, Name, (Select Id,Name From Contacts) From Account Limit 5]);
	}

	public Map<Id,Account> getAccountLst() {
		return accLst;
	}
}