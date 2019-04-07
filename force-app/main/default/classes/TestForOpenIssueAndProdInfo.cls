@isTest
private class TestForOpenIssueAndProdInfo {
    
    @isTest static void testLtng() {
        Account testAccount = new Account(Name = 'test');
        insert testAccount;
        Contact testContact = new Contact(AccountId = testAccount.Id,
            FirstName = 'firstName1',
            LastName = 'lastName1',
            Email = 'email1@email.test',
            Language__c = 'EN',
            Survey_Date__c = Date.today() - 1,
            Product__c='name',
            Home_Country__C='DE'
        );
        insert testContact;
        Case testCase = new Case(
            AccountId = testAccount.Id,
            ContactId = testContact.Id,
            Subject = 'subject'
        );
        insert testCase;
        Product2 testProduct = new Product2(
            IsActive = true,
            Name = 'name',
            ProductCode = '1324',
            Home_Country__c = 'DE'
        );
        insert testProduct;
        System.assertEquals('name',ProductInfo.getProductDetails(testCase.Id)[0].Name);//For ProdInfo
        System.assertEquals('DE', OpenissuesCtrlr.getContactDetails(testCase.Id).Home_Country__C);//Adding This Line to Cover Other Classes Also
    }
}
