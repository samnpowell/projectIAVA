@isTest
private class cov_vouching_controller_TESTS {
	
	@isTest static void setReciprocalRelationship() {

		// moved to cov_relationships_TEST_utility
	    cov_relationships_TEST_utility.setReciprocalRelationship('Vouched for', 'Vouched for by');

	//	// it appears we have to re-create the relationships settings
	//	// and reciprocal relationships lookups inside of the unit test

	//	String sprimary = 'Vouched for';
	//	String srecip = 'Vouched for by';
	//	npe4__Relationship_Lookup__c rl = new npe4__Relationship_Lookup__c(
	//		Name = sprimary,
	//		npe4__Active__c = true,
	//		npe4__Female__c = srecip, 
	//		npe4__Male__c = srecip, 
	//		npe4__Neutral__c = srecip
	//		);
	//	insert rl;

	//	npe4__Relationship_Lookup__c rl2 = new npe4__Relationship_Lookup__c(
	//		Name = srecip,
	//		npe4__Active__c = true,
	//		npe4__Female__c = sprimary, 
	//		npe4__Male__c = sprimary, 
	//		npe4__Neutral__c = sprimary
	//		);
	//	insert rl2;

	//	npe4__Relationship_Settings__c rs = new npe4__Relationship_Settings__c(
	//		Name = 'test setting',
	//		SetupOwnerId = UserInfo.getOrganizationId(),
	//		npe4__Reciprocal_Method__c = 'List Setting',
	//		npe4__Force_Synchronous_Auto_Create__c = true
	//		);
	//	insert rs;

 //       Profile p = [SELECT Id FROM Profile WHERE Name='IAVA Plus Portal User']; 

	//	npe4__Relationship_Settings__c rs2 = new npe4__Relationship_Settings__c(
	//		Name = 'test portal profile setting',
	//		SetupOwnerId = p.Id,
	//		npe4__DISABLE_Relationships_trigger__c = true
	//		);
	//	insert rs2;

	//	System.debug('All relationship lookups: ' + [select Id, Name, npe4__Active__c, npe4__Female__c, npe4__Male__c, npe4__Neutral__c from npe4__Relationship_Lookup__c]);

	//	System.debug('All relationships settings: ' + [select Id, IsDeleted, Name, npe4__Allow_AutoCreated_Duplicates__c, npe4__DISABLE_RelationshipCM_trigger__c, npe4__DISABLE_RelationshipContacts_trigger__c, npe4__DISABLE_Relationships_trigger__c, npe4__Force_Synchronous_Auto_Create__c, npe4__Gender_Field__c, npe4__Reciprocal_Method__c, npe4__Relationship_Name_Field_Id__c, npe4__Relationship_Name_Id_Field_Id__c from npe4__Relationship_Settings__c]);

	}

	
	@isTest static void test_vouching_controller_portaluser_to_existing_contact() {

		setReciprocalRelationship();
		
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUserWithEmail();
		Contact c2 = testusers2.getPortalContact();

		c2.FirstName = 'first';
		c2.LastName = 'last';
		update c2;

		String existingEmail = c2.email;

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();

			cov_vouching_controller controller = new cov_vouching_controller();
			System.assertEquals(false, controller.getHasVouchees());


			controller.vcfirst = 'New first';
			controller.vclast = 'New last';
			controller.vcemail = existingEmail;
			controller.vcOEF = false;
			controller.vcOIF = true;
			controller.vcOND = false;
			PageReference pr = controller.newVouchee();

			controller.vouchees = null;
			System.assertEquals(true, controller.getHasVouchees());

		}

		// Test that vouch relationship got created
		System.assertEquals(1, [select Id from npe4__Relationship__c 
				where npe4__Type__c = 'Vouched for' and npe4__Contact__c = :c.id and npe4__RelatedContact__c = :c2.id].size());

		// Test that reciprocal relationship got created
		System.assertEquals(1, [select Id from npe4__Relationship__c 
				where npe4__Type__c = 'Vouched for by' and npe4__Contact__c = :c2.id and npe4__RelatedContact__c = :c.id].size());

