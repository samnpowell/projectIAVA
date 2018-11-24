public without sharing class cov_user_contact_utility {
	public cov_user_contact_utility() {
		
	}

  public static Contact getContactFromUser(User theU) {
  	return getContactFromUser(theU, new List<String>());
  }


  public static Contact getContactFromUser(User theU, List<String> additionalFields) {
 		String criteria = '';
		if (theU.ContactId != null) {
			System.debug('theU.ContactId is not null, it is: ' + theU.ContactId);
			criteria = 'Id = \'' + theU.ContactId + '\'';
//				c = u.Contact;
		} else {
			// find another contact record that points to this user (for staff users)
			criteria = 'Portal_User__c = \'' + theU.Id + '\'';
		}

		Contact theC;
		try {
			//System.debug('UserInfo.getUserId(): ' + UserInfo.getUserId());
			String q = 'select Id, Email, Portal_User__c'
				+ ', Member_Categories__c' 
				+ ', MA_Latitude__c, MA_Longitude__c' 
				+ ', MailingState, MailingPostalCode';

			for (String s : additionalFields) {
				//if (cov_user_utility.hasSObjectField(s, 'Contact')) {
				if (!q.contains(' ' + s)) { // make sure the field is not already part of the query
					q+= ', ' + s;
				}
				//}
			}

			q += ' from Contact where ' + criteria + ' limit 1';
			System.debug('q from cov_user_contact_utility: ' + q);
			theC = Database.query(q);
			System.debug('theC from cov_user_contact_utility: ' + theC);


		} catch(QueryException e){
			System.debug('e: ' + e);
		}
		if (theC != null) {
			System.debug('theC: ' + theC);
		} else {
			System.debug('No corresponding contact found for user: ' + theU);
		}	
		return theC;
  }

  public static User getUserFromContact(Contact theC, List<String> additionalFields) {

 		String criteria = '';

		User theU;
		try {
			//System.debug('UserInfo.getUserId(): ' + UserInfo.getUserId());
			String q = 'select Id, Name, SmallPhotoURL, FullPhotoURL';

			if (additionalFields != null) {
				for (String s : additionalFields) {
					//if (cov_user_utility.hasSObjectField(s, 'Contact')) {
					if (!q.contains(' ' + s)) { // make sure the field is not already part of the query
						q+= ', ' + s;
					}
					//}
				}
			}

			q += ' from User where Id = \'' + theC.Portal_User__c + '\''
			+ ' limit 1';
			System.debug('q from cov_user_contact_utility getUserFromContact: ' + q);
			theU = Database.query(q);
			System.debug('theU from cov_user_contact_utility getUserFromContact: ' + theU);


		} catch(QueryException e){
			System.debug('e: ' + e);
		}
		if (theU != null) {
			System.debug('theU: ' + theU);
		} else {
			System.debug('No corresponding User found for contact: ' + theC);
		}	
		return theU;


  }

  public static Map<Id, Id> getContactIdToUserIdMap(Set<Id> contactIds) {
  	List<Contact> contacts = [select Id, Portal_User__c from Contact where Id in :contactIds];
  	Map<Id, Id> theMap = new Map<Id, Id>();
  	for (Contact con : contacts) {
  		theMap.put(con.Id, con.Portal_User__c);
  	}
  	return theMap;
  }


  public static Map<Id, Id> getUserIdToContactIdMap(Set<String> userIdStrings) {
  	Set<Id> ids = new Set<Id>();
  	for (String s : userIdStrings) {
  		try {
  			Id theId = (Id)s;
  			ids.add(theId);
  		}
  		catch(Exception e) {}
  	}
  	return getUserIdToContactIdMap(ids);
  }

  public static Map<Id, Id> getUserIdToContactIdMap(Set<Id> userIds) {
  	List<Contact> contacts = [select Id, Portal_User__c from Contact where Portal_User__c in :userIds];
  	Map<Id, Id> theMap = new Map<Id, Id>();
  	for (Contact con : contacts) {
  		theMap.put(con.Portal_User__c, con.Id);
  	}
  	return theMap;
  }

  public static List<Contact> getContactsFromEmail(String email) {
  	return getContactsFromEmail(email, '');
  }

  public static List<Contact> getContactsFromEmail(String email, String querySuffix) {
  	List<String> emptyList = new List<String>();
  	return getContactsFromEmail(email, emptyList, querySuffix);
  }

  public static List<Contact> getContactsFromEmail(String email, List<String> extraFields) {
  	return getContactsFromEmail(email, extraFields, '');
  }

  public static List<Contact> getContactsFromEmail(String email, List<String> extraFields, String querySuffix) {
  	Set<String> emails = new Set<String>();
  	emails.add(email);
  	return getContactsFromEmails(emails, extraFields, querySuffix);
  }



  public static List<Contact> getContactsFromEmails(Set<String> emails) {
  	return getContactsFromEmails(emails, '');
  }

  public static List<Contact> getContactsFromEmails(Set<String> emails, String querySuffix) {
  	List<String> emptyList = new List<String>();
  	return getContactsFromEmails(emails, emptyList, querySuffix);
  }


  public static List<Contact> getContactsFromEmails(Set<String> emails, List<String> extraFields) {
  	return getContactsFromEmails(emails, extraFields, '');
  }

  public static List<Contact> getContactsFromEmails(Set<String> emails, List<String> extraFields, String querySuffix) {
	    if (emails.size() == 0) {
	    	return null;
	    } else {
	    	Set<String> fieldsToQuery = new Set<String>();
	    	fieldsToQuery.add('FirstName');
	    	fieldsToQuery.add('LastName');
	    	fieldsToQuery.add('Email');
	    	fieldsToQuery.add('Member_Categories__c');
	    	fieldsToQuery.addAll(extraFields);
	    	String q = 'select Id';
	    for (String s : fieldsToQuery) {
		    	q+= s == 'Id' ? '' : ', ' + s;
	    }

	    q+=                           ' from Contact where'
	                                + ' Email in :emails'
	                                + ' or npe01__AlternateEmail__c in :emails'
	                                + ' or npe01__HomeEmail__c in :emails'
	                                + ' or npe01__WorkEmail__c in :emails'
	                                  ;
	    q += ' ' + querySuffix;
	    System.debug('query to pull contacts from emails: ' + q);
	    try {
	        	List<Contact> contactsFromEmails = Database.query(q);
	        	return contactsFromEmails;
	        } catch (Exception e) { cov_log_error.logError(e, 'error querying to pull contacts from emails'); return null;}
	}

  }

}