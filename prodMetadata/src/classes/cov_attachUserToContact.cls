public without sharing class cov_attachUserToContact {


		@future
		public static void updateContacts(set<Id> theSet, map<Id, Id> contactUserMap) {
			List<Contact> contactsToUpdate = [select Id from Contact where Id in :theSet];
			if(contactsToUpdate.size() > 0) {
				for(Contact c : contactsToUpdate) {
					System.debug('c: ' + c);					
					System.debug('contactUserMap.get(c.Id): ' + contactUserMap.get(c.Id));		
					c.Portal_User__c = contactUserMap.get(c.Id);
				}
				update contactsToUpdate;
			}

		}

}