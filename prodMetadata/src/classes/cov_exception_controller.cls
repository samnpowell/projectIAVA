public without sharing class cov_exception_controller {

	//public String errorDescription {get; set;}
	public COV_Error__c ce {get; set;}
	public String userMessage {get; set;}
	public String responseMessage {get; set;}
	public Boolean userMessageSubmitted {get; set;}

	public cov_exception_controller() {}
	
	//public void logError() {
	//	System.debug('in the exception controller');
	//	COV_Error__c ce = new COV_Error__c();
	//	ce.Error_Date_Time__c = System.now();
	//	ce.User__c = Userinfo.getUserId();
	//	String summary;
	//	ce.Developer_Message__c = 'Exception page was shown.';
	//	if (ApexPages.hasMessages()) {
	//		summary = ApexPages.GetMessages().get(0).getSummary();
	//		ce.Full_Error_Message__c = summary;
	//	}
	//	if (summary == null) {
	//		ce.Developer_Message__c += ' No explanatory page message.';
	//	} else {
	//		ce.Brief_Error_Message__c = summary.left(255);
	//	}
	//	System.debug('about to insert COV Error record: ' + ce);
	//	try {
	//		insert ce;
	//	} catch(Exception e) {
	//		System.debug('couldnt insert: ' + ce);
	//	}
	//	System.debug('Exiting exception controller');		
	//}

	public void logVFerror() {
		System.debug('in logVFerror in the exception controller');

		String errorDescription = Site.getErrorDescription();
		String errorMessage = Site.getErrorMessage();
		String originalUrl = Site.getOriginalUrl();

		ce = new COV_Error__c();
		ce.Error_Date_Time__c = System.now();
		ce.User__c = Userinfo.getUserId();
		ce.Full_Error_Message__c = errorDescription;
		ce.Brief_Error_Message__c = errorDescription == null ? null : errorDescription.left(255);
		ce.Developer_Message__c = errorMessage == null ? null : errorMessage.left(255);
		ce.Error_Type__c = 'Visualforce Error';
		ce.Error_Stack_Trace__c = originalUrl;

		ce.Referrer__c = ApexPages.currentPage().getHeaders().get('Referrer');
		ce.User_Agent__c = ApexPages.currentPage().getHeaders().get('USER-AGENT');

		String baseUrl = Site.getBaseUrl();
		String pathPrefix = Site.getPathPrefix();
		if (!String.isEmpty(baseUrl) && !String.isEmpty(pathPrefix) && !String.isEmpty(originalUrl)
			&& baseUrl.contains(pathPrefix) && originalUrl.contains(pathPrefix)) {
			baseUrl = baseUrl.replace(pathPrefix, '');			
		}
		baseUrl = !String.isEmpty(baseUrl) && !String.isEmpty(originalUrl) && !baseUrl.endsWith('/') && !originalUrl.startsWith('/') ? baseUrl + '/' : baseUrl;
		String fullOriginalUrl = baseUrl + originalUrl;
		ce.Original_URL__c = fullOriginalUrl;
		System.debug('about to insert COV Error record: ' + ce);
		try {
			insert ce;
		} catch(Exception e) {
			System.debug('couldnt insert: ' + ce);
		}
		System.debug('Exiting logVFerror in exception controller');	

	}

	public pageReference addUserMessage() {
		ce.User_Message__c = userMessage;
		try {
			update ce;
			userMessageSubmitted = true;
			responseMessage = 'Thanks! We\'ll look into it.';
		} catch(Exception e) {
			System.debug('couldnt insert: ' + ce);
		}
		return null;
	}

}