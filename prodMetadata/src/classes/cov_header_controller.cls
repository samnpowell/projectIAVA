public with sharing class cov_header_controller {

    public static User u;

	public Boolean hasAdminPrivileges {set;}

    public Integer unreadMessageCount {get; set;}
    public Boolean hasUnreadMessages {get; set;}

	public cov_header_controller() {
        unreadMessageCount = ConnectApi.ChatterMessages.getUnreadCount(cov_user_utility.self.getNetworkId()).unreadCount;
        hasUnreadMessages = unreadMessageCount > 0 ? true : false;
    }

    public User getU() {
        if (u == null) {
			u = cov_user_utility.self.getU();
        }
        return u;
    }

    public Boolean getHasAdminPrivileges() {
    	return cov_gateway_controller.alreadyHasPermissionSet('COV Admin');
    }

    public Boolean getIsMobile() {
        return cov_user_utility.self.getIsMobile();
    }

    public Boolean getShowFacebookLogin() {
        IAVA_switches__c sw = IAVA_switches__c.getInstance('myIAVA_show_facebook_login');
        return sw != null && !sw.Disable__c ? true : false;
    }

}