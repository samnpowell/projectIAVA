@isTest
private class cov_recentactivity_controller_TESTS {
	
	@isTest static void test_cov_recentactivity_controller() {
		
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Id theNetworkId = cov_user_utility.self.getNetworkId();


		CollaborationGroup cg = new CollaborationGroup(
			Name='Test Public Group', 
			CollaborationType='Public', 
			NetworkId=theNetworkId
			);
		insert cg;
		System.debug('cg: ' + cg);

		User uInt = testusers.getInternalUser();
		//cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		//User u2 = testusers2.getPortalUser();

		List<FeedItem> f = new List<FeedItem>();
		// add a feedItem with a blank body (like a linkpost with just a link) to make sure that case is covered
		FeedItem blankF = new FeedItem(
			ParentId = cg.Id,
			Type = 'LinkPost',
			NetworkScope = theNetworkId,
			CreatedById = uInt.Id,
			LinkURL = 'http://iava.org'
			);	
		f.add(blankF);		

		for (Integer i=1; i<=cov_recentactivity_controller.MAX_POSTS + 3; i++) {
			f.add(new FeedItem(
				ParentId = cg.Id,
				Type = 'TextPost',
				NetworkScope = theNetworkId,
				CreatedById = uInt.Id,
				Body='Post number ' + i
				));
		}
		insert f;
		Set<Id> fIdSet = (new Map<Id,FeedItem>(f)).keySet();

		System.RunAs(u) {

			cov_recentactivity_controller controller = new cov_recentactivity_controller();
			List<cov_recentactivity_controller.customGroupedPost> cgp = controller.getRecentGroupedPosts();
			System.debug('cgp: ' + cgp);

			// test that linkURL got transfered to body field for a blank feeditem
			Integer blankPostIndex;
			for (Integer i=0; i < cgp[0].postlist.size(); i++) {
				if (cgp[0].postlist[i].feedItemId == blankF.Id) blankPostIndex = i;
			}
			if (blankPostIndex != null) {
				System.assertEquals('http://iava.org', cgp[0].postlist[blankPostIndex].bodyShortened);
			}

			System.assertEquals(cg.Id, cgp[0].g.Id);
			System.assertEquals(false, cgp[0].isMember);
			System.assertEquals(false, cgp[0].isPrivate);
			System.assertEquals(false, cgp[0].isOwner);

			System.assertEquals(true, fIdSet.contains(cgp[0].postList[0].feedItemId));
			//System.debug('cgp[0].postList.size(): ' + cgp[0].postList.size());
			//System.debug('cgp[0].postList: ' + cgp[0].postList);
			System.assertEquals(true, cgp[0].postList.size() <= cov_recentactivity_controller.MAX_POSTS);
			System.assertEquals(true, cgp[0].postList.size() <= cov_recentactivity_controller.MAX_POSTS_FROM_SINGLE_USER);

		}

		cg.CollaborationType='Private';
		update cg;

		System.RunAs(u) {

			cov_recentactivity_controller controller = new cov_recentactivity_controller();
			List<cov_recentactivity_controller.customGroupedPost> cgp = controller.getRecentGroupedPosts();

			System.assertEquals(0, cgp.size()); // private group should not appear so should be empty

		}

		CollaborationGroupMember cgm = new CollaborationGroupMember(
			CollaborationGroupId = cg.Id,
			CollaborationRole = 'Standard',
			MemberId = u.Id,
			NotificationFrequency = 'N'
			);
		insert cgm;

		System.RunAs(u) {

			cov_recentactivity_controller controller = new cov_recentactivity_controller();
			List<cov_recentactivity_controller.customGroupedPost> cgp = controller.getRecentGroupedPosts();

			System.assertEquals(cg.Id, cgp[0].g.Id);
			System.assertEquals(true, cgp[0].isMember);
			System.assertEquals(true, cgp[0].isPrivate);
			System.assertEquals(false, cgp[0].isOwner);

			System.assertEquals(1, cgp.size()); // private group should appear since user is a member
			System.assertEquals(true, fIdSet.contains(cgp[0].postList[0].feedItemId));
			//System.assertEquals(f[0].Id, cgp[0].postList[0].feedItemId);

		}


		cg.OwnerId = u.Id;
		update cg;

		CollaborationGroup cg2 = new CollaborationGroup(
			Name='Test Public Group 2', 
			CollaborationType='Public', 
			NetworkId=theNetworkId
			);
		insert cg2;


		System.RunAs(u) {

			cov_recentactivity_controller controller = new cov_recentactivity_controller();
			List<cov_recentactivity_controller.customGroupedPost> cgp = controller.getRecentGroupedPosts();

			System.assertEquals(true, cgp[0].isOwner);

			FeedItem f2 = new FeedItem(
					ParentId = cg2.Id,
					Type = 'TextPost',
					NetworkScope = theNetworkId,
					CreatedById = u.Id,
					Body='own post'
					);
			insert f2;

			System.assertEquals(1, cgp.size()); // first group still appears but second doesnt since post is from running user

		}

		String longbody = '';
		for (Integer i = 1; i < cov_recentactivity_controller.POST_PREVIEW_CHAR_LENGTH/2 + 10; i++) {
			longbody += 'a ';
		}
		longbody = longbody.trim();

		FeedItem f3 = new FeedItem(
				ParentId = cg2.Id,
				Type = 'TextPost',
				NetworkScope = theNetworkId,
				CreatedById = uInt.Id,
				Body=longbody
				);
		insert f3;


		CollaborationGroupMember cgm2 = new CollaborationGroupMember(
			CollaborationGroupId = cg.Id,
			CollaborationRole = 'Standard',
			MemberId = uInt.Id,
			NotificationFrequency = 'N'
			);
		insert cgm2;


		System.RunAs(u) {

			cov_recentactivity_controller controller = new cov_recentactivity_controller();
			List<cov_recentactivity_controller.customGroupedPost> cgp = controller.getRecentGroupedPosts();

			System.assertEquals(2, controller.posts.size());
			System.assertEquals(true, cg2.Id == cgp[0].g.Id || cg2.Id == cgp[1].g.Id);
			System.assertEquals(true, f3.Body == cgp[0].postList[0].body || f3.Body == cgp[1].postList[0].body);
			String longbodyShortened = longbody.left(cov_recentactivity_controller.POST_PREVIEW_CHAR_LENGTH)+'...';
			System.debug('longbodyShortened: ' + longbodyShortened);
			System.debug('cgp[0].postList[0].bodyShortened: ' + cgp[0].postList[0].bodyShortened);
			System.debug('cgp[1].postList[0].bodyShortened: ' + cgp[1].postList[0].bodyShortened);
			System.assertEquals(true, longbodyShortened == cgp[0].postList[0].bodyShortened || longbodyShortened == cgp[1].postList[0].bodyShortened);

			cg.OwnerId = uInt.Id;
			update cg;
			delete cgm;
			controller.refresh();
			System.assertEquals(1, controller.posts.size());


		}

		String longword = '';
		for (Integer i = 1; i < cov_recentactivity_controller.POST_MAX_WORD_LENGTH + 5; i++ ) {
			longword += 'b';
		}
		String longwordProcessed = longword.left(cov_recentactivity_controller.POST_MAX_WORD_LENGTH - 7) + '...' + longword.right(4);
		
		delete f3;

		FeedItem f4 = new FeedItem(
				ParentId = cg2.Id,
				Type = 'TextPost',
				NetworkScope = theNetworkId,
				CreatedById = uInt.Id,
				Body='Now testing a long word like ' + longword + ' in the post body'
				);
		insert f4;

		System.RunAs(u) {
			cov_recentactivity_controller controller = new cov_recentactivity_controller();
			List<cov_recentactivity_controller.customGroupedPost> cgp = controller.getRecentGroupedPosts();
			System.assertEquals(true, cgp[0].postList[0].bodyShortened.contains(longwordProcessed) || cgp[1].postList[0].bodyShortened.contains(longwordProcessed));
		}

	}


