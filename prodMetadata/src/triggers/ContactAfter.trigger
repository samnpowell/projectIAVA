trigger ContactAfter on Contact (after update, after insert) {
	
	List<Contact> contactsToProvisionPortalUsers = new List<Contact>();
	Map<Id, String> contactEmailById = new Map<Id, String>();
	
	for (Contact c : Trigger.new) {
		if (c.Create_Portal_User__c && (Trigger.isInsert || !Trigger.oldMap.get(c.Id).Create_Portal_User__c)) {  // checking this flag triggers portal user creation
			// && c.Veteran_Member_Status__c == 'Confirmed') {
			// portal user no longer only provisioned for confirmed IAVA members - SD 2/3/14
			contactsToProvisionPortalUsers.add(c);
		} else if (Trigger.isUpdate && c.Email != null && c.Email != Trigger.oldMap.get(c.Id).Email) {
			contactEmailById.put(c.Id, c.Email);
		}
	}
	
	if (!contactsToProvisionPortalUsers.isEmpty())
		PortalUserProvisioning.createPortalUsers(contactsToProvisionPortalUsers);
	
	if (!contactEmailById.isEmpty())
		PortalUserAction.updatePortalUsers(contactEmailById);
	
}