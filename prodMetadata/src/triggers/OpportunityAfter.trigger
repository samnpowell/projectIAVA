trigger OpportunityAfter on Opportunity (after update) {
	
	/*
	 * R41 Add contacts to donation campaigns
	 *
	 * WH, Exponent Partners, 2014
	 */
	if (Trigger.isAfter && Trigger.isUpdate) {
		Map<Id, Opportunity> oppById = new Map<Id, Opportunity>();
		
		for (Opportunity o : Trigger.new) {
			if (o.RecordTypeId == RecordTypes.donationOpportunityType && o.CampaignId != null && Trigger.oldMap.get(o.Id).CampaignId != o.CampaignId) {
				oppById.put(o.Id, o);
			}
		}
		
		if (!oppById.isEmpty()) {
			CampaignAction.addDonorsFromOpportunityToCampaign(oppById);
		}
	}
	
}