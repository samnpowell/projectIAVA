global class cov_facebook_reghandler implements Auth.RegistrationHandler {


//Cases covered:

//- Has existing user with same email as FB email: 
//  - if active portal user: log in as that user
//  - if inactive user: error message saying user inactive
// - if active staff user: error message saying log in with staff link


//- Has existing contact with same email as FB email:
//  - system should find the confirmed veteran if multiple records match
//  - if Portal User linked on contact record, log in as that user (as long as not inactive or staff, which would throw the appropriate errors)
//  - if contact with no portal user linked, check that the contact is authorized to join. 
//    - if not authorized, reject user with error message
//    - if authorized, provision user and log in


//- Has no existing contact record with same email as FB email:
//  - should reject user with not authorized error message


	private Contact c;
	//private User u;

	private Contact getContactFromEmail(String theemail) {
		List<Contact> contacts =    cov_user_contact_utility.getContactsFromEmail(
										theemail
										, new String[]{'Portal_User__c', 'myIAVA_Pre_User_TOS_Accept_Date__c', 'Community_Title__c'}
										, 'order by Veteran_Member_Status__c ASC NULLS LAST limit 1'
									);
		system.debug('contacts found: ' + contacts);
		return contacts.size() > 0 ? contacts[0] : null;
	}

	private User getActiveUser(String theemail) {
		return queryUser(null, theemail, true);
	} 

	private User queryUser(Id idIn, String emailIn, Boolean limitToActiveUsers) {
		String q = 'select Id, ContactId, isActive'
				+ ', Profile.UserType, Profile.UserLicenseId, Date_of_COV_Terms_and_Conduct_Acceptance__c'
				+ ' from User where ';
		if (idIn != null) {
			q+= 'Id = \'' + idIn + '\'';
		} else if (String.isNotBlank(emailIn)) {
			q+= 'Email = \'' + emailIn + '\'';
		} else {
			cov_log_error.logDevMsg('facebook reghandler - Attempted to query for user without a parameter');
			return null;
		}
		if (limitToActiveUsers) {
			q += ' and isActive = true';
		}
		q += ' and Profile.UserType != \'Guest\' order by Preferred_User_Sort_Order__c';
		system.debug('about to query for user with this query: ' + q);
		List<User> users = Database.Query(q);
		return users.size() > 0 ? users[0] : null;
	}


	global boolean canCreateUser(Auth.UserData data) {
		c = getContactFromEmail(data.email);
		if (c == null) {
			System.debug('it doesnt appear anyone with this email is in the system that fits the criteria. rejecting.');
			throw new MyException('Sorry, we can\'t find anyone in our system with the email address on your Facebook account. If you use a different addresses intentionally, first log using your myIAVA username, then go to your profile page to link it to your Facebook account.');
			return false;
		} else {
			System.debug('Yep, found the contact. Checking if authorized. c: ' + c);
			if(cov_gateway_controller.alreadyHasPermissionSet(c) || cov_gateway_controller.isAuthorizedToGainAccess(c)) {
				return true;
			} else {	
				throw new MyException('Sorry, myIAVA access is limited at this time. Please go to http://iava.org to sign up, or if you think there is an issue with your account, contact us at myiava@iava.org so we can look into it.');
				return false;
			}
		}
	}

	global User createUser(Id portalId, Auth.UserData data){
		system.debug('createUser called');

		// first check if an active user already exists
		User u = getActiveUser(data.email);
		system.debug('user returned from getActiveUser: ' + u);
		if (u != null) {
			return checkForViableUser(u);
		}

		if(!canCreateUser(data)) {
			// error already thrown in canCreateUser method
			return null;
		}
		if (c.Portal_User__c != null) {
			System.debug('OK, in cov_facebook_reghandler.createUser and returning c.Portal_User__c: ' + c.Portal_User__c);
			return checkForViableUser(c.Portal_User__c);
		} else {
			System.debug('There doesnt seem to be a user yet for this contact. Provisioning one.');
			List<Contact> cList = new List<Contact>();
			cList.add(c);
			PortalUserProvisioning.createPortalUsers(cList);
			//c = null;
			//c = getContactFromEmail(data.email);
			//User newU = checkForViableUser(c.Portal_User__c);
			//cant use portal_user__c because its populated via a @future method, might not have happened yet
			u = getActiveUser(data.email);
			User newU = checkForViableUser(u);
			System.debug('Newly created user newU: ' + newU);
			return newU;
		}
	}

	private User checkForViableUser(Id uId) {
		return checkForViableUser(uId, true, true);
	}

	private User checkForViableUser(Id uId, Boolean rejectStaff, Boolean checkForAuthorization) {
		User u = queryUser(uId, null, false);
		return u == null ? null : checkForViableUser(u, rejectStaff, checkForAuthorization);
	}

	private User checkForViableUser(User u) {
		return checkForViableUser(u, true, true);
	}

	private User checkForViableUser(User u, Boolean rejectStaff, Boolean checkForAuthorization) {
		system.debug('about to check if user is viable: ' + u);
		if (u == null) {
			return null;
		} else if (!u.isActive) {
			throw new MyException('Sorry, your user record appears to be inactive. Please contact support at community@iava.org for help.');
			return null;			
		} else if (rejectStaff && u.Profile.UserType == 'Standard') {
			throw new MyException('Staff users should use the staff link to log in.');
			return null;
		} else {
			if(cov_gateway_controller.alreadyHasPermissionSet(u)) {
				system.debug('user seems viable and has permset already.');
				return u;
			} else { 
				if (checkForAuthorization && cov_gateway_controller.isAuthorizedToGainAccess(u)) {
					system.debug('user is authorized but needs permset. adding.');
					cov_gateway_controller.addCOVPermissionSet(u);
					system.debug('permset should have been added.');
					return u;
				} else {
					system.debug('user not authorized for access.');
					throw new MyException('Sorry, myIAVA access is limited at this time. Please go to http://iava.org to sign up, or if you think there is an issue with your account, contact us at myiava@iava.org so we can look into it.');
					return null;
				}
			}
		}

	}

	global void updateUser(Id userId, Id portalId, Auth.UserData data){

		system.debug('in updateUser and userId is: ' + userId);
		system.debug('and data received is: ' + data);
		User u = checkForViableUser(userId, false, false);
		if (u == null) {
			system.debug('Failed the viable user test');
			throw new MyException('Sorry, there is an issue with your account. Please contact us at myiava@iava.org so we can look into it.');
		} else {
			system.debug('Yes, this is a viable user');
		}

	}

	public class MyException extends Exception{}

}