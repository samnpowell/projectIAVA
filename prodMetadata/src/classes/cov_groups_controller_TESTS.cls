@isTest
private class cov_groups_controller_TESTS {
	
	@isTest static void cov_groups_controller_TEST() {


		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();


		CollaborationGroup cg = new CollaborationGroup(
			Name='Test Public Group', 
			CollaborationType='Public', 
			NetworkId=cov_user_utility.self.getNetworkId()
			);
		insert cg;
		System.debug('cg: ' + cg);

		System.RunAs(u) {

			cov_groups_controller controller = new cov_groups_controller();
			List<cov_groups_controller.groupMemberMap> gmm = controller.getGroups();
			System.debug('gmm: ' + gmm);


			System.assertEquals(cg.Id, gmm[0].cg.Id);
			System.assertEquals(false, gmm[0].isMember);
			System.assertEquals(false, gmm[0].isPrivate);
			System.assertEquals(false, gmm[0].isOwner);


		}

		CollaborationGroupMember cgm = new CollaborationGroupMember(
			CollaborationGroupId = cg.Id,
			CollaborationRole = 'Standard',
			MemberId = u.Id,
			NotificationFrequency = 'N'
			);
		insert cgm;


		cg.CollaborationType = 'Private';
		cg.OwnerId = u.Id;
		update cg;


		System.RunAs(u) {

			cov_groups_controller controller = new cov_groups_controller();
			List<cov_groups_controller.groupMemberMap> gmm = controller.getGroups();

			System.assertEquals(cg.Id, gmm[0].cg.Id);
			System.assertEquals(true, gmm[0].isMember);
			System.assertEquals(true, gmm[0].isPrivate);
			System.assertEquals(true, gmm[0].isOwner);

		}



	}


	@isTest static void cov_groups_add_user_to_groups_TEST() {


		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();


		CollaborationGroup cg1 = new CollaborationGroup(
			Name='Test Public Group 1', 
			CollaborationType='Public', 
			NetworkId=cov_user_utility.self.getNetworkId()
			);
		insert cg1;
		System.debug('cg1: ' + cg1);

		CollaborationGroup cg2 = new CollaborationGroup(
			Name='Test Public Group 2', 
			CollaborationType='Public', 
			NetworkId=cov_user_utility.self.getNetworkId()
			);
		insert cg2;



		System.RunAs(u) {

			cov_groups_controller controller = new cov_groups_controller();

			cov_groups_controller.addToGroups(u, new List<Id>{cg1.id, cg2.Id, cg1.Id});
			List<CollaborationGroupMember> cgm1 = [select Id from CollaborationGroupMember where MemberId = :u.Id and CollaborationGroupId = :cg1.Id];
			List<CollaborationGroupMember> cgm2 = [select Id from CollaborationGroupMember where MemberId = :u.Id and CollaborationGroupId = :cg2.Id];
			System.assertEquals(1, cgm1.size());
			System.assertEquals(1, cgm2.size());

			delete cgm1;
			delete cgm2;
			cgm1 = [select Id from CollaborationGroupMember where MemberId = :u.Id and CollaborationGroupId = :cg1.Id];
			cgm2 = [select Id from CollaborationGroupMember where MemberId = :u.Id and CollaborationGroupId = :cg2.Id];
			System.assertEquals(0, cgm1.size());
			System.assertEquals(0, cgm2.size());

			cov_groups_controller.addToGroups(u, new List<CollaborationGroup>{cg1, cg2, cg1});
			cgm1 = [select Id from CollaborationGroupMember where MemberId = :u.Id and CollaborationGroupId = :cg1.Id];
			cgm2 = [select Id from CollaborationGroupMember where MemberId = :u.Id and CollaborationGroupId = :cg2.Id];
			System.assertEquals(1, cgm1.size());
			System.assertEquals(1, cgm2.size());

		}

	}

	public class myException extends Exception {
	}
 


