public without sharing class cov_autofollow_relationships {


	/*
		* Pass a list of Contacts (or Contact Ids or Strings with Contact Ids)
		* along with a list of relationship types
		* and it will add follow records for everyone who that contact has a relationship
		* of those types with
		*
		* Used to establish auto-follow for people who vouch for each other.
		*
		* SD 2013
	*/

	/*		
		case a: new user signs up, already has vouches (followAllRelationships):
			- auto-add follows for all relationships where the new user is vouchee
			- auto-add follows for other person on all relationships where the new user is vouchee
							
		case b: new vouch is added (followOneRelationship):
			- auto-add follow of the specific vouchee
	*/	

	// USE THIS IF YOU WANT TO JUST INSERT A SINGLE FOLLOW BASED ON A RELATIONSHIP BETWEEN TWO CONTACTS

	public static void followOneRelationship(Id contactId, Id relContactId, List<String> relTypes, Boolean followBothWays) {
		followRelationshipsMain(new List<Id>{contactId}, relTypes, relContactId, followBothWays);
	}
	

	// USE THESE IF YOU WANT TO JUST INSERT FOLLOWS BASED ON ALL RELATIONSHIPS WITH A CONTACT

	public static void followAllRelationships(Id contactId, List<String> relTypes, Boolean followBothWays) {
		List<Id> conIds = new List<Id>();
		conIds.add(contactId);
		followAllRelationships(conIds, relTypes, followBothWays);		
	}

	public static void followAllRelationships(Id contactId, String relType, Boolean followBothWays) {
		List<Id> conIds = new List<Id>();
		conIds.add(contactId);
		List<String> relTypes = new List<String>{relType};
		followAllRelationships(conIds, relTypes, followBothWays);		
	}


	// USE THESE IF YOU WANT TO JUST INSERT FOLLOWS BASED ON ALL RELATIONSHIPS
	// WITH A LIST OF CONTACTS (e.g. from a trigger)

	public static void followAllRelationships(List<Contact> contacts, List<String> relTypes, Boolean followBothWays) {
		List<Id> conIds = new List<Id>();
		for (Contact c : contacts) {
			conIds.add(c.Id);
		}
		followAllRelationships(conIds, relTypes, followBothWays);		
	}

	public static void followAllRelationships(List<String> contactIdStrings, List<String> relTypes, Boolean followBothWays) {
		List<Id> conIds = new List<Id>();
		for (String s : contactIdStrings) {
			conIds.add((Id)s);
		}
		followAllRelationships(conIds, relTypes, followBothWays);		
	}



	// THIS IS AN ADAPTER TO THE MAIN METHOD for the followAll methods
	public static void followAllRelationships(List<Id> contactIds, List<String> relTypes, Boolean followBothWays) {
		followRelationshipsMain(contactIds, relTypes, null, followBothWays);
	}


	public class IdPair {
    	Id primaryUser, relatedUser;

	    public IdPair(Id a, Id b) {
	        primaryUser=a;
	        relatedUser=b;
	    }
	    
	    public Boolean equals(Object obj) {
	        if (obj instanceof IdPair) {
	            IdPair p = (IdPair)obj;
	            return ((primaryUser==p.primaryUser) && (relatedUser==p.relatedUser));
	        }
	        return false;
    	}
    	
    	public Integer hashCode() {
        	return (31 * ((String)primaryUser).hashCode()) ^ ((String)relatedUser).hashCode();
    	}
    	
	}

	public static void followRelationshipsMain(List<Id> contactIds, List<String> relTypes, Id relContactId, Boolean followBothWays) {
		
		System.debug('in main followRelationships method.');
		System.debug('contactIds: ' + contactIds );
		System.debug('relTypes: ' + relTypes );
		System.debug('relContactId: ' + relContactId);
		System.debug('followBothWays: ' + followBothWays);

		Id theNetworkId = cov_user_utility.self.getNetworkId();


		// if relContactId is null, figure it's a followAll 
		// if relContactId is not null, figure it's a followOne
		
		String q = 'select npe4__RelatedContact__r.Portal_User__c'
				+ ', npe4__RelatedContact__r.Portal_User__r.isActive'
				+ ', npe4__Contact__r.Portal_User__r.isActive'
				+ ', npe4__Contact__r.Portal_User__c'
				+ ', npe4__Type__c'
				+ ' from npe4__Relationship__c'
				+ ' where npe4__Contact__c in :contactIds'
				+ ' and npe4__Type__c in :relTypes'
//				+ ' and npe4__RelatedContact__r.Portal_User__c in (SELECT MemberId FROM NetworkMember where NetworkId = :theNetworkId)'
				;
		if (relContactId != null) {
			q += ' and npe4__RelatedContact__c = :relContactId';
		}
		System.debug('q: ' + q);
		List<npe4__Relationship__c> relationships = Database.query(q);
				
		System.debug('relationships.size(): ' + relationships.size());
		System.debug('relationships: ' + relationships);
		



		// First need to check that related users are in the network
		Set<Id> allUserIdsFromRelationships = new Set<Id>();
		for(npe4__Relationship__c rel : relationships) {
			if (rel.npe4__Contact__r.Portal_User__c != null && rel.npe4__Contact__r.Portal_User__r.isActive) { 
				allUserIdsFromRelationships.add(rel.npe4__Contact__r.Portal_User__c); 
			}
			if (rel.npe4__RelatedContact__r.Portal_User__c != null && rel.npe4__RelatedContact__r.Portal_User__r.isActive) { 
				allUserIdsFromRelationships.add(rel.npe4__RelatedContact__r.Portal_User__c); 
			}
		}
		List<User> allUsersFromRelationships = [select Id from User where id in :allUserIdsFromRelationships
			and isActive = true
			and Id in (SELECT MemberId FROM NetworkMember where NetworkId = :theNetworkId)];
		Set<Id> networkUserIdsFromRelationships = (new Map<Id,SObject>(allUsersFromRelationships)).keySet(); // generate set of Ids from List


		// Now check if the users are in the network before adding them to the list of users
		Set<Id> userIds = new Set<Id>();
		Set<IdPair> userIdPairs = new Set<IdPair>();
		for(npe4__Relationship__c rel : relationships) {
//			if (rel.npe4__Contact__r.Portal_User__c != null && rel.npe4__RelatedContact__r.Portal_User__c != null) {
			if (networkUserIdsFromRelationships.contains(rel.npe4__Contact__r.Portal_User__c) 
				&& networkUserIdsFromRelationships.contains(rel.npe4__RelatedContact__r.Portal_User__c)) {
				userIds.add(rel.npe4__Contact__r.Portal_User__c);
				userIdPairs.add(new IdPair(rel.npe4__Contact__r.Portal_User__c, rel.npe4__RelatedContact__r.Portal_User__c));
				if (followBothWays) {
					userIds.add(rel.npe4__RelatedContact__r.Portal_User__c);
					userIdPairs.add(new IdPair(rel.npe4__RelatedContact__r.Portal_User__c, rel.npe4__Contact__r.Portal_User__c));					
				}
			}
		}
		
		List<User> autofollowUsers;
		if (relContactId == null) { //followAll
			autofollowUsers = [select id from User where Everyone_follows_in_COV__c = true
				and isActive = true
				and Id in (SELECT MemberId FROM NetworkMember where NetworkId = :theNetworkId)];
			System.debug('autofollowUsers: ' + autofollowUsers);
			for (User uuu : autofollowUsers) {
				userIds.add(uuu.Id);
			}
		} else { //followOne
			autofollowUsers = new List<User>();
		}

		List<Contact> contactUsers = [select id, Portal_User__c, Portal_User__r.isActive from Contact where id in :contactIds];
		
		for (Contact c : contactUsers) {
			if (c.Portal_User__c != null && c.Portal_User__r.isActive) {
				userIds.add(c.Portal_User__c);
				for (User uuu : autofollowUsers) {
					userIdPairs.add(new IdPair(c.Portal_User__c, uuu.Id));
				}
			}
		}
		
		System.debug('userIds: ' + userIds);
		System.debug(userIdPairs.size() + ' userIdPairs: ' + userIdPairs);
		for (IdPair idp : userIdPairs) {
			System.debug('userIdPairs idp: ' + idp);
		}
		
		List <EntitySubscription> follows = new List <EntitySubscription>();
		System.debug('relContactId: ' + relContactId);

		if (relContactId == null) { //followAll
			follows = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid in :userIds and parentId in :userIds limit 1000];		
			System.debug('follows.size(): ' + follows.size());
		} else { //followOne
			System.debug('relContactId is not null so it is a followOne between two specified contacts.');
			// it's a followOne so pull just the follows between these users
			follows = [select parentId, subscriberid, networkId from EntitySubscription
					where 
						(subscriberid = :relationships[0].npe4__Contact__r.Portal_User__c
						and parentid = :relationships[0].npe4__RelatedContact__r.Portal_User__c)
					or
						(subscriberid = :relationships[0].npe4__RelatedContact__r.Portal_User__c
						and parentid = :relationships[0].npe4__Contact__r.Portal_User__c)
					limit 1000
					];
		}

		System.debug('existing follows: ' + follows);

		// Put existing follows into a set with both Ids concatenated separated by a pipe
		// so it can be easily checked whether a combo is in the set.
		Set<String> existingFollowerFolloweeCombos = new Set<String>();
		for(EntitySubscription es : follows) {
			existingFollowerFolloweeCombos.add(es.SubscriberId + '|' + es.ParentId);
		}

		
		List <EntitySubscription> followsToInsert = new List <EntitySubscription>();		

		System.debug('followsToInsert on initialization: ' + followsToInsert);

		for (IdPair ii : userIdPairs) {
			System.debug('Now looking at this IdPair: ' + ii);
			Boolean alreadyFollowing = false;

			if (existingFollowerFolloweeCombos.contains(ii.primaryUser + '|' + ii.relatedUser)) {
				System.debug('User ' + ii.primaryUser + ' is already following user ' + ii.relatedUser);
				alreadyFollowing = true;
			} else {
				System.debug('User ' + ii.primaryUser + ' is NOT YET following user ' + ii.relatedUser);
			}


			//for(EntitySubscription es : follows) {
			//	System.debug('Existing EntitySubscription es: ' + es);
			//	if (es.parentId == ii.relatedUser
			//			&& es.SubscriberId == ii.primaryUser
			//			// && es.NetworkId == theNetworkId  // check for follow regardless of whether in network
			//	   ){
			//		System.debug('User ' + ii.primaryUser + ' is already following user ' + ii.relatedUser + ' on Network: ' + es.NetworkId);
			//		alreadyFollowing = true;
			//	} else {
			//		System.debug('User ' + ii.primaryUser + ' is NOT YET following user ' + ii.relatedUser + ' on Network: ' + es.NetworkId);
			//	}
/*				if (followBothWays && es.parentId == ii.primaryUser
						&& es.SubscriberId == ii.relatedUser
						&& es.NetworkId == theNetworkId) {
					System.debug('User ' + ii.relatedUser + ' is already following.');
					alreadyFollowingOtherWay = true;
				}
*/
			//}
			if (!alreadyFollowing && (ii.primaryUser != ii.relatedUser)) {
				System.debug('Since User ' + ii.primaryUser + ' is not yet following user ' + ii.relatedUser + ', insert a follow.');
				followsToInsert.add(
					new EntitySubscription (
						parentId = ii.relatedUser,
                        subscriberid = ii.primaryUser,
                        networkId = theNetworkId
                    )
                );
			}
/*			if (followBothWays && !alreadyFollowingOtherWay) {
				System.debug('User ' + ii.relatedUser + ' not yet following.');					
				followsToInsert.add(
					new EntitySubscription (
						parentId = ii.primaryUser,
                        subscriberid = ii.relatedUser,
                        networkId = theNetworkId
                    )
                );
			}
*/
		}
		System.debug('followsToInsert: ' + followsToInsert);
		if (followsToInsert.size() > 0) {
			Database.SaveResult[] srs = database.insert(followsToInsert, false);
			//try {
			//	insert followsToInsert;
			//	System.debug('follows inserted.');
			//} catch (DMLException e) { cov_log_error.logError(e); }
	        Integer errorCount = 0; 
			for (Integer i = 0; i < srs.size() && errorCount < 5; i++) {
			//for (Database.SaveResult sr : srs) {
		        if (srs[i].isSuccess()) {
			        // Operation was successful, so get the ID of the record that was processed
			        System.debug('Successfully inserted follow ID: ' + srs[i].getId());
			    } else {
			        System.debug('Error inserting follow: ' + srs[i].getErrors()[0].getMessage());
			    	errorCount++;
			        // Operation failed, so get all errors   
			     //   String errorFields = '';            
			     //   for(Database.Error err : srs[i].getErrors()) {
			     //   	errorCount++;
			     //       System.debug('The following error has occurred.');                    
			     //       System.debug(err.getStatusCode() + ': ' + err.getMessage());
			     //       System.debug('PermissionSetAssignment fields that affected this error: ' + err.getFields());
			     //       errorFields += err.getFields() + '/';
			     //   }
			     //   if (userList.size() == 1 && !Trigger.isExecuting) {
			     //       ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Sorry there was an error joining COV. Please let us know at covdev@iava.org so we can look into it.')); 
				    //}
			    }
			}
	        if (errorCount > 0) {
	        	cov_log_error.logDevMsg((errorCount >= 5 ? 'At least ' : '') + errorCount + ' error(s) trying to insert follows.');
	        }
		}
	}		


}