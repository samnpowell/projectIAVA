// adapted from cov_customevent

public with sharing class cov_customannouncement {

/*
	custom object to store info for use in COV

*/


	public Id cId {get; set;}
	public String name {get; set;}
	public Date startDate {get; set;}
	public Date endDate {get; set;}
	public String details {get; set;}
	public Boolean showIt {get; set;}
	public Boolean hasPicThumb {get; set;}
	public Boolean hasPicFull {get; set;}
	public String picThumb {get; set;}
	public String picFull {get; set;}
	public String showTo {get; set;}
	public String type {get; set;}
	public Boolean hasSigned {get; set;}
	
	
	public cov_customannouncement() {}
	
	
	public static List<cov_customannouncement> getCustomAnnouncements(String theContactId) {

			Date todayDate = System.Today();

			List<Campaign> ancCampaigns = 
				[select Id, Name, StartDate, EndDate, Event_Public_Details__c
						, Show_Inside_COV_To__c, Type
						, (select id, Image__c, Size__c from Campaign_images__r)
						, (select Id, Status from CampaignMembers 
							where ContactId=:theContactId 
							)
						from Campaign
						where (Type = 'COV Announcement' or Type = 'Petition')
						and isActive = true
						and (StartDate <= :todayDate or StartDate = null)
						and (EndDate >= :todayDate or EndDate = null)
						ORDER BY CreatedDate DESC
				];
				System.debug('ancCampaigns: ' + ancCampaigns);
			
  				
  			List<cov_customannouncement> CAs = new List<cov_customannouncement>();
  			for (Campaign cmp : ancCampaigns) {
  				Boolean statusIsDismissed = false;
  				Boolean statusIsSigned = false;
  				for (CampaignMember cm : cmp.CampaignMembers) {
  					if (cm.Status == 'Dismissed') {
  						statusIsDismissed = true;
  					} else if (cm.Status == 'Signed') {
  						statusIsSigned = true;
  					}
  				}
  			if (	!statusIsDismissed && !statusIsSigned &&
  					(
	  					(cmp.Show_Inside_COV_To__c == 'Everyone')
	  					||
	  					(cmp.Show_Inside_COV_To__c == 'Campaign Members' && cmp.CampaignMembers.size() > 0)	
	  				)
	  			) {
	  				CAs.add(new cov_customannouncement(cmp));
	  			}
  			}
  			System.debug('CAs: ' + CAs);
  			return CAs;
	}


	public cov_customannouncement(Campaign theCampaign) {
		
		System.debug('theCampaign: ' + theCampaign);
		
		cId = theCampaign.Id;
		name = theCampaign.Name;
		startDate = theCampaign.StartDate;
		endDate = theCampaign.EndDate;
		details = theCampaign.Event_Public_Details__c;
		showTo = theCampaign.Show_Inside_COV_To__c;
		type = theCampaign.Type;
//		if (showTo == 'Everyone' || (showTo == 'Campaign Members' && theCampaign.CampaignMembers.size() > 0)) {
//			showIt = true;
//		} else {
//			showIt = false;
//		}
//		nonDismissed = theCampaign.CampaignMembers.size() == 0 ? true : false;
      	hasPicThumb = false;
      	hasPicFull = false;

		Integer numImages = theCampaign.Campaign_images__r.size();
		Integer i = 0;
		if(numImages > 0) {
			
			while (i < numImages && (!hasPicThumb || !hasPicFull)) {
				if (theCampaign.Campaign_images__r[i].Size__c == 'Thumbnail') {
					hasPicThumb = true;
					picThumb = theCampaign.Campaign_images__r[i].Image__c;
				} else if (theCampaign.Campaign_images__r[i].Size__c == 'Full') {
					hasPicFull = true;
					picFull = theCampaign.Campaign_images__r[i].Image__c;
				}
				i++;

			} 
			
		}
		
		
	}



}