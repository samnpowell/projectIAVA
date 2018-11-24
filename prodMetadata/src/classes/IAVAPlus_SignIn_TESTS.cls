public class IAVAPlus_SignIn_TESTS {}

//@isTest
//private class IAVAPlus_SignIn_TESTS {
	
//	////////// tests //////////
	
//	private static void createPortalSettings() {
//		IAVAPlus_Portal_Settings__c ps = new IAVAPlus_Portal_Settings__c();
//		ps.Name = 'IAVA';
//		ps.Portal_Account_Owner__c = 'exp@iava.org';
//		ps.Secure_Site_URL__c = cov_user_utility.IsProduction() ? 'https://iava.secure.force.com/iavaplus' : 'https://cov-iava.cs7.force.com/iavaplus';
//		ps.Secure_COV_URL__c = cov_user_utility.IsProduction() ? 'https://cov-iavadev.cs7.force.com/covtest' : 'https://cov-iavadev.cs7.force.com/covtest';
//		insert ps;
//	}
	
//	private static testMethod void testIAVAPlus_SignIn() {
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
		
//		// default portal account owner and secure site url when there is no custom settings
//		System.assertEquals('', controller.loginMsg);
//		// System.assertEquals('', controller.regMsg);
//		System.assertEquals('', controller.signupMsg);
//		System.assert( (controller.portalOwnerId == UserInfo.getUserId()) ||																// sandbox
//						([select UserName from User where Id = :controller.portalOwnerId].Username == 'backgroundadmin@iava.org') );		// production
//		System.assertEquals(null, controller.securePortalURL);
		
//		createPortalSettings();
//		controller = new IAVAPlus_SignIn();
		
//		// portal account owner and secure site url from custom settings
//		System.assertEquals('', controller.loginMsg);
//		// System.assertEquals('', controller.regMsg);
//		System.assertEquals('', controller.signupMsg);
//		System.assert( (controller.portalOwnerId == UserInfo.getUserId()) ||													// sandbox
//						([select UserName from User where Id = :controller.portalOwnerId].Username == 'exp@iava.org') );		// production
//		System.assert(controller.securePortalURL == 'https://iava.secure.force.com/iavaplus' || controller.securePortalURL == 'https://cov-iava.cs7.force.com/iavaplus');
//	}
	
//	//private static testMethod void testInit() {
//	//	IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
//	//	PageReference pRef = controller.init();
		
//	//	System.assertEquals(null, pRef);
//	//}
	
//	private static testMethod void testIavaPlusLogin() {
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
		
//		controller.username = 'user2123534234';
//		controller.password = 'password';
//		PageReference pRef = controller.iavaPlusLogin();
		
//		System.assertEquals(null, pRef);
//		System.assertEquals('Your login attempt has failed. Make sure the username and password are correct.', controller.loginMsg);
//	}
	

//	private static testMethod void loginTests_IAVAPlus() {
//		createPortalSettings();
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();

//		//Get sites
//		Site covSite = [select Id, UrlPathPrefix from Site where (MasterLabel Like '%Community of Veterans%' or MasterLabel Like '%COV%' or MasterLabel Like '%myIAVA%') and SiteType='ChatterNetwork'];
//		Site iavaplusSite = [select Id, UrlPathPrefix from Site where UrlPathPrefix = 'iavaplus'];

//		// CASE: First test a bad username
//		controller.username = 'badloginname@testuser23429598.org';
//		controller.password = '134tuhaelkrjgnqpeoir';
//		PageReference pRef = controller.iavaPlusLogin();
		
//		System.assertEquals(null, pRef);
//		System.assertEquals('Your login attempt has failed. Make sure the username and password are correct.', controller.loginMsg);


//		// CASE: Now test a real username		
//		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
//		User u1 = testusers.getPortalUser();
//		String testPwd = 'pwd12345';
//		system.setPassword(u1.Id, testPwd);
//		Contact c1 = testusers.getPortalContact();

//		User guestUser = [select Id from User where Name Like 'IAVA Plus%' and UserType = 'Guest' limit 1];
//		System.runAs(guestUser) {
//			PageReference pageRef = new PageReference(controller.securePortalURL + '/IAVAPlus_SignInPage'); // just using a page to show whether logged in
//			pageRef.getParameters().put('startURL', EncodingUtil.urlEncode(controller.securePortalURL + '/IAVAPlus_ForgotPassword', 'UTF-8')); //iavaplus address
//	   		Test.setCurrentPage(pageRef);

