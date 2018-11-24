@isTest
private class cov_protectedareas_controller_TESTS {
	
	@isTest static void test_restricted_groups() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();

		// Start with unconfirmed member
		c.Veteran_Member__c = true;
		c.Email = 'testemail2345@iava.org';
		update c;

		//Contact queriedC = [select Id, Member_Categories__c from Contact where Id = :c.Id];
		//system.debug('queriedC.Member_Categories__c: ' + queriedC.Member_Categories__c);

		System.RunAs(u) {

			// first make sure it doesnt crash if there are no relevant protected groups
			cov_protectedareas_controller controller = new cov_protectedareas_controller();
			List<cov_protectedareas_controller.groupMemberMap> groupMemberMap = controller.loadRestrictedGroups();
			System.assertEquals(null, groupMemberMap);


			cov_user_utility.self.refreshSelf();
			System.assertEquals(true, cov_user_utility.self.getIsMemberVeteran());
			System.assertEquals(false, cov_user_utility.self.getIsConfirmed());
		}

		CollaborationGroup cg1 = new CollaborationGroup(
			Name='Test Group 1', 
			CollaborationType='Unlisted', 
			NetworkId=cov_user_utility.self.getNetworkId()
			);

		CollaborationGroup cg2 = new CollaborationGroup(
			Name='Test Group 2', 
			CollaborationType='Unlisted', 
			NetworkId=cov_user_utility.self.getNetworkId()
			);

		CollaborationGroup cg3 = new CollaborationGroup(
			Name='Test Group 3', 
			CollaborationType='Unlisted', 
			NetworkId=cov_user_utility.self.getNetworkId()
			);

		CollaborationGroup cg4 = new CollaborationGroup(
			Name='Test Group 4', 
			CollaborationType='Unlisted', 
			NetworkId=cov_user_utility.self.getNetworkId(),
			OwnerId=u.Id
			);

		CollaborationGroup cg5 = new CollaborationGroup(
			Name='Test Group 5', 
			CollaborationType='Unlisted', 
			NetworkId=cov_user_utility.self.getNetworkId()
			);

		insert new List<CollaborationGroup>{cg1, cg2, cg3, cg4, cg5};

		CollaborationGroupMember cgmem2 = new CollaborationGroupMember(
			CollaborationGroupId = cg2.Id,
			CollaborationRole = 'Standard',
			MemberId = u.Id,
			NotificationFrequency = 'N'
			);
		insert cgmem2;


		Chatter_Group_Mirror__c cgm2 = new Chatter_Group_Mirror__c(Name = cg2.Name, Expose_Joining_To__c = 'Confirmed');
		Chatter_Group_Mirror__c cgm3 = new Chatter_Group_Mirror__c(Name = cg3.Name, Expose_Joining_To__c = 'Unconfirmed;Confirmed');
		Chatter_Group_Mirror__c cgm4 = new Chatter_Group_Mirror__c(Name = cg4.Name, Expose_Joining_To__c = 'Unconfirmed');
		Chatter_Group_Mirror__c cgm5 = new Chatter_Group_Mirror__c(Name = cg5.Name);
		insert new List<Chatter_Group_Mirror__c>{cgm2, cgm3, cgm4, cgm5};

		Map<Id, cov_protectedareas_controller.groupMemberMap> mapToGmm;

		System.RunAs(u) {

			cov_protectedareas_controller controller = new cov_protectedareas_controller();

			List<cov_protectedareas_controller.groupMemberMap> groupMemberMap = controller.loadRestrictedGroups();
			system.debug('groupMemberMap: ' + groupMemberMap);
			mapToGmm = loadMap(groupMemberMap);

			System.assertEquals(null, mapToGmm.get(cg1.Id)); // not a restricted group

			System.assertEquals(true, mapToGmm.get(cg2.Id).isMember);
			System.assertEquals(false, mapToGmm.get(cg2.Id).isOwner);
			System.assertEquals(true, mapToGmm.get(cg2.Id).isPrivate);
			System.assertEquals(true, mapToGmm.get(cg2.Id).forConfirmed);
			System.assertEquals(false, mapToGmm.get(cg2.Id).forUnconfirmed);

			System.assertEquals(false, mapToGmm.get(cg3.Id).isMember);
			System.assertEquals(false, mapToGmm.get(cg3.Id).isOwner);
			System.assertEquals(true, mapToGmm.get(cg3.Id).isPrivate);
			System.assertEquals(true, mapToGmm.get(cg3.Id).forConfirmed);
			System.assertEquals(true, mapToGmm.get(cg3.Id).forUnconfirmed);

			System.assertEquals(true, mapToGmm.get(cg4.Id).isMember);
			System.assertEquals(true, mapToGmm.get(cg4.Id).isOwner);
			System.assertEquals(true, mapToGmm.get(cg4.Id).isPrivate);
			System.assertEquals(false, mapToGmm.get(cg4.Id).forConfirmed);
			System.assertEquals(true, mapToGmm.get(cg4.Id).forUnconfirmed);

			System.assertEquals(null, mapToGmm.get(cg5.Id)); // not a restricted group


			controller.groupIdSelected = cg3.Id;
			controller.addToGroup();

			groupMemberMap = controller.loadRestrictedGroups();
			mapToGmm = loadMap(groupMemberMap);

			System.assertEquals(true, mapToGmm.get(cg3.Id).isMember);

		}


	}

	// helper method to load the groupMemberMap result into a map that allows each group's result to be pulled by its key
	static Map<Id, cov_protectedareas_controller.groupMemberMap> loadMap(List<cov_protectedareas_controller.groupMemberMap> gmmArg) {
		Map<Id, cov_protectedareas_controller.groupMemberMap> returnMap = new Map<Id, cov_protectedareas_controller.groupMemberMap>();
		for (cov_protectedareas_controller.groupMemberMap gmm : gmmArg) {
			returnMap.put(gmm.cg.Id, gmm);
		}
		return returnMap;
	}

	
	
}