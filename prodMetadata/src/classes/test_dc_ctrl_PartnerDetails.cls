@isTest
private class test_dc_ctrl_PartnerDetails {

    static testMethod void myController() {
        Partnership_Request__c ps = test_Utilities.createPartnership();
        PageReference pageRef = Page.dc_PartnerDetails;
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('id', ps.Id);
        
        dc_ctrl_PartnerDetails controller = new dc_ctrl_PartnerDetails();
       	ps = controller.getPartner();
       	controller.its();
       	
    }
}