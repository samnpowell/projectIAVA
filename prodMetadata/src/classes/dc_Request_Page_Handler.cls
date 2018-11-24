public virtual with sharing class dc_Request_Page_Handler {
    
    //////////////////// Primary Object /////////////////////////
    public Give__c                      give        { get; set; }
    public Give_Instance__c             instance    { get; set; }
    public Give_Request__c              request     { get; set; }
    public Contact                      contact     { get; set; }
    public List<Give_Request_Guest__c>  guests      { get; set; }
    
    ///////////////////// Page Field Variables //////////////////////////////
    public map<String,String>           params                  { get; set; } 
    public Integer                      ticketValue             { get; set; }
    public String                       administratorEmail      { get; set; }
    public String                       selectedInstanceId      { get; set; }
    public Boolean                      primaryMailingAddress   { get; set; }
    public Integer                      selectedNumberOfGuests  { get; set; }
    public String                       mail_body               { get; set; }
    public Boolean                      age_y                   { get; set; }   
    public Boolean                      age_n                   { get; set; }
    public Boolean                      guest_age_y             { get; set; }
    public Boolean                      guest_age_n             { get; set; }
    public String                       confirmGuestAge21       { get; set; }

    public String                       dl_num                  { get; set; }
    public String                       first_name              { get; set; }
    public String                       last_name               { get; set; }
    public String                       shirt_size              { get; set; }
    public String                       special_response_1      { get; set; }
    public String                       special_response_2      { get; set; }
    public String                       special_response_3      { get; set; }
    public String                       special_response_4      { get; set; }
    public String                       special_response_5      { get; set; }
    public Boolean                      terms_was_checked       { get; set; }
    
        
    //////////////////////// Save Variables /////////////////////////////////
    public String   saveError   { get; set; }
    
    ///////////////////// Editable Contact Fields ///////////////////////////
    public String contactMailingStreet          { get; set; }
    public String contactMailingAddressLine1    { get; set; }
    public String contactMailingAddressLine2    { get; set; }
    public String contactMailingCountry         { get; set; }
    public String contactMailingCity            { get; set; }
    public String contactMailingState           { get; set; }
    public String contactMailingPostalCode      { get; set; }
    public String contactPhone                  { get; set; }
    public String contactEmail                  { get; set; }
    public String contactBirthdate              { get; set; }
    public String contactName                   { get; set; }
            
    
    /////////////////// Control Variables ///////////////////////////
    public String pageState { get; set; }
    public Boolean HasValidationErrors { get; set; } 
    private List<Give_Request_Guest__c> removedGuests;
    
    
    /**************** Constructor *******************************/
    public dc_Request_Page_Handler() {
        System.debug(System.LoggingLevel.INFO, 'dc_Request_Page_Handler() START');
        
        params = ApexPages.CurrentPage().getParameters();
        
        Rucksack_Settings__c appSettings = Rucksack_Settings__c.getInstance();
        
        administratorEmail = ((appSettings == null) || (appSettings.Administrator_Email__c == null)) ? 'rucksack@iava.org' : appSettings.Administrator_Email__c;
        
        //this.pageState = pageState;
        
        saveError = 'false';
        //selectedInstanceId = '';
        primaryMailingAddress = false;
        
        System.debug(System.LoggingLevel.INFO, 'dc_Request_Page_Handler() END');
        
    }

    public dc_Request_Page_Handler(String pageState) {
        System.debug(System.LoggingLevel.INFO, 'dc_Request_Page_Handler() START');
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        
        params = ApexPages.CurrentPage().getParameters();
        
        Rucksack_Settings__c appSettings = Rucksack_Settings__c.getInstance();
        
        administratorEmail = ((appSettings == null) || (appSettings.Administrator_Email__c == null)) ? 'rucksack@iava.org' : appSettings.Administrator_Email__c;
        
        this.pageState = pageState;
        
        saveError = 'false';
        //selectedInstanceId = '';
        primaryMailingAddress = false;
        
        System.debug(System.LoggingLevel.INFO, 'dc_Request_Page_Handler() END');
    }
    
    public virtual void init() {
        
        if (give != null) mail_body =  System.Label.dc_RewardDetail_Mail_Body +  '%0d' + '%0d' + 'Reward Title: ' + give.Name + '%0d' + 'Reward Link: ' ;
        
    }
    
    /*************** loadGive ***********************************/
    public void loadGive(String giveId) {
        System.debug(System.LoggingLevel.INFO, 'Handler.loadGive()');
        System.debug(System.LoggingLevel.INFO, 'giveId: ' + giveId);
        
        if (giveId == null) return;
        
        give = [select 
                    id, Category__c,available__c, Waitlist__c,status__c,Location_Formula__c, Deadline__c,type__c, name, Disclaimer__c, Number_Remaining__c,City__c, Location_by_State_s__c,Zip_Code_s__c,
                    description__c,Partnership_Request__c,Requires_Special_Response__c,Special_Instructions__c,Latest_Application_Deadline__c,Must_be_21__c, Must_be_21_for_guest__c,
                    location_description__c,Member_Cannot_Select_Quantity__c,Partnership_Request__r.Public_Partner_Name__c,Maximum_Units_per_Member__c, Fulfillment_Instructions_rtf__c,
                    Show_Terms_and_Conditions__c, Terms_and_Conditions__c,
                    (select 
                        id, status__c,start_date__c, Location__c,start_time__c, end_date__c, end_time__c, date_to__c, date_from__c, 
                        year_start_date__c,year_end_date__c, Differentiator__c 
                        from Give_Instances__r 
                        order by start_date__c asc),
                    (select id From Attachments where Name like '%logo%' limit 1),
                    Collect_Special_Response_5__c, Collect_Special_Response_4__c, Collect_Special_Response_3__c, 
                    Collect_Special_Response_2__c, Collect_Member_Shirt_Size__c, Collect_Member_DOB__c, Collect_Member_DL_Num__c, 
                    Collect_Guest_Shirt_Size__c, Collect_Guest_DOB__c, Collect_Guest_DL_Num__c,Collect_Guest_Name__c,
                    Special_Instructions_5__c, Special_Instructions_4__c, Special_Instructions_3__c, Special_Instructions_2__c
                    , Available_To__c
                    , Collect_Mailing_Address__c, Collect_Phone_Number__c
                From Give__c 
                Where Id=:giveId
                limit 1];

                            
        System.debug(System.LoggingLevel.INFO, 'give: ' + give);
    }

    public void loadInstance(String instanceId) {
        System.debug(System.LoggingLevel.INFO, 'Handler.loadInstance()');
        System.debug(System.LoggingLevel.INFO, 'instanceId: ' + instanceId);
        

        if (instanceId == null) return;
        
        instance =  [Select 
                        g.Reconfirm_date__c, g.Give__c , g.id, g.status__c, g.date_to__c, g.date_from__c, g.year_start_date__c,
                        g.year_end_date__c, g.Start_Date__c, g.Tentative_Number_Remaining__c, g.Number_Remaining__c 
                    From Give_Instance__c g 
                    where (id = :instanceId) 
                    limit 1];
                    
        if (instance != null){
            selectedInstanceId = instance.Id;
            System.debug(System.LoggingLevel.INFO, 'loadInstance instance: ' + instance);
        } else {
            selectedInstanceId = '';
        }

        System.debug(System.LoggingLevel.INFO, 'instance: ' + instance);                
    }

    /*************** loadRequest ***********************************/
    public void loadRequest(String requestId) {
        System.debug(System.LoggingLevel.INFO, 'Handler.loadRequest()');
        System.debug(System.LoggingLevel.INFO, 'requestId: ' + requestId);

        if (requestId == null) return;

        List<Give_Request__c> requests = [Select 
                        g.Id, g.Zip_Code__c, g.Units_Requested__c, g.State__c, g.Special_Response__c, g.Special_Response_5__c, 
                        g.Special_Response_4__c, g.Special_Response_3__c, g.Special_Response_2__c, g.Secondary_Phone__c, 
                        g.Re_confirm_Status__c, g.Re_confirm_Count__c, g.Primary_Phone__c, g.Platform__c, 
                        g.Num_Confirmed_Give_Requests__c, g.Name, g.Make_Phone_Primary__c, g.Make_Email_Primary__c, 
                        g.Make_Address_Primary__c, g.Guest_s_21_and_Over__c, g.Give_Instance__c, g.Email_Address__c, 
                        g.Date_of_Re_confirm__c, g.Contact_ID_plus_Give_ID__c, g.Confirmed_21__c, g.City__c, 
                        g.Availability__c, g.Attended__c, g.Applicant__c, g.Address__c, Stage__c, 
                        Give_Instance__r.Give__r.Fulfillment_Instructions_rtf__c, Member_DL_Num__c, Member_DOB__c,
                        Member_Shirt_Size__c
                    From Give_Request__c g 
                    where (ID= :requestId)
                    limit 1];
        
        if (requests != null && requests.size() > 0) request = requests[0];

        if (request != null) {
            loadGuests();
            /*              
            guests = [Select g.Shirt_Size__c,g.Name, g.Name__c, g.First_Name__c, g.Last_Name__c, g.Give_Id__c, g.Id, g.Give_Request__c, g.Drivers_License__c, g.Birthdate__c, g.TMP_Birthdate__c From Give_Request_Guest__c g where (g.Give_Request__c= : request.Id)];
            
            if (guests != null && guests.size() > 0) {
                for (Give_Request_Guest__c guest : guests) {
                    if (guest.Birthdate__c != null)
                        guest.TMP_Birthdate__c = guest.Birthdate__c.format();
                    else
                        guest.TMP_Birthdate__c = null;
                }               
            }
            */
        }
                                    
        System.debug(System.LoggingLevel.INFO, 'request: ' + request);      
    }

    public void loadGuests() {
        System.debug(System.LoggingLevel.INFO, 'loadGuests (Begin)');
        if (guests != null) guests.clear();
        //guests = [Select 
        //                    g.SystemModstamp, g.Shirt_Size__c, g.OwnerId, g.Name__c, g.Name, g.Last_Name__c, g.LastModifiedDate, 
        //                    g.LastModifiedById, g.IsDeleted, g.Id, g.Give_Request__c, g.Give_Id__c, g.First_Name__c, 
        //                    g.Drivers_License__c, g.CreatedDate, g.CreatedById, g.Birthdate__c, g.TMP_Birthdate__c 
        //            From Give_Request_Guest__c g 
        //            Where g.Give_Request__c = :request.Id];
        if (request != null && request.Id != null) {
            String guestsQuery ='Select'
                                + ' g.SystemModstamp, g.Shirt_Size__c, g.OwnerId, g.Name__c, g.Name, g.Last_Name__c, g.LastModifiedDate'
                                + ', g.LastModifiedById, g.IsDeleted, g.Id, g.Give_Request__c, g.Give_Id__c, g.First_Name__c'
                                + ', g.Drivers_License__c, g.CreatedDate, g.CreatedById, g.Birthdate__c, g.TMP_Birthdate__c'
                        + ' From Give_Request_Guest__c g'
                        + ' Where g.Give_Request__c = \'' + request.Id + '\'';
            guests = cov_nosharing_utilities.runListQuery(guestsQuery);
        }
        System.debug(System.LoggingLevel.INFO, 'loadGuests (End)');
        
        if (guests == null) return;
        
        for (Give_Request_Guest__c guest : guests) {
            if (guest.Birthdate__c != null)
                guest.TMP_Birthdate__c = guest.Birthdate__c.format();
            else
                guest.TMP_Birthdate__c = null;
                
            if (request != null && request.Id != null && guest.Give_Request__c == null) {
                guest.Give_Request__c = request.Id;
            }
                
        }
    }
    
    /*************** loadContact ***********************************/
    public void loadContact(String contactId) {
        System.debug(System.LoggingLevel.INFO, 'Handler.loadContact()');
        System.debug(System.LoggingLevel.INFO, 'contactId: ' + contactId);

        if (contactId == null) return;

        contact =   [Select 
                        c.Shirt_size__c,c.Drivers_License__c, c.MailingCountry, c.MailingCity, c.Id, c.MailingState,
                        c.MailingPostalCode, c.IAVA_Board_Member__c, c.HomePhone, c.Gender__c, c.Full_Name__c, c.Email, 
                        c.Name, c.Description, c.Department, c.Current_Status__c, c.Birthdate, c.Approved_Date__c, c.Age__c, 
                        c.AccountId, c.Membership_ID__c, c.MailingStreet, c.OtherPhone, c.Phone,
                        c.Veteran_Member_Status__c
                        , c.Member_Categories__c, c.FirstName, c.LastName
                    From Contact c 
                    where (id = : contactId)
                    limit 1];

        setContactFields();
        
        System.debug(System.LoggingLevel.INFO, 'contact: ' + contact);      
    }

    public void loadContact(String contactId, string emailAddress, string memberId) {
        System.debug(System.LoggingLevel.INFO, 'Handler.loadContact()');
        System.debug(System.LoggingLevel.INFO, 'contactId: ' + contactId);

        if (contactId == null) return;

        contact =   [Select 
                        c.Shirt_size__c,c.Drivers_License__c, c.MailingCountry, c.MailingCity, c.Id, c.MailingState,
                        c.MailingPostalCode, c.IAVA_Board_Member__c, c.HomePhone, c.Gender__c, c.Full_Name__c, c.Email, 
                        c.Name, c.Description, c.Department, c.Current_Status__c, c.Birthdate, c.Approved_Date__c, c.Age__c, 
                        c.AccountId, c.Membership_ID__c, c.MailingStreet, c.OtherPhone, c.Phone
                        , c.Member_Categories__c, c.FirstName, c.LastName
                    From Contact c 
                    Where (( Email = :emailAddress and Membership_Id__c = :memberId) or id =: contactId)
                    limit 1];
                    
        setContactFields();
                    
        System.debug(System.LoggingLevel.INFO, 'contact: ' + contact);
    }
    
    private void setContactFields() {
        if (contact != null) {
            contactMailingCountry       = contact.MailingCountry;
            contactMailingCity          = contact.MailingCity;
            contactMailingState         = contact.MailingState;
            contactMailingPostalCode    = contact.MailingPostalCode;
            contactPhone                = contact.Phone;
            contactEmail                = contact.Email;
            contactName                 = contact.Name;
            first_name                  = contact.FirstName;
            last_name                   = contact.LastName;
            
            splitContactMailingAddress(contact.MailingStreet);
            if (contact.Birthdate != null)  contactBirthdate = contact.Birthdate.format();

            dl_num = contact.Drivers_License__c;
            shirt_size = contact.Shirt_size__c;

        }       
    }
        
    private void splitContactMailingAddress(String mailingAddress) {
        if (mailingAddress == null) {
            contactMailingStreet = null;
            contactMailingAddressLine1 = null;
            contactMailingAddressLine2 = null;
            return;
        }
        
        List<String> addressParts = mailingAddress.split('\n');
        contactMailingAddressLine1 = addressParts[0];
        
        if (addressParts.size() > 1) contactMailingAddressLine2 = addressParts[1];
    }
    
    public String joinContactMailingAddress() {
        if (contactMailingAddressLine1 != null && contactMailingAddressLine2 != null) 
            contactMailingStreet = contactMailingAddressLine1 + '\n' + contactMailingAddressLine2;
        else if (contactMailingAddressLine1 != null && contactMailingAddressLine2 == null)
            contactMailingStreet = contactMailingAddressLine1;
        else if (contactMailingAddressLine1 == null && contactMailingAddressLine2 != null)
            contactMailingStreet = contactMailingAddressLine2;
        else
            contactMailingStreet = null;
        
        return contactMailingStreet;
    }
        
    /************************************************************************************************************************/
    /************************************************************************************************************************/
    
    ////////////////////////////////////////////////  Collect Flags //////////////////////////////////////////////////////////
    
    /************************************************************************************************************************/
    /************************************************************************************************************************/
    public Boolean getCollectMemberDOB() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectMemberDOB()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        
        return give.Collect_Member_DOB__c == pageState;
    }
    
    public Boolean getCollectMemberDLNum() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectMemberDLNum()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        System.debug(System.LoggingLevel.INFO, 'Collect_Member_DL_Num__c: ' + give.Collect_Member_DL_num__c);
        
        return give.Collect_Member_DL_Num__c == pageState;
    }
    
    public Boolean getCollectMemberShirtSize() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectMemberShirtSize()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        
        return give.Collect_Member_Shirt_Size__c == pageState;
    }

    public Boolean getCollectGuestName() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectGuestName()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        
        return (give.Collect_Guest_Name__c == pageState) || (pageState == 'at re-confirm' && give.Collect_Guest_Name__c == 'at request' && ( getCollectGuestDOB() || getCollectGuestDLNum() || getCollectGuestShirtSize()));
    }
    
    public Boolean getCollectGuestDOB() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectGuestDOB()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        System.debug(System.LoggingLevel.INFO, 'Collect_Guest_DOB__c: ' + give.Collect_Guest_DOB__c);
        Boolean returnValue = give.Collect_Guest_DOB__c == pageState || (give.Collect_Guest_DOB__c == 'at request'); 
        System.debug(System.LoggingLevel.INFO, 'getCollectGuestDOB.return: ' + returnValue);
        return returnValue;
    }
    
    public Boolean getCollectGuestDLNum() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectGuestDLNum()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        
        return give.Collect_Guest_DL_Num__c == pageState || (give.Collect_Guest_DOB__c == 'at request');
    }
    
    public Boolean getCollectGuestShirtSize() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectGuestShirtSize()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        
        return give.Collect_Guest_Shirt_Size__c == pageState || (give.Collect_Guest_Shirt_Size__c == 'at request');
    }

    public Boolean getCollectSpecialResponse() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectSpecialResponse()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        
        return give != null && give.Requires_Special_Response__c;
    }
    
    public Boolean getCollectSpecialResponse2() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectSpecialResponse2()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        
        return give.Collect_Special_Response_2__c == pageState;
    }

    public Boolean getCollectSpecialResponse3() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectSpecialResponse3()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        
        return give.Collect_Special_Response_3__c == pageState;
    }

    public Boolean getCollectSpecialResponse4() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectSpecialResponse4()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        
        return give.Collect_Special_Response_4__c == pageState;
    }

    public Boolean getCollectSpecialResponse5() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectSpecialResponse5()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'pageState: ' + pageState);
        
        return give.Collect_Special_Response_5__c == pageState;
    }
    
    public Boolean getCollectQuantity() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectQuantity()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        
        return give != null && !give.Member_Cannot_Select_Quantity__c && give.Maximum_Units_per_Member__c != null && give.Maximum_Units_per_Member__c > 1;      
    }
    
    public Boolean getCollectMemberAgeVerification() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectMemberAgeVerification()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        
        return give != null && !give.Must_be_21__c != null && give.Must_be_21__c && pageState == 'at request';      
    }
    
    public Boolean getPromptForGuestAge21() {
        if (!give.Must_be_21_for_guest__c) return false;
        if (give.Maximum_Units_per_Member__c == null) return false;
        //10/2015 default to 0 guests so need this property to come up true even when no guests selected
        //return selectedNumberOfGuests > 0;
        return true;
    }

    public Boolean getCollectTermsAndConditions() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getCollectTermsAndConditions()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        
        return give != null && give.Terms_and_Conditions__c != null && give.Show_Terms_and_Conditions__c;      
    }

    public Boolean getCollectMailingAddress() {
        return give != null && give.Collect_Mailing_Address__c;
    }

    public Boolean getCollectPhoneNumber() {
        return give != null && give.Collect_Phone_Number__c;
    }

    
    /************************************************************************************************************************/
    /************************************************************************************************************************/
    
    ////////////////////////////////////////////  Special Instructions ///////////////////////////////////////////////////////
    
    /************************************************************************************************************************/
    /************************************************************************************************************************/
    
    public String getSpecialInstructions2() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getSpecialInstructions2()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'give.Special_Instructions_2__c: ' + give.Special_Instructions_2__c);
        
        if (give != null) return give.Special_Instructions_2__c;
        return null;
    }

    public String getSpecialInstructions3() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getSpecialInstructions3()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'give.Special_Instructions_3__c: ' + give.Special_Instructions_3__c);
        
        if (give != null) return give.Special_Instructions_3__c;
        return null;
    }

    public String getSpecialInstructions4() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getSpecialInstructions4()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'give.Special_Instructions_2__c: ' + give.Special_Instructions_4__c);
        
        if (give != null) return give.Special_Instructions_4__c;
        return null;
    }

    public String getSpecialInstructions5() {
        System.debug(System.LoggingLevel.INFO, 'Handler.getSpecialInstructions5()');
        System.debug(System.LoggingLevel.INFO, 'give is null? ' + (give == null));
        System.debug(System.LoggingLevel.INFO, 'give.Special_Instructions_5__c: ' + give.Special_Instructions_5__c);
        
        if (give != null) return give.Special_Instructions_5__c;
        return null;
    }
    
    
    public Boolean getMultipleInstances() {
        if (give == null) return false;
        return give.Give_Instances__r.size() > 1;
    }
    
    public List<SelectOption> getInstanceOptions()
    {
        try
        {
            string opt;
            integer n;
            string gwhen = '';
            List<SelectOption> options = new List<SelectOption>();
            for(integer i=0;i<give.Give_Instances__r.size();i++)
            {
                // NGKJ - show add'l information
                Give_Instance__c instance = give.Give_Instances__r[i];
                
                System.Debug('NGKJ - give: ' + give);
                System.Debug('NGKJ - Give Instance: ' + instance);
                
                n = i+1;
                
                gwhen = ' ';
                if(instance.date_from__c != null && instance.date_to__c != null &&  instance.date_from__c.contains(' ') && instance.date_to__c.contains(' ') && instance.date_from__c.split(' ')[0] == instance.date_to__c.split(' ')[0] && instance.date_from__c != instance.date_to__c) 
                    gwhen = gwhen + instance.date_from__c + ' - ' + instance.date_to__c  + ', ' + instance.Year_Start_Date__c;
        
                if(instance.date_from__c != null && instance.date_to__c != null &&  instance.date_from__c == instance.date_to__c) 
                    gwhen = gwhen + instance.date_from__c + ', ' + instance.Year_Start_Date__c; 
        
                system.debug('gwhen........2....................................' + gwhen);
                //else if(instance.date_from__c != null && instance.date_to__c != null && instance.date_from__c.split(',')[0] != giveinst.date_to__c.split(',')[0]) 
                //  gwhen = gwhen + giveinst.date_from__c + ' - ' + giveinst.date_to__c;
        
                system.debug('gwhen.........3...................................' + gwhen);
                if(instance.date_from__c != null && instance.date_to__c == null)    
                    gwhen = gwhen + instance.date_from__c  + ', ' + instance.Year_Start_Date__c; 
        
                system.debug('gwhen.........4...................................' + gwhen);
                if(instance.date_from__c == null && instance.date_to__c != null)    
                    gwhen = gwhen + instance.date_to__c + ', ' + instance.Year_End_Date__c;
        
                system.debug('gwhen............5................................' + gwhen);
                if((instance.date_from__c != null && instance.date_to__c != null && instance.date_from__c == instance.date_to__c) || instance.date_to__c == null || instance.date_from__c == null)
                {
                    if(instance.start_time__c != null || instance.end_time__c != null)
                        gwhen = gwhen + ' | ';
        
                    system.debug('gwhen............6................................' + gwhen);
                    if(instance.start_time__c != null) 
                        gwhen = gwhen + instance.start_time__c;
        
                    system.debug('gwhen..............7..............................' + gwhen);
                    if(instance.end_time__c != null)
                        gwhen = gwhen + '-';
        
                    system.debug('gwhen...............8.............................' + gwhen);
                    if(instance.end_time__c != null   )
                        gwhen = gwhen + instance.end_time__c; 
       
                    system.debug('gwhen................9............................' + gwhen);
                }
                
                // NGKJ - Show additional information - Waitlisted ? Number Remaining ...
                // gwhen = gwhen + ' (' + instance.Status__c + ' - ' + instance.Number_Remaining__c + ' remaining) '; // Too long - doesn't display.
                if (instance.Status__c == 'Open')
                    gwhen = gwhen + ' (Available) ';
                else
                    gwhen = gwhen + ' (' + instance.Status__c + ') ';
                // if (instance.Status__c == 'Waitlist') gwhen = gwhen + ' (Waitlisted) ';
                
                opt = gwhen;
                if (String.isNotBlank(instance.Differentiator__c)) {
                    opt += ' | ' + instance.Differentiator__c;
                }
                if(instance.status__c!='Closed') options.add(new SelectOption(instance.id,opt));
            }
            return options;  
        }
        catch(exception e)
        { 
            return null;
        }  
    }
    
    public List<SelectOption> getStateOptions()
    {
        List<SelectOption> options = new List<SelectOption>(); 
        
        // NGKJ - Use the Schema to determine the list of States ...
        Set<String> sset = new Set<String>();
        List<Schema.PicklistEntry> states = Give_Request__c.State__c.getDescribe().getPicklistValues();
        System.Debug('NGKJ - State Picklist Values: ' + states);
        for (Schema.PicklistEntry state : states)
            if (state.isActive())
                sset.add(state.getValue());
        // NGKJ - add User State if it's not there ...
        System.Debug('NGKJ - sset: ' + sset);
        //System.Debug('NGKJ - givereq.State__c' + request.State__c);
        if (request != null && request.State__c == null) sset.add(''); else sset.add(request.State__c); 
        System.Debug('NGKJ - sset: ' + sset);
        // NGKJ - add User State if it's not there ...
        // NGKJ - now make the set a List for sorting
        List<string> stlist = new List<String>();
        stlist.addAll(sset);        
        stlist.sort(); 
        System.Debug('NGKJ - stlist: ' + stlist);
        for(integer i=0;i<stlist.size();i++)
            options.add(new SelectOption(stlist[i],stlist[i]));
                
        return options;       
    }
    
    public List<SelectOption> getYesNoOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('YES','YES'));
        options.add(new SelectOption('NO','NO'));
        return options;    
    }

    public String getLogo() {
        string logo = ' ';

        if(give != null && give.Attachments != null && give.Attachments.size() > 0)
            logo = '/servlet/servlet.FileDownload?file=' + give.Attachments[0].id;
        
        return logo;
    }
    
    public String getDefaultLogo() {
        if (give == null) return '.jpg';
        
        return give.Category__c + '.jpg';
    }
    
    public string getWhen() {
        if (give == null) return ' ';
        
        String gwhen = null;
        if(give.Give_Instances__r.size() > 1) {
            //multigive = true;
            gwhen = 'Multiple Dates & Times | ';
            if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c != null && give.Give_Instances__r[0].date_from__c.contains(' ') && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c.contains(' ') && give.Give_Instances__r[0].date_from__c.split(' ')[0] == give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c.split(' ')[0]) 
                gwhen = gwhen + give.Give_Instances__r[0].date_from__c.split(' ')[0] + ' ' + give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c.split(' ')[1];
            if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c != null && give.Give_Instances__r[0].date_from__c.contains(' ') && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c.contains(' ') && give.Give_Instances__r[0].date_from__c.split(' ')[0] != give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c.split(' ')[0]) 
                gwhen = gwhen + give.Give_Instances__r[0].date_from__c + ' - ' + give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c;
            if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c == null)    
                gwhen = gwhen + give.Give_Instances__r[0].date_from__c; 
            if(give.Give_Instances__r[0].date_from__c == null && give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c != null)    
                gwhen = gwhen + give.Give_Instances__r[give.Give_Instances__r.size()-1].date_to__c;
            system.debug('noofgiveinst = true');
        } else {
            gwhen = ' ';
            if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[0].date_to__c != null && give.Give_Instances__r[0].date_from__c.contains(' ') && give.Give_Instances__r[0].date_to__c.contains(' ') &&  give.Give_Instances__r[0].date_from__c.split(' ')[0] == give.Give_Instances__r[0].date_to__c.split(' ')[0]) 
                gwhen = gwhen + give.Give_Instances__r[0].date_from__c + ' - ' + give.Give_Instances__r[0].date_to__c.split(' ')[1];
            
            if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[0].date_to__c != null && give.Give_Instances__r[0].date_from__c == give.Give_Instances__r[0].date_to__c) 
                gwhen = gwhen + give.Give_Instances__r[0].date_from__c + ', ' + give.Give_Instances__r[0].Year_Start_Date__c; 
            if(give.Give_Instances__r[0].date_from__c != null && give.Give_Instances__r[0].date_to__c == null)  
                gwhen = gwhen + give.Give_Instances__r[0].date_from__c + ', ' + give.Give_Instances__r[0].Year_Start_Date__c; 
            if(give.Give_Instances__r[0].date_from__c == null && give.Give_Instances__r[0].date_to__c != null)  
                gwhen = gwhen + give.Give_Instances__r[0].date_to__c  + ', ' + give.Give_Instances__r[0].Year_End_Date__c;
            if(give.Give_Instances__r[0].start_time__c != null || give.Give_Instances__r[0].end_time__c != null)
                gwhen = gwhen + '| ';
            if(give.Give_Instances__r[0].start_time__c != null) 
                gwhen = gwhen + give.Give_Instances__r[0].start_time__c;
            if(give.Give_Instances__r[0].start_time__c != null && give.Give_Instances__r[0].end_time__c != null)
                gwhen = gwhen + '-';
            if(give.Give_Instances__r[0].end_time__c != null)
                gwhen = gwhen + give.Give_Instances__r[0].end_time__c;
        }
        return gwhen;    
    }
    
    public String getWhere() {
        String gwhere = ' ';
        
        if (give == null) return gwhere;
        
        if(give.Location_Description__c != null)
            gwhere = give.Location_Description__c;
        else if(give.City__c != null)
            gwhere = give.City__c;
        else if(give.Location_Formula__c == 'National')
            gwhere = 'National';
        else if(give.Location_Description__c != null)
            gwhere = give.Location_Description__c;
        else if(give.City__c != null && give.Location_by_State_s__c != null)
            gwhere = give.City__c + ', ' + give.Location_by_State_s__c;
        else if(give.City__c != null && give.Location_by_State_s__c == null) 
            gwhere = give.City__c + ', ' + give.Zip_Code_s__c;
        else if(give.City__c == null && give.Location_by_State_s__c != null)
            gwhere = give.Location_by_State_s__c;
        else if(give.City__c == null && give.Location_by_State_s__c == null)
            gwhere = give.Zip_Code_s__c;    
        else gwhere = give.Location_Formula__c;
        
        return gwhere;
    }
        
    public String getQuantity() {
        if (give == null) return ' ';
        if(give.Maximum_Units_per_Member__c != null && give.Maximum_Units_per_Member__c != 0)   
            return give.Maximum_Units_per_Member__c + ' per veteran';
        if(give.Maximum_Units_per_Member__c == null)
            return 'Unlimited';
            
        return ' ';
    }
    
    public String getDeadline() {
        String deadline = ' ';  
        if (give == null) return 'N/A';
            
        if(give.Latest_Application_Deadline__c != null)
            deadline = give.Deadline__c;
        else deadline = 'N/A';
        return deadline;
    }
    
    public String getAgeLimit() {
        if (give == null) return ' ';
        
        String agelimit = ' ';
        if(give.Must_be_21__c == true)
            agelimit = 'AGE 21+';
        return agelimit;
    }

    public List<SelectOption> getTicketOptions()
    {
        string opt;
        integer n;
        List<SelectOption> options = new List<SelectOption>();
        for(integer i=0;i<give.Maximum_Units_per_Member__c;i++)
        {
            n = i+1;
            opt = n + ' Tickets';
            options.add(new SelectOption(string.valueof(n),opt));
        }  
        return options;    
    }   

    ////////////////////////////// Get Shirt Sizes //////////////////////////////
    public List<SelectOption> getShirtSizeOptions(){
        List<SelectOption> options = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult = Schema.sObjectType.Contact.fields.Shirt_size__c;
        List<Schema.PicklistEntry> picklistEntries = fieldResult.getPicklistValues();
        
        options.add(New SelectOption('', '-None-'));
        
        for(Schema.PicklistEntry entry : picklistEntries){
            options.add(new SelectOption(entry.getLabel(), entry.getLabel()));
        }
        
        return options;
    }
    
    public virtual String getStage() {
        String stage = null;
        
        System.debug(give);
        System.debug(instance);
        
        if (give != null) {
            System.debug('give.Status__c: ' + give.Status__c);
            System.debug('give.Type__c' + give.Type__c);
            System.debug('give.Waitlist__c: ' + give.Waitlist__c);
        }
        
        if (instance != null) {
            System.debug('instance.Status__c: ' + instance.Status__c);
            System.debug('instance.Tentative_Number_Remaining__c: ' + instance.Tentative_Number_Remaining__c);
            System.debug('instance.Number_Remaining__c: ' + instance.Number_Remaining__c);
        }
        
        if(give != null && give.Status__c == 'Open' && give.Type__c == 'Unlimited Give')
            stage = 'Final confirmation';
            
        if(give != null && give.Status__c == 'Open' && give.Type__c == 'Information')
            stage = 'Information sent';

        if(instance != null && give != null && instance.status__c == 'Open' && instance.Tentative_Number_Remaining__c > 0 && give.Type__c == 'First Come First Served')
            stage = 'Tentative confirmation';

        if(give != null && instance != null && (give.Waitlist__c == 'Waitlist' || give.Waitlist__c == null) && instance.Number_Remaining__c <= 0 && give.Type__c == 'First Come First Served')
            stage = 'Wait-list';

        if(give != null && give.Type__c == 'Screened Give')
            stage = 'Give requested';

        System.debug(System.LoggingLevel.INFO, 'Stage: ' + stage);

        return stage;
    }
    
    public void refreshGuests() {
    	if (guests == null) guests = new List<Give_Request_Guest__c>();
    	
        System.debug(System.LoggingLevel.INFO, 'refreshGuests(ticketValue: ' + ticketValue + ')');
        //ticketValue = ticketValue2;
        if (ticketValue == null) {
            if (request != null && request.Units_Requested__c != null) {
                ticketValue = request.Units_Requested__c.intValue();
            }
            else {
                selectedNumberOfGuests = 0;
                return;
            }
        }
        selectedNumberOfGuests = ticketValue - 1;
                
        if (guests.size() < selectedNumberOfGuests) {
            while (guests.size() < selectedNumberOfGuests) {
                System.debug(System.LoggingLevel.INFO, 'Adding guest');
                guests.add(new Give_Request_Guest__c());
            }
        } else if (guests.size() > selectedNumberOfGuests) {
            removedGuests = new List<Give_Request_Guest__c>();
            while (guests.size() > selectedNumberOfGuests) {
                System.debug(System.LoggingLevel.INFO, 'Removing guest');
                Give_Request_Guest__c removedGuest = guests[guests.size() - 1];
                if (removedGuest.Give_Request__c != null) removedGuests.add(removedGuest);
                guests.remove(guests.size() - 1);
            }
        }       
        
        System.debug(System.LoggingLevel.INFO, 'guests: ' + guests);

    }
    
    protected Boolean validateGuests() {
        System.debug(System.LoggingLevel.INFO, 'validateGuests (Begin)');
        System.debug(System.LoggingLevel.INFO, 'guests: ' + guests);
        if (guests == null) return true;
        
        HasValidationErrors = false;
        
        for (Give_Request_Guest__c guest : guests) {
            if (getCollectGuestDOB()) {
                try {
                    if (guest.TMP_Birthdate__c != null)
                        guest.Birthdate__c = Date.parse(guest.TMP_Birthdate__c);
                    else
                        guest.Birthdate__c = null;
                }
                catch (Exception ex) {
                    guest.addError('Invalid guest DOB: ' + guest.TMP_Birthdate__c);
                    HasValidationErrors = true;
                }
            }
            
            if (getCollectGuestName()) {
                if (guest.First_Name__c == null || guest.First_Name__c.trim() == '') {
                    guest.addError(System.Label.dc_guest_first_name_not_specified);
                    HasValidationErrors = true;
                }
    
                if (guest.Last_Name__c == null || guest.Last_Name__c.trim() == '') {
                    guest.addError(System.Label.dc_guest_last_name_not_specified);
                    HasValidationErrors = true;
                }
            }
        }
        
        System.debug(System.LoggingLevel.INFO, 'validateGuests (End)');
        
        return !HasValidationErrors;
    }
    
    public Boolean commitGuests() {
        System.debug(System.LoggingLevel.INFO, 'commitGuests (Begin). guests: ' + guests);         
        if (guests == null || guests.size() == 0) {
            System.debug(System.LoggingLevel.INFO, 'commitGuests (Ending.  No guests to commit.)');
            loadGuests();           
            return true;
        } 
        
        if (removedGuests != null && removedGuests.size() > 0) {
            System.debug(System.LoggingLevel.INFO, 'Deleting: ' + removedGuests);
            delete removedGuests;
            removedGuests.clear();
        }

        System.debug(System.LoggingLevel.INFO, 'request: ' + request);

        if (guests != null && guests.size() > 0) {
            
            Integer n = 1;
                
            for (Give_Request_Guest__c guest : guests) {
                if (guest.Give_Request__c == null && request != null) {
                    guest.Give_Request__c = request.Id;
                }
                
                if (getCollectGuestName())
                    guest.Name = guest.First_Name__c + ' ' + guest.Last_Name__c;
                else if (give.Collect_Guest_Name__c == 'don\'t collect')
                    guest.Name = 'Guest ' + n;
                    
                guest.Applicant__c = request.Applicant__c;
                    
                n++;
            }
        }       
        
        System.debug(System.LoggingLevel.INFO, 'Upserting: ' + guests);
        //upsert guests;
        // upsert without sharing in case it's the guest user
        List<Database.UpsertResult> urs = cov_nosharing_utilities.runDatabaseUpsert(guests, false);
        Boolean wasAnError = false;
        for (Database.UpsertResult ur : urs) {
            if (!ur.isSuccess()) {
                wasAnError = true;
            }
        }

        loadGuests();
        System.debug(System.LoggingLevel.INFO, 'commitGuests (almost End)');

        if (wasAnError) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'There may have been an error saving your guest info. Please double check with IAVA staff.'));
            return false;
        }  else {    
            return true;   
        }     
    }   

    protected void saveFields() {
        System.debug(System.LoggingLevel.INFO, 'saveFields() BEGIN');
        System.debug(System.LoggingLevel.INFO, 'give: ' + give);
        System.debug(System.LoggingLevel.INFO, 'request: ' + request);
        
        if (give == null) return;
        if (request == null) return;

        if (getCollectMemberAgeVerification()) {
            request.Confirmed_21__c = age_y;
        }

        System.debug(System.LoggingLevel.INFO, 'promptForGuestAge21: ' + getPromptForGuestAge21());
        if (getPromptForGuestAge21()) {
            System.debug(System.LoggingLevel.INFO, 'guest_age_y: ' + guest_age_y);
            request.Guest_s_21_and_Over__c = guest_age_y;
        }
        
        if (getCollectMemberDLNum() || getCollectMemberDOB() || getCollectMemberShirtSize()) {
            System.debug(System.LoggingLevel.INFO, 'contact: ' + contact);
            
            if (contact == null) return;

            if (getCollectMemberDOB()) {
                if (!isNullOrEmpty(contactBirthdate)) {
                    try {
                        contact.Birthdate = Date.parse(contactBirthdate);
                        request.Member_DOB__c = contact.Birthdate;
                    }
                    catch (Exception eMemDOB) {
                        contact.addError('Member Birthdate is invalid.');
                        saveError = 'true';
                    }
                }
                else {
                    contact.addError(System.Label.dc_member_dob_not_specified);
                    saveError = 'true';
                }   
            }

            if (getCollectMemberDLNum()) {
                contact.Drivers_License__c = request.Member_DL_Num__c;
            }
            
            if (getCollectMemberShirtSize()) {
                contact.Shirt_size__c = request.Member_Shirt_size__c;
            }
        }       
    }
    

    protected Boolean validateFields() {
        Boolean validated = true;
        
        if (give == null) {
            validated = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.dc_no_give_error));
            return validated;
        }
                
        if (getCollectMemberDLNum() || getCollectMemberDOB() || getCollectMemberShirtSize()) {
            if (contact != null) {
                System.debug(System.LoggingLevel.INFO, 'getCollectMemberDLNum(): ' + getCollectMemberDLNum() + '; contact.Drivers_License__c: ' + contact.Drivers_License__c);
                if (getCollectMemberDLNum() && isNullOrEmpty(contact.Drivers_License__c)) {
                    validated = false;
                    contact.addError(System.Label.dc_member_dlnum_not_specified);
                }
                
                if (getCollectMemberDOB() && isNullOrEmpty(contact.Birthdate)) {
                    validated = false;
                    contact.addError(System.Label.dc_member_dob_not_specified);
                }

                if (getCollectMemberShirtSize() && isNullOrEmpty(contact.Shirt_size__c)) {
                    validated = false;
                    contact.addError(System.Label.dc_member_shirt_size_not_specified);
                }               
            }
            else
            {
                validated = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.dc_no_contact_error));
            }
        }
        
        if (request != null && give != null) {
        if (getCollectSpecialResponse() && isNullOrEmpty(request.Special_Response__c)) {
            validated = false;
            request.addError('\'' + give.Special_Instructions__c + '\' is required.');
        }

        if (getCollectSpecialResponse2() && isNullOrEmpty(request.Special_Response_2__c)) {
            validated = false;
            request.addError('\'' + give.Special_Instructions_2__c + '\' is required.');
        }

        if (getCollectSpecialResponse3() && isNullOrEmpty(request.Special_Response_3__c)) {
            validated = false;
            request.addError('\'' + give.Special_Instructions_3__c + '\' is required.');
        }

        if (getCollectSpecialResponse4() && isNullOrEmpty(request.Special_Response_4__c)) {
            validated = false;
            request.addError('\'' + give.Special_Instructions_4__c + '\' is required.');
        }

        if (getCollectSpecialResponse5() && isNullOrEmpty(request.Special_Response_5__c)) {
            validated = false;
            request.addError('\'' + give.Special_Instructions_5__c + '\' is required.');
        }
        }
        
        return validated;
    }
    
    protected Boolean isNullOrEmpty(String value) {
        return value == null || value.trim() == '';
    }
    
    protected Boolean isNullOrEmpty(Date value) {
        return value == null || value.format() == '';
    }
 
     /** Method below is to ensure that 'Request Reward' is highlighted in IN THIS SECTION **/
    // public void its()
    public ApexPages.PageReference its()
    {
        // NGKJ redirect to dc_RewardDetails if only giveid is passed (security violation) ...
        // ... ALSO if the give is neither Open or Waitlist ...

        String giveid = params.get('giveid');
        System.Debug('GiveId: ' + giveid);
        
        Boolean redirect = false;

        if ((giveid == null) || (giveid == '')) {
        	redirect = true;
        } else {
            Give__c check = [SELECT Status__c FROM Give__c WHERE Id = :giveid];
            System.Debug('Checking Give: ' + check);
            if ((check.Status__c != 'Open') && (check.Status__c != 'Waitlist')) redirect = true;
        }

        if (redirect)
        {
            ApexPages.Pagereference ref;
            if (Site.getCurrentSiteURL() != null)
                ref = new ApexPages.Pagereference(Site.getCurrentSiteURL() + 'cov_reward');
            else    // Viewing from within Salesforce as /apex/page ...
                ref = Page.cov_reward;
            ref.getParameters().put('giveid', giveid);
            System.Debug('Redirecting to: ' + ref);
            return ref;
        }

        Staticvar.dc_homepage = false;
        Staticvar.dc_rewardsearch = false;
        Staticvar.dc_rewarddetail = false;
        Staticvar.dc_partner =false;
        Staticvar.dc_faq = false;
        Staticvar.dc_claimreward = true;
        Staticvar.title = 'IAVA Rucksack - Claim reward';

        return null;
        
    } 
    
    /** Method below is to ensure that 'Request Reward' is highlighted in IN THIS SECTION **/
    public ApexPages.PageReference its_conf()
    {
        system.debug('its_conf');
        Staticvar.dc_homepage = false;
        Staticvar.dc_rewardsearch = false;
        Staticvar.dc_rewarddetail = false;
        Staticvar.dc_claimreward = true;
        Staticvar.dc_partner =false;
        Staticvar.dc_faq = false;
        Staticvar.title = 'IAVA Rucksack - Thank you';
        
        return null;
    } 
    
}