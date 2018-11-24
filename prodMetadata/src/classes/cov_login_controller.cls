public with sharing class cov_login_controller {


    public String loginMsg { get; private set; }
    public String signupMsg { get; private set; }

    public String username { get; set; }
    public String password { get; set; }

    public String emailToReg { get; set; }
    public Boolean oif { get; set; }
    public Boolean oef { get; set; }
    public Boolean ond { get; set; }
    public Boolean agreeToTerms { get; set; }

    private Map<String, String> theParams { get; set; }
    public String encodedStartURL { get; set; }
    private String startURL { get; set; }
    public Boolean hidePageMessages { get; set; }
    public String instancePrefix { private set; }
    public Boolean showFacebookLogin {get; set;}
    public String fbAuthURL {get; set;}

    public String unitTestStartURL; // just for the purposes of testing since cant test site.login()

    public Id portalOwnerId;

    public Boolean isSandbox {
        get {
            return cov_user_utility.self.getIsSandbox();
        }
    }



    public cov_login_controller() {
		loginMsg = '';
		//regMsg = '';
		signupMsg = '';

        theParams = ApexPages.currentPage().getParameters();
        startURL = theParams.get('startURL');
        String sitePathPrefix = Site.getPathPrefix();
        system.debug('startURL: ' + startURL);
        system.debug('sitePathPrefix: ' + sitePathPrefix);
        //if (string.isnotblank(sitePathPrefix) && startURL.startsWith(sitePathPrefix)) {
        //    startURL = startURL.replace(sitePathPrefix, '');
        //    system.debug('startURL after prefix replace: ' + startURL);
        //}
        if (String.isNotBlank(startURL) && startURL.contains('cov_login')) {
            startURL = null;
        }
        encodedStartURL = (startURL == null) ? startURL : EncodingUtil.urlEncode(startURL, 'UTF-8');

        //String URLmsg = ApexPages.currentPage().getParameters().get('msg');
        String URLmsg = theParams.get('msg');
        if (URLmsg != null) {
            loginMsg = EncodingUtil.urlDecode(URLmsg, 'UTF-8');
        }

        IAVA_switches__c sw = IAVA_switches__c.getInstance('myIAVA_show_facebook_login');
        showFacebookLogin = sw != null && !sw.Disable__c ? true : false;
        String baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        fbAuthURL = Auth.AuthConfiguration.getAuthProviderSsoUrl(baseUrl + sitePathPrefix, startURL, 'Facebook');

    }

    public PageReference init() {

        if ( UserInfo.getUserType() != 'Guest') {
            return CommunitiesLandingController.forwardToStartPage();            
        }

        // Check whether user is on non-secure URL and if so redirect to secure

        IAVA_switches__c sw = IAVA_switches__c.getInstance('myIAVA_secure_login_redirect');
        if (sw != null && !sw.Disable__c) {
            system.debug('Checking URL for insecure URL');

            String currentBaseURL = Site.getBaseUrl();
            String currentPageURL = ApexPages.currentPage().getUrl();
            system.debug('currentPageURL: ' + currentPageURL);
            String newURL = Site.getBaseSecureUrl() + currentPageURL.replace('/apex/', '/');
            system.debug('newURL: ' + newURL);

            if (currentBaseURL != null && !currentBaseURL.startsWith('https://')) {
                PageReference secureURLequivalent = new PageReference(newURL);
                for (String paramName : theParams.keySet()) {
                    secureURLequivalent.getParameters().put(paramName, theParams.get(paramName));
                }
                return secureURLequivalent;
            }
        }
        return null; 
    }


    public static String getInstancePrefix() {
    	try {
    		Organization o = [select Id, Name, InstanceName from Organization where Name like '%Iraq%' or Name like '%IAVA' limit 1];
    		return o.InstanceName;
    	} catch (Exception e) {
    		cov_log_error.logError(e, 'Error querying Organization for instance name.');
    		return null;
    	}
    }

    public PageReference communityLogin() {
        loginMsg = '';
    	signupMsg = '';
    	hidePageMessages = false;

        PageReference loginAttempt = Site.login(username, password, startUrl);
        System.debug('loginAttempt pageref after login: ' + loginAttempt);
        unitTestStartURL = startUrl;

        if (loginAttempt != null) {
            return loginAttempt;
        } else {
        	system.debug('Login failed. Lets get more info.');

                User u = findUserFromUsername(username);
                if (u == null) {
                	system.debug('User not found.');
                	return loginAttempt;
                } else {
                    Boolean hasPermSet = cov_gateway_controller.alreadyHasPermissionSet(u);
                    System.debug('User: ' + u);
                    System.debug('hasPermSet: ' + hasPermSet);
                    if (hasPermSet) {
                    	system.debug('User has the permset so must have entered incorrect login info.');
                    	return loginAttempt;
                    } else {
                    	// hide default pagemessages message to display custom message
                    	if (ApexPages.getMessages().size() == 1 && Apexpages.getMessages()[0].getSummary().contains('Your login attempt has failed')) {
                    		hidePageMessages = true;
                    	}
                    	if (cov_gateway_controller.isAuthorizedToGainAccess(u)) {
                    		system.debug('User is authorized to gain access to myIAVA but does not have permset. Try to add.');
                    		if (cov_gateway_controller.addCOVPermissionSet(u)) {
                    			system.debug('Added to permset');
                                // SD 9/2016 - attempt to log in again after PermSet added
                                system.debug('Attempt to log in again now that user has permset.');
                                loginAttempt = Site.login(username, password, startUrl);
                                System.debug('loginAttempt pageref after login: ' + loginAttempt);
                                return loginAttempt;
                                // loginMsg = 'Please check your email for a temporary password, or use the Forgot Password link if you don\'t receive an email.';
            					// return null;
                                // end edit 9/2016
                    		} else {
                    			system.debug('Problem adding to COV permset');
                    			loginMsg = 'Sorry there was a problem sending you a temporary password. Please try the link at the bottom right instead.';
            					return null;
                    		}
                    	} else {
                    		system.debug('Not authorized to gain access to myIAVA.');
                    		loginMsg = 'Sorry, access to myIAVA is currently limited. If you believe you already meet the criteria for access, please use the "Create a myIAVA account" button to complete your record.';
            				return null;
                    	}
                    }
                }
        }
    }


    private User findUserFromUsername(String usernameArg) {
            User u;
            try {
                List<User> uusers = [select Id, ContactId, Date_of_COV_Terms_and_Conduct_Acceptance__c, Profile.UserType, Profile.UserLicenseId
                    from User where Username = :usernameArg ];
                if (uusers.size() > 0) {
                    u = uusers[0];
                    System.debug('User found: ' + u);
                } else {
                    System.debug('No user found with that username');                   
                }
            } catch (DmlException e) { 
                System.debug('Problem while attempting to find user with that username'); 
            }
            return u;
    }









    
//    ////////// Sign up as an IAVA Member //////////
    
    public PageReference legacySignup() {
        
        loginMsg = '';
        signupMsg = '';
        hidePageMessages = true; // doesn't work

        // adapted from dc_ctrl_RewardSearch.signup()
        
        System.debug('>>>>>>>>>> signup() email: ' + emailToReg + ' OEF: ' + oef + ' OIF: ' + oif + ' OND: ' + ond);
        
        oef = oef == null ? false : oef;
        oif = oif == null ? false : oif;
        ond = ond == null ? false : ond;
        agreeToTerms = agreeToTerms == null ? false : agreeToTerms;


		// ***** FIRST: VALIDATE ENTERED INFO

        if (String.isEmpty(emailToReg)) {
        	signupMsg = 'Please enter an email address.';
        	return null;
        }

        if (!cov_utilities.validateEmail(emailToReg)) {
        	signupMsg = 'Sorry, that email address appears to be invalid.';
        	return null;        	
        }

        if (!agreeToTerms) {
        	signupMsg = 'You must agree to the terms to create a myIAVA account.';
        	return null;
        }



        // ***** NEXT: CHECK IF EMAIL ALREADY EXISTS ON A CONTACT RECORD
        Contact c;

        // check if contact already exists in the system

        String q = 'select Id, Name, Account.OwnerId'
        	+ ', FirstName, LastName, MailingPostalCode'
        	+ ', Membership_ID__c, Veteran_Member__c, Veteran_Member_Status__c'
        	+ ', Paperwork_Confirmation__c, Submitted_Application__c'
        	+ ', Create_Portal_User__c, Portal_User__c, User_Initiated_login__c'
			+ ', Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, No_Email_Blasts__c, myIAVA_Pre_User_TOS_Accept_Date__c'
			+ ', Veteran_of_Other_Era__c, Not_a_Veteran__c'
			+ ', Member_Categories__c'
            + ' from contact'
            + ' where (Email = \'' + emailToReg + '\' or npe01__HomeEmail__c = \'' + emailToReg + '\' or npe01__WorkEmail__c = \'' + emailToReg + '\' or npe01__AlternateEmail__c = \'' + emailToReg + '\')'
            + ' order by Veteran_Member_Status__c ASC NULLS LAST'
            + ' limit 1';


        sObject contactQueried = cov_nosharing_utilities.runSingleQuery(q);

        //c = [select Id, Name, Account.OwnerId, Membership_ID__c, Veteran_Member__c, Veteran_Member_Status__c, Paperwork_Confirmation__c, Submitted_Application__c, Create_Portal_User__c, Portal_User__c, User_Initiated_login__c
        //            , Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, No_Email_Blasts__c, myIAVA_Pre_User_TOS_Accept_Date__c
        //    from contact
        //    where (Email = :emailToReg or npe01__HomeEmail__c = :emailToReg or npe01__WorkEmail__c = :emailToReg or npe01__AlternateEmail__c = :emailToReg)
        //    order by Veteran_Member_Status__c ASC NULLS LAST 
        //    limit 1];
        // SD: added Order By so if there are duplicate Contacts with that email then Confirmed Member will be chosen

        if (contactQueried != null) {

        	c = (Contact)contactQueried;

            System.debug('Found Contact id ' + c.Id + ' and Name: ' + c.Name);

            // If any of the operation checkboxes are new, update the contact
            Boolean updateContact = false;
            if (oef != null && oef && !c.Veteran_of_OEF__c) { c.Veteran_of_OEF__c = true; updateContact = true; }
            if (oif != null && oif && !c.Veteran_of_OIF__c) { c.Veteran_of_OIF__c = true; updateContact = true; }
            if (ond != null && ond && !c.Veteran_of_OND__c) { c.Veteran_of_OND__c = true; updateContact = true; }
            // If "Should not receive email blasts" is checked, uncheck and update the contact.
            if (c.No_Email_Blasts__c) { c.No_Email_Blasts__c = false; updateContact = true; }
            if (c.myIAVA_Pre_User_TOS_Accept_Date__c == null && agreeToTerms) { c.myIAVA_Pre_User_TOS_Accept_Date__c = System.now(); updateContact = true; }

            // cant set User Initiated Login here because if already filled out form they will immediately get a license
            // and the below code will say that they should have one instead of check your email
            if (updateContact) {
	            Database.SaveResult sr = cov_nosharing_utilities.runDatabaseUpdate(c, false);
	            if (sr.isSuccess()) {
                    contactQueried = cov_nosharing_utilities.runSingleQuery(q);
                    if (contactQueried != null) {
						c = (Contact)contactQueried;
					}	            	
	            } else {
                	cov_log_error.logDevMsg('error updating contact based on legacy signup checkboxes.'); 
	            }
            }
        } else {

        	// ***** CASE: EMAIL NOT FOUND IN SYSTEM - insert a contact
        
            System.debug('Email not in system');   

	        // get portal account owner with a role and secure Site URL
	        String portalAccountOwner = 'backgroundadmin@iava.org'; // default
	        IAVAPlus_Portal_Settings__c ps = IAVAPlus_Portal_Settings__c.getInstance('IAVA');
	        if (ps != null) {
	            portalAccountOwner = (ps.Portal_Account_Owner__c != null) ? ps.Portal_Account_Owner__c : portalAccountOwner;
	//          System.debug('portalAccountOwner: ' + portalAccountOwner);
	        }
	        try {
	            User owner = [select Id from User where Username = :portalAccountOwner limit 1];
	            portalOwnerId = owner.Id;
	        } catch (Exception e2) {
	            System.debug('>>>>>>>>>> set contact owner failed: ' + e2.getMessage());
	            portalOwnerId = UserInfo.getUserId();
	        }


            // Create stub record and redirect to appropriate destination
            Contact cont = new Contact(LastName = '(Unknown)',
                                        Email = emailToReg
                                        , npe01__HomeEmail__c = emailToReg
                                        , Veteran_of_OEF__c = oef == null ? false : oef
                                        , Veteran_of_OIF__c = oif == null ? false : oif
                                        , Veteran_of_OND__c = ond == null ? false : ond
                                        , Veteran_Member__c = oef || oif || ond ? true : false
                                        , User_Initiated_login__c = true
                                        , myIAVA_Pre_User_TOS_Accept_Date__c = agreeToTerms ? System.now() : null
                                        );
            cont.OwnerId = portalOwnerId;
            System.debug('portalOwnerId: ' + portalOwnerId);
            try {
                insert cont;
            } catch (Exception e) {
                cov_log_error.logError(e, 'Error inserting stub contact from COV login page: ' + cont);
            }
            System.debug('New contact inserted: ' + cont);
            
            c = [select Id, Name, Account.OwnerId, Membership_ID__c, Veteran_Member__c, Veteran_Member_Status__c, Paperwork_Confirmation__c, Submitted_Application__c, Create_Portal_User__c, Portal_User__c, User_Initiated_login__c, AccountId, Member_Categories__c from Contact where Id = :cont.Id];
            Account a = new Account(Id = c.AccountId, OwnerId = portalOwnerId);
            //update a;
            Database.SaveResult sr = cov_nosharing_utilities.runDatabaseUpdate(a, false);
            if (!sr.isSuccess()) {
            	cov_log_error.logDevMsg('Error trying to update the account owner to portalOwnerId \'' + portalOwnerId + '\'. account: ' + a);
            }

        }



        // Now we can assume everyone has a contact, either pre-exising or newly created
        system.debug('About to query the user');
        List<User> u = [SELECT Id, isActive, IsPortalEnabled, Username FROM User WHERE (ContactId = :c.Id and IsPortalEnabled = true) or Username = :emailToReg or Id = :c.Portal_User__c ORDER BY isPortalEnabled DESC];
        system.debug('list of users u: ' + u);
        if (u.size() > 0) {  

        // ***** CASE: EXISTING USER RECORD WITH THIS EMAIL

            if (u[0].IsPortalEnabled) {
                // *** SUBCASE: existing user has portal login

                System.debug('already has portal login');
                if (u[0].isActive) {
                    //System.debug('ApexPages.currentPage().getUrl(): ' + ApexPages.currentPage().getUrl());
                    signupMsg ='Looks like you already have a myIAVA Login. Log in on the left, or click the Forgot Password link to reset it.';
                } else {
                    signupMsg = 'Your account is inactive. Contact membership@iava.org for assistance.';
                }
            } else {
                // *** SUBCASE: existing user is a non-portal (staff) user                      
                signupMsg = 'This email is already in use by a staff user record. Use the hidden link to sign in.';
            }                   
            return null;

        } else if (
	            	cov_gateway_controller.isAuthorizedToGainAccess(c)
                   ) {  

        		// CASE: Authorized to gain access


            // --> provision license now

			System.debug('Authorized to gain access. Check whether enough basic info on file to provision a license.');


            if (
            		  c.FirstName == null || c.Firstname == '(Unknown)'
            		|| c.LastName == null || c.LastName == '(Unknown)'
            		|| c.MailingPostalCode == null
            		||
            		(c.Veteran_of_OEF__c == null && c.Veteran_of_OIF__c == null && c.Veteran_of_OND__c == null
            			&& c.Veteran_of_Other_Era__c == null && c.Not_a_Veteran__c == null)
            	) {
            	system.debug('Not enough basic info on file, send to join form.');
				PageReference pref = new PageReference('http://iava.org/#join?tfa_EMAIL=' 
												+ EncodingUtil.urlEncode(emailToReg, 'UTF-8')
												+ '&url-msg-join='
												+ EncodingUtil.urlEncode('Please fill out this form to finish creating an account.', 'UTF-8')
												);
				  system.debug('pref to redirect: ' + pref);
				  return pref;

            } else {

            	system.debug('Enough info on contact record to provision a license.');

	            // SD: make sure the contact's account's owner has a role
	            String aq = 'select Id, UserRoleId from User where Id = \'' + c.Account.OwnerId + '\' limit 1';
	            User accountuser = (User)cov_nosharing_utilities.runSingleQuery(aq);
	            //User accountuser = [select Id, UserRoleId from User where Id = :c.Account.OwnerId limit 1];
	            if (accountuser.UserRoleId == null) {
	                signupMsg = 'Sorry there was a problem activating your myIAVA login. Please contact membership@iava.org and mention error code "AccountOwnerRole".';                        
	            }
	            else {
	                // SD: if flag already set, unset it so re-setting it will cause the provisioning trigger to fire
	                // That would happen if a previous provisioning attempt had failed.
	                if (c.Create_Portal_User__c == true) {
	                    c.Create_Portal_User__c = false;
                        Database.SaveResult sr = cov_nosharing_utilities.runDatabaseUpdate(c, false);
                        if (!sr.isSuccess()) {
                            cov_log_error.logDevMsg('error unsetting Create_Portal_User__c flag in order to reset it.');
                        }
	                 //   try {
	                 //   	update c;
	                	//} catch (Exception e) {
	                	//	cov_log_error.logError(e, 'error unsetting Create_Portal_User__c flag in order to reset it.');
	                	//}
	                }
	                // set flag on Contact record to trigger portal user license provisioning
	                c.Create_Portal_User__c = true;
                    Database.SaveResult sr = cov_nosharing_utilities.runDatabaseUpdate(c, false);
                    if (sr.isSuccess()) {
                        signupMsg = 'Please check your email for a temporary password.';
                    } else {
                        cov_log_error.logDevMsg('error updating record to set Create_Portal_User__c flag.');                        
                        signupMsg = 'Sorry there was a problem creating your temporary password. Please contact IAVA so they can get you set up.';
                    }
	             //   try {
	             //   	update c;
	            	//} catch (Exception e) {
	            	//	cov_log_error.logError(e, 'error setting Create_Portal_User__c flag.');
	            	//}
	            }
	            return null;
	        }


        } else {
            
        	// CASE: Not authorized to gain access

    		signupMsg = 'Sorry, access to myIAVA is currently limited. If you believe you already meet the criteria for access, please use the "Create a myIAVA account" button to complete your record.';
			return null;

        }
   
    }

}