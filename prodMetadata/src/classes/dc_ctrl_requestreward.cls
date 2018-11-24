// Distribution Center - Controller Class for Request Reward Page
                    // Created By - Puneet Aggarwal - 5/21/2010
                    // Modified Versions

public class dc_ctrl_requestreward extends dc_Request_Page_Handler {
	
    /******************************  Properties *********************************************/
    public Integer ticketValue2 { get; set; }
    
    public Boolean makePhonePrimary { get; set; }
    
    public Boolean makeEmailPrimary { get; set; }

    public Boolean eligibleForReward {get; set; }
    public List<String> eligibleList {get; set;}
    public Boolean allowGuestSignup {get; set;}

    public String currentEncodedUrlWithBase { get { return cov_user_utility.self.getCurrentEncodedUrlWithBase(); } }
    public String currentEncodedUrlWithoutBase { get { return cov_user_utility.self.getCurrentEncodedUrlWithoutBase(); } }
    public String portalLoginBaseUrl { get { return cov_user_utility.self.getPortalLoginBaseUrl(); } }
 
    /***************************************************************************************************************/
    /***************************************************************************************************************/
    /***************************************************               *********************************************/
    /***************************************************  Constructor  *********************************************/
    /***************************************************               *********************************************/
    /***************************************************************************************************************/
    /***************************************************************************************************************/
    public dc_ctrl_requestreward(){
    	
    	super('at request');
    	
    	System.debug(System.LoggingLevel.INFO, 'dc_ctrl_requestreward (constructor) BEGIN');
    	
    	this.init();
    	if (give != null && give.Maximum_Units_per_Member__c != null) {
    		//ticketValue = give.Maximum_Units_per_Member__c.intValue();
            // 10/2015 actually default selected quantity to 1 instead of maximum number
            ticketValue = 1;
    		selectedNumberOfGuests = ticketValue - 1;
    	}
    	refreshGuests();
    	
    	System.debug(System.LoggingLevel.INFO, 'dc_ctrl_requestreward (constructor) END');
    }


    /****************************************************************************************************************/
    /****************************************************************************************************************/
    /***************************************************                *********************************************/
    /***************************************************  Option Lists  *********************************************/
    /***************************************************                *********************************************/
    /****************************************************************************************************************/
    /****************************************************************************************************************/

    ////////////////////////////// Get Confirmation Options //////////////////////////////	
	public List<SelectOption> getconfirmItems() {
		List<SelectOption> options = new List<SelectOption>();
		options.add(new SelectOption('Yes', 'Yes'));
		options.add(new SelectOption('No', 'No'));
		return options;
	}
    
    ////////////////////////////// Get States //////////////////////////////
    
