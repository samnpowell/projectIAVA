public with sharing class cov_redirect_controller {
	public cov_redirect_controller() {
		
	}

	public PageReference init_dashboard() {
		if (UserInfo.getUserType() ==  'Standard') {
			return null;
		}

		IAVA_switches__c sw_disable_dashbord_redirect = IAVA_switches__c.getInstance('myIAVA_dashboard_redirect');
        Boolean redirectFromDashboard = sw_disable_dashbord_redirect == null || !sw_disable_dashbord_redirect.Disable__c ? true : false;

        if (redirectFromDashboard) {
			Contact c = cov_user_utility.self.getC();
			String memberCategories = c == null ? null : c.Member_Categories__c;
			Set<String> memberCats = memberCategories == null ? null : new Set<String>(memberCategories.split(';'));
			if (memberCats.contains('Confirmed') || memberCats.contains('Unconfirmed') || memberCats.contains('OtherEra')) {
				return null;
			} else {
				system.debug('Not authorized for dashboard, send instead to events page. member categories: ' + memberCategories);
				return Page.cov_events_central;
			}
		} else {
			return null;
		}
	}

	public String getEventsCentralPage() {
		if (cov_user_utility.self.isMobile()) {
			return 'cov_events_central_mobile';
		} else {
			return 'cov_events_central_full';			
		}
	}



}