public without sharing class cov_profile_controller {
    // commented out lines 112, 226-234, 234-257 to circumvent isNotSsoUsable issue -- SPowell 2018-02-20

		public Boolean isOwnProfile {get; set;}
		public static String profileContactId;
		public Contact theC {get; set;}
		public User u {get; set;}
		public Id uId {get; set;}
		
		public String city {get; set;}
		public String state {get; set;}
		public String zip {get; set;}
		public String country {get; set;}

		public String aboutme;
		public String vetstory;
		private String aboutme_prev {get; set;}
		private String vetstory_prev {get; set;}
		public String twitterHandle {get; set;}
		public String instagramHandle {get; set;}
		private String twitter_prev {get; set;}
		private String instagram_prev {get; set;}

		
		public List<cov_customdeployment> deployments;
		
		public String dpIdChosen {get; set;}
		public Map<Id, Boolean> editmodes {get; set;}
		public Boolean ineditmode {get; set;}
		public Boolean didNotDeploy {get; set;}
		
		public String dpcity {get; set;}
		public String dpcountry {get; set;}
		public String dpothercountry {get; set;}
		public String dpstartdate {get; set;}
		public String dpenddate {get; set;}
		public String dpnotes {get; set;}
		public Boolean dpstoploss {get; set;}
		public String dpoperation {get; set;}
		public Boolean dpsurvivor {get; set;}
		
		public Boolean hasPhoto {get; set;}
		public Boolean hasAboutMe {get; set;}
		public Boolean hasServiceInfo {get; set;}
		public Boolean hasDeployments;
		public Integer numDeployments {get; set;}
		
		public Date dummyDateField {get; set;}
		public String saveMsgProfileInfo {get; set;}
		public String saveMsgTheC {get; set;}

		public Boolean hasUnreadMessages {get; set;}
		public Integer unreadMessageCount {get; set;}

		public Boolean isConfirmed {get; set;}
		public Boolean isMemberVeteran { get; set; }
		public Boolean isNonVeteran {get; set;}
		public Boolean askIfNonVeteran {
			get {
				return theC == null ? null : !theC.Veteran_of_OEF__c && !theC.Veteran_of_OIF__c 
											&& !theC.Veteran_of_OND__c && theC.Branch_of_Service__c == null;
			}
		}

		public Boolean isFacebookLinked {get; set;}

		public Boolean getFacebookLoginActive() {
		    IAVA_switches__c sw = IAVA_switches__c.getInstance('myIAVA_show_facebook_login');
		    return sw != null && !sw.Disable__c ? true : false;
		}


	    public Boolean isSandbox {
	        get {
	            return cov_user_utility.self.getIsSandbox();
	        }
	    }

	    public void populateVeteranFields() {
			isMemberVeteran = cov_user_utility.self.getIsMemberVeteran();
			isNonVeteran = cov_user_utility.self.getIsNonVeteran();
			isConfirmed = cov_user_utility.self.getIsConfirmed();
	    }
				

		public cov_profile_controller() {
			System.debug('Now in cov_profile_controller constructor');
			uId = ApexPages.currentPage().getParameters().get('sfdc.userId');
			if (uId == null) {
				uId = ApexPages.currentPage().getParameters().get('u');
			}
			if (uId == null) {
				uId = System.UserInfo.getUserId();			
			}
			System.debug('uId in profile controller: ' + uId);
			System.debug('System.UserInfo.getUserId(): ' + System.UserInfo.getUserId());
			isOwnProfile = (System.UserInfo.getUserId() == uId ? true : false);

			if (isOwnProfile) {
				u = cov_user_utility.self.getU();
				profileContactId = cov_user_utility.self.getCId();

				unreadMessageCount = ConnectApi.ChatterMessages.getUnreadCount(cov_user_utility.self.getNetworkId()).unreadCount;
				hasUnreadMessages = unreadMessageCount > 0 ? true : false;
				if (!Test.isRunningTest()) {
					// was causing strange error in test after inserting test users via cov_user_TEST_utility
					// error is System.UnexpectedException: A callout failed because an Apex operation 
					// has pending uncommitted work. The Apex code needs to commit or roll back before 
					// callouts can be performed in the same transaction.
					// of course this also means that the isFacebookLinked flag can't currently be tested via a unit test

					//isFacebookLinked = queryFacebookLink();
				}
			} else {
//				u = [Select Id, ContactId, Username, AboutMe, FullPhotoUrl, SmallPhotoUrl
//					 from User u where Id = :uId];
				u = getProfileUser(uId);

				if (u.ContactId != null) { 
					profileContactId = u.ContactId;
				} else {
					Contact profileContact = getProfileContact(uId);
					if (profileContact != null) { profileContactId = getProfileContact(uId).Id; }
				}
			}

			populateVeteranFields();			

			if (u.SmallPhotoUrl.right(5) == '005/T') {
				hasPhoto = false;
			} else {
				hasPhoto = true;
			}

			if (u.AboutMe == null || u.AboutMe == '') {
				hasAboutMe = false;
			} else {
				hasAboutMe = true;
			}
			
			theC = loadContact(profileContactId, uId);

			
			if(theC != null) {			
				city = theC.MailingCity;
				state = theC.MailingState;
				zip = theC.MailingPostalCode;
				country = theC.MailingCountry;
				didNotDeploy = theC.Did_Not_Deploy__c;
				
				if (
					(!theC.Veteran_of_OEF__c && !theC.Veteran_of_OIF__c && !theC.Veteran_of_OND__c)
					|| (theC.Branch_of_Service__c == null || theC.Branch_of_Service__c == '')
					) {
					hasServiceInfo = false;
				} else {
					hasServiceInfo = true;
				}

				twitterHandle = theC.Twitter_ID__c;
				// strip out leading @ if present
				twitterHandle = twitterHandle != null && twitterHandle.startsWith('@') ? twitterHandle.right(twitterHandle.length()-1) : twitterHandle;
				twitter_prev = twitterHandle;

				instagramHandle = theC.Instagram_ID__c;
				// strip out leading @ if present
				instagramHandle = instagramHandle != null && instagramHandle.startsWith('@') ? instagramHandle.right(instagramHandle.length()-1) : instagramHandle;
				instagram_prev = instagramHandle;
				
			}
			System.debug('theC: ' + theC);
			System.debug('didNotDeploy: ' + didNotDeploy);
		}

		private Contact loadContact(String profileContactIdIn, Id profileUserId) {
			// if there's a Contact on user record, get that one.  otherwise see if there's another contact
			// whose Portal User points to the user (e.g. a staff user)
			String whereClause = (profileContactIdIn != null) ? 'id = \'' + profileContactIdIn + '\'' : 'Portal_User__c = \'' + profileUserId + '\'';
			
			
			String q = 'select Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, Most_Recent_Unit__c' +
							', Branch_of_Service__c, Service_Type__c, Current_Status__c' +
							', Did_Not_Deploy__c' +
							', Veteran_Member__c' +
							', Twitter_ID__c, Instagram_ID__c' +
							', Email, Phone' +
							', MailingStreet, MailingCity, MailingState, MailingPostalCode, MailingCountry' +
							', My_Veteran_Story__c' +
							', Not_a_Veteran__c' +
							' from Contact' +
							' where ' + whereClause +
							' limit 1'
							;
			System.debug('query for contact: ' + q);
			
			Contact returnC;
			try {
				returnC = Database.query(q);
			} catch(QueryException e){
				system.debug(e);
			}
			return returnC;
		}


		public String getAboutme() {
			aboutme_prev = u.AboutMe;
			return u.AboutMe;
		}
		public void setAboutme(String s) {
			aboutme = s;
		}

		public String getVetStory() {
			if (theC != null) {
				vetstory_prev = theC.My_Veteran_Story__c;
				return theC.My_Veteran_Story__c;
			} else {
				return null;
			}
		}
		public void setVetStory(String s) {
			vetstory = s;
		}

/*		public Boolean queryFacebookLink() {
			List<ThirdPartyAccountLink> tpals = [select Id from ThirdPartyAccountLink where UserId = :uId and Provider = 'Facebook' and isNotSsoUsable = false];
			if (tpals.size() > 0) {
				return true;
			} else {
				return false;
			}
		}
*//*
		public PageReference deleteFacebookLink() {
			system.debug('1');
			List<ThirdPartyAccountLink> tpals = [select Id, SsoProviderId, SsoProviderName, RemoteIdentifier, UserId from ThirdPartyAccountLink where UserId = :uId and Provider = 'Facebook' and isNotSsoUsable = false];
			if (tpals.size() > 0) {
				system.debug('2');
				system.debug('uId: ' + uId);
				system.debug('tpals[0]: ' + tpals[0]);
				Auth.Authtoken.revokeAccess(tpals[0].SsoProviderId, tpals[0].SsoProviderName, tpals[0].UserId, tpals[0].RemoteIdentifier);
				system.debug('3');
				isFacebookLinked = queryFacebookLink();
				system.debug('4 - isFacebookLinked: ' + isFacebookLinked);
				if (isFacebookLinked) {
					system.debug('5');
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, there was an error unlinking your Facebook account. Please contact support for assistance.'));
				}
				return null;
			} else {
				system.debug('6');
				cov_log_error.logDevMsg('deleteFacebookLink called but no facebook link to delete.');
				return null;
			}
		}
*/
		public PageReference saveProfileInfo() {
			return saveProfileInfo(null);
		}

		public PageReference setAsNonVeteran() {
			return saveProfileInfo(true);
		}

		public PageReference unsetNonVeteranSetVeteran() {
			return saveProfileInfo(false);
		}

		public PageReference saveProfileInfo(Boolean notVeteranFlag) {
			saveMsgProfileInfo = null;
			Boolean updated = false;
			aboutme = String.isEmpty(aboutme) ? null : aboutme;
			if (!stringsAreExactlyTheSame(aboutme, aboutme_prev)) {
				System.debug('AboutMe is changed, updating user.');
				u.AboutMe = aboutme;
				try {
			        update u;
			        updated = true;
				} catch (DMLException e) { 
					cov_log_error.logError(e); 
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, there was an error and your About Me description was not saved.'));
				}				
			}

			vetstory = String.isEmpty(vetstory) ? null : vetstory;
			twitterHandle = String.isEmpty(twitterHandle) ? null : twitterHandle;
			instagramHandle = String.isEmpty(instagramHandle) ? null : instagramHandle;

			if(twitterHandle != null) {
				twitterHandle = twitterHandle.trim();
				twitterHandle = twitterHandle.replace('http://twitter.com/', '').replace('https://twitter.com/', '').replace('twitter.com/', '');
				twitterHandle = twitterHandle.toLowerCase().startsWith('@') ? twitterHandle.right(twitterHandle.length()-1) : twitterHandle;
			}
			if(instagramHandle != null) {
				instagramHandle = instagramHandle.trim();
				instagramHandle = instagramHandle.toLowerCase().startsWith('@') ? instagramHandle.right(instagramHandle.length()-1) : instagramHandle;
				instagramHandle = instagramHandle.replace('http://instagram.com/', '').replace('https://instagram.com/', '').replace('instagram.com/', '');
			}

			system.debug('twitterHandle: ' + twitterHandle);
			system.debug('twitter_prev: ' + twitter_prev);
			if (theC != null &&
					(
					!stringsAreExactlyTheSame(vetstory, vetstory_prev)
					||
					!stringsAreExactlyTheSame(twitterHandle, twitter_prev)
					||
					!stringsAreExactlyTheSame(instagramHandle, instagram_prev)
					||
					notVeteranFlag != null
					)
				) {
				theC.My_Veteran_Story__c = vetstory;
				theC.Twitter_ID__c = twitterHandle;
				theC.Instagram_ID__c = instagramHandle;
				if (notVeteranFlag != null) {
					theC.Not_a_Veteran__c = notVeteranFlag;
					if (notVeteranFlag == false) {
						theC.Veteran_Member__c = true;
					}
				}

				System.debug('Contact field(s) have changed, updating contact.');
				try {
			        update theC;
			        updated = true;
			        theC = loadContact(profileContactId, uId); // in case workflow changed veteran fields
			        populateVeteranFields(); // in case NonVeteran flag was updated
				} catch (DMLException e) { 
					cov_log_error.logError(e); 
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, there was an error and any changes to your Veteran Story or social media handles were not saved.'));
				}
			}
			if (updated) {
		        saveMsgProfileInfo = 'Saved.';
			} else {
				saveMsgProfileInfo = 'Nothing saved.';
			}

			return null;
		}

		
	    public PageReference saveTheC() {
	    	saveMsgTheC = 'Not saved.';

	    	System.debug('city: ' + city);
			theC.MailingCity = city;
			theC.MailingState = state;
			theC.MailingPostalCode = zip;
			theC.MailingCountry = country;
			try {
		        update theC;
		        saveMsgTheC = 'Saved.';
			} catch (DMLException e) { cov_log_error.logError(e); }
	        return null;
	    }

	    public PageReference saveTheU() {
			try {
		        update u;
			} catch (DMLException e) { cov_log_error.logError(e); }
	        return null;
	    }

	private User getProfileUser(Id userId) {
		User theU;
		try {
				theU= [Select Id, ContactId, Username, AboutMe, FullPhotoUrl, SmallPhotoUrl
						 from User u where Id = :userId limit 1];
		} catch (QueryException e) {
			System.debug('e: ' + e);
			cov_log_error.logError(e);
		}
		return theU;
	}
	
	private Contact getProfileContact(Id userId) {
		Contact c;
		try {
				c = [select Id
						, Portal_User__c
						from Contact
						where Portal_User__c = :userId
						limit 1
						];
		} catch(QueryException e){
			System.debug('e: ' + e);
		}
		return c;
	}

	public List<SelectOption> getStateOptions() {
		return getStateOptions(state);
	}

	// Taken from dc_Request_Page_Handler.cls
    public static List<SelectOption> getStateOptions(String currentState)
    {
        List<SelectOption> options = new List<SelectOption>(); 
        
        // NGKJ - Use the Schema to determine the list of States ...
        Set<String> sset = new Set<String>();
        List<Schema.PicklistEntry> states = Give_Request__c.State__c.getDescribe().getPicklistValues();
        System.Debug('NGKJ - State Picklist Values: ' + states);
        for (Schema.PicklistEntry state : states)
            if (state.isActive())
                sset.add(state.getValue());
        // NGKJ - add User State if it's not there ...
        System.Debug('NGKJ - sset: ' + sset);
        //System.Debug('NGKJ - givereq.State__c' + request.State__c);
 //       if (request != null && request.State__c == null) sset.add(''); else sset.add(request.State__c); 
 		if (currentState == null) sset.add('');
        System.Debug('NGKJ - sset: ' + sset);
        // NGKJ - add User State if it's not there ...
        // NGKJ - now make the set a List for sorting
        List<string> stlist = new List<String>();
        stlist.addAll(sset);        
        stlist.sort(); 
        System.Debug('NGKJ - stlist: ' + stlist);
        for(integer i=0;i<stlist.size();i++)
            options.add(new SelectOption(stlist[i],stlist[i]));
                
        return options;       
    }

	public PageReference changePassword() {
		PageReference pr = Page.IAVAPlus_ChangePassword;
  		pr.setRedirect(true);
  		return pr;
	}

/*	    
	public PageReference resetPassword() {
		System.ResetPasswordResult rpr = System.resetPassword(uId, true);
		System.Debug('rpr: ' + rpr);
		return Page.cov_dashboard;		
	}    
	    
	// Taken from IAVAPlus_ForgotPasswordController.cls
  	public PageReference forgotPassword() {
  		boolean success = Site.forgotPassword(u.Username);
  		PageReference pr = Page.cov_dashboard;
  		pr.setRedirect(true);
  		
  		if (success) {  			
  			return pr;
  		}
  		return null;
  	}
*/	    

  //  public virtual void deploymentsInit() {
  //  	System.debug('Now in deploymentsInit()');
		//deployments = getDeployments();
  //  }

	public List<cov_customdeployment> getDeployments(){
		System.Debug('In getDeployments and deployments: ' + deployments);
		System.Debug('In getDeployments and editmodes: ' + editmodes);
		if (deployments == null) {
			System.debug('since deployments is null, calling query method');
			deployments = queryDeployments();
		}
		if (deployments != null && (deployments.size() > 1 || (deployments.size() == 1 && deployments[0].dpId != null))) {
			hasDeployments = true;
			numDeployments = deployments.size();
		} else if (didNotDeploy) {
			hasDeployments = false;
			numDeployments = 0;
		} else {
			hasDeployments = false;
			numDeployments = 0;
			deployments = new List<cov_customdeployment>();
//			ineditmode = true;
			toCreateMode();
			ineditmode = true;
		}
		System.debug('numDeployments: ' + numDeployments);
		System.debug('ineditmode: ' + ineditmode);
		return deployments;
	}
	
//	public Integer getNumDeployments() {
//		if (numDeployments == null) {
//			deployments = getDeployments();
//		}
//		return numDeployments;

//	}

	public Boolean getHasDeployments() {
		System.debug('in getHasDeployments and deployments: ' + deployments);
		if (deployments == null) {
			deployments = getDeployments();
		}
		//if (deployments.size() > 0) {
		//	System.debug('deployments.size() > 0. returning hasDeployments=true');
		//} else {
		//	System.debug('deployments.size() is not > 0. returning hasDeployments=false');
		//}
//		return (deployments.size() > 0);
		//if (deployments.size() == 1 && deployments[0].dpId == null) {
		//	return false;
		//} else {
		//	return (deployments.size() > 0);
		//}
		return hasDeployments;
	}

	public List<cov_customdeployment> queryDeployments(){
		
		System.debug('profileContactId: ' + profileContactId);
		
		// seems to be necessary to pull the user and contact again
		if (profileContactId == null) {
			u = getProfileUser(uId);
			if (u.ContactId != null) {
				profileContactId = u.ContactId;
			} else {
				profileContactId = getProfileContact(uid).Id;
			}
		}
		
		List<Detailed_Deployment_Information__c> dps = [
			select City__c, Country__c, End_Date__c, Notes__c
				, OEF_OIF__c, Start_Date__c, Stop_Loss__c
				from Detailed_Deployment_Information__c
				where Contact__c = :profileContactId
		];
		System.Debug('dps: ' + dps);
		List<cov_customdeployment> cdpls = cov_customdeployment.createCDs(dps);
		System.debug('cdpls: ' + cdpls);
		
		editmodes = new Map<Id, Boolean>();
		for (cov_customdeployment cdpl : cdpls) {
			if (cdpl.dpId == null) {
				editmodes.put(cdpl.dpId, true);
			} else {
				editmodes.put(cdpl.dpId, false);
			}
		}
		System.debug('editmodes: ' + editmodes);
		if (cdpls != null) {
			numDeployments = cdpls.size(); 
		}

		return cdpls;
		
	}
/*	
	public Map<Id,Boolean> modes {
    get {
        Map<Id,Boolean> themap = new Map<Id,Boolean>();
			for (cov_customdeployment cdpl : deployments) {
				themap.put(cdpl.dpId, false);
			}  
			return themap;      
    }
    set;
}
*/
	
	public void toEditMode() {
		System.debug('dpIdChosen: ' + dpIdChosen);
		System.debug('editmodes before switching editmode: ' + editmodes);
		editmodes.put(dpIdChosen, true);
		System.debug('editmodes after switching editmode: ' + editmodes);

		System.Debug('In toEditMode() and deployments: ' + deployments);
		for (cov_customdeployment theDDI : deployments) {
			System.Debug('theDDI.dpId: ' + theDDI.dpId);
			if (theDDI.dpId == dpIdChosen) {
				dpcity = theDDI.city;
				dpstartdate = (theDDI.startdate == null) ? null : theDDI.startdate.format();
				dpenddate = (theDDI.enddate == null) ? null : theDDI.enddate.format();
				dpoperation = theDDI.operation;
				dpnotes = theDDI.notes;
				dpstoploss = theDDI.stoploss;
				if (String.isEmpty(theDDI.country) || theDDI.country == 'Iraq' || theDDI.country == 'Afghanistan' || theDDI.country == 'Other') {
					dpcountry = theDDI.country;
				} else {
					dpothercountry = theDDI.country;
					dpcountry = 'Other';
				}
			}
		}
		ineditmode = true;
	}
	
	public void toCreateMode() {
		System.debug('in toCreateMode()');
		cov_customdeployment newDDI = new cov_customdeployment();
		newDDI.dpId = null;
		if (deployments == null) {
			deployments = new List<cov_customdeployment>();
		}
		if (editmodes == null) {
			editmodes = new Map<Id, Boolean>();
		}
		System.debug('deployments before adding: ' + deployments);
		deployments.add(newDDI);
		System.debug('deployments after adding: ' + deployments);
		editmodes.put(null, true);
		System.debug('editmodes after adding: ' + editmodes);
		dpcity = null;
		dpcountry = null;
		dpstartdate = null;
		dpenddate = null;
		dpoperation = null;
		dpnotes = null;
		dpsurvivor = null;
		dpstoploss = null;
		
		didNotDeploy = false;
		
		ineditmode = true;
	}
	
	public void saveEdit() {
		System.debug('dpIdChosen2: ' + dpIdChosen);
		System.debug('dpcity: ' + dpcity);
		System.debug('dpstartdate: ' + dpstartdate);
		System.debug('dpenddate: ' + dpenddate);
		
		Date newstartdate;
		Date newenddate;
		
		if (dpstartdate != null && dpstartdate != '') {
			try {
				newstartdate = Date.parse(dpstartdate);
			} catch (Exception e) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
				return;
			}
		}

		if (dpenddate != null && dpenddate != '') {
			try {
				newenddate = Date.parse(dpenddate);
			} catch (Exception e) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
				return;
			}
		}
		
		if(newstartdate > newenddate) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Start Date can\'t be later than End Date'));
				return;
		}


		Detailed_Deployment_Information__c ddi;
		if(dpIdChosen == '' || dpIdChosen == null) {
			ddi = new Detailed_Deployment_Information__c();
			ddi.Contact__c = theC.Id;
		} else {
				ddi = [
					select City__c, Country__c, End_Date__c, Notes__c
						, OEF_OIF__c, Start_Date__c, Stop_Loss__c
						from Detailed_Deployment_Information__c
						where Id = :dpIdChosen
						limit 1
					];
		}
		System.debug('ddi: ' + ddi);
		Boolean updateDDI = false;
		
		dpcity = nullIfEmpty(dpcity);
		dpstartdate = nullIfEmpty(dpstartdate);
		dpenddate = nullIfEmpty(dpenddate);
		dpoperation = nullIfEmpty(dpoperation);
		dpnotes = nullIfEmpty(dpnotes);

		if (dpcountry == 'Other' && !String.isEmpty(dpothercountry)) {
			dpcountry = dpothercountry;
		} else {
			dpcountry = nullIfEmpty(dpcountry);			
		}
		
		
		if (ddi.City__c != dpcity) { ddi.City__c = dpcity; updateDDI = true; }
		if (ddi.Country__c != dpcountry) {ddi.Country__c = dpcountry; updateDDI = true; }
		if ((dpstartdate == null || dpstartdate == 'Start Date' || dpstartdate == '') && ddi.Start_Date__c != null) {
			 ddi.Start_Date__c = null;
			 updateDDI = true;
		} else if (dpstartdate != null && dpstartdate != 'Start Date' && dpstartdate != '') {
			if (ddi.Start_Date__c != newstartdate) {
				ddi.Start_Date__c = newstartdate;
				updateDDI = true; 
			}
		}
		if ((dpenddate == null || dpenddate == 'End Date' || dpenddate == '') && ddi.End_Date__c != null) {
			 ddi.End_Date__c = null;
			 updateDDI = true;
		} else if (dpenddate != null && dpenddate != 'End Date' && dpenddate != '') {
			if (ddi.End_Date__c != newenddate) {
				ddi.End_Date__c = newenddate;
				updateDDI = true; 
			}
		}
