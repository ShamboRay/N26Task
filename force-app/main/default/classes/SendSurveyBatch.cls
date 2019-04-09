/**This Class Contains The Batch Functionality Of Survey Email Sending
@TestClass :  SendSurveysBatchTest.cls
This Class Can schedule it self              

**/

public with sharing class SendSurveyBatch implements Database.Batchable<Contact>, Schedulable, Database.AllowsCallouts {
	public static final Integer EMAILS_PER_BATCH = 100;
	public static Map<Id,Contact> conIdToContact = new Map<Id,Contact> ();
    public static final String GER = 'DE';
    public static final String DEF = 'EN';

    //start of the scheduler part
    public void execute(SchedulableContext context) {
        Database.executeBatch(this, SendSurveyBatch.EMAILS_PER_BATCH); //going to send up to 100 emails in a single batch
    }
    //end of the scheduler part

    //start of the batch part
    public List<Contact> start(Database.BatchableContext BC) {
        return [SELECT Id,FirstName,LastName,Email,Language__c,Survey_Date__c,AccountId FROM Contact WHERE Survey_Date__c < TODAY];
    }

    public void execute(Database.BatchableContext BC, List<Contact> contacts) {
        List<Messaging.SingleEmailMessage> messages = new List<Messaging.SingleEmailMessage>();
        
		//Checking the limit
        Integer remainingInvocations = Limits.getLimitEmailInvocations() - Limits.getEmailInvocations();
        for (Contact con : Contacts) {
             if (String.isBlank(con.Email)) {
                return;
            }
			SendSurveyBatch.conIdToContact.put(con.Id,con);//tracking contact
            String language = (GER.equalsIgnoreCase(con.Language__c)) ? GER : DEF;
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            message.setTargetObjectId(con.Id);
            message.setTemplateId(getSurveyTemplateId(language));
            message.setWhatId(con.AccountId);
            message.setSaveAsActivity(true);
            messages.add(message);
        }
        if(remainingInvocations>0){
            try{
                if(!messages.isEmpty()){
                    List<Messaging.SendEmailResult> sendEmailResults = Messaging.sendEmail(messages,false);
                    
                    List<Id> conList = new List<Id> ();
                    for(Integer i=0;i<messages.size();i++){
                        if(sendEmailResults[i].isSuccess()){
                            conList.add(messages[i].getTargetObjectId());//Tracking Contacts
                        }
                    }
                    if(!conList.isEmpty()){
                    	updateContacts(conList);
                    }
                }
            }
            catch(Exception e){
                System.debug('Error Block');
            }
            
        }
        else{
            system.debug('Daily Email Limit Reached!');
        }
    }
	
    public void finish(Database.BatchableContext BC) {}
    //updating survey date
    private static void updateContacts(List<Id> idList){
        List<Contact> conToUpdate = new List<Contact>();
        for(Id ids:idList){
            if(SendSurveyBatch.conIdToContact!= null && !SendSurveyBatch.conIdToContact.isEmpty() && SendSurveyBatch.conIdToContact.containsKey(ids)){
                SendSurveyBatch.conIdToContact.get(ids).Survey_Date__c =null;
                conToUpdate.add(SendSurveyBatch.conIdToContact.get(ids));
            }
        }
        if(!conToUpdate.isEmpty())
        {	
            Database.update(conToUpdate,false);
        }
    }
    //get Template
    private static Id getSurveyTemplateId(String language) {
        String templateName = 'Survey_Email_' + language;
        return [SELECT Id FROM EmailTemplate WHERE DeveloperName = :templateName].Id;
    }

}
