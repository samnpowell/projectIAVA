@isTest
private class cov_login_controller_TESTS {

	
	
	private static testMethod void test_getInstancePrefix() {

		String pre = cov_login_controller.getInstancePrefix();
		system.assert(pre.left(2) == 'na' || pre.left(2) == 'cs');

	}
	
	
	private static testMethod void test_cov_Login() {
		User guestUser = cov_user_TEST_utility.getGuestUser();
		cov_login_controller controller = new cov_login_controller();
		Test.setCurrentPage(Page.cov_login);
		
		controller.username = 'user2123534234';
		controller.password = 'password';
		PageReference pRef;
		System.runAs(guestUser) {
			pRef = controller.communityLogin();
		}
		
		System.assertEquals(null, pRef);
		//System.assert(ApexPages.getMessages()[0].getSummary().contains('login attempt has failed'));
	}
	

	private static testMethod void loginTests_cov_login() {
		User guestUser = cov_user_TEST_utility.getGuestUser();
		cov_login_controller controller = new cov_login_controller();

		//Get site
		Site covSite = [select Id, UrlPathPrefix from Site where (MasterLabel Like '%Community of Veterans%' or MasterLabel Like '%COV%' or MasterLabel Like '%myIAVA%') and SiteType='ChatterNetwork'];

		// CASE: First test a bad username
		controller.username = 'badloginname@testuser23429598.org';
		controller.password = '134tuhaelkrjgnqpeoir';
		PageReference pRef;
		System.runAs(guestUser) {
			pRef = controller.communityLogin();
		}

		System.assertEquals(null, pRef);
		//System.assert(ApexPages.getMessages()[0].getSummary().contains('login attempt has failed'));


		// CASE: Now test a real username		
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u1 = testusers.getPortalUser();
		String testPwd = 'pwd12345';
		system.setPassword(u1.Id, testPwd);
		Contact c1 = testusers.getPortalContact();

		System.runAs(guestUser) {
			//PageReference pageRef = Page.cov_login; // just using a page to show whether logged in
			//pageRef.getParameters().put('startURL', EncodingUtil.urlEncode(covSite.UrlPathPrefix + '/cov_vouchees', 'UTF-8'));
	  // 		Test.setCurrentPage(pageRef);

			// Test with good password -- should pass it on through
	   		controller.username = u1.Username;
	   		controller.password = testPwd;
			pRef = controller.communityLogin();		
			System.debug('9 pRef: ' + pRef);  
			System.debug('UserInfo.getUserId() in unit test: ' + UserInfo.getUserId());
			// TODO - In test Site.login always seems to return null
			//System.assertNotEquals(null, pRef);
			//System.assertNotEquals('Guest', UserInfo.getUserType());
		}

		System.runAs(guestUser) {
			//PageReference pageRef = Page.cov_login; // just using a page to show whether logged in
			//pageRef.getParameters().put('startURL', EncodingUtil.urlEncode(covSite.UrlPathPrefix + '/cov_vouchees', 'UTF-8'));
	  // 		Test.setCurrentPage(pageRef);

	   		// User with permset but bad password
	   		controller.username = u1.Username;
	   		controller.password = 'wrongpwd';
			pRef = controller.communityLogin();		
			System.assertEquals(null, pRef);
			//System.assert(ApexPages.getMessages()[0].getSummary().contains('login attempt has failed'));
			//System.assertEquals('Your login attempt has failed. Make sure the username and password are correct.', controller.loginMsg);
			System.assertEquals('Guest', UserInfo.getUserType());

		}

		//	 delete the user's permset 
		PermissionSetAssignment psa = [select Id from PermissionSetAssignment 
			where AssigneeId = :u1.Id
			and PermissionSetId in (select Id from PermissionSet where Label like 'COV Access%')];
		delete psa;

		System.runAs(guestUser) {
			//PageReference pageRef = Page.cov_login; 
	  // 		Test.setCurrentPage(pageRef);

	   		//  test if no permset and not authorized - should get limited access error
	   		controller.username = u1.Username;
	   		controller.password = testPwd;
			pRef = controller.communityLogin();		
			//System.debug('99 pRef: ' + pRef);  // seemingly cant test login in unit test
			System.assertEquals(null, pRef);
			System.assert(controller.loginMsg.contains('access to myIAVA is currently limited'));
			System.assertEquals('Guest', UserInfo.getUserType());

		}

			System.assertEquals(false, cov_gateway_controller.alreadyHasPermissionSet(u1));
			// now authorize user and test login - user should get permset added
			COV_Access_Profile_Settings__c setting = new COV_Access_Profile_Settings__c(
				Name = 'Test Profile Setting',
				Authorized_member_categories__c = 'Confirmed',
				Prefix_for_COV_Access_Permission_Sets__c = 'COV Access'
				);
			insert setting;	
			c1.Paperwork_Confirmation__c = 'Paperwork Accepted';
			c1.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
			update c1;

		System.runAs(guestUser) {
			pRef = controller.communityLogin();		
			//System.debug('999 pRef: ' + pRef);  // seemingly cant test login in unit test
			//System.assertNotEquals('Guest', UserInfo.getUserType());
			System.assertEquals(true, cov_gateway_controller.alreadyHasPermissionSet(u1));
			// 9/2016 SD - changed for updated login code
			//System.assert(controller.loginMsg.contains('check your email for a temporary password'));
			//System.assertNotEquals(null, pRef);
			// TODO - In test Site.login always seems to return null

	   	}



	}

	
	private static testMethod void legacySignup_validation() {
		User guestUser = cov_user_TEST_utility.getGuestUser();
		cov_login_controller controller = new cov_login_controller();

		controller.agreeToTerms = true;
		System.runAs(guestUser) {
			controller.legacySignup();
		}
		System.assert(controller.signupMsg.contains('enter an email address'));

		controller.emailToReg = 'bad_email';
		System.RunAs(guestUser) {
			controller.legacySignup();		
		}
		System.assert(controller.signupMsg.contains('email address appears to be invalid'));
		
		controller.emailToReg = 'good_email+853@iava.org';
		controller.agreeToTerms = false;
		System.RunAs(guestUser) {
			controller.legacySignup();
		}
		System.assert(controller.signupMsg.contains('must agree to the terms'));


	}
	
