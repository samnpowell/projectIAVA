/*
 	When a portal user record is attached to a Contact, also fill in the
	Portal_User__c field on Contact so there is an easy lookup from 
	User to Contact, for use in COV programming
	
	SD Sep 2013

*/


trigger cov_attachUserToContact on User (after insert, after update) {

	
		set<Id> IDset = new set<Id>(); 
		Map<Id, Id> contactUserMap = new Map<Id, Id>();
		
		for (User u : Trigger.new) {

			if (u.UserType == 'CSPLitePortal' || u.UserType == 'CustomerSuccess' ||
				u.UserType == 'PowerCustomerSuccess') {
			
				User u_old = new User();

				System.debug('u.ContactId: ' + u.ContactId);

				if (Trigger.isUpdate){
					u_old = Trigger.oldMap.get(u.Id);
					System.debug('u_old.ContactId: ' + u_old.ContactId);
				}
		
				if (u.ContactId != null &&
						((Trigger.isInsert) || (Trigger.isUpdate &&
					          						(
					          						 (u.isActive && !(u_old.isActive))
					          						 || 
					          						 (u.ContactId != u_old.ContactId)
					          						)
					    					    )
					    )
				    ) {
					IDset.add(u.ContactId);
					contactUserMap.put(u.ContactId, u.Id);
										
			    } else if (Trigger.isUpdate && 
			    				((u.ContactId == null && u_old.ContactId != null)
						     	|| ( !(u.isActive) && u_old.isActive))) {
					IDset.add(u_old.ContactId);
					contactUserMap.put(u_old.ContactId, null);
			    }
			}
		}
		
		if (IDset.size() > 0) {   
				cov_attachUserToContact.updateContacts(IDset, contactUserMap);
				// removed to separate @future method to avoid MIXED_DML_OPERATION error
		}
		

}