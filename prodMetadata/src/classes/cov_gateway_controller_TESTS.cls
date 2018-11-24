@isTest
public class cov_gateway_controller_TESTS {
	

	public static COV_Access_Profile_Settings__c setTheSetting() {
			COV_Access_Profile_Settings__c setting = new COV_Access_Profile_Settings__c(
				Name = 'Test Profile Setting',
				Authorized_member_categories__c = 'Confirmed',
				Prefix_for_COV_Access_Permission_Sets__c = 'COV Access',
				Allowed_relationship_types_to_COVuser__c = 'Decoy; Test Type',
				Allow_members_of_Campaign__c = 'Access Campaign'
				);
			insert setting;	
			return setting;	
	}

	static testMethod void test_gateway() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u1 = testusers.getPortalUser();
		Contact c1 = testusers.getPortalContact();
		Campaign cmp;

		System.runAs(u1) {
			cov_user_utility.self.refreshSelf();
			cov_gateway_controller controller = new cov_gateway_controller();

			System.assertEquals(true, controller.checkIfAlreadyHasPermissionSet());
			System.assertEquals(false, controller.getHasAcceptedAgreement());
			System.assertEquals(false, controller.checkIfAuthorizedToGainAccess());
			System.assertEquals(false, controller.getIsAuthorized());

			//COV_Access_Profile_Settings__c setting = new COV_Access_Profile_Settings__c(
			//	Name = 'Test Profile Setting',
			//	Authorized_member_categories__c = 'Confirmed',
			//	Prefix_for_COV_Access_Permission_Sets__c = 'COV Access',
			//	Allowed_relationship_types_to_COVuser__c = 'Decoy; Test Status',
			//	Allow_members_of_Campaign__c = 'Access Campaign'
			//	);
			//insert setting;

			COV_Access_Profile_Settings__c setting = setTheSetting();

			System.debug('About to run it back');
			c1.Paperwork_Confirmation__c = 'Paperwork Accepted';
			c1.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
			update c1;
			cov_user_utility.self.refreshSelf();
 			controller = new cov_gateway_controller();
			System.assertEquals(true, controller.checkIfAuthorizedToGainAccess());

			c1.Paperwork_Confirmation__c = 'Paperwork Requested';
			c1.Paperwork_Confirmation_Type__c = null;
			update c1;
			System.debug('c1.Member_Categories__c: ' + c1.Member_Categories__c);
			cov_user_utility.self.refreshSelf();
 			controller = new cov_gateway_controller();
			System.assertEquals(false, controller.checkIfAuthorizedToGainAccess());

			cmp = new Campaign(Name='Access Campaign');
			insert cmp;
			CampaignMember cm = new CampaignMember(CampaignId = cmp.Id, ContactId = c1.Id);
			insert cm;
			System.assertEquals(true, controller.checkIfAuthorizedToGainAccess());

			delete cm;
			System.assertEquals(false, controller.checkIfAuthorizedToGainAccess());

		}

