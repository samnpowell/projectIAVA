// needs SeeAllData=true to test connectAPI method for adding photo to group
// but that causes an internal server error so commenting out
//@isTest(SeeAllData=true)

@isTest
private class cov_event_entry_controller_TESTS {

	static testMethod void test_event_entry() {

		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();

		IAVAEvent__c e1;

		System.runAs(u) {
			cov_user_utility.self.refreshSelf();

			PageReference pageRef = Page.cov_event_entry;
	        Test.setCurrentPage(pageRef);

	        e1 = new IAVAEvent__c();
	        ApexPages.StandardController sc = new ApexPages.standardController(e1);
	        cov_event_entry_controller controller = new cov_event_entry_controller(sc);
	        System.assertEquals(false, controller.costCheckbox);

	        e1.Name = 'Unit Test Name 1';
	        e1.Type__c = 'VetTogether';
	        e1.Event_Date__c = System.today().addDays(14);
	        e1.Start_Time__c = '7:00 PM';
	        //e1.Location_Street_Address__c = '1114 Main St';
	        //e1.Location_City__c = 'Test City';
	        //e1.Location_State__c = 'TS';
	        //e1.Location_Zip_Code__c = '12345';
	        e1.Reply_Cap__c = 5;
	        e1.Associated_Cost__c = 15.50;
	        e1.Cost_Description__c = 'Two people per entry';

	        PageReference pr = controller.save();

	        // save should not have worked without user agreeing to host TOS
	        system.assertEquals(null, pr);
	        System.AssertEquals(true, ApexPages.getMessages()[0].getSummary().contains('Leader Code of Conduct'));

	        // now check host TOS box and try again
	        controller.hostTOSAccepted = true;

	        pr = controller.save();

	        List<IAVAEvent__c> evs = [select Id, Name, Type__c, Organizer_Type__c, OwnerId
	        								, Date_Accepted_Host_TOS__c
	        								, Status__c, Chatter_Group_Mirror__c
	        								, Location_City__c, Location_State__c 
	        								, Location_Street_Address__c, Location_Zip_Code__c
	        								, Start_Time__c, Event_Date__c, Creator_Contact__c, Reply_Cap__c
	        								, Associated_Cost__c, Cost_Description__c, Tier__c
	        								from IAVAEvent__c where Name = 'Unit Test Name 1'
	        								];
	        System.assertEquals(1, evs.size());
	        System.assertNotEquals(null, evs[0].Date_Accepted_Host_TOS__c);
	        system.assert(evs[0].Date_Accepted_Host_TOS__c > System.now().addMinutes(-10) && evs[0].Date_Accepted_Host_TOS__c <= System.now());
	        System.assertEquals('/apex/cov_event?id=' + evs[0].Id, pr.getUrl());
	        System.assertEquals('VetTogether', evs[0].Type__c);
	        System.assertEquals('Distributed', evs[0].Organizer_Type__c);
	        System.assertEquals('Unpublished', evs[0].Status__c);
	        System.assertEquals('3', evs[0].Tier__c);
	        System.assertEquals(c.Id, evs[0].Creator_Contact__c);
	        System.assertEquals(5, evs[0].Reply_Cap__c);
	        System.assertEquals(e1.Associated_Cost__c, evs[0].Associated_Cost__c);
	        System.assertEquals(e1.Cost_Description__c, evs[0].Cost_Description__c);
	        System.assertEquals(null, evs[0].Chatter_Group_Mirror__c);
	        System.assertEquals(0, [select Id from CollaborationGroup where Name = :('[Event] ' + e1.Name)].size());

	        e1.Date_Accepted_Host_TOS__c = evs[0].Date_Accepted_Host_TOS__c;

	        pageRef = Page.cov_event_entry;
	        pageRef.getParameters().put('id', evs[0].Id);
	        Test.setCurrentPage(pageRef);
	        e1 = evs[0];
			sc = new ApexPages.standardController(e1);
	        controller = new cov_event_entry_controller(sc);
	        System.assertEquals(true, controller.costCheckbox);	        

	        e1.Location_Street_Address__c = '1114 Main St';
	        e1.Location_City__c = 'Test City';
	        e1.Location_State__c = 'TS';
	        e1.Location_Zip_Code__c = '12345';
	        controller.costCheckbox = false;
			pr = controller.save();
			String addressParam = (e1.Location_Street_Address__c + ' ' + e1.Location_City__c + ' ' + e1.Location_State__c + ' ' + e1.Location_Zip_Code__c).replaceAll(' ', '%2B');
	        System.assertEquals('/apex/cov_event_geolocate?address=' + addressParam + '&id=' + evs[0].Id, pr.getUrl());

	        System.assertEquals(null, evs[0].Associated_Cost__c);
	        System.assertEquals(null, evs[0].Cost_Description__c);

	        pageRef = Page.cov_event_entry;
	        pageRef.getParameters().put('id', evs[0].Id);
	        Test.setCurrentPage(pageRef);
	        e1 = evs[0];
			sc = new ApexPages.standardController(e1);
	        controller = new cov_event_entry_controller(sc);



	        //TEST ATTACHMENTS

	        // no attachments yet
	        System.assertEquals(null, controller.existingImageId);
	        System.assertEquals(0, [select Id, Name from Attachment where ParentId = :evs[0].Id].size());

	        // only a fullsize attachment added
	        controller.newImageFull = 'R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==';
	        controller.newImageName = 'random-filename.jpg';
	        controller.newImageType = 'image/jpg';
	        controller.save();

	        System.assertNotEquals(null, controller.existingImageId);
	        List<Attachment> atts = [select Id, Name from Attachment where ParentId = :evs[0].Id];
	        System.assertEquals(1, atts.size());
	        System.assert(atts[0].Name.startsWith('image-full'));

	        // delete full size attachment
	        controller.deletePic();
	        System.assertEquals(null, controller.existingImageId);
	        System.assertEquals(0, [select Id, Name from Attachment where ParentId = :evs[0].Id].size());

	        // add both full size and thumbnail attachments
	        controller.newImageFull = 'R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==';
	        controller.newImageThumb = 'R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==';
	        controller.newImageName = 'random-filename.jpg';
	        controller.newImageType = 'image/jpg';
	        controller.save();

	        System.assertNotEquals(null, controller.existingImageId);
	        atts = [select Id, Name from Attachment where ParentId = :evs[0].Id];
	        System.assertEquals(2, atts.size());
	        System.assert(
	        	(atts[0].Name.startsWith('image-full') && atts[1].Name.startsWith('image-thumb'))
	        	||
	        	(atts[1].Name.startsWith('image-full') && atts[0].Name.startsWith('image-thumb'))
	        	);

	        // delete both attachments
	        controller.deletePic();
	        System.assertEquals(null, controller.existingImageId);
	        System.assertEquals(0, [select Id, Name from Attachment where ParentId = :evs[0].Id].size());


	        System.assertEquals('Unpublished', evs[0].Status__c);
	        System.assertEquals(0, [select Id from CollaborationGroup where Name = :('[Event] ' + e1.Name)].size());

	        e1 = evs[0];
			sc = new ApexPages.standardController(e1);
	        controller = new cov_event_entry_controller(sc);
	        System.assertEquals('Test City', evs[0].Location_City__c);
	        e1.Location_City__c = 'Changed City';
	        controller.save();
	        evs = [select Id, Name, Type__c, Organizer_Type__c, OwnerId
	        								, Date_Accepted_Host_TOS__c
	        								, Status__c, Chatter_Group_Mirror__c
	        								, Location_City__c, Location_State__c
	        								, Location_Street_Address__c, Location_Zip_Code__c
	        								, Start_Time__c, Event_Date__c
	        								, Associated_Cost__c, Cost_Description__c
	        								from IAVAEvent__c where Name = 'Unit Test Name 1'
	        								];
	        System.assertEquals('Changed City', evs[0].Location_City__c);
	        System.assertEquals(null, evs[0].Chatter_Group_Mirror__c);

			pageRef = Page.cov_event_entry;
	        pageRef.getParameters().put('id', evs[0].Id);
	        Test.setCurrentPage(pageRef);
	        e1 = evs[0];
	        system.debug('e1.Chatter_Group_Mirror__c before publish: ' + e1.Chatter_Group_Mirror__c);
			sc = new ApexPages.standardController(e1);
	        controller = new cov_event_entry_controller(sc);
	        System.assertEquals('7:00 PM', evs[0].Start_Time__c);
	        e1.Start_Time__c = '8:00 PM';
	        controller.savePublish();
	        evs = [select Id, Name, Type__c, Organizer_Type__c, OwnerId
	        								, Status__c, Chatter_Group_Mirror__c
	        								, Location_City__c, Location_State__c
	        								, Location_Street_Address__c, Location_Zip_Code__c
	        								, Start_Time__c, Event_Date__c
	        								from IAVAEvent__c where Name = 'Unit Test Name 1'
	        								];
	        system.debug('evs[0].Chatter_Group_Mirror__c after publish: ' + evs[0].Chatter_Group_Mirror__c);
	        System.assertEquals('8:00 PM', evs[0].Start_Time__c);
	        System.assertEquals('Published', evs[0].Status__c);
	        System.assertNotEquals(null, evs[0].Chatter_Group_Mirror__c);
	        List <CollaborationGroup> cgs = [select Id, FullPhotoUrl from CollaborationGroup where Name = :('[Event] ' + e1.Name)];
	        System.assertEquals(1, cgs.size());


	        // Test that event creator got added to event with a "Yes" reply
	        List<IAVAEvent_Attendee__c> creatorAttendee = [select Id, Reply_Status__c from IAVAEvent_Attendee__c 
	        												where Event__c = :evs[0].Id
	        												and Contact__c = :c.Id
	        												];
	        System.assertEquals(1, creatorAttendee.size());
	        System.assertEquals('Yes', creatorAttendee[0].Reply_Status__c);

	        List<CollaborationGroupMember> creatorGroupMember = [select Id, NotificationFrequency from CollaborationGroupMember 
	        												where CollaborationGroupId = :cgs[0].Id
	        												and MemberId = :u.Id
	        												];
	        System.assertEquals(1, creatorGroupMember.size());
	        System.assertEquals('P', creatorGroupMember[0].NotificationFrequency);

	        //Test that default group created feeditem was deleted
	        List<CollaborationGroupFeed> cgfeeditems = [select Id from CollaborationGroupFeed
	        								where Type = 'CollaborationGroupCreated'
	        								and ParentId = :u.Id
	        								and CreatedDate = TODAY
	        								];
	        System.assertEquals(0, cgfeeditems.size());

	        // Test that replacement feeditem got created
			List<UserFeed> ufeeditems = [select Id, Title from UserFeed
	        								where Type = 'LinkPost'
	        								and ParentId = :u.Id
	        								and CreatedDate = TODAY
	        								];
	        System.assertEquals(1, ufeeditems.size());
	        System.assertEquals(evs[0].Name, ufeeditems[0].Title);


	        // Currently it doesnt add the photo to the group unless it's uploaded to a published event
	        // so cant test this here
	        //System.assert(!cgs[0].FullPhotoUrl.contains('0F9'));

	        // delete both attachments after group created to get coverage chatterAPI photo deletion code
	        System.assertEquals(null, controller.existingImageId);
	        System.assertEquals(0, [select Id, Name from Attachment where ParentId = :evs[0].Id].size());
	        controller.newImageFull = 'R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==';
	        controller.newImageThumb = 'R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==';
	        controller.newImageName = 'random-filename.jpg';
	        controller.newImageType = 'image/jpg';
	        controller.save();
	        System.assertNotEquals(null, controller.existingImageId);
	        System.assertEquals(2, [select Id, Name from Attachment where ParentId = :evs[0].Id].size());
	        controller.deletePic();
	        System.assertEquals(null, controller.existingImageId);
	        System.assertEquals(0, [select Id, Name from Attachment where ParentId = :evs[0].Id].size());



	        // these were tests for the remote action method, now deprecated

	  //      String fileBody = 'R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==';
	  //      String sitePrefix = 'http://my.iava.org';
	  //      Id attId = cov_event_entry_controller.uploadImage(e1.Id, sitePrefix, 'image-full-random-filename.jpg', 'image/jpg', fileBody);
	  //      controller = new cov_event_entry_controller(sc);

	  //     	System.assertNotEquals(null, controller.existingImageId);
	  //     	System.assertEquals(attId, controller.existingImageId);
	  //     	System.assertEquals(null, [select Thumbnail_image_URL__c from IAVAEvent__c where Id = :e1.Id].Thumbnail_image_URL__c);

	  //      controller.deletePic();
	  //      controller.existingImageId = null;
			//System.assertEquals(null, controller.existingImageId);	        

	  //      Id thumbId = cov_event_entry_controller.uploadImage(e1.Id, sitePrefix, 'image-thumb-random-filename.jpg', 'image/jpg', fileBody);
	  //      controller = new cov_event_entry_controller(sc);
	  //     	System.assertEquals(sitePrefix + 'servlet/servlet.FileDownload?file=' + thumbId, [select Thumbnail_image_URL__c from IAVAEvent__c where Id = :e1.Id].Thumbnail_image_URL__c);





	        //// fake test coverage on the photo getting added to the group
	        //controller.imageFile = new Attachment(Body=EncodingUtil.base64decode('R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==')
	        //										, Name='random-filename.jpg');
	        //controller.uploadImageContentType = '.jpg';
	        //system.debug('controller.imageFile in test after assignment: ' + controller.imageFile);
	        //controller.save();
	        evs = [select Id, Name, Type__c, Organizer_Type__c, OwnerId
	        								, Date_Accepted_Host_TOS__c
	        								, Status__c, Chatter_Group_Mirror__c
	        								, Location_City__c, Location_State__c
	        								, Location_Street_Address__c, Location_Zip_Code__c
	        								, Start_Time__c, Event_Date__c
	        								, Associated_Cost__c, Cost_Description__c
	        								from IAVAEvent__c where Name = 'Unit Test Name 1'
	        								];

	        e1 = evs[0];
			sc = new ApexPages.standardController(e1);
	        controller = new cov_event_entry_controller(sc);
	        controller.saveCancel();
	        evs = [select Id, Name, Type__c, Organizer_Type__c, OwnerId
	        								, Status__c, Chatter_Group_Mirror__c
	        								, Location_City__c, Location_State__c
	        								, Location_Street_Address__c, Location_Zip_Code__c
	        								, Start_Time__c, Event_Date__c
	        								, Associated_Cost__c, Cost_Description__c
	        								from IAVAEvent__c where Name = 'Unit Test Name 1'
	        								];
	        System.assertEquals('Canceled', evs[0].Status__c);


	        // test getStateOptions
	        List<SelectOption> states = controller.getStateOptions();
	        Set<String> statesSet = new Set<String>();
	        for(SelectOption s : states) {
	        	statesSet.add(s.getValue());
	        }
	        System.assert(statesSet.contains('CA'));
	        System.assert(statesSet.contains('NY'));
	        System.assert(statesSet.contains('HI'));
	        System.assert(statesSet.contains('NM'));

	        // ~ Imagefile
	        // √ create group
	        // x group photo
	        // Delete feeditems
	        // create feeditem

			//atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
	  //  	System.assertEquals(1, atts.size());	
	  //  	System.assertEquals('Yes', atts[0].Reply_Status__c);	




	  //      List<Apexpages.Message> msgs = ApexPages.getMessages();
			//boolean b = false;
			//for(Apexpages.Message msg:msgs){
			//    if (msg.getDetail().contains('Search requires more characters')) b = true;
			//}
			//system.assert(b);


		}


	}





}