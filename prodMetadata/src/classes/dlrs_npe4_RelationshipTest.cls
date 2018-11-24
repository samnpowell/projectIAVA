/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_npe4_RelationshipTest
{
    private static testmethod void testTrigger()
    {
        // Force the dlrs_npe4_RelationshipTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new npe4__Relationship__c());
    }
}