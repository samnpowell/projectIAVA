@isTest
private class cov_exception_controller_TESTS {
	
	@isTest static void test_vf_exception() {
		

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();

		System.RunAs(u) {
	        cov_exception_controller controller = new cov_exception_controller();

			PageReference pageRef = Page.cov_exception_page;
	        Test.setCurrentPage(pageRef);

	        controller.logVFerror();

	        List<COV_Error__c> errors = [select Id, Error_Type__c, User_Message__c, User__c from COV_Error__c where Error_Type__c = 'Visualforce Error'];
	        System.assertEquals(1, errors.size());
	        Id theErrorId = errors[0].Id;
	        System.assertEquals(UserInfo.getUserId(), errors[0].User__c);
	        System.assertEquals(null, errors[0].User_Message__c);

	        System.assert(controller.userMessageSubmitted == null || controller.userMessageSubmitted == false);
	        System.assertEquals(null, controller.responseMessage);

	        controller.userMessage = 'I was trying to log in';
	        controller.addUserMessage();

	        System.assertEquals(true, controller.userMessageSubmitted);
	        System.assert(controller.responseMessage.contains('Thanks'));
			errors = [select Id, Error_Type__c, User_Message__c, User__c from COV_Error__c where Id = :theErrorId];
	        System.assertEquals(controller.userMessage, errors[0].User_Message__c);

		}


	}
	
	
}