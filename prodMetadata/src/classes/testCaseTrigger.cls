@isTest  
  
private class testCaseTrigger {  

    static testMethod void testfillInCaseRequestor() {
    
        Case c = new Case(Subject = 'Unit Test Case');
        insert c;   
    
        // requestor__c field on case should be updated by trigger to current user
        System.assertEquals(UserInfo.GetUserId(), [select Requestor__c from Case where Id = :c.Id].Requestor__c);
    }

}