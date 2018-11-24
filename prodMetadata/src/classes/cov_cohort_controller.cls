public without sharing class cov_cohort_controller {
//without sharing since have to update contact lookup to sponsor contact

	public static void addCohort(Id cId) {

		System.debug('in cov_cohort_controller.addCohort()');
		Contact c = [select Id, COV_Cohort__c, COV_Sponsor__c from Contact where Id = :cId limit 1];

		if (c == null || c.COV_Cohort__c != null || c.COV_Sponsor__c != null) {
			System.debug('returning out of method because c: ' + c);
			return;
		}
		System.debug('c: ' + c);

		Boolean foundCohort = false;
		Boolean updateRecord = false;

		
		// 1) If contact has a vouch, take the cohort from the most recent voucher 
		// and fill in sponsor. If most recent voucher has no cohort go to step 2 
		// but still make the voucher the COV Sponsor.

		npe4__Relationship__c voucherRel;
		try {
				voucherRel = 
				[select CreatedDate
	        	, npe4__RelatedContact__r.COV_Cohort__c
	        	, npe4__RelatedContact__c
	  			FROM npe4__Relationship__c 
				WHERE npe4__Contact__c=:cId
				AND npe4__Type__c='Vouched for by'
				AND npe4__RelatedContact__c != :cId
				order by CreatedDate DESC
				limit 1
				];
		} catch(QueryException e){}

    	if (voucherRel != null) {
    		System.debug('voucher relationship found: ' + voucherRel);
			if (voucherRel.npe4__RelatedContact__r.COV_Cohort__c != null) {
    			c.COV_Cohort__c = voucherRel.npe4__RelatedContact__r.COV_Cohort__c;
    			foundCohort = true;
    		}
    		c.COV_Sponsor__c = voucherRel.npe4__RelatedContact__c;
    		updateRecord = true;
        }


        // 2) Find if the contact is part of a campaign of type COV Cohort 
		// and if so make the cohort the name of the campaign. If multiple campaigns 
		// take the one with the most recent Date Created.

		if (!foundCohort) {
			System.debug('Going to try to find a campaignMember of a campaign of type COV Cohort Invitees');
			CampaignMember cm;
			try {
				cm = [select Id
				, Campaign.Name 
				from CampaignMember 
				where ContactId = :cId and Campaign.Type = 'COV Cohort Invitees' 
				order by CreatedDate DESC
				limit 1];
				System.debug('CampaignMember record found: ' + cm);
			} catch(QueryException e){}
			if (cm != null) {
	    		System.debug('Found a campaignMember of a campaign of type COV Cohort Invitees: ' + cm);
				c.COV_Cohort__c = cm.Campaign.Name;
				foundCohort = true;
				updateRecord = true;
			}
		}


		// 3) Take the only campaign that has an open End Date.

		if (!foundCohort) {
			System.debug('Fallback: Going to try to find a campaign of type COV Cohort Invitees with no End Date');
			Campaign cmp;
			try {
				cmp = [select Id
				, Name 
				from Campaign
				where Campaign.Type = 'COV Cohort Invitees' 
				and EndDate = null
				order by CreatedDate DESC
				limit 1];
				System.debug('Campaign record found: ' + cmp);
			} catch(QueryException e){}
			if (cmp != null) {
	    		System.debug('Found a campaign of type COV Cohort Invitees with no EndDate: ' + cmp);
				c.COV_Cohort__c = cmp.Name;
				foundCohort = true;
				updateRecord = true;
			}
		}

		if (updateRecord) {
			System.debug('Updating c: ' + c);
			update c;
		}

	}

}