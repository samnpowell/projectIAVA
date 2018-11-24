/*
 * R41 Add contacts to donation campaigns
 *
 * WH, Exponent Partners, 2014
 */
public class CampaignAction {
	
	// called from OpportunityAfter trigger when Opportunities are added to Campaigns
	//	2 SOQL, 1 DML
	public static Integer addDonorsFromOpportunityToCampaign(Map<Id, Opportunity> oppById) {
		
		// build map of donors to add to campaigns
		Map<Id, Set<Id>> donorIdsByCampaign = new Map<Id, Set<Id>>();
		for (OpportunityContactRole ocr : [select ContactId, OpportunityId from OpportunityContactRole where OpportunityId in :oppById.keySet()]) {
			Id campaignId = oppById.get(ocr.OpportunityId).CampaignId;
			Set<Id> donorIds = donorIdsByCampaign.get(campaignId);
			if (donorIds == null) {
				donorIds = new Set<Id>();
				donorIdsByCampaign.put(campaignId, donorIds);
			}
			donorIds.add(ocr.ContactId);
		}
		
		// gather existing campaignMembers of campaigns
		Map<Id, Set<Id>> memberIdsByCampaign = new Map<Id, Set<Id>>();
		for (CampaignMember cm : [select CampaignId, ContactId from CampaignMember where CampaignId in : donorIdsByCampaign.keySet()]) {
			Id campaignId = cm.CampaignId;
			Set<Id> memberIds = memberIdsByCampaign.get(campaignId);
			if (memberIds == null) {
				memberIds = new Set<Id>();
				memberIdsByCampaign.put(campaignId, memberIds);
			}
			memberIds.add(cm.ContactId);
		}
		
		// create missing campaignMembers for the campaigns
		List<CampaignMember> cmsToAdd = new List<CampaignMember>();
		for (Id campaignId : donorIdsByCampaign.keySet()) {
			Set<Id> donorIds = donorIdsByCampaign.get(campaignId);
			if (memberIdsByCampaign.get(campaignId) != null) {
				for (Id cId : memberIdsByCampaign.get(campaignId)) {
					donorIds.remove(cId);
				}
			}
			for (Id cId : donorIds) {
				cmsToAdd.add(new CampaignMember(CampaignId = campaignId, ContactId = cId));
			}
		}
		
		if (!cmsToAdd.isEmpty()) {
			insert cmsToAdd;
		}
		
		return cmsToAdd.size();
	}
	
	// called from custom button on Campaign detail to add missing CampaignMembers to the Campaign
	//	1 SOQL + (2 SOQL, 1 DML in addDonorsFromOpportunityToCampaign())
	public static Integer addDonorsToCampaign(Id campaignId) {
		
		Map<Id, Opportunity> oppById = new Map<Id, Opportunity>( 
			[select Id, CampaignId from Opportunity where CampaignId = :campaignId and RecordTypeId = :RecordTypes.donationOpportunityType] );
		
		return addDonorsFromOpportunityToCampaign(oppById);
		
	}
	
}