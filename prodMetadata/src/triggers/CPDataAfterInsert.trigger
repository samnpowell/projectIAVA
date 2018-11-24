/*
 * Parse DataXML field on CP Data for values to update corresponding fields on related Opportunity and Contact
 *
 * WH, Exponent Partners, 2011
 */
trigger CPDataAfterInsert on CnP_PaaS__CnPData__c (after insert) {
	// this is not a bulk trigger
	if (Trigger.size == 1) {
		if (Trigger.new[0].CnP_PaaS__DataXML__c != null && Trigger.new[0].CnP_PaaS__DataXML__c != '') {
			CPDonationUpdate.updateOpportunityAndContact(Trigger.new[0]);
		}
	}
}