//	   		// First with bad password
//	   		controller.username = u1.Username;
//	   		controller.password = 'wrongpwd';
//			pRef = controller.iavaPlusLogin();		
//			System.assertEquals(null, pRef);
//			System.assertEquals('Your login attempt has failed. Make sure the username and password are correct.', controller.loginMsg);
//			System.assertEquals('Guest', UserInfo.getUserType());

//			// Then with good password -- should pass it on through
//	   		controller.username = u1.Username;
//	   		controller.password = testPwd;
//			pRef = controller.iavaPlusLogin();		
//System.debug('9 pRef: ' + pRef);  // TODO - In test Site.login always seems to return null
//			//System.assertEquals(Page.IAVAPlus_ForgotPassword.getUrl(), pRef.getUrl());
//			//System.assertNotEquals('Guest', UserInfo.getUserType());
//			System.debug('UserInfo.getUserId() in unit test: ' + UserInfo.getUserId());

//			//  else if they have the permset cross-site login to COV and send to dashboard or startURL
//			pageRef = new PageReference(controller.securePortalURL + '/IAVAPlus_SignInPage'); // just using a page to show whether logged in
//			pageRef.getParameters().put('startURL', EncodingUtil.urlEncode('%2Fiavaplus%2Fdc_ClaimReward%3Fgiveid%3Da0QM0000003J6GmMAK', 'UTF-8')); //iavaplus address
//	   		Test.setCurrentPage(pageRef);
//	   		controller.username = u1.Username;
//	   		controller.password = testPwd;
//			pRef = controller.iavaPlusLogin();
//			System.assertEquals('%2Fiavaplus%2Fdc_ClaimReward%3Fgiveid%3Da0QM0000003J6GmMAK', controller.unitTestStartUrl);

//		}

//		//	 else no permset 
//		PermissionSetAssignment psa = [select Id from PermissionSetAssignment 
//			where AssigneeId = :u1.Id
//			and PermissionSetId in (select Id from PermissionSet where Label like 'COV Access%')];
//		delete psa;

//		System.runAs(guestUser) {
//			PageReference pageRef = new PageReference(controller.securePortalURL); // no startURL, like new users
//	   		Test.setCurrentPage(pageRef);

//	   		//  test if no permset and not authorized - should go to IAVAPlus_Dashboard
//	   		controller.username = u1.Username;
//	   		controller.password = testPwd;
//			pRef = controller.iavaPlusLogin();		
//System.debug('99 pRef: ' + pRef);  // seemingly cant test login in unit test
//			//System.assertEquals(Page.IAVAPlus_Dashboard.getUrl(), pRef.getUrl());
//			//System.assertNotEquals('Guest', UserInfo.getUserType());
//			System.assertEquals('/IAVAPlus_Dashboard', controller.unitTestStartUrl);

//		}

//			// now authorize user and test login - should go to cov_gateway
//			COV_Access_Profile_Settings__c setting = new COV_Access_Profile_Settings__c(
//				Name = 'Test Profile Setting',
//				Authorized_member_categories__c = 'Confirmed',
//				Prefix_for_COV_Access_Permission_Sets__c = 'COV Access'
//				);
//			insert setting;	
//			c1.Paperwork_Confirmation__c = 'Paperwork Accepted';
//			c1.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
//			update c1;

//		System.runAs(guestUser) {
//			pRef = controller.iavaPlusLogin();		
//System.debug('999 pRef: ' + pRef);  // seemingly cant test login in unit test
//			//System.assertEquals(Page.cov_gateway.getUrl(), pRef.getUrl());
//			//System.assertNotEquals('Guest', UserInfo.getUserType());
//			System.assertEquals('/cov_gateway', controller.unitTestStartUrl.left(12));

//	   	}



//	}


//	private static testMethod void loginTests_COV() {
//		createPortalSettings();
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();


//		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
//		User u1 = testusers.getPortalUser();
//		String testPwd = 'pwd12345';
//		system.setPassword(u1.Id, testPwd);
//		Contact c1 = testusers.getPortalContact();

