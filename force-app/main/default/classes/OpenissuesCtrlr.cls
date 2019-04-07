public with sharing class OpenissuesCtrlr {
    @AuraEnabled
    public static Contact getContactDetails(Id caseId){
        Id ids = OpenissuesCtrlr.getConId(caseId);
       	if(ids!=null)
            return [SELECT Id,Product__c,Home_Country__c FROM Contact Where Id =:ids];
	    return null;    
    }
    @AuraEnabled
    public Static Id getConId(Id caseId){
        return [SELECT contact.Id from Case WHERE Id = : caseId LIMIT 1].contactId; 
    }
  

}