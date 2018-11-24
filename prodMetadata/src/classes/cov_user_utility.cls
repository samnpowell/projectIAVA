/*
	* Utility class to get the user and contact only once per transaction
	* for all pages that need it
	* 
	* Adapted from "Simple Apex Singleton Strategy" at
	* http://www.tgerm.com/2010/03/apex-implementing-singleton-design.html
*/

public class cov_user_utility {

	public static User u;
	public static Contact c;
	public static Id cId;
	public Id networkId;
	public static boolean isMobile;
	public static boolean isSandbox;
	public static String currentURLencoded;
	public static String portalLoginBaseUrl;
	public static Boolean isMemberVeteran {get; set;}
	public static Boolean isConfirmed {get; set;}
	public static Boolean isNonVeteran {get; set;}

	// Keep track of which chatter follow tags have been
	// displayed so as not to trigger a VF error by
	// displaying one for the same entity twice
	public Map<Id, Boolean> followTagsDisplayed {get; private set;}



  /*
    Note: this is the static handle to the single class reference.
    Its set accessor is made private to dis-allow any modifications to the reference
  */
  public static cov_user_utility self {get; private set;}
   
  static {
    // Static block used for transparent Singleton setup. the "self" static variable
    // will be ready as soon as class will be loaded in memory.
    self = new cov_user_utility(); 
  }
   
  // NOTE: the constructor is marked "PRIVATE"
  // so that no Apex code outside this class can create
  // the instance

  private cov_user_utility() {
  	initializeUserUtility(UserInfo.getUserId());
  }

  private void initializeUserUtility(Id userId) {

    // Do all the non DML initalization here
    // If DML code is required, use Advanced version 
    // of this code on the page linked above
			System.debug('in the cov_user_utility constructor');
			u = [Select 
						Id
						, ContactId
						, Username
						, AboutMe
						, Contact.MailingPostalCode
						, SmallPhotoUrl
						, FullPhotoUrl
						, Date_of_first_COV_login__c
						, Date_of_COV_Terms_and_Conduct_Acceptance__c
						, UserPermissionsChatterAnswersUser
						, Profile.UserType
						, Profile.UserLicenseId
				 		from User
				 		where isActive = true 
				 		and Id = :userId
				 		];
	 		System.debug('u: ' + u);

//	 		c = getContactFromUser(u);
			c = cov_user_contact_utility.getContactFromUser(u);

			isMemberVeteran = false;
			isConfirmed = false;
			if (c != null) {
				if (c.Member_Categories__c.replace('Unconfirmed', '').contains('Confirmed')) {
					isMemberVeteran = true;
					isConfirmed = true;
					isNonVeteran = false;
				} else if (c.Member_Categories__c.contains('Non-veteran')) {
					isNonVeteran = true;
					isMemberVeteran = false;
				} else if (c.Member_Categories__c.contains('Unconfirmed')) {
					isMemberVeteran = true;
					isNonVeteran = false;
				}  else {
					isMemberVeteran = false;
				}
			}

	 		// MOVED TO SEPARATE FUNCTION SO IT CAN BE CALLED ON ANOTHER USER
//	 		String criteria = '';
//			if (u.ContactId != null) {
//				System.debug('u.ContactId is not null now. In fact it is: ' + u.ContactId);
//				criteria = 'Id = \'' + u.ContactId + '\'';
////				c = u.Contact;
//			} else {
//				// find another contact record that points to this user (for staff users)
//				criteria = 'Portal_User__c = \'' + UserInfo.getUserId() + '\'';
//			}

//			try {
//				System.debug('UserInfo.getUserId(): ' + UserInfo.getUserId());
//				String q = 'select Id, Email, Portal_User__c, Member_Categories__c from Contact where ' + criteria + ' limit 1';
//				System.debug('q from cov_user_utility: ' + q);
//				c = Database.query(q);
//				System.debug('c from cov_user_utility: ' + c);


//			} catch(QueryException e){
//				System.debug('e: ' + e);
//			}
//			if (c != null) {
//				System.debug('c: ' + c);
//			} else {
//				System.debug('No corresponding contact found for user: ' + u);
//			}

			networkId = Network.getNetworkId();
			System.debug('networkId: ' + networkId);
			if (Test.isRunningTest()) {
				networkId = [select id from Network where (Name like '%COV%' or Name like '%IAVA%') limit 1].id;
				// TODO: the above line will bonk if the Community doesnt have COV or IAVA in the name
				System.debug('networkId in test context: ' + networkId);
			}

			followTagsDisplayed = new Map<Id, Boolean>();
  }

  //public static Contact getContactFromUser(User theU) {
  //	cov_user_utility cuu = new cov_user_utility()
  //}

//  private Contact getContactFromUser(User theU) {
// 		String criteria = '';
//		if (theU.ContactId != null) {
//			System.debug('theU.ContactId is not null now. In fact it is: ' + theU.ContactId);
//			criteria = 'Id = \'' + theU.ContactId + '\'';
////				c = u.Contact;
//		} else {
//			// find another contact record that points to this user (for staff users)
//			criteria = 'Portal_User__c = \'' + theU.Id + '\'';
//		}

//		Contact theC;
//		try {
//			System.debug('UserInfo.getUserId(): ' + UserInfo.getUserId());
//			String q = 'select Id, Email, Portal_User__c, Member_Categories__c from Contact where ' + criteria + ' limit 1';
//			System.debug('q from cov_user_utility: ' + q);
//			theC = Database.query(q);
//			System.debug('theC from cov_user_utility: ' + theC);


//		} catch(QueryException e){
//			System.debug('e: ' + e);
//		}
//		if (theC != null) {
//			System.debug('theC: ' + theC);
//		} else {
//			System.debug('No corresponding contact found for user: ' + theU);
//		}	
//		return theC;
//  }
   

  
  public User getU() {
  	if (UserInfo.getUserId() !=  u.Id) { refreshSelf(); }
  	return u;
  }

