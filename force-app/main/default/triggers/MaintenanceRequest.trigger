trigger MaintenanceRequest on Case (before update, after update, before insert) {
    // call MaintenanceRequestHelper.updateWorkOrders  
    Map<Id,Case> casesToConsider = new Map<Id,Case>();
    
    if(trigger.isBefore && trigger.isInsert){
        for(Case c : trigger.new  ){
            c.addError('TEst to throw this error');
        }
    }

    if(trigger.isAfter && trigger.isUpdate){
        for(Case maintenance : trigger.new){
            if((maintenance.Type.contains('Repair') || maintenance.Type.contains('Routine Maintenance')) && maintenance.Status == 'Closed'){
                casesToConsider.put(maintenance.Id,maintenance);
            }
        }
    }
    MaintenanceRequestHelper.updateWorkOrders(casesToConsider);
}