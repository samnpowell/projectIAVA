public with sharing class cov_template_controller {
	
	private String currentUrl {get; set;}
	public String baseUrl {get; set;}
	public String pathprefix {get; set;}
	final String CUSTOM_BASE_DOMAIN = 'https://my.iava.org/';
	final String EXTRA_PATH = 'iava/';



	public cov_template_controller() {
		baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
		pathprefix = Site.getPathPrefix();
		currentUrl = Url.getCurrentRequestUrl().toExternalForm();
	}

    public PageReference checkURLPath() {

    	system.debug('in checkURLPath method');

		IAVA_switches__c sw = IAVA_switches__c.getInstance('myIAVA_path_checker');
		if (sw != null && !sw.Disable__c) {
			system.debug('Checking myIAVA path for extra /iava/ on custom domain');

	        system.debug('currentUrl: ' + currentUrl);
	        system.debug('pathprefix: ' + pathprefix);

	        // check for extra path prefix on custom domain
	        if (currentUrl.startsWith(CUSTOM_BASE_DOMAIN + EXTRA_PATH)) {
	            String redirectUrl = currentUrl.replace(CUSTOM_BASE_DOMAIN + EXTRA_PATH + 'apex/', CUSTOM_BASE_DOMAIN);
	            try {
		            pageReference pr = new PageReference(redirectUrl);
		            return pr;
	            } catch (Exception e) {
	            	cov_log_error.logError(e, 'Error creating a PageReference to redirect and eliminate extra /iava/ in url path. Pageref arg: ' + redirectUrl);
	            }
	        } 
	    }
	    return null;
    }

    public Boolean getIsMobile() {
    	return cov_user_utility.self.getIsMobile();
    }


    // eliminated this and instead just redirect via javascript since couldnt use an actionfunction in the <head> section
  //  public PageReference checkUrlForApex() {
  //  	// method has to be triggered by javascript because inside apex can't seem to accurately
  //  	// test whether /apex/ is part of the URL. getSalesforceBaseUrl always seems to include /apex/

		//IAVA_switches__c sw = IAVA_switches__c.getInstance('myIAVA_apex_path_checker');

  //  	if(sw != null && !sw.Disable__c && currentUrl.startsWith(baseUrl + pathprefix + '/apex/')) {

	 //       	// next check for /apex/ in the URL

	 //           String redirectUrl = currentUrl.replace('/apex/', '/');
	 //           try {
		//            pageReference pr = new PageReference(redirectUrl);
		//            return pr;
	 //           } catch (Exception e) {
	 //           	cov_log_error.logError(e, 'Error creating a PageReference to redirect and eliminate /apex/ in url path. Pageref arg: ' + redirectUrl);
	 //           }

	 //   }
	 //   return null;
  //  }


}