  public Contact getC() {
  	return c;
  }

  public Boolean getIsMemberVeteran() {
  	return isMemberVeteran;
  }

  public Boolean getIsConfirmed() {
  	return isConfirmed;
  }

  public Boolean getIsNonVeteran() {
  	return isNonVeteran;
  }

  public Contact getC(String additionalField) {
  	return cov_user_contact_utility.getContactFromUser(u, new List<String>{additionalField});
  }

  public Contact getC(List<String> additionalFields) {
  	c = cov_user_contact_utility.getContactFromUser(u, additionalFields);
  	return c;
  }

  public Id getCId() {
  	return c == null ? null : c.Id;
  }

  public Id getNetworkId() {
  	return networkId;
  }

  public Boolean getIsMobile() {
  	if (ApexPages.currentPage() == null) {
  		return false;
  	} else {
	  	return isMobile(ApexPages.currentPage().getHeaders().get('USER-AGENT'));
	}
  }

  public Boolean getIsSandbox() {
  	if (isSandbox == null) {
  		List<Organization> orgs = [select Id, IsSandbox from Organization limit 1];
  		if (orgs.size() > 0) {
  			isSandbox = orgs[0].isSandbox;
  		}
  	}
  	return isSandbox;
  }

  public cov_user_utility freshSelf() {
  	self = new cov_user_utility();
  	return self;
  }

  public void refreshSelf() {
  	self = new cov_user_utility();
  }
 
  // Allows classes to check whether a chatter follow tag
  // for a certain user has already been displayed
  // so as not to trigger a VF error by displaying
  // one for the same entity twice

  public Boolean displayFollowTagChecker(Id theId) {

  		if (theId == null) {
			System.debug('returning false. Id was null. followTagsDisplayed: ' + followTagsDisplayed);
			return false; 			
  		} else if (followTagsDisplayed.containsKey(theId) == false) {
			followTagsDisplayed.put(theId, false);
			System.debug('returning true. Id ' + theId + ' was not in followTagsDisplayed but now should be: ' + followTagsDisplayed);
			return true;
		} else { // theId was already present in the Set
			System.debug('returning false. Id ' + theId + ' was already in followTagsDisplayed');
			return false;
		}

  }

	public static boolean IsProduction() {
		return ( UserInfo.getOrganizationId() == '00D80000000d0vO' );
	}

	// http://www.cesabarre.com/2012/04/get-visual-force-page-name-within-apex.html
	public static String getPageName() {
		String pageName = ApexPages.CurrentPage().getUrl();
		pageName = pageName.replaceFirst('/apex/','');
		pageName = EncodingUtil.urlEncode(pageName, 'UTF-8');
		string[] pageNameExtra = pageName.split('%3F',0);
		pageName = pageNameExtra[0];
		return pageName;
	}


	public static boolean IDisvalid(String theID) {
		Id returnID;
		try {
			returnID = theID;
			System.debug('********** ID \'' + theID + '\' is valid');
			return true;
		} catch (System.StringException e) {
			System.debug('********** ID \'' + theID + '\' is not valid');
			return false;
		}
	}

	//public static boolean hasSObjectField(String fieldName, SObject so){
	//// from http://fastdevforce.wordpress.com/2014/02/14/apex-tip-check-if-field-exists-on-sobject/

	//	String s = JSON.serialize(so);
	//	// Deserialize it back into a key/value map
	//	Map<String,Object> obj = (Map<String,Object>) JSON.deserializeUntyped(s);

	//	// Build a set containing the fields present on our SObject
	//	Set<String> fieldsPresent = obj.keyset().clone();

	//	return fieldsPresent.contains(fieldName);
	//}	

	public boolean isMobile() {
		return isMobile(ApexPages.currentPage().getHeaders().get('USER-AGENT'));
	}

	public boolean isMobile(String userAgentString) {
	// From Dave Manelski / Power of Us Hub
		//system.debug('USER AGENT STRING: ' + userAgentString);
		//Using RegEx, figure out if the user is on a mobile device based on the user-agent string
        if (userAgentString == null)  return false;
        Pattern p = Pattern.compile('Mobile|iP(hone|od|ad)|Android|BlackBerry|IEMobile|Kindle|NetFront|Silk-Accelerated|(hpw|web)OS|Fennec|Minimo|Opera M(obi|ini)|Blazer|Dolfin|Dolphin|Skyfire|Zune');
        Matcher pm = p.matcher( userAgentString );

        return pm.find();
        
	}

	public String getPageUrl() {
		String pageUrl = ApexPages.currentPage().getUrl();
    	if (pageUrl.left(5) == '/apex') {
    		pageUrl = pageUrl.right(pageUrl.length() - 5);
    	}
    	return pageUrl;
	}

    public String getCurrentEncodedUrlWithBase() {
    	String pageUrl = getPageUrl();
    	return EncodingUtil.urlEncode(Site.getBaseSecureUrl() + pageUrl, 'UTF-8');
    }

    public String getCurrentEncodedUrlWithoutBase() {
    	String pageUrl = getPageUrl();
    	return EncodingUtil.urlEncode(Site.getPathPrefix() + pageUrl, 'UTF-8');
    }

    public String getPortalLoginBaseUrl() {
		IAVAPlus_Portal_Settings__c ps = IAVAPlus_Portal_Settings__c.getInstance('IAVA');
		return ps == null ? '' : ps.Secure_Site_URL__c;
	}


}