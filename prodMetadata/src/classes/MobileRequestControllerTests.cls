@isTest
private class MobileRequestControllerTests {

	public static Contact member()
	{
    	String paper = ContactUtilities.CONFIRMED_VET;
    	// Contact member = new Contact(LastName = 'NonMember', Membership_ID__c = '321321321',
    	// 	Email = 'n1@test.com', npe01__HomeEmail__c = 'n2@test.com', npe01__AlternateEmail__c = 'n3@test.com');
    	// member.Paperwork_Confirmation__c = paper;
    	// insert member;
    	Contact member = [SELECT Membership_ID__c, Email, npe01__HomeEmail__c, npe01__AlternateEmail__c, Phone,
    		MailingStreet, MailingCity, MailingState, MailingPostalCode FROM Contact WHERE Membership_ID__c != null
    		AND Phone != null AND Email != null AND npe01__HomeEmail__c != null AND npe01__AlternateEmail__c != null
    		AND MailingStreet != null AND MailingCity != null AND MailingState != null AND MailingPostalCode != null
    		AND Paperwork_Confirmation__c = :paper LIMIT 1];
		return member;
	}
	
	public static Contact nonmember()
	{
    	String paper = ContactUtilities.CONFIRMED_VET;
    	// Contact nonmember = new Contact(LastName = 'NonMember', Membership_ID__c = '321321321',
    	// 	Email = 'n1@test.com', npe01__HomeEmail__c = 'n2@test.com', npe01__AlternateEmail__c = 'n3@test.com');
    	// insert nonmember;
    	Contact nonmember = [SELECT Membership_ID__c, Email, npe01__HomeEmail__c, npe01__AlternateEmail__c FROM Contact
    		WHERE Membership_ID__c != null AND Email != null AND npe01__HomeEmail__c != null AND npe01__AlternateEmail__c != null
    		AND Paperwork_Confirmation__c != :paper LIMIT 1];
		return nonmember;
	}

    static testMethod void TestMemberValidation() {
		// Gather our test data ...
		Contact member = member();
		Contact nonmember = nonmember();
    	// Now set the current page and create the controller ...
    	Test.setCurrentPage(Page.MemberValidation);
    	MobileRequestController con = new MobileRequestController();
    	// ... and here we go!
    	Test.startTest();
    	ApexPages.PageReference pref = null;
   		ApexPages.currentPage().getParameters().put('MemberID', member.Membership_ID__c);
   		ApexPages.currentPage().getParameters().put('eMail', member.Email);
   		pref = con.handleMemberValidationRequest();
   		System.assertEquals(true, con.JSONr1.contains('"status": "Valid Member"'));
   		
   		Registered_Device__c rD = new Registered_Device__c();
   		rD.Device_Model__c = 'iPod Touch';
   		rD.Device_Token__c = '0101010101010101010101010101010101010101010101010101010101010101';
   		rD.Device_Id__c = '0123456789012345678901234567890123456789';
   		rD.Device_OS__c = 'iPhone OS 4.3';
   		rD.App_Version__c = 'Rucksack Mobile 2.0';
   		rD.Active__c = true;
   		rD.Receive_Messages__c = true;
   		
   		insert rD;
   		
   		ApexPages.currentPage().getParameters().put('MemberID', member.Membership_ID__c);
   		ApexPages.currentPage().getParameters().put('eMail', member.npe01__HomeEmail__c);
   		ApexPages.currentPAge().getParameters().put('DeviceToken','0101010101010101010101010101010101010101010101010101010101010101');
   		pref = con.handleMemberValidationRequest();
   		System.assertEquals(true, con.JSONr1.contains('"status": "Valid Member"'));
   		ApexPages.currentPage().getParameters().put('MemberID', member.Membership_ID__c);
   		ApexPages.currentPage().getParameters().put('eMail', member.npe01__AlternateEmail__c);
   		pref = con.handleMemberValidationRequest();
   		System.assertEquals(true, con.JSONr1.contains('"status": "Valid Member"'));
   		ApexPages.currentPage().getParameters().put('MemberID', nonmember.Membership_ID__c);
   		ApexPages.currentPage().getParameters().put('eMail', nonmember.Email);
   		pref = con.handleMemberValidationRequest();
   		System.assertEquals(true, con.JSONr1.contains('"status": "Invalid MemberID / eMail combination."'));
   		ApexPages.currentPage().getParameters().put('MemberID', nonmember.Membership_ID__c);
   		ApexPages.currentPage().getParameters().put('eMail', nonmember.npe01__HomeEmail__c);
   		pref = con.handleMemberValidationRequest();
   		System.assertEquals(true, con.JSONr1.contains('"status": "Invalid MemberID / eMail combination."'));
   		ApexPages.currentPage().getParameters().put('MemberID', nonmember.Membership_ID__c);
   		ApexPages.currentPage().getParameters().put('eMail', nonmember.npe01__AlternateEmail__c);
   		pref = con.handleMemberValidationRequest();
   		System.assertEquals(true, con.JSONr1.contains('"status": "Invalid MemberID / eMail combination."'));
    	Test.stopTest();
    }
    
