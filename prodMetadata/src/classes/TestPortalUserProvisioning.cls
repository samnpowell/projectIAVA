/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestPortalUserProvisioning {
	
	static testMethod void testCreatePortalUsersWithErrors() {
		
		List<Contact> contacts = new List<Contact>();
		
		for (Integer i = 0; i < 10; i++) {
			// licenses should be provisioned for confirmed IAVA members
			contacts.add( new Contact(
								LastName = 'TestMember' + (i < 10 ? '0' : '') + i, 
								Email	 = 'testmember' + (i < 10 ? '0' : '') + i + '@test.org',
								Veteran_Member__c = true,
								Paperwork_Confirmation__c = 'Paperwork Accepted',
								Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND'
								) );
			// no licenses should be provisioned for confirmed IAVA members with dupe emails (case-insensitive)
			contacts.add( new Contact(
								LastName = 'TestMemberDupeEmail' + (i < 10 ? '0' : '') + i, 
								Email	 = 'testMember' + (i < 10 ? '0' : '') + i + '@test.org',
								Veteran_Member__c = true,
								Paperwork_Confirmation__c = 'Paperwork Accepted',
								Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND'
								) );
			// licenses should be provisioned for unconfirmed IAVA members
			contacts.add( new Contact(
								LastName = 'TestUnconfirmedMember' + (i < 10 ? '0' : '') + i, 
								Email	 = 'TestUnconfirmedMember' + (i < 10 ? '0' : '') + i + '@test.org',
								Veteran_Member__c = true,
								Paperwork_Confirmation__c = 'Paperwork Received') );
		}
		
		for (Integer i = 0; i < 8; i++) {
			// no licenses should be provisioned for confirmed IAVA members with no email
			contacts.add( new Contact(
								LastName = 'TestMemberNoEmail' + (i < 10 ? '0' : '') + i, 
								Veteran_Member__c = true,
								Paperwork_Confirmation__c = 'Paperwork Accepted',
								Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND'
								) );
		}
		
		// 2 contacts matching existing users
		List<User> existingUsers = [select Username from User where IsActive = true limit 2];
		for (Integer i = 0; i < 2; i++) {
			// no licenses should be provisioned for 2 contacts clashing with existing usernames
			contacts.add( new Contact(
								LastName = 'TestUsernameClash' + i, 
								Email	 = existingUsers[i].Username,
								Veteran_Member__c = true,
								Paperwork_Confirmation__c = 'Paperwork Accepted',
								Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND'
								) );
		}
		
		insert contacts;
		
		for (Contact c : contacts) {
			c.Create_Portal_User__c = true;
		}
		
		Test.startTest();
		update contacts;
		Test.stopTest();
		
		Id profileId = PortalUserProvisioning.getPortalProfileId();
		
		System.assertEquals(10, [select count() from User where ProfileId = :profileId and LastName like 'TestMember%']);
		System.assertEquals(0,  [select count() from User where ProfileId = :profileId and LastName like 'TestMemberDupeEmail%']);
		System.assertEquals(10,  [select count() from User where ProfileId = :profileId and LastName like 'TestUnconfirmedMember%']);
		System.assertEquals(0,  [select count() from User where ProfileId = :profileId and LastName like 'TestMemberNoEmail%']);
		System.assertEquals(0,  [select count() from User where ProfileId = :profileId and LastName like 'TestUsernameClash%']);

		//System.assertEquals('Veteran', [select CompanyName from User where LastName like 'TestMember%' limit 1].CompanyName);
	}
	
}