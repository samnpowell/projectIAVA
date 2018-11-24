public class IAVAPlus_SignIn {

	// from old green box IAVAPlus_SignIn box
    public PageReference redirectToNewLogin() {
    	PageReference newPR = new PageReference('https://my.iava.org/cov_login');
    	Map<String, String> theParams = ApexPages.currentPage().getParameters();
    	for (string s : theParams.keySet()) {
			newPr.getParameters().put(s, theParams.get(s));        		
    	}
    	system.debug('newPR: ' + newPR);
    	return newPR;
    }

    // from old IAVAlus_AutoRegister page
    public PageReference registerRedirect() {
    	PageReference newPR = new PageReference('http://iava.org/');
    	String emailParam = ApexPages.currentPage().getParameters().get('e');
		if (!String.isEmpty(emailParam)) {
			newPr.getParameters().put('tfa_EMAIL', emailParam);
		}
		String msg = 'Welcome!';
		newPr.getParameters().put('url-msg-join', msg);
    	newPr.setAnchor('join');
    	system.debug('newPR: ' + newPR);
    	return newPR;
    }

    public PageReference iavaPlusLogin() {
    	return null;
    }


}

///*

// * Login cases to cover for signup/reg:
// * - already has an active portal user record
// * - has an inactive portal user record
// * - email address already in use by another user record (staff user record)
// * - the person's contact record's account record's owner doesn't a Role on its user record
// * - the contact's "Create Portal User" flag was already set by a failed attempt so it didn't create a portal user
// * - successful creation of portal user
// * - multiple contact records for that email. if one is confirmed and has portal user, it should win out and log in.
// *
// * - unconfirmed member record should go to the paperwork upload page
// * - not pre-existing member record but operation (OEF etc) boxes not checked - should show error
// * - not a pre-existing member and operation checked - should save stub record and go to member signup


//*/





//public class IAVAPlus_SignIn {
    
//    public String loginMsg { get; private set; }
//    public String regMsg { get; private set; }
//    public String signupMsg { get; private set; }
    
//    public Id portalOwnerId;
//    public String securePortalURL;
//    public String secureCOVURL;

//    public Id covSiteId {get; set;}
//    private Site covSite;
//    private String covSitePathPrefix;

//    public String originalStartUrl {get; set;}
//    public String unitTestStartURL; // just for the purposes of testing since cant test site.login()
    
//    public IAVAPlus_SignIn() {
//        loginMsg = '';
//        regMsg = '';
//        signupMsg = '';

//        // get portal account owner with a role and secure Site URL
//        String portalAccountOwner = 'backgroundadmin@iava.org'; // default
//        IAVAPlus_Portal_Settings__c ps = IAVAPlus_Portal_Settings__c.getInstance('IAVA');
////      System.debug('ps: ' + ps);
//        if (ps != null) {
//            portalAccountOwner = (ps.Portal_Account_Owner__c != null) ? ps.Portal_Account_Owner__c : portalAccountOwner;
////          System.debug('portalAccountOwner: ' + portalAccountOwner);
//            securePortalURL = ps.Secure_Site_URL__c;
//            secureCOVURL = ps.Secure_COV_URL__c;
//        }
//        try {
//            User owner = [select Id from User where Username = :portalAccountOwner limit 1];
//            portalOwnerId = owner.Id;
//        } catch (Exception e) {
//            System.debug('>>>>>>>>>> set contact owner failed: ' + e.getMessage());
//            portalOwnerId = UserInfo.getUserId();
//        }

//        try {
//            covSite = [select Id, UrlPathPrefix from Site where (MasterLabel Like '%Community of Veterans%' or MasterLabel Like '%COV%' or MasterLabel Like '%myIAVA%') and SiteType='ChatterNetwork'];
//            covSiteId = covSite.Id;
//            covSitePathPrefix = covSite.UrlPathPrefix;
//        } catch (DmlException e) {}

//    }
    
//    // always redirect to secure site for login
//    public PageReference init() {

//        Map<String, String> theParams = ApexPages.currentPage().getParameters();
//        String currentURL = Site.getCurrentSiteUrl();
//        //String currentURL = Site.getBaseUrl(); -- starting in API version 30

//        if (currentURL != null && !currentUrl.startsWith('https://')) {
//            //return new PageReference(currentURL.replace('http://', 'https://'));
////          return new PageReference(securePortalURL + '?startURL=' + EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('startURL'), 'UTF-8'));
//            //return new PageReference(securePortalURL + URLsuffix);
//            PageReference secureURLequivalent = new PageReference(Site.getBaseSecureUrl());
//            for (String paramName : theParams.keySet()) {
//                secureURLequivalent.getParameters().put(paramName, theParams.get(paramName));
//            }
//            return secureURLequivalent;
//        }