//		//Get site
//		Site covSite = [select Id, UrlPathPrefix from Site where (MasterLabel Like '%Community of Veterans%' or MasterLabel Like '%COV%' or MasterLabel Like '%myIAVA%') and SiteType='ChatterNetwork'];

//		User guestUser = [select Id from User where Name Like 'IAVA Plus%' and UserType = 'Guest' limit 1];
//		System.runAs(guestUser) {
//			PageReference pageRef = new PageReference(controller.secureCOVURL + '/cov_login');
//	   		Test.setCurrentPage(pageRef);

//	   		//u1 should have the permission set.  if they have permset, go on through
//	   		controller.username = u1.Username;
//	   		controller.password = testPwd;
//	   		PageReference pRef = controller.iavaPlusLogin();	
//	   		System.assertEquals(null, controller.unitTestStartURL);

//	   	}

//	   	//	 if no permset cross-site login to iavaplus gateway 
//		PermissionSetAssignment psa = [select Id from PermissionSetAssignment 
//			where AssigneeId = :u1.Id
//			and PermissionSetId in (select Id from PermissionSet where Label like 'COV Access%')];
//		delete psa;

//		System.runAs(guestUser) {
//			PageReference pageRef = new PageReference(controller.secureCOVURL); 
//	   		Test.setCurrentPage(pageRef);

//	   		controller.username = u1.Username;
//	   		controller.password = testPwd;
//			PageReference pRef = controller.iavaPlusLogin();
//			System.assertEquals('&startURL=%2Fcov_gateway', controller.unitTestStartUrl);


//	   	}




//	}



	
//	private static testMethod void signupWithInvalidEmail() {
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
		
//		controller.emailToReg = 'bad_email';
//		controller.signup();
		
//		System.assertEquals('Please enter a valid email address.', controller.signupMsg);
//	}
	
//	private static testMethod void signupWithEmailNotInSystem() {
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
		
//		controller.emailToReg = 'email@doesnotexist.org';
//		controller.oef = true;
//		controller.oif = false;
//		controller.ond = false;
//		controller.signup();
		
//		System.assertEquals('', controller.signupMsg);
//		System.assertEquals('tfa_OEFAfghanistan1', controller.oef_val);
//		System.assertEquals('', controller.oif_val);
//		System.assertEquals('', controller.ond_val);
//		System.assert(controller.pName.startsWith(System.Label.dc_MemberSignupURLStep1));
//		System.assert(controller.pName.contains('Welcome%21+Fill+out+this+signup+form+to+get+your+IAVA+Plus+account'));

		
//		Contact c = [select npe01__HomeEmail__c, Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, Veteran_Member__c
//						from Contact
//						where Email = 'email@doesnotexist.org'];
		
//		System.assertEquals('email@doesnotexist.org', c.npe01__HomeEmail__c);
//		System.assertEquals(true, c.Veteran_of_OEF__c);
//		System.assertEquals(false, c.Veteran_of_OIF__c);
//		System.assertEquals(false, c.Veteran_of_OND__c);
//		System.assertEquals(true, c.Veteran_Member__c);
//	}
	
//	private static testMethod void signupNonMember() {
//		//createMember('Nonmember', 'test@nonmember.org', false, null, false);
		
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
		
//		controller.emailToReg = 'test@nonmember.org';
//		controller.oef = false;
//		controller.oif = true;
//		controller.ond = false;
//		controller.signup();
		
//		System.assertEquals('', controller.signupMsg);
//		System.assertEquals('', controller.oef_val);
//		System.assertEquals('tfa_OIFIraq', controller.oif_val);
//		System.assertEquals('', controller.ond_val);
//		System.assert(controller.pName.startsWith(System.Label.dc_MemberSignupURLStep1));
//		System.assert(controller.pName.contains('Welcome%21+Fill+out+this+signup+form+to+get+your+IAVA+Plus+account'));

//		Contact c = [select npe01__HomeEmail__c, Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, Veteran_Member__c
//						from Contact
//						where Email = 'test@nonmember.org'];
		