	@isTest static void cov_groups_mirrors_TEST() {


		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Id theNetworkId = cov_user_utility.self.getNetworkId();


		CollaborationGroup cg1 = new CollaborationGroup(
			Name='Test Public Group 1', 
			CollaborationType='Public', 
			NetworkId=theNetworkId
			);
		insert cg1;
		System.debug('cg1: ' + cg1);

		CollaborationGroup cg2 = new CollaborationGroup(
			Name='Test Public Group 2', 
			CollaborationType='Public', 
			NetworkId=theNetworkId
			);
		insert cg2;

		Chatter_Group_Mirror__c cgm1 = new Chatter_Group_Mirror__c();

		cgm1.Name = 'Bad name test';
		insertAndAssertErrorMsg(cgm1, 'No group found with that name');

		cgm1.Group_Id__c = 'ham sandwich';
		insertAndAssertErrorMsg(cgm1, 'not a valid ID');

		cgm1.Group_Id__c = u.Id;
		insertAndAssertErrorMsg(cgm1, 'ID does not correspond to a Chatter group');

		cgm1.Group_Id__c = cg2.Id;
		insertAndAssertErrorMsg(cgm1, 'ID does not match the Group name');

		cgm1.Name = cg1.Name;
		cgm1.Group_ID__c = null;
		insert cgm1;
		System.assertEquals(1, [select Id from Chatter_Group_Mirror__c where Group_Id__c = :cg1.Id].size());

		Chatter_Group_Mirror__c cgm2 = new Chatter_Group_Mirror__c();

		cgm2.Name = cg1.Name;
		insertAndAssertErrorMsg(cgm2, 'already a Chatter Group Mirror for this group');

		cgm2.Group_ID__c = cg1.Id;
		insertAndAssertErrorMsg(cgm2, 'already a Chatter Group Mirror for this group ID');

		cgm2.Name = cg2.Name;
		cgm2.Group_Id__c = cg2.Id;
		insert cgm2;
		System.assertEquals(1, [select Id from Chatter_Group_Mirror__c where Group_Id__c = :cg2.Id].size());

		// make sure record can still be updated
		cgm2.Add_everyone_to_group__c = true;
		update cgm2;
		System.assertEquals(true, [select Add_everyone_to_group__c from Chatter_Group_Mirror__c where Group_Id__c = :cg2.Id].Add_everyone_to_group__c);


		System.assertEquals(cgm1.Id, cov_groups_controller.findGroupMirrorByGroup(cg1).Id);

		List<CollaborationGroup> cgList = new List<CollaborationGroup>{cg1, cg2};
		List<Chatter_Group_Mirror__c> cgmList = cov_groups_controller.findGroupMirrorsByGroups(cgList);
		System.assert(cgm1.Id == cgmList[0].Id || cgm1.Id == cgmList[1].Id);
		System.assert(cgm2.Id == cgmList[0].Id || cgm2.Id == cgmList[1].Id);


		// re-query to make sure the Group_Id__c is populated
		cgm1 = [select Id, Name, Group_Id__c from Chatter_Group_Mirror__c where Id = :cgm1.Id];
		cgm2 = [select Id, Name, Group_Id__c from Chatter_Group_Mirror__c where Id = :cgm2.Id];
		System.assertEquals(cg1.Id, cov_groups_controller.findGroupByMirror(cgm1).Id);

		List<Chatter_Group_Mirror__c> cgmList2 = new List<Chatter_Group_Mirror__c>{cgm1, cgm2};
		List<CollaborationGroup> cgList2 = cov_groups_controller.findGroupsByMirrors(cgmList2);
		System.assert(cg1.Id == cgList2[0].Id || cg1.Id == cgList2[1].Id);
		System.assert(cg2.Id == cgList2[0].Id || cg2.Id == cgList2[1].Id);

		// test that method is bulkified
		CollaborationGroup cg3 = new CollaborationGroup(
			Name='Test Public Group 3', 
			CollaborationType='Public', 
			NetworkId=theNetworkId
			);
		insert cg3;
		Chatter_Group_Mirror__c cgm3 = new Chatter_Group_Mirror__c(Name = cg3.Name);
		Chatter_Group_Mirror__c cgm4 = new Chatter_Group_Mirror__c(Name = cg1.Name);
		try {
			insert new List<Chatter_Group_Mirror__c>{cgm3, cgm4};
			throw new myException('It should have thrown an error here.');
		} catch (Exception e) {
			System.assertEquals(true, e.getMessage().contains('already a Chatter Group Mirror for this group'));
		}
		System.assertEquals(0, [select Id from Chatter_Group_Mirror__c where Group_Id__c = :cg3.Id].size());
		insert cgm3;
		System.assertEquals(1, [select Id from Chatter_Group_Mirror__c where Group_Id__c = :cg3.Id].size());

	}

	static void insertAndAssertErrorMsg(Chatter_Group_Mirror__c cgm, String theMessage) {
		try {
			insert cgm;
			throw new myException('It should have thrown an error here.');
		} catch (Exception e) {
			System.assertEquals(true, e.getMessage().contains(theMessage));
		}

	}

	static void testMirrorRename() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		Id theNetworkId = cov_user_utility.self.getNetworkId();


		String group1Name = 'Test Public Group 1';

		CollaborationGroup cg1 = new CollaborationGroup(
			Name=group1Name, 
			CollaborationType='Public', 
			NetworkId=theNetworkId
			);
		insert cg1;
		System.debug('cg1: ' + cg1);

		Chatter_Group_Mirror__c cgm1 = new Chatter_Group_Mirror__c(Name = cg1.Name);
		insert cgm1;
		System.assertEquals(group1Name, [select Name from Chatter_Group_Mirror__c where Group_Id__c = :cg1.Id limit 1].Name);		