    /**------------Below Method is called as an action on dc_RequestReward Page --------------------------------------------------**/
    public override void init()
    { 
    	System.debug(System.LoggingLevel.INFO, 'dc_ctrl_requestreward.init() {BEGIN}');
    	if (params.size() == 0) return;
    	
    	String giveId = params.get('giveid');
    	if (giveId == null) return;
    	
    	if (give == null) loadGive(giveId);
    	
    	String instanceId = params.get('instanceid');
    	if (instance == null && instanceId != null) loadInstance(instanceId);

     //   User u = [Select u.Id,u.ContactId from User u where u.Id = :UserInfo.getUserId()];
    	//String con = u.ContactId; //params.get('con');

        User u = cov_user_utility.self.getU();
        String con = cov_user_utility.self.getCId();


    	String email = params.get('Email');
    	String memid = params.get('mem-id');
    	
    	// R51
    	//if (con == null) {
    	//	// internal SF platform user
    	//	con = cov_user_utility.self.getCId();
    	//}
    	loadContact(con);

        // SD - 5/14 - Open Gives to contacts based on Member Categories
        if (give != null) { // just to be safe
            if (give.Available_To__c != null && give.Available_To__c.contains('Everyone')) {
                eligibleForReward = true;
                allowGuestSignup = true;
            } else {
                allowGuestSignup = false;
                String giveCategories = give.Available_To__c == null ? 'Confirmed' : give.Available_To__c;

                if (contact != null) {
                    List<String> contactMemberCatsList = contact.Member_Categories__c == null ? new List<String>() : contact.Member_Categories__c.split(';', 0);
                    for (String s : contactMemberCatsList) {
                        if (s != null && s.trim() != '' && giveCategories.contains(s.trim())) {
                            eligibleForReward = true;
                            break;
                        }
                    }
                }
                eligibleForReward = eligibleForReward == null ? false : eligibleForReward;

                giveCategories = giveCategories.replace('Unconfirmed', 'All OEF/OIF/OND Veterans')
                                             .replace('Confirmed', 'Confirmed Member Veterans')
                                             .replace('Other Era', 'Veterans of Other Eras')
                                             .replace('Family', 'Veteran Family Members')
                                             ;
                eligibleList = giveCategories.split(';', 0);
                //eligibleList = cleanAvailableCategories(giveCategories.split(';', 0));
            }
        } else {
            eligibleForReward = false;
            allowGuestSignup = false;
        }

    	
    	super.init();
    	    	
    	request = new Give_Request__c();
    	
    	System.debug(System.LoggingLevel.INFO, 'contact: ' + contact);
    	
		if (contact != null) {
			request.State__c = contact.MailingState;
			request.Zip_Code__c = contact.MailingPostalCode;
			request.State__c = contact.MailingState;
			request.primary_phone__c = contact.Phone;
			request.Email_Address__c = contact.Email;
			System.debug(System.LoggingLevel.INFO, 'Setting Drivers_License__c: ' + contact.Drivers_License__c);
			request.Member_DL_Num__c = contact.Drivers_License__c;
			request.Member_DOB__c = contact.Birthdate;
			request.Member_Shirt_Size__c = contact.Shirt_size__c;
		}
		
		//selectedNumberOfGuests = ticketValue - 1;
	 	System.debug(System.LoggingLevel.INFO, 'selectedNumberOfGuests: ' + selectedNumberOfGuests);
	 	        
        System.debug(System.LoggingLevel.INFO, 'dc_ctrl_requestreward.init() {END}');
    } 
    /**----------------------------------------------Method Ends here -----------------------------------------------**/    
        
    /**------------------------------------Method called when request is submitted by Applicant -------------------------------**/  
    public void submitrequest()
    {
        try
        {
        	saveError = 'false';
        	
            system.debug('age_y:::::::::::::::::submit request:::::' + age_y);
            /** Checking again if the valid contact exists with email and membership number **/
            /*
            listcon = [select id, Name, Email, Membership_ID__c, MailingCity, MailingState, MailingPostalCode,
                MailingStreet,Phone, OtherPhone from contact where
                (((Email = :email or npe01__HomeEmail__c = :email or npe01__WorkEmail__c = :email 
                or npe01__AlternateEmail__c = :email ) and Membership_Id__c =: memid) or id =:con) and Veteran_Member__c = true and 
                Paperwork_Confirmation__c = :CONFIRMED_VET limit 1];
            */
            
            if (ticketValue != null)
            	selectedNumberOfGuests = ticketValue - 1;
                        
            // For guest request, contact may not exist yet
            if (contact == null && contactEmail != null && contactEmail.trim() != '') {
                List<String> cFields = new List<String>{
                                        'Id'
                                        , 'Email'
                                        , 'Shirt_size__c'
                                        , 'Drivers_License__c'
                                        , 'MailingCountry'
                                        , 'MailingCity'
                                        , 'MailingState'
                                        , 'MailingPostalCode'
                                        , 'IAVA_Board_Member__c'
                                        , 'HomePhone'
                                        , 'Gender__c'
                                        , 'Full_Name__c'
                                        , 'Description'
                                        , 'Department'
                                        , 'Current_Status__c'
                                        , 'Birthdate'
                                        , 'Approved_Date__c'
                                        , 'Age__c' 
                                        , 'AccountId'
                                        , 'Membership_ID__c'
                                        , 'MailingStreet'
                                        , 'OtherPhone'
                                        , 'Phone'
                                        , 'Veteran_Member_Status__c'
                                        , 'Member_Categories__c'
                                    };
                List<Contact> theCs = cov_user_contact_utility.getContactsFromEmail(contactEmail, cFields, 'ORDER BY Veteran_Member_Status__c ASC NULLS LAST');  
                if (theCs.size() > 0) {
                    contact = theCs[0];
                } else {
                    // no contact found, insert one
                    contact = new Contact(FirstName = first_name, LastName = last_name, Email = contactEmail);
                    try {
                        insert contact;
                    } catch (Exception e) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry there was an error submitting your request.'));
                        cov_log_error.logError(e, 'problem inserting new contact for give request');
                    }

                }
            }

            if(contact != null) 
            {
                /** Selecting the appropriate Give Instance **/
                if (selectedInstanceId != null && selectedInstanceId.trim() != '')
                	loadInstance(selectedInstanceId);
                else if (give != null && give.Give_Instances__r.size() > 0)
                	loadInstance(give.Give_Instances__r[0].Id);
                else {
                	System.debug(System.LoggingLevel.INFO, 'Unable to load instance.');
                	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.dc_no_instance_error));
                	saveError = 'true';
                	return;
                }
                /** If a give request is already submitted, then throw error **/
                string cont_give = (string.valueof(contact.id)).substring(0,15) + string.valueof(give.id).substring(0,15);
                String requestQuery = 'select id from Give_Request__c where Contact_ID_plus_Give_ID__c = \'' + cont_give + '\' and (Stage__c = \'Final confirmation\' or Stage__c = \'Tentative confirmation\') limit 1';
                //List<Give_Request__c> gr = [select id from Give_Request__c where Contact_ID_plus_Give_ID__c = :cont_give and (Stage__c = 'Final confirmation' or Stage__c = 'Tentative confirmation') limit 1];
                List<Give_Request__c> gr = (List<Give_Request__c>)cov_nosharing_utilities.runListQuery(requestQuery);

