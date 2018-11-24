@isTest
private class cov_user_utility_TESTS {

	//TODO: The first two are actually only tests for the cov_user_TEST_utility, should be broken out separately
	
	@isTest static void test_user_utility() {
		

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();

			System.debug('UserInfo.getUserId(): ' + UserInfo.getUserId());
			System.assertEquals(u.Id, cov_user_utility.self.getU().Id);
			System.assertEquals(c.Id, cov_user_utility.self.getC().Id);

		}

	}
	

	@isTest static void test_user_utility_internal() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u2 = testusers.getInternalUser();
		Contact c2 = testusers.getInternalContact();

		System.RunAs(u2) {
			cov_user_utility.self.refreshSelf();

			System.assertEquals(u2.Id, cov_user_utility.self.getU().Id);
			System.assertEquals(c2.Id, cov_user_utility.self.getC().Id);

		}

	}

	@isTest static void test_user_contact_map_and_email_methods() {

		cov_user_TEST_utility testusers1 = new cov_user_TEST_utility();
		Contact c1 = testusers1.getPortalContact();
		User u1 = testusers1.getPortalUser();

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		Contact c2 = testusers2.getPortalContact();
		User u2 = testusers2.getPortalUser();

		cov_user_TEST_utility testusers3 = new cov_user_TEST_utility();
		Contact c3 = testusers3.getPortalContact();
		User u3 = testusers3.getPortalUser();

		c1.Email = 'testc1@iava.org';
		c2.Email = 'testc2@iava.org';
		c3.Email = 'testc3@iava.org';
		update new List<Contact>{c1, c2, c3};

		Set<Id> contactIds = new Set<Id>();
		contactIds.add(c1.Id);
		contactIds.add(c2.Id);
		contactIds.add(c3.Id);


		Map<Id, Id> theMap;

		System.RunAs(u1) {
			theMap = cov_user_contact_utility.getContactIdToUserIdMap(contactIds);
		}

		System.assertEquals(u1.Id, theMap.get(c1.Id));
		System.assertEquals(u2.Id, theMap.get(c2.Id));
		System.assertEquals(u3.Id, theMap.get(c3.Id));

		List<Contact> returnCs;
		System.RunAs(u1) {
			returnCs = cov_user_contact_utility.getContactsFromEmail(c1.Email);
		}

		System.assertEquals(c1.Id, returnCs[0].Id);

		c1.Description = 'additional field';
		update c1;

		System.RunAs(u1) {
			returnCs = cov_user_contact_utility.getContactsFromEmail(c1.Email, new List<String>{'Description'});
		}

		System.assertEquals(c1.Description, returnCs[0].Description);



		Set<String> emailStrings = new Set<String>();
		emailStrings.add(c2.Email);

		System.RunAs(u1) {
			returnCs = cov_user_contact_utility.getContactsFromEmails(emailStrings);
		}

		System.assertNotEquals(c1.Email, c2.Email);
		System.assertNotEquals(c1.Email, c3.Email);
		System.assertNotEquals(c2.Email, c3.Email);
		System.assertEquals(c2.Id, returnCs[0].Id);


		// also make sure we can query for additional fields and query for multiple contacts
		c3.Description = 'Here is an additional field';
		update c3;
		emailStrings.add(c3.Email);
		System.RunAs(u1) {
			returnCs = cov_user_contact_utility.getContactsFromEmails(emailStrings, new List<String>{'Email', 'Description'});
		}

		System.assertEquals(2, returnCs.size());
		Integer index;
		if (returnCs[0].Id == c3.Id) index = 0;
		else if (returnCs[1].Id == c3.Id) index = 1;
		else system.assertEquals(false, true, 'c3 should have been in the returned contacts');

		system.assertEquals(c3.Description, returnCs[index].Description);


	}



	// commented out when this Override Contact feature was torn back out
	//@isTest static void test_user_utility_external_overridden() {
		

	//	cov_user_TEST_utility testusers = new cov_user_TEST_utility();
	//	User u = testusers.getPortalUser();
	//	Contact c = testusers.getPortalContact();

	//	System.RunAs(u) {
	//		cov_user_utility.self.refreshSelf();

	//		System.debug('UserInfo.getUserId(): ' + UserInfo.getUserId());
	//		System.assertEquals(u.Id, cov_user_utility.self.getU().Id);
	//		System.assertEquals(c.Id, cov_user_utility.self.getC().Id);

	//	}

	//	u.Override_associated_Contact__c = true;
	//	update u;
	//	c.Portal_User__c = null;
	//	update c;

	//	System.RunAs(u) {
	//		cov_user_utility.self.refreshSelf();

	//		System.assertEquals(u.Id, cov_user_utility.self.getU().Id);
	//		System.assertEquals(null, cov_user_utility.self.getC());

	//	}

	//	Contact c2 = new Contact(LastName='Test', Portal_User__c=u.Id);
	//	insert c2;

	//	System.RunAs(u) {
	//		cov_user_utility.self.refreshSelf();

	//		System.assertEquals(u.Id, cov_user_utility.self.getU().Id);
	//		System.assertEquals(c2.Id, cov_user_utility.self.getC().Id);

	//	}


	//}	


	
}