//		System.assertEquals(false, c.Veteran_of_OEF__c);
//		System.assertEquals(true, c.Veteran_of_OIF__c);
//		System.assertEquals(false, c.Veteran_of_OND__c);
//		System.assertEquals(true, c.Veteran_Member__c);
//	}
	
//	private static testMethod void signupUnconfirmedMember() {
//		createMember('UnconfirmedMember', 'test@unconfirmedMember.org', true, 'Paperwork Requested', false);
		
//		// first test that a contact who hasn't filled out form1 gets directed to Form1

//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
		
//		controller.emailToReg = 'test@unconfirmedMember.org';
//		controller.oef = false;
//		controller.oif = false;
//		controller.ond = true;
//		controller.signup();
		
//		System.assertEquals('', controller.signupMsg);
//		System.assertEquals('', controller.oef_val);
//		System.assertEquals('', controller.oif_val);
//		System.assertEquals('tfa_ONDIraq', controller.ond_val);
//		System.assert(controller.pName.startsWith(System.Label.dc_MemberSignupURLStep1));
//		System.assert(controller.pName.contains('Welcome%21+Fill+out+this+signup+form+to+get+your+IAVA+Plus+account'));


//		//next test that a contact who has already filled out form1 gets a license
//		System.assertEquals(0, [select Id from Contact where Email = 'test@unconfirmedMember2.org'].size());

//		createMember('UnconfirmedMember2', 'test@unconfirmedMember2.org', true, 'Paperwork Requested', false);

//		Contact c = [select Submitted_Application__c
//						from Contact
//						where Email = 'test@unconfirmedMember2.org'];
//		c.Submitted_Application__c = true;
//		update c;

//		IAVAPlus_SignIn controller2 = new IAVAPlus_SignIn();

//		controller2.emailToReg = 'test@unconfirmedMember2.org';
//		controller2.oef = true;
//		controller2.oif = false;
//		controller2.ond = true;
//		Test.setCurrentPage(Page.IAVAPlus_SignInPage);
//		controller2.signup();

//		System.debug('controller2.pName: ' + controller2.pName);

//		//System.assert(controller2.pName.startsWith(System.Label.dc_MemberSignupURLStep2));
//		//System.assert(controller2.pName.contains('We+have+you+in+our+system+as+an+unconfirmed+member.++Upload+your+paperwork+as+described+below+to+confirm+your+membership'));
//		System.assertEquals('Please check your email for a temporary IAVA Plus password.', controller2.signupMsg);
//		System.assertEquals(null, controller2.oef_val);
//		System.assertEquals(null, controller2.oif_val);
//		System.assertEquals(null, controller2.ond_val);
//		System.assertEquals(' ', controller2.pName);



//	}


//	private static testMethod void signupSupporter() {

//		// first test previously existing supporter

//		String contactEmail = 'test@iavasupporter1.org';
//		createMember('Supporter', contactEmail, false, null, false);

//		Contact c = [select Submitted_Supporter_Form__c
//						from Contact
//						where Email = :contactEmail];
//		c.Submitted_Supporter_Form__c = true;
//		update c;

//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();

//		controller.emailToReg = contactEmail;
//		controller.oef = false;
//		controller.oif = false;
//		controller.ond = false;
//		Test.setCurrentPage(Page.IAVAPlus_SignInPage);
//		controller.signup();

//		System.debug('controller.pName: ' + controller.pName);

//		//System.assert(controller.pName.startsWith(System.Label.dc_MemberSignupURLStep2));
//		//System.assert(controller.pName.contains('We+have+you+in+our+system+as+an+unconfirmed+member.++Upload+your+paperwork+as+described+below+to+confirm+your+membership'));
//		System.assertEquals('', controller.oef_val);
//		System.assertEquals('', controller.oif_val);
//		System.assertEquals('', controller.ond_val);
//		System.assert(controller.pName.contains('become-supporter'));
//		System.assertEquals(true, [select Id, User_Initiated_Login__c from Contact where Id = :c.Id].User_Initiated_Login__c);


//		// now try a brand new contact

//		IAVAPlus_SignIn controller2 = new IAVAPlus_SignIn();

//		contactEmail = 'test@iavabrandnewsupporter1.org';
//		controller2.emailToReg = contactEmail;
//		controller2.oef = false;
//		controller2.oif = false;
//		controller2.ond = false;
//		Test.setCurrentPage(Page.IAVAPlus_SignInPage);
//		controller2.signup();

