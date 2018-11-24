@isTest(SeeAllData=true)

	// Feb 2016: note, the "isFacebookLinked" flag can't currently be tested via a unit test
	// because it was causing a strange error in test after inserting test users via cov_user_TEST_utility
	// error is System.UnexpectedException: A callout failed because an Apex operation 
	// has pending uncommitted work. The Apex code needs to commit or roll back before 
	// callouts can be performed in the same transaction.


private class cov_profile_controller_TESTS
{
	/*@isTest static void simpleTest() {
	//	cov_user_TEST_utility testusers = new cov_user_TEST_utility();
	//	User u = testusers.getPortalUser();
	//	System.runAs ( new User(Id = u.Id) ) {
	//	//System.runAs(u){
	//		Test.startTest();
	//		cov_profile_controller controller = new cov_profile_controller();
	//		Test.stopTest();
	//	}
	}*/
	
    /* comment out original test
	@isTest static void cov_profile_controller_TEST()
    {
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();
		c.Paperwork_Confirmation__c = 'Paperwork Accepted';
		c.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		update c;

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUser();

		User u3 = testusers.getInternalUser();

		Test.startTest();

		PageReference pageRef = Page.cov_profile_profileinfo;
	    Test.setCurrentPage(pageRef);

		// View own profile as portal user
		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();

			cov_profile_controller controller = new cov_profile_controller();

			controller.city = 'NYC';
			controller.state = 'NY';
			controller.saveTheC();	

			List<Contact> theCs = [select Id, MailingCity, Portal_User__c from Contact where id = :c.Id];
			system.debug('theCs: ' + theCs);
            
			System.assertEquals('NYC', theCs[0].MailingCity);
			system.assertEquals(false, controller.hasServiceInfo);

			// test the trigger that builds CompanyName based on service info
			controller.theC.Veteran_Member__c = true;
			controller.theC.Veteran_of_OEF__c = true;
			controller.saveTheC();
            
			System.assertEquals('Veteran: OEF', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);

			controller.theC.Branch_of_Service__c = 'Army';
			controller.saveTheC();
			System.assertEquals('Army: OEF', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);

			controller.theC.Branch_of_Service__c = 'Air Force';
			controller.theC.Veteran_of_OND__c = true;
			controller.saveTheC();
			System.assertEquals('Air Force: OEF/OND', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);
		}

		// test CompanyName for Unconfirmed Member
		c.Paperwork_Confirmation__c = 'Paperwork Requested';
		c.Approved_Date__c = null;
		update c;

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();
			cov_profile_controller controller = new cov_profile_controller();
			controller.theC.Branch_of_Service__c = 'Coast Guard';
			controller.theC.Veteran_of_OIF__c = true;
			controller.saveTheC();
			system.debug('here is the c: ' + [select Id, Veteran_Member_Status__c, Veteran_Member__c, Paperwork_Confirmation__c from Contact where Id=:c.Id]);
			System.assertEquals('[Unconfirmed] Coast Guard: OEF/OIF/OND', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);

			system.assertEquals(false, controller.hasAboutMe);
			controller.u.AboutMe = 'The AboutMe Text';
			controller.saveTheU();
			System.assertEquals('The AboutMe Text', [select AboutMe from User where id = :u.Id limit 1].AboutMe);
			cov_user_utility.self.refreshSelf();
			controller = new cov_profile_controller();
			system.assertEquals(true, controller.hasAboutMe);

			List<SelectOption> states = controller.getStateOptions();

	       	// Test change password page
	       	System.assertEquals(Page.IAVAPlus_ChangePassword.getUrl(), controller.changePassword().getUrl());

	       	controller = new cov_profile_controller();
	       	system.assertEquals(true, controller.hasServiceInfo);
		}

	    // View another user's profile as portal user
		System.RunAs(u2) {
			cov_profile_controller controller = new cov_profile_controller();
		}

		Test.stopTest();
	}
	*/

