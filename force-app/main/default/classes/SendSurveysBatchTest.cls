@isTest
private class SendSurveysBatchTest {

    @isTest static void testBatch() {
        Account testAccount = new Account(Name = 'test');
        insert testAccount;
        Contact testContact = new Contact(AccountId = testAccount.Id,
            FirstName = 'firstName1',
            LastName = 'lastName1',
            Email = 'email1@email.test',
            Language__c = 'EN',
            Survey_Date__c = Date.today() - 1
        );
        Contact testContact2 = new Contact(AccountId = testAccount.Id,
            FirstName = 'firstName2',
            LastName = 'lastName2',
            Email = 'email1@email.test2',
            Language__c = 'EN',
            Survey_Date__c = Date.today() - 1
        );
        INSERT new List<Contact> {testContact,testContact2};
        Test.startTest();
        Database.executeBatch(new SendSurveyBatch(), SendSurveyBatch.EMAILS_PER_BATCH);
        Test.stopTest();
        for(Contact con:[SELECT Survey_Date__c FROM Contact LIMIT 2]){
            System.assertEquals(null, con.Survey_Date__c);
        }
    }

}