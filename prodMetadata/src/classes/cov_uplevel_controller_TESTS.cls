@isTest
private class cov_uplevel_controller_TESTS {
	
	@isTest static void test_paperwork_upload() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();

		cov_uplevel_controller controller;
		PageReference pageRef;

		System.RunAs(u) {
	        controller = new cov_uplevel_controller();

			pageRef = Page.cov_uplevel_widget;
	        Test.setCurrentPage(pageRef);

	        system.assertNotEquals('Paperwork Received', controller.paperworkStatus);
	        system.assertEquals(null, controller.paperworkIssue);
			system.assertEquals(null, controller.paperworkStatus);
			system.assertEquals(null, controller.paperworkComments);

			PageReference pr = controller.uploadPaperwork();

			system.assert(ApexPages.getMessages()[0].getSummary().contains('Please select a file to upload'));


	        controller.paperworkFile = new Attachment(Body=EncodingUtil.base64decode('R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==')
	        										, Name='random-filename.jpg');

	        pr = controller.uploadPaperwork();

			system.assert(ApexPages.getMessages()[ApexPages.getMessages().size()-1].getSummary().contains('File uploaded'));

	    }

        Contact queriedC = [select Id, Paperwork_Confirmation__c, Paperwork_Issue__c, Approval_Related_Comments__c from Contact where Id = :c.Id];
        system.assertEquals('Paperwork Received', queriedC.Paperwork_Confirmation__c);

        system.assertEquals('Paperwork Received', controller.paperworkStatus);
        system.assertEquals(null, controller.paperworkIssue);
		system.assertEquals(null, controller.paperworkComments);

		System.RunAs(u) {

	        controller.paperworkFile = new Attachment(Body=EncodingUtil.base64decode('R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==')
	        										,  Name='');

	        PageReference pr = controller.uploadPaperwork();

			system.assert(ApexPages.getMessages()[ApexPages.getMessages().size()-1].getSummary().contains('error uploading the file'));

		}

		c.Paperwork_Confirmation__c = 'Standard Question/Issue';
		c.Paperwork_Issue__c = 'Illegible';
		c.Approval_Related_Comments__c = 'Ham Sando';
		update c;

		System.RunAs(u) {
			controller = new cov_uplevel_controller();
		}

        system.assertEquals(c.Paperwork_Confirmation__c, controller.paperworkStatus);
		system.assertEquals(c.Paperwork_Issue__c, controller.paperworkIssue);
		system.assertEquals(c.Approval_Related_Comments__c, controller.paperworkComments);


	}

}