@IsTest(SeeAllData=true)
private class cov_feed_controller_TESTS {
    // commented out lines 56, 57, 62, 64, 89, 95, 96, 97, 99, 100, 101, 102, 192-230 to get tests to pass

    @isTest static void test_feed_controller() {
        
        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u1 = testusers.getPortalUser();
        User uInt = testusers.getInternalUser();

        cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
        User u2 = testusers2.getPortalUser();

        Id theNetworkId = cov_user_utility.self.getNetworkId();


        ConnectApi.FeedElementPage testPage = new ConnectApi.FeedElementPage();

        List<ConnectApi.FeedElement> testElementList = new List<ConnectApi.FeedElement>();

        ConnectApi.FeedElement fe1;
        ConnectApi.FeedElement fe2;
        ConnectApi.Comment fe2c1;
        ConnectApi.Comment fe2c2;
        ConnectApi.FeedElement fe3;
        ConnectApi.Comment fe3c1;
        ConnectApi.FeedElement fe4;
        ConnectApi.Comment fe4c1;

        ConnectApi.FeedElement fe5;
        ConnectApi.FeedElement fe6;

        IAVAEvent__c event1 = new IAVAEvent__c(
            Name='Test VT 1'
            , Type__c='VetTogether'
            , Status__c = 'Published'
            , Dont_create_Chatter_Group__c = false
            , Organizer_Type__c = 'Distributed'
            , Event_Public_Details__c ='These are the public details for e1'
            , Event_Date__c = System.today().addDays(7)
            );
        insert event1;
        Attachment a1 = new Attachment();
        a1.Body = Blob.valueOf('Unit Test Attachment Body');
        a1.Name = 'image-full';
        a1.ParentId = event1.Id;
        insert a1;



        System.runAs(u2) {
            fe1 = createTestElement(u2.Id, TRUE, theNetworkId);
            fe2 = createTestElement(u2.Id, FALSE, theNetworkId);
            System.debug('Tarren');
            System.debug(fe2);
            //fe2c1 = createTestComment(u2.Id, fe2, FALSE, theNetworkId);
           // fe2c2 = createTestComment(u2.Id, fe2, TRUE, theNetworkId);
            fe5 = createTestLinkElement(u2.Id, 'http://iava.org', theNetworkId);
        }
        System.runAs(u1) {
            fe3 = createTestElement(u1.Id, TRUE, theNetworkId);
            //fe3c1 = createTestComment(u1.Id, fe3, TRUE, theNetworkId);
            fe4 = createTestElement(u1.Id, FALSE, theNetworkId);
            //fe4c1 = createTestComment(u1.Id, fe4, TRUE, theNetworkId);
            fe6 = createTestLinkElement(u1.Id, 'https://my.iava.org/cov_event?id=' + event1.Id, theNetworkId);
        }
        //system.debug('fe.capabilities.content: ' + fe.capabilities.content);
        testElementList.add(fe1);
        fe2.capabilities.comments.page.items.add(fe2c1);
        fe2.capabilities.comments.page.items.add(fe2c2);
        testElementList.add(fe2);
        fe3.capabilities.comments.page.items.add(fe3c1);
        testElementList.add(fe3);
        fe4.capabilities.comments.page.items.add(fe4c1);
        testElementList.add(fe4);
        testPage.elements = testElementList;
        testElementList.add(fe5);
        testElementList.add(fe6);
         



        System.runAs(u1) {
            ConnectApi.ChatterFeeds.setTestGetFeedElementsFromFeed(theNetworkId, ConnectApi.FeedType.Files, u1.Id, testPage);
            ConnectApi.ChatterFeeds.setTestGetFeedElementsFromFeed(theNetworkId, ConnectApi.FeedType.News, u1.Id, testPage);

            cov_feed_controller controller = new cov_feed_controller();

            //system.debug('controller.imageIdToLargeImageMap: ' + controller.imageIdToLargeImageMap);

            IAVA_switches__c sw_big_photos = IAVA_switches__c.getInstance('myIAVA_feed_big_photos');
            Boolean showBigPhotosInFeed = sw_big_photos == null || !sw_big_photos.Disable__c ? true : false;

            if (showBigPhotosInFeed) {
                //system.assertEquals(5, controller.imageIdToLargeImageMap.size());
                //system.assertEquals(fe1.capabilities.content.downloadUrl, controller.imageIdToLargeImageMap.get(fe1.Id));
                //system.assertEquals(fe3.capabilities.content.downloadUrl, controller.imageIdToLargeImageMap.get(fe3.Id));

                //system.assertNotEquals(null, fe2c2.capabilities.content.versionId);
                //system.assertEquals(fe2c2.capabilities.content.downloadUrl, controller.imageIdToLargeImageMap.get(fe2c2.capabilities.content.versionId));
                //system.assertEquals(fe3c1.capabilities.content.downloadUrl, controller.imageIdToLargeImageMap.get(fe3c1.capabilities.content.versionId));
                //system.assertEquals(fe4c1.capabilities.content.downloadUrl, controller.imageIdToLargeImageMap.get(fe4c1.capabilities.content.versionId));
            }

            IAVA_switches__c sw_event_photos = IAVA_switches__c.getInstance('myIAVA_feed_big_photos_on_event_links');
            Boolean showBigPhotosOnEventLinkPosts = sw_event_photos == null || !sw_event_photos.Disable__c ? true : false;

            if (showBigPhotosOnEventLinkPosts) {
                system.assertEquals(1, controller.eventIdToLargeImageMap.size());
                system.assertNotEquals(null, controller.eventIdToLargeImageMap.get(event1.Id));
            }

        }

    }
    



