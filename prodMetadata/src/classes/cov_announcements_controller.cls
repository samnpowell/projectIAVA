// Adapted from cov_events_controller

public with sharing class cov_announcements_controller {

	public List<cov_customannouncement> announcementsList {get; set;}
	public String conId {get; set;}
	public String cmpIdChosen {get; set;}
	public String cmpNameChosen {get; set;}
	public Boolean hasAnnouncements {get; set;}
	
//	public cov_customannouncement ca {get; set;}
	

	public cov_announcements_controller() {
		System.debug('conId in announcements controller before setting: ' + conId);
				
		if (conId == null) {
//			conId = cov_nosharing_controller.getUserContactId();
			conId = cov_user_utility.self.getCId();
		}	
		System.debug('conId in announcements controller after setting: ' + conId);
		if (conId != null) {
			// added this IF so it wouldnt bonk during unit tests
			announcementsList = getcAnnounceList(conId);
		}
	}


    public List<cov_customannouncement> getcAnnounceList(String conId) {

		if (conId == null) {
//			conId = cov_nosharing_controller.getUserContactId();
			conId = cov_user_utility.self.getC().Id;
		}	

		List<cov_customannouncement> theAnnouncements = cov_customannouncement.getCustomAnnouncements(conId);
		if (theAnnouncements.size() > 0 ) {
			hasAnnouncements = true;
		} else {
			hasAnnouncements = false;
		}
		System.debug('hasAnnouncements: ' + hasAnnouncements);
		return theAnnouncements;				
      				
    }
    
    public PageReference signPetition() {
		addCampaignMember(cmpIdChosen, 'Signed');


		FeedItem post = new FeedItem();
		post.ParentId = cov_user_utility.self.getU().Id;
		post.Body = UserInfo.getFirstName() + ' just signed the petition "' + cmpNameChosen + '"';
		//post.LinkUrl = Site.getPrefix() + '/cov_announcement_detail?id=' + cmpIdChosen; // doesnt exist yet
		post.Title = cmpNameChosen;
		post.NetworkScope = Network.getNetworkId();
		try {	
			insert post;
		} catch (DMLException e) { cov_log_error.logError(e); }

		String userMsg = 'You\'ve signed the petition. Thanks!';
		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Confirm, userMsg);
		ApexPages.addMessage(myMsg);

		return null;
    }

    public PageReference dismiss(){
		addCampaignMember(cmpIdChosen, 'Dismissed');    
		return null;
    }

 /*   
    public PageReference dismiss_old(){
    	
    	// check whether existing CM record.  if so change status to Dismissed
    	// if not create CM record with status Dismissed

		System.debug('Campaign ID of announcement to Dismiss: ' + cmpIdChosen);
    	
    	CampaignMemberStatus dismissStatus;
    	
    	try {
			dismissStatus = [SELECT id, HasResponded 
                                        FROM CampaignMemberStatus
                                        WHERE CampaignID = :cmpIdChosen AND (Label = 'Dismissed') limit 1];
    	} catch(QueryException e){}

		System.debug('dismissStatus after query: ' + dismissStatus);

		if (dismissStatus == null) {
			dismissStatus = new CampaignMemberStatus (CampaignId = cmpIdChosen, Label = 'Dismissed', SortOrder=0, HasResponded = true);
			System.debug('dismissStatus before insert: ' + dismissStatus);
			try {
				insert dismissStatus;
			} catch (DMLException e) { cov_log_error.logError(e); }
		}

    	CampaignMember existingCM;
    	
    	try {
    		existingCM = [select Id from CampaignMember where ContactId = :conId and CampaignId = :cmpIdChosen limit 1];
			System.debug('existing CampaignMember record found: ' + existingCM);			
			existingCM.Status = 'Dismissed';
			System.debug('existingCM before update: ' + existingCM);
			try {
				update existingCM;
			} catch (DMLException e) { cov_log_error.logError(e); }
			System.debug('existingCM after update: ' + existingCM);
    	} catch(QueryException e){}
		if (existingCM == null) {
			System.debug('No existing CampaignMember record found.');
			CampaignMember CMtoInsert = new CampaignMember(ContactId=conId, CampaignId=cmpIdChosen, Status='Dismissed');
			try {
				insert CMtoInsert;
			} catch (DMLException e) { cov_log_error.logError(e); }
		}

		// remove announcement from list to correct post-dismiss refresh
		Integer j = 0;
		while (j < announcementsList.size()) {
			if(announcementsList.get(j).cId == cmpIdChosen) {
				announcementsList.remove(j);
			} else {
				j++;
			}
		}
		return null;
    	
    }
*/
    public void addCampaignMember(String cmpId, String status){
    	
    	// check whether existing CM record.  if so change status to Dismissed
    	// if not create CM record with status Dismissed

		System.debug('Campaign ID of announcement chosen: ' + cmpId);
		System.debug('Status to add: ' + status);
    	
		List<CampaignMemberStatus> cmStatuses = [SELECT id, Label, SortOrder, HasResponded 
                                        FROM CampaignMemberStatus
                                        WHERE CampaignID = :cmpId];
		System.debug('cmStatuses after query: ' + cmStatuses);

        Set<String> statuses = new Set<String>();
        Set<Integer> sortOrders = new Set<Integer>();
        for (CampaignMemberStatus cms : cmStatuses) {
        	statuses.add(cms.Label);
        	sortOrders.add(cms.SortOrder);
        }

		if (!statuses.contains(status)) {
			Integer availableSortOrder;
			Integer i = 0;
			while (i < 1000 && availableSortOrder == null) {
				if (!sortOrders.contains(i)) {
					availableSortOrder = i;
					system.debug('availableSortOrder: ' + availableSortOrder);
				}
				i++;
			}

			if (availableSortOrder == null) {
				return;
			}

			CampaignMemberStatus cmStatus = new CampaignMemberStatus (CampaignId = cmpIdChosen, Label = status
												, SortOrder = availableSortOrder
												, HasResponded = true);
			System.debug('cmStatus before insert: ' + cmStatus);
			try {
				insert cmStatus;
			} catch (DMLException e) { cov_log_error.logError(e); }
		}

    	CampaignMember existingCM;
    	
    	try {
    		existingCM = [select Id from CampaignMember where ContactId = :conId and CampaignId = :cmpIdChosen limit 1];
			System.debug('existing CampaignMember record found: ' + existingCM);			
			existingCM.Status = status;
			System.debug('existingCM before update: ' + existingCM);
			try {
				update existingCM;
			} catch (DMLException e) { cov_log_error.logError(e); }
			System.debug('existingCM after update: ' + existingCM);
    	} catch(QueryException e){}
		if (existingCM == null) {
			System.debug('No existing CampaignMember record found.');
			CampaignMember CMtoInsert = new CampaignMember(ContactId=conId, CampaignId=cmpIdChosen, Status=status);
			try {
				insert CMtoInsert;
			} catch (DMLException e) { cov_log_error.logError(e); }
		}

		// remove announcement from list to correct post-dismiss refresh
		Integer j = 0;
		while (j < announcementsList.size()) {
			if(announcementsList.get(j).cId == cmpId) {
				announcementsList.remove(j);
			} else {
				j++;
			}
		}
    	
    }



}