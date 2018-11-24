@isTest
private class test_dc_ctrl_homepage {
	private static testMethod void testController() {
		
		Partnership_Request__c part = test_Utilities.createPartnership();
		
		PageReference pageRef = Page.dc_homepage;
		Test.setCurrentPageReference(pageRef);
		
		dc_ctrl_homepage controller = new dc_ctrl_homepage();
		
		Test.startTest();
		
		List<PartnerDetails> postImgId = controller.getPostImgId();
		List<dc_ctrl_homepage.FeatureReward> featureReward = controller.getfeature_reward();
		ApexPages.StandardSetController setCon = controller.setCon;
		Boolean hasNext = controller.hasNext;
		Boolean hasPrevious = controller.hasPrevious;
		controller.previous();
		List<PartnerDetails> details = controller.getPartners();
		String feature = controller.getFeaturedPartnerLogo();
		List<dc_ctrl_homepage.dc_CustomFeed> customFeed = controller.getFeedList();
		PageReference pr = controller.PartnerPage();
		controller.its();
		controller.its_Partner();
		Controller.Feed();
		
		Test.stopTest();
	}
	
	private static testMethod void test_dc_Customfeed() {
		Test.startTest();
		dc_ctrl_homepage.dc_Customfeed feed = new dc_ctrl_homepage.dc_Customfeed('a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a', 'a');
		Test.stopTest();
	}
}