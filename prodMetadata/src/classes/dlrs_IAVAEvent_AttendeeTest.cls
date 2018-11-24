/**
 * Auto Generated and Deployed by the Declarative Lookup Rollup Summaries Tool package (dlrs)
 **/
@IsTest
private class dlrs_IAVAEvent_AttendeeTest
{
    private static testmethod void testTrigger()
    {
        // Force the dlrs_IAVAEvent_AttendeeTrigger to be invoked, fails the test if org config or other Apex code prevents this.
        dlrs.RollupService.testHandler(new IAVAEvent_Attendee__c());
    }
}