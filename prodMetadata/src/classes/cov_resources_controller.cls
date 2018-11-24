public with sharing class cov_resources_controller {

    private static Set<String> RRRP_STATES = new Set<String>{'NY', 'New York', 'CA', 'California'}; // disabled as of 4/2015

    private ApexPages.StandardController sController;
    
    public Boolean inRRRPstate {get; set;}
    public List<SelectOption> stateOptions;
    public String closeTarget {get; set;} // redirect if case closed early on creation
    public Integer stageNumber {get; set;}
    public String extraParameters {get; set;}

    public Contact c {get; private set;}
    public String contactPreference {get; set;}
    public Case theCase {get; set;}
    public Id caseIdHolder {get; set;}
    public Boolean makePhonePrimary {get; set;}
    public Boolean makeEmailPrimary {get; set;}
    public String phoneConfirm {get; set;}
    public String emailConfirm {get; set;}
    public String phoneConfirm_prev {get; set;}
    public String emailConfirm_prev {get; set;}
    public String preferredPhone {get; set;}
    public String preferredEmail {get; set;}
    public String maritalStatusOnContact_prev {get; set;}
    public String caseDescription {get; set;}

    public List<caseWrapper> existingCases {get; set;}
    public String caseComment {get; set;}
    public String caseIdForComment {get; set;}
    public String caseIdForComment_prev {get; set;}
    public String commentMsg {get; set;}
    public Boolean lockCaseDescription {
        get {
            return String.IsNotBlank(theCase.Description) || (theCase.Intake_Step_Completed__c != null && theCase.Intake_Step_Completed__c != '1');
        }
    }


    public cov_resources_controller(ApexPages.StandardController stdController) {
        System.debug('stdController.getRecord(): ' + stdController.getRecord());
        sController = stdController;
        this.theCase = (Case)stdController.getRecord();
        //this.c = this.c.Id == null ? cov_user_utility.self.getC() : this.c; // if no id as URL parameter, get standard Contact with fields
        //inRRRPstate = c!= null && RRRP_STATES.contains(c.MailingState) ? true : false;
    }

    public cov_resources_controller() {
    }

    public Boolean getIsInModal() {
        if (apexpages.currentpage().getparameters().get('modal') == 'true') {
            return true;
        } else {
            return false;
        }
    }

    public Boolean getIsMobile() {
        return cov_user_utility.self.getIsMobile();
    }

    //public PageReference addParams(PageReference pr) {
    //    Map<String, String> params = apexpages.currentpage().getparameters();
    //    for (String p : params.keySet()) {
    //        if (p != 'id') {
    //            pr.getParameters().put(p, params.get(p));
    //        }
    //    }
    //    return pr;
    //}

    public String loadExtraParams() {
        String extraPs = '';
        Map<String, String> params = apexpages.currentpage().getparameters();
        for (String p : params.keySet()) {
            if (p != 'id') {
                extraPs += '&' + p + '=' + params.get(p);
            }
        }
        return extraPs;
    }



    public void initDash() {
        c = cov_user_utility.self.getC();
        inRRRPstate = checkIfInRRRPstate();     
    }

    public void initStep1() {
        initDash();     
        existingCases = loadExistingCases();
        stageNumber = 1;
        extraParameters = loadExtraParams();
    }

    public void setCloseTarget() {
        closeTarget = null;
        if (ApexPages.currentPage().getParameters().get('first') == 'true') {
            closeTarget = 'cov_rrrp_5';
            String extraParams = loadExtraParams();
            if (String.isNotBlank(extraParams) && extraParams.left(1) == '&') {
                extraParams = extraParams.right(extraParams.length() - 1);
            }
            closeTarget += String.isBlank(extraParams) ? '' : '?' + extraParams;
        }
    }

    public PageReference initStep2() {
        if (String.isEmpty(caseIdHolder) && String.isEmpty(apexpages.currentpage().getparameters().get('id'))) {
            return Page.cov_rrrp;
        }

        c = cov_user_utility.self.getC(new List<String>{'Phone', 'Email'});

        theCase = loadTheCase();
        if (theCase == null) {
            return Page.cov_rrrp;
        }
        contactPreference = theCase == null ? null : theCase.Contact_Preference__c;

        if (theCase != null && theCase.Case_Phone__c != null) {
            phoneConfirm = theCase.Case_Phone__c;
        } else if (c != null) {
            phoneConfirm = c.Phone;
        }
        if (theCase != null && theCase.Case_Email__c != null) {
            emailConfirm = theCase.Case_Email__c;
        } else if (c != null) {
            emailConfirm = c.Email;
        }
        if (theCase != null) {
            caseDescription = theCase.Description;
        }

        phoneConfirm_prev = phoneConfirm;
        emailConfirm_prev = emailConfirm;
        //phoneConfirm = c != null ? c.Phone : null;
        //emailConfirm = c != null ? c.Email : null;   

        setCloseTarget();
        stageNumber = 2;
        return null;
    }

    public PageReference initStep3() {
        if (String.isEmpty(caseIdHolder) && String.isEmpty(apexpages.currentpage().getparameters().get('id'))) {
            return Page.cov_rrrp;
        }

        System.debug('In initStep3()');
        c = cov_user_utility.self.getC(new List<String>{'LastName', 'FirstName'
            , 'Birthdate', 'Branch_of_Service__c', 'MOS_Military_Job__c'
            , 'Veteran_of_OEF__c', 'Veteran_of_OIF__c', 'Veteran_of_OND__c'
            , 'Number_of_Children__c', 'Marital_Status__c', 'Rank__c'
            , 'MailingCity', 'MailingState', 'MailingPostalCode'
            });

        maritalStatusOnContact_prev = theCase.Contact.Marital_Status__c;
        if (theCase.Marital_Status__c == null && maritalStatusOnContact_prev != null) {
            theCase.Marital_Status__c = maritalStatusOnContact_prev;
        }
        setCloseTarget();
        //initStep4();
        stageNumber = 3;
        System.debug('in initStep3 and stageNumber: ' + stageNumber);
        return null;
    }

    public PageReference initStep4() {
        System.debug('In initStep4()');
        if (String.isEmpty(caseIdHolder) && String.isEmpty(apexpages.currentpage().getparameters().get('id'))) {
            return Page.cov_rrrp;
        }

        if (!Test.isRunningTest()) sController.reset();
        maritalStatusOnContact_prev = theCase.Contact.Marital_Status__c;
        if (theCase.Marital_Status__c == null && maritalStatusOnContact_prev != null) {
            theCase.Marital_Status__c = maritalStatusOnContact_prev;
        }
        setCloseTarget();
        stageNumber = 4;
        System.debug('in initStep4 and stageNumber: ' + stageNumber);
        return null;
    }

    public Boolean checkIfInRRRPstate() {
        return true; //opening up RRRP to all users 4/2015
        //return (c != null && RRRP_STATES.contains(c.MailingState)) ? true : false;
    }

    public List<SelectOption> getStateOptions() {
        String theState = c == null ? null : c.MailingState;
        return cov_profile_controller.getStateOptions(theState);
    }

    public pageReference createNewRRRPcase() {
        system.debug('entering createNewRRRPcase');
        c = cov_user_utility.self.getC();

        if (c != null) {
            system.debug('c is not null');
            RecordType caseRecordType = [select Id from RecordType where sobjecttype = 'Case' and Name = 'Referral System' and IsActive = true limit 1];
            if (caseRecordType != null) {
                Case cs = new Case(RecordTypeId=caseRecordType.Id
                        , ContactId = c.Id, Subject='COV Referral'
                        , Intake_Step_Completed__c='1'
                        , Origin = 'COV'
                        );
                // Disable "notify contact" email
                Database.DMLOptions dlo = new Database.DMLOptions();
                dlo.EmailHeader.triggerOtherEmail = false;
                dlo.EmailHeader.triggerAutoResponseEmail = true;

                //Creating the DMLOptions for "Assign using active assignment rules" checkbox
                AssignmentRule ar;
                try {
                    //ar = [select id from AssignmentRule where SobjectType = 'Case' and Active = true Order By LastModifiedDate DESC limit 1];
                    String q = 'select id from AssignmentRule where SobjectType = \'Case\' and Active = true Order By LastModifiedDate DESC limit 1';
                    ar = (AssignmentRule)cov_nosharing_utilities.runSingleQuery(q);
                    dlo.assignmentRuleHeader.assignmentRuleId= ar.id;                     
                    } catch(Exception e) { cov_log_error.logError(e); }
                cs.setOptions(dlo);

                system.debug('About to insert the case: ' + cs);
                Database.SaveResult sr = database.insert(cs, dlo);
                if (!sr.isSuccess()) {
                    cov_log_error.logDevMsg('error(s) inserting case: ' + sr.getErrors());   
                    String message = 'Sorry, there was a problem creating your case.  Please <a href="http://iava.org/rrrp" target="_blank">click here</a> to contact us (bottom of the page).';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, message));
                    return null;
                } else {
                    system.debug('successfully inserted the case');
                    caseIdHolder = cs.Id;
                    system.debug('caseIdHolder:' + caseIdHolder);


//                      CaseShare doesn't work for customer portal users
//                      CaseShare caseShr  = new CaseShare();
//                      caseShr.CaseId = sr.getId(); // Set the ID of record being shared.
//                      caseShr.UserOrGroupId = cov_user_utility.self.getU().Id; // Set the ID of user or group being granted access.
//                      caseShr.CaseAccessLevel = 'Edit'; // Set the access level.
////                      caseShr.RowCause = Schema.Case__Share.RowCause.caseSubmitter;
//                      Database.SaveResult sr2 = Database.insert(caseShr);
//                      if(!sr2.isSuccess()){
//                            //cov_log_error.logError(e);   // TODO - error log even for no exception record
//                            String message = 'Your case was created.  However it is not showing up in your account. Rest assured we will be in touch, or <a href="http://iava.org/rrrp" target="_blank">click here</a> to contact us (bottom of the page).';
//                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, message));
//                            return null;
//                      }
//                      else {
                    PageReference pageref = Page.cov_rrrp_2;
                    pageref.getParameters().put('id', cs.id);
                    pageref.getParameters().put('first', 'true');
                    pageref = cov_utilities.addAllCurrentParameters(pageref);
                    System.debug('pageref: ' + pageref);
                    return pageref;
//                      }

                }
            }
        }
        system.debug('c was null, returning null');
        return null;
    }
    
    public pageReference intakeFormCreateNewRRRPCase()
    {
        system.debug('entering intakeFormCreateNewRRRPCase');
        c = cov_user_utility.self.getC(new List<String>{'Id','FirstName','LastName','Email','Phone','MailingStreet','MailingCity','MailingState','MailingPostalCode','Birthdate'});

        if (c != null && c.Id != null)
        {
            system.debug('c is not null');
            PageReference pageref = new PageReference('https://www.tfaforms.com/4687991?tfa_190=' + c.Id);
            
            if(c.FirstName != null)
            {
                pageref.getParameters().put('tfa_3', c.FirstName);
            }
            if(c.LastName != null)
            {
                pageref.getParameters().put('tfa_5', c.LastName);
            }
            if(c.Email != null)
            {
                pageref.getParameters().put('tfa_41', c.Email);
            }
            if(c.Phone != null)
            {
                pageref.getParameters().put('tfa_39', c.Phone);
            }
            if(c.MailingStreet != null)
            {
                pageref.getParameters().put('tfa_7', c.MailingStreet);
            }
            if(c.MailingCity != null)
            {
                pageref.getParameters().put('tfa_9', c.MailingCity);
            }
            if(c.MailingState != null)
            {
                pageref.getParameters().put('tfa_201', c.MailingState);
            }
            if(c.MailingPostalCode != null)
            {
                pageref.getParameters().put('tfa_13', c.MailingPostalCode);
            }
            if(c.Birthdate != null)
            {
                Integer bMonth = c.Birthdate.month();
                string sMonth = string.valueOf(bMonth);
                if(sMonth.length()==1)
                {
                    sMonth = '0' + sMonth;
                }
                
                Integer bDay = c.Birthdate.day();
                string sDay = string.valueOf(bDay);
                if(sDay.length()==1)
                {
                    sDay = '0' + sDay;
                }
                
                Integer bYear = c.Birthdate.year();
                string sYear = string.valueOf(bYear);
                
                string birthday = sMonth + sDay + sYear;
                
                pageref.getParameters().put('tfa_37', birthday);
            }
            
            // PageReference pageref = new PageReference('https://www.tfaforms.com/4687991?tfa_190='+c.Id+'&tfa_3='+c.FirstName+'&tfa_5='+c.LastName+'&tfa_41='+c.Email+'&tfa_39='+c.Phone+'&tfa_7='+c.MailingStreet+'&tfa_9='+c.MailingCity+'&tfa_201='+c.MailingState+'&tfa_13='+c.MailingPostalCode+'&tfa_37='+c.Birthdate);
            
            System.debug('pageref: ' + pageref);
            return pageref;
        }
        system.debug('c was null, returning null');
        return null;
    }

    public Case loadTheCase() {
        system.debug('caseIdHolder: ' + caseIdHolder);
        system.debug('apexpages.currentpage().getparameters().get(\'id\'): ' + apexpages.currentpage().getparameters().get('id'));
        system.debug('c.Id: ' + c.Id);
        String theCaseId;
        if (!String.isEmpty(caseIdHolder)) {
            theCaseId = caseIdHolder;
        } else if (!String.isEmpty(apexpages.currentpage().getparameters().get('id'))) {
            theCaseId = apexpages.currentpage().getparameters().get('id');
        } else {
            return null;
        }
        Case cz;
        try {
            cz = [select Id
                , Description
                , Healthcare__c
                , Contact_Preference__c
                , How_did_you_hear_about_us__c
                , Annual_Family_income__c
                , Salary__c
                , Position_Job_Title__c
                , Intake_Step_Completed__c
                , Case_Phone__c
                , Case_Email__c
                from Case where Id = :theCaseId
                and ContactId = :c.Id
                limit 1];
        } catch (Exception e) {
            system.debug('No case found wiht that Id for the user\'s contact');
        }
        return cz;

    }

    public class caseWrapper {
        public Case cs {get; set;}
        public Boolean editable {get; set;}
        public String caseNumTrimmed {get; set;}

        public caseWrapper(Case theC) {
            cs = theC;
            if (theC.Status != 'Closed' && theC.Status != 'Canceled' && theC.Status != 'Contact Lost' &&
                 (theC.Intake_Step_Completed__c == null || Integer.valueOf(theC.Intake_Step_Completed__c) < 4)
                ) {
                editable = true;
            } else {
                editable = false;
            }
            caseNumTrimmed = theC.CaseNumber;
            while (caseNumTrimmed != null && caseNumTrimmed != '' && caseNumTrimmed.left(1) == '0') {
                caseNumTrimmed = caseNumTrimmed.substring(1);
            }
        }
    }

    public List<caseWrapper> loadExistingCases() {
        System.debug('About to query for existing cases');
        List<Case> cases;
        if (c != null) {
            cases = [select Id, Status, Contact_Preference__c, CreatedDate, Intake_Step_Completed__c, CaseNumber from Case 
                where ContactId = :c.Id 
                and RecordType.Name='Referral System'
                and Status not in ('Closed', 'Canceled', 'Contact Lost')
                order by CreatedDate DESC
                ];
        } else {
            cases = new List<Case>();
        }
        List<caseWrapper> wrapperList = new List<caseWrapper>();
        for (Case theCase : cases) {
            system.debug('theCase.CaseNumber: ' + theCase.CaseNumber);
            wrapperList.add(new caseWrapper(theCase));
        }
        return wrapperList;
        //if (theCases.size() > 0) {
        //  hasExistingCases = true;
        //} else {
        //  hasExistingCases = false;
        //}
    }

    public pageReference saveContactPreference() {
        if (contactPreference == null) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please select an option.')); 
            return null;
        }

        System.debug('About to save contactPreference: ' + contactPreference);
        if (theCase == null) {
            theCase = loadTheCase();
        }
        theCase.Contact_Preference__c = contactPreference;
        theCase.Description = caseDescription == null ? theCase.Description : caseDescription;
        c = cov_user_utility.self.getC(new List<String>{'Phone', 'Email', 'npe01__PreferredPhone__c', 'npe01__Preferred_Email__c'
                                                    , 'MobilePhone', 'HomePhone', 'npe01__WorkPhone__c', 'OtherPhone'
                                                    });
        if (contactPreference == 'Phone') {
            if (phoneConfirm == null || phoneConfirm.trim() == '') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter a phone number where we can reach you.')); 
                return null;
            }
            //theCase.Description = theCase.Description == null ? null : theCase.Description + '\r\n';
            //theCase.Description += 'Contact Preference - Phone: ' + phoneConfirm;
            if (phoneConfirm != phoneConfirm_prev || makePhonePrimary) {
                theCase.Case_Phone__c = phoneConfirm;
                if (makePhonePrimary) {
                    if (preferredPhone == 'Mobile') {
                        c.MobilePhone = phoneConfirm;
                        c.npe01__PreferredPhone__c = 'Mobile';
                    } else if (preferredPhone == 'Home') {
                        c.HomePhone = phoneConfirm;
                        c.npe01__PreferredPhone__c = 'Home';
                    } else if (preferredPhone == 'Work') {
                        c.npe01__WorkPhone__c = phoneConfirm;
                        c.npe01__PreferredPhone__c = 'Work';
                    } else if (preferredPhone == 'Other') {
                        c.OtherPhone = phoneConfirm;
                        c.npe01__PreferredPhone__c = 'Other';
                    } else {
                        c.Phone = phoneConfirm;
                    }
                }
            }
        } else if (contactPreference == 'Email') {
            if (emailConfirm == null || emailConfirm.trim() == '') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter an email address where we can reach you.')); 
                return null;
            }

            //theCase.Description = theCase.Description == null ? null : theCase.Description + '\r\n';
            //theCase.Description += 'Contact Preference - Email: ' + emailConfirm;
            if (emailConfirm != emailConfirm_prev || makeEmailPrimary) {
                theCase.Case_Email__c = emailConfirm;
                if (makeEmailPrimary) {
                    if (preferredEmail == 'Personal') {
                        c.npe01__Preferred_Email__c = emailConfirm;
                        c.npe01__Preferred_Email__c = 'Personal';
                    } else if (preferredEmail == 'Work') {
                        c.npe01__WorkEmail__c = emailConfirm;
                        c.npe01__Preferred_Email__c = 'Work';
                    } else if (preferredEmail == 'Alternate') {
                        c.npe01__AlternateEmail__c = emailConfirm;
                        c.npe01__Preferred_Email__c = 'Alternate';
                    } else {
                        c.Email = emailConfirm;
                    }
                }
            }
        } else if (contactPreference == 'COV') {
            //theCase.Description = theCase.Description == null ? null : theCase.Description + '\r\n';
            //theCase.Description += 'Contact Preference - COV';
        } else {
            return null;
        }

        try {
            if (theCase.Intake_Step_Completed__c == null || Integer.valueOf(theCase.Intake_Step_Completed__c) < 2) {
                theCase.Intake_Step_Completed__c = '2';
            }
            update theCase;
            update c;
            PageReference pageref;
            if (Integer.valueof(theCase.Intake_Step_Completed__c) >= 4) {
                pageref = Page.cov_rrrp_1;
            } else if (Integer.valueof(theCase.Intake_Step_Completed__c) == 3) {
                pageref = Page.cov_rrrp_4;
            } else {
                pageref = Page.cov_rrrp_3;
            }
            pageref.getParameters().put('id', theCase.id);
            //if (ApexPages.currentPage().getParameters().get('first') == 'true') {
            //    pageref.getParameters().put('first', 'true');
            //}
            pageref = cov_utilities.addAllCurrentParameters(pageref);
            System.debug('pageref: ' + pageref);
            return pageref;
        } catch(Exception e) { cov_log_error.logError(e); return null; }

    }

    public pageReference save() { // called by both Steps 3 and 4
        //String currentStep = cov_user_utility.getPageName().right(1);
        System.debug('stageNumber: ' + stageNumber);
        String currentStep = String.valueOf(stageNumber);
        System.debug('currentStep: ' + currentStep);
        theCase.Intake_Step_Completed__c = currentStep;     
        System.debug('Going to save RRRP case theCase:' + theCase);
        System.debug('theCase.Marital_Status__c before save: ' + theCase.Marital_Status__c);
        System.debug('theCase.Intake_Step_Completed__c before save: ' + theCase.Intake_Step_Completed__c);
        PageReference pr = sController.save();
        system.debug('pr: ' + pr);
        PageReference pageref;
        if (currentStep == '3') {
            System.debug('RRRP case: Going to save the contact theCase.Contact: ' + theCase.Contact);
            try {
                update theCase.Contact;
                pageRef = Page.cov_rrrp_4;
            } catch(Exception e) { cov_log_error.logError(e); return null; }
        } else {
            System.debug('maritalStatusOnContact_prev: ' + maritalStatusOnContact_prev);
            System.debug('theCase.Marital_Status__c: ' + theCase.Marital_Status__c);
            if (maritalStatusOnContact_prev != theCase.Marital_Status__c) {
                System.debug('Update Marital Status on contact record to :' + theCase.Marital_Status__c);
                theCase.Contact.Marital_Status__c = theCase.Marital_Status__c;
                try {
                    update theCase.Contact;
                } catch(Exception e) { cov_log_error.logError(e); return null; }
            }
            pageRef = Page.cov_rrrp_5;
        }
        pageref.getParameters().put('id', theCase.id);
        //if (ApexPages.currentPage().getParameters().get('first') == 'true') {
        //    pageref.getParameters().put('first', 'true');
        //}
        pageref = cov_utilities.addAllCurrentParameters(pageref);
        System.debug('pageRef: ' + pageRef);
        return pageref;
        
    }

    public void saveCaseComment() {
        System.debug('caseIdForComment: ' + caseIdForComment);
        System.debug('caseComment: ' + caseComment);
        System.debug('theCase: ' + theCase);
        if (caseComment != null & caseComment.trim() != '') {
            CaseComment cc = new CaseComment(ParentId = caseIdForComment, CommentBody = caseComment);
            try {
                insert cc;
                commentMsg = 'Comment sent.';
                caseComment = null;
                caseIdForComment_prev = caseIdForComment;
                caseIdForComment = null;
            } catch(Exception e) { cov_log_error.logError(e); commentMsg = 'Sorry, there was an error, comment not sent.'; }
        } else {
            commentMsg = 'Comment cannot be blank.';
        }
    }

    public PageReference exit() {
        if (ApexPages.currentPage().getParameters().get('first') == 'true') {
            return Page.cov_rrrp_5;
        } else {
            return Page.cov_rrrp;
        }
        
    }


}