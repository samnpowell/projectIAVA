public with sharing class RecordTypes {
	
	private static final Map<String, Schema.RecordTypeInfo> opportunityTypeMap = Opportunity.SObjectType.getDescribe().getRecordTypeInfosByName();
	public static final Id donationOpportunityType = opportunityTypeMap.get('Donation').RecordTypeId;
	
}