public with sharing class cov_npsp_classes {

	/*
    * These classes are taken from NPSP managed package. 
    * Ideally we would just tap into the NPSP classes directly
    * but they are defined as public instead of global, so they
    * cannot be accessed from outside of the managed package.
    *
    * Of course the code here (originally copied/adapted in April 2016)
    * will not continue to get future NPSP3 updates so should either be
    * periodically updated, or even better should be eliminated once
    * no longer necessary.
    *
    * The original reason for adding is as a workaround to an issue in
    * the NPSP3 accounts trigger where it cant insert an account
	* with a portal user as owner. So instead we need to first create 
	* the account before inserting contact. These NPSP3 classes are necessary
	* to help determine which NPSP model is in use.
	*
	* - SD
    */


    // https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/CAO_Constants.cls
	/**
	* @author Salesforce.org
	* @date 2011 (1.x)
	* @group Accounts
	* @description Constants and helper methods used for common settings in npe01: account model, default contact role, etc. 
	*/

    /*******************************************************************************************************
    * @description One-to-One value for system processor field
    */ 
    public static final String ONE_TO_ONE_PROCESSOR = 'One-to-One';

    /*******************************************************************************************************
    * @description One-to-One org type value
    */ 
    public static final String ONE_TO_ONE_ORGANIZATION_TYPE = 'One-to-One Individual';

    /*******************************************************************************************************
    * @description Individual Bucket value for system processor field
    */ 
    public static final String BUCKET_PROCESSOR = 'Individual';

    /*******************************************************************************************************
    * @description Individual Bucket org type value
    */ 
    public static final String BUCKET_ORGANIZATION_TYPE = 'Bucket Individual';

    /*******************************************************************************************************
    * @description Individual Bucket Account name
    */ 
    public static String BUCKET_ACCOUNT_NAME = 'Individual';

    /*******************************************************************************************************
    * @description Household Account value for system processor field
    */ 
    public static final String HH_ACCOUNT_PROCESSOR = 'Household Account';

    /*******************************************************************************************************
    * @description Household Account org type value
    */ 
    public static final String HH_ACCOUNT_TYPE = 'Household Account';

    /*******************************************************************************************************
    * @description Household Account value for the standard Type field
    */ 
    public static final string HH_TYPE = 'Household';

    /*******************************************************************************************************
    * @description A contact's firstname to use in test code.
    */ 
    public static  string CONTACT_FIRSTNAME_FOR_TESTS = 'test';

    /*******************************************************************************************************
    * @description A contact's lastname to use in test code.
    */ 
    public static  string CONTACT_LASTNAME_FOR_TESTS = 'Contact_forTests';

    /*******************************************************************************************************
    * @description A contact's email to use in test code.
    */ 
    public static  string CONTACT_EMAIL_FOR_TESTS = 'junk@test.net';

    /*******************************************************************************************************
    * @description A contact's preferred email to use in test code.
    */ 
    public static  string CONTACT_PREFERRED_EMAIL_FOR_TESTS = 'Work';

    /*******************************************************************************************************
    * @description A contact's phone number to use in test code.
    */ 
    public static  string CONTACT_PHONE_FOR_TESTS = '206-777-8888';

    /*******************************************************************************************************
    * @description A contact's preferred phone to use in test code.
    */ 
    public static  string CONTACT_PREFERRED_PHONE_FOR_TESTS = 'Work';
    
    /*******************************************************************************************************
    * @description The name to use for the Individual Bucket Account in test code.
    */ 
    public static  string INDIVIDUAL_ACCOUNT_NAME_FOR_TESTS = 'IndividualAccountNameForTests';

    /*******************************************************************************************************
    * @description Returns whether we are in the One-to-One Account Model
    * @return  boolean
    */ 
    public static boolean isOneToOne() {
        //if no settings exist, create defaults
        //if (UTIL_CustomSettingsFacade.getContactsSettings().npe01__Account_Processor__c==ONE_TO_ONE_PROCESSOR) {
        if (getContactsSettings().npe01__Account_Processor__c==ONE_TO_ONE_PROCESSOR) {
            return true;
        } else {
            return false;
        }
    }

    /*******************************************************************************************************
    * @description Returns whether we are in the Individual Bucket Account Model
    * @return  boolean
    */ 
    public static boolean isBucketModel() {
        //return (UTIL_CustomSettingsFacade.getContactsSettings().npe01__Account_Processor__c == BUCKET_PROCESSOR);
        return (getContactsSettings().npe01__Account_Processor__c == BUCKET_PROCESSOR);
    }

    /*******************************************************************************************************
    * @description Returns whether we are in the Household Account Model
    * @return  boolean
    */ 
    public static boolean isHHAccountModel() {
        //return (UTIL_CustomSettingsFacade.getContactsSettings().npe01__Account_Processor__c == HH_ACCOUNT_PROCESSOR);
        return (getContactsSettings().npe01__Account_Processor__c == HH_ACCOUNT_PROCESSOR);
    }    



    // https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/UTIL_CustomSettingsFacade.cls#L41
	static npe01__Contacts_And_Orgs_Settings__c contactsSettings;

    // https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/UTIL_CustomSettingsFacade.cls#L54
	static npe01__Contacts_And_Orgs_Settings__c orgContactsSettings;


 	// https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/UTIL_CustomSettingsFacade.cls#L72
 	/*******************************************************************************************************
    * @description Returns the default Contacts and Orgs settings. 
    * @return npe01__Contacts_And_Orgs_Settings__c Custom settings record for Contacts and Orgs configuration. 
    * At the org level, if no user level settings are defined. The ID field should be checked to determine if 
    * the returned record already exists or doesn't exist in the database.      
    */
    public static npe01__Contacts_And_Orgs_Settings__c getContactsSettings() {
        if(Test.isRunningTest() && contactsSettings == null) {
        	contactsSettings = new npe01__Contacts_And_Orgs_Settings__c();
        	configContactsSettings(contactsSettings);
        } else if (contactsSettings == null) {
            contactsSettings = npe01__Contacts_And_Orgs_Settings__c.getInstance();
            if(contactsSettings.Id == null)
                contactsSettings = getOrgContactsSettings();
        }    
        return contactsSettings;
    }


	// https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/UTIL_CustomSettingsFacade.cls#L90
    /*******************************************************************************************************
    * @description Returns the default Households settings. 
    * @return npo02__Households_Settings__c Custom settings record for Households configuration. At the org level, 
    * if no user level settings are defined. The ID field should be checked to determine if the returned record 
    * already exists or doesn't exist in the database.
    */
    //public static npo02__Households_Settings__c getHouseholdsSettings() {
    //    if(Test.isRunningTest() && householdsSettings == null) {
    //        householdsSettings = new npo02__Households_Settings__c();
    //        configHouseholdSettings(householdsSettings);
    //    } else if (householdsSettings == null) {
    //        householdsSettings = npo02__Households_Settings__c.getInstance();
    //        if(householdsSettings.Id == null)
    //            householdsSettings = getOrgHouseholdsSettings();
    //    }  
    //    return householdsSettings;
    //}


    // https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/UTIL_CustomSettingsFacade.cls#L463
    /*******************************************************************************************************
     * Private methods that will configure the default org-level custom settings.
     **/
    private static void configContactsSettings(npe01__Contacts_And_Orgs_Settings__c cs) {
        //this setting does nothing, but needs to be extracted from the tests before removing
        cs.npe01__Enable_Opportunity_Contact_Role_Trigger__c = false;
        cs.npe01__Payments_Enabled__c  = true;
        cs.npe01__Opportunity_Contact_Role_Default_role__c = 'Donor';
        //cs.npe01__Account_Processor__c = CAO_Constants.HH_ACCOUNT_PROCESSOR;
        cs.npe01__Account_Processor__c = HH_ACCOUNT_PROCESSOR;
        //cs.Opp_RecTypes_Excluded_for_Payments__c = null;
        //cs.Opp_Types_Excluded_for_Payments__c = null;
        //Recordtypeinfo householdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(CAO_Constants.HH_ACCOUNT_PROCESSOR);
        Recordtypeinfo householdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(HH_ACCOUNT_PROCESSOR);
        if(householdAccount != null)
            cs.npe01__HH_Account_RecordTypeID__c = householdAccount.getRecordTypeId();
    }

    // https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/UTIL_CustomSettingsFacade.cls#L275
    /*******************************************************************************************************
    * @description Returns the org-level Contacts and Orgs settings. Default org-level settings will be created 
    * if none exist. Meant to be called only from settings page and install script.
    * @return npe01__Contacts_And_Orgs_Settings__c Org-level settings for Contacts and Orgs.
    */
    public static npe01__Contacts_And_Orgs_Settings__c getOrgContactsSettings() {
        if(orgContactsSettings == null) {
            orgContactsSettings = npe01__Contacts_And_Orgs_Settings__c.getOrgDefaults();
            if(orgContactsSettings.Id == null) {
                configContactsSettings(orgContactsSettings);
                orgContactsSettings.Setupownerid = UserInfo.getOrganizationId();
                if(!Test.isRunningTest())
                    upsert orgContactsSettings;
            }
        }
        return orgContactsSettings;
    }


    // https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/ACCT_IndividualAccounts_TDTM.cls#L827
    /*******************************************************************************************************
    * @description returns the default name for a new HH Account. Custom household naming will update this 
    * account later if enabled, but we still need one if not enabled.
    * @param con the Contact
    * @return string. the Household account name
    */ 
    public static String strNameHHAccountForContact(Contact con) {
        return con.LastName + ' ' + system.label.npo02.DefaultHouseholdName;
    }

    /*******************************************************************************************************
    * @description returns the default name for a new 1:1 Account 
    * @param con the Contact
    * @return string. the 1:1 account name
    */ 
    public static String strNameOne2OneAccountForContact(Contact con) {
        String str = '';
        
        if (con.FirstName != null) {
            str += con.FirstName;
            str += ' ' ;
        }                
        //if (EasternOrderLanguages.contains(OrgLanguage))
        //    str = con.LastName + ' ' + str;
        //else
            str += con.LastName;
        
        return str;
    }

    // https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/ADDR_Addresses_TDTM.cls#L995
    /*******************************************************************************************************
    * @description Utility to copy Address fields between Contacts and Accounts (or vice-versa).
    * Handles instances where State and Country picklists are enabled, and multiline street addresses.
    * @param sobjSrc the source Contact or Account
    * @param strFieldPrefixSrc the address fields to copy from, ie., Mailing, Other, Shipping, Billing
    * @param sobjDst the destination Contact or Account
    * @param strFieldPrefixDst the address fields to copy to, ie., Mailing, Other, Shipping, Billing
    * @return void
    */ 
    public static void copyAddressStdSObj(sobject sobjSrc, string strFieldPrefixSrc, sobject sobjDst, string strFieldPrefixDst) {
        sobjDst.put(strFieldPrefixDst + 'Street', sobjSrc.get(strFieldPrefixSrc + 'Street'));
        sobjDst.put(strFieldPrefixDst + 'City', sobjSrc.get(strFieldPrefixSrc + 'City'));
        sobjDst.put(strFieldPrefixDst + 'PostalCode', sobjSrc.get(strFieldPrefixSrc + 'PostalCode'));
        sobjDst.put(strFieldPrefixDst + 'State', sobjSrc.get(strFieldPrefixSrc + 'State'));
        sobjDst.put(strFieldPrefixDst + 'Country', sobjSrc.get(strFieldPrefixSrc + 'Country'));
        sobjDst.put(strFieldPrefixDst + 'Latitude', sobjSrc.get(strFieldPrefixSrc + 'Latitude'));
        sobjDst.put(strFieldPrefixDst + 'Longitude', sobjSrc.get(strFieldPrefixSrc + 'Longitude'));

        if (isStateCountryPicklistsEnabled) {
            sobjDst.put(strFieldPrefixDst + 'StateCode', sobjSrc.get(strFieldPrefixSrc + 'StateCode'));
            sobjDst.put(strFieldPrefixDst + 'CountryCode', sobjSrc.get(strFieldPrefixSrc + 'CountryCode'));
        }    
        //UTIL_Debug.debug('****DJH: copyAddressStdSObj: ' + sobjSrc + ' ' + sobjDst);
    }



    // https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/ADDR_Addresses_TDTM.cls#L48
	/*******************************************************************************************************
    * @description map from Country name to Country Code
    */
    private static Map<String, String> validCountriesByLabel = new Map<String, String>();

    /*******************************************************************************************************
    * @description map from State name to State Code
    */
    private static Map<String, String> validStatesByLabel = new Map<String, String>();

    /*******************************************************************************************************
    * @description map from Country Code to Country Name
    */
    private static Map<String, String> validCountriesByCode = new Map<String, String>();


    // https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/ADDR_Addresses_TDTM.cls#L1114
    /*******************************************************************************************************
    * @description specifies whether state and country picklists are enabled in this org.
    * @return true if enabled
    */ 
    public static Boolean isStateCountryPicklistsEnabled {
        get {
        	if (isStateCountryPicklistsEnabled == null)
                isStateCountryPicklistsEnabled = initValidStateCountryCodes();
            return isStateCountryPicklistsEnabled;
        }
        private set;
    }

    /*******************************************************************************************************
    * @description utility to determine if the "State and Country Picklist" field feature is enabled in Salesforce
    * @return true if enabled; Fills 4 sets<> with a list of value codes and labels for each field
    */ 
    private static Boolean initValidStateCountryCodes() {

        // If State & Country Picklists are enabled in the org, build maps of the
        // valid Labels and Codes for each field to use for validation
        map<String, Schema.SObjectField> acctFields = Account.getSobjectType().getDescribe().fields.getMap();
        boolean isCodesEnabled = acctFields.containsKey('BillingCountryCode');
        if (isCodesEnabled) {
            list<Schema.Picklistentry> countryPLValues = acctFields.get('BillingCountryCode').getDescribe().getPicklistValues();
            for (Schema.Picklistentry p : countryPLValues) {
                if (p.isActive()) { 
                    validCountriesByLabel.put(p.getLabel(), p.getValue()); 
                    validCountriesByCode.put(p.getValue(), p.getLabel());
                }
            }
            list<Schema.Picklistentry> statePLValues = acctFields.get('BillingStateCode').getDescribe().getPicklistValues();
            for (Schema.Picklistentry p : statePLValues) {
                if (p.isActive()) { 
                    validStatesByLabel.put(p.getLabel(), p.getValue());
                    // we can't have a map of valid StateCodes, because they are not unique.
                    // ideally we would have a map of CountryCode + StateCode -> StateLabel
                    // but Salesforce provides us no way of figuring out picklist dependencies efficiently. 
                }
            }
        }
        return isCodesEnabled;
    }

	// https://github.com/SalesforceFoundation/Cumulus/blob/dev/src/classes/ACCT_IndividualAccounts_TDTM.cls#L470
    /*******************************************************************************************************
    * @description utility to return the recordtypeId for a new account, given the account model. 
    * @return Id. if none is explicitly specified, returns null.
    */ 
    public static ID rtIdForNewAccount() {
    	//return rtIdForAccountModel(CAO_Constants.isHHAccountModel());
    	return rtIdForAccountModel(isHHAccountModel());
    }

    /*******************************************************************************************************
    * @description utility to return the recordtypeId for a new account, given the account model. 
    * @param isHHAccountModel whether we are using the Household Account Model
    * @return Id. recordtype Id to use, or null if none is specified for the account model.
    */ 
    public static ID rtIdForAccountModel(boolean isHHAccountModel) {
        //ContactsSettings = UTIL_CustomSettingsFacade.getContactsSettings();
        ContactsSettings = getContactsSettings();
        Schema.Recordtypeinfo rtById = null;
        // check if recordtypes are enabled, and if it matches the existing setting
        // we go thru describe to validate that it is a valid recordType ID.
        ID rtId = isHHAccountModel ? ContactsSettings.npe01__HH_Account_RecordTypeID__c : ContactsSettings.npe01__One_to_One_RecordTypeID__c;
        if (rtId != null) {
            Schema.DescribeSObjectResult R = Account.SObjectType.getDescribe();
            Map<Id,Schema.RecordTypeInfo> rtMapById = r.getRecordTypeInfosById();
            rtById = rtMapById.get(rtId);
            return (rtById == null ? null : rtById.getRecordTypeID());            
        }
        return null;
    }



}