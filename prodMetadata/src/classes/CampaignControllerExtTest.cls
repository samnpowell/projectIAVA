/*
 * R41 Add contacts to donation campaigns
 *
 * WH, Exponent Partners, 2014
 */
@isTest
private class CampaignControllerExtTest {
	
	static testMethod void testAddDonors() {
		Contact donor = new Contact(LastName = 'Donor');
		insert donor;
		
		Contact insertedDonor = [select AccountId from Contact where Id = :donor.Id];
		
		Campaign campaign = new Campaign(Name = 'Test Campaign');
		insert campaign;
		
		Opportunity donation = new Opportunity(Name = 'Donation', CampaignId = campaign.Id, RecordTypeId = RecordTypes.donationOpportunityType,
											AccountId = insertedDonor.AccountId, StageName = 'Posted', CloseDate = Date.today(), Amount = 100);
		insert donation;
		
		insert new OpportunityContactRole(OpportunityId = donation.Id, ContactId = donor.Id);
		
		System.assertEquals(0, [select count() from CampaignMember where CampaignId = :campaign.Id]);
		
		Test.startTest();
		
		ApexPages.StandardController stdController = new ApexPages.StandardController(campaign);
		CampaignControllerExt ext = new CampaignControllerExt(stdController);
		
		PageReference pRef = ext.addDonors();
		
		System.assertEquals(null, pRef);
		System.assertEquals(1, ext.newMemberCount);
		
		pRef = ext.back();
		
		System.assertEquals('/' + campaign.Id, pRef.getUrl());
		
		Test.stopTest();
		
		System.assertEquals(1, [select count() from CampaignMember where CampaignId = :campaign.Id]);
	}
	
}