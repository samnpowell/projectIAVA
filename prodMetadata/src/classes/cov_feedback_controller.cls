/*
	* feedback widget from the Power of Us Hub
	* by Dave Manelski
	* used by permission
*/

public with sharing class cov_feedback_controller {
	
	public Feedback__c feedback { get; set; }
	public boolean submitted { get; private set; }

	public cov_feedback_controller() {
		feedback = new Feedback__c();

		map<string,string> params = apexPages.currentPage().getParameters();

		feedback.URL__c = params.get('url');
	}

	public pageReference Save() {
		
		//only try to save a record if some feedback was given, otherwise just do nothing
		//we are not opting to incorporate validation since this is such a simple form
		if (feedback.Rating__c != null || feedback.Message__c != null) {
			try {
			
				insert feedback;
				submitted = true;
			} catch (Exception e) {
				//WLMA_Error_Logger.log(e, 'PUBfeedbackController', 'Save', null); 
			}
		}

		return null;
	}

	public static Boolean insertFeedback(String msg, Integer starRating, String url) {
		cov_feedback_controller controller = new cov_feedback_controller();
		controller.feedback.Message__c = msg;
		controller.feedback.Rating__c = (starRating < 0) ? null : starRating;
		controller.feedback.URL__c = url;
		controller.Save();
		return controller.submitted;
	}

}