public without sharing class cov_vouching_controller {

	public String theConId;
//	public List<String[]> vouchees1;
	public Integer numVouchees {get; set;}
	public List<customVouchee> vouchees;

	public String vcfirst {get; set;}
	public String vclast {get; set;}
	public String vcemail {get; set;}
	public String vcmsg {get; set;}
	public Boolean vcOEF {get; set;}
	public Boolean vcOIF {get; set;}
	public Boolean vcOND {get; set;}
	public Boolean vcserved {get; set;}
	
    public Boolean hasVouchees;

    public Boolean isMobile {get; set;}
    public Boolean isConfirmed {get; set;}
    public Boolean isUnconfirmed {get; set;}


		public cov_vouching_controller() {
			System.debug('in the constructor');
			isMobile = cov_user_utility.self.getIsMobile();
			isConfirmed = cov_user_utility.self.getIsConfirmed();
			isUnconfirmed = cov_user_utility.self.getIsMemberVeteran() && !cov_user_utility.self.getIsConfirmed();
		}
		
		public Boolean getHasVouchees() {
			System.debug('getting hasVouchees');
			if (vouchees == null) {
				System.debug('vouchees was null');
				vouchees = getVouchees();
			} else {
				System.debug('vouchees was not null');
			}
			return hasVouchees;
		}

		public String getTheConId() {
			return cov_user_utility.self.getCId();
		}
		
		public class customVouchee {
			private npe4__Relationship__c theRel;
			public Boolean displayFollowTag {get; private set; }
			public Boolean inNetwork {get; private set; }

			public customVouchee(npe4__Relationship__c item) {
            	this.theRel = item;

				// Keep track of which chatter follow tags have been
				// displayed so as not to trigger a VF error by
				// displaying one for the same entity twice
            	displayFollowTag = cov_user_utility.self.displayFollowTagChecker(cvId);
            	System.debug('customvouchee displayFollowTag: ' + displayFollowTag);
        	}
			
			public Id cvId {
				get { 
					if (theRel.npe4__RelatedContact__r.Portal_User__c != null) {
						return theRel.npe4__RelatedContact__r.Portal_User__c;
	      			} else {
	      				return null;
		      		}
				}
			}
			public String first {
				get { return theRel.npe4__RelatedContact__r.FirstName; }
			}
			public String last {
				get { return theRel.npe4__RelatedContact__r.LastName; }
			}
			public String smallPhotoUrl {
				get { return theRel.npe4__RelatedContact__r.Portal_User__r.SmallPhotoUrl; }
			}
			public String fullPhotoUrl {
				get { return theRel.npe4__RelatedContact__r.Portal_User__r.FullPhotoUrl; }
			}
			public String status {
				get { return theRel.Vouchee_public_status__c; }				
			}
			public DateTime createdate {
				get { return theRel.CreatedDate; }				
			}
			
		}
		
		public List<customVouchee> getVouchees() {
			
			if (theConId == null || theConId == '') {
//					User u = [Select u.Id,u.ContactId,u.Contact.MailingPostalCode, u.SmallPhotoUrl,u.FullPhotoUrl
//						 from User u where isActive=true and u.Id = :UserInfo.getUserId()];
					User u = cov_user_utility.self.getU();
					//if (u.ContactId != null) {
					//	theConId = u.ContactId;
					//} else {
						theConId = cov_user_utility.self.getC().Id;
					//}
				}
				System.debug('theConId: ' + theConId);
				
			System.debug('vouchees before: ' + vouchees);
			// use a Set for deduping list so <chatter:follow> tag doesn't bonk on dupe
			Set<Id> relUserSet = new Set<Id>();
	        if(vouchees == null) {
	            vouchees = new List<customVouchee>();
	            for(npe4__Relationship__c item : 
	            	[select CreatedDate
	     			, Vouchee_public_status__c
	      			, Peer_Invite_Message__c
	      			, Vouched_Served_Together__c
	            	, npe4__RelatedContact__r.Portal_User__c
	      			, npe4__RelatedContact__r.Portal_User__r.SmallPhotoUrl
	      			, npe4__RelatedContact__r.Portal_User__r.FullPhotoUrl
	      			, npe4__RelatedContact__r.FirstName
	      			, npe4__RelatedContact__r.LastName
	      			from npe4__Relationship__c 
					where npe4__Contact__c=:theConId and npe4__Type__c='Vouched for'
					order by CreatedDate DESC
					]) {
//						if (item.npe4__RelatedContact__r.Portal_User__c == null || relUserSet.add(item.npe4__RelatedContact__r.Portal_User__c)) {  // will be true if Id is not a duplicate
//						if (item.npe4__RelatedContact__r.Portal_User__c == null ) { 
	                		vouchees.add(new customVouchee(item));
//						}
	            	}
	        }

	        // Check to make sure vouchees are still in the network before displaying link and follow tag
	        Set<Id> userIds = new Set<Id>();
//	        Map<Id, customVouchee> cvMap = new Map<Id, customVouchee>();
	        for (customVouchee cv : vouchees) {
	        	if (cv.cvId != null) {
//	        		cvMap.add(cv.cvId, cv)
	        		userIds.add(cv.cvId);
	        	}
	        }
	        Set<Id> inNetworkUsers = new Set<Id>();
	        List<User> users = [select Id from User where isActive = true AND Id in (SELECT MemberId FROM NetworkMember where MemberId in :userIds AND NetworkId = :cov_user_utility.self.getNetworkId())];
	        for (User u : users) {
	        	inNetworkUsers.add(u.Id);
	        }
	        for (customVouchee cv : vouchees) {
	        	if (inNetworkUsers.contains(cv.cvId)) {
	        		cv.inNetwork = true;
	        	} else {
	        		cv.inNetwork = false;
	        	}
	        }



			System.debug(vouchees.size() + ' vouchees after: ' + vouchees);
			numVouchees = vouchees.size();
			if (numVouchees > 0) {
				hasVouchees = true;
			} else {
				hasVouchees = false;
			}
	        System.debug('hasVouchees: ' + hasVouchees);

	        return vouchees;
	    }
		
/*
//		The original method which passed an array of strings to the page instead of a custom class

	    public List<String[]> getVouchees1() {
      		
				if (theConId == null || theConId == '') {
					User u = [Select u.Id,u.ContactId,u.Contact.MailingPostalCode, u.SmallPhotoUrl,u.FullPhotoUrl
						 from User u where isActive=true and u.Id = :UserInfo.getUserId()];
					if (u.ContactId != null) {
						theConId = u.ContactId;
					} else {
						// find another contact record that points to this user (for staff users)
						try {
							Contact c;
							System.debug('UserInfo.getUserId(): ' + UserInfo.getUserId());
							c = [select Id
									, Portal_User__c
									from Contact
									where Portal_User__c = :UserInfo.getUserId()
									limit 1
									];
							theConId = c.Id;
						} catch(QueryException e){
							System.debug('e: ' + e);
						}
					}
				}
				System.debug('theConId: ' + theConId);
      		
      		List<npe4__Relationship__c> voucheesList = 
      		[select Vouchee_public_status__c, CreatedDate
      			, npe4__RelatedContact__r.Portal_User__r.SmallPhotoUrl
      			, npe4__RelatedContact__r.Portal_User__r.FullPhotoUrl
      			, npe4__RelatedContact__r.FirstName
      			, npe4__RelatedContact__r.LastName
      			, npe4__Relationship__c.Peer_Invite_Message__c
      			, npe4__Relationship__c.Vouched_Served_Together__c
      			from npe4__Relationship__c 
				where npe4__Contact__c=:theConId and npe4__Type__c='Vouched for'
				order by CreatedDate DESC
				];
				
			numVouchees = voucheesList.size();
			if (numVouchees > 0) {
				hasVouchees = true;
			} else {
				hasVouchees = false;
			}
	      	
	      	List<String[]> returnValues = new List<String[]>();	
	      	
	      	for (npe4__Relationship__c rel : voucheesList) {

	      		String[] newString = new List<String>();
	      		if (rel.npe4__RelatedContact__r.Portal_User__c != null) {
	      			newString.add((String)(rel.npe4__RelatedContact__r.Portal_User__c));
	      		} else {
	      			newString.add('_none');
	      			//replace null with '' to avoid visualforce error
	      		}
	      		newString.add(rel.npe4__RelatedContact__r.FirstName);
	      		newString.add(rel.npe4__RelatedContact__r.LastName);
	      		newString.add(rel.Vouchee_public_status__c);
	      		newString.add(String.valueOf(rel.CreatedDate.format('M/d/yyyy')));
	      		newString.add(rel.npe4__RelatedContact__r.Portal_User__r.SmallPhotoUrl);
	      		returnValues.add(newString);
	      			      		
	      	}
	      	System.debug(returnValues);
			return returnValues;  
	      				
	      				
	    }  
*/		

		@RemoteAction
    	public static String newRemoteVouchee() {
    		PageReference pr = new cov_vouching_controller().newVouchee();
    		if (pr != null) {
    			return 'hello';
    		} else {
    			return 'nully';
    		}
    	}

		public PageReference newVouchee(){
	    	System.debug(vcfirst + ' ' + vclast + ' ' + vcemail);
			Contact voucheeCon;
			Contact existingCon;
			
			// cant figure out how to allow plus sign in email so only checking if no plus sign
			//if(!vcemail.contains('+') && !Pattern.matches('[a-zA-Z0-9._-]+@[a-zA-Z]+.[a-zA-Z]{2,4}', vcemail)) {
			if (!cov_utilities.validateEmail(vcemail)) {				
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Invalid email address')); 
	            return null;
	        }
	        
	        if (vcemail == cov_user_utility.self.getC().Email) {
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'You can\'t vouch for yourself, silly. Jeez.')); 
	            return null;
	        }
	        
			if (vcfirst == '' && vclast == '') {
	            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter the person\'s name.')); 
	            return null;				
			}

	        if (vclast == '') {
	        	vclast = '(Unknown)';
	        }

	        if (vcserved == null) {
	        	vcserved = false;
	        }
	        
			if (theConId == null) {
				theConId = cov_user_utility.self.getCId();
			}

			npe4__Relationship__c existingRelationship;
	        try {
	        		existingRelationship = [select Id from npe4__Relationship__c where
	        		npe4__Contact__c = :theConId 
	        		and npe4__Type__c = 'Vouched for' 
	        		and (
	        			npe4__RelatedContact__r.Email = :vcemail
	        			or npe4__RelatedContact__r.npe01__HomeEmail__c = :vcemail
	        			or npe4__RelatedContact__r.npe01__WorkEmail__c = :vcemail
	        			or npe4__RelatedContact__r.npe01__AlternateEmail__c = :vcemail
	        			)
	        		limit 1];
	        } catch(QueryException e){}
	        if (existingRelationship != null) {
					String userMsg = 'Whoops, looks like you already vouched for someone with that email address. Check the list below.';
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, userMsg);
					ApexPages.addMessage(myMsg);
					return null;
	        }
	        
			
			Boolean addAFollow = false;
			try {
				existingCon = [select Id, Email, FirstName, LastName
					, Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, Portal_User__c
					from Contact where Email = :vcemail limit 1];
			} catch(QueryException e){}
			if (existingCon == null) {
				voucheeCon = new Contact(
					FirstName=vcfirst
					, LastName=vclast
					, Email=vcemail
					, Veteran_Member__c = true
					, Veteran_of_OEF__c = vcOEF
					, Veteran_of_OIF__c = vcOIF
					, Veteran_of_OND__c = vcOND
					, No_Email_Blasts__c = true
				);

				// Pre-insert account if it's a portal user as a workaround to NPSP issue
				// where NPSP3 accounts trigger which cant insert an account
				// with a portal user as owner. So instead first create the account before inserting contact
				// If issue gets fixed by NPSP then can remove this code (and part 2 a few lines below).
				Account a = cov_npsp_workaround.preInsertAdminOwnedAccount(voucheeCon, true);
				if (a != null && a.Id != null) {
					voucheeCon.AccountId = a.Id;
				}
				try {
					insert voucheeCon;	

					// Part 2 of the NPSP account workaround referenced above
					if (a != null && a.npe01__One2OneContact__c == null) {
						cov_npsp_workaround.postUpdateAccountOne2OneContact(a, voucheeCon);
					}
				} catch (DMLException e) { 
					cov_log_error.logError(e); 
				}
			} else {
				voucheeCon = existingCon;
				if (existingCon.Portal_User__c != null) {
					addAFollow = true;					
				}
			}

	    	npe4__Relationship__c newRel = new npe4__Relationship__c(
	    		npe4__Contact__c = theConId
	    		, npe4__RelatedContact__c = voucheeCon.Id
	    		, npe4__Status__c = 'Current'
	    		, npe4__Type__c = 'Vouched for'
	    		, Vouched_Served_Together__c = vcserved
	    	);
			System.debug('7 pre-insert newRel: ' + newRel);
			try {
				insert newRel;
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'Thank you, your vouch was recorded.')); 
			} catch (DMLException e) { 
				if (e.getMessage().contains('DUPLICATE_VALUE')) {
					String userMsg = 'Whoops, looks like you already vouched for someone with that email address. Check the list below.';
					ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, userMsg);
					ApexPages.addMessage(myMsg);
					return null;
				} else {
					cov_log_error.logError(e); 
				}
			}
			System.debug('7 post-insert newRel: ' + newRel);
			System.debug('UserInfo.getUserType() inside vouching controller: ' + UserInfo.getUserType());
			
			// A portal user doesn't have permissions for the reciprocal relationship trigger to run
			// so we have to manually insert the reciprocal relationship
			// April 2016 - This code no longer necessary with NPSP3
			//if (UserInfo.getUserType() != 'Standard') {
			//	npe4__Relationship__c newRelRecip = new npe4__Relationship__c(
		 //   		npe4__Contact__c = voucheeCon.Id
		 //   		, npe4__RelatedContact__c = theConId
		 //   		, npe4__Status__c = 'Current'
		 //   		, npe4__Type__c = 'Vouched for by'
		 //   		, npe4__ReciprocalRelationship__c = newRel.id
		 //   		, Vouched_Served_Together__c = vcserved
		 //   		, Peer_Invite_Message__c = vcmsg
		 //   	);
			//	System.debug('8 newRelRecip: ' + newRelRecip);
			//	try {
			//		insert newRelRecip;
			//	} catch (DMLException e) { cov_log_error.logError(e); }
		 //   	newRel.npe4__ReciprocalRelationship__c = newRelRecip.id;
			//	System.debug('9 newRel: ' + newRel);
			//	try {
			//		update newRel;
			//	} catch (DMLException e) { cov_log_error.logError(e); }
			//}
			// now follow the user who you just vouched for if they already exist
			if (addAFollow) {
				System.debug('Adding a follow record for the vouchee');
				cov_autofollow_relationships.followOneRelationship(theConId, voucheeCon.id, new List<String>{'Vouched for'}, false);
			}
			return null;
    	}  


		public void followAllVoucheesOneWay() {
			System.debug('in followAllVoucheesOneWay and theConId: ' + theConId);
			cov_autofollow_relationships.followAllRelationships(theConId, new List<String>{'Vouched for'}, false);			
			System.debug('exiting followAllVoucheesOneWay');			
		}

		public void followAllVoucheesBothWays() {
			System.debug('in followAllVoucheesBothWays and theConId: ' + theConId);
			cov_autofollow_relationships.followAllRelationships(theConId, new List<String>{'Vouched for'}, true);			
			System.debug('exiting followAllVoucheesBothWays');			
		}




}