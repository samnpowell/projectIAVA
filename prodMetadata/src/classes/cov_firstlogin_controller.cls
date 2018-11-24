public with sharing class cov_firstlogin_controller {

	// replaced with custom Chatter Group Mirror object
	//public List<Id> GROUPS_TO_ADD_EVERYONE = new List<Id>();

//	public static String sessionId {get; set;}
	public static Boolean isFirstLogin {get; set;}
	public static Boolean isFirstLoginDate {get; set;}
	public static User u {get; set;}
	
	public cov_firstlogin_controller(){}
	
	public PageReference checkFirstLogin() {
		System.debug('Initializing cov_firstlogin controller. isFirstLogin: ' + isFirstLogin);

		System.debug('u: ' + u);
		if (u == null) {
			u = cov_user_utility.self.getU();
			System.debug('u after query: ' + u);
			System.debug('u.Date_of_first_COV_login__c: ' + u.Date_of_first_COV_login__c);
			System.debug('u.Date_of_COV_Terms_and_Conduct_Acceptance__c: ' + u.Date_of_COV_Terms_and_Conduct_Acceptance__c);
			System.debug('u.ContactId: ' + u.ContactId);
		}

		if (u.Date_of_COV_Terms_and_Conduct_Acceptance__c == null) {
			System.debug('u.Date_of_COV_Terms_and_Conduct_Acceptance__c is null so sending over to cov_gateway');
			return Page.cov_gateway;
		}


		if (isFirstLogin == null) {
			System.debug('u.Date_of_first_COV_login__c: ' + u.Date_of_first_COV_login__c);
			if (u.Date_of_first_COV_login__c == null) {
				isFirstLogin = true;
				isFirstLoginDate = true;
				u.Date_of_first_COV_login__c = Date.today();
				try {
					update u;
				} catch (DMLException e) { cov_log_error.logError(e); }
/*				Id theContactId = u.ContactId;
				if (theContactId == null) {
					try {
							theContactId = [select Id
									, Portal_User__c
									from Contact
									where Portal_User__c = :u.Id
									limit 1
									].Id;
							System.debug ('theContactId: ' + theContactId);
					} catch(QueryException e){
						System.debug('No related contact found. e: ' + e);
					}
				}
*/

				Id theNetworkId = cov_user_utility.self.getNetworkId();
				NetworkMember nm = [select DefaultGroupNotificationFrequency from NetworkMember 
									where MemberId = :u.Id
									and NetworkId = :theNetworkId
									limit 1
									];
				if (nm != null) {
					nm.DefaultGroupNotificationFrequency = 'D';
					try {
						update nm;
					} catch (Exception e) { cov_log_error.logError(e); }
				}

				//Contact theContact = cov_user_utility.self.getC(new List<String>{'MailingState'});
				Contact theContact = cov_user_utility.self.getC();
				Id theContactId;
				String contactState = 'NONMATCH-VALUE'; // so if contact is null the query clause wont match
				Set<Id> campaignIdsWhereContactIsMember = new Set<Id>();
				if (theContact != null) {
					theContactId = theContact.Id;
					contactState = theContact.MailingState;
					//First query all campaigns where the contact has a groupmember
					List<CampaignMember> cms = [select Campaign.Id from CampaignMember where ContactId = :theContactId];
					for (CampaignMember cm : cms) {
						campaignIdsWhereContactIsMember.add(cm.Campaign.Id);
					}
				}

				String memberCatsToSearch = cov_groups_controller.getMemberCatsSetFromMemberCatsField(theContact.Member_Categories__c);

				//List<Chatter_Group_Mirror__c> targetGroupMirrors = [select Group_Id__c from Chatter_Group_Mirror__c 
				//													where Add_everyone_to_group__c = true
				//													or (Auto_add_Campaign__c != null and Auto_add_Campaign__c in :campaignIdsWhereContactIsMember)
				//													or (Auto_add_States__c != null and Auto_add_States__c includes (:contactState))
				//													];
				String q = 'select Group_Id__c from Chatter_Group_Mirror__c'
						+ ' where '
						+ ' (Auto_Add_to_Group__c != null and Auto_Add_to_Group__c includes (' + memberCatsToSearch + '))'
						+ ' or (Auto_add_Campaign__c != null and Auto_add_Campaign__c in :campaignIdsWhereContactIsMember)'
						+ ' or (Auto_add_States__c != null and Auto_add_States__c includes (:contactState) and Auto_Add_to_Selected_States__c != null and Auto_Add_to_Selected_States__c includes (' + memberCatsToSearch + '))'
						;
				List<Chatter_Group_Mirror__c> targetGroupMirrors = Database.query(q);


				system.debug('targetGroupMirrors: ' + targetGroupMirrors);
				List<CollaborationGroup> targetGroups = new List<CollaborationGroup>();
				if (targetGroupMirrors.size() > 0) {
					targetGroups = cov_groups_controller.findGroupsByMirrors(targetGroupMirrors);
				}

				System.debug('targetGroups: ' + targetGroups);
				cov_groups_controller.addToGroups(u, targetGroups);


				if (theContact != null) {
					System.debug('About to autofollow vouchers and vice versa');
					System.debug ('theContactId: ' + theContactId);
					cov_autofollow_relationships.followAllRelationships(theContactId, new List<String>{'Vouched for by', 'Invited to event by'}, true);
					System.debug('Done with autofollowing');

					List<Id> uIds = new List<Id>();
					uIds.add(u.Id);
					//cov_profile_controller.updateUserCompanyNames(uIds);
					cov_cohort_controller.addCohort(theContactId);
				}

			} else {
				isFirstLogin = false;
				if (u.Date_of_first_COV_login__c == Date.today()) {
					isFirstLoginDate = true;
				} else {
					isFirstLoginDate = false;
				}
			}

		}
		System.debug('Exiting cov_firstlogin controller. isFirstLogin: ' + isFirstLogin);
		return null;
	}
	
}