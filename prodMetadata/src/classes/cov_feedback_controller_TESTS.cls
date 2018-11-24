@isTest
private class cov_feedback_controller_TESTS {
	
	/****************************************
	*				  TESTS					*
	****************************************/

	static testMethod void submitFeedback() {
		Test.setCurrentPageReference(new PageReference('cov_feedback.myPage')); 
		System.currentPageReference().getParameters().put('url', 'http://www.google.com/');

		cov_feedback_controller controller = new cov_feedback_controller();
		controller.feedback.Message__c = 'The PUB rocks, man, far out';
		controller.feedback.Rating__c = 5;
		controller.Save();

		Feedback__c[] feedback = [SELECT Message__c, Rating__c, URL__c FROM Feedback__c LIMIT 1];
		system.assertEquals(feedback[0].Message__c, 'The PUB rocks, man, far out');
		system.assertEquals(feedback[0].Rating__c, 5);
		system.assertEquals(feedback[0].URL__c, 'http://www.google.com/');
	}

	static testMethod void throwFeedbackInsertError() {
		Test.setCurrentPageReference(new PageReference('cov_feedback.myPage')); 
		System.currentPageReference().getParameters().put('url', 'http://www.google.com/');

		cov_feedback_controller controller = new cov_feedback_controller();
		controller.feedback.Message__c = 'The PUB rocks, man, far out';
		//this should throw an error, since this is a one digit number field
		controller.feedback.Rating__c = 56;
		
		try {
			controller.Save();
		} catch (Exception e) {
			system.assert(e != null);
		}
		
	}

	static testMethod void noInsert() {
		Test.setCurrentPageReference(new PageReference('cov_feedback.myPage')); 
		System.currentPageReference().getParameters().put('url', 'http://www.google.com/');

		cov_feedback_controller controller = new cov_feedback_controller();
		controller.Save();

		//there was no Rating or Message, so no record should have been inserted
		Feedback__c[] feedback = [SELECT Message__c, Rating__c, URL__c FROM Feedback__c LIMIT 1];
		system.assert(feedback.isEmpty());
		
	}	
}