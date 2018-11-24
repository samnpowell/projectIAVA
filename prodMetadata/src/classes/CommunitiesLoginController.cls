/**
 * An apex page controller that exposes the site login functionality
 */
global with sharing class CommunitiesLoginController {

    global CommunitiesLoginController () {}
    
    // Code we will invoke on page load.
    global PageReference forwardToAuthPage() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String displayType = System.currentPageReference().getParameters().get('display');

        if (startUrl != null && startUrl.contains('forcelogin=true')) {
        	startUrl = startUrl.replace('&forcelogin=true', '');
        	startUrl = startUrl.replace('?forcelogin=true&', '?');
            startUrl = startUrl.replace('?forcelogin=true', '');
        }

        return Network.forwardToAuthPage(startUrl, displayType);

        //startUrl = (startUrl == null) ? '' : '?startURL=' + startUrl;
        //return new PageReference('/cov_login' + startUrl);

    }
}