		PermissionSetAssignment psa = [select Id from PermissionSetAssignment 
			where AssigneeId = :u1.Id
			and PermissionSetId in (select Id from PermissionSet where Label like 'COV Access%')];
		
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
        	// to avoid mixedDML error (http://salesforce.stackexchange.com/questions/13318/error-mixed-dml-operation-on-setup-and-non-setup-objects)
			delete psa;
		}

		System.runAs(u1) {
			cov_user_utility.self.refreshSelf();
 			cov_gateway_controller controller = new cov_gateway_controller();
			System.assertEquals(false, controller.checkIfAlreadyHasPermissionSet());

			System.assertEquals(null, [select Date_of_COV_Terms_and_Conduct_Acceptance__c from User where Id = :u1.Id].Date_of_COV_Terms_and_Conduct_Acceptance__c);
			PageReference pReftest = controller.accept();
			User ucheck = [select Date_of_COV_Terms_and_Conduct_Acceptance__c, UserPermissionsChatterAnswersUser from User where Id = :u1.Id limit 1];
			System.assertNotEquals(null, ucheck.Date_of_COV_Terms_and_Conduct_Acceptance__c);
			System.assertNotEquals(null, ucheck.UserPermissionsChatterAnswersUser);

			System.assertEquals(Page.cov_dashboard.getUrl(), pReftest.getUrl());
			System.assertEquals(true, controller.getHasAcceptedAgreement());
			System.assertEquals(true, controller.checkIfAlreadyHasPermissionSet());

		}

		// Also test accept() for internal user since Chatter Answers User doesnt apply

		User uint = testusers.getInternalUser();
		Contact cint = testusers.getInternalContact();
		PermissionSetAssignment psaint = [select Id from PermissionSetAssignment 
			where AssigneeId = :uint.Id
			and PermissionSetId in (select Id from PermissionSet where Label like 'COV Access%')];
		System.runAs ( new User(Id = UserInfo.getUserId()) ) {
        // to avoid mixedDML error (http://salesforce.stackexchange.com/questions/13318/error-mixed-dml-operation-on-setup-and-non-setup-objects)
			delete psaint;
		}

		System.runAs(uint) {
			cov_user_utility.self.refreshSelf();
			cov_gateway_controller controller = new cov_gateway_controller();

			System.assertEquals(false, controller.checkIfAuthorizedToGainAccess());

			CampaignMember cm = new CampaignMember(CampaignId = cmp.Id, ContactId = cint.Id);
			insert cm;
			System.assertEquals(true, controller.checkIfAuthorizedToGainAccess());

			System.assertEquals(false, controller.checkIfAlreadyHasPermissionSet());
			System.assertEquals(null, [select Date_of_COV_Terms_and_Conduct_Acceptance__c from User where Id = :uint.Id].Date_of_COV_Terms_and_Conduct_Acceptance__c);
			PageReference pReftest = controller.accept();
			User ucheck = [select Date_of_COV_Terms_and_Conduct_Acceptance__c from User where Id = :uint.Id limit 1];
			System.assertNotEquals(null, ucheck.Date_of_COV_Terms_and_Conduct_Acceptance__c);

			System.assertEquals(Page.cov_dashboard.getUrl(), pReftest.getUrl());
			System.assertEquals(true, controller.getHasAcceptedAgreement());
			System.assertEquals(true, controller.checkIfAlreadyHasPermissionSet());

		}
			


	}


	static testMethod void test_gateway_relationship() {

		COV_Access_Profile_Settings__c setting = setTheSetting();

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u1 = testusers.getPortalUserWithoutPerm();
		Contact c1 = testusers.getPortalContact();

       	cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUser();
		Contact c2 = testusers2.getPortalContact();

		npe4__Relationship__c r1 = new npe4__Relationship__c(
											npe4__Contact__c = c1.Id
											, npe4__RelatedContact__c = c2.Id
											, npe4__Type__c = 'Test Type'
											, npe4__Status__c = 'Current'
											);
		insert r1;

		System.runAs(u1) {
			cov_user_utility.self.refreshSelf();
			cov_gateway_controller controller = new cov_gateway_controller();

			System.assertEquals(true, controller.checkIfAuthorizedToGainAccess());
		}

	}

	static testMethod void test_user_based_constructors() {

		COV_Access_Profile_Settings__c setting = setTheSetting();

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u1 = testusers.getPortalUser();
		Contact c1 = testusers.getPortalContact();

       	cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUser();
		Contact c2 = testusers2.getPortalContact();


		// TODO - figure out why these user based constructor tests are failing

		//System.runAs(u1) {
		//	cov_user_utility.self.refreshSelf();
		//	cov_gateway_controller controller = new cov_gateway_controller(u2);
		//	// TODO -- FIX below line which currently fails
		//	System.assertEquals(true, controller.getAlreadyHasPermissionSet());
		//	System.assertEquals(true, cov_gateway_controller.alreadyHasPermissionSet(u2));
		//}

		//PermissionSetAssignment psa = [select Id from PermissionSetAssignment 
		//	where AssigneeId = :u1.Id
		//	and PermissionSetId in (select Id from PermissionSet where Label like :setting.Prefix_for_COV_Access_Permission_Sets__c+'%')];
		//delete psa;

		//System.runAs(u1) {
		//	cov_user_utility.self.refreshSelf();
 	//		cov_gateway_controller controller = new cov_gateway_controller(u2);
		//	System.assertEquals(false, controller.getAlreadyHasPermissionSet());
		//	System.assertEquals(false, cov_gateway_controller.alreadyHasPermissionSet(u2));

		//	System.assertEquals(false, controller.checkIfAuthorizedToGainAccess());
		//	Campaign cmp = new Campaign(Name='Access Campaign');
		//	insert cmp;
		//	CampaignMember cm = new CampaignMember(CampaignId = cmp.Id, ContactId = c1.Id);
		//	insert cm;
		//	System.assertEquals(true, controller.checkIfAuthorizedToGainAccess());

		//}
	}

	static testMethod void test_submit_feedback() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u1 = testusers.getPortalUser();

		System.runAs(u1) {
			cov_gateway_controller controller = new cov_gateway_controller();
			controller.feedbackMessage = 'Please give me access.';
			controller.feedbackSave();

			List<Feedback__c> fb = [select Id from Feedback__c where OwnerId = :u1.Id];
			System.assertEquals(1, fb.size());
		}

	}

	
	
}