//		System.debug('controller2.pName: ' + controller2.pName);

//		//System.assert(controller2.pName.startsWith(System.Label.dc_MemberSignupURLStep2));
//		//System.assert(controller2.pName.contains('We+have+you+in+our+system+as+an+unconfirmed+member.++Upload+your+paperwork+as+described+below+to+confirm+your+membership'));
//		System.assertEquals('', controller2.oef_val);
//		System.assertEquals('', controller2.oif_val);
//		System.assertEquals('', controller2.ond_val);
//		List<Contact> c2 = [select Id from Contact where Email = :contactEmail];
//		System.assertEquals(1, c2.size());
//		System.assert(controller2.pName.contains('become-supporter'));
//		System.assertEquals(true, [select Id, User_Initiated_Login__c from Contact where Id = :c2[0].Id].User_Initiated_Login__c);



//	}


	
//	private static testMethod void signupConfirmedMember() {
//		createMember('ConfirmedMember', 'test@confirmedMember.org', true, 'Paperwork Accepted', false);
		
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
		
//		controller.emailToReg = 'test@confirmedMember.org';
//		controller.oef = false;
//		controller.oif = false;
//		controller.ond = true;
//		Test.setCurrentPage(Page.IAVAPlus_SignInPage);
//		controller.signup();
		
//		// no portal login
//		System.assertEquals('Please check your email for a temporary IAVA Plus password.', controller.signupMsg);
//		System.assertEquals(null, controller.oef_val);
//		System.assertEquals(null, controller.oif_val);
//		System.assertEquals(null, controller.ond_val);
//		System.assertEquals(' ', controller.pName);
		
//		Contact c = [select Id, Email, FirstName, LastName from Contact where Email = 'test@confirmedMember.org'];
		
//		PortalUserProvisioning.createPortalUsers(new List<Contact> { c });
		
//		controller.signup();
		
//		// active portal login
//		System.assert(controller.signupMsg.contains('Looks like you already have an IAVA Plus Login.'));
//		System.assertEquals(null, controller.oef_val);
//		System.assertEquals(null, controller.oif_val);
//		System.assertEquals(null, controller.ond_val);
//		System.assertEquals(' ', controller.pName);
		
//		// Avoid MixedDML error by wrapping in a System.runAs that explicitly uses the current user
//		// See http://stackoverflow.com/questions/2387475/how-to-avoid-mixed-dml-operation-error-in-salesforce-tests-that-create-users
//		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
//		System.runAs ( thisUser ) {		
//			User u = [select Id from User where ContactId = :c.Id];
//			u.isActive = false;
//			update u;
//		}
		
//		controller.signup();
		
//		// inactive portal login
//		System.assertEquals('Your account is inactive. Contact membership@iava.org for assistance.', controller.signupMsg);
//		System.assertEquals(null, controller.oef_val);
//		System.assertEquals(null, controller.oif_val);
//		System.assertEquals(null, controller.ond_val);
//		System.assertEquals(' ', controller.pName);
//	}
	
//	private static testMethod void signupConfirmedMemberWithExistingSFUser() {
//		createMember('ConfirmedMember', 'test@confirmedMember.org', true, 'Paperwork Accepted', false);
//		createUser('test@confirmedMember.org');
		
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
		
//		controller.emailToReg = 'test@confirmedMember.org';
//		controller.signup();
		
//		System.assertEquals('This email is already in use by another Salesforce user record. Use the alternate link to sign in.', controller.signupMsg);
//		System.assertEquals(null, controller.oef_val);
//		System.assertEquals(null, controller.oif_val);
//		System.assertEquals(null, controller.ond_val);
//		System.assertEquals(' ', controller.pName);
//	}


//	private static testMethod void signupWithNoAccountOwnerRole() {
//		ID profileId = [select Id from Profile where Name = 'Membership'].Id;
//		User u = new User(Username = 'test@testuser.net', LastName = 'test@testuser.net', Email = 'test@testuser.net', Alias = 'tu1', TimeZoneSidKey = 'America/New_York',
//							LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', ProfileId = profileId, LanguageLocaleKey = 'en_US',
//							isActive = true);
//		insert u;
		
