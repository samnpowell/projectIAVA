@isTest
private class cov_facebook_reghandler_TESTS {
	
	static Auth.UserData createUserData(String emailIn) {
		Auth.UserData data = new Auth.UserData('testId', 'testFirst', 'testLast',
        	'testFirst testLast', emailIn, null, 'testuserlong', 'en_US', 'facebook',
        	null, new Map<String, String>{'language' => 'en_US'});
        return data;
	}
	
	static void testExceptionOnCreate(cov_facebook_reghandler handler, User runAsUser, Auth.UserData data, String exceptionFragment) {
		System.runAs(runAsUser) {
			User u;
			try {
				u = handler.createUser(null, data);
				System.assert(false, 'Exception expected');
			} catch (cov_facebook_reghandler.MyException e) {
				System.assert(e.getMessage().contains(exceptionFragment));
				System.assertEquals(null, u);
			}
		}

	}




	static testMethod void testCreateUser() {
	    cov_facebook_reghandler handler = new cov_facebook_reghandler();
	    User badmintonRobot = [select Id from User where Name = 'Background Admin Robot' limit 1];

	    String email1 = 'test1@unittest.iava.org';

	    Auth.UserData data1 = createUserData(email1);

	    User u;

		Test.startTest();

	    // no matching user or contact, so reject the login
	    testExceptionOnCreate(handler, badmintonRobot, data1, 'can\'t find anyone in our system with the email address on your Facebook account');
	    
	    cov_user_TEST_utility testusers1 = new cov_user_TEST_utility();
		User internalU1 = testusers1.getInternalUser();
	    internalU1.Email = email1;
	    update internalU1;

	    // staff user should get directed to staff login link
	    testExceptionOnCreate(handler, badmintonRobot, data1, 'Staff users should use the staff link');

	    cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User portalU1 = testusers2.getPortalUser();
	    portalU1.Email = email1;
	    System.runAs(badmintonRobot) {
		    update portalU1;
		}

	    // portal user should get precedence and it should work
		u = handler.createUser(null, data1);
		system.assertEquals(portalU1.Id, u.Id);


		// set access profile settings
		COV_Access_Profile_Settings__c setting = cov_gateway_controller_TESTS.setTheSetting();
		system.assertEquals('Confirmed', setting.Authorized_member_categories__c);


	    String email2 = 'test2@unittest.iava.org';

		Contact c2 = new Contact(LastName = 'Tester', Email = email2);
		insert c2;

	    Auth.UserData data2 = createUserData(email2);


	    // contact isn't authorized to join 
	    testExceptionOnCreate(handler, badmintonRobot, data2, 'myIAVA access is limited at this time');

	    setting.Authorized_member_categories__c = 'Everyone';
	    update setting;

	    User queriedU;
	    try {
		    queriedU = [select Id from User where Email = :email2 limit 1];
		    System.assert(false, 'Exception expected');
	    } catch (System.QueryException e) {
		    System.assertEquals(null, queriedU);
		}

		// no existing user on Contact so one should get provisioned and returned
		system.debug('ok now test one that works');
	    u = handler.createUser(null, data2);

		queriedU = [select Id from User where Email = :email2 limit 1];
	    System.assertEquals(queriedU.Id, u.Id);


	    Test.stopTest(); // allows transaction to stop so future method can complete to fill in Portal_User__c

	    u.Email = 'different-' + email2;
	    system.runAs(badmintonRobot) {
		    update u;
		}

	    // now test case where there was already a portal user on the contact with a different email
	    u = handler.createUser(null, data2);
	    System.assertEquals(queriedU.Id, u.Id);


	    // now remove permset and make sure it gets added on login for authorized user
		PermissionSetAssignment psa = [select Id from PermissionSetAssignment 
			where AssigneeId = :u.Id
			and PermissionSetId in (select Id from PermissionSet where Label like 'COV Access%')];
		system.runAs(badmintonRobot) {
			delete psa;
		}
	    u = handler.createUser(null, data2);
	    System.assertEquals(queriedU.Id, u.Id);


	    // now test inactive user
	    u.isActive = false;
	    system.runAs(badmintonRobot) {
		    update u;
		}
		system.debug('user is inactive?: u.isActive:' + [select isActive from User where Id = :u.Id].isActive);
	    testExceptionOnCreate(handler, badmintonRobot, data2, 'appears to be inactive');





	}



	
}