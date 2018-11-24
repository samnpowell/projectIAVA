/*

	When someone arrives at any COV page if they're not on a profile with Access
	send them to the gateway page (via a custom not-authorized page?)

	Grab the custom setting.
	If restrict to campaign members only is checked, pull the campaign record and check if the user's contact is a member.
		(Use a function that takes a list of contacts, so it can be used both for the indiv user and a list of relationship contacts).
	If not restricted, check the user's contact's concatenated membercategories field against the custom setting's list
	If allow vouchees is checked, pull the relationships and check if any of those contacts are a member

    If they accept, redirect to cov_dashboard


*/


public without sharing class cov_gateway_controller {
//	TODO - switch back to without since production seems to need it to be able to see relationships.  not sure why test not turning that up.

	private Contact c;
	private User u;

	private String memberCategories;
	private String campaignString;
	private String relationshipTypes;

	public Boolean isInternalUser {get; set;}
	public Boolean isAuthorized;
	public Boolean hasAcceptedAgreement;
	public Boolean alreadyHasPermissionSet;

	public String feedbackMessage {get; set;}
	public Boolean feedbackSubmitted {get; set;}

	public String secureCOVURL {get; set;}

	public cov_gateway_controller() {
		System.debug('in cov_gateway_controller() constructor and u: ' + u);
        if (u == null) { u = cov_user_utility.self.getU(); }
        if (c == null) { c = cov_user_utility.self.getC(); }
        // TODO:  c can be null if theres no corresponding contact  

		IAVAPlus_Portal_Settings__c ps = IAVAPlus_Portal_Settings__c.getInstance('IAVA');
		if (ps != null) {
			secureCOVURL = ps.Secure_COV_URL__c;
		}

		System.debug('exiting cov_gateway_controller() constructor and u: ' + u);
	}

	public cov_gateway_controller(User theU) {
		System.debug('in cov_gateway_controller(User theU) constructor and theU: ' + theU);
		u = theU;
		if (c == null  && u != null) { c = cov_user_contact_utility.getContactFromUser(theU); }
        // TODO:  c can be null if theres no corresponding contact  
		System.debug('exiting cov_gateway_controller(User u) constructor and u: ' + u);
	}

	public cov_gateway_controller(Contact theC) {
		System.debug('in cov_gateway_controller(Contact theC) constructor and theC: ' + theC);
		//if (u == null) { u = theU; }
		c = theC;
		u = cov_user_contact_utility.getUserFromContact(c, new List<String>{'Profile.UserType'});
        // TODO:  c can be null if theres no corresponding contact  
		System.debug('exiting cov_gateway_controller(User theU) constructor and u: ' + u);
	}


	private User getU() {
        //if (u == null) { 
        //	return cov_user_utility.self.getU();
        //} else {
        //	return u;
        //}		
        System.debug('getting u.  before u: ' + u);
        return (u == null) ? cov_user_utility.self.getU() : u;

        // TODO -- doesnt really work to use self if the constructor has been invoked with a user argument
	} 

	private Contact getC() {
        //if (c == null) { 
        //	return cov_user_utility.self.getC();
        //} else {
        //	return c;
        //}		
//        return (c == null) ? cov_user_utility.self.getC() : c;
		return c;
	} 

	public Boolean getIsAuthorized() {
		if (isAuthorized == null) {
			return isAuthorizedToGainAccess();
		} else {
			return isAuthorized;
		}
	}

	public Boolean getHasAcceptedAgreement() {
		System.debug('in getHasAcceptedAgreement and u: ' + u);
		return (u.Date_of_COV_Terms_and_Conduct_Acceptance__c != null);
	}

	public Boolean getAlreadyHasPermissionSet() {
		System.debug('in getAlreadyHasPermissionSet() and u.Id=' + u.Id + ' and alreadyHasPermissionSet: ' + alreadyHasPermissionSet);
		if (alreadyHasPermissionSet == null) {
			return checkIfAlreadyHasPermissionSet();
		} else {
			return alreadyHasPermissionSet;
		}
	}

	// no longer needed, not redirecting from the unauth page
	//public static Boolean redirectToGateway() {
	//	// method run from SignIn (unauthorized) page if the user is trying to access a COV page without access
	//	System.debug('Starting redirectToGateway().');
	//	cov_gateway_controller gateway = new cov_gateway_controller();
	//	System.debug('gateway initialized: ' + gateway);
	//	if (
	//		(gateway.getAlreadyHasPermissionSet() && !gateway.getHasAcceptedAgreement())
	//		|| isAuthorizedToGainAccess()
	//		) {
	//		System.debug('In redirectToGateway() and returning true.');
	//		return true;
	//	} else {
	//		System.debug('In redirectToGateway() and returning false.');
	//		return false;
	//	}
	//	System.debug('End of redirectToGateway()');
	//	return false;
	//} 

	public static Boolean alreadyHasPermissionSet() {
		// FOR THE MAIN COV ACCESS PERMISSION SET
		cov_gateway_controller gateway = new cov_gateway_controller();
		return gateway.checkIfAlreadyHasPermissionSet();
	}

	public static Boolean alreadyHasPermissionSet(User theU) {
		// FOR THE MAIN COV ACCESS PERMISSION SET
		cov_gateway_controller gateway = new cov_gateway_controller(theU);
		return gateway.checkIfAlreadyHasPermissionSet();
	}

	public Boolean checkIfAlreadyHasPermissionSet() {
		return checkIfAlreadyHasPermissionSet('COV Access', true); // DEFAULT
	}


	public static Boolean alreadyHasPermissionSet(String prefixIn) {
		// FOR AN ALTERNATE PERMISSION SET
		cov_gateway_controller gateway = new cov_gateway_controller();
		return gateway.checkIfAlreadyHasPermissionSet(prefixIn, false);
	}

	public static Boolean alreadyHasPermissionSet(User theU, String prefixIn) {
		// FOR AN ALTERNATE PERMISSION SET
		cov_gateway_controller gateway = new cov_gateway_controller(theU);
		return gateway.checkIfAlreadyHasPermissionSet(prefixIn, false);
	}

	public static Boolean alreadyHasPermissionSet(Contact theC) {
		return alreadyHasPermissionSet(theC, 'COV Access');
	}

	public static Boolean alreadyHasPermissionSet(Contact theC, String prefixIn) {
		// FOR AN ALTERNATE PERMISSION SET
		cov_gateway_controller gateway = new cov_gateway_controller(theC);
		if (gateway.u == null) {
			return false;
		} else {
			return gateway.checkIfAlreadyHasPermissionSet(prefixIn, false);
		}
	}



	public Boolean checkIfAlreadyHasPermissionSet(String pSetPrefix, Boolean mainPermissionSet) {
			//String pSetPrefix = 'COV Access'; //DEFAULT
			
			if (mainPermissionSet) {
				List<COV_Access_Profile_Settings__c> theSettings = COV_Access_Profile_Settings__c.getAll().values();
		 		if (theSettings.size() > 0) {
		 			if (theSettings[0].Prefix_for_COV_Access_Permission_Sets__c != null) {
						pSetPrefix = theSettings[0].Prefix_for_COV_Access_Permission_Sets__c;
					}
				}
			}

			pSetPrefix += '%';
			try {
				PermissionSetAssignment psa = [select Id from PermissionSetAssignment 
					where PermissionSet.Label like :pSetPrefix 
					and AssigneeId = :u.Id
					limit 1
					];
					//and PermissionSet.UserLicenseId = :u.Profile.UserLicenseId
				System.debug('User already has PermissionSet for access: ' + psa);
				return true;
			} catch (Exception e) {
				System.debug('User doesn\'t have PermissionSet for access');
				return false;
			}

	} 	

	public static Boolean isAuthorizedToGainAccess() {
		cov_gateway_controller gateway = new cov_gateway_controller();
		return gateway.checkIfAuthorizedToGainAccess();
	}

	public static Boolean isAuthorizedToGainAccess(User theU) {
		cov_gateway_controller gateway = new cov_gateway_controller(theU);
		return gateway.checkIfAuthorizedToGainAccess();
	}

	public static Boolean isAuthorizedToGainAccess(Contact theC) {
		cov_gateway_controller gateway = new cov_gateway_controller(theC);
		return gateway.checkIfAuthorizedToGainAccess();
	}

	public Boolean checkIfAuthorizedToGainAccess() {

        if (u!= null) {
	        System.debug('u.Profile.UserType: ' + u.Profile.UserType);
	        isInternalUser = (u.Profile.UserType == 'Standard');
	    }

		List<COV_Access_Profile_Settings__c> theSettings = COV_Access_Profile_Settings__c.getAll().values();
		System.debug('theSettings: ' + theSettings);

 		if (theSettings.size() > 0) {
			memberCategories = theSettings[0].Authorized_member_categories__c;
			campaignString = theSettings[0].Allow_members_of_Campaign__c;
			relationshipTypes = theSettings[0].Allowed_relationship_types_to_COVuser__c;
		}

		return 
			(c != null) && 
				(
					allowedToSwitchViaMemberCategories(c)
					||
					allowedToSwitchViaCampaign(c)
					||
					allowedToSwitchViaRelationship(c)
				)
			;

	}

	private Boolean allowedToSwitchViaMemberCategories(Contact c) {
		if (memberCategories == null || memberCategories == '') {
			System.debug('Member Categories was blank in the COV Access Profile custom setting');
			return false;
		} else {
System.debug('c.Member_Categories__c: ' + c.Member_Categories__c);
			if (c.Member_Categories__c == null || c.Member_Categories__c == '') {
				System.debug('Contact Member Categories was blank');
				return false;
			} else {
				List<String> contactMemberCatsList = c.Member_Categories__c.split(';', 0);
				for (String s : contactMemberCatsList) {
					if (s != null && s != '' && memberCategories.contains(s.trim())) {
						System.debug('Member Category \'' + s + '\' matches, user\'s contact is authorized gain access to community');
						return true;
					}
				}
				System.debug('Member Category did not match, user\'s contact is not authorized via Member Category to gain access to community');
				return false;
			}
		}
	}

	private Boolean allowedToSwitchViaCampaign(Contact c) {

		if (campaignString == null || campaignString == '') {
			System.debug('Authorized Campaign was blank in the COV Access Profile custom setting');
			return false;
		} else {
			Campaign authorizedCampaign;
			try {
				authorizedCampaign = [select Id from Campaign where Id=:campaignString or Name=:campaignString limit 1];
			} catch (Exception e) {
				System.debug('No campaign found matching the value specified in the COV Access Profile custom setting');
				return false;
			}
			try {
				CampaignMember cm = [select Id from CampaignMember where CampaignId = :authorizedCampaign.Id and ContactId = :c.Id limit 1];
				System.debug('Yes, the contact is part of the campaign that authorizes access to switch profiles.');
				return true;
			} catch (Exception e) {
				System.debug('No, the contact is not part of the campaign that authorizes access to switch profiles.');
				return false;
			}
		}

	}		

	private Boolean allowedToSwitchViaRelationship(Contact c) {
		if (relationshipTypes == null || relationshipTypes == '') {
			System.debug('Relationship Types was blank in the COV Access Profile custom setting');
			return false;
		} else {
			List<String> relTypesList = relationshipTypes.split(';', 0);

			// TODO:  use a Set of IDs and where contactID in :IDSET
			Set<String> relTypes = new set<String>();
			for (String s : relTypesList) {
				if (s != null && s.trim() != '') {
					relTypes.add(s.trim());
				}
			}
			System.debug('relationshipTypes: ' + relationshipTypes);
			System.debug('relTypes: ' + relTypes);
			List<npe4__Relationship__c> relatedContacts = new List<npe4__Relationship__c>();
			try {
				relatedContacts = [Select Id, npe4__RelatedContact__r.Portal_User__c from npe4__Relationship__c where npe4__Contact__c = :c.Id and npe4__Type__c in :relTypes];
			} catch (Exception e) { }
			
			if (relatedContacts.size() > 0) {
				System.debug('Found relationships of the specified type, have to check whether the related Contacts have access: ' + relatedContacts);
			} else {
				System.debug('No relationships were returned by the query');
				return false;
			}


			Set<Id> contactIds = new set<Id>();
			for (npe4__Relationship__c r : relatedContacts) {
				contactIds.add(r.npe4__RelatedContact__r.Portal_User__c);
			}
			try {
				List<NetworkMember> nms = [Select Id from NetworkMember where NetworkId = :cov_user_utility.self.getNetworkId() and MemberId in :contactIds];
				System.debug('Found at least one user with relationship to current user who is a networkMember: ' + nms);
				return true;
			} catch (Exception e) {
				System.debug('No networkMembers with relationships to user');
				return false;
			}
		}
	}

	// future methods to avoid MIXED_DML error when permset doesnt need
	// to be added synchronously
	public static void addCOVPermissionSetFutureMethod(Id userId) {
		Set<Id> uSet = new Set<Id>{userId};
		addCOVPermissionSetFutureMethod(uSet);
	}

	@future
	public static void addCOVPermissionSetFutureMethod(Set<Id> idSet) {
		List<User> uList = [select Id, Profile.UserLicenseId from User where Id in :idSet];
		Boolean b = addCOVPermissionSet(uList);
	}

	public static Boolean addCOVPermissionSet(User theU) {
		List<User> uList = new List<User>();
		uList.add(theU);
		return addCOVPermissionSet(uList);
	}


	public static Boolean addCOVPermissionSet(List<User> userList) {

		// made this a bulk method so it can be used by the trigger that provisions portal users


		String pSetPrefix = 'COV Access';
		List<COV_Access_Profile_Settings__c> theSettings = COV_Access_Profile_Settings__c.getAll().values();
 		if (theSettings.size() > 0) {
 			if (theSettings[0].Prefix_for_COV_Access_Permission_Sets__c != null) {
				pSetPrefix = theSettings[0].Prefix_for_COV_Access_Permission_Sets__c;
			}
		}


		Set<Id> licenseIdsFromUsers = new Set<Id>();
		//Map<Id, PermissionSet> userToPermsetMap = new Map<Id, PermissionSet>();

		for (User userFromList : userList) {
			licenseIdsFromUsers.add(userFromList.Profile.UserLicenseId);
		}

		//if (!alreadyHasPermissionSet(theU, pSetPrefix)) {

		List<PermissionSet> pSets;
		pSetPrefix += '%';
		pSets = [select Id, UserLicenseId from PermissionSet where Label like :pSetPrefix and (UserLicenseId in :licenseIdsFromUsers or UserLicenseId = null)];
		//Set<Id> licenseIdsFromPermsetsFound = (new Map<Id,PermissionSet>(pSets)).keySet();
		Map<Id, Id> userlicenseToPermsetMap = new Map<Id, Id>();
		for (PermissionSet pSet : pSets) {
			if (!userlicenseToPermsetMap.containsKey(pSet.UserLicenseId)) {
				userlicenseToPermsetMap.put(pSet.UserLicenseId, pSet.Id);
			}
		}

		List<PermissionSetAssignment> psaList = new List<PermissionSetAssignment>();
		for (User userFromList : userList) {
			if (userlicenseToPermsetMap.containsKey(userFromList.Profile.UserLicenseId)) {
				psaList.add(new PermissionSetAssignment(PermissionSetId=userlicenseToPermsetMap.get(userFromList.Profile.UserLicenseId), AssigneeId=userFromList.Id));
			} else if (userlicenseToPermsetMap.containsKey(null)) {
				psaList.add(new PermissionSetAssignment(PermissionSetId=userlicenseToPermsetMap.get(null), AssigneeId=userFromList.Id));
			}
		}

		Boolean noErrorsSoFar = true;

		//Database.SaveResult[] srs = database.insert(psaList, false);
		// avoid MixedDML error on unit test by using system.runas to set new context
		Database.SaveResult[] srs;
		if (Test.isRunningTest()) {
			System.runAs ( new User(Id = Userinfo.getUserId()) ) {
				srs = cov_nosharing_utilities.runDatabaseInsert(psaList, false);
			}
		} else {
			srs = cov_nosharing_utilities.runDatabaseInsert(psaList, false);
		}
		if (srs.size() == 0) {
			noErrorsSoFar = false;
		}
		for (Database.SaveResult sr : srs) {
	        if (sr.isSuccess()) {
		        // Operation was successful, so get the ID of the record that was processed
		        System.debug('Successfully inserted permsetassignment. psa ID: ' + sr.getId());
		    } else {
		        // Operation failed, so get all errors   
		        Integer errorCount = 0; 
		        String errorFields = '';            
		        String errorMessages = ''; 
		        String errorStatusCodes = '';           
		        for(Database.Error err : sr.getErrors()) {
		        	if (err.getStatusCode() != StatusCode.DUPLICATE_VALUE) { // if trying to add a duplicate permset assignment, no big whoop, ignore error
			        	errorCount++;
			            System.debug('The following error has occurred.');                    
			            System.debug(err.getStatusCode() + ': ' + err.getMessage());
			            System.debug('PermissionSetAssignment fields that affected this error: ' + err.getFields());
			            errorFields += err.getFields() + '/';
			            errorMessages += err.getMessage() + '/';
			            errorStatusCodes += err.getStatusCode() + '/';
			        }
		        }
		        if (errorCount > 0) {
			    	noErrorsSoFar = false;
			        if (userList.size() == 1 && !Trigger.isExecuting) {
			            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Sorry there was an error joining myIAVA. Please let us know at community@iava.org so we can look into it.')); 
				    }
			        cov_log_error.logDevMsg(errorCount + ' error(s) trying to insert PermissionSetAssignment(s). ' + (userList.size() == 1 ? 'uId: ' + userList[0].Id : userList.size() + ' users') + ' errorStatusCodes: ' + errorStatusCodes + ' and errorMessages: ' + errorMessages + ' and fields: ' + errorFields);
			    }
		    }
		}

	    return noErrorsSoFar;


			//PermissionSet pSet;
			//pSetPrefix += '%';
			//try {
			//	pSet = [select Id from PermissionSet where Label like :pSetPrefix and UserLicenseId = :theU.Profile.UserLicenseId limit 1];
			//	System.debug('Found PermissionSet for this user\'s license type with prefix: ' + pSetPrefix);
			//} catch (Exception e) {
			//	System.debug('Error finding the PermissionSet for this user\'s license type with prefix: ' + pSetPrefix);
			//}
			//if (pset == null) {
			//	try {
			//		pSet = [select Id from PermissionSet where Label like :pSetPrefix and UserLicenseId = null limit 1];
			//		System.debug('Found PermissionSet with null user license type and prefix: ' + pSetPrefix);
			//	} catch (Exception e) {
			//		System.debug('Error finding the PermissionSet for null user license with prefix: ' + pSetPrefix);
			//		if (!Trigger.isExecuting) {
			//            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Sorry there was an error joining COV. Please let us know at covdev@iava.org so we can look into it.')); 
			//        }
			//		cov_log_error.logError(e);
			//		return null;				
			//	}
			//}

			//try {
			//	insert new PermissionSetAssignment(PermissionSetId=pSet.Id, AssigneeId=theU.Id);
			//	System.debug('Just added this user to the permission set for access to the community');
			//	return true;
			//} catch (Exception e) {
				//System.debug('Error inserting the PermissionSet record to grant access to COV');
				//if (!Trigger.isExecuting) {
		  //          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Sorry there was an error joining COV. Please let us know at covdev@iava.org so we can look into it.')); 
		  //      }
				//cov_log_error.logError(e);
				//return null;				
			//}
		//} else {
		//	return true;
		//}

	}


	public PageReference accept() {

		//u = cov_user_utility.self.freshSelf().getU(); // refresh the user since it now has a new profile on it
		u.Date_of_COV_Terms_and_Conduct_Acceptance__c = datetime.now();
		if (u.Profile.UserType != 'Standard') {
			u.UserPermissionsChatterAnswersUser = true; // in case Chatter Answers User not already checked on User record.
		}
		try {
			update u;
			System.debug('Updated the user to include Date of COV Terms and Conduct Acceptance.');
		} catch (Exception e) {
			System.debug('Error updating the user to include Date of COV Terms and Conduct Acceptance: ' + u);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Sorry there was an error joining COV. Please let us know at covdev@iava.org so we can look into it.')); 
			cov_log_error.logError(e);
			return null;
		}

		Boolean addPerms = addCOVPermissionSet(u);
		if (addPerms ==  null || !addPerms) {
			return null;
		} else {
			String startURL = ApexPages.currentPage().getParameters().get('startURL');
			if (startURL != null && startURL != '') {
				return new PageReference(startURL);
			} else {
				return Page.cov_dashboard;
			}
		}

	}

	// This was from when was attempting to switch the profile instead of using a permission set.
	//
	//public PageReference switchProfile(Id profileID) {
	//	// method adapted from Ian Zepp's youtube: http://www.youtube.com/watch?v=a2fJWeJscps
	//	String remoteURL = Site.getBaseUrl() + '/cov_switchprofile?p=' + profileID + '&u=' + u.Id;

	//	// Try the outbound call
	//	HttpRequest httpRequest = new HttpRequest();
	//	httpRequest.setMethod('GET');
	//	httpRequest.setEndpoint(remoteURL);

	//	// Run it - here is where the switch happens
	//	HttpResponse httpresponse = new Http().send(httpRequest);

	//	System.debug('remoteURL: ' + remoteURL);
	//	System.debug('httpresponse.getBody(): ' + httpresponse.getBody());

	//	return Page.cov_dashboard;
	//}

	public PageReference feedbackSave() {
		feedbackMessage = 'Request for COV Access: ' + feedbackMessage;
		feedbackSubmitted = cov_feedback_controller.insertFeedback(feedbackMessage, -1, ApexPages.currentPage().getHeaders().get('Host') + '/cov_gateway');
		return null;
	}



	
}