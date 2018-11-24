/*
 * Provision IAVA Plus portal user licenses for confirmed IAVA members
 *
 * WH, Exponent Partners, 2012
 */
public class PortalUserProvisioning {
	
	private static Id portalProfileId;
	
	public static Id getPortalProfileId() {
		if (portalProfileId == null) {
			portalProfileId = [select Id from Profile where Name = 'IAVA Plus Portal User'].Id;
		}
		return portalProfileId;
	}
	
	public static void createPortalUsers(List<Contact> contacts) {
		
		// map of lowercase email address to contact
		Map<String, Contact> emailContactMap = new Map<String, Contact>();
		
		String thisEmail;
		for (Contact c : contacts) {
			if (c.Email != null) {
				thisEmail = c.Email.toLowerCase();
				if (!emailContactMap.containsKey(thisEmail)) {
					emailContactMap.put(thisEmail, c);
				} else {
					System.debug('>>>>>>>>>> Contact with same case-insensitive email address as others in the update trigger batch: ' + c.Id);
				}
			} // else do nothing, since email is required and used as username	
		}
		
		// find existing users with same username
		for (User u : [select Id, Username from User where Username in :emailContactMap.keySet()]) {
			// remove from map of new users to provision
			emailContactMap.remove(u.Username);
			System.debug('>>>>>>>>>> User with identical username already exists in the org: ' + u.Username + ': ' + u.Id);
		}
		
		// create portal user for each contact that has no existing user with same username
		List<User> portalUsersToInsert = new List<User>();
		User thisUser;
		Id profileId = getPortalProfileId();
		for (Contact c : emailContactMap.values()) {
			thisUser = getAPortalUser(c, profileId);
			if (thisUser != null) {
				portalUsersToInsert.add(thisUser);
			}
		}
		
		Boolean insertedSuccessfully = false;

		// insert portal users
		if (portalUsersToInsert.size() > 0) {
			try {
				insert portalUsersToInsert;
				insertedSuccessfully = true;
			} catch (Exception e) {
				System.debug('>>>>>>>>>> Failed to bulk provision portal user licenses: ' + e.getMessage());
				return;
			}
		}

		if (insertedSuccessfully) {
			Set<Id> portalUserIdsToAddToCOV = new Set<Id>();
			for (User newPortalUser : portalUsersToInsert) {
				if (newPortalUser.Date_of_COV_Terms_and_Conduct_Acceptance__c != null) {
					portalUserIdsToAddToCOV.add(newPortalUser.Id);
				}
			}
			if (portalUserIdsToAddToCOV.size() > 0) {
				addUsersToCOV(portalUserIdsToAddToCOV);
			}

		}

	}

	@future
	private static void addUsersToCOV(Set<Id> newUserIds) {
		// in future method to avoid MIXED DML ERROR after Contact update
		List<User> newUsers = [select Id, Profile.UserLicenseId from User where Id in :newUserIds];
		if (newUsers.size() > 0) {
			Boolean unnecessaryBoolean = cov_gateway_controller.addCOVPermissionSet(newUsers);		
		}
	}
	
	private static User getAPortalUser(Contact theContact, Id portalUserProfileId) {
		Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.EmailHeader.triggerUserEmail = true;
		User portalUser = null;
		if (theContact != null) {
			String alias;
			List<String> emailSplit = theContact.Email.split('@', 2);
			if (emailSplit.size() > 1) {
				alias = emailSplit[0];
				if (alias.length() > 8) {
					alias = alias.substring(0,8);
				}
			}
			portalUser = new User();
			portalUser.Username = theContact.Email.toLowerCase();
			portalUser.LastName = theContact.LastName;
			portalUser.FirstName = theContact.FirstName;
			portalUser.Email = theContact.Email;
			portalUser.Alias = alias;
			portalUser.TimeZoneSidKey = 'America/New_York';
			portalUser.LocaleSidKey = 'en_US';
			portalUser.EmailEncodingKey = 'ISO-8859-1';
			portalUser.ProfileId = portalUserProfileId;
			portalUser.LanguageLocaleKey = 'en_US';
			portalUser.ContactId = theContact.Id;
			portalUser.isActive = true;
            portalUser.CompanyName = theContact.Community_Title__c;

			// Deprecated 6/2015 when replaced by Process Builder process
			//// added by SD 1/14 to pre-populate Company Name when user is provisioned
			//portalUser.CompanyName = cov_profile_controller.buildCompanyName(portalUser, theContact);

			// added by SD 1/15 to account for contact pre-user TOS acceptance
			// removed by SD 3/16 per Chris request so all users have to go through gateway page
			//if (theContact.myIAVA_Pre_User_TOS_Accept_Date__c != null && cov_gateway_controller.isAuthorizedToGainAccess(theContact)) {
			//	portalUser.Date_of_COV_Terms_and_Conduct_Acceptance__c = theContact.myIAVA_Pre_User_TOS_Accept_Date__c;
			//}

			portalUser.setOptions(dmo);
		}
		return portalUser;
	}
}