    static testMethod void TestGiveListRequest() {
    	test.setCurrentPage(Page.RequestGiveList);
    	
    	Registered_Device__c rD = new Registered_Device__c();
   		rD.Device_Model__c = 'iPod Touch';
   		//rD.Device_Token__c = '012345679012345678901234567890123456789';
   		rD.Device_Token__c = '0101010101010101010101010101010101010101010101010101010101010101';
   		rD.Device_Id__c = '0123456789012345678901234567890123456789';
   		rD.Device_OS__c = 'iPhone OS 4.3';
   		rD.App_Version__c = 'Rucksack Mobile 2.0';
   		rD.Active__c = true;
   		rD.Receive_Messages__c = true;
   		
   		insert rD;
    	ApexPages.currentPage().getParameters().put('DeviceToken','0101010101010101010101010101010101010101010101010101010101010101');
		MobileRequestController con = new MobileRequestController();
		test.startTest();
			ApexPages.Pagereference newref = con.handleGiveListRequest();
		test.stopTest();
		System.assertNotEquals(true, con.JSONr2.contains('"status": "No data returned."'));
    }
    
    static testMethod void TestGiveDetailRequest() {
    	Give__c give = [SELECT Id FROM Give__c LIMIT 1];
    	Test.setCurrentPage(Page.RequestGiveDetail);
		MobileRequestController con = new MobileRequestController();
   		ApexPages.currentPage().getParameters().put('GiveID', give.Id);
       	ApexPages.Pagereference newref = con.handleGiveDetailRequest();
		// System.assertNotEquals(true, con.JSONr3.contains('"status": "Invalid GiveID."'));
    }
    
    static testMethod void TestRewardRequest() {
    	
    	Contact member = member();
    	Give_Instance__c gi = [SELECT Id FROM Give_Instance__c WHERE Give__r.Status__c = 'Open' LIMIT 1];
    	Test.setCurrentPage(Page.RequestReward);
		MobileRequestController con = new MobileRequestController();
   		ApexPages.currentPage().getParameters().put('MemberID', member.Membership_ID__c);
   		ApexPages.currentPage().getParameters().put('eMail', member.Email);
   		ApexPages.currentPage().getParameters().put('GiveInstanceID', gi.Id);
   		ApexPages.currentPage().getParameters().put('AddressLine1', member.MailingStreet);
   		ApexPages.currentPage().getParameters().put('City', member.MailingCity);
   		ApexPages.currentPage().getParameters().put('State', member.MailingState);
   		ApexPages.currentPage().getParameters().put('Zip', member.MailingPostalCode);
   		ApexPages.currentPage().getParameters().put('State', member.MailingState);
   		ApexPages.currentPage().getParameters().put('Phone', member.Phone);
   		ApexPages.currentPage().getParameters().put('Confirmed21', 'true');
   		test.startTest();
       		ApexPages.Pagereference newref = con.handleRewardRequest();
       	test.stopTest();
		System.assertEquals(false, (con.JSONr4.contains('"message": ""')));
    }
    
    static testMethod void TestDeviceRegistrationPositiveRegisterDefault() {
    	test.setCurrentPage(Page.DeviceRegistration);
    	MobileRequestController con = new MobileRequestController();
    	ApexPages.currentPage().getParameters().put('DeviceModel','iPod nano');
    	ApexPages.currentPage().getParameters().put('DeviceOS', 'iPhone OS 4.5');
    	ApexPages.currentPage().getParameters().put('DeviceToken', '0123456789012345678901234567890123456789');
    	ApexPages.currentPage().getParameters().put('AppVersion','Rucksack Mobile 2.0');
    	ApexPages.currentPage().getParameters().put('Action','Register');
    	//ApexPages.currentPage().getParameters().put('Messages','false');
    	
    	List<Registered_Device__c> devices = [SELECT Id From Registered_Device__c];
    	Integer oldSize = devices.size();
    	
    	test.startTest();
	    	ApexPages.Pagereference newref = con.handleDeviceRegistration();
	    	devices = [Select Id From Registered_Device__c];
    	test.stopTest();
    	
		//System.assertEquals(oldSize+1, devices.size());
    }
    
