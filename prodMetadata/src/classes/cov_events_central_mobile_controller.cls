public with sharing class cov_events_central_mobile_controller {


	public String selectedTab {get; set;}

	public cov_events_central_mobile_controller() {
		selectedTab = ApexPages.CurrentPage().getParameters().get('tab');
		if (String.isBlank(selectedTab)) {
			selectedTab = 'AllEvents';
		}
	}

    public Boolean getIsMobile() {
        return cov_user_utility.self.getIsMobile();
    }

	public Boolean isSandbox {
		get {
			return cov_user_utility.self.getIsSandbox();
		}
	}




}