/**
 * An apex page controller that exposes the site forgot password functionality
 */
public class IAVAPlus_ForgotPasswordController {

	public String username { get; set; }
	
	public IAVAPlus_ForgotPasswordController() {}
	
	public PageReference forgotPassword() {
		
		String startUrl = ApexPages.currentPage().getParameters().get('startUrl');
		PageReference pr = Page.IAVAPlus_ForgotPasswordConfirm;
		if (startUrl != '') pr.getParameters().put('startUrl', startUrl);
		pr.setRedirect(true);
		
		// provision license for confirmed member with no IAVAPlus login
		System.debug('username: ' + username);
		if (String.isNotBlank(username)) {
System.debug('1');
			List<User> users = [select Id from User where Username = :username and IsActive = true and isPortalEnabled = true];
System.debug('2');
			if (users.isEmpty()) {		// no IAVAPlus login
System.debug('3');
				try {
System.debug('4');
					Contact c = [select Email, Veteran_Member__c, Veteran_Member_Status__c, Create_Portal_User__c, Account.OwnerId from Contact
						where (Email = :username or npe01__HomeEmail__c = :username or npe01__WorkEmail__c = :username or npe01__AlternateEmail__c = :username)
						order by Veteran_Member_Status__c ASC NULLS LAST
						limit 1];
System.debug('5');
					if (c.Veteran_Member__c == true && c.Veteran_Member_Status__c == 'Confirmed') {		// confirmed member
System.debug('6');
						List<User> accountOwner = [select UserRoleId from User where Id = :c.Account.OwnerId];
						if (!accountOwner.isEmpty() && accountOwner[0].UserRoleId != null) {			// make sure account owner has a role
							if (c.Create_Portal_User__c == true) {		// reset flag to cause license provisioning trigger to fire
								c.Create_Portal_User__c = false;
								update c;
							}
							// provision a portal license
							c.Create_Portal_User__c = true;
							update c;
							
							return pr;
						}
					}
				} catch (Exception e) {
					System.debug('>>>>>>>>>> forgotPassword: ' + e.getMessage());
				}
			}
		}
		
		// go to Site password reset for all other cases:
		//	1) reset password if IAVAPlus login exists
		//	2) standard error handling for
		//		a) no IAVAPlus login, not a confirmed member (with or without contact record)
		//		b) no IAVAPlus login, confirmed member but cannot auto provision license because account owner missing role
		//		c) missing username
		Boolean success = Site.forgotPassword(username);
		
		if (success) {
			return pr;
		} else {
			return null;
		}
	}
	
	/*
	 * tests
	 */
	
	static testMethod void testForgotPasswordController() {
		// Instantiate a new controller with all parameters in the page
		IAVAPlus_ForgotPasswordController controller = new IAVAPlus_ForgotPasswordController();
		controller.username = 'test@salesforce.com';
		
		System.assertEquals(null, controller.forgotPassword()); 
	}
	
	static testMethod void licenseProvisionedForConfirmedMember() {
		IAVA_Rewards_Settings__c irs = new IAVA_Rewards_Settings__c(Name = 'Main', Last_Member_ID__c = '12345678');
		insert irs;
		
		Contact c = new Contact(FirstName = 'Confirmed', LastName = 'Member', Email = 'test@confirmedmember.org', 
								Veteran_Member__c = true, Paperwork_Confirmation__c = 'Paperwork Accepted');
//		c.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		c.Paperwork_Confirmation_Type__c = 'Dummyvalue'; // not using deployed avoids triggering the workflow which sets Create Portal User and bonks the test
		insert c;
		
		IAVAPlus_ForgotPasswordController controller = new IAVAPlus_ForgotPasswordController();
		controller.username = 'test@confirmedmember.org';
		
		PageReference pr = controller.forgotPassword();
		
		System.assertEquals(Page.IAVAPlus_ForgotPasswordConfirm.getUrl(), pr.getUrl());
		System.assertEquals(true, [select Create_Portal_User__c from Contact where Id = :c.Id].Create_Portal_User__c);
	}
	
	static testMethod void noLicenseProvisionedForUnconfirmedMember() {
		IAVA_Rewards_Settings__c irs = new IAVA_Rewards_Settings__c(Name = 'Main', Last_Member_ID__c = '12345678');
		insert irs;
		
		Contact c = new Contact(FirstName = 'Confirmed', LastName = 'Member', Email = 'test@confirmedmember.org', 
								Veteran_Member__c = true, Paperwork_Confirmation__c = 'Paperwork Requested', Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND');
		insert c;
		
		IAVAPlus_ForgotPasswordController controller = new IAVAPlus_ForgotPasswordController();
		controller.username = 'test@confirmedmember.org';
		
		PageReference pr = controller.forgotPassword();
		
		System.assertEquals(null, pr);
		System.assertEquals(false, [select Create_Portal_User__c from Contact where Id = :c.Id].Create_Portal_User__c);
	}
	
}