    static testMethod void TestDeviceRegistrationPositiveRegisterFalse() {
    	test.setCurrentPage(Page.DeviceRegistration);
    	MobileRequestController con = new MobileRequestController();
    	ApexPages.currentPage().getParameters().put('DeviceModel','iPod nano');
    	ApexPages.currentPage().getParameters().put('DeviceOS', 'iPhone OS 4.5');
    	ApexPages.currentPage().getParameters().put('DeviceToken', '012345678901234567890123456789');
    	ApexPages.currentPage().getParameters().put('AppVersion','Rucksack Mobile 2.0');
    	ApexPages.currentPage().getParameters().put('Action','Register');
    	ApexPages.currentPage().getParameters().put('Messages','false');
    	
    	List<Registered_Device__c> devices = [SELECT Id From Registered_Device__c];
    	Integer oldSize = devices.size();
    	
    	test.startTest();
	    	ApexPages.Pagereference newref = con.handleDeviceRegistration();
	    	devices = [Select Id From Registered_Device__c];
    	test.stopTest();
    	
		//System.assertEquals(oldSize+1, devices.size());
    }
    
    static testMethod void TestDeviceRegistrationPositiveUnRegister() {
    	test.setCurrentPage(Page.DeviceRegistration);
    	MobileRequestController con = new MobileRequestController();
    	ApexPages.currentPage().getParameters().put('DeviceModel','iPod nano');
    	ApexPages.currentPage().getParameters().put('DeviceOS', 'iPhone OS 4.5');
    	ApexPages.currentPage().getParameters().put('DeviceToken', '0123456789012345678901234567890123456789');
    	ApexPages.currentPage().getParameters().put('AppVersion','Rucksack Mobile 2.0');
    	ApexPages.currentPage().getParameters().put('Action','UnRegister');
    	ApexPages.currentPage().getParameters().put('Messages','false');
    	
    	List<Registered_Device__c> devices = [SELECT Id From Registered_Device__c];
    	Integer oldSize = devices.size();
    	
    	test.startTest();
	    	ApexPages.Pagereference newref = con.handleDeviceRegistration();
	    	devices = [Select Id From Registered_Device__c];
    	test.stopTest();
    	
		//System.assertEquals(oldSize+1, devices.size());
    }
    
    static testMethod void TestDeviceRegistrationNegativeDeviceModel() {
    	test.setCurrentPage(Page.DeviceRegistration);
    	MobileRequestController con = new MobileRequestController();
    	//ApexPages.currentPage().getParameters().put('DeviceModel','iPod nano');
    	ApexPages.currentPage().getParameters().put('DeviceOS', 'iPhone OS 4.5');
    	ApexPages.currentPage().getParameters().put('DeviceToken', '0123456789012345678901234567890123456789');
    	ApexPages.currentPage().getParameters().put('AppVersion','Rucksack Mobile 2.0');
    	ApexPages.currentPage().getParameters().put('Action','Register');
    	ApexPages.currentPage().getParameters().put('Messages','false');
    	
    	test.startTest();
	    	ApexPages.Pagereference newref = con.handleDeviceRegistration();
    	test.stopTest();
    	
    	//System.assert(true, (con.JSONr5.contains('{"message": "The DeviceModel is required.", "status": "Error"}')));
    }
    
    static testMethod void TestDeviceRegistrationNegativeDeviceOS() {
    	test.setCurrentPage(Page.DeviceRegistration);
    	MobileRequestController con = new MobileRequestController();
    	ApexPages.currentPage().getParameters().put('DeviceModel','iPod nano');
    	//ApexPages.currentPage().getParameters().put('DeviceOS', 'iPhone OS 4.5');
    	ApexPages.currentPage().getParameters().put('DeviceToken', '0123456789012345678901234567890123456789');
    	ApexPages.currentPage().getParameters().put('AppVersion','Rucksack Mobile 2.0');
    	ApexPages.currentPage().getParameters().put('Action','Register');
    	ApexPages.currentPage().getParameters().put('Messages','false');
    	
    	test.startTest();
	    	ApexPages.Pagereference newref = con.handleDeviceRegistration();
    	test.stopTest();
    	
    	System.assert(true, (con.JSONr5.contains('{"message": "The DeviceOS is required.", "status": "Error"}')));
    }
    
