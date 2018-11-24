/*
 * R41 Add contacts to donation campaigns
 *
 * WH, Exponent Partners, 2014
 */
public with sharing class CampaignControllerExt {
	
	public Integer newMemberCount { get; private set; }
	
	private Campaign thisCampaign;
	
	public CampaignControllerExt(ApexPages.StandardController controller) {
		thisCampaign = (Campaign)controller.getRecord();
	}
	
	public PageReference addDonors() {
		newMemberCount = CampaignAction.addDonorsToCampaign(thisCampaign.Id);
		return null;
	}
	
	public PageReference back() {
		System.debug('>>>>>>>>>> ' + thisCampaign);
		return new PageReference('/' + thisCampaign.Id);
	}
	
}