		String newName1 = 'New changed name';
		cg1.Name = newName1;
		update cg1;
		System.assertEquals(newName1, [select Name from Chatter_Group_Mirror__c where Group_Id__c = :cg1.Id limit 1].Name);				

	}

	@isTest static void cov_groups_mirrors_helper_methods() {


		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Id theNetworkId = cov_user_utility.self.getNetworkId();


		CollaborationGroup cg1 = new CollaborationGroup(
			Name='Test Public Group 1', 
			CollaborationType='Public', 
			NetworkId=theNetworkId
			);
		insert cg1;
		System.debug('cg1: ' + cg1);

		Chatter_Group_Mirror__c cgm1 = cov_groups_controller.createMirrorFromGroup(cg1);
		Chatter_Group_Mirror__c cgm1Query = [select Id, Name, Group_Id__c, Type__c from Chatter_Group_Mirror__c where Group_Id__c = :cg1.Id limit 1];
		System.assertEquals(cg1.Name, cgm1Query.Name);
		System.assertEquals(null, cgm1Query.Type__c);

		// Check that dupe is not created
		Chatter_Group_Mirror__c cgm1Dupe = cov_groups_controller.createMirrorFromGroup(cg1);
		System.assertEquals(cgm1.Id, cgm1Dupe.Id);



		CollaborationGroup cg2 = new CollaborationGroup(
			Name='Test Public Group 2', 
			CollaborationType='Public', 
			NetworkId=theNetworkId
			);
		insert cg2;
		System.debug('cg2: ' + cg2);

		Chatter_Group_Mirror__c cgm2 = cov_groups_controller.createMirrorFromGroup(cg2, 'Event');
		Chatter_Group_Mirror__c cgm2Query = [select Id, Name, Group_Id__c, Type__c from Chatter_Group_Mirror__c where Group_Id__c = :cg2.Id limit 1];
		System.assertEquals(cg2.Name, cgm2Query.Name);
		System.assertEquals('Event', cgm2Query.Type__c);


		System.assertEquals(cg1.Id, cov_groups_controller.findGroupByMirror(cgm1).Id);
		System.assertEquals(cg1.Id, cov_groups_controller.findGroupByMirrorId(cgm1.Id).Id);
		System.assertEquals(null, cov_groups_controller.findGroupByMirrorId(u.Id));

		List<Chatter_Group_Mirror__c> mirrorList = new List<Chatter_Group_Mirror__c>{cgm1, cgm2};
		List<CollaborationGroup> groupListReturned = cov_groups_controller.findGroupsByMirrors(mirrorList);
		System.assert((groupListReturned[0].Id == cg1.Id && groupListReturned[1].Id == cg2.Id) || (groupListReturned[0].Id == cg2.Id && groupListReturned[1].Id == cg1.Id));

		List<Id> mirrorIdList = new List<Id>{cgm1.Id, cgm2.Id};
		groupListReturned = cov_groups_controller.findGroupsByMirrorIds(mirrorIdList);
		System.assert((groupListReturned[0].Id == cg1.Id && groupListReturned[1].Id == cg2.Id) || (groupListReturned[0].Id == cg2.Id && groupListReturned[1].Id == cg1.Id));
		
		System.assertEquals(cgm1.Id, cov_groups_controller.findGroupMirrorByGroup(cg1).Id);
		System.assertEquals(cgm1.Id, cov_groups_controller.findGroupMirrorByGroupId(cg1.Id).Id);
		System.assertEquals(null, cov_groups_controller.findGroupMirrorByGroupId(u.Id));

		List<CollaborationGroup> groupList = new List<CollaborationGroup>{cg1, cg2};
		List<Chatter_Group_Mirror__c> mirrorListReturned = cov_groups_controller.findGroupMirrorsByGroups(groupList);
		System.assert((mirrorListReturned[0].Id == cgm1.Id && mirrorListReturned[1].Id == cgm2.Id) || (mirrorListReturned[0].Id == cgm2.Id && mirrorListReturned[1].Id == cgm1.Id));

		List<Id> groupIdList = new List<Id>{cg1.Id, cg2.Id};
		mirrorListReturned = cov_groups_controller.findGroupMirrorsByGroupIds(groupIdList);
		System.assert((mirrorListReturned[0].Id == cgm1.Id && mirrorListReturned[1].Id == cgm2.Id) || (mirrorListReturned[0].Id == cgm2.Id && mirrorListReturned[1].Id == cgm1.Id));

		// TEST MIRROR RENAME TRIGGER
		cg1.Name = 'New group 1 Name';
		update cg1;
		System.assertEquals(cg1.Name, [select Name from Chatter_Group_Mirror__c where Group_Id__c = :cg1.Id limit 1].Name);

		// TEST UNIQUE GROUP NAME METHOD
		System.assertEquals(cg1.Name + '-1', cov_groups_controller.createUniqueGroupName(cg1.Name, null));

		String longName32chars = '32 character Name That Cuts Off!';
		cg2.Name = '[Event] ' + longName32chars;
		System.assertEquals(40, cg2.Name.length());
		update cg2;
		System.assertEquals(cg2.Name.left(38) + '-1', cov_groups_controller.createUniqueGroupName(longName32chars, '[Event] '));

		// TEST DELETE TRIGGER
		System.assertEquals(1, [select Id from Chatter_Group_Mirror__c where Name = :cg2.Name].size());
		delete cg2;
		System.assertEquals(0, [select Id from Chatter_Group_Mirror__c where Name = :cg2.Name].size());

	}


	
}