	private static testMethod void signupWithEmailNotInSystem() {
		User guestUser = cov_user_TEST_utility.getGuestUser();
		cov_login_controller controller = new cov_login_controller();
		
		controller.emailToReg = 'email@doesnotexist.org';
		controller.oef = true;
		controller.oif = false;
		controller.ond = false;
		controller.agreeToTerms = true;
		System.RunAs(guestUser) {
			controller.legacySignup();
		}
		System.assert(controller.signupMsg.contains('access to myIAVA is currently limited'));
		
		Contact c = [select npe01__HomeEmail__c, Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, Veteran_Member__c
							, myIAVA_Pre_User_TOS_Accept_Date__c
						from Contact
						where Email = :controller.emailToReg];
		
		System.assertEquals(controller.emailToReg, c.npe01__HomeEmail__c);
		System.assertEquals(true, c.Veteran_of_OEF__c);
		System.assertEquals(false, c.Veteran_of_OIF__c);
		System.assertEquals(false, c.Veteran_of_OND__c);
		System.assertEquals(true, c.Veteran_Member__c);
		System.assertNotEquals(null, c.myIAVA_Pre_User_TOS_Accept_Date__c);

	}
	
	
	private static testMethod void signupUnconfirmedMember() {
		User guestUser = cov_user_TEST_utility.getGuestUser();
		createMember('UnconfirmedMember', 'test@unconfirmedMember.org', true, 'Paperwork Requested', false);
		
		// set access level to Confirmed
		COV_Access_Profile_Settings__c setting = new COV_Access_Profile_Settings__c(
			Name = 'Test Profile Setting',
			Authorized_member_categories__c = 'Confirmed',
			Prefix_for_COV_Access_Permission_Sets__c = 'COV Access'
			);
		insert setting;	

		// first test that a contact who doesnt match the access level doesnt get a license
		cov_login_controller controller = new cov_login_controller();
		
		controller.emailToReg = 'test@unconfirmedMember.org';
		controller.oef = false;
		controller.oif = false;
		controller.ond = true;
		controller.agreeToTerms = true;

		System.assertEquals(false, [select Veteran_of_OND__c from Contact where Email = 'test@unconfirmedMember.org'].Veteran_of_OND__c);
		
		System.RunAs(guestUser) {
			controller.legacySignup();
		}
		System.assertEquals(true, [select Veteran_of_OND__c from Contact where Email = 'test@unconfirmedMember.org'].Veteran_of_OND__c);
		System.assert(controller.signupMsg.contains('access to myIAVA is currently limited'));

		// open access to unconfirmed also
		setting.Authorized_member_categories__c = 'Confirmed; Unconfirmed';
		update setting;

		//next test that a contact who matches access but doesnt have basic fields filled out gets sent to join form
		System.assertEquals(0, [select Id from Contact where Email = 'test@unconfirmedMember2.org'].size());
		createMember('UnconfirmedMember2', 'test@unconfirmedMember2.org', true, 'Paperwork Requested', false);

		Contact c = [select FirstName, LastName, Email, MailingPostalCode
							, Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c
							, Veteran_of_Other_Era__c, Not_a_Veteran__c
						from Contact
						where Email = 'test@unconfirmedMember2.org'];
		c.FirstName = null;
		c.MailingPostalCode = '10012';
		update c;

		cov_login_controller controller2 = new cov_login_controller();

		controller2.emailToReg = 'test@unconfirmedMember2.org';
		controller2.oef = true;
		controller2.oif = false;
		controller2.ond = false;
		controller2.agreeToTerms = true;
		Test.setCurrentPage(Page.cov_login);
		PageReference pr;
		System.RunAs(guestUser) {
			pr = controller2.legacySignup();
		}
		System.assert(pr.getUrl().contains('iava.org'));
		System.assert(pr.getUrl().contains('join'));

		// and when basic fields are filled out the user does get a license
		c.FirstName = 'notblank';
		update c;
		System.RunAs(guestUser) {
			controller2.legacySignup();
		}
		System.assert(controller2.signupMsg.contains('check your email for a temporary password'));


	}

