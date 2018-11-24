@isTest
private class cov_announcements_TESTS {
	
static testMethod void cov_announcements_Test() {
        
		Campaign c1 = new Campaign(name='Test Campaign 1', Type='COV Announcement', IsActive=TRUE);
		c1.Event_Public_Details__c ='These are the public details';
		c1.Show_Inside_COV_To__c = 'Everyone';
		insert c1;

		Campaign c2 = new Campaign(name='Test Campaign 2', Type='COV Announcement', IsActive=TRUE);
		c2.Event_Public_Details__c ='These are the public details';
		c2.Show_Inside_COV_To__c = 'Campaign Members';
		insert c2;
		
       	Campaign_Image__c ci = new Campaign_Image__c();
       	ci.Campaign__c = c1.Id;
       	ci.Size__c = 'Thumbnail';
       	insert ci;


       	cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
        
        System.runAs(u) {

        	cov_user_utility.self.refreshSelf();
	        
    		PageReference pageRef = Page.cov_announcements_dash;
	        Test.setCurrentPage(pageRef);
	        
	        cov_announcements_controller controller = new cov_announcements_controller();

	        System.assertEquals(1, controller.announcementsList.size());

	        // Test that dismissing the announcement adds the contact to the campaign with Status Dismissed
	        System.assertEquals(0, [select Status from CampaignMember where CampaignId = :c1.Id and ContactId = :u.ContactId limit 1].size());
	        controller.cmpIdChosen = c1.Id;
	        controller.dismiss();
	        CampaignMember cm = [select Status from CampaignMember where CampaignId = :c1.Id and ContactId = :u.ContactId limit 1];
	        System.assertEquals('Dismissed', cm.Status);

	        // Test that dismissing the announcement changes the campaignmember Status to Dismissed
	        cm.Status = 'Sent';
	        update cm;
	        cm = [select Status from CampaignMember where CampaignId = :c1.Id and ContactId = :u.ContactId limit 1];
	        System.assertEquals('Sent', cm.Status);
	        controller.dismiss();
	        cm = [select Status from CampaignMember where CampaignId = :c1.Id and ContactId = :u.ContactId limit 1];
	        System.assertEquals('Dismissed', cm.Status);


	        // Test that a 'CampaignMembers only' campaign is returned if the member is added to the campaign
	        controller = new cov_announcements_controller();
	        System.assertEquals(0, controller.announcementsList.size());
	        CampaignMember cm2 = new CampaignMember(CampaignId = c2.id, ContactId = u.ContactId);
	        insert cm2;
	        controller = new cov_announcements_controller();
	        System.assertEquals(1, controller.announcementsList.size());

	        cm = [select Status from CampaignMember where CampaignId = :c2.Id and ContactId = :u.ContactId limit 1];
	        System.assertNotEquals('Dismissed', cm.Status);
	      	controller.cmpIdChosen = c2.Id;
	        controller.dismiss();
	        cm = [select Status from CampaignMember where CampaignId = :c2.Id and ContactId = :u.ContactId limit 1];
	        System.assertEquals('Dismissed', cm.Status);


        }        


    }


	static testMethod void cov_announcements_internalUser_Test() {
        
		Campaign c1 = new Campaign(name='Test Campaign 1', Type='COV Announcement', IsActive=TRUE);
		c1.Event_Public_Details__c ='These are the public details';
		c1.Show_Inside_COV_To__c = 'Everyone';
		insert c1;

		Campaign c2 = new Campaign(name='Test Campaign 2', Type='COV Announcement', IsActive=FALSE);
		c2.Event_Public_Details__c ='These are the public details';
		c2.Show_Inside_COV_To__c = 'Campaign Members';
		insert c2;
		
       	Campaign_Image__c ci = new Campaign_Image__c();
       	ci.Campaign__c = c1.Id;
       	ci.Size__c = 'Thumbnail';
       	insert ci;

       	cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u2 = testusers.getInternalUser();
		Contact con2 = testusers.getInternalContact();
        
        System.runAs(u2) {
	        
    		PageReference pageRef2 = Page.cov_announcements_dash;
	        Test.setCurrentPage(pageRef2);
	        
	        cov_announcements_controller controller2 = new cov_announcements_controller();
	        controller2.cmpIdChosen = c1.Id;
	        controller2.dismiss();

	        System.assertEquals('Dismissed',[select Status from CampaignMember where CampaignId = :c1.Id and ContactId = :con2.Id limit 1].Status);

        }         


    }


	static testMethod void cov_announcements_Petition_Test() {
        
		Campaign c1 = new Campaign(name='Test Petition 1', Type='Petition', IsActive=TRUE);
		c1.Event_Public_Details__c ='These are the public details';
		c1.Show_Inside_COV_To__c = 'Everyone';
		insert c1;

		Campaign c2 = new Campaign(name='Test Campaign 2', Type='COV Announcement', IsActive=FALSE);
		c2.Event_Public_Details__c ='These are the public details';
		c2.Show_Inside_COV_To__c = 'Campaign Members';
		insert c2;
		
       	Campaign_Image__c ci = new Campaign_Image__c();
       	ci.Campaign__c = c1.Id;
       	ci.Size__c = 'Full';
       	insert ci;

       	cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u2 = testusers.getInternalUser();
		Contact con2 = testusers.getInternalContact();
        
        System.runAs(u2) {
	        
    		PageReference pageRef2 = Page.cov_announcements_dash;
	        Test.setCurrentPage(pageRef2);
	        
	        cov_announcements_controller controller = new cov_announcements_controller();
	        controller.cmpIdChosen = c1.Id;
	        controller.signPetition();

	        System.assertEquals('Signed',[select Status from CampaignMember where CampaignId = :c1.Id and ContactId = :con2.Id limit 1].Status);

	        // This caused an Implementation restriction: FeedItem requires a filter by Id
	        //System.assertEquals(true, [select Body from FeedItem where parentId = :u2.Id limit 1].Body.contains('just signed the petition'));

	        System.assertEquals(true, ApexPages.getMessages().get(0).getSummary().contains('signed the petition.'));

        }         


    }
   

	
}