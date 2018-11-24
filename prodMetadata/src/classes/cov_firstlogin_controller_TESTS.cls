@isTest
private class cov_firstlogin_controller_TESTS {
	
	@isTest static void test_firstlogin() {
		
       	cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u1 = testusers.getPortalUser();
		Contact c1 = testusers.getPortalContact();

       	cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		Contact c2 = testusers2.getPortalContact();

		npe4__Relationship__c r1 = new npe4__Relationship__c(
											npe4__Contact__c = c1.Id
											, npe4__RelatedContact__c = c2.Id
											, npe4__Type__c = 'Vouched for by'
											, npe4__Status__c = 'Current'
											);
		insert r1;

		// no longer works - validation rule prevents relationship to own contact
		// also try a relationship between a contact and itself to make sure
		// it doesnt attempt to follow self
		//npe4__Relationship__c r2 = new npe4__Relationship__c(
		//									npe4__Contact__c = c1.Id
		//									, npe4__RelatedContact__c = c1.Id
		//									, npe4__Type__c = 'Vouched for by'
		//									, npe4__Status__c = 'Current'
		//									);
		//insert r2;


		Id theNetwork = cov_user_utility.self.getNetworkId();
		CollaborationGroup cg1 = new CollaborationGroup(Name='Test Group 1', CollaborationType='Public', NetworkId=theNetwork);
		CollaborationGroup cg2 = new CollaborationGroup(Name='Test Group 2', CollaborationType='Public', NetworkId=theNetwork);
		CollaborationGroup cg3 = new CollaborationGroup(Name='Test Group 3', CollaborationType='Public', NetworkId=theNetwork);
		CollaborationGroup cg4 = new CollaborationGroup(Name='Test Group 4', CollaborationType='Public', NetworkId=theNetwork);
		CollaborationGroup cg5 = new CollaborationGroup(Name='Test Group 5', CollaborationType='Public', NetworkId=theNetwork);
		insert new List<CollaborationGroup>{cg1, cg2, cg3, cg4, cg5};
		Chatter_Group_Mirror__c cgm2 = new Chatter_Group_Mirror__c(Name=cg2.Name);
		Chatter_Group_Mirror__c cgm3 = new Chatter_Group_Mirror__c(Name=cg3.Name);
		Chatter_Group_Mirror__c cgm4 = new Chatter_Group_Mirror__c(Name=cg4.Name);
		Chatter_Group_Mirror__c cgm5 = new Chatter_Group_Mirror__c(Name=cg5.Name);
		insert new List<Chatter_Group_Mirror__c>{cgm2, cgm3, cgm4, cgm5};

		Campaign cmp = new Campaign(Name='Test Campaign 123');
		insert cmp;
		CampaignMember cmpmemb = new CampaignMember(ContactId = c1.Id, CampaignId = cmp.Id);
		insert cmpmemb;
		c1.MailingState = 'NM';
		c1.Veteran_Member__c = true;
		c1.Email = u1.Email;
		update c1;


		System.RunAs(u1) {
			System.debug('Running as u1.Id: ' + u1.Id);

			cov_user_utility.self.refreshSelf();
			system.debug('current member category: ' + cov_user_utility.self.getC().Member_Categories__c);
			//system.assertEquals(c1.Id, cov_user_utility.self.getC().Id);
			cov_firstlogin_controller controller = new cov_firstlogin_controller();
			
			// without an acceptance date the user will get redirected to the gateway page
			System.assertEquals(Page.cov_gateway.getUrl(), controller.checkFirstLogin().getUrl());

			u1.Date_of_COV_Terms_and_Conduct_Acceptance__c = datetime.now();
			update u1;

			cov_firstlogin_controller.u = null;
			cov_user_utility.self.refreshSelf();
			controller = new cov_firstlogin_controller();

			Test.startTest();

			// pre-method baseline
			//System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Name='Introduce Yourself'].size());
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg1.Id].size());
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg2.Id].size());
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg3.Id].size());
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg4.Id].size());
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg5.Id].size());


			controller.checkFirstLogin();
			List <EntitySubscription> follows = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid = :c1.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
			System.debug('c1.Portal_User__c: ' + c1.Portal_User__c);
			System.debug('c2.Portal_User__c: ' + c2.Portal_User__c);
			System.assertEquals(1, follows.size());

			//System.assertEquals('Supporter', [select CompanyName from User where Id = :u1.Id limit 1].CompanyName);

			// still should be 0 since none of the mirrors were marked as add everyone
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg1.Id].size());
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg2.Id].size());
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg3.Id].size());
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg4.Id].size());
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg5.Id].size());

			//cgm2.Add_everyone_to_group__c = true;
			cgm2.Auto_Add_to_Group__c = 'Unconfirmed';
			cgm4.Auto_add_Campaign__c = cmp.Id;
			cgm3.Auto_add_States__c = 'DE;WY'; // shouldnt match the contact's state
			cgm3.Auto_Add_to_Selected_States__c = 'Everyone';
			cgm5.Auto_add_States__c = 'NY;NM;CA'; // should match the contact's state
			cgm5.Auto_Add_to_Selected_States__c = 'Everyone';
			update new List<Chatter_Group_Mirror__c>{cgm2, cgm4, cgm3, cgm5};
			u1.Date_of_first_COV_login__c = null;
			update u1;
			cov_firstlogin_controller.u = null;
			cov_firstlogin_controller.isFirstLogin = null;
			cov_user_utility.self.refreshSelf();
			controller = new cov_firstlogin_controller();
			controller.checkFirstLogin();
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg1.Id].size());
			System.assertEquals(1, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg2.Id].size());
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg3.Id].size());
			System.assertEquals(1, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg4.Id].size());
			System.assertEquals(1, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Id = :cg5.Id].size());


			//if ([select Id from CollaborationGroupMember where CollaborationGroup.Name='Introduce Yourself'].size() > 0) {
			//	System.assertEquals(1, [select Id from CollaborationGroupMember where MemberId = :u1.Id and CollaborationGroup.Name='Introduce Yourself'].size());
			//}

			// cover the case if First Login Date already filled in
			cov_firstlogin_controller.isFirstLogin = null;
			controller.checkFirstLogin();

			Test.stopTest();

		}

	}

	@isTest static void test_firstlogin_group_targeting_1() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u1 = testusers.getPortalUser();
		Contact c1 = testusers.getPortalContact();

		Id theNetwork = cov_user_utility.self.getNetworkId();
		CollaborationGroup cg1 = new CollaborationGroup(Name='Test Group 1', CollaborationType='Public', NetworkId=theNetwork);
		insert cg1;
		Chatter_Group_Mirror__c cgm1 = new Chatter_Group_Mirror__c(Name=cg1.Name, Auto_Add_to_Group__c = 'Unconfirmed');
		insert cgm1;

		c1.Email = u1.Email;
		update c1;

		System.RunAs(u1) {
			u1.Date_of_COV_Terms_and_Conduct_Acceptance__c = datetime.now();
			update u1;
		}

		runTheTest(u1, cg1, 0, 'Everyone');

		c1.Veteran_Member__c = true;
		update c1;

		runTheTest(u1, cg1, 1, 'Unconfirmed');

		removeFromGroup(u1, cg1);
		cgm1.Auto_Add_to_Group__c = 'Confirmed';
		update cgm1;

		runTheTest(u1, cg1, 0, 'Unconfirmed');

		cgm1.Auto_Add_to_Group__c = 'Unconfirmed;Family';
		update cgm1;
		runTheTest(u1, cg1, 1, 'Unconfirmed');

	}

	@isTest static void test_firstlogin_group_targeting_2() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u1 = testusers.getPortalUser();
		Contact c1 = testusers.getPortalContact();

		Id theNetwork = cov_user_utility.self.getNetworkId();
		CollaborationGroup cg1 = new CollaborationGroup(Name='Test Group 1', CollaborationType='Public', NetworkId=theNetwork);
		insert cg1;
		Chatter_Group_Mirror__c cgm1 = new Chatter_Group_Mirror__c(Name=cg1.Name, Auto_Add_to_Group__c = 'Unconfirmed');
		insert cgm1;

		c1.Email = u1.Email;
		update c1;

		System.RunAs(u1) {
			u1.Date_of_COV_Terms_and_Conduct_Acceptance__c = datetime.now();
			update u1;
		}

		c1.Veteran_of_Other_Era__c = true;
		update c1;
		cgm1.Auto_Add_to_Group__c = 'Other Era';
		update cgm1;

		runTheTest(u1, cg1, 1, 'OtherEra');

		removeFromGroup(u1, cg1);
		cgm1.Auto_Add_to_Group__c = 'Confirmed;Family';
		update cgm1;
		runTheTest(u1, cg1, 0, 'OtherEra');

		c1.Veteran_Family_Member__c = true;
		update c1;
		runTheTest(u1, cg1, 1, 'Family');

	}

	@isTest static void test_firstlogin_group_targeting_3() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u1 = testusers.getPortalUser();
		Contact c1 = testusers.getPortalContact();

		Id theNetwork = cov_user_utility.self.getNetworkId();
		CollaborationGroup cg1 = new CollaborationGroup(Name='Test Group 1', CollaborationType='Public', NetworkId=theNetwork);
		insert cg1;
		Chatter_Group_Mirror__c cgm1 = new Chatter_Group_Mirror__c(Name=cg1.Name, Auto_Add_to_Group__c = 'Unconfirmed');
		insert cgm1;

		c1.Email = u1.Email;
		update c1;

		System.RunAs(u1) {
			u1.Date_of_COV_Terms_and_Conduct_Acceptance__c = datetime.now();
			update u1;
		}

		cgm1.Auto_Add_to_Group__c = 'Confirmed;Other Era';
		update cgm1;
		c1.Paperwork_Confirmation__c = 'Paperwork Accepted';
		c1.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		update c1;
		runTheTest(u1, cg1, 1, 'Confirmed');		

		removeFromGroup(u1, cg1);
		cgm1.Auto_Add_to_Group__c = 'Everyone';
		update cgm1;
		runTheTest(u1, cg1, 1, 'Confirmed');		

		removeFromGroup(u1, cg1);
		c1.Paperwork_Confirmation__c = null;
		c1.Paperwork_Confirmation_Type__c = null;
		c1.Veteran_Member__c = false;
		update c1;
		runTheTest(u1, cg1, 1, 'Everyone');	

	}

	@isTest static void test_firstlogin_state_targeting_1() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u1 = testusers.getPortalUser();
		Contact c1 = testusers.getPortalContact();

		Id theNetwork = cov_user_utility.self.getNetworkId();
		CollaborationGroup cg1 = new CollaborationGroup(Name='Test Group 1', CollaborationType='Public', NetworkId=theNetwork);
		insert cg1;
		Chatter_Group_Mirror__c cgm1 = new Chatter_Group_Mirror__c(Name=cg1.Name, Auto_add_States__c = 'NY;DE');
		insert cgm1;

		c1.Email = u1.Email;
		c1.Veteran_Member__c = true;
		c1.MailingState = 'NY';
		update c1;

		System.RunAs(u1) {
			u1.Date_of_COV_Terms_and_Conduct_Acceptance__c = datetime.now();
			update u1;
		}

		system.debug('scenario 1');
		runTheTest(u1, cg1, 0, 'Unconfirmed');		

		system.debug('scenario 2');
		cgm1.Auto_Add_to_Selected_States__c = 'Confirmed';
		update cgm1;
		runTheTest(u1, cg1, 0, 'Unconfirmed');		

		system.debug('scenario 3');
		cgm1.Auto_Add_to_Selected_States__c = 'Unconfirmed';
		update cgm1;
		runTheTest(u1, cg1, 1, 'Unconfirmed');		

		system.debug('scenario 4');
		removeFromGroup(u1, cg1);
		cgm1.Auto_Add_to_Selected_States__c = 'Other Era;Family';
		update cgm1;
		c1.Veteran_of_Other_Era__c = true;
		update c1;
		runTheTest(u1, cg1, 1, 'OtherEra');		

	}

	@isTest static void test_firstlogin_state_targeting_2() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u1 = testusers.getPortalUser();
		Contact c1 = testusers.getPortalContact();

		Id theNetwork = cov_user_utility.self.getNetworkId();
		CollaborationGroup cg1 = new CollaborationGroup(Name='Test Group 1', CollaborationType='Public', NetworkId=theNetwork);
		insert cg1;
		Chatter_Group_Mirror__c cgm1 = new Chatter_Group_Mirror__c(Name=cg1.Name, Auto_add_States__c = 'NY;DE', Auto_Add_to_Selected_States__c = 'Everyone');
		insert cgm1;

		c1.Email = u1.Email;
		c1.MailingState = 'CA';
		update c1;

		System.RunAs(u1) {
			u1.Date_of_COV_Terms_and_Conduct_Acceptance__c = datetime.now();
			update u1;
		}

		system.debug('scenario 5');
		runTheTest(u1, cg1, 0, 'Everyone');	

		system.debug('scenario 6');
		c1.MailingState = 'NY';
		update c1;
		runTheTest(u1, cg1, 1, 'Everyone');	

		system.debug('scenario 7');
		removeFromGroup(u1, cg1);
		cgm1.Auto_Add_to_Selected_States__c = 'Confirmed';
		update cgm1;
		c1.Veteran_Member__c = true;
		c1.Paperwork_Confirmation__c = 'Paperwork Accepted';
		c1.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		update c1;
		runTheTest(u1, cg1, 1, 'Confirmed');	

	}


	private static void removeFromGroup(User theU, CollaborationGroup theCg) {
		delete [select Id from CollaborationGroupMember where MemberId = :theU.Id and CollaborationGroupId = :theCg.Id];
	}


	private static void runTheTest(User theU, CollaborationGroup theCg, Integer result, String memberCatContains) {
		System.RunAs(theU) {
			System.debug('Running as theU.Id: ' + theU.Id);

			theU.Date_of_COV_Terms_and_Conduct_Acceptance__c = datetime.now();
			theU.Date_of_first_COV_login__c = null;
			update theU;

			cov_firstlogin_controller.u = null;
			cov_user_utility.self.refreshSelf();
			system.assert(cov_user_utility.self.getC().Member_Categories__c.contains(memberCatContains));
			//system.assertEquals(c1.Id, cov_user_utility.self.getC().Id);
			cov_firstlogin_controller controller = new cov_firstlogin_controller();
			cov_firstlogin_controller.isFirstLogin = null;

			// pre-method baseline
			System.assertEquals(0, [select Id from CollaborationGroupMember where MemberId = :theU.Id and CollaborationGroup.Id = :theCg.Id].size());

			controller.checkFirstLogin();

			System.assertEquals(result, [select Id from CollaborationGroupMember where MemberId = :theU.Id and CollaborationGroup.Id = :theCg.Id].size());

		}
	}


	
}