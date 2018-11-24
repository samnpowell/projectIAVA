/*
 * R41 Add contacts to donation campaigns
 *
 * WH, Exponent Partners, 2014
 */
@isTest
private class CampaignActionTest {
	
	static testMethod void donorsAddedToCampaignWhenDonationsAddedToCampaign() {
		Contact dr1 = new Contact(LastName = 'Donor 1');
		Contact dr2 = new Contact(LastName = 'Donor 2');
		List<Contact> donors = new List<Contact> { dr1, dr2 };
		insert donors;
		
		Map<Id, Id> accountIdByDonor = new Map<Id, Id>();
		for (Contact c : [select Id, AccountId from Contact where Id in :donors]) {
			accountIdByDonor.put(c.Id, c.AccountId);
		}
		
		Campaign c1 = new Campaign(Name = 'Campaign 1');
		Campaign c2 = new Campaign(Name = 'Campaign 2');
		List<Campaign> campaigns = new List<Campaign> { c1, c2 };
		insert campaigns;
		
		CampaignMember cm11 = new CampaignMember(CampaignId = c1.Id, ContactId = dr1.Id);
		insert cm11;
		
		Opportunity dn1 = new Opportunity(Name = 'Donation 1', CampaignId = c1.Id, RecordTypeId = RecordTypes.donationOpportunityType,
											AccountId = accountIdByDonor.get(dr1.Id), StageName = 'Posted', CloseDate = Date.today(), Amount = 100);
		Opportunity dn2 = new Opportunity(Name = 'Donation 2', CampaignId = c2.Id, RecordTypeId = RecordTypes.donationOpportunityType,
											AccountId = accountIdByDonor.get(dr2.Id), StageName = 'Posted', CloseDate = Date.today(), Amount = 200);
		List<Opportunity> donations = new List<Opportunity> { dn1, dn2 };
		insert donations;
		
		OpportunityContactRole ocr11 = new OpportunityContactRole(OpportunityId = dn1.Id, ContactId = dr1.Id);
		OpportunityContactRole ocr22 = new OpportunityContactRole(OpportunityId = dn2.Id, ContactId = dr2.Id);
		insert new List<OpportunityContactRole> { ocr11, ocr22 };
		
		List<CampaignMember> cms = [select CampaignId, ContactId from CampaignMember where CampaignId in :campaigns order by CampaignId, ContactId];
		
		// opps have no contactRoles when added to campaign; no trigger on contactRoles => no new campaignMembers
		System.assertEquals(1,		cms.size());
		System.assertEquals(c1.Id,	cms[0].CampaignId);
		System.assertEquals(dr1.Id,	cms[0].ContactId);
		
		Test.startTest();
		
		dn1.CampaignId = c2.Id;
		dn2.CampaignId = c1.Id;
		update donations;
		
		Test.stopTest();
		
		cms = [select CampaignId, ContactId from CampaignMember where CampaignId in :campaigns order by CampaignId, ContactId];
		
		// campaignMembers added, not removed from campaigns
		System.assertEquals(3,		cms.size());
		System.assertEquals(c1.Id,	cms[0].CampaignId);
		System.assertEquals(dr1.Id,	cms[0].ContactId);
		System.assertEquals(c1.Id,	cms[1].CampaignId);
		System.assertEquals(dr2.Id,	cms[1].ContactId);
		System.assertEquals(c2.Id,	cms[2].CampaignId);
		System.assertEquals(dr1.Id,	cms[2].ContactId);
	}
	
	static testMethod void donorsAddedToCampaignOnDemand() {
		Contact dr1 = new Contact(LastName = 'Donor 1');
		Contact dr2 = new Contact(LastName = 'Donor 2');
		List<Contact> donors = new List<Contact> { dr1, dr2 };
		insert donors;
		
		Map<Id, Id> accountIdByDonor = new Map<Id, Id>();
		for (Contact c : [select Id, AccountId from Contact where Id in :donors]) {
			accountIdByDonor.put(c.Id, c.AccountId);
		}
		
		Campaign c = new Campaign(Name = 'Test Campaign');
		insert c;
		
		CampaignMember cm1 = new CampaignMember(CampaignId = c.Id, ContactId = dr1.Id);
		insert cm1;
		
		Opportunity dn1 = new Opportunity(Name = 'Donation 1', CampaignId = c.Id, RecordTypeId = RecordTypes.donationOpportunityType,
											AccountId = accountIdByDonor.get(dr1.Id), StageName = 'Posted', CloseDate = Date.today(), Amount = 100);
		Opportunity dn2 = new Opportunity(Name = 'Donation 2', CampaignId = c.Id, RecordTypeId = RecordTypes.donationOpportunityType,
											AccountId = accountIdByDonor.get(dr2.Id), StageName = 'Posted', CloseDate = Date.today(), Amount = 200);
		List<Opportunity> donations = new List<Opportunity> { dn1, dn2 };
		insert donations;
		
		OpportunityContactRole ocr11 = new OpportunityContactRole(OpportunityId = dn1.Id, ContactId = dr1.Id);
		OpportunityContactRole ocr22 = new OpportunityContactRole(OpportunityId = dn2.Id, ContactId = dr2.Id);
		insert new List<OpportunityContactRole> { ocr11, ocr22 };
		
		List<CampaignMember> cms = [select ContactId from CampaignMember where CampaignId = :c.Id order by ContactId];
		
		// opps have no contactRoles when added to campaign; no trigger on contactRoles => no new campaignMembers
		System.assertEquals(1,		cms.size());
		System.assertEquals(dr1.Id,	cms[0].ContactId);
		
		Integer newMemberCount;
		
		Test.startTest();
		
		newMemberCount = campaignAction.addDonorsToCampaign(c.Id);
		
		Test.stopTest();
		
		cms = [select ContactId from CampaignMember where CampaignId = :c.Id order by ContactId];
		
		// missing campaignMembers added on demand
		System.assertEquals(1,		newMemberCount);
		System.assertEquals(2,		cms.size());
		System.assertEquals(dr1.Id,	cms[0].ContactId);
		System.assertEquals(dr2.Id,	cms[1].ContactId);
	}
		
}