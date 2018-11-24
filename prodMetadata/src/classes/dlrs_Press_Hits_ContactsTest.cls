/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_Press_Hits_ContactsTest
{
    private static testmethod void testTrigger()
    {
        // Force the dlrs_Press_Hits_ContactsTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new Press_Hits_Contacts__c());
    }
}