                String gstage = getStage();
                
                if(gr.size() > 0 && (gstage == 'Final confirmation' || gstage ==  'Tentative confirmation'))
                {
                    system.debug('inside error');
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.dc_multiple_giverequest_error);
                    ApexPages.addMessage(myMsg);
                    saveError = 'true';
                    return;
                }
                /** Updating other attributes of Give Request from Page and contact details**/
                system.debug('request: ' + request);
                system.debug('contact.id: ' + contact.id);
                request.Applicant__c = contact.id;
                //if(specialresponse != null)
                //    givereq.Special_Response__c = specialresponse;
                if(ticketValue != null)
                    request.Units_Requested__c  = ticketValue;
                else request.Units_Requested__c = 1;
                
                joinContactMailingAddress();
                request.Address__c = contactMailingStreet;
                request.City__c = contactMailingCity;
                
                if(!String.isEmpty(contactMailingState)) request.State__c = contactMailingState;
                request.Zip_Code__c = contactMailingPostalCode;
                request.Give_Instance__c = instance.id;
                request.Contact_ID_plus_Give_ID__c = cont_give;
                //gstart = instance.Date_From__c;
                //request.Make_Address_Primary__c = pRecord;
                //givereq.Special_Response_2__c = givereq_Special_Response_2;
                
                request.Make_Phone_Primary__c = makePhonePrimary == null ? false : makePhonePrimary;
                request.Primary_Phone__c = contactPhone;
                
                request.Make_Email_Primary__c = makeEmailPrimary == null ? false : makeEmailPrimary;
                request.Email_Address__c = contactEmail; // added by SD 12/2012

                request.Member_DL_Num__c = dl_num;
                request.Member_Shirt_Size__c = shirt_size;

                request.Special_Response__c = special_response_1;
                request.Special_Response_2__c = special_response_2;
                request.Special_Response_3__c = special_response_3;
                request.Special_Response_4__c = special_response_4;
                request.Special_Response_5__c = special_response_5;

                request.Terms_Was_Checked__c = terms_was_checked == null ? false : terms_was_checked;

                
                //Insert Give Request

				saveFields();
                if (!validateFields()) {
					saveError = 'true';
				}
	        	if (!validateGuests()) {
	        		saveError = 'true';
				}
                if (saveError != 'false') return;	
                Savepoint sp = Database.setSavepoint();
                
                System.debug('>>>>>>>>>> primaryMailingAddress: ' + primaryMailingAddress);
                System.debug('>>>>>>>>>> Make_Address_Primary__c: ' + request.Make_Address_Primary__c);
                System.debug('>>>>>>>>>> Make_Email_Primary__c: ' + request.Make_Email_Primary__c);
                System.debug('>>>>>>>>>> Make_Phone_Primary__c: ' + request.Make_Phone_Primary__c);
                System.debug('>>>>>>>>>> Address__c: ' + request.Address__c);
                System.debug('>>>>>>>>>> City__c: ' + request.City__c);
                System.debug('>>>>>>>>>> State__c: ' + request.State__c);
                System.debug('>>>>>>>>>> Zip_Code__c: ' + request.Zip_Code__c);
                System.debug('>>>>>>>>>> Email_Address__c: ' + request.Email_Address__c);
                System.debug('>>>>>>>>>> Primary_Phone__c: ' + request.Primary_Phone__c);
                System.debug('>>>>>>>>>> guests: ' + guests);
                
                request.Make_Address_Primary__c = primaryMailingAddress;
                
                System.debug(System.LoggingLevel.INFO, 'givereq: ' + request);
                //insert request; 
                // needs to be run without sharing if it's the guest user
                Database.SaveResult sr = cov_nosharing_utilities.runDatabaseInsert(request, false);
                if (!sr.isSuccess()) {
                    saveError = 'true';
                    for (Database.Error er : sr.getErrors()) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, er.getMessage()));
                    }
                } else {
                    system.debug('give request inserted with id ' + sr.getId());
                }
                //GiveRequest = givereq;
                
                if (request.Make_Address_Primary__c || (contact.MailingStreet == null && request.Address__c != null)) {
                	contact.MailingStreet = request.Address__c;
                	contact.MailingCity = request.City__c;
                	contact.MailingState = request.State__c;
                	contact.MailingPostalCode = request.Zip_Code__c;
                }
                if (request.Make_Email_Primary__c || (contact.Email == null && request.Email_Address__c != null)) {
                	contact.Email = request.Email_Address__c;
                }
                if (request.Make_Phone_Primary__c || (contact.Phone == null && request.Primary_Phone__c != null)) {
                	contact.Phone = request.Primary_Phone__c;
                }
                
                //update contact;
                Database.SaveResult sr2 = cov_nosharing_utilities.runDatabaseUpdate(contact, false);
                if (!sr2.isSuccess()) {
                    cov_log_error.logDevMsg('Error updating contact after inserting give request: ' + request);
                }
                
                /* TODO: why rollback insert of request when member is not bringing any guest?
                   un-commented back out by Sam 12/7/12 -- turns out it happens when Max Units per member is null
                */
                if (!commitGuests()) {
                    system.debug('commitGuests() was false, rolling back request insert and database update.');
                	Database.rollback(sp);
                	return;
                }
                
                //return confirmation page
                //return Page.dc_RequestConfirmation;
                //return null;         
            }
            return;
        }
        catch(exception e)
        { 
        	saveError = 'true';
            // If the exception is because it's a give request on the same give for the same contact then replace the error message to something more friendly
            if(e.getMessage() != null && e.getMessage().contains('duplicate value found: Contact_ID_plus_Give_ID__c duplicates value on record')){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.dc_multiple_giverequest_error));
            } else {
                ApexPages.addMessages(e);
            }
            return;
        }
        
    }
    /**---------------------------------------------Method ends here--------------------------------------------**/
    
    
    public PageReference redirectOnSave() {
    	return Page.cov_rewardconfirmation;
    }
    
    public Boolean getShouldRenderGuests() {
    	if (give == null) return false;
    	
    	return false;
    }

    // Feb 2015 - no longer needed now that guest claim is used    
    //public PageReference ClaimRewardAuthCheck() {
    	
    //	PageReference p = null;
    //	System.debug('UserType: ' + UserInfo.getUserType());
    //	if(UserInfo.getUserType() == 'Guest') {
    //		p = Page.IAVAPlus_SignInPage;
    //		p.setRedirect(true);
    //		p.getParameters().put('startUrl', EncodingUtil.urlEncode(ApexPages.currentPage().getUrl(), 'UTF-8'));
    //		System.debug('SignIn Url: ' + p.getUrl());
    //	} else {
    //		p = super.its();
    //	}
    	
    //	return p;
    //}
    
    public void LoadSuccessInfo() {
        
        loadInstance(selectedInstanceId);

        User u = [Select u.Id,u.ContactId from User u where u.Id = :UserInfo.getUserId()];
        String con = u.ContactId; //params.get('con');
        
        // R51
    	if (con == null) {
    		// internal SF platform user
    		con = cov_user_utility.self.getCId();
    	}
        loadContact(con);
        
        super.init();
                
        request = new Give_Request__c();
        
        System.debug(System.LoggingLevel.INFO, 'contact: ' + contact);
        
        if (contact != null) {
            request.State__c = contact.MailingState;
            request.Zip_Code__c = contact.MailingPostalCode;
            request.State__c = contact.MailingState;
            request.primary_phone__c = contact.Phone;
            request.Email_Address__c = contact.Email;
            System.debug(System.LoggingLevel.INFO, 'Setting Drivers_License__c: ' + contact.Drivers_License__c);
            request.Member_DL_Num__c = contact.Drivers_License__c;
            request.Member_DOB__c = contact.Birthdate;
            request.Member_Shirt_Size__c = contact.Shirt_size__c;
        }
    }
        
    /**************************************************  Helper/Utility Methods  *********************************************/
    	
	public Boolean getPromptForGuests() {
		//if (ticketValue != null) selectedNumberOfGuests = ticketValue - 1;
		
		System.debug(System.LoggingLevel.INFO, 'getProm	ptForGuests()');
		System.debug(System.LoggingLevel.INFO, 'ticketValue: ' + ticketValue);
		System.debug(System.LoggingLevel.INFO, 'selectedNumberOfGuests: ' + selectedNumberOfGuests);
		System.debug(System.LoggingLevel.INFO, 'give: ' + give);
		
        // 10/2015 default selected guest quantity to 0 but still leave guest option so commenting next
		//if (selectedNumberOfGuests == 0) return false;

		//if (give == null || give.Maximum_Units_per_Member__c == null) return false;
		
		System.debug(System.LoggingLevel.INFO, 'getCollectGuestName: ' + getCollectGuestName() + '; getCollectGuestDLNum: ' + getCollectGuestDLNum() +
			'; getCollectGuestDOB: ' + getCollectGuestDOB() + '; getCollectGuestShirtSize: ' + getCollectGuestShirtSize());
		
		return 	getCollectGuestName() ||
				getCollectGuestDLNum() ||
			   	getCollectGuestDOB() ||
			   	getCollectGuestShirtSize();
		/*
		return (give.Collect_Guest_DL_Num__c == 'at request' || 
				give.Collect_Guest_DOB__c == 'at request' ||
				give.Collect_Guest_Shirt_Size__c == 'at request' ||
				give.Guest_Name_Required__c);
				*/
	}

	public Boolean getShouldShowGuestsDivider() {
		if (getPromptForGuestAge21()) return true;
		if (getPromptForGuests()) return true;
		return false;
	}
	
	public Boolean getShowSpecialSectionDivider() {
		return 	getCollectSpecialResponse() ||
				getCollectSpecialResponse2() ||
				getCollectSpecialResponse3() ||
				getCollectSpecialResponse4() ||
				getCollectSpecialResponse5();
	}

    public static String cleanAvailableCategories(List<String> categoriesIn) {
        String cleanedCatsString = '';
        for (Integer i = 0 ; i < categoriesIn.size() ; i++ ) {
            if (i > 0 && i == categoriesIn.size() - 1) {
                cleanedCatsString += ' and ';
            }
            String cleanedCategory;
            if (categoriesIn[i] == 'Confirmed') { cleanedCategory = 'Confirmed Member Veterans'; }
            else if (categoriesIn[i] == 'Unconfirmed') { cleanedCategory = 'Unconfirmed OEF/OIF/OND Veterans'; }
            else if (categoriesIn[i] == 'Other Era') { cleanedCategory = 'Veterans of Other Eras'; }
            else if (categoriesIn[i] == 'Family') { cleanedCategory = 'Veteran Family Members'; }
            else { cleanedCategory = categoriesIn[i]; }
            
            cleanedCatsString += cleanedCategory;
            if (i > 1 && i < categoriesIn.size() - 1) {
                cleanedCatsString += ', ';
            }
        }
        return cleanedCatsString;
    }

    public static Give_Request__c updateStage(Id giveId, Id contactId, String newStage) {
        Give_Request__c gr;
        try {
            gr = [select Id, Stage__c from Give_Request__c where Applicant__c = :contactId and Give_Instance__r.Give__c = :giveId];
        } catch (Exception e) {
            cov_log_error.logError(e, 'give request not found in query when trying to update stage.');
            return null;
        }
        gr.Stage__c = newStage;
        try {
            update gr;
        } catch (Exception e) {
            cov_log_error.logError(e, 'error trying to update give request when trying to update stage to: ' + newStage);
        }
        return gr;
    }


}