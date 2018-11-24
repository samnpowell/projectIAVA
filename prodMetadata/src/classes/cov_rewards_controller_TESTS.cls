@isTest
private class cov_rewards_controller_TESTS {
	
	@isTest static void cov_rewards_controller_TEST() {

		Partnership_Request__c p = new Partnership_Request__c(Name='Test Partnership', Public_Partner_Name__c='Test Public Name');
		insert p;
		Give__c g = new Give__c(Name='Test Give', National_Give__c = true, Partnership_Request__c = p.Id, Highlight_Listing__c = true);
		insert g;
		Give_Instance__c gi = new Give_Instance__c(Give__c = g.Id, Number_of_Units__c=5, Status__c='Open');
		insert gi;
		Give__c g2 = new Give__c(Name='Test Give 2', National_Give__c = true, Partnership_Request__c = p.Id, Highlight_Listing__c = true, Category__c = 'Events');
		insert g2;
		Geo_Location__c gl1 = new Geo_Location__c(Name='94102', lat__c=37.778687100000000, lon__c=-122.421242399999980);
		insert gl1;
		Give__c g3 = new Give__c(Name='Test Give 3', Geo_Location__c=gl1.id, Zip_Code_s__c='94102', National_Give__c = false, Partnership_Request__c = p.Id, Highlight_Listing__c = false, Category__c = 'Hot Dogs');
		insert g3;
		Give__c g4 = new Give__c(Name='Test Give 4', Location_by_State_s__c='OR;CA;WA', National_Give__c = false, Partnership_Request__c = p.Id, Highlight_Listing__c = false, Category__c = 'Hot Dogs');
		insert g4;


		
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();

		// First try it while user's contact has no lat/lon fields
		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();
			cov_rewards_controller controller = new cov_rewards_controller();
			List<cov_rewards_controller.customReward> glist = controller.getRewards();
			System.assertEquals(2, glist.size());
			System.assertEquals('Test Give', glist[0].Title);
		}


		Contact c = testusers.getPortalContact();
		c.MailingState='CA';
		update c;
		c.MA_Latitude__c = 37.776378600000000;
		c.MA_Longitude__c = -122.456878700000000;
		update c;

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();
			cov_rewards_controller controller = new cov_rewards_controller();
			//List<Give__c> glist = controller.getRewards();
			List<cov_rewards_controller.customReward> glist = controller.getRewards();
			System.assertEquals(4, glist.size());
			System.assertEquals('Test Give 3', glist[0].Title); // lat/lon results first
			System.assertEquals('Test Give 4', glist[1].Title); // then state
			System.assert(glist[2].Title == 'Test Give 2' || glist[2].Title == 'Test Give'); // then national
			System.assertEquals(1, controller.eventRewards.size());
			System.assertEquals('Test Give 2', controller.eventRewards[0].Title);			
			System.assertEquals(3, controller.standardRewards.size());
			System.assertEquals('Test Give 3', controller.standardRewards[0].Title);			



			// Not sure anymore what these functions are for, just testing to get coverage
			controller.g = g;
			System.assertEquals('Test Give', controller.getGive().Name);
			System.assertEquals('Test Give', controller.getGiveList()[0].Name);

			Give_Request__c gr = new Give_Request__c(Applicant__c = u.ContactId, Give_Instance__c = gi.Id,
					Email_Address__c='test@test.iava.org', Address__c='1234 5th St', State__c='NY', Zip_Code__c='10012',
					Primary_Phone__c='212-555-1234', City__c='New York');
			insert gr;
			//System.assertEquals('Test Give', controller.getGiveRequests()[0].Give_Name__c);
			List<cov_rewards_controller.customRewardRequest> rqList = controller.getRewardRequests();
			System.assertEquals('Test Give', rqList[0].giveName);
			System.assertEquals('Tentative confirmation', rqList[0].publicStage);

			gr.Attended__c = 'Yes';
			update gr;
			rqList = controller.getRewardRequests();
			System.assertEquals('Attended', rqList[0].publicStage);

			gr.Attended__c = 'No';
			update gr;
			rqList = controller.getRewardRequests();
			System.assertEquals('Did not attend', rqList[0].publicStage);

			gr.Attended__c = null;
			gr.Stage__c = 'Ineligible';
			update gr;
			rqList = controller.getRewardRequests();
			System.assertEquals('Did not get reward', rqList[0].publicStage);


		}

		// Internal user with no connected contact should only get National and Highlighted gives
		User u2 = testusers.getInternalUser();
		Contact c2 = testusers.getInternalContact();
		c2.Portal_User__c = null;
		update c2;

		System.RunAs(u2) {
			cov_user_utility.self.refreshSelf();
			cov_rewards_controller controller = new cov_rewards_controller();
			List<cov_rewards_controller.customReward> glist = controller.getRewards();
			System.assertEquals(2, glist.size());
			System.assertEquals('Test Give', glist[0].Title);
		}


	}
	
	
}