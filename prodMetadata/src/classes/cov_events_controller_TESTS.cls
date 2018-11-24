@isTest
private class cov_events_controller_TESTS {

    static testMethod void cov_events_basics()
    {        
        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(-3)); // start with date already past
        insert e1;
        System.debug('e1: ' + e1);

        IAVAEvent__c e2 = new IAVAEvent__c(Name='Test Social 2', Type__c='Social', Status__c = 'Unpublished', Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e2', Event_Date__c = System.today().addDays(2));
        insert e2;
        System.debug('e2: ' + e2);

        IAVAEvent__c e3 = new IAVAEvent__c(Name='Test Support 3', Type__c='Support', Status__c = 'Unpublished', Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e3', Event_Date__c = System.today().addDays(2));
        insert e3;
        System.debug('e3: ' + e3);
        
        Attachment a1 = new Attachment();
        a1.Body = Blob.valueOf('Unit Test Attachment Body');
        a1.Name = 'image-full';
        a1.ParentId = e1.Id;
        insert a1;

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUser();
        Contact c = testusers.getPortalContact();
        
        Test.startTest();
        List<IAVAEvent_Attendee__c> atts = [select Id from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
        System.assertEquals(atts.size(), 0);

        System.runAs(u)
        {    
            cov_user_utility.self.refreshSelf();

            cov_events_controller controller = new cov_events_controller();

            // Initially no events should come up since e1 has passed and c2 is unpublished
            controller.getEventsList();
            System.assertEquals(0, controller.cEventsList.size());
            System.assertEquals(false, controller.hasEvents);
        }

        // e2 should come up if published
        e2.Status__c = 'Published';
        e2.Dont_create_Chatter_Group__c = false;
        update e2;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();
            System.assertEquals(1, controller.cEventsList.size());
            System.assertEquals(true, controller.hasEvents);
            System.assertEquals(0, controller.mycEventsList.size());
            System.assertEquals(false, controller.hasMyEvents);
        }

        // my events count should increment if the user is the owner
        e2.ownerId = u.Id;
        update e2;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();
            System.assertEquals(1, controller.cEventsList.size());
            System.assertEquals(true, controller.hasEvents);
            System.assertEquals(1, controller.mycEventsList.size());
            System.assertEquals(true, controller.hasMyEvents);
            System.assertEquals(0, controller.mycEventsToTrackList.size());
            System.assertEquals(false, controller.hasMyEventsToTrack);
        }

        //e3 should also come up both places if published and owned by the user
        e3.Status__c = 'Published';
        e3.ownerId = u.Id;
        update e3;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();
            System.assertEquals(2, controller.cEventsList.size());
            System.assertEquals(true, controller.hasEvents);
            System.assertEquals(2, controller.mycEventsList.size());
            System.assertEquals(true, controller.hasMyEvents);
            System.assertEquals(0, controller.mycEventsToTrackList.size());
            System.assertEquals(false, controller.hasMyEventsToTrack);
        }

