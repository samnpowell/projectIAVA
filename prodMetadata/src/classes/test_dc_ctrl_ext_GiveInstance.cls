@isTest
private class test_dc_ctrl_ext_GiveInstance {

    static testMethod void testController() {
    	Contact con = test_Utilities.createSimpleContact('doe', 'test@test.com', '12345');
    	
    	Give__c give = test_Utilities.createSimpleGive();
    	Give_Instance__c instance = test_Utilities.createSimpleGiveInstance(give);
        Give_Request__c request = test_Utilities.createSimpleGiveRequest(give, instance, con);

        dc_ctrl_ext_GiveInstance controller = new dc_ctrl_ext_GiveInstance(instance);
                
        Test.startTest();
        controller.selectedStage = 'Give requested';
        controller.selectedEndStage = 'Give requested';
        controller.selectedStartStage = 'Give requested';
        
        List<Give_Request__c> requests = controller.requests;
        List<SelectOption> stageOptions = controller.stageOptions;
        List<dc_ctrl_ext_GiveInstance.RequestSelect> requestSelects = controller.requestSelects;
        PageReference pr = controller.updateSelectedStage();
        pr = controller.massUpdateStage();
        
        Test.stopTest();
    }
}