trigger BatchApexErrorTrigger on BatchApexErrorEvent (after insert) {
    List<BatchLeadConvertErrors__c>  newBatcherrorLst = new List<BatchLeadConvertErrors__c>();
    for(BatchApexErrorEvent be : trigger.new){
        BatchLeadConvertErrors__c  newBatcherror = new BatchLeadConvertErrors__c ();
        newBatcherror.AsyncApexJobId__c = be.AsyncApexJobId;
        newBatcherror.Records__c = be.JobScope;
        newBatcherror.StackTrace__c = be.StackTrace;
        newBatcherrorLst.add(newBatcherror);
    }
    
    insert newBatcherrorLst;
}