	@isTest static void cov_profile_controller_testOwnProfileVetFlags()
    {
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();
		c.Paperwork_Confirmation__c = 'Paperwork Accepted';
		c.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		update c;

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUser();

		User u3 = testusers.getInternalUser();

		Test.startTest();

		PageReference pageRef = Page.cov_profile_profileinfo;
	    Test.setCurrentPage(pageRef);

		// View own profile as portal user
		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();

			cov_profile_controller controller = new cov_profile_controller();

			controller.city = 'NYC';
			controller.state = 'NY';
			controller.saveTheC();	

			List<Contact> theCs = [select Id, MailingCity, Portal_User__c from Contact where id = :c.Id];
			system.debug('theCs: ' + theCs);
            
			System.assertEquals('NYC', theCs[0].MailingCity);
			system.assertEquals(false, controller.hasServiceInfo);

			// test the trigger that builds CompanyName based on service info
			controller.theC.Veteran_Member__c = true;
			controller.theC.Veteran_of_OEF__c = true;
			controller.saveTheC();
            
            set<Id> cUserIds = new set<Id>();
            
            integer count = 0;
            while(count<theCs.size())
            {
                cUserIds.add(theCs[count].Portal_User__c);
                count ++;
            }
            
            futureMethodForCOVProfileCompanyUpdate.updateCompanyName(cUserIds);
            test.stopTest();
            
			System.assertEquals('Veteran: OEF', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);
		}