	private static testMethod void testExistingUsers() {
		User guestUser = cov_user_TEST_utility.getGuestUser();
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();

		cov_login_controller controller = new cov_login_controller();

		controller.emailToReg = u.username;
		controller.agreeToTerms = true;
		System.RunAs(guestUser) {
			controller.legacySignup();
}
		system.assert(controller.signupMsg.contains('you already have a myIAVA Login'));

		u.isActive = false;
		update u;

		// also test inactive user
		System.RunAs(guestUser) {
			controller.legacySignup();
		}
		system.assert(controller.signupMsg.contains('account is inactive'));

		// also test staff user
		User internalU = testusers.getInternalUser();
		controller.emailToReg = internalU.username;
		System.RunAs(guestUser) {
			controller.legacySignup();
		}
		system.assert(controller.signupMsg.contains('staff user'));

	}




	private static testMethod void signupWithNoAccountOwnerRole() {
		User guestUser = cov_user_TEST_utility.getGuestUser();
		ID profileId = [select Id from Profile where Name = 'Membership'].Id;
		User u = new User(Username = 'test@testuser.net', LastName = 'test@testuser.net', Email = 'test@testuser.net', Alias = 'tu1', TimeZoneSidKey = 'America/New_York',
							LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', ProfileId = profileId, LanguageLocaleKey = 'en_US',
							isActive = true);
		insert u;
		
		Account a = new Account(Name='TestAccount', OwnerId=u.Id);
		insert a;
		
		system.debug('ok create the contact');
		Contact c = new Contact(AccountId=a.Id, Email = 'test@confirmedMember.org', FirstName = 'Test', LastName = 'CreatePortalUser', Veteran_Member__c = true, Paperwork_Confirmation__c = 'Paperwork Accepted', Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND');
		c.MailingPostalCode = '10012';
		c.Approved_Date__c = Date.today();  // prevents Paperwork Accepted workflow from firing and checking Create Portal User
		insert c;

		// set access level to Confirmed
		COV_Access_Profile_Settings__c setting = new COV_Access_Profile_Settings__c(
			Name = 'Test Profile Setting',
			Authorized_member_categories__c = 'Confirmed',
			Prefix_for_COV_Access_Permission_Sets__c = 'COV Access'
			);
		insert setting;	

				
		//Test.setCurrentPage(Page.cov_login);
		cov_login_controller controller = new cov_login_controller();
		
		
		controller.emailToReg = 'test@confirmedMember.org';
		controller.oif = true;
		controller.agreeToTerms = true;
		System.RunAs(guestUser) {
			controller.legacySignup();
		}
		System.assert(controller.signupMsg.contains('problem activating your myIAVA'));
		System.assert(controller.signupMsg.contains('AccountOwnerRole'));

		// Avoid MixedDML error by wrapping in a System.runAs that explicitly uses the current user
		// See http://stackoverflow.com/questions/2387475/how-to-avoid-mixed-dml-operation-error-in-salesforce-tests-that-create-users
		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
		System.runAs ( thisUser ) {		
			ID roleId = [select Id from UserRole where Name = 'Robot'].Id;
			u.UserRoleId = roleId;
			update u;
		}

		controller.emailToReg = 'test@confirmedMember.org';
		System.RunAs(guestUser) {
			controller.legacySignup();
		}
		System.assert(controller.signupMsg.contains('check your email for a temporary password'));

	}

	private static testMethod void testLoggedInRedirect() {
		cov_login_controller controller = new cov_login_controller();
		PageReference initPr = controller.init();
		system.assertNotEquals(null, initPr);

		User guestUser = cov_user_TEST_utility.getGuestUser();
		System.runAs(guestUser) {
			cov_login_controller controller2 = new cov_login_controller();
			initPr = controller2.init();
			system.assertEquals(null, initPr);
		}
	}

	private static testMethod void testSecureRedirect() {
		User guestUser = cov_user_TEST_utility.getGuestUser();
		System.runAs(guestUser) {

			String startURL = 'cov_event?argument=monkeybrains';
			Test.setCurrentPage(new PageReference(Site.getBaseInsecureUrl() + 'cov_login?startURL=' + EncodingUtil.urlEncode(startURL, 'UTF-8') + '&fancy=knuckles'));
			cov_login_controller controller = new cov_login_controller();

			// first test without "switch" on
			system.assertEquals(null, controller.init());

			// now insert switch and test again
			insert new IAVA_switches__c(Name='myIAVA_secure_login_redirect', Disable__c = false);

			system.debug('Url.getCurrentRequestUrl() before: ' + Url.getCurrentRequestUrl());
			controller.init();
			system.debug('Url.getCurrentRequestUrl() after: ' + Url.getCurrentRequestUrl());
			// baseURL doesnt seem to work in unit test
			//system.assertEquals('https:', URL.getSalesforceBaseUrl().toExternalForm().left(6));
			String currentURL = ApexPages.currentPage().getUrl();
			system.assert(currentURL.contains(EncodingUtil.urlEncode(startURL, 'UTF-8')));
			system.assert(currentURL.contains('fancy=knuckles'));
		}
	}


	private static void createMember(String name, String email, Boolean isVeteran, String status, Boolean createPortalUser) {
		Contact c = new Contact(FirstName = 'Test', LastName = name, Email = email, Veteran_Member__c = isVeteran, Paperwork_Confirmation__c = status);
		if (status == 'Paperwork Accepted') {
			c.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		}
		if (!createPortalUser) {
			c.Approved_Date__c = Date.today();  // prevents Paperwork Accepted workflow from firing and checking Create Portal User
		}
		insert c;
		system.debug('just inserted test contact: ' + c);
	}
	
	//private static void createUser(String username) {
	//	ID profileId = [select Id from Profile where Name = 'Membership'].Id;
	//	User u = new User(Username = username, LastName = 'TestUser1', Email = username, Alias = 'tu1', TimeZoneSidKey = 'America/New_York',
	//						LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', ProfileId = profileId, LanguageLocaleKey = 'en_US',
	//						isActive = true);
	//	insert u;
	//}
	

	
}