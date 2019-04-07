public with sharing class ProductInfo {
     @AuraEnabled
    public static List<Product2> getProductDetails(Id caseId){
        Id ids = OpenissuesCtrlr.getConId(caseId);
        Contact con =null;
        if(ids!=null){
            con = [SELECT Id,Product__c,Home_Country__c FROM Contact Where Id =:ids];
        }
       	if(con!=null && String.isNotBlank(con.Product__c) && String.isNotBlank(con.Home_Country__c) )
            return [SELECT Id,Name,	Home_Country__c,Cost_per_Calendar_Month__c,Card_Replacement_Cost__c,ATM_Fee_in_other_currencies__c FROM Product2 WHERE Name = :con.Product__c AND Home_Country__c=:con.Home_Country__c];
	    return null;    
    }

}