public class PortalUserAction {
	
	@future		// need to be asynchronous to avoid mixed dml error
	public static void updatePortalUsers(Map<Id, String> contactEmailById) {
		List<User> usersToUpdate = new List<User>();
		for (User u : [select Id, ContactId, Email, Username from User where ContactId in :contactEmailById.keySet()]) {
			String email = contactEmailById.get(u.ContactId);
			if (u.Username != email || u.Email != email) {
				u.Username = email;
				u.Email = email;
				usersToUpdate.add(u);
			}
		}
		
		if (!usersToUpdate.isEmpty())
			update usersToUpdate;
	}
	
	////////// tests //////////
	
	private static testMethod void portalUsernamesUpdated() {
		Contact c1 = createMember('ConfirmedMember1', 'test1@confirmedMember.org', true, 'Paperwork Accepted');
		Contact c2 = createMember('ConfirmedMember2', 'test2@confirmedMember.org', true, 'Paperwork Accepted');
		Contact c3 = createMember('ConfirmedMember3', 'test3@confirmedMember.org', true, 'Paperwork Accepted');
		
		List<Contact> contacts = new List<Contact> { c1, c2, c3 };
		insert contacts;
		
		PortalUserProvisioning.createPortalUsers(contacts);
		
		List<User> users = [select Id, ContactId, Username, Email from User where ContactId in :contacts];
		
		System.assertEquals(3, users.size());
		for (User u : users) {
			if (u.ContactId == c1.Id) {
				System.assertEquals(c1.Email.toLowercase(), u.Username);
				System.assertEquals(c1.Email.toLowercase(), u.Email);
			} else if (u.ContactId == c2.Id) {
				System.assertEquals(c2.Email.toLowercase(), u.Username);
				System.assertEquals(c2.Email.toLowercase(), u.Email);
			} else {
				System.assertEquals(c3.Email.toLowercase(), u.Username);
				System.assertEquals(c3.Email.toLowercase(), u.Email);
			}
		}
		
		Test.startTest();
		for (User u : users) {
			if (u.ContactId == c2.Id) {
				u.IsActive = false;
				update u;
				break;
			}
		}
		c1.Email = 'newEmail1@confirmedMember.org';		// with active portal user
		c2.Email = 'newEmail2@confirmedMember.org';		// with inactive portal user
		update contacts;
		Test.stopTest();
		
		users = [select Id, ContactId, Username, Email from User where ContactId in :contacts];
		
		System.assertEquals(3, users.size());
		for (User u : users) {
			if (u.ContactId == c1.Id) {
				System.assertEquals(c1.Email.toLowercase(), u.Username);
				System.assertEquals(c1.Email.toLowercase(), u.Email);
			} else if (u.ContactId == c2.Id) {
				System.assertEquals(c2.Email.toLowercase(), u.Username);
				System.assertEquals(c2.Email.toLowercase(), u.Email);
			} else {
				System.assertEquals(c3.Email.toLowercase(), u.Username);
				System.assertEquals(c3.Email.toLowercase(), u.Email);
			}
		}
	}
	
	private static Contact createMember(String name, String email, Boolean isVeteran, String status) {
		Contact c = new Contact(FirstName = 'Test', LastName = name, Email = email, Veteran_Member__c = isVeteran, Paperwork_Confirmation__c = status);
		if (status == 'Paperwork Accepted') {
			c.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
		}		
		return c;
	}
	
}