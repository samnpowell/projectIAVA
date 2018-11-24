/**
 * An apex page controller that takes the user to the right start page based on credentials or lack thereof
 */
public with sharing class CommunitiesLandingController {
    
    // Code we will invoke on page load.
    public static PageReference forwardToStartPage() {
        //return Network.communitiesLanding(); // this returns the first tab in the community, but with /apex before it
        //if (cov_user_utility.self.isMobile()) {
        //	return new PageReference('/one/one.app');
        //} else {
            String startUrl = System.currentPageReference().getParameters().get('startURL');
            system.debug('startUrl: ' + startUrl);
            if (startUrl != null) {
                if (startUrl.contains(Site.getPathPrefix())) {
                    system.debug('about to redirect to startUrl');
                    return new PageReference(startUrl);
                }
            }
            system.debug('about to redirect to cov_dashboard');
	        return new PageReference('/cov_dashboard');
	    //}
    }
    
    public CommunitiesLandingController() {}


}