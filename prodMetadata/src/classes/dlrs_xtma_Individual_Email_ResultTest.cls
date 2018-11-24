/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_xtma_Individual_Email_ResultTest
{
    private static testmethod void testTrigger()
    {
        // Force the dlrs_xtma_Individual_Email_ResultTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new xtma_Individual_Email_Result__c());
    }
}