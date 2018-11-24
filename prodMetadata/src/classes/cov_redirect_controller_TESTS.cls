@isTest
private class cov_redirect_controller_TESTS {
	
	@isTest static void test_init_dashbord() {
		

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();


		PageReference pr;

		// Non-veterans should get directed to events
		confirmMemberCategories(queryContact(c.Id).Member_Categories__c, false, false, false, false, true);
		testRedirect(u, c, 'cov_events_central');

		c.Veteran_Family_Member__c = true;
		update c;

		// Family but non-veteran should get directed to events
		confirmMemberCategories(queryContact(c.Id).Member_Categories__c, false, false, false, true, true);
		testRedirect(u, c, 'cov_events_central');


		c.Veteran_Member__c = true;
		c.Email = u.Email;
		update c;

		// Unconfirmed should not get directed anywhere
		confirmMemberCategories(queryContact(c.Id).Member_Categories__c, false, true, false, true, true);
		testRedirect(u, c, null);

		c.Veteran_Member__c = false;
		c.Veteran_of_Other_Era__c = true;
		update c;

		// Other Era should not get directed anywhere
		confirmMemberCategories(queryContact(c.Id).Member_Categories__c, false, false, true, true, true);
		testRedirect(u, c, null);

		c.Veteran_Member__c = true;
		c.Veteran_Family_Member__c = false;
		c.Veteran_of_Other_Era__c = false;
		c.Paperwork_Confirmation__c = 'Paperwork Accepted';
		c.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		update c;

		// Confirmed should not get directed anywhere
		confirmMemberCategories(queryContact(c.Id).Member_Categories__c, true, false, false, false, true);
		testRedirect(u, c, null);


		// staff users should not get redirected even if non-vet
		User staffU = testusers.getInternalUser();
		Contact staffC = testusers.getInternalContact();
		confirmMemberCategories(queryContact(staffC.Id).Member_Categories__c, false, false, false, false, true);
		testRedirect(staffU, staffC, null);


	}
	


	// **** HELPER METHODS ****

	private static Contact queryContact(Id cId) {
		return [select Id, Member_Categories__c from Contact where Id = :cId];
	}

	private static void testRedirect(User uIn, Contact cIn,  String pageRefString) {

		PageReference pr;

		System.RunAs(uIn) {
			cov_user_utility.self.refreshSelf();
			pr = new cov_redirect_controller().init_dashboard();
			if (pageRefString == null) {
				system.assertEquals(null, pr);
			} else {
				system.assertNotEquals(null, pr);
				system.assert(pr.getUrl().contains(pageRefString));
			}
		}

	}

	public static void confirmMemberCategories(String memberCats, Boolean containsConfirmed, Boolean containsUnconfirmed, Boolean containsOtherEra, Boolean containsFamily, Boolean containsEveryone) {
		confirmCategory(memberCats.replace('Unconfirmed', ''), 'Confirmed', containsConfirmed);
		confirmCategory(memberCats, 'Unconfirmed', containsUnconfirmed);
		confirmCategory(memberCats, 'OtherEra', containsOtherEra);
		confirmCategory(memberCats, 'Family', containsFamily);
		confirmCategory(memberCats, 'Everyone', containsEveryone);
	}

	public static void confirmCategory(String memberCatsIn, String compareString, Boolean shouldBeTrue) {
		if (shouldBeTrue) {
			System.assert(memberCatsIn.contains(compareString));
		} else {
			System.assert(!memberCatsIn.contains(compareString));
		}
	}


}