	    // View another user's profile as portal user
		System.RunAs(u2) {
			cov_profile_controller controller = new cov_profile_controller();
		}
    }

	@isTest static void cov_profile_controller_testOwnProfileBranch()
    {
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();
		c.Paperwork_Confirmation__c = 'Paperwork Accepted';
		c.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		update c;

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUser();

		User u3 = testusers.getInternalUser();

		Test.startTest();

		PageReference pageRef = Page.cov_profile_profileinfo;
	    Test.setCurrentPage(pageRef);

		// View own profile as portal user
		System.RunAs(u)
        {
			cov_user_utility.self.refreshSelf();

			cov_profile_controller controller = new cov_profile_controller();

			controller.city = 'NYC';
			controller.state = 'NY';
			controller.saveTheC();	

			List<Contact> theCs = [select Id, MailingCity, Portal_User__c from Contact where id = :c.Id];
			system.debug('theCs: ' + theCs);
            
			System.assertEquals('NYC', theCs[0].MailingCity);

			system.assertEquals(false, controller.hasServiceInfo);

			// test the trigger that builds CompanyName based on service info
			controller.theC.Veteran_Member__c = true;
			controller.theC.Veteran_of_OEF__c = true;
			controller.saveTheC();
            
			//System.assertEquals('Veteran: OEF', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);

			controller.theC.Branch_of_Service__c = 'Army';
			controller.saveTheC();
            
            set<Id> cUserIds = new set<Id>();
            
            integer count = 0;
            while(count<theCs.size())
            {
                cUserIds.add(theCs[count].Portal_User__c);
                count ++;
            }
            
            futureMethodForCOVProfileCompanyUpdate.updateCompanyName(cUserIds);
            test.stopTest();
            
			System.assertEquals('Army: OEF', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);
		}
	}

	@isTest static void cov_profile_controller_testOwnProfileChangeBranch()
    {
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();
		c.Paperwork_Confirmation__c = 'Paperwork Accepted';
		c.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		update c;

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUser();

		User u3 = testusers.getInternalUser();

		Test.startTest();

		PageReference pageRef = Page.cov_profile_profileinfo;
	    Test.setCurrentPage(pageRef);

		// View own profile as portal user
		System.RunAs(u)
        {
			cov_user_utility.self.refreshSelf();

			cov_profile_controller controller = new cov_profile_controller();

			controller.city = 'NYC';
			controller.state = 'NY';
			controller.saveTheC();	

			List<Contact> theCs = [select Id, MailingCity, Portal_User__c from Contact where id = :c.Id];
			system.debug('theCs: ' + theCs);
            
			System.assertEquals('NYC', theCs[0].MailingCity);

			system.assertEquals(false, controller.hasServiceInfo);

			// test the trigger that builds CompanyName based on service info
			controller.theC.Veteran_Member__c = true;
			controller.theC.Veteran_of_OEF__c = true;
			controller.saveTheC();
            
			//System.assertEquals('Veteran: OEF', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);

			controller.theC.Branch_of_Service__c = 'Army';
			controller.saveTheC();
			//System.assertEquals('Army: OEF', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);

			controller.theC.Branch_of_Service__c = 'Air Force';
			controller.theC.Veteran_of_OND__c = true;
			controller.saveTheC();
            
            set<Id> cUserIds = new set<Id>();
            
            integer count = 0;
            while(count<theCs.size())
            {
                cUserIds.add(theCs[count].Portal_User__c);
                count ++;
            }
            
            futureMethodForCOVProfileCompanyUpdate.updateCompanyName(cUserIds);
            test.stopTest();
            
			System.assertEquals('Air Force: OEF/OND', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);
		}
	}

	@isTest static void cov_profile_controller_testOwnProfileUnconfirmed()
    {
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();
		c.Paperwork_Confirmation__c = 'Paperwork Accepted';
		c.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		update c;

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUser();

		User u3 = testusers.getInternalUser();

		Test.startTest();

		PageReference pageRef = Page.cov_profile_profileinfo;
	    Test.setCurrentPage(pageRef);

		// View own profile as portal user
		System.RunAs(u)
        {
			cov_user_utility.self.refreshSelf();

			cov_profile_controller controller = new cov_profile_controller();

			controller.city = 'NYC';
			controller.state = 'NY';
			controller.saveTheC();	

			List<Contact> theCs = [select Id, MailingCity, Portal_User__c from Contact where id = :c.Id];
			system.debug('theCs: ' + theCs);
            
			System.assertEquals('NYC', theCs[0].MailingCity);

			system.assertEquals(false, controller.hasServiceInfo);

			// test the trigger that builds CompanyName based on service info
			controller.theC.Veteran_Member__c = true;
			controller.theC.Veteran_of_OEF__c = true;
			controller.saveTheC();
            
			//System.assertEquals('Veteran: OEF', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);
            
			controller.theC.Branch_of_Service__c = 'Army';
			controller.saveTheC();
			//System.assertEquals('Army: OEF', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);

			controller.theC.Branch_of_Service__c = 'Air Force';
			controller.theC.Veteran_of_OND__c = true;
			controller.saveTheC();
			//System.assertEquals('Air Force: OEF/OND', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);
		}

		// test CompanyName for Unconfirmed Member
		c.Paperwork_Confirmation__c = 'Paperwork Requested';
		c.Approved_Date__c = null;
		update c;

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();
			cov_profile_controller controller = new cov_profile_controller();
			controller.theC.Branch_of_Service__c = 'Coast Guard';
			controller.theC.Veteran_of_OIF__c = true;
			controller.saveTheC();

            set<Id> UserIds = new set<Id>();
            UserIds.add(u.Id);
            
            futureMethodForCOVProfileCompanyUpdate.updateCompanyName(UserIds);
            test.stopTest();
            
			system.debug('here is the c: ' + [select Id, Veteran_Member_Status__c, Veteran_Member__c, Paperwork_Confirmation__c from Contact where Id=:c.Id]);
			System.assertEquals('[Unconfirmed] Coast Guard: OEF/OIF/OND', [select CompanyName from User where Id = :u.Id limit 1].CompanyName);
		}

	    // View another user's profile as portal user
		System.RunAs(u2) {
			cov_profile_controller controller = new cov_profile_controller();
		}
	}

	@isTest static void cov_profile_controller_testOtherAsserts()
    {
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		//Contact c = testusers.getPortalContact();
		//c.Paperwork_Confirmation__c = 'Paperwork Accepted';
		//c.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		//update c;

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUser();

		User u3 = testusers.getInternalUser();

		Test.startTest();

		PageReference pageRef = Page.cov_profile_profileinfo;
	    Test.setCurrentPage(pageRef);

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();
			cov_profile_controller controller = new cov_profile_controller();

			system.assertEquals(false, controller.hasAboutMe);
			controller.u.AboutMe = 'The AboutMe Text';
			controller.saveTheU();
			System.assertEquals('The AboutMe Text', [select AboutMe from User where id = :u.Id limit 1].AboutMe);
			cov_user_utility.self.refreshSelf();
			controller = new cov_profile_controller();
			system.assertEquals(true, controller.hasAboutMe);

			List<SelectOption> states = controller.getStateOptions();

	       	// Test change password page
	       	System.assertEquals(Page.IAVAPlus_ChangePassword.getUrl(), controller.changePassword().getUrl());

	       	controller = new cov_profile_controller();
	       	//system.assertEquals(true, controller.hasServiceInfo);
		}

	    // View another user's profile as portal user
		System.RunAs(u2) {
			cov_profile_controller controller = new cov_profile_controller();
		}

		Test.stopTest();
	}

	@isTest static void cov_profile_controller_internaluser_TEST()
    {
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		User u3 = testusers.getInternalUser();
		System.debug('u3: ' + u3);

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u4 = testusers2.getInternalUser();

        test.startTest();
        
		PageReference pageRef = Page.cov_profile_profileinfo;
	    Test.setCurrentPage(pageRef);

	    // View own profile as internal user
		System.RunAs(u3) {
			cov_profile_controller controller = new cov_profile_controller();

			// Test CompanyName with IAVA prefix
			controller.theC.Veteran_Member__c = true;
			controller.theC.Veteran_of_OIF__c = true;
			controller.saveTheC();
            
            set<Id> UserIds = new set<Id>();
            UserIds.add(u3.Id);
            
            futureMethodForCOVProfileCompanyUpdate.updateCompanyName(UserIds);
            test.stopTest();
            
			System.assertEquals('[IAVA] Veteran: OIF', [select CompanyName from User where Id = :u3.Id limit 1].CompanyName);
		}

		// View another user's profile as internal user
		System.RunAs(u4) {
		    ApexPages.currentPage().getParameters().put('sfdc.userId', u3.Id);
			cov_profile_controller controller = new cov_profile_controller();
		}
	}

	@isTest static void cov_profile_controller_saveMethods_TEST()
    {
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();

		PageReference pageRef = Page.cov_profile_profileinfo;
	    Test.setCurrentPage(pageRef);

		// View own profile as portal user
		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();
			cov_profile_controller controller = new cov_profile_controller();
			controller.aboutme = 'AboutMe Text';
			controller.vetstory = 'Vet Story Text';
			controller.twitterHandle = '@iava';
			controller.instagramHandle = 'http://instagram.com/iava';
			controller.saveProfileInfo();
			System.assertEquals('AboutMe Text', controller.getAboutme());
			System.assertEquals('Vet Story Text', controller.getVetStory());
		}

		System.assertEquals('AboutMe Text', [select AboutMe from User where id = :u.Id limit 1].AboutMe);
		Contact checkContact = [select My_Veteran_Story__c, Twitter_ID__c, Instagram_ID__c from Contact where id = :c.Id limit 1];
		System.assertEquals('Vet Story Text', checkContact.My_Veteran_Story__c);
		System.assertEquals('iava', checkContact.Twitter_ID__c);
		System.assertEquals('iava', checkContact.Instagram_ID__c);

		System.RunAs(u) {
			cov_user_utility.self.refreshSelf();
			cov_profile_controller controller = new cov_profile_controller();
			controller.twitterHandle = '';
			controller.saveProfileInfo();
		}
		System.assertEquals(null, [select Twitter_ID__c from Contact where id = :c.Id limit 1].Twitter_ID__c);
    }

	@isTest static void testDeployments()
    {
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();
		Contact c = testusers.getPortalContact();

		System.RunAs(u)
        {
			cov_profile_controller controller = new cov_profile_controller();

			PageReference pageRef = Page.cov_profile_deployments;
	    	Test.setCurrentPage(pageRef);
	    	
	    	controller.getDeployments();

			system.assert(controller.hasDeployments == null || controller.hasDeployments == false);

			controller.dpcity = 'Test City';
			controller.dpcountry = 'Iraq';
			controller.dpstartdate = '1/1/2008';
			controller.dpenddate = 'hamburger';
			controller.dpoperation = 'OIF';
			controller.dpstoploss = true;
			controller.dpnotes = 'test notes';
			controller.saveEdit();
			System.AssertEquals(true, ApexPages.getMessages()[0].getSummary().contains('Invalid date'));

//			ApexPages.getMessages().clear();
			controller.dpenddate = '2/2/2007';
			controller.saveEdit();
			System.AssertEquals(true, ApexPages.getMessages()[1].getSummary().contains('later than End Date'));

			controller.dpenddate = '2/2/2009';
			controller.saveEdit();

			Detailed_Deployment_Information__c dep = [select Id, City__c from Detailed_Deployment_Information__c where Contact__c = :c.Id limit 1];
			System.assertEquals('Test City', dep.City__c);

			controller.dpIdChosen = dep.Id;
			controller.toEditMode();
			controller.dpcity = 'Test 2';
			controller.dpothercountry = 'Canada';
			controller.dpcountry = 'Other';
			controller.dpenddate = null;
			controller.saveEdit();
			System.assertEquals('Test 2', [select City__c from Detailed_Deployment_Information__c where Contact__c = :c.Id limit 1].City__c);
			System.assertEquals('Canada', [select Country__c from Detailed_Deployment_Information__c where Contact__c = :c.Id limit 1].Country__c);

			controller.getDeployments();
			System.assertEquals(true, controller.getHasDeployments());
			System.assertEquals(true, controller.hasDeployments);
			System.assertEquals(1, controller.numDeployments);

			cov_profile_controller.profileContactId = null;
			controller.dpIdChosen = dep.Id;
			controller.toEditMode();
			controller.cancelRow();

			controller.deleteRow();
			System.assertEquals(0, [select Id from Detailed_Deployment_Information__c where Contact__c = :c.Id].size());

			controller.didntDeploy();
			System.assertEquals(true, [select Did_Not_Deploy__c from Contact where Id = :c.Id limit 1].Did_Not_Deploy__c);

			controller.getDeployments();
			System.assertEquals(0, controller.numDeployments);

			controller.toCreateMode();
			System.assertEquals(true, controller.ineditmode);
		}
	}

	//@isTest static void cov_test_unreadcount_TEST() {
			
	//		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
	//		User u = testusers.getPortalUser();

	//		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
	//		User u2 = testusers2.getPortalUser();

	//		PageReference pageRef = Page.cov_profile_profileinfo;
	//	    Test.setCurrentPage(pageRef);


	//		// View own profile as portal user
	//		System.RunAs(u) {
	//			cov_user_utility.self.refreshSelf();
	//			cov_profile_controller controller = new cov_profile_controller();

	//			system.assert(controller.hasUnreadMessages == null || controller.hasUnreadMessages == false);
	//		}

	//		System.runAs(u2) {
	//			ConnectApi.ChatterMessages.sendMessage('Hi', u.Id);
	//		}

	//		System.RunAs(u) {
	//			cov_user_utility.self.refreshSelf();
	//			cov_profile_controller controller = new cov_profile_controller();

	//			system.assertEquals(true, controller.hasUnreadMessages);
	//			system.assertEquals(1, controller.unreadMessageCount);
	//		}


	//}		
}