//		if (dpenddate != 'End Date' && ddi.End_Date__c != Date.parse(dpenddate)) {ddi.End_Date__c = Date.parse(dpenddate); updateDDI = true; }
		if (ddi.Notes__c != dpnotes) {ddi.Notes__c = dpnotes; updateDDI = true; }
		if (ddi.OEF_OIF__c != dpoperation) {ddi.OEF_OIF__c = dpoperation; updateDDI = true; }
		if (ddi.Stop_Loss__c != dpstoploss) {ddi.Stop_Loss__c = dpstoploss; updateDDI = true; }
//		if (ddi.Submitted_by_Survivor__c != dpsurvivor) {ddi.Submitted_by_Survivor__c = dpsurvivor; updateDDI = true; }

		if(updateDDI) { 
			if(dpIdChosen == '' || dpIdChosen == null) {
				System.debug('about to insert ddi: ' + ddi);
				try {
					insert ddi;
				} catch (DMLException e) { cov_log_error.logError(e); }
				deployments = null;
			} else {
				System.debug('about to update ddi: ' + ddi);
				try {
					update ddi; 
				} catch (DMLException e) { cov_log_error.logError(e); }
			}
		}		
		
		deployments = null;
		deployments = getDeployments();
		ineditmode = false;

	}
	
	public void cancelRow() {
		deployments = queryDeployments();
		ineditmode = false;		
	}
	
	public void deleteRow() {
		System.debug('Delete dpId: ' + dpIdChosen);
		if(dpIdChosen != null) {
			try {
    			delete [select Id from Detailed_Deployment_Information__c
						where Id = :dpIdChosen
						limit 1];
			} catch (DMLException e) { cov_log_error.logError(e); }
		}
		deployments = null;
		deployments = getDeployments();
		if (deployments != null && deployments.size() > 0) {
			ineditmode = false;			
		} else {
			ineditmode = true;
		}
	}
	
	public PageReference didntDeploy() {
		return setDidNotDeployFlag(true);
	}

	public PageReference unsetDidNotDeploy() {
		return setDidNotDeployFlag(false);
	}

	public PageReference setDidNotDeployFlag(Boolean value) {
		System.debug('Setting Did_Not_Deploy__c');

		theC.Did_Not_Deploy__c = value;
		try {
			update theC;
			didNotDeploy = value;
		} catch (DMLException e) { cov_log_error.logError(e); }

		deployments = queryDeployments();
		return null;

	}

	public String nullIfEmpty(String s) {
		return (s == null || String.isEmpty(s) ? null : s);
	}

	public Boolean stringsAreExactlyTheSame(String s1, String s2) {
		if (s1==null || s2==null) {
			if (s1 != s2) {
				return false;
			} else {
				return true;
			}
		} else {
			return s1.equals(s2);
		}
	}



	// 6/2015 Deprecated, replaced with process builder process 
	// to update Company Name when the Community Title Formula on contact is changed

	
	///*
	//  *  For populating the user's Company field based on Veteran Status, Branch, and Operation.
	//*/
	
	// If it's an external user the Contact fields will be
	// accessible from the user record	
	public static String buildCompanyName(User uu) {
		Contact tempC = new Contact(
			Veteran_Member__c = uu.Contact.Veteran_Member__c
			, Branch_of_Service__c = uu.Contact.Branch_of_Service__c
			, Veteran_of_OEF__c = uu.Contact.Veteran_of_OEF__c
			, Veteran_of_OIF__c = uu.Contact.Veteran_of_OIF__c
			, Veteran_of_OND__c = uu.Contact.Veteran_of_OND__c
			, temp_title__c = uu.Contact.Community_Title__c
			);
		return buildCompanyName(uu, tempC);
	}


	// If it's an internal user the Contact fields will be
	// passed in separately	
	public static String buildCompanyName(User uu, Contact cc) {
		system.debug('user: ' + uu + '; Contact: ' + cc);
		String n = '';
        
		
		/*if(uu.UserType == 'Standard') {
			n = '[IAVA] ';
		}
		
		if (!cc.Veteran_Member__c) {
				if(uu.UserType != 'Standard') {
					n += 'Supporter';
				}
		} else {
			
			n += (cc.Branch_of_Service__c == null) ? 'Veteran' : cc.Branch_of_Service__c;

			if (cc.Veteran_of_OEF__c || cc.Veteran_of_OIF__c || cc.Veteran_of_OND__c) {
				n += ': ';
			}
			
			if (cc.Veteran_of_OEF__c) {
				n += 'OEF';
			}
			
			if (cc.Veteran_of_OIF__c) {
				if (cc.Veteran_of_OEF__c) { n = n + '/'; }
				n += 'OIF';
			}

			if (cc.Veteran_of_OND__c) {
				if (cc.Veteran_of_OEF__c || cc.Veteran_of_OIF__c) { n = n + '/'; }
				n += 'OND';
			}
									
		}*/
        n = cc.temp_title__c;
        if(string.isBlank(n))
        {
            n = cc.Community_Title__c;
        }
        // temp title is not completed on internal users
        // if temp title is blank, use community title instead
        // this should hopefully fill in title for all users
        system.debug('community title: ' + n);
        
        if(!string.isBlank(n))
        {
            n = n.trim();
        }
		return n;
	}

	
	public static void updateUserCompanyNames(List<Id> uIds) {
		
		System.debug('Going to update Company name for users: ' + uIds);
		List<User> uus = [select Id, CompanyName, UserType
								, ContactId, Contact.Community_Title__c
								, Contact.Veteran_Member__c, Contact.Branch_of_Service__c,
								Contact.Veteran_of_OEF__c, Contact.Veteran_of_OIF__c, Contact.Veteran_of_OND__c
								, (select Veteran_Member__c, Branch_of_Service__c
								, Veteran_of_OEF__c
								, Veteran_of_OIF__c	
								, Veteran_of_OND__c	
								, Community_Title__c
                                , temp_title__c
								from PortalContacts__r)
								from User
								where id in :uIds
								];
		
		for (User uu : uus) {
			if (uu.ContactId != null) {
				uu.CompanyName = buildCompanyName(uu);
				System.debug('For external user ' + uu.Id + ' company name will now be: ' + uu.CompanyName);				
			} else if (uu.PortalContacts__r.size() > 0) {
				uu.CompanyName = buildCompanyName(uu, uu.PortalContacts__r[0]);
				System.debug('For internal user ' + uu.Id + ' company name will now be: ' + uu.CompanyName);
			}
		}
		
		try {
			update uus;
		} catch (DMLException e) { cov_log_error.logError(e); }
		
	}




}