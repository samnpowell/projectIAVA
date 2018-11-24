global without sharing class cov_log_error {

	public static void logError(Exception e) {
		logError(e, null);
	}

	public static void logError(Exception e, String devMsg) {
		system.debug('devMsg: ' + devMsg);
		String urlArg;
		if (Trigger.isExecuting) {
			urlArg = 'Trigger';
		} else {
			urlArg = ApexPages.currentPage().getHeaders().get('referer');
		}
		reportError(e, urlArg, devMsg);
	}


	public static void reportError(Exception e, String theURL, String devMsg) {
		System.debug('about to report an error e: ' + e);
		String userMsg = 'There may have been an error. Our team has been notified and we\'ll check it out soon. Sorry for any inconvenience.';
		system.debug('devMsg in reportError: ' + devMsg);
		//writeError(e.getMessage(), System.now(), Userinfo.getUserId(), e.getTypeName(), e.getStackTraceString(), theURL, devMsg);
		writeError(e.getMessage(), System.now(), Userinfo.getUserId(), e.getTypeName(), e.getStackTraceString(), theURL, devMsg);
		if (!Trigger.isExecuting && ApexPages.getMessages().size() == 0) {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, userMsg);
			ApexPages.addMessage(myMsg);
		}
	}


	public static void logDevMsg(String devMsg) {
		System.debug('about to report an error with this string: ' + devMsg);
		writeError(null, System.now(), Userinfo.getUserId(), null, null, null, devMsg);
	}



	@future
     public static void writeError(String msg, DateTime theDateTime, String userId, String theType, String stacktrace, String theURL, String devMsg){

		System.debug('in cov_log_error');
		COV_Error__c ce = new COV_Error__c();
		ce.Error_Date_Time__c = theDateTime == null ? System.now() : theDateTime;
		ce.User__c = Userinfo.getUserId();
		ce.Full_Error_Message__c = msg;
		ce.Brief_Error_Message__c = msg == null ? null : msg.left(255);
		ce.Error_Type__c = theType;
		ce.Error_Stack_Trace__c = stacktrace;
		ce.Original_URL__c = theURL == null ? null : theURL.left(255);
		system.debug('devMsg in writeError: ' + devMsg);
		ce.Developer_Message__c = devMsg == null ? null : devMsg.left(255);
		System.debug('about to insert COV Error record: ' + ce);
		try {
			insert ce;
		} catch(Exception ex) {
				System.debug('couldnt insert: ' + ce);
				Messaging.SingleEmailMessage mail=new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] {'covdev@iava.org'};
				mail.setToAddresses(toAddresses);
				mail.setReplyTo('covdev@iava.org');
				mail.setSenderDisplayName('COV Error Reporting');
				mail.setSubject('Couldnt insert COV Error record from Org : ' + UserInfo.getOrganizationName());
				mail.setPlainTextBody(ex.getMessage());
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
		System.debug('Exiting cov_log_error.writeError()');	

     }


}