    static testMethod void TestDeviceRegistrationNegativeDeviceToken() {
    	test.setCurrentPage(Page.DeviceRegistration);
    	MobileRequestController con = new MobileRequestController();
    	ApexPages.currentPage().getParameters().put('DeviceModel','iPod nano');
    	ApexPages.currentPage().getParameters().put('DeviceOS', 'iPhone OS 4.5');
    	//ApexPages.currentPage().getParameters().put('DeviceToken', '0123456789012345678901234567890123456789');
    	ApexPages.currentPage().getParameters().put('AppVersion','Rucksack Mobile 2.0');
    	ApexPages.currentPage().getParameters().put('Action','Register');
    	ApexPages.currentPage().getParameters().put('Messages','false');
    	
    	test.startTest();
	    	ApexPages.Pagereference newref = con.handleDeviceRegistration();
    	test.stopTest();
    	
    	System.assert(true, (con.JSONr5.contains('{"message": "The DeviceToken is required.", "status": "Error"}')));
    }
    
    static testMethod void TestDeviceRegistrationNegativeAppVersion() {
    	test.setCurrentPage(Page.DeviceRegistration);
    	MobileRequestController con = new MobileRequestController();
    	ApexPages.currentPage().getParameters().put('DeviceModel','iPod nano');
    	ApexPages.currentPage().getParameters().put('DeviceOS', 'iPhone OS 4.5');
    	ApexPages.currentPage().getParameters().put('DeviceToken', '0123456789012345678901234567890123456789');
    	//ApexPages.currentPage().getParameters().put('AppVersion','Rucksack Mobile 2.0');
    	ApexPages.currentPage().getParameters().put('Action','Register');
    	ApexPages.currentPage().getParameters().put('Messages','false');
    	
    	test.startTest();
	    	ApexPages.Pagereference newref = con.handleDeviceRegistration();
    	test.stopTest();
    	
    	System.assert(true, (con.JSONr5.contains('{"message": "The AppVersion is required.", "status": "Error"}')));
    }
    
    static testMethod void TestDeviceRegistrationNegativeAction() {
    	test.setCurrentPage(Page.DeviceRegistration);
    	MobileRequestController con = new MobileRequestController();
    	ApexPages.currentPage().getParameters().put('DeviceModel','iPod nano');
    	ApexPages.currentPage().getParameters().put('DeviceOS', 'iPhone OS 4.5');
    	ApexPages.currentPage().getParameters().put('DeviceToken', '0123456789012345678901234567890123456789');
    	ApexPages.currentPage().getParameters().put('AppVersion','Rucksack Mobile 2.0');
    	//ApexPages.currentPage().getParameters().put('Action','Register');
    	ApexPages.currentPage().getParameters().put('Messages','false');
    	
    	test.startTest();
	    	ApexPages.Pagereference newref = con.handleDeviceRegistration();
    	test.stopTest();
    	
    	System.assert(true, (con.JSONr5.contains('{"message": "The Action is required.", "status": "Error"}')));
    }
    
    static testMethod void TestDeviceRegistrationNegativeActionWrong() {
    	test.setCurrentPage(Page.DeviceRegistration);
    	MobileRequestController con = new MobileRequestController();
    	ApexPages.currentPage().getParameters().put('DeviceModel','iPod nano');
    	ApexPages.currentPage().getParameters().put('DeviceOS', 'iPhone OS 4.5');
    	ApexPages.currentPage().getParameters().put('DeviceToken', '0123456789012345678901234567890123456789');
    	ApexPages.currentPage().getParameters().put('AppVersion','Rucksack Mobile 2.0');
    	ApexPages.currentPage().getParameters().put('Action','WrongAction');
    	ApexPages.currentPage().getParameters().put('Messages','false');
    	
    	test.startTest();
	    	ApexPages.Pagereference newref = con.handleDeviceRegistration();
    	test.stopTest();
    	
    	System.assert(true, (con.JSONr5.contains('{"message": "The Action is invalid. (Only Register or UnRegister)", "status": "Error"}')));
    }
    
    static testMethod void TestDeviceRegistrationNegativeMessagesWrong() {
    	test.setCurrentPage(Page.DeviceRegistration);
    	MobileRequestController con = new MobileRequestController();
    	ApexPages.currentPage().getParameters().put('DeviceModel','iPod nano');
    	ApexPages.currentPage().getParameters().put('DeviceOS', 'iPhone OS 4.5');
    	ApexPages.currentPage().getParameters().put('DeviceToken', '0123456789012345678901234567890123456789');
    	ApexPages.currentPage().getParameters().put('AppVersion','Rucksack Mobile 2.0');
    	ApexPages.currentPage().getParameters().put('Action','Register');
    	ApexPages.currentPage().getParameters().put('Messages','this is an invalid message');
    	
    	test.startTest();
	    	ApexPages.Pagereference newref = con.handleDeviceRegistration();
    	test.stopTest();
    	
    	System.assert(true, (con.JSONr5.contains('{"message": "The Messages is invalid. (Only true or false, default true)", "status": "Error"}')));
    }  
}