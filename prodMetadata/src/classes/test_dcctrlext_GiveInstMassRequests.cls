@isTest
private class test_dcctrlext_GiveInstMassRequests {

    static testMethod void testController() {
       	Contact con = test_Utilities.createSimpleContact('doe', 'test@test.com', '12345');
    	
    	Give__c give = test_Utilities.createSimpleGive();
    	Give_Instance__c instance = test_Utilities.createSimpleGiveInstance(give);
        Give_Request__c request = test_Utilities.createSimpleGiveRequest(give, instance, con);
        
        PageReference pageRef = Page.dc_ReConfirm;
        pageRef.getParameters().put('instanceId', instance.Id);
        
        Test.setCurrentPage(pageRef);
    	
    	Test.startTest();    	
    	
        dc_ctrl_ext_GiveInstanceMassRequests controller = new dc_ctrl_ext_GiveInstanceMassRequests();
        
        controller.selectedStage = 'Give requested';
        controller.selectedEndStage = 'Give requested';
        controller.selectedStartStage = 'Give requested';
        
        List<SelectOption> stageOptions = controller.stageOptions;
        Give_Request__c[] requests = controller.requests;
        List<dc_ctrl_ext_GiveInstanceMassRequests.RequestSelect> requestselects = controller.requestSelects;
        Id id = controller.instanceId;
        
        controller.updateSelectedStage();
        controller.massUpdateStage();
        
        Test.stopTest();
    }
}