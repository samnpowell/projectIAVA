@isTest
public class cov_user_TEST_utility {

	public User portaluser;
	public User internaluser;
	public Contact portalcontact;
	public Contact internalcontact;
  public PermissionSet permSetExternal;
  public PermissionSet permSetInternal;

	public User getPortalUser() {
    return getPortalUser(false);
  }

  public User getPortalUserWithEmail() {
    return getPortalUser(true);
  }

  public User getPortalUser(Boolean withEmail) {
    System.debug('** about to get Portal User and portaluser: ' + portaluser);
		if (portaluser == null) {
      System.debug('** portaluser is null');
			setUpTestUser(true, withEmail);
		}
      System.debug('** Returning test portal user: ' + portaluser);
  		return portaluser;
  }

  public User getPortalUserWithoutPerm() {
    System.debug('** about to get Portal User and portaluser: ' + portaluser);
    if (portaluser == null) {
      System.debug('** portaluser is null');
      setUpTestUser(false);
    }
      System.debug('** Returning test portal user: ' + portaluser);
      return portaluser;
  }

  public Contact getPortalContact() {
    return getPortalContact(false);
  }

  public Contact getPortalContactWithEmail() {
    return getPortalContact(true);
  }

  public Contact getPortalContact(Boolean withEmail) {
    System.debug('** about to get Portal Contact');
		if (portaluser == null) {
			setUpTestUser(true, withEmail);
		}
      System.debug('** Returning test portal contact: ' + portalcontact);
  		return portalcontact;
  }

	public User getInternalUser() {
		if (internaluser == null) {
			setUpTestInternalUser();
		}
  		return internaluser;
  }

  public Contact getInternalContact() {
		if (internaluser == null) {
			setUpTestInternalUser();
		}
  		return internalcontact;
  }

  public PermissionSet getPermSetExternal() {
    if (permSetExternal == null) {
      permSetExternal = setUpTestPermSetExternal();
    }
      return permSetExternal;
  }

  public PermissionSet getPermSetInternal() {
    if (permSetInternal == null) {
      permSetInternal = setUpTestPermSetInternal();
    }
      return permSetInternal;
  }

    public void setUpTestUser(Boolean withPermSet) {
      setUpTestUser(withPermSet, false);
    }

    public void setUpTestUser(Boolean withPermSet, Boolean withEmail) {

        System.debug('** About to setUpTestUser()');
        portalcontact = new Contact(LastName='Utility Test 1');
        if (withEmail) {
          String emailstring = String.valueof(System.now()).replaceAll(' ', '').replaceAll(':','') + '@iava.org';
          portalcontact.Email = emailstring;
        }
        System.debug('About to insert portalcontact');
		    insert portalcontact;        
        System.debug('portalcontact inserted');
        
        Profile p = [SELECT Id, UserLicenseId FROM Profile WHERE Name='IAVA Plus Portal User']; 

        portaluser = new User(LastName='TestUser',
        					isActive = true,
        					ProfileId = p.Id,
        					Username = withEmail ? portalcontact.email : 'u' + portalcontact.Id + '@iava.org',
        					// used portalcontact.Id in username to keep it unique between users
                  Email = withEmail ? portalcontact.email : 'u' + portalcontact.Id + '@iava.org',
        					Alias = 'unittstr',
        					CommunityNickname = 'u'+ portalcontact.Id,
        					emailencodingkey = 'UTF-8',
                           languagelocalekey = 'en_US',
                           localesidkey = 'en_US',
                           timezonesidkey = 'America/New_York',
                           ContactId=portalcontact.Id
                           );
        System.debug('About to insert portaluser');

        insert portaluser;
        System.debug('portaluser inserted');

        if (withPermSet) {
          PermissionSet ps = getPermSetExternal();
          //System.debug('permSetExternal after getPermSetExternal(): ' + permSetExternal);
  //        PermissionSet ps = [select id from PermissionSet where Label Like 'COV Access%' and UserLicenseId = :portaluser.Profile.UserLicenseId];
          PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = portaluser.id, PermissionSetId = ps.id);
          
          System.runAs ( new User(Id = UserInfo.getUserId()) ) {
        System.debug('About to insert permset');
          // to avoid mixedDML error (http://salesforce.stackexchange.com/questions/13318/error-mixed-dml-operation-on-setup-and-non-setup-objects)
              insert psa;
          }
          System.debug('psa inserted: ' + psa);
        }


        // shouldnt have to do this, trigger should do it.
        // but seems like trigger isnt setting portal user during unit tests
        System.debug('** About to set portal_user__c on Contact ' + portalcontact.Id + ' to ' + portaluser.Id);
        portalcontact.Portal_User__c = portaluser.id;
        update portalcontact;
        System.debug('contact updated with portal_user__c');


//		return u;

    }


    public void setUpTestInternalUser() {


        internalcontact = new Contact(LastName='Utility Test 2');
    		insert internalcontact;        

        
        Profile p = [SELECT Id, UserLicenseId FROM Profile WHERE Name='Membership']; 

        internaluser = new User(LastName='TestUser 2',
        					isActive = true,
        					ProfileId = p.Id,
        					Username = 'u' + internalcontact.Id + '@iava.org',
        					Email = 'covdev@iava.org',
        					Alias = 'unittst2',
        					CommunityNickname = 'u'+ internalcontact.Id,
        					emailencodingkey = 'UTF-8',
                           languagelocalekey = 'en_US',
                           localesidkey = 'en_US',
                           timezonesidkey = 'America/New_York'
                           );

        insert internaluser;


        PermissionSet ps = getPermSetInternal();
//        PermissionSet ps = [select id from PermissionSet where Label Like 'COV Access%' and UserLicenseId = :internaluser.Profile.UserLicenseId];
        PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = internaluser.id, PermissionSetId = ps.id);
        System.runAs ( new User(Id = UserInfo.getUserId()) ) {
        // to avoid mixedDML error (http://salesforce.stackexchange.com/questions/13318/error-mixed-dml-operation-on-setup-and-non-setup-objects)
          insert psa;
        }
        System.debug('PermissionSetAssignment inserted: ' + psa);

  		  internalcontact.Portal_User__c = internaluser.id;
  		  update internalcontact;



//		return u;

    }

    public PermissionSet setUpTestPermSetExternal() {
      //try {
      permSetExternal = [select Id from PermissionSet where Label Like 'COV Access%' limit 1];
      //System.debug('Yes PermissionSet found called COV Access% for Overage High Volume Customer Portal: ' + permSetExternal);
      //} catch (QueryException e) {}
      //if (permSetExternal == null) {
      //  permSetExternal = new PermissionSet(Name='COV_Access_External_Test', Label='COV Access - Test External', UserLicenseId=[select Id from UserLicense where Name='Overage High Volume Customer Portal'].Id);
      //  insert permSetExternal;
      //}
      NetworkMemberGroup nmg;
      //try {
      nmg = [select Id, NetworkId from NetworkMemberGroup where ParentId = :permSetExternal.Id and NetworkId = :cov_user_utility.self.getNetworkID() limit 1];
        //System.debug('Found NetworkMemberGroup: ' + nmg);
      //} catch (QueryException e) { }
      //if (nmg == null) {
      //  nmg = new NetworkMemberGroup(NetworkId = cov_user_utility.self.getNetworkID(), ParentId = permSetExternal.Id);
      //  SaveResult[] results = connection.create(new SObject[] { nmg });
      //}
      return permSetExternal;
    }

    public PermissionSet setUpTestPermSetInternal() {
      try {
        System.debug('about to try to find the permSet');
        permSetInternal = [select Id from PermissionSet where Label Like 'COV Access%' and UserLicenseId = null limit 1];
        System.debug('permSet found: ' + permSetInternal);
      } catch (QueryException e) {
        System.debug ('QueryException when trying to find permset with UserLicenseId=null');
      }
      if (permSetInternal == null) {
        //try {
          permSetInternal = [select Id from PermissionSet where Label Like 'COV Access%' and UserLicense.Name = 'Salesforce'];        
        //} catch (QueryException e) {
          //permSetInternal = new PermissionSet(Name='COV_Access_Internal_Test', Label='COV Access - Internal Test');
          //insert permSetInternal;
          //NetworkMemberGroup nmg = new NetworkMemberGroup(ParentId = permSetInternal.Id, NetworkId=cov_user_utility.self.getNetworkID());
          //insert nmg;
        //}
      }
      //if (permSetInternal == null) {
      //  permSetInternal = new PermissionSet(Name='COV_Access_Internal_Test', Label='COV Access - Test Internal', UserLicenseId=[select Id from UserLicense where Name='Salesforce'].Id);
      //  insert permSetInternal;
      //}
      return permSetInternal;
    }

    public static User getGuestUser() {
        return [select Id from User where (Name Like 'COV Dev%' or Name like 'COV%' or Name like '%myIAVA%') and UserType = 'Guest' limit 1];
    }

    public static Boolean pageContainsErrorMessage(ApexPages.Message[] messagesIn, String fragment) {
      Boolean fragmentFound = false;
      Integer i = 0;
      while (i < messagesIn.size() && !fragmentFound) {
        if (messagesIn[i] != null && messagesIn[i].getSummary() != null && messagesIn[i].getSummary().contains(fragment)) {
          fragmentFound = true;
        }
        i++;
      }
      return fragmentFound;
    }

	
}