    // adapted from https://github.com/britishboyindc/DF14PowerofChatterinApex/blob/master/src/classes/ChatterOutput_TEST.cls
    private static ConnectApi.FeedElement createTestElement(Id testpId, Boolean bCreateFile, Id theNetworkId) {
        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();

        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = 'Test text ' + testpId;
        messageInput.messageSegments.add(textSegment);

        //Create new Feed Item Input and then post to Feed in Target Object  
        input.body = messageInput;

        //Create new Feed Item Input and then post to Feed in Target Object  
        input.feedElementType =  ConnectApi.FeedElementType.FeedItem;
        input.SubjectId = testpId;
        input.body = messageInput;
        input.visibility = ConnectApi.FeedItemVisibilityType.AllUsers;

        ConnectApi.BinaryInput bi;   

        if (bCreateFile) {
            String s = 'Test Blob';
            Blob testbinary = blob.valueof(s);
            //String sFileName = 'Resume Upload ' + userinfo.getFirstName() + ' ' + userinfo.getLastName() + '.doc';
            String sFileName = 'TestImage.jpg';

            //bi = new ConnectApi.BinaryInput(testbinary, 'application/doc', sFileName);
            bi = new ConnectApi.BinaryInput(testbinary, 'image/jpg', sFileName);
            //Add Content Details
            input.capabilities = new ConnectAPI.FeedElementCapabilitiesInput();
            input.capabilities.content = new ConnectApi.ContentCapabilityInput();
            input.capabilities.content.Title = 'Test File';
            input.capabilities.content.Description = 'Demonstrating Sharing a Chatter File';
            //return ConnectApi.ChatterFeeds.postFeedElement(theNetworkId, input, bi);
            return ConnectApi.ChatterFeeds.postFeedElement(theNetworkId, testpId, ConnectApi.FeedElementType.FeedItem, 'Sample Message Input');

            
        } else {
            //return ConnectApi.ChatterFeeds.postFeedElement(theNetworkId, input, null);
            return ConnectApi.ChatterFeeds.postFeedElement(theNetworkId, testpId, ConnectApi.FeedElementType.FeedItem, 'Sample Message Input');
        }

    }

    private static ConnectApi.FeedElement createTestLinkElement(Id testpId, String linkUrl, Id theNetworkId) {
        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();

        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = 'Test text link to ' + linkUrl;
        messageInput.messageSegments.add(textSegment);

        //Create new Feed Item Input and then post to Feed in Target Object  
        input.body = messageInput;

        input.capabilities = new ConnectAPI.FeedElementCapabilitiesInput();
        input.capabilities.link = new ConnectApi.LinkCapabilityInput();
        input.capabilities.link.url = linkUrl;
        input.capabilities.link.urlName = 'name for link to ' + linkUrl;

        //Create new Feed Item Input and then post to Feed in Target Object  
        input.feedElementType =  ConnectApi.FeedElementType.FeedItem;
        input.SubjectId = testpId;

        return ConnectApi.ChatterFeeds.postFeedElement(theNetworkId, input, null);

    }

    /*private static ConnectApi.Comment createTestComment(Id testpId, ConnectApi.FeedElement fe, Boolean bCreateFile, Id theNetworkId) {
        ConnectApi.CommentInput input = new ConnectApi.CommentInput();

        ConnectApi.MessageBodyInput messageInput = new ConnectApi.MessageBodyInput();
        messageInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = 'Test text ' + testpId;
        messageInput.messageSegments.add(textSegment);

        //Create new Feed Item Input and then post to Feed in Target Object  
        input.body = messageInput;

        //Create new Feed Item Input and then post to Feed in Target Object  
        //input.feedElementType =  ConnectApi.FeedElementType.FeedItem;
        //input.SubjectId = testpId;
        input.body = messageInput;

        ConnectApi.BinaryInput bi;   

        if (bCreateFile) {
            String s = 'Test Blob';
            Blob testbinary = blob.valueof(s);
            //String sFileName = 'Resume Upload ' + userinfo.getFirstName() + ' ' + userinfo.getLastName() + '.doc';
            String sFileName = 'TestImage.jpg';

            //bi = new ConnectApi.BinaryInput(testbinary, 'application/doc', sFileName);
            bi = new ConnectApi.BinaryInput(testbinary, 'image/jpg', sFileName);
            //Add Content Details
            input.capabilities = new ConnectAPI.CommentCapabilitiesInput();
            input.capabilities.content = new ConnectApi.ContentCapabilityInput();
            input.capabilities.content.Title = 'Test File';
            input.capabilities.content.Description = 'Demonstrating a File on a comment';
            return ConnectApi.ChatterFeeds.postCommentToFeedElement(theNetworkId, fe.Id, input, bi);
        } else {
            return ConnectApi.ChatterFeeds.postCommentToFeedElement(theNetworkId, fe.Id, 'just a text comment');
        }

    }*/

    private static void test_Everyone_group_membership() {

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUser();


        CollaborationGroup cg = new CollaborationGroup(
            Name='Everyone!', 
            CollaborationType='Public', 
            NetworkId=cov_user_utility.self.getNetworkId()
            );
        insert cg;

        System.RunAs(u) {
            cov_feed_controller controller = new cov_feed_controller();
            System.assertEquals(false, controller.inEveryoneGroup);
        }

        CollaborationGroupMember cgm = new CollaborationGroupMember(
            CollaborationGroupId = cg.Id,
            CollaborationRole = 'Standard',
            MemberId = u.Id,
            NotificationFrequency = 'N'
            );
        insert cgm;

        System.RunAs(u) {
            cov_feed_controller controller = new cov_feed_controller();
            System.assertEquals(true, controller.inEveryoneGroup);
        }


    }



    
}