@isTest
private class test_dc_ctrl_RewardDetails {

    static testMethod void testController() {
    	Give__c give = test_Utilities.createSimpleGive();
    	Give_Instance__c instance = test_Utilities.createSimpleGiveInstance(give);
    	
    	ApexPages.currentPage().getParameters().put('giveid', give.Id);
    	
    	Test.startTest();
    	
    	dc_ctrl_RewardDetails rd = new dc_ctrl_RewardDetails();
    	
    	rd.givedetlist();
    	
    	rd.setgiveid(give.id);
    	
    	List<dc_CustomGive> giveList = rd.getGiveList();
    	giveList = rd.getGiveInstList();
    	String s = rd.getPartnerLogo();
    	
    	rd.its();
    	
    	Test.stopTest();
    	
    }
}