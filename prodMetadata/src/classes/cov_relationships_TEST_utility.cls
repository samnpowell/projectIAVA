@isTest
public with sharing class cov_relationships_TEST_utility {


	public static void setReciprocalRelationship(String sprimary, String srecip) {
		// it appears we have to re-create the relationships settings
		// and reciprocal relationships lookups inside of the unit test

		// this code was written for NPSP2 settings and probably should be updated
		// for NPSP3 but doesnt seem to have broken anything


		npe4__Relationship_Lookup__c rl = new npe4__Relationship_Lookup__c(
			Name = sprimary,
			npe4__Active__c = true,
			npe4__Female__c = srecip, 
			npe4__Male__c = srecip, 
			npe4__Neutral__c = srecip
			);
		insert rl;

		npe4__Relationship_Lookup__c rl2 = new npe4__Relationship_Lookup__c(
			Name = srecip,
			npe4__Active__c = true,
			npe4__Female__c = sprimary, 
			npe4__Male__c = sprimary, 
			npe4__Neutral__c = sprimary
			);
		insert rl2;

		npe4__Relationship_Settings__c rs = new npe4__Relationship_Settings__c(
			Name = 'test setting',
			SetupOwnerId = UserInfo.getOrganizationId(),
			npe4__Reciprocal_Method__c = 'List Setting',
			npe4__Force_Synchronous_Auto_Create__c = true
			);
		insert rs;

		// with NPSP3 no longer seem to need to disable auto-creation of 
		// reciprocal relationship for portal user and instead create in code
		
  //      Profile p = [SELECT Id FROM Profile WHERE Name='IAVA Plus Portal User']; 

		//npe4__Relationship_Settings__c rs2 = new npe4__Relationship_Settings__c(
		//	Name = 'test portal profile setting',
		//	SetupOwnerId = p.Id,
		//	npe4__DISABLE_Relationships_trigger__c = true
		//	);
		//insert rs2;

		System.debug('All relationship lookups: ' + [select Id, Name, npe4__Active__c, npe4__Female__c, npe4__Male__c, npe4__Neutral__c from npe4__Relationship_Lookup__c]);

		//System.debug('All relationships settings: ' + [select Id, IsDeleted, Name, npe4__Allow_AutoCreated_Duplicates__c, npe4__DISABLE_RelationshipCM_trigger__c, npe4__DISABLE_RelationshipContacts_trigger__c, npe4__DISABLE_Relationships_trigger__c, npe4__Force_Synchronous_Auto_Create__c, npe4__Gender_Field__c, npe4__Reciprocal_Method__c, npe4__Relationship_Name_Field_Id__c, npe4__Relationship_Name_Id_Field_Id__c from npe4__Relationship_Settings__c]);

	}



}