        // e1 should come up also with Event_Date__c tomorrow
        e1.Event_Date__c = System.today().addDays(1);
        update e1;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();
            System.assertEquals(3, controller.cEventsList.size());
        }

        // e1 should still come up with Event_Date__c in future
        e1.Event_Date__c = System.today().addDays(4);
        update e1;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();
            System.assertEquals(3, controller.cEventsList.size());
            System.assertEquals(2, controller.mycEventsList.size());
            System.assertEquals(true, controller.hasMyEvents);
        }

        // if e2 and e3 Event_Date__c in past it should still come up on My Events but not All Events
        e2.Event_Date__c = System.today().addDays(-4);
        update e2;
        e3.Event_Date__c = System.today().addDays(-1);
        update e3;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();
            System.assertEquals(1, controller.cEventsList.size());
            System.assertNotEquals(e2.Id, controller.cEventsList[0].eId);
            System.assertNotEquals(e3.Id, controller.cEventsList[0].eId);
            System.assertEquals(2, controller.mycEventsList.size());
            System.assert(controller.mycEventsList[0].eId == e2.Id || controller.mycEventsList[0].eId == e3.Id);
            System.assert(controller.mycEventsList[1].eId == e2.Id || controller.mycEventsList[1].eId == e3.Id);
            System.assertEquals(true, controller.hasMyEvents);

            //only e3 should be in events to track since within last 2 days
            System.assertEquals(1, controller.mycEventsToTrackList.size());
            System.assertEquals(true, controller.hasMyEventsToTrack);
        }

        e2.Event_Date__c = System.today().addDays(-10);
        update e2;
        e3.Event_Date__c = System.today();
        update e3;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();

            //now only e3 shows up (today) in events to track while e2 is too old
            System.assertEquals(1, controller.mycEventsToTrackList.size());
            System.assertEquals(true, controller.hasMyEventsToTrack);
            System.assertEquals(e3.Id, controller.mycEventsToTrackList[0].eId);
        }

        // reset e2 and c3 dates to future so they show up on All Events
        e3.Event_Date__c = System.today().addDays(4);
        update e3;        
        e2.Event_Date__c = System.today().addDays(1);

        // e2 should not come up with status Canceled
        e2.Status__c = 'Canceled';
        update e2;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();
            System.assertEquals(2, controller.cEventsList.size());
            System.assertNotEquals(e2.Id, controller.cEventsList[0].eId);
            System.assertNotEquals(e2.Id, controller.cEventsList[1].eId);
        }

        // e2 should not come up with other statuses
        e2.Status__c = 'Flagged/Removed';
        update e2;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();
            System.assertEquals(2, controller.cEventsList.size());
            System.assertNotEquals(e2.Id, controller.cEventsList[0].eId);
            System.assertNotEquals(e2.Id, controller.cEventsList[1].eId);
        }

        // e2 should come up if status Unpublished as long as it's still owned by the user
        e2.Status__c = 'Unpublished';
        update e2;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();
            System.assertEquals(3, controller.cEventsList.size());
            System.assertEquals(true, controller.hasEvents);
            System.assertEquals(2, controller.mycEventsList.size());
            System.assertEquals(true, controller.hasMyEvents);
        }

        // but if not owned by the user e2 should not come up if status Unpublished
        e2.ownerId = UserInfo.getUserId();
        update e2;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();
            System.assertEquals(2, controller.cEventsList.size());
            System.assertEquals(true, controller.hasEvents);
            System.assertEquals(1, controller.mycEventsList.size());
            System.assertEquals(true, controller.hasMyEvents);
        }

        // if no events owned by user then My Events should be empty
        e3.ownerId = UserInfo.getUserId();
        update e3;

        System.runAs(u)
        {
            cov_events_controller controller = new cov_events_controller();

            controller.getEventsList();
            System.assertEquals(2, controller.cEventsList.size());
            System.assertEquals(true, controller.hasEvents);
            System.assertEquals(0, controller.mycEventsList.size());
            System.assertEquals(false, controller.hasMyEvents);
        }

        // But e2 should come up if unpublished and the user is the owner
        // (have to do this outside of portal user context)
        e2.OwnerId = u.Id;
        update e2;

        System.RunAs(u)
        {
            // now go back into portal user context to test
            cov_user_utility.self.refreshSelf();
            cov_events_controller controller = new cov_events_controller();
            controller.getEventsList();
            System.assertEquals(3, controller.cEventsList.size());
        }
        Test.stopTest();
    }

    static testMethod void cov_events_refresh_methods()
    {    
        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3));
        insert e1;
        System.debug('e1: ' + e1);

        IAVAEvent__c e2 = new IAVAEvent__c(Name='Test Social 2', Type__c='Social', Status__c = 'Unpublished', Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e2', Event_Date__c = System.today().addDays(1));
        insert e2;
        System.debug('e2: ' + e2);

        IAVAEvent__c e3 = new IAVAEvent__c(Name='Test Support 3', Type__c='Support', Status__c = 'Unpublished', Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e3', Event_Date__c = System.today().addDays(12));
        insert e3;
        System.debug('e3: ' + e3);
        
        Attachment a1 = new Attachment();
        a1.Body = Blob.valueOf('Unit Test Attachment Body');
        a1.Name = 'image-full';
        a1.ParentId = e1.Id;
        insert a1;

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUser();
        Contact c = testusers.getPortalContact();

        Test.startTest();
        cov_events_controller controller = new cov_events_controller();
        
        // now test page refresh methods for dashboard page
        controller.cEventsList = null;
        controller.refreshEventsSection();
        System.assertEquals(3, controller.cEventsList.size());
        
        controller.cEventsList = null;
        controller.NUM_ROWS_DEFAULT = 1;
        controller.numRows = 1;
        controller.refreshEventsSection();
        System.assertEquals(1, controller.numRows);
        controller.showAll();
        System.assertEquals(3, controller.numRows);
        controller.showFewer();
        System.assertEquals(1, controller.numRows);
        
        // now page refresh method for event page
        PageReference pageRefBefore = Page.cov_event;
        Test.setCurrentPage(pageRefBefore);
        ApexPages.currentPage().getParameters().put('id', e1.Id);
        controller.getEventID();
        controller.includePageRefresher = true;
        PageReference prRefresh = controller.refreshPage();
        System.assertEquals(e1.Id, prRefresh.getParameters().get('id'));
        System.assertEquals(false, controller.includePageRefresher);
        
        // now utility methods for invite page
        PageReference pageRef = Page.cov_event;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', e1.Id);
        controller.getEventID();
        
        System.assertEquals(false, controller.inInviteMode);
        controller.toInviteMode();
        System.assertEquals(true, controller.inInviteMode); 
        PageReference pr1 = controller.toDetailPage();
        System.assertEquals('/apex/cov_event?id='+e1.Id, pr1.getUrl());
        System.assertEquals(e1.Id, pr1.getParameters().get('id'));
        System.assertEquals(null, pr1.getParameters().get('header'));
        System.assertEquals(false, controller.inInviteMode);
        System.assertEquals('cov_template', controller.templateName);
        
        // also test that header parameter gets passed along and template name is adjusted accordingly
        pageRef = Page.cov_event;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', e1.Id);
        ApexPages.currentPage().getParameters().put('header', 'false');
        controller = new cov_events_controller();
        controller.getEventID();
        
        System.assertEquals(false, controller.inInviteMode);
        controller.toInviteMode();
        System.assertEquals(true, controller.inInviteMode); 
        PageReference pr2 = controller.toDetailPage();
        System.assert(pr2.getUrl().contains('/apex/cov_event'));
        System.assert(pr2.getUrl().contains('id='+e1.Id));
        System.assert(pr2.getUrl().contains('header=false'));
        System.assertEquals(e1.Id, pr2.getParameters().get('id'));
        System.assertEquals('false', pr2.getParameters().get('header'));
        System.assertEquals(false, controller.inInviteMode);
        System.assertEquals('cov_template_noheader', controller.templateName);
        
        Test.stopTest();
    }

    static testMethod void cov_events_joining()
    {
        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3));
        insert e1;
        System.debug('e1: ' + e1);

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUser();
        Contact c = testusers.getPortalContact();

        List<IAVAEvent_Attendee__c> atts;

        cov_events_controller controller;

        System.runAs(u)
        {
            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();

            // test joining an event
            // first have to create customevent variable ce
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();
            controller.eventIdChosen = null;
            controller.eventIdChosen = controller.ce.eId;
            controller.replyValue = 'Yes';

            atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
            System.assertEquals(0, atts.size());    
            controller.eventReply();
        }

        atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
        System.assertEquals(1, atts.size());    
        System.assertEquals('Yes', atts[0].Reply_Status__c);    

        atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
        System.assertEquals(atts.size(), 1);
        System.assertEquals('Yes', atts[0].Reply_Status__c);

        controller.loadAttendeesList();
        System.assertEquals(c.Id, controller.yesAttendeesList[0].att.Contact__c);
        System.assertEquals(0, controller.noAttendeesList.size());

        System.runAs(u)
        {
            controller = new cov_events_controller();

            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();
            controller.eventIdChosen = controller.ce.eId;

            // test that you can change the reply
            controller.replyValue = 'No';
            controller.eventReply();
        }

        atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
        System.assertEquals('No', atts[0].Reply_Status__c);

        controller.loadAttendeesList();
        System.assertEquals(c.Id, controller.noAttendeesList[0].att.Contact__c);
        System.assertEquals(0, controller.yesAttendeesList.size());

        delete atts;

        System.runAs(u)
        {
            controller = new cov_events_controller();

            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();
            controller.eventIdChosen = null;
            controller.eventIdChosen = controller.ce.eId;

            // test adding a different status fresh
            controller.replyValue = 'Maybe';
            controller.eventReply();
        }

        atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
        System.assertEquals('Maybe', atts[0].Reply_Status__c);
    }     

    // NOTE: AT SOME POINT THESE TESTS IN GUEST USER CONTEXT
    // WERE CAUSING AN INTERNAL ERROR FOR SOME UNKNOWN REASON
    static testMethod void cov_events_nonauth_reply()
    {
        // Now test for a pre-existing contact
        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUserWithEmail();
        Contact c = testusers.getPortalContact();
        //c.Email = 'portaluser.test@test.iava.org';
        c.LastName = '(Unknown)';
        update c;

        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3), Max_number_of_guests__c = 3, Collect_Guest_Name__c = 'Optional', Collect_Guest_Email__c = 'Required');
        insert e1;
        System.debug('e1: ' + e1);

        List<IAVAEvent_Attendee__c> atts;
        List<Contact> newCs;

        User guestUser = cov_user_TEST_utility.getGuestUser();

        String testEmail = 'susie.q@test.iava.org';

        System.runAs(guestUser)
        {
            //System.runAs(u) {
            //cov_user_utility.self.refreshSelf();
            cov_events_controller controller = new cov_events_controller();

            // test joining an event for a guest user entering contact info
            // first have to create customevent variable ce
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();
            controller.eventIdChosen = null;
            controller.eventIdChosen = controller.ce.eId;

            controller.nonAuthReplyValue = 'Yes';
            controller.nonAuthReplyFirstName = 'Susie';
            controller.nonAuthReplyLastName = 'Q';
            controller.nonAuthReplyEmail = testEmail;
            controller.nonAuthReplyPhone = '212-499-8778';
            System.assertEquals(false, c.Veteran_of_OEF__c);
            controller.nonAuthReplyOEF = true;
            controller.nonAuthReplyFamily = true;

            atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :testEmail];
            System.assertEquals(0, atts.size());
            newCs = [Select Id, FirstName, LastName, Email, Phone from Contact where Email = :testEmail];
            System.assertEquals(0, newCs.size());
            controller.nonAuthReply();
        }

        newCs = [Select Id, FirstName, LastName, Email, Phone, Veteran_Member__c, Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, Veteran_of_Other_Era__c, Veteran_Family_Member__c, Not_a_Veteran__c from Contact where Email = :testEmail];
        System.assertEquals(1, newCs.size());
        System.assertEquals('Susie', newCs[0].FirstName);
        System.assertEquals('Q', newCs[0].LastName);
        System.assertEquals('212-499-8778', newCs[0].Phone);
        System.assertEquals(true, newCs[0].Veteran_Member__c);
        System.assertEquals(true, newCs[0].Veteran_of_OEF__c);
        System.assertEquals(false, newCs[0].Veteran_of_OIF__c);
        System.assertEquals(false, newCs[0].Veteran_of_OND__c);
        System.assertEquals(false, newCs[0].Veteran_of_Other_Era__c);
        System.assertEquals(true, newCs[0].Veteran_Family_Member__c);
        System.assertEquals(false, newCs[0].Not_a_Veteran__c);

        atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :newCs[0].Id];
        System.assertEquals(1, atts.size());    
        System.assertEquals('Yes', atts[0].Reply_Status__c);    
        IAVAEvent_Attendee__c nonAuthAttendee = atts[0];

        cov_events_controller controller;

        c.Veteran_Member__c = false;
        c.Veteran_of_OEF__c = false;
        c.Veteran_of_OIF__c = false;
        c.Veteran_of_OND__c = false;
        c.Veteran_of_Other_Era__c = false;
        c.Veteran_Family_Member__c = false;
        c.Not_a_Veteran__c = false;
        c.Phone = null;
        update c;

        System.runAs(guestUser)
        {
            //System.runAs(u) {

            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();

            // first have to create customevent variable ce
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();
            controller.eventIdChosen = controller.ce.eId;

            system.debug('c: ' + c);
            system.debug('c.Email: ' + c.Email);
            controller.nonAuthReplyValue = 'No';
            controller.nonAuthReplyFirstName = 'Sidney';
            controller.nonAuthReplyLastName = 'Poitier';
            controller.nonAuthReplyEmail = c.Email;
            controller.nonAuthReplyPhone = '212-555-1212';
            //controller.nonAuthReplyVeteranStatus = false;
            controller.nonAuthReplyPost911 = false; // will get overridden by operation checkboxes
            controller.nonAuthReplyOEF = true;
            controller.nonAuthReplyOIF = true;
            controller.nonAuthReplyOND = true;
            controller.nonAuthReplyOtherEra = true;
            controller.nonAuthReplyFamily = true;
            controller.nonAuthReplyNotVeteran = false;

            atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
            System.assertEquals(0, atts.size());
            controller.nonAuthReply();
        }

        newCs = [Select Id, FirstName, LastName, Email, Phone, Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, Veteran_of_Other_Era__c, Veteran_Family_Member__c, Not_a_Veteran__c, Veteran_Member__c from Contact where Email = :c.Email];
        System.assertEquals(1, newCs.size());
        System.assertEquals('Poitier', newCs[0].LastName);
        System.assertEquals('212-555-1212', newCs[0].Phone);
        System.assertEquals(true, newCs[0].Veteran_Member__c);
        System.assertEquals(true, newCs[0].Veteran_of_OEF__c);
        System.assertEquals(true, newCs[0].Veteran_of_OIF__c);
        System.assertEquals(true, newCs[0].Veteran_of_OND__c);
        System.assertEquals(true, newCs[0].Veteran_of_Other_Era__c);
        System.assertEquals(true, newCs[0].Veteran_Family_Member__c);
        System.assertEquals(false, newCs[0].Not_a_Veteran__c);

        atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
        System.assertEquals(1, atts.size());    
        System.assertEquals('No', atts[0].Reply_Status__c); 

        System.assertEquals(true, controller.nonAuthReplied);
        controller.changeNonAuthReply();
        System.assertEquals(false, controller.nonAuthReplied);
    }

    static testMethod void cov_events_nonauth_reply2()
    {
        // Now test for a pre-existing contact
        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUserWithEmail();
        Contact c = testusers.getPortalContact();
        //c.Email = 'portaluser.test@test.iava.org';
        c.LastName = '(Unknown)';
        update c;

        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3), Max_number_of_guests__c = 3, Collect_Guest_Name__c = 'Optional', Collect_Guest_Email__c = 'Required');
        insert e1;
        System.debug('e1: ' + e1);

        List<IAVAEvent_Attendee__c> atts;
        //List<Contact> newCs;
        cov_events_controller controller;

        String testEmail = 'susie.q@test.iava.org';

        User guestUser = cov_user_TEST_utility.getGuestUser();

        Contact newAttendeeContact = new Contact(LastName='Q', Email=testEmail);
        Contact newGuestContact = new Contact(LastName = 'Wawawa');
        insert new List<Contact>{newAttendeeContact, newGuestContact};

        IAVAEvent_Attendee__c nonAuthAttendee = new IAVAEvent_Attendee__c(Contact__c = newAttendeeContact.Id, Event__c = e1.Id, Reply_Status__c = 'Yes');
        insert nonAuthAttendee;

        IAVAEvent_Attendee__c nonauthGuest = new IAVAEvent_Attendee__c(Event__c = e1.Id, Contact__c = newGuestContact.Id, Parent_Attendee__c = nonAuthAttendee.Id);
        insert nonauthGuest;

        // now test guests for non-auth user
        System.runAs(guestuser)
        {
            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();
            controller.eventIdChosen = null;
            controller.eventIdChosen = controller.ce.eId;

            controller.nonAuthReplyValue = 'Yes';
            controller.nonAuthReplyFirstName = 'Susie';
            controller.nonAuthReplyLastName = 'Q';
            controller.nonAuthReplyEmail = testEmail;
            controller.nonAuthReplyPhone = '212-499-8778';
            controller.nonAuthReplyOND = true;

            controller.nonAuthReply();
            System.assertEquals(nonAuthAttendee.Id, controller.ce.attendeeId);
            System.assertEquals(1, controller.ce.guests.size());
            controller.guestInputFirstName = 'Newperson';
            controller.guestInputLastName = 'McGee';
            controller.guestInputEmail = 'newpersonmcgee122@iava.org';
            controller.saveGuest();
            // test that the new (second) guest is added and info is displayed since added in this session
            // while original (first) guest info would not be displayed since from previous session
            System.assertEquals(2, controller.ce.guests.size());
            cov_customevent.eventGuest firstGuest;
            cov_customevent.eventGuest secondGuest;
            if (controller.ce.guests[0].attendeeId == nonauthGuest.Id){
                firstGuest = controller.ce.guests[0];
                secondGuest = controller.ce.guests[1];
            } else {
                firstGuest = controller.ce.guests[1];
                secondGuest = controller.ce.guests[0];
            }
            System.assertEquals(false, firstGuest.displayInfo);
            System.assertEquals(true, secondGuest.displayInfo);
            System.assertEquals(nonAuthAttendee.Id, secondGuest.parentAttendeeId);
            System.assert(!controller.attendeeIdsFromThisSession.contains(firstGuest.attendeeId));
            System.assert(controller.attendeeIdsFromThisSession.contains(secondGuest.attendeeId));
        }
    }   

    static testMethod void cov_events_invites_users()
    {
        cov_relationships_TEST_utility.setReciprocalRelationship('Invited to event', 'Invited to event by');

        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3));
        insert e1;
        System.debug('e1: ' + e1);

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUser();
        Contact c = testusers.getPortalContact();

        cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
        User u2 = testusers2.getPortalUser();
        Contact c2 = testusers2.getPortalContact();

        cov_user_TEST_utility testusers3 = new cov_user_TEST_utility();
        User u3 = testusers3.getPortalUser();
        Contact c3 = testusers3.getPortalContact();

        Test.startTest();

        cov_events_controller controller;
        System.runAs(u)
        {
            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();

            controller.inviteeId = u2.Id;
            controller.inviteeName = u2.Name;
            controller.addUser();
            System.assert(controller.inviteeIds.contains(u2.Id));
            System.assert(controller.inviteeNames.contains(u2.Name));
            System.assertEquals(u2.Name, controller.inviteeIdNameMap.get(u2.Id));

            controller.inviteeId = u3.Id;
            controller.inviteeName = u3.Name;
            controller.addUser();
            System.assert(controller.inviteeIds.contains(u3.Id));
            System.assert(controller.inviteeNames.contains(u3.Name));
            System.assertEquals(u3.Name, controller.inviteeIdNameMap.get(u3.Id));

            // test adding a bad user Id
            controller.inviteeId = e1.Id;
            controller.inviteeName = e1.Name;
            controller.addUser();
            System.assertEquals(e1.Name, controller.inviteeIdNameMap.get(e1.Id));

            // first have to populate customevent variable ce
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();

            controller.sendInvitesToUsers();
            System.assert(controller.successfulInviteeIds[0] == u2.Id || controller.successfulInviteeIds[1] == u2.Id);
            System.assert(controller.successfulInviteeIds[0] == u3.Id || controller.successfulInviteeIds[1] == u3.Id);
            System.assertEquals(e1.Id, controller.failedInviteeIds[0]);
        }

        List<IAVAEvent_Attendee__c> atts = [select Id, Contact__c, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id];
        System.assert(atts[0].Contact__c == c2.Id || atts[1].Contact__c == c2.Id);
        System.assert(atts[0].Contact__c == c3.Id || atts[1].Contact__c == c3.Id);
        System.assertEquals('Invited', atts[0].Reply_Status__c);
        System.assertEquals('Invited', atts[1].Reply_Status__c);

        List<npe4__Relationship__c> rels = [select Id, npe4__ReciprocalRelationship__c from npe4__Relationship__c where npe4__Contact__c = :c.Id and npe4__RelatedContact__c = :c2.Id and npe4__Type__c = 'Invited to event'];
        System.assertEquals(1, rels.size());
        List<npe4__Relationship__c> recipRels;
        System.RunAs(new User(Id = Userinfo.getUserId()))
        {
            recipRels = [select Id, npe4__ReciprocalRelationship__c from npe4__Relationship__c where npe4__Contact__c = :c2.Id and npe4__RelatedContact__c = :c.Id and npe4__Type__c = 'Invited to event by'];
        }
        System.assertEquals(1, recipRels.size());
        System.assertEquals(rels[0].npe4__ReciprocalRelationship__c, recipRels[0].Id);
        System.assertEquals(recipRels[0].npe4__ReciprocalRelationship__c, rels[0].Id);

        rels = [select Id, npe4__ReciprocalRelationship__c from npe4__Relationship__c where npe4__Contact__c = :c.Id and npe4__RelatedContact__c = :c3.Id and npe4__Type__c = 'Invited to event'];
        System.assertEquals(1, rels.size());
        recipRels = [select Id, npe4__ReciprocalRelationship__c from npe4__Relationship__c where npe4__Contact__c = :c3.Id and npe4__RelatedContact__c = :c.Id and npe4__Type__c = 'Invited to event by'];
        System.assertEquals(1, rels.size());
        System.assertEquals(1, recipRels.size());
        System.assertEquals(rels[0].npe4__ReciprocalRelationship__c, recipRels[0].Id);
        System.assertEquals(recipRels[0].npe4__ReciprocalRelationship__c, rels[0].Id);

        System.runAs(u)
        {
            // Test attendee page methods
            controller.initAttendeePage();
            System.assert(controller.invitedAttendeesList[0].att.Contact__c == c2.Id || controller.invitedAttendeesList[0].att.Contact__c == c3.Id);
            System.assert(controller.invitedAttendeesList[1].att.Contact__c == c2.Id || controller.invitedAttendeesList[1].att.Contact__c == c3.Id);

            IAVAEvent_Attendee__c c2Attendee;
            IAVAEvent_Attendee__c c3Attendee;
            if (controller.invitedAttendeesList[0].att.Contact__c == c2.Id) {
                c2Attendee = controller.invitedAttendeesList[0].att;
                c3Attendee = controller.invitedAttendeesList[1].att;
            } else {
                c2Attendee = controller.invitedAttendeesList[1].att;
                c3Attendee = controller.invitedAttendeesList[0].att;            
            }
            controller.attendanceArray = c2Attendee.Id + ':' + 'Yes' + ';' + c3Attendee.Id + ':' + 'No';
            controller.saveAttendanceChanges();
        }
        System.assertEquals('Yes', [select Id, Attended__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c2.Id].Attended__c);
        System.assertEquals('No', [select Id, Attended__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c3.Id].Attended__c);

        String testfaceEmail = 'testface12493879@iava.org';
        System.assertEquals(0, [select Id from Contact where Email = :testfaceEmail].size());

        System.runAs(u)
        {
            PageReference pageRef = Page.cov_event_attendees;
            pageRef.getParameters().put('id', e1.Id);
            Test.setCurrentPage(pageRef);

            controller.newAttendeeFirstName = 'Phil';
            controller.newAttendeeVeteran = true;
            PageReference pr = controller.addNewAttendee();
            System.AssertEquals(true, ApexPages.getMessages()[0].getSummary().contains('Name is required'));
            controller.newAttendeeLastName = 'Testface';
            pr = controller.addNewAttendee();
            System.AssertEquals(true, ApexPages.getMessages()[1].getSummary().contains('Email is required or check the box if email is not available.'));
            controller.newAttendeeEmail = testfaceEmail;
            pr = controller.addNewAttendee();
            System.debug(LoggingLevel.ERROR, 'Tarren1');
            System.debug(ApexPages.getMessages());
        }
        
        System.debug(LoggingLevel.ERROR, 'Tarren2');
        System.debug(ApexPages.getMessages());
        List<Contact> testfaceCons = [select Id, Post_9_11_Veteran__c, Veteran_Member__c from Contact where Email = :testfaceEmail];
        System.assertEquals(1, testfaceCons.size());
        System.assertEquals(True, testfaceCons[0].Post_9_11_Veteran__c);
        System.assertEquals(True, testfaceCons[0].Veteran_Member__c);
        List<IAVAEvent_Attendee__c> testfaceAtts = [select Id, Attended__c, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :testfaceCons[0].Id];
        System.assertEquals(1, testfaceAtts.size());
        System.assertEquals('Not on list', testfaceAtts[0].Reply_Status__c);
        System.assertEquals('Yes', testfaceAtts[0].Attended__c);

        testfaceAtts[0].Reply_Status__c = 'Yes';
        testfaceAtts[0].Attended__c = 'No';
        update testfaceAtts[0];

        testfaceAtts = [select Id, Attended__c, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :testfaceCons[0].Id];
        System.assertEquals(1, testfaceAtts.size());
        System.assertEquals('Yes', testfaceAtts[0].Reply_Status__c);
        System.assertEquals('No', testfaceAtts[0].Attended__c);

        System.runAs(u)
        {
            controller.newAttendeeFirstName = 'Wrongname';
            controller.newAttendeeLastName = 'Wrongnamer';
            controller.newAttendeeEmail = testfaceEmail;
            PageReference pr = controller.addNewAttendee();
        }
        testfaceCons = [select Id, FirstName, LastName from Contact where Email = :testfaceEmail];
        System.assertEquals(1, testfaceCons.size()); // duplicate should not get added
        System.assertEquals('Phil', testfaceCons[0].FirstName); // dont overwrite name for existing contact
        System.assertEquals('Testface', testfaceCons[0].LastName); // dont overwrite name for existing contact
        testfaceAtts = [select Id, Attended__c, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :testfaceCons[0].Id];
        System.assertEquals(1, testfaceAtts.size()); // should not add duplicate attendee record
        System.assertEquals('Yes', testfaceAtts[0].Reply_Status__c); // existing Reply Value should not get overwritten
        System.assertEquals('Yes', testfaceAtts[0].Attended__c);

        Test.stopTest();
    }

    static testMethod void cov_events_invites_emails()
    {
        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3));
        insert e1;
        System.debug('e1: ' + e1);

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUser();
        Contact c = testusers.getPortalContact();

        cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
        User u2 = testusers2.getPortalUser();
        Contact c2 = testusers2.getPortalContact();

        cov_user_TEST_utility testusers3 = new cov_user_TEST_utility();
        User u3 = testusers3.getPortalUser();
        Contact c3 = testusers3.getPortalContact();

        String email1;

        Test.startTest();
        System.runAs(u)
        {
            cov_user_utility.self.refreshSelf();
            cov_events_controller controller = new cov_events_controller();

            // first have to populate customevent variable ce
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();

            email1 = 'newemail1+unittest@iava.org';
            controller.inviteeEmailBox = email1;
            controller.sendInvitesToEmails();
            System.assertEquals(email1, controller.successfulEmails[0]);

            String bademail1 = 'unittest@12345@iava.org';
            controller.inviteeEmailBox = bademail1;
            controller.sendInvitesToEmails();
            System.assertEquals(bademail1, controller.failedEmails[0]);
        }

        List<Contact> cs = [select Id, Email from Contact where Email = :email1];
        System.assertEquals(1, cs.size());
        System.assertEquals(email1, cs[0].Email);

        List<IAVAEvent_Attendee__c> atts = [select Id, Contact__c, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c in (select Id from Contact where Email = :email1)];
        System.assertEquals(1, atts.size());
        System.assertEquals('Invited', atts[0].Reply_Status__c);

        // also test that any one of the contact's email address will be matched
        // hmm, doesnt look like this is actually tested for
        // TODO - test for matching an alternate email field
        //insert new Contact(
        //        LastName='UnitTest3'
        //        , npe01__WorkEmail__c = 'unittestemail3@iava.org'
        //        , Email = 'unittestemail3@iava.org'
        //        , npe01__AlternateEmail__c = 'unittestalternate3@iava.org'
        //        , npe01__Preferred_Email__c = 'Work'
        //        );

        String email1_diffcaps = 'Newemail1+unittest@iava.org';
        String email1_diffcaps2 = 'newEmail1+unittest@iava.org';
        String bademail2 = 'bademail';
        String bademail3 = 'bademail.bademail.com';
        String newemail2 = 'totallynewemail+unittest@iava.org';
        String newemail3 = 'anothernewemail+unittest@iava.org';
        String existingemail1 = email1;

        System.runAs(u)
        {
            cov_user_utility.self.refreshSelf();
            cov_events_controller controller = new cov_events_controller();

            // first have to populate customevent variable ce
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();

            String multipleEmails = email1_diffcaps + ',' + bademail2+', '+newemail2+','+existingemail1+'\n'+newemail3+' , '+bademail3 + ',' + email1_diffcaps2;
            controller.inviteeEmailBox = multipleEmails;
            controller.sendInvitesToEmails();
            System.debug('controller.successfulEmails: ' + controller.successfulEmails);
            System.debug('controller.failedEmails: ' + controller.failedEmails);
            System.assertEquals(3, controller.successfulEmails.size());
            System.assertEquals(2, controller.failedEmails.size());
            System.assert(controller.failedEmails[0] == bademail2 || controller.failedEmails[1] == bademail2);
            System.assert(controller.failedEmails[0] == bademail3 || controller.failedEmails[1] == bademail3);
            System.assert(controller.successfulEmails[0] == newemail2 || controller.successfulEmails[1] == newemail2 || controller.successfulEmails[2] == newemail2);
            System.assert(controller.successfulEmails[0] == newemail3 || controller.successfulEmails[1] == newemail3 || controller.successfulEmails[2] == newemail3);
            System.assert(controller.successfulEmails[0] == existingemail1 || controller.successfulEmails[1] == existingemail1 || controller.successfulEmails[2] == existingemail1);
        }

        System.assertEquals(0, [select Id from Contact where Email in (:bademail2, :bademail3)].size());

        //make sure the existing email was updated instead of a dupe contact created
        cs = [select Id, Email from Contact where Email = :existingemail1];
        System.assertEquals(1, cs.size());

        atts = [select Id, Contact__c, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c in (select Id from Contact where Email = :existingemail1)];
        System.assertEquals(1, atts.size());
        System.assertEquals('Invited', atts[0].Reply_Status__c);

        cs = [select Id, No_Email_Blasts__c from Contact where Email = :newemail2];
        System.assertEquals(1, cs.size());
        System.assertEquals(true, cs[0].No_Email_Blasts__c);

        atts = [select Id, Contact__c, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c in (select Id from Contact where Email = :newemail2)];
        System.assertEquals(1, atts.size());
        System.assertEquals('Invited', atts[0].Reply_Status__c);

        cs = [select Id, No_Email_Blasts__c from Contact where Email = :newemail3];
        System.assertEquals(1, cs.size());
        System.assertEquals(true, cs[0].No_Email_Blasts__c);

        atts = [select Id, Contact__c, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c in (select Id from Contact where Email = :newemail3)];
        System.assertEquals(1, atts.size());
        System.assertEquals('Invited', atts[0].Reply_Status__c);

        Test.stopTest();
    }

    // not sure who commented this test method out or why
    /*static testMethod void test_location_event_search()
    {
        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT in SF', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3), Latitude__c=37.7577, Longitude__c=-122.4376);
        insert e1;
        System.debug('e1: ' + e1);
        
        IAVAEvent__c e2 = new IAVAEvent__c(Name='Test VT in NYC', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e2', Event_Date__c = System.today().addDays(3), Latitude__c=40.7033127, Longitude__c=-73.979681);
        insert e2;
        System.debug('e2: ' + e2);
        
        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUser();
        Contact c = testusers.getPortalContact();
        
        System.runAs(u)
        {
            cov_user_utility.self.refreshSelf();
            cov_events_controller controller = new cov_events_controller();
            controller.getEventsList();
        }
    }*/

    // old test methods from Events as Campaigns
    /*static testMethod void cov_events_controller_Test()
    {
        Campaign c1 = new Campaign(name='Test Campaign 1', Type='Event', IsActive=TRUE);
        c1.Event_Public_Details__c ='These are the public details';
        c1.Show_Inside_COV__c = true;
        c1.Event_Type__c='Art Event';
        c1.StartDate = System.today().addDays(-3); // start with date already past
        insert c1;
        System.debug('c1: ' + c1);
        
        Campaign c2 = new Campaign(name='Test Campaign 2', Type='Event', IsActive=FALSE);
        c2.Event_Public_Details__c ='These are the public details';
        c2.Show_Inside_COV__c = false;
        c2.Event_Type__c='Sporting Event';
        insert c2;
        
        Campaign_Image__c ci = new Campaign_Image__c();
        ci.Campaign__c = c1.Id;
        ci.Size__c = 'Thumbnail';
        insert ci;
        
        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUser();
        Contact c = testusers.getPortalContact();
        
        List<CampaignMember> cms = [select Id from CampaignMember where CampaignId = :c1.Id and ContactId = :c.Id];
        System.assertEquals(cms.size(), 0);
        
        System.runAs(u)
        {
            cov_user_utility.self.refreshSelf();
            cov_events_controller controller = new cov_events_controller();
            
            // Initially no events should come up since c1 has passed and c2 has the Show Inside COV flag off
            controller.getEventsList();
            System.assertEquals(0, controller.cEventsList.size());
            
            // c1 should still not come up with past EndDate
            c1.EndDate = System.today().addDays(-2);
            update c1;
            controller.getEventsList();
            System.assertEquals(0, controller.cEventsList.size());
            
            // Now c1 should come up since EndDate is today
            c1.EndDate = System.today();
            update c1;
            controller.getEventsList();
            System.assertEquals(1, controller.cEventsList.size());
            
            // c1 should still come up since EndDate in future
            c1.EndDate = System.today().addDays(3);
            update c1;
            controller.getEventsList();
            System.assertEquals(1, controller.cEventsList.size());
            
            // c1 should still come up with StartDate today
            c1.StartDate = System.today();
            c1.EndDate = null;
            update c1;
            controller.getEventsList();
            System.assertEquals(1, controller.cEventsList.size());
            
            // c1 should still come up with StartDate in future
            c1.StartDate = System.today().addDays(4);
            update c1;
            controller.getEventsList();
            System.assertEquals(1, controller.cEventsList.size());
            
            // now switch on c2's Show Inside COV and c2 should come up also
            c2.Show_Inside_COV__c = true;
            update c2;
            controller.getEventsList();
            System.assertEquals(2, controller.cEventsList.size());
            
            // test joining an event
            controller.eventIdChosen = c1.Id;
            controller.eventJoin();
            
            cms = [select Id from CampaignMember where CampaignId = :c1.Id and ContactId = :c.Id];
            System.assertEquals(cms.size(), 1);
            
            // test that you can run eventJoin() even if already in the campaign
            controller.eventJoin();
            cms = [select Id from CampaignMember where CampaignId = :c1.Id and ContactId = :c.Id];
            System.assertEquals(cms.size(), 1);
            
            List<String[]> attendeds = controller.getEventsAttended();
            System.assertEquals(cms.size() > 0, true);
            
            // test un-joining an event
            controller.eventUnJoin();
            cms = [select Id from CampaignMember where CampaignId = :c1.Id and ContactId = :c.Id];
            System.assertEquals(cms.size(), 0);
            
            // test trigger an error because already unjoined this event
            PageReference pageRef = Page.cov_events_dash;
            Test.setCurrentPage(pageRef);
            try
            {
                controller.eventUnjoin();
            } catch (Exception e)
            {
                System.debug('ApexPages.getMessages(): ' + ApexPages.getMessages());
                System.AssertEquals(ApexPages.getMessages()[0].getSummary().contains('error removing you from the event'), true);
            }
            
            controller.refreshEventsSection();
            
            PageReference pageRef2 = Page.cov_event;
            Test.setCurrentPage(pageRef2);
            
            ApexPages.currentPage().getParameters().put('id', c1.Id);
            controller.getEventID();
            controller.eventIdChosen = null;
            controller.eventIdChosen = controller.ce.cId;
            controller.eventJoin();
            cms = [select Id from CampaignMember where CampaignId = :c1.Id and ContactId = :c.Id];
            System.assertEquals(cms.size(), 1); 
        }
    }*/

    static testMethod void test_rewards_as_events()
    {
        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3)); // start with date already past
        insert e1;
        System.debug('e1: ' + e1);

        // now test that Give events get included on dashboard
        Partnership_Request__c p = new Partnership_Request__c(Name='Test Partnership', Public_Partner_Name__c='Test Public Name');
        insert p;
        Give__c g1 = new Give__c(Name='Test Give', National_Give__c = true, Partnership_Request__c = p.Id, Category__c='Events', Status__c='Open');
        insert g1;
        Give_Instance__c g1i1 = new Give_Instance__c(Give__c = g1.Id, Number_of_Units__c=5, Status__c='Open', Start_Date__c=System.today().addDays(-10));
        Give_Instance__c g1i2 = new Give_Instance__c(Give__c = g1.Id, Number_of_Units__c=5, Status__c='Open', Start_Date__c=System.today().addDays(10));
        Give_Instance__c g1i3 = new Give_Instance__c(Give__c = g1.Id, Number_of_Units__c=5, Status__c='Open', Start_Date__c=System.today().addDays(2));
        insert new List<Give_Instance__c>{ g1i1, g1i2, g1i3 };
        Give__c g2 = new Give__c(Name='Test Give 2', National_Give__c = true, Partnership_Request__c = p.Id, Category__c = 'Giveaways');
        insert g2;
        Give__c g3 = new Give__c(Name='Test Give 3', Status__c='Waitlist', Category__c = 'Events', Latitude__c=37.778687100000000, Longitude__c=-122.421242399999980, Zip_Code_s__c='94102', National_Give__c = false, Partnership_Request__c = p.Id);
        insert g3;
        Give__c g4 = new Give__c(Name='Test Give 4', Status__c='Closed Visible', National_Give__c = true, Partnership_Request__c = p.Id, Category__c = 'Events');
        insert g4;

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUser();
        Contact c = testusers.getPortalContact();
        c.MA_Latitude__c = 37.7919615;
        c.MA_Longitude__c = -122.2287941;
        update c;

        system.debug('Okeedokee lets start the test');
        Test.startTest();

        System.RunAs(u)
        {
            cov_user_utility.self.refreshSelf();
            cov_events_controller controller = new cov_events_controller();
            controller.getEventsList();
            // should have added g1 and g3 (events) but not g2 (discounts) or g4 (status is closed)
            System.assertEquals(3, controller.cEventsList.size());

            Integer g3Index;
            for (Integer i = 0; i < controller.cEventsList.size(); i++) {
                if (controller.cEventsList[i].eId == g3.Id) g3Index = i;
            }
            if (g3Index == null) { system.assert(false); }

            //g3 should be local to contact in terms of lat/lon
            System.assertEquals(true, controller.cEventsList[g3Index].isLocal);

            // g1's nextDate should be from instance g1i3 since g1i1 is passed and g1i2 happens after g1i3
            Boolean nextDateTested = false;
            for (cov_customevent ce : controller.cEventsList) {
                if (ce.eId == g1.Id) {
                    system.assertEquals(g1i3.Start_Date__c, ce.nextDate);
                    system.assertEquals(false, ce.past);
                    nextDateTested = true;
                }
            }
            system.assertEquals(true, nextDateTested);
        }

        Test.stopTest();
    }

    static testMethod void test_guests_on_events()
    {

        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3));
        insert e1;
        System.debug('e1: ' + e1);

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUserWithEmail();
        Contact c = testusers.getPortalContact();
        //c.Email = 'testMemberEmail14253@iava.org';
        //update c;

        List<IAVAEvent_Attendee__c> atts;

        cov_events_controller controller;

        System.runAs(u)
        {
            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();

            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();

            System.assertEquals(false, controller.ce.collectGuestInfo);
            System.assertEquals(0, controller.ce.maxNumGuests);
            System.assertEquals(0, controller.ce.guests.size());
            System.assertNotEquals(true, controller.ce.collectGuestName);
            System.assertNotEquals(true, controller.ce.guestNameRequired);
            System.assertNotEquals(true, controller.ce.collectGuestEmail);
            System.assertNotEquals(true, controller.ce.guestEmailRequired);
            System.assertNotEquals(true, controller.ce.collectGuestPhone);
            System.assertNotEquals(true, controller.ce.guestPhoneRequired);

            //controller.eventIdChosen = null;
            //controller.eventIdChosen = controller.ce.eId;
            //controller.replyValue = 'Yes';
            //atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
      		//System.assertEquals(0, atts.size());    
            //controller.eventReply();
        }

        e1.Max_number_of_guests__c = 2;
        e1.Collect_Guest_Name__c = 'Optional';
        e1.Collect_Guest_Email__c = 'Required';
        e1.Collect_Guest_Phone__c = 'No';
        update e1;

        String testFirst = 'Frank';
        String testLast = 'Testerlast';
        String testGoodEmail = 'frank152424+15252@iava.org';
        String testBadEmail = 'frank152424+15252.iava.org';
        String testPhone = '212-982-9699';

        Id mainAttendeeRecord;

        System.runAs(u)
        {
            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();
            controller.eventIdChosen = controller.ce.eId;
            controller.replyValue = 'Yes';
            controller.eventReply();

            mainAttendeeRecord = controller.ce.attendeeId;

            System.assertEquals(true, controller.ce.collectGuestInfo);
            System.assertEquals(2, controller.ce.maxNumGuests);
            System.assertEquals(0, controller.ce.guests.size());
            System.assertEquals(true, controller.ce.collectGuestName);
            System.assertEquals(false, controller.ce.guestNameRequired);
            System.assertEquals(true, controller.ce.collectGuestEmail);
            System.assertEquals(true, controller.ce.guestEmailRequired);
            System.assertEquals(false, controller.ce.collectGuestPhone);
            System.assertEquals(false, controller.ce.guestPhoneRequired);

            System.assertNotEquals(true, controller.inGuestEditMode);

            controller.addGuest();

            System.assertEquals(0, controller.ce.guests.size());
            System.assertEquals(true, controller.inGuestEditMode);

            controller.guestInputFirstName = testFirst;
            controller.guestInputLastName = testLast;
            PageReference pr = controller.saveGuest();

            System.assertEquals(0, controller.ce.guests.size());
            System.assertEquals(true, controller.inGuestEditMode);

            System.AssertEquals(true, cov_user_TEST_utility.pageContainsErrorMessage(ApexPages.getMessages(), 'Please fill in your guest\'s email'));

            controller.guestInputEmail = testBadEmail;
            pr = controller.saveGuest();

            System.AssertEquals(true, cov_user_TEST_utility.pageContainsErrorMessage(ApexPages.getMessages(), 'That email address appears to be invalid.'));

            controller.guestInputEmail = c.Email;
            pr = controller.saveGuest();

            System.AssertEquals(true, cov_user_TEST_utility.pageContainsErrorMessage(ApexPages.getMessages(), 'your own email'));
            
            controller.guestInputEmail = testGoodEmail;
            pr = controller.saveGuest();

            System.assertEquals(1, controller.ce.guests.size());
            System.assertEquals(testFirst, controller.ce.guests[0].FirstName);
            System.assertEquals(testLast, controller.ce.guests[0].LastName);
            System.assertEquals(testGoodEmail, controller.ce.guests[0].Email);
            System.assertEquals(false, controller.inGuestEditMode);
        }

        Contact newAttendeeContact = [select Id, FirstName, LastName, Email, MobilePhone from Contact where Email = :testGoodEmail];
        System.assertNotEquals(null, newAttendeeContact);

        System.assertEquals(testFirst, newAttendeeContact.FirstName);
        System.assertEquals(testLast, newAttendeeContact.LastName);
        System.assertEquals(testGoodEmail, newAttendeeContact.Email);
    }

    static testMethod void test_multiple_guests_on_events()
    {
        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3));
        e1.Collect_Guest_Name__c = 'Required';
        e1.Collect_Guest_Phone__c = 'Required';
        e1.Collect_Guest_Email__c = 'Optional';
        insert e1;
        System.debug('e1: ' + e1);

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUserWithEmail();
        Contact c = testusers.getPortalContact();
        //c.Email = 'testMemberEmail14253@iava.org';
        //update c;

        List<IAVAEvent_Attendee__c> atts;

        cov_events_controller controller;

        cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
        User u2 = testusers2.getPortalUserWithEmail();
        Contact c2 = testusers2.getPortalContact();
        c2.FirstName = 'Squee';
        //c2.Email = 'testMemberEmail14253_2@iava.org';
        c2.MobilePhone = '212-982-9699';
        update c2;

        String testFirst = 'Frank';
        String testLast = 'Testerlast';
        String testGoodEmail = 'frank152424+15252@iava.org';
        String testPhone = '212-982-9699';

        Contact cFirst = new Contact(FirstName=testFirst, LastName=testLast, Email = testGoodEmail, Phone=testPhone);
        insert cFirst;

        // insert main attendee record for user
        IAVAEvent_Attendee__c attMain = new IAVAEvent_Attendee__c(Event__c = e1.Id, Contact__c = c.Id, Reply_Status__c = 'Yes');
        insert attMain;

        // insert first guest
        IAVAEvent_Attendee__c attGuest1 = new IAVAEvent_Attendee__c(Event__c = e1.Id, Contact__c = cFirst.Id, Reply_Status__c = 'Yes', Parent_Attendee__c = attMain.Id);
        insert attGuest1;

        Test.startTest();
        
        System.runAs(u)
        {
            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();

            System.assertEquals('Yes', controller.ce.replyStatus);

            // save second guest but without name, should trigger error
            controller.guestInputEmail = c2.Email;
            PageReference pr = controller.saveGuest();
            System.AssertEquals(true, cov_user_TEST_utility.pageContainsErrorMessage(ApexPages.getMessages(), 'Please fill in your guest\'s name'));
            System.AssertEquals(true, cov_user_TEST_utility.pageContainsErrorMessage(ApexPages.getMessages(), 'Please fill in your guest\'s phone'));

            // try lastname without firstname, should trigger error
            controller.guestInputLastName = c2.LastName;
            controller.guestInputPhone = c2.MobilePhone;
            pr = controller.saveGuest();

            System.AssertEquals(true, cov_user_TEST_utility.pageContainsErrorMessage(ApexPages.getMessages(), 'Please fill in your guest\'s name'));

             // try firstname without lastname, should trigger error
            controller.guestInputFirstName = c2.FirstName;
            controller.guestInputLastName = null;
            pr = controller.saveGuest();

            System.AssertEquals(true, cov_user_TEST_utility.pageContainsErrorMessage(ApexPages.getMessages(), 'Please fill in your guest\'s name'));

            // should work with both names
            controller.guestInputLastName = c2.LastName;
            system.debug('sqee');
            pr = controller.saveGuest();

            // now there should be two guests
            System.assertEquals(2, controller.ce.guests.size());
            System.assert(c2.FirstName == controller.ce.guests[0].FirstName || c2.FirstName == controller.ce.guests[1].FirstName);
            System.assert(c2.LastName == controller.ce.guests[0].LastName || c2.LastName == controller.ce.guests[1].LastName);
            System.assert(c2.Email == controller.ce.guests[0].Email || c2.Email == controller.ce.guests[1].Email);
            System.assert(c2.MobilePhone == controller.ce.guests[0].Phone || c2.MobilePhone == controller.ce.guests[1].Phone);
            System.assertEquals(false, controller.inGuestEditMode);

            // delete second guest
            controller.guestIndexChosen = 1;
            controller.deleteGuest();

            // check that only first guest is still there
            System.assertEquals(1, controller.ce.guests.size());
            System.assertEquals(testFirst, controller.ce.guests[0].FirstName);
            System.assertEquals(testLast, controller.ce.guests[0].LastName);
            System.assertEquals(testGoodEmail, controller.ce.guests[0].Email);
            System.assertEquals(false, controller.inGuestEditMode);
        }

        Test.stopTest();
    }

    // have to repeat a bunch of code because were too many queries
    static testMethod void test_guests_on_events_continued()
    {
        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3), Max_number_of_guests__c = 2, Collect_Guest_Name__c = 'Optional', Collect_Guest_Email__c = 'Required', Collect_Guest_Phone__c = 'No');
        insert e1;
        System.debug('e1: ' + e1);

        List<IAVAEvent_Attendee__c> atts;
        cov_events_controller controller;

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u1 = testusers.getPortalUserWithEmail();
        Contact c1 = testusers.getPortalContact();
        //c1.Email = 'testMemberEmail14253@iava.org';
        //update c1;

        cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
        Contact c2 = testusers2.getPortalContactWithEmail();
        c2.FirstName = 'Squee';
        //c2.Email = 'testMemberEmail14253_2@iava.org';
        c2.MobilePhone = '212-982-9699';
        update c2;

        cov_user_TEST_utility testusers3 = new cov_user_TEST_utility();
        Contact c3 = testusers3.getPortalContact();
        //update c3;

        IAVAEvent_Attendee__c att1 = new IAVAEvent_Attendee__c(Reply_Status__c = 'Yes', Event__c = e1.Id, Contact__c = c1.Id);
        insert att1;

        IAVAEvent_Attendee__c att2 = new IAVAEvent_Attendee__c(Reply_Status__c = 'Yes', Event__c = e1.Id, Contact__c = c2.Id, Parent_Attendee__c = att1.Id);
        insert att2;

        System.runAs(u1)
        {
            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();

            System.assertEquals(1, controller.ce.guests.size());

            controller.guestInputEmail = c2.Email;
            PageReference pr = controller.saveGuest();

            System.AssertEquals(true, cov_user_TEST_utility.pageContainsErrorMessage(ApexPages.getMessages(), 'person is already registered'));
        }

        att2.Reply_Status__c = 'No';
        att2.Parent_Attendee__c = null;
        update att2;

        System.runAs(u1)
        {
            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();

            System.assertEquals(0, controller.ce.guests.size());
        }
    }

    static testMethod void test_guests_on_events_3()
    {
        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3), Max_number_of_guests__c = 2, Collect_Guest_Name__c = 'Optional', Collect_Guest_Email__c = 'Required', Collect_Guest_Phone__c = 'No');
        insert e1;
        System.debug('e1: ' + e1);

        List<IAVAEvent_Attendee__c> atts;
        cov_events_controller controller;    

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u1 = testusers.getPortalUser();
        Contact c1 = testusers.getPortalContact();

        cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
        Contact c2 = testusers2.getPortalContactWithEmail();
        c2.FirstName = 'Squee';
        c2.MobilePhone = '212-982-9699';
        update c2;

        IAVAEvent_Attendee__c att1 = new IAVAEvent_Attendee__c(Reply_Status__c = 'Yes', Event__c = e1.Id, Contact__c = c1.Id);
        insert att1;

        IAVAEvent_Attendee__c att2 = new IAVAEvent_Attendee__c(Reply_Status__c = 'Yes', Event__c = e1.Id, Contact__c = c2.Id, Parent_Attendee__c = att1.Id);
        insert att2;

        System.runAs(u1)
        {
            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();

            controller.guestInputFirstName = 'fakeout';
            controller.guestInputEmail = c2.Email;
            PageReference pr = controller.saveGuest();

            controller.getEventID();
            System.assertEquals(1, controller.ce.guests.size());
        }

        Contact con2 = [select Id, FirstName, Email from Contact where Id = :c2.Id];
        System.assertEquals(c2.FirstName, con2.FirstName);
        System.assertNotEquals('fakeout', con2.FirstName);

        c2.FirstName = null;
        c2.LastName = c2.Email;
        update c2;

        att2.Reply_Status__c = 'No';
        att2.Parent_Attendee__c = null;
        update att2;

        System.runAs(u1)
        {
            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);
            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();
            
            System.assertEquals(0, controller.ce.guests.size());
            
            controller.guestInputFirstName = 'realFirst';
            controller.guestInputLastName = 'realLast';
            controller.guestInputEmail = c2.Email;
            PageReference pr = controller.saveGuest();
            
            controller.getEventID();
            System.assertEquals(1, controller.ce.guests.size());
        }

        con2 = [select Id, FirstName, LastName, Email from Contact where Id = :c2.Id];
        System.assertEquals('realFirst', con2.FirstName);
        System.assertEquals('realLast', con2.LastName);
        System.assertNotEquals(c2.Email, con2.LastName);

        System.assertEquals(1, controller.ce.guests.size());
    }
        
    static testMethod void test_mark_attended()
    {
        IAVAEvent__c e1 = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(3));
        insert e1;
        System.debug('e1: ' + e1);

        cov_user_TEST_utility testusers = new cov_user_TEST_utility();
        User u = testusers.getPortalUser();
        Contact c = testusers.getPortalContact();

        List<IAVAEvent_Attendee__c> atts;

        cov_events_controller controller;

        System.runAs(u)
        {
            cov_user_utility.self.refreshSelf();
            controller = new cov_events_controller();

            // test joining an event
            // first have to create customevent variable ce
            PageReference pageRef = Page.cov_event;
            Test.setCurrentPage(pageRef);

            ApexPages.currentPage().getParameters().put('id', e1.Id);
            controller.getEventID();
            controller.eventIdChosen = null;
            controller.eventIdChosen = controller.ce.eId;
            controller.replyValue = 'Yes';

            atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
            System.assertEquals(0, atts.size());    
            controller.eventReply();
        }

        atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
        System.assertEquals(1, atts.size());    
        System.assertEquals('Yes', atts[0].Reply_Status__c);    

        atts = [select Id, Reply_Status__c from IAVAEvent_Attendee__c where Event__c = :e1.Id and Contact__c = :c.Id];
        System.assertEquals(atts.size(), 1);
        System.assertEquals('Yes', atts[0].Reply_Status__c);

        controller.loadAttendeesList();
        system.debug('attendeeList ' + controller.yesAttendeesList);
        System.assertEquals(c.Id, controller.yesAttendeesList[0].att.Contact__c);
        System.assertEquals(0, controller.noAttendeesList.size());
        
        controller.attendeeListChosen = 'Yes';
        controller.attendeeChosenIndex = 0;
        controller.markAttended();
        controller.setAttendeeForCollection();
    }
}