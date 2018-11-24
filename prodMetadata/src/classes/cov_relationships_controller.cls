public without sharing class cov_relationships_controller {
	// without sharing to access other contact records and add relationships


	public static List<npe4__Relationship__c> addRelationship(Id originContactId, Id targetContactId
														, String primaryRelType, String recipRelType
														, Boolean addFollows) {
		return addRelationships(originContactId, new List<Id>{targetContactId}, primaryRelType, recipRelType, addFollows);
	}

	public static List<npe4__Relationship__c> addRelationships(Id originContactId, List<Id> targetContactIds
														, String primaryRelType, String recipRelType
														, Boolean addFollows) {

			List<npe4__Relationship__c> existingRelationships = [select Id, npe4__RelatedContact__c from npe4__Relationship__c where
						    		npe4__Contact__c = :originContactId 
						    		and npe4__Type__c = :primaryRelType 
						    		and npe4__RelatedContact__c in :targetContactIds
						    		];
			Map<Id, npe4__Relationship__c> targetContactIdToExistingRelationshipMap = new Map<Id, npe4__Relationship__c>();
			for (npe4__Relationship__c existingRel : existingRelationships) {
				targetContactIdToExistingRelationshipMap.put(existingRel.npe4__RelatedContact__c, existingRel);
			}
	        
			List<npe4__Relationship__c> newPrimaryRelationships = new List<npe4__Relationship__c>();

			for (Id targetId : targetContactIds) {
				if (!targetContactIdToExistingRelationshipMap.containsKey(targetId)) {
					npe4__Relationship__c newRel = new npe4__Relationship__c(
			    		npe4__Contact__c = originContactId
			    		, npe4__RelatedContact__c = targetId
			    		, npe4__Type__c = primaryRelType
			    		//, npe4__Status__c = 'Current'
			    	);
					newPrimaryRelationships.add(newRel);
				}
			}
			System.debug('About to insert these primary relationships: ' + newPrimaryRelationships);
			Database.SaveResult[] srList = Database.insert(newPrimaryRelationships, false);

			List<npe4__Relationship__c> successfulPrimaryRelationships = new List<npe4__Relationship__c>();
			for(Integer i = 0 ; i < newPrimaryRelationships.size() ; i++) {
				if(srList.get(i).isSuccess()){
					npe4__Relationship__c successRel = newPrimaryRelationships.get(i);
					successRel.Id = srList.get(i).getId();
					successfulPrimaryRelationships.add(successRel);
				} else {
					cov_log_error.logDevMsg('error adding rel to Id ' + newPrimaryRelationships.get(i).npe4__RelatedContact__c + ': ' + srList.get(i).getErrors());
				}
			}
			
			
			// A portal user doesn't have permissions for the reciprocal relationship trigger to run
			// so we have to manually insert the reciprocal relationship
			// April 2016 - This code no longer necessary with NPSP3

			//if (UserInfo.getUserType() != 'Standard') {
			//	List<npe4__Relationship__c> newRecipRelationships = new List<npe4__Relationship__c>();
			//	for(npe4__Relationship__c successfulRel : successfulPrimaryRelationships) {
			//		npe4__Relationship__c newRelRecip = new npe4__Relationship__c(
			//    		npe4__Contact__c = successfulRel.npe4__RelatedContact__c
			//    		, npe4__RelatedContact__c = successfulRel.npe4__Contact__c
			//    		//, npe4__Status__c = 'Current'
			//    		, npe4__Type__c = recipRelType
			//    		, npe4__ReciprocalRelationship__c = successfulRel.id
			//    	);
			//    	newRecipRelationships.add(newRelRecip);

			//    }

			//	System.debug('About to insert these reciprocal relationships: ' + newRecipRelationships);
			//	Database.SaveResult[] srList2 = Database.insert(newRecipRelationships, false);
			//	system.debug('saveresult from reciprocal relationships: ' + srList2);

			//	Map<Id, Id> targetContactIdToRecipRelMap = new Map<Id, Id>();
			//	for(Integer i = 0 ; i < newRecipRelationships.size() ; i++) {
			//		if(srList2.get(i).isSuccess()){
			//			targetContactIdToRecipRelMap.put(newRecipRelationships.get(i).npe4__Contact__c, srList2.get(i).getId());
			//		} else {
			//			cov_log_error.logDevMsg('error adding recip rel on Id ' + newRecipRelationships.get(i).npe4__Contact__c + ': ' + srList.get(i).getErrors());
			//		}
			//	}

			//	//now go back and add recip id to orig relationship
			//	for (npe4__Relationship__c successfulRel : successfulPrimaryRelationships) {
			//		successfulRel.npe4__ReciprocalRelationship__c = targetContactIdToRecipRelMap.get(successfulRel.npe4__RelatedContact__c);
			//	}
			//	Database.SaveResult[] srList3 = Database.update(successfulPrimaryRelationships, false);
			//	system.debug('saveresult from primary relationships update with recip Ids: ' + srList3);				

			//}

			// now follow the user who you just vouched for if they already exist
			if (addFollows) {
				System.debug('Adding follow records for the contact');
				cov_autofollow_relationships.followAllRelationships(originContactId, new List<String>{primaryRelType}, true);
			}
			return successfulPrimaryRelationships;

	}



}