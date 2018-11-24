public with sharing class cov_npsp_workaround {


	// Workaround methods for NPSP3 accounts trigger which cant insert an account
	// with a portal user as owner. So instead first create the account before inserting contact
	public static Account preInsertAdminOwnedAccount(Contact unsavedC, Boolean checkForHighVolumeUser) {
		Map<Contact, Account> oneAccountMap = preInsertAdminOwnedAccounts(new List<Contact>{unsavedC}, checkForHighVolumeUser);
		return oneAccountMap.get(unsavedC);
	}

	public static Map<Contact, Account> preInsertAdminOwnedAccounts(List<Contact> unsavedCs, Boolean checkForHighVolumeUser) {

		Map<Contact, Account> contactToAccountMap = new Map<Contact, Account>();

		Boolean doTheInsert = !checkForHighVolumeUser || UserInfo.getUserType() == 'CSPLitePortal';
		Id newOwnerId = cov_utilities.getBackgroundAdminUserId();
		if (doTheInsert && newOwnerId != null) {

			List<Account> accountsToInsert = new List<Account>();

			for (Contact unsavedC : unsavedCs) {

				// This code adapted from 
				// https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/ACCT_IndividualAccounts_TDTM.cls#L535

				ID rtIdAcccount = cov_npsp_classes.rtIdForNewAccount();

				// construct the individual account for the Contact
				Account a = new Account();

				// construct the Account name
		        a.Name = cov_npsp_classes.isHHAccountModel() ? cov_npsp_classes.strNameHHAccountForContact(unsavedC) : cov_npsp_classes.strNameOne2OneAccountForContact(unsavedC);

				//connect the Account to the Contact for 1:1 and HHAccount
				if (unsavedC.Id != null) {
					a.npe01__One2OneContact__c = unsavedC.Id;
				}
				a.Phone = unsavedC.Phone;
				a.Fax = unsavedC.Fax;
				//ADDR_Addresses_TDTM.copyAddressStdSObj(unsavedC, 'Mailing', a, 'Billing');
				//ADDR_Addresses_TDTM.copyAddressStdSObj(unsavedC, 'Other', a, 'Shipping');
				cov_npsp_classes.copyAddressStdSObj(unsavedC, 'Mailing', a, 'Billing');
				cov_npsp_classes.copyAddressStdSObj(unsavedC, 'Other', a, 'Shipping');

				//a.npe01__SYSTEM_AccountType__c = cov_npsp_classes.isHHAccountModel() ? cov_npsp_classes.HH_ACCOUNT_TYPE : cov_npsp_classes.ONE_TO_ONE_ORGANIZATION_TYPE;
				// Nov 2016 workaround for new bug: set account type to BUCKET_ORGANIZATION_TYPE to prevent it from getting cleared by NPSP triggers
				a.npe01__SYSTEM_AccountType__c = cov_npsp_classes.isHHAccountModel() ? cov_npsp_classes.HH_ACCOUNT_TYPE : cov_npsp_classes.BUCKET_ORGANIZATION_TYPE;
				
				if (rtIdAcccount != null) {                
					a.put('RecordTypeID', rtIdAcccount);
				}                
				a.Type = cov_npsp_classes.isHHAccountModel() ? cov_npsp_classes.HH_TYPE : '';
				a.npe01__SYSTEMISINDIVIDUAL__c = true;

				a.OwnerId = newOwnerId;

				accountsToInsert.add(a);
			}

			Database.SaveResult[] srs = cov_nosharing_utilities.runDatabaseInsert(accountsToInsert, false);
			Map<Id, Account> idToAccountMap = new Map<Id, Account>(accountsToInsert);
	        Integer errorCount = 0; 
			for (Integer i = 0; i < accountsToInsert.size(); i++) {
		        if (srs[i].isSuccess()) {
			        // Operation was successful, so get the record that was processed
			        System.debug('Successfully inserted account ID: ' + srs[i].getId());
			        accountsToInsert[i].Id = srs[i].getId();
			    } else {
			        System.debug('Error inserting account: ' + srs[i].getErrors()[0].getMessage());
			    	errorCount++;
			    }
		        contactToAccountMap.put(unsavedCs[i], accountsToInsert[i]);
			}
	        if (errorCount > 0) {
	        	cov_log_error.logDevMsg(errorCount + ' error(s) inserting an account for a portal user without sharing rules.');
	        }
		}

        return contactToAccountMap;

	}

	public static Account postUpdateAccountOne2OneContact(Account aIn, Contact cIn) {
		List<Account> oneAccountList = postUpdateAccountOne2OneContacts(new List<Account>{aIn}, new List<Contact>{cIn});
		return oneAccountList != null && oneAccountList.size() > 0 ? oneAccountList[0] : null;
	}

	public static List<Account> postUpdateAccountOne2OneContacts(List<Account> accountsIn, List<Contact> contactsIn) {
		//system.debug('ok going to update the account: ' + aIn);
		//system.debug('with this contact Id: ' + cIn);
		if (accountsIn == null || contactsIn == null || accountsIn.size() != contactsIn.size()) {
			cov_log_error.logDevMsg('Was going to update one2one accounts with contact Id but lists are null or different lengths.');
			return null;
		} else {
			List<Account> successfulUpdates = new List<Account>();
			for (Integer i = 0; i < accountsIn.size(); i++) {
				if (contactsIn[i] != null) {
					accountsIn[i].npe01__One2OneContact__c = contactsIn[i].Id;
					// Nov 2016 workaround for new bug: set pre-inserted Account back to One-to-One type
					// since had to set it to Bucket in order to get the contact inserted
					accountsIn[i].npe01__SYSTEM_AccountType__c = cov_npsp_classes.ONE_TO_ONE_ORGANIZATION_TYPE;
				}
			}
			Database.SaveResult[] srs = cov_nosharing_utilities.runDatabaseUpdate(accountsIn, false);
	        Integer errorCount = 0; 
	        String errorIds = '';
			for (Integer i = 0; i < srs.size(); i++) {
		        if (srs[i].isSuccess()) {
		        	successfulUpdates.add(accountsIn[i]);
		        } else {
			        System.debug('Error updating account: ' + srs[i].getErrors()[0].getMessage());
			    	errorCount++;
			    	errorIds += contactsIn[i].Id + ';';
			    }
			}
	        if (errorCount > 0) {
	        	cov_log_error.logDevMsg(errorCount + ' error(s) Error updating One2OneContact fields on account for contact Id(s): ' + errorIds);
	        }
	        return successfulUpdates;
		}
	}


}