//		Account a = new Account(Name='TestAccount', OwnerId=u.Id);
//		insert a;
		
//		Contact c = new Contact(AccountId=a.Id, Email = 'test@confirmedMember.org', FirstName = 'Test', LastName = 'CreatePortalUser', Veteran_Member__c = true, Paperwork_Confirmation__c = 'Paperwork Accepted', Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND');
//		insert c;
				
//		Test.setCurrentPage(Page.IAVAPlus_SignInPage);
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
		
		
//		controller.emailToReg = 'test@confirmedMember.org';
//		controller.signup();
		
//		System.assertEquals('Sorry there was a problem activating your IAVA plus login. Please contact membership@iava.org and mention error code "AccountOwnerRole".', controller.signupMsg);

//		// Avoid MixedDML error by wrapping in a System.runAs that explicitly uses the current user
//		// See http://stackoverflow.com/questions/2387475/how-to-avoid-mixed-dml-operation-error-in-salesforce-tests-that-create-users
//		User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
//		System.runAs ( thisUser ) {		
//			ID roleId = [select Id from UserRole where Name = 'Robot'].Id;
//			u.UserRoleId = roleId;
//			update u;
//		}

//		controller.emailToReg = 'test@confirmedMember.org';
//		controller.signup();
		
//		System.assertEquals('Please check your email for a temporary IAVA Plus password.', controller.signupMsg);

//	}

//	private static testMethod void signinUnconfirmedWithPortalUser() {
//		createMember('UnconfirmedMember', 'test@unconfirmedMember.org', true, 'Paperwork Requested', false);
////		createUser('test@unconfirmedMember.org');

//		Test.setCurrentPage(Page.IAVAPlus_SignInPage);
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
		
//		Contact c = [select Id, Email, FirstName, LastName, Veteran_Member__c, Branch_of_Service__c,
//			Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, myIAVA_Pre_User_TOS_Accept_Date__c
//			from Contact where Email = 'test@unconfirmedMember.org'];
//		PortalUserProvisioning.createPortalUsers(new List<Contact> { c });
		
//		controller.emailToReg = 'test@unconfirmedMember.org';
//		controller.signup();

//		// active portal login
//		System.assert(controller.signupMsg.contains('Looks like you already have an IAVA Plus Login.'));

//	}

	
//	private static void createMember(String name, String email, Boolean isVeteran, String status, Boolean createPortalUser) {
//		Contact c = new Contact(FirstName = 'Test', LastName = name, Email = email, Veteran_Member__c = isVeteran, Paperwork_Confirmation__c = status);
//		if (status == 'Paperwork Accepted') {
//			c.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
//		}
//		if (!createPortalUser) {
//			c.Approved_Date__c = Date.today();  // prevents Paperwork Accepted workflow from firing and checking Create Portal User
//		}
//		insert c;
//		system.debug('just inserted test contact: ' + c);
//	}
	
//	private static void createUser(String username) {
//		ID profileId = [select Id from Profile where Name = 'Membership'].Id;
//		User u = new User(Username = username, LastName = 'TestUser1', Email = username, Alias = 'tu1', TimeZoneSidKey = 'America/New_York',
//							LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', ProfileId = profileId, LanguageLocaleKey = 'en_US',
//							isActive = true);
//		insert u;
//	}
	
//	private static testMethod void testHelperMethods() {
//		IAVAPlus_SignIn controller = new IAVAPlus_SignIn();
		
//		controller.setEmail('test_email');
//		System.assertEquals('test_email', controller.getEmail());
		
//		controller.setEmailToReg('test_reg_email');
//		System.assertEquals('test_reg_email', controller.getEmailToReg());
		
//		controller.setPassword('test_password');
//		System.assertEquals('test_password', controller.getPassword());
		
//		controller.setPName('test_url');
//		System.assertEquals('test_url', controller.getPName());
		
//		controller.setUsername('test_user');
//		System.assertEquals('test_user', controller.getUsername());
		
//		ApexPages.currentPage().getHeaders().put('USER-AGENT', 'Mac');
//		System.assertEquals('true', controller.getMacos());
//		System.assertEquals('none', controller.getoldieversion());
//	}
	
//}