	@isTest static void test_event_group() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Id theNetworkId = cov_user_utility.self.getNetworkId();


		CollaborationGroup cg = new CollaborationGroup(
			Name='Test Public Group', 
			CollaborationType='Public', 
			NetworkId=theNetworkId
			);
		insert cg;
		System.debug('cg: ' + cg);

		User uInt = testusers.getInternalUser();

		FeedItem f = new FeedItem(
			ParentId = cg.Id,
			Type = 'LinkPost',
			NetworkScope = theNetworkId,
			CreatedById = uInt.Id,
			LinkURL = 'http://iava.org',
			Body = 'Here is a post.'
			);	
		insert f;		


		System.RunAs(u) {

			cov_recentactivity_controller controller = new cov_recentactivity_controller();
			List<cov_recentactivity_controller.customGroupedPost> cgp = controller.getRecentGroupedPosts();

			System.assertEquals(1, cgp.size()); // group should appear since it's not an event group

		}

		cg.Name = '[Event] ' + cg.Name;
		update cg;

		System.RunAs(u) {

			cov_recentactivity_controller controller = new cov_recentactivity_controller();
			List<cov_recentactivity_controller.customGroupedPost> cgp = controller.getRecentGroupedPosts();

			System.assertEquals(0, cgp.size()); // group should not appear since it's now an event group

		}


	}	




	@isTest static void test_unlisted_group() {
		
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		User uInt = testusers.getInternalUser();
		Id theNetworkId = cov_user_utility.self.getNetworkId();

		// create add an unlisted group
		CollaborationGroup cgU = new CollaborationGroup(
			Name='Test Unlisted Group', 
			CollaborationType='Unlisted', 
			NetworkId=theNetworkId
			);
		insert cgU;
		System.debug('cgU: ' + cgU);

		// add the internal user to the unlisted group so can post
		CollaborationGroupMember cgUIntm = new CollaborationGroupMember(
			CollaborationGroupId = cgU.Id,
			CollaborationRole = 'Standard',
			MemberId = uInt.Id,
			NotificationFrequency = 'N'
			);
		insert cgUIntm;

		// insert a post in the unlisted group
		FeedItem unlistedF = new FeedItem(
			ParentId = cgU.Id,
			Type = 'LinkPost',
			NetworkScope = theNetworkId,
			CreatedById = uInt.Id,
			LinkURL = 'http://iava.org'
			);	
		insert unlistedF;	


		System.RunAs(u) {

			cov_recentactivity_controller controller = new cov_recentactivity_controller();
			List<cov_recentactivity_controller.customGroupedPost> cgp = controller.getRecentGroupedPosts();

			System.assertEquals(0, cgp.size()); // unlisted groups should not appear so should be empty

		}


		// now add user to unlisted group so unlisted group posts show up
		CollaborationGroupMember cgmU = new CollaborationGroupMember(
			CollaborationGroupId = cgU.Id,
			CollaborationRole = 'Standard',
			MemberId = u.Id,
			NotificationFrequency = 'N'
			);
		insert cgmU;

		System.RunAs(u) {

			cov_recentactivity_controller controller = new cov_recentactivity_controller();
			List<cov_recentactivity_controller.customGroupedPost> cgp = controller.getRecentGroupedPosts();

			System.assertEquals(1, cgp.size()); // unlisted group should appear since user is a member
			System.assert(cgU.Id == cgp[0].g.Id);
			System.assertEquals(true, cgp[0].isMember);
			System.assertEquals(true, cgp[0].isPrivate);
			System.assertEquals(false, cgp[0].isOwner);

			System.assertEquals(unlistedF.Id, cgp[0].postList[0].feedItemId);

		}

	}


	
	
}