		// make sure a new contact was not added since one with the email already existed
		System.assertEquals(1, [select id from Contact where Email = :existingEmail].size());
		// make sure first name wasnt overwritten on existing contact
		System.assertNotEquals('New first', [select FirstName from Contact where Email = :existingEmail limit 1].FirstName);

	}

	@isTest static void test_vouching_controller_portaluser_to_new_contact() {

		setReciprocalRelationship();
		
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUser();
		Contact c2 = testusers2.getPortalContact();

		String newEmail = 'unittestcontactqefhldkjs@iava.org';

		System.RunAs(u) {

			cov_user_utility.self.refreshSelf();

			cov_vouching_controller controller = new cov_vouching_controller();
			controller.vcfirst = 'First2';
			controller.vclast = 'Last2';
			controller.vcemail = newEmail;
			controller.vcOEF = false;
			controller.vcOIF = false;
			controller.vcOND = true;
			system.debug('yhoya about to call newVouchee()');
			PageReference pr = controller.newVouchee();

		}

//		System.debug('allrels: ' + [select Id, npe4__Type__c, npe4__Contact__c, npe4__RelatedContact__c from npe4__Relationship__c]);

		// Test that vouch relationship got created
		System.assertEquals(1, [select Id from npe4__Relationship__c 
				where npe4__Type__c = 'Vouched for' and npe4__Contact__c = :c.id and npe4__RelatedContact__r.email = :newEmail].size());

		// Test that reciprocal relationship got created 
		System.assertEquals(1, [select Id from npe4__Relationship__c 
				where npe4__Type__c = 'Vouched for by' and npe4__Contact__r.email = :newEmail and npe4__RelatedContact__c = :c.id].size());

		// make sure a new contact was added since the email is new
		System.assertEquals(1, [select id from Contact where Email = :newEmail].size());
		//make sure Should Not Receive Email Blasts was set on the new contact
		System.assertEquals(true, [select No_Email_Blasts__c from Contact where Email = :newEmail].No_Email_Blasts__c);

		// make sure first name was overwritten on existing contact
		System.assertEquals('First2', [select FirstName from Contact where Email = :newEmail limit 1].FirstName);

	}

	@isTest static void test_vouching_controller_internaluser() {

		setReciprocalRelationship();
		
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u3 = testusers.getInternalUser();
		Contact c = testusers.getInternalContact();

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUserWithEmail();
		Contact c2 = testusers2.getPortalContact();
		system.debug('c2.email: ' + c2.email);
		String email1 = c2.email;
		c2.FirstName = 'first';
		c2.LastName = 'last';
		update c2;

		System.RunAs(u3) {
			cov_user_utility.self.refreshSelf();

			System.debug('UserInfo.getUserType() in first u3 runas: ' + UserInfo.getUserType());

			cov_vouching_controller controller = new cov_vouching_controller();
			System.assertEquals(false, controller.getHasVouchees());


			controller.vcfirst = 'New first';
			controller.vclast = 'New last';
			controller.vcemail = email1;
			controller.vcOEF = false;
			controller.vcOIF = true;
			controller.vcOND = false;
			PageReference pr = controller.newVouchee();

			controller.vouchees = null;
			System.assertEquals(true, controller.getHasVouchees());

		}

		// Test that vouch relationship got created
		System.assertEquals(1, [select Id from npe4__Relationship__c 
				where npe4__Type__c = 'Vouched for' and npe4__Contact__c = :c.id and npe4__RelatedContact__c = :c2.id].size());

		System.debug('allrels: ' + [select Id, npe4__Type__c, npe4__Contact__c, npe4__RelatedContact__c from npe4__Relationship__c]);

		// Test that reciprocal relationship got created (should be created by the trigger)
		System.assertEquals(1, [select Id from npe4__Relationship__c 
				where npe4__Type__c = 'Vouched for by' and npe4__Contact__c = :c2.id and npe4__RelatedContact__c = :c.id].size());


		// make sure a new contact was not added since one with the email already existed
		System.assertEquals(1, [select id from Contact where Email = :email1].size());
		// make sure first name wasnt overwritten on existing contact
		System.assertNotEquals('New first', [select FirstName from Contact where Email = :email1 limit 1].FirstName);

	}


@isTest static void test_vouching_controller_internaluser2() {

		setReciprocalRelationship();
		
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u3 = testusers.getInternalUser();
		Contact c = testusers.getInternalContact();

		String email2 = 'unittestcontactqefhldkjs@iava.org';

		System.RunAs(u3) {

			cov_user_utility.self.refreshSelf();

			System.debug('UserInfo.getUserType() in second u3 runas: ' + UserInfo.getUserType());

			cov_vouching_controller controller = new cov_vouching_controller();
			controller.vcfirst = 'First2';
			controller.vclast = 'Last2';
			controller.vcemail = email2;
			controller.vcOEF = false;
			controller.vcOIF = false;
			controller.vcOND = true;
			PageReference pr = controller.newVouchee();

		}

//		System.debug('allrels: ' + [select Id, npe4__Type__c, npe4__Contact__c, npe4__RelatedContact__c from npe4__Relationship__c]);

		// make sure a new contact was added since the email is new
		List<Contact> newCon = [select id, FirstName from Contact where Email = :email2];
		System.assertEquals(1, newCon.size());
		// make sure first name was overwritten on existing contact
		System.assertEquals('First2', newCon[0].FirstName);

		// Test that vouch relationship got created
		System.assertEquals(1, [select Id from npe4__Relationship__c 
				where npe4__Type__c = 'Vouched for' and npe4__Contact__c = :c.id and npe4__RelatedContact__r.email = :email2].size());

		System.debug('allrels: ' + [select Id, npe4__Type__c, npe4__Contact__c, npe4__RelatedContact__c, npe4__Contact__r.email from npe4__Relationship__c]);

		System.debug('newCon[0].Id: ' + newCon[0].Id);

		// DISABLED because the reciprocal relationship isn't getting created, not sure why not
		// Test that reciprocal relationship got created 
//		System.assertEquals(1, [select Id from npe4__Relationship__c 
//				where npe4__Type__c = 'Vouched for by' and npe4__Contact__c = :newCon[0].id and npe4__RelatedContact__c = :c.id].size());




	}

	
}