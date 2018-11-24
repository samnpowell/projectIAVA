@isTest
private class cov_cohort_controller_TESTS {

	static cov_user_TEST_utility testusers;
	static User u;
	static Contact c;

	static cov_user_TEST_utility testusers2;
	static User u2;
	static Contact c2;	

	static npe4__Relationship__c rel;

	static Campaign cmp1;
	static Campaign cmp2;
	static Campaign cmp3;
	static CampaignMember cm;


	static void setupUsers() {
		testusers = new cov_user_TEST_utility();
		u = testusers.getPortalUser();
		c = testusers.getPortalContact();

		testusers2 = new cov_user_TEST_utility();
		u2 = testusers2.getPortalUser();
		c2 = testusers2.getPortalContact();
	}

	static void setupRels() {
		rel = new npe4__Relationship__c(npe4__Contact__c=c.Id, npe4__RelatedContact__c=c2.Id, npe4__Type__c='Vouched for by');
		insert rel;
	}

	static void setupCampaigns() {
		cmp1 = new Campaign(Name='01 Test Cohort', Type='COV Cohort Invitees', StartDate=System.today().addDays(-30), EndDate=System.today().addDays(-21));
		cmp2 = new Campaign(Name='02 Test Cohort', Type='COV Cohort Invitees', StartDate=System.today().addDays(-20), EndDate=System.today().addDays(-11));
		cmp3 = new Campaign(Name='03 Test Cohort', Type='COV Cohort Invitees', StartDate=System.today().addDays(-10));
		insert new List<Campaign>{cmp1, cmp2, cmp3};
	}

	static void setupCampaignMember() {
		cm = new CampaignMember(CampaignId = cmp2.Id, ContactId = c.Id);
		insert cm;
	}

	@isTest static void test_cohorts() {

		setupUsers();

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();

			// Test that no cohort gets set if none of the conditions are met
			cov_cohort_controller.addCohort(c.Id);
			Contact endC = [select Id, COV_Cohort__c, COV_Sponsor__c from Contact where Id = :c.Id];
			System.assertEquals(null, endC.COV_Cohort__c);
			System.assertEquals(null, endC.COV_Sponsor__c);

		}

		//rel = new npe4__Relationship__c(npe4__Contact__c=c.Id, npe4__RelatedContact__c=c2.Id, npe4__Type__c='Vouched for by');
		//insert rel;
		setupRels();

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();

			// Test that COV Sponsor gets filled in even if sponsor has no cohort
			cov_cohort_controller.addCohort(c.Id);
			Contact endC = [select Id, COV_Cohort__c, COV_Sponsor__c from Contact where Id = :c.Id];
			System.assertEquals(null, endC.COV_Cohort__c);
			System.assertEquals(c2.Id, endC.COV_Sponsor__c);
		}

		c2.COV_Cohort__c = 'TestCohort';
		update c2;

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();

			// Test that there's no change since Sponsor was already filled in
			cov_cohort_controller.addCohort(c.Id);
			Contact endC = [select Id, COV_Cohort__c, COV_Sponsor__c from Contact where Id = :c.Id];
			System.assertEquals(null, endC.COV_Cohort__c);
			System.assertEquals(c2.Id, endC.COV_Sponsor__c);

			c.COV_Sponsor__c = null;
			update c;

			// Test that both COV Cohort and COV Sponsor get filled in from a voucher relationship
			cov_cohort_controller.addCohort(c.Id);
			endC = [select Id, COV_Cohort__c, COV_Sponsor__c from Contact where Id = :c.Id];
			System.assertEquals('TestCohort', endC.COV_Cohort__c);
			System.assertEquals(c2.Id, endC.COV_Sponsor__c);
		}

	}

	@isTest static void test_cohorts2() {

		setupUsers();

		setupCampaigns();

		setupCampaignMember();

		setupRels();

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();

			// Test that the contact gets Sponsor from relationship and cohort from campaign
			cov_cohort_controller.addCohort(c.Id);
			Contact endC = [select Id, COV_Cohort__c, COV_Sponsor__c from Contact where Id = :c.Id];
			System.assertEquals(cmp2.Name, endC.COV_Cohort__c);
			System.assertEquals(c2.Id, endC.COV_Sponsor__c);
		}

		//delete rel;
		//c.COV_Cohort__c = null;
		//c.COV_Sponsor__c = null;
		//update c;

	}

	@isTest static void test_cohorts3() {

		setupUsers();

		setupCampaigns();

		setupCampaignMember();

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();

			// Test that the contact gets cohort from campaign even if no vouch relationship or sponsor
			cov_cohort_controller.addCohort(c.Id);
			Contact endC = [select Id, COV_Cohort__c, COV_Sponsor__c from Contact where Id = :c.Id];
			System.assertEquals(cmp2.Name, endC.COV_Cohort__c);
			System.assertEquals(null, endC.COV_Sponsor__c);
		}

		//c.COV_Cohort__c = null;
		//c.COV_Sponsor__c = null;
		//update c;
		//delete cm;

	}

	@isTest static void test_cohorts4() {

		setupUsers();

		setupCampaigns();


		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();

			// Test that the contact gets cohort from fallback campaign with no EndDate
			cov_cohort_controller.addCohort(c.Id);
			Contact endC = [select Id, COV_Cohort__c, COV_Sponsor__c from Contact where Id = :c.Id];
			System.assertEquals(cmp3.Name, endC.COV_Cohort__c);
			System.assertEquals(null, endC.COV_Sponsor__c);
		}

		c.COV_Cohort__c = null;
		c.COV_Sponsor__c = null;
		update c;
		u.Date_of_COV_Terms_and_Conduct_Acceptance__c = System.today(); // ensure user doesnt get redirected to acceptance page
		System.runAs ( new User(Id = UserInfo.getUserId()) ) {
          // to avoid mixedDML error (http://salesforce.stackexchange.com/questions/13318/error-mixed-dml-operation-on-setup-and-non-setup-objects)
			update u;
		}

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();

			// Test that addCohort gets called from firstlogin controller
			cov_firstlogin_controller controller = new cov_firstlogin_controller();
			controller.checkFirstLogin();
			Contact endC = [select Id, COV_Cohort__c, COV_Sponsor__c from Contact where Id = :c.Id];
			System.assertEquals(cmp3.Name, endC.COV_Cohort__c);
			System.assertEquals(null, endC.COV_Sponsor__c);
		}



	}
	
}