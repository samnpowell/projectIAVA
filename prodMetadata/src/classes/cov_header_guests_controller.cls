public with sharing class cov_header_guests_controller {

    public String currentEncodedUrlWithBase;
    public String currentEncodedUrlWithoutBase;
    public String portalLoginBaseUrl;

    public String getCurrentEncodedUrlWithBase() {
    	return cov_user_utility.self.getCurrentEncodedUrlWithBase();
    }

    public String getCurrentEncodedUrlWithoutBase() {
    	return cov_user_utility.self.getCurrentEncodedUrlWithoutBase();
    }

    public String getPortalLoginBaseUrl() {
    	return cov_user_utility.self.getPortalLoginBaseUrl();
	}

    public Boolean getIsMobile() {
        return cov_user_utility.self.getIsMobile();
    }

}