//        //String startURL = ApexPages.currentPage().getParameters().get('startURL');
//        String startURL = theParams.get('startURL');
//        originalStartUrl = startUrl == null ? null : EncodingUtil.urlEncode(startUrl, 'UTF-8');
//        startURL = (startURL == null) ? startURL : EncodingUtil.urlDecode(startURL, 'UTF-8');
//        //String URLsuffix = '';
//        //if (startURL != null && startURL != '') {
//        //  URLsuffix = '?startURL=' + startURL;
//        //}

//        //String URLmsg = ApexPages.currentPage().getParameters().get('msg');
//        String URLmsg = theParams.get('msg');
//        if (URLmsg != null) {
//            loginMsg = EncodingUtil.urlDecode(URLmsg, 'UTF-8');
//        }



//        return null;
//    }
    
//    ////////// Login to IAVA Plus //////////
    
//    public PageReference iavaPlusLogin() {
//        return iavaPlusLogin(false);
//    }

//    public PageReference continueAsLoggedIn() {
//        return iavaPlusLogin(true);
//    }

//    public PageReference iavaPlusLogin(Boolean alreadyLoggedIn) {

//        //Logic for IAVA Plus login page:
//        //      if its iavaPlus or rucksack
//        //              if startURL on iavaplus or rucksack, just go ahead through
//        //              if they have the permset
//        //                      cross-site login to COV and send to dashboard or startURL
//        //              else no permset 
//        //                      if startURL is on cov or if authorized,
//        //                              send to gateway on iavaplus and then back to startURL on COV
//        //                      else (not authorized), send through to iavaplus dashboard
//        //      if it's on COV site
//        //              if startURL blank or on cov site
//        //                      if no permset cross-site login to iavaplus gateway (dont need to check for authorized since they can request access and were trying to go somewhere on COV)
//        //                      else if they have permset, go on through
//        //              if startURL on iavaplus site, cross-site login to iavaplus and go on through





//        //System.debug('>>>>>>>>>> site url: ' + Site.getCurrentSiteUrl());
//        //System.debug('>>>>>>>>>> username: ' + username);
//        //System.debug('>>>>>>>>>> password: ' + password);
//        String startUrl = System.currentPageReference().getParameters().get('startURL');
//        startURL = (startURL == null) ? startURL : EncodingUtil.urlDecode(startURL, 'UTF-8');
//        //startUrl = (startUrl != null) ? startUrl : '/home/home.jsp';
////      startUrl = (startUrl != null) ? startUrl : '/apex/Pipeline';    // redirect straight to Pipeline upon login to IAVA Plus portal

//        //startUrl = (startUrl != null) ? startUrl : '/IAVAPlus_Dashboard'; // redirect to temp Dashboard upon login to IAVA Plus portal

//        User u;
//        Boolean hasPermSet;
//        Boolean startUrlOnCOVSite = false;
//        if (startUrl != null) {
//            if (startUrl.right(covSitePathPrefix.length()) == covSitePathPrefix 
//                    || startUrl.contains('/' + covSitePathPrefix + '/') 
//                    || startUrl.contains('/' + covSitePathPrefix + '?')
//                    || startUrl.left(5).contains('cov_')
//                    || startUrl.left(25).contains('myiava.org')
//                    || startUrl.left(25).contains('my.iava.org')
//                ) {
//                startUrlOnCOVSite = true;
//            }
//        }

//        System.debug('covSiteId: ' + covSiteId);
//        //System.debug('Site.getSiteId(): ' + Site.getSiteId());
//        System.debug('ApexPages.currentPage().getHeaders().get(\'Host\'): ' + ApexPages.currentPage().getHeaders().get('Host'));
//        //System.debug('Apexpages.currentPage().getUrl(): ' + Apexpages.currentPage().getUrl());
//        String currentUrl = Apexpages.currentPage().getUrl();

//        // -- TODO - If want to use getSiteId() then reinstate after 3/7/14 upgrade to spring 14
//        //if (Site.getSiteId() != covSiteId) {
//        if (currentUrl != null && !currentUrl.contains(secureCOVURL)) {
//        //if (true) {  // true puts it into IAVA Plus site mode, false puts it into COV site mode
//            System.debug('Not currently on the COV site');
//            if (startUrl == null || startUrl == '' || startUrlOnCOVSite) {
//            // only bother running this section if the user wasn't specifically trying to get into the portal side anyway
//                System.debug('startURL is not seemingly iavaplus or rucksack');
//                if (alreadyLoggedIn) {
//                    username = UserInfo.getUserName();
//                }
//                u = findUserFromUsername(username);
//                if (u != null) {
//                    hasPermSet = cov_gateway_controller.alreadyHasPermissionSet(u);
//                    System.debug('User: ' + u);
//                    System.debug('hasPermSet: ' + hasPermSet);
//                    if (hasPermSet) {
//                        System.debug('Has the permission set. Going to log user into COV and send to secureCOVURL: ' + secureCOVURL + ' and startUrl:' + startUrl);
//                        //String startUrlstring = (startUrl == null || startUrl == '') ? '' : '?startURL=' + startURL;
////System.debug(username+' asdkfjhfdedge334qyy'+password+'yyqswarrior25uslnadaeldkjgfhk');
//                        //return new pageReference(secureCOVURL + startUrlstring);
//                        unitTestStartURL = startUrl;
//                        PageReference crossSitePageRef;
//                        if (alreadyLoggedIn) {
//                            system.debug('already logged in.');
//                            if (startUrl == null || startUrl.trim() == '') {
//                                startUrl = secureCOVURL;
//                            }
//                            String destUrl = startUrl;
//                            if (!startUrl.startsWith('http')) {
//                                destUrl = secureCOVURL + destUrl;
//                            }
//                            crossSitePageRef = new PageReference(destUrl);
//                            system.debug('already logged in, sending to: ' + crossSitePageRef);
//                        } else {
//                            system.debug('not logged in yet, need to send to login page.');
//                            Blob encryptedU = encrypt(username);
//                            Blob encryptedP = encrypt(password);
//                            crossSitePageRef = new PageReference(secureCOVURL + '/cov_iavaplus_login');
//                            crossSitePageRef.getParameters().put('a', EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedU), 'UTF-8'));
//                            crossSitePageRef.getParameters().put('b', EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedP), 'UTF-8'));
//                            if (startUrl != null && startUrl.trim() != '') {
//                                crossSitePageRef.getParameters().put('startURL', EncodingUtil.urlEncode(startUrl, 'UTF-8'));
//                            }
//                        }
//                        //PageReference crossSitePageRef = new PageReference(secureCOVURL + '/cov_iavaplus_login?a=' 
//                        //  + EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedU), 'UTF-8')
//                        //  + '&b=' +EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedP), 'UTF-8')
//                        //  + startUrlstring
//                        //  );
//                        system.debug('About to send user to this cross-site pageref: ' + crossSitePageRef);
//                        return crossSitePageRef;

//                    } else {
//                        System.debug('Doesnt have the permission set.');
//                        if (startUrlOnCOVSite || cov_gateway_controller.isAuthorizedToGainAccess(u)) {
//                            if (startUrl == null || startUrl == '') {
//                                System.debug('Going to cov_gateway page no startUrl so adding one to go back to COV after gateway');
//                                startUrl = '/cov_gateway?startUrl=' + EncodingUtil.urlEncode(secureCOVURL, 'UTF-8');
//                            } else {
//                                System.debug('Going to cov_gateway page and preserving startUrl: ' + startUrl);
//                                if (startUrl.contains('/cov_event')) {
//                                    startUrl += '&forcelogin=true';
//                                }
//                                startUrl = '/cov_gateway?startUrl=' + EncodingUtil.urlEncode(startUrl, 'UTF-8');
//                            }
//                        } else {
//                            System.debug('Not authorized for COV, going to IAVAPlus_Dashboard');
//                            startUrl = '/IAVAPlus_Dashboard';
//                        }
//                        if (alreadyLoggedIn) {
//                            // go now to the startUrl instead of logging into other site since no permset
//                            return new PageReference(startUrl);
//                        }
//                    }
//                }
//            }
//        } else { // page is on the COV site
//            System.debug('On the COV site');
//            if (alreadyLoggedIn) {
//                username = UserInfo.getUserName();
//            }
//            u = findUserFromUsername(username);
//            System.debug('User: ' + u);
//            if (u != null) {
//                Boolean doCrossSiteLogin = false;
//                String crossSitePage = '';
//                if(startUrl == null || startUrl == '' || startUrlOnCOVSite) {
//                    System.debug('StartUrl is blank or on the COV site.  startUrl: ' + startUrl);
//                    hasPermSet = cov_gateway_controller.alreadyHasPermissionSet(u);         
//                    System.debug('hasPermSet: ' + hasPermSet);
//                    if (!hasPermSet) {
//                        System.debug('User does not have COV Access permission set so send over to cov_gateway on iavaplus');
//                        doCrossSiteLogin = true;
//                        crossSitePage = '%2Fcov_gateway';
//                    } 
//                } else {
//                    System.debug('StartUrl seems to not be on the COV site so log in on IAVAPlus side.  startUrl: ' + startUrl);
//                    doCrossSiteLogin = true;
//                }

//                if (doCrossSiteLogin) {
////System.debug(username+' asdkfjhfdedge334qyy'+password+'yyqswarrior25uslnadaeldkjgfhk');
////System.debug('eA: ' + EncodingUtil.base64Encode(encryptedU) +'  eB: '+ EncodingUtil.base64Encode(encryptedP));
//                    String startUrlstring = '&startURL=' + crossSitePage;
//                    if (startUrl != null && startUrl != '') { startUrlstring += EncodingUtil.urlEncode(startURL, 'UTF-8'); }
//                    System.debug('startUrlstring: ' + startUrlstring);
//	                unitTestStartURL = startUrlString;

//                    PageReference crossSitePageRef;
//                    if (alreadyLoggedIn) {
//                        crossSitePageRef = new PageReference(securePortalURL + startUrlString);
//                        system.debug('already logged in on COV side, sending to: ' + crossSitePageRef);
//                    } else {
//                        system.debug('use login box creds to log into IAVA Plus side');
//                        Blob encryptedU = encrypt(username);
//                        Blob encryptedP = encrypt(password);
//                        crossSitePageRef = new PageReference(securePortalURL + '/cov_iavaplus_login');
//                        crossSitePageRef.getParameters().put('a', EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedU), 'UTF-8'));
//                        crossSitePageRef.getParameters().put('b', EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedP), 'UTF-8'));
//                        if (startUrl != null && startUrl.trim() != '') {
//                        	crossSitePageRef.getParameters().put('startURL', EncodingUtil.urlEncode(startUrlString, 'UTF-8'));
//                        }
//                    }

//                    //return new PageReference(securePortalURL + '/cov_iavaplus_login?a=' 
//                    //    + EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedU), 'UTF-8')
//                    //    + '&b=' +EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedP), 'UTF-8')
//                    //    + startUrlstring
//                    //    );
//                    return crossSitePageRef;
//                }
//            }
//        }





//        System.debug('startUrl: ' + startUrl);

////      String URLsuffix;
////      if (startURL != null && startURL != '') {
////          URLsuffix = '?startURL=' + EncodingUtil.urlDecode(startURL, 'UTF-8');
////      }

////      //Id covSiteId;
////      try {
////          covSite = [select Id from Site where (Name Like '%Community of Veterans%' or Name Like '%COV%') and SiteType='ChatterNetwork'];
////          covSiteId = covSite.Id;
////      } catch (DmlException e) {}
////      if (Site.getSiteId() == covSiteId) {
////          System.debug('On covSite.');
////          //User u;
////          try {
////              u = [select Id, ContactId, Date_of_COV_Terms_and_Conduct_Acceptance__c, Profile.UserType, Profile.UserLicenseId
////                  from User where Username = :username limit 1 ];
////              System.debug('User found: ' + u);
////          } catch (DmlException e) { 
////              System.debug('No user found with that username'); 
////          }

////          // TODO: Now have to check via the cov_gateway_controller methods but first rewrite them to accept a User as an argument
////          //System.debug('u: ' + u);
////          //System.debug('cov_gateway_controller.alreadyHasPermissionSet(u): ' + cov_gateway_controller.alreadyHasPermissionSet(u));
////          //System.debug('cov_gateway_controller.isAuthorizedToGainAccess(u): ' + cov_gateway_controller.isAuthorizedToGainAccess(u));
////          //if (u != null && !cov_gateway_controller.alreadyHasPermissionSet(u) && cov_gateway_controller.isAuthorizedToGainAccess(u)) {
////          // forward them even if not authorized since they can request access
////          if (u != null && !cov_gateway_controller.alreadyHasPermissionSet(u)) {
////              System.debug('Found the user, who doesnt have the permission set but is authorized to gain access');

////              //Blob cryptoKey = Crypto.generateAesKey(128);
////              Blob cryptoKey = EncodingUtil.base64decode('LTCT0BEHm0BEoverewhiNw==');
////              Blob initializationVector = Blob.valueOf('0000000000000000');
////              Blob encryptedU = Crypto.encrypt('AES128', cryptoKey, initializationVector, Blob.valueOf(username));
////              Blob encryptedP = Crypto.encrypt('AES128', cryptoKey, initializationVector, Blob.valueOf(password));
////              //Blob encryptedU = Crypto.encryptWithManagedIV('AES128', cryptoKey, Blob.valueOf(username));
////              //Blob encryptedP = Crypto.encryptWithManagedIV('AES128', cryptoKey, Blob.valueOf(password));
////              //String ustring = EncodingUtil.base64encode(encryptedU);
////              //Blob unencryptedU = Crypto.decrypt('AES128', cryptoKey, initializationVector, EncodingUtil.base64decode(ustring));
////              //loginMsg = EncodingUtil.base64encode(unencryptedU) + ' ***** ' + unencryptedU.toString();

////              return new PageReference(securePortalURL + '/cov_iavaplus_login?a=' 
////                  + EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedU), 'UTF-8')
////                  + '&b=' +EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedP), 'UTF-8')
////                  + '&startURL=%2Fcov_gateway'
////                  );


////              //String loginresponse = new PageReference(securePortalURL + '/cov_iavaplus_login?a=' 
////              //  + EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedU), 'UTF-8')
////              //  + '&b=' +EncodingUtil.urlEncode(EncodingUtil.base64encode(encryptedP), 'UTF-8')
////              //  ).getContent().toString();

////              //if (loginresponse.contains('Login successful') || loginresponse.contains('Already logged in') {
////              //  return new PageReference(securePortalURL + '/cov_gateway' + '&msg = ' + loginresponse);
////              //} else {
////              //  loginMsg = 'Your login attempt has failed. Make sure the username and password are correct. (' + loginresponse + ')');
////              //  return null;
////              //}

////              // TODO -- also add case for if already logged in

//////                        if (pRef != null) {
//////                            return pRef;
//////                        } else {
//////                            loginMsg = 'There was a problem sending you to the Join COV page. Please let us know at covdev@iava.org that you got error "Signin4".';
//////                            return null;
//////                        }
////                  //} catch (DmlException e) {
////                  //  loginMsg = 'There was a problem sending you to the Join COV page. Please let us know at covdev@iava.org that you got error "Signin5".';
////                  //  cov_log_error.logError(e);
////                  //  return null;
////                  //}
////          } else {
////              System.debug('Either didnt find the user, or already had the permission set, or wasnt authorized to gain access');
////          }
////      }

////              //if (UserInfo.getUserType() != 'Guest' && cov_gateway.redirectToGateway()) {
////     //             // if the user was headed to a cov page, first check if they just need to
////     //             // accept the terms and/or be added to the correct permissionset
////     //             // if so redirect to iavaplus site since may not have permissions yet for community
////     //             String URLsuffixprefix = '';
////     //             if (!securePortalURL.startsWith('/')) { URLsuffixprefix='/'; }
////     //             URLsuffix = URLsuffixprefix + 'cov_gateway' + URLsuffix;
////     //             System.debug('About to return this pageReference: ' + securePortalURL + URLsuffix);
////     //             return new PageReference(securePortalURL + URLsuffix);
////             //}

//        //System.debug('u: ' + username + ' and p: ' + password + ' and s: ' + startUrl);
//        PageReference pRef = Site.login(username, password, startUrl);
//        System.debug('pRef after login: ' + pRef);
//        System.debug('loginMsg after login: ' + loginMsg);
//        unitTestStartURL = startUrl;

//        if (pRef != null) {
//            return pRef;
//        } else {
//            loginMsg = 'Your login attempt has failed. Make sure the username and password are correct.';
//            return null;
//        }
//    }

//    private static Blob encrypt(String s) {
//        Blob cryptoKey = EncodingUtil.base64decode('LTCT0BEHm0BEoverewhiNw==');
//        Blob initializationVector = Blob.valueOf('0000000000000000');
//        return Crypto.encrypt('AES128', cryptoKey, initializationVector, Blob.valueOf(s));
//    }

//    private User findUserFromUsername(String usernameArg) {
//            User u;
//            try {
//                List<User> uusers = [select Id, ContactId, Date_of_COV_Terms_and_Conduct_Acceptance__c, Profile.UserType, Profile.UserLicenseId
//                    from User where Username = :usernameArg ];
//                if (uusers.size() > 0) {
//                    u = uusers[0];
//                    System.debug('User found: ' + u);
//                } else {
//                    System.debug('No user found with that username');                   
//                }
//            } catch (DmlException e) { 
//                System.debug('Problem while attempting to find user with that username'); 
//            }
//            return u;
//    }



    
//    ////////// Sign up as an IAVA Member //////////
    
//    public PageReference signup() {
        
//        // adapted from dc_ctrl_RewardSearch.signup()
        
//        System.debug('>>>>>>>>>> signup() email: ' + emailToReg + ' OEF: ' + oef + ' OIF: ' + oif + ' OND: ' + ond);
        
//        oef = oef == null ? false : oef;
//        oif = oif == null ? false : oif;
//        ond = ond == null ? false : ond;


//        // ***** FIRST: CHECK IF EMAIL IS VALID

//        //if (emailToReg != null && emailToReg != 'Email' && emailToReg.contains('@') && emailToReg.contains('.')) {
//        if (cov_utilities.validateEmail(emailToReg)) {
//            System.debug('email was not empty is valid');


//            // ***** NEXT: CHECK IF EMAIL ALREADY EXISTS ON A CONTACT RECORD
//            Contact c;

//            try {           
//                // check if contact already exists in the system
//                c = [select Id, Name, Account.OwnerId, Membership_ID__c, Veteran_Member__c, Veteran_Member_Status__c, Paperwork_Confirmation__c, Submitted_Application__c, Create_Portal_User__c, Portal_User__c, User_Initiated_login__c
//                            , Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, No_Email_Blasts__c
//                    from contact
//                    where (Email = :emailToReg or npe01__HomeEmail__c = :emailToReg or npe01__WorkEmail__c = :emailToReg or npe01__AlternateEmail__c = :emailToReg)
//                    order by Veteran_Member_Status__c ASC NULLS LAST 
//                    limit 1];
//                // SD: added Order By so if there are duplicate Contacts with that email then Confirmed Member will be chosen
//                System.debug('Found Contact id ' + c.Id + ' and Name: ' + c.Name);

//                // If any of the operation checkboxes are new, update the contact
//                Boolean updateContact = false;
//                if (oef != null && oef && !c.Veteran_of_OEF__c) { c.Veteran_of_OEF__c = true; updateContact = true; }
//                if (oif != null && oif && !c.Veteran_of_OIF__c) { c.Veteran_of_OIF__c = true; updateContact = true; }
//                if (ond != null && ond && !c.Veteran_of_OND__c) { c.Veteran_of_OND__c = true; updateContact = true; }
//                // If "Should not receive email blasts" is checked, uncheck and update the contact.
//                if (c.No_Email_Blasts__c) { c.No_Email_Blasts__c = false; updateContact = true; }
//                // cant set User Initiated Login here because if already filled out form they will immediately get a license
//                // and the below code will say that they should have one instead of check your email
//                if (updateContact) {
//                    try {
//                        update c;
//                    } catch (Exception e) {}
//                }


//            } catch (Exception e) {     

//            // ***** CASE: EMAIL NOT FOUND IN SYSTEM - insert a contact
            
//                System.debug('Email not in system');    


//                // PLACEHOLDER: Make the user confirm that they dont have another email


//                // Create stub record and redirect to appropriate destination
//                Contact cont = new Contact(LastName = '(Unknown)',
//                                            Email = emailToReg
//                                            , npe01__HomeEmail__c = emailToReg
//                                            , Veteran_of_OEF__c = oef == null ? false : oef
//                                            , Veteran_of_OIF__c = oif == null ? false : oif
//                                            , Veteran_of_OND__c = ond == null ? false : ond
//                                            , Veteran_Member__c = oef || oif || ond ? true : false
//                                            , User_Initiated_login__c = true
//                                            );
//                cont.OwnerId = portalOwnerId;
//                System.debug('portalOwnerId: ' + portalOwnerId);
//                try {
//                    insert cont;
//                } catch (Exception e2) {
//                    cov_log_error.logError(e2, 'Error inserting stub contact from IAVAPlus login page: ' + cont);
//                }
//                System.debug('New contact inserted: ' + cont);
                
//                c = [select Id, Name, Account.OwnerId, Membership_ID__c, Veteran_Member__c, Veteran_Member_Status__c, Paperwork_Confirmation__c, Submitted_Application__c, Create_Portal_User__c, Portal_User__c, User_Initiated_login__c, AccountId from Contact where Id = :cont.Id];
//                Account a = new Account(Id = c.AccountId, OwnerId = portalOwnerId);
//                update a;

//            }

//            // Now we can assume everyone has a contact, either pre-exising or newly created

//            List<User> u = [select Id, isActive, IsPortalEnabled, Username from User where (ContactId = :c.Id and IsPortalEnabled = true) or Username = :emailToReg or Id = :c.Portal_User__c];
//            if (u.size() > 0) {  

//            // ***** CASE: EXISTING USER RECORD WITH THIS EMAIL

//                if (u[0].IsPortalEnabled) {
//                    // *** SUBCASE: existing user has portal login

//                    System.debug('already has portal login');
//                    if (u[0].isActive) {
//                        //System.debug('ApexPages.currentPage().getUrl(): ' + ApexPages.currentPage().getUrl());
//                        signupMsg =
//                            ApexPages.currentPage().getUrl().contains('IAVAPlus_AutoRegister') ?
//                                'Looks like you already have an IAVA Plus Login. Please <a href=".?u=' + emailToReg + '">click here</a> and log in on the left side.'
//                                : 'Looks like you already have an IAVA Plus Login. Log in on the left, or click the Forgot Password link to reset it.';
//                    } else {
//                        signupMsg = 'Your account is inactive. Contact membership@iava.org for assistance.';
//                    }
//                } else {
//                    // *** SUBCASE: existing user is a non-portal (staff) user                      
//                    signupMsg = 'This email is already in use by another Salesforce user record. Use the alternate link to sign in.';
//                }                   
//                return null;

//            } else if (
//                        c.Veteran_Member__c == true && 
//                            (c.Veteran_Member_Status__c == 'Confirmed' ||
//                                (c.Veteran_Member_Status__c == 'Unconfirmed' && c.Submitted_Application__c)
//                            )
//                       ) {  

//                // ***** CASE: CONFIRMED MEMBER WITHOUT A USER ACCOUNT 
//                // *****        OR UNCONFIRMED BUT ALREADY FILLED OUT FORM1

//                // --> provision license now
                
//                System.debug('Confirmed member with no portal login yet, OR Unconfirmed but filled out Form1');

//                // SD: make sure the contact's account's owner has a role
//                User accountuser = [select Id, UserRoleId from User where Id = :c.Account.OwnerId limit 1];
//                if (accountuser.UserRoleId == null) {
//                    signupMsg = 'Sorry there was a problem activating your IAVA plus login. Please contact membership@iava.org and mention error code "AccountOwnerRole".';                         
//                }
//                else {
//                    // SD: if flag already set, unset it so re-setting it will cause the provisioning trigger to fire
//                    // That would happen if a previous provisioning attempt had failed.
//                    if (c.Create_Portal_User__c == true) {
//                        c.Create_Portal_User__c = false;
//                        update c;
//                    }
//                    // set flag on Contact record to trigger portal user license provisioning
//                    c.Create_Portal_User__c = true;
//                    update c;
//                    signupMsg =
//                            ApexPages.currentPage().getUrl().contains('IAVAPlus_AutoRegister') ?
//                                'Please check your email for a temporary IAVA Plus password and <a href=".?u=' + emailToReg + '">sign in here</a>.'
//                                : 'Please check your email for a temporary IAVA Plus password.';
//                }
//                return null;

//            //} else if (c.Veteran_Member__c == true) {     

//            //  // ***** CASE: UNCONFIRMED MEMBER WITHOUT A PORTAL USER 

//         //     System.debug('Unconfirmed member');


//         //     if (!c.Submitted_Application__c) { // if they havent yet filled out Form 1 send them to it
//            //      c.User_Initiated_login__c = true; // this will cause a license to be provionsed after Form1 is completed and a signup date is added to contact record
//            //      update c;
//            //      String msg = 'Welcome! Fill out this signup form to get your IAVA Plus account.  If you think you have already signed up you may need to go back and enter the email you used to sign up previously.';
//            //      pName = System.Label.dc_MemberSignupURLStep1 + (System.Label.dc_MemberSignupURLStep1.contains('?') ? '&' : '?')
//            //                  + 'tfa_EMAIL=' + EncodingUtil.urlEncode(emailToReg, 'UTF-8')
//            //                  + '&msg=' + EncodingUtil.urlEncode(msg, 'UTF-8');
//      //        } else { // they have already filled out Form1 so send to Form2
//            //      c.Create_Portal_User__c = true; // provision a license and send on to Form2
//            //      update c;
//            //      String msg = 'We have you in our system as an unconfirmed member.  Upload your paperwork as described below to confirm your membership, and check your email for a temporary IAVA Plus password.';
//            //      pName = System.Label.dc_MemberSignupURLStep2 + (System.Label.dc_MemberSignupURLStep2.contains('?') ? '&' : '?') + 'tfa_ContactID=' + c.Id +
//            //                  '&msg=' + EncodingUtil.urlEncode(msg, 'UTF-8');
//         //     }
//            //  return new pageReference(pName);
//            //} else {

//            //  // ***** CASE: IN SYSTEM BUT NOT MARKED AS VETERAN MEMBER

//         //     System.debug('In system but not as veteran member');                    
//            //  if (oef || oif || ond) {    
//            //      System.debug('at least one box selected');
//            //      // capture operation entered, mark as veteran, redirect to signup page
//            //      c.Veteran_of_OEF__c = oef;
//            //      c.Veteran_of_OIF__c = oif;
//            //      c.Veteran_of_OND__c = ond;
//            //      c.Veteran_Member__c = true;
//            //      c.User_Initiated_login__c = true; // this will cause a license to be provionsed after Form1 is completed and a signup date is added to contact record
//            //      update c;
                    
//            //      oef_val = (oef == true) ? 'tfa_OEFAfghanistan1' : '';
//            //      oif_val = (oif == true) ? 'tfa_OIFIraq' : '';
//            //      ond_val = (ond == true) ? 'tfa_ONDIraq' : '';
                    
//            //      pName = System.Label.dc_MemberSignupURLStep1 + (System.Label.dc_MemberSignupURLStep1.contains('?') ? '&' : '?') + 'tfa_EMAIL=' + emailToReg;
//            //      return new pageReference(pName);
//            //  } else {
//            //      System.debug('no boxes selected');                                  // non-member
//            //      signupMsg = 'This IAVA program is available to veterans of Iraq (OIF/OND) and Afghanistan (OEF). If you\'ve served in any of the three, check the appropriate box to register with IAVA.';
//            //      return null;
//            //  }
//            //}
//            } else {
                
//                // CASE: Unconfirmed with no Form1, Other Era, Family, or Supporter

//                // REDIRECT SECTION

//                oif_val = (oif == true) ? 'tfa_OIFIraq' : '';
//                oef_val = (oef == true) ? 'tfa_OEFAfghanistan1' : '';
//                ond_val = (ond == true) ? 'tfa_ONDIraq' : '';
                
//                // clear previous error message
//                signupMsg = '';

                
//                // cant do this higher up because it would immediately provision a license for unconfirmed user if the user has previously filled out form1
//                if (!c.User_Initiated_login__c) { 
//                	c.User_Initiated_login__c = true; 
//                	try { 
//                		update c; 
//            		} catch (Exception e) {
//            			cov_log_error.logError(e);
//            		}
//                }

//                // redirect to signup page

//                System.debug('about to redirect');
//                String msg = 'Welcome! Fill out this signup form to get your IAVA Plus account.  If you think you have already signed up you may need to go back and enter the email you used to sign up previously.';              
//                String completionMsg = 'Please check your email for a temporary IAVA Plus password.';
//                String emailParam;
//                String completionMsgParam;
//                String redirectUrlParam;
//                String redirectUrl;

//                if (oef || oif || ond) {    
//                    System.debug('At least one box checked, its a veteran, send to Form1');                 
//                    pName = System.Label.dc_MemberSignupURLStep1;
//                    emailParam = 'tfa_EMAIL';
//                    completionMsgParam = 'tfa_3783473255399';
//                    redirectUrlParam = 'tfa_3783473255400';
//                } else {
//                    System.debug('No operation boxes checked, not a veteran, send to supporter signup');                    
//                    pName = 'https://secure.iava.org/take-action/become-supporter';
//                    emailParam = 'tfa_Email';
//                    completionMsgParam = 'tfa_completionMsg';
//                    redirectUrlParam = 'tfa_6';
//                }
//                redirectUrl = Site.getCurrentSiteUrl() + 'IAVAPlus_SignInPage?u=' + EncodingUtil.urlEncode(emailToReg, 'UTF-8');
//                String startURL = ApexPages.currentPage().getParameters().get('startURL');
//                redirectUrl = redirectUrl + (startURL == null ? '' : '%26startURL=' + startURL);
//                system.debug('redirectUrl: ' + redirectUrl);

//                system.debug('pName before parameters: ' + pName);
//                //pageReference pageRef = new pageReference(pName);
//                //system.debug('pageRef before parameters: ' + pageRef);
//                //pageRef.getParameters().put(emailParam, emailToReg);
//                //pageRef.getParameters().put('msg', msg);
//                //pageRef.getParameters().put(completionMsgParam, completionMsg);
//                //system.debug('pageRef after parameters: ' + pageRef);

//                pName += (pName.contains('?') ? '&' : '?') 
//                                + emailParam + '=' + EncodingUtil.urlEncode(emailToReg, 'UTF-8')
//                                + '&' + redirectUrlParam + '=' + redirectUrl                                
//                                + '&' + completionMsgParam + '=' + EncodingUtil.urlEncode(completionMsg, 'UTF-8')
//                                + '&msg=' + EncodingUtil.urlEncode(msg, 'UTF-8');
//                system.debug('pName after parameters: ' + pName);
//                return new pageReference(pName);
//            }

//        } else {

//            // ***** CASE: NON-VALID EMAIL ENTERED

//            signupMsg = 'Please enter a valid email address.';
//            return null;
//        }
        
//    }
    
//    ////////// Utility Methods //////////
    
//    //public String username = 'Email Address';     // Username entered by user
//    //public String password = 'Password';      // Password entered by user
//    public String username;     // Username entered by user
//    public String password;     // Password entered by user
//    //public String email = 'Email';              // Email entered by user
//    //public String emailToReg = 'Email';
//    public String email = '';              // Email entered by user
//    public String emailToReg = '';
//    public Boolean oif { get; set; }
//    public Boolean oef { get; set; }
//    public Boolean ond { get; set; }
//    public String pName = ' ';
//    public String oif_val { get; set; }
//    public String oef_val { get; set; }
//    public String ond_val { get; set; }
    
//    public String getUsername() {
//        return username;
//    }
    
//    public void setUsername(String s) {
//        username = s;
//    }
    
//    public String getPassword() {
//        return password;
//    }
    
//    public void setPassword(String s) {
//        password = s;
//    }
    
//    public String getEmail() {
//        return email;
//    }
    
//    public void setEmail(String s) {
//        email = s;
//    }
    
//    public String getEmailToReg() {
//        return emailToReg;
//    }
    
//    public void setEmailToReg(String s) {
//        emailToReg = s;
//    }
    
//    public String getPName() {
//        return pName;
//    }
    
//    public void setPName(String s) {
//        pName = s;
//    }

//    public String getoldieversion() {
//        String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
//        System.debug('userAgent::::::::::::::::::::::' + userAgent);
//        if (userAgent.contains('MSIE 6.0'))
//            return 'true';
//        else if (userAgent.contains('MSIE'))
//            return 'false';
//        else
//            return 'none';
//    }
    
//    public String getMacos() {
//        String user_Agent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
//        System.debug('userAgent::::::::::::::::::::::' + user_Agent);
//        if (user_Agent.contains('Mac'))
//            return 'true';
//        else
//            return 'none';
//    }

//    //public String getPageURL() {
//    //    //String hostVal  = ApexPages.currentPage().getHeaders().get('Host').toExternalForm();
//    //    //String urlVal = Apexpages.currentPage().getUrl().toExternalForm();
//    //    String hostVal  = System.URL.getHost().toExternalForm();
//    //    String urlVal = System.URL.getPath().toExternalForm();


//    //    return 'https://' + hostVal + urlVal;

//    //}
    

//}