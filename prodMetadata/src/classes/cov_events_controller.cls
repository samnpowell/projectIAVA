public without sharing class cov_events_controller {
    
    public String conId {get; set;}
    public Contact con {get; set;}
    public String eventIdChosen {get; set;}
    public String replyValue {get; set;}
    
    public String templateName {get; set;}
    public String headerParam {get; set;}
    public String forceLoginParam {get; set;}
    public String inviterParam {get; set;}
    public String tabParam {get; set;}
    private String startAttendeeParam {get; set;}
    private String endAttendeeParam {get; set;}
    
    public Integer MAX_ATTENDEE_PHOTOS_SHOWN {get; set;}
    
    public cov_customevent ce {get; set;}
    public List<IAVAEvent_Attendee__c> attendeesList {get; set;}
    public List<attendee> yesAttendeesList {get; set;}
    public List<attendee> noAttendeesList {get; set;}
    public List<attendee> maybeAttendeesList {get; set;}
    public List<attendee> invitedAttendeesList {get; set;}
    public List<attendee> notOnListAttendeesList {get; set;}
    public String attendeeListChosen {get; set;}
    public Integer attendeeChosenIndex {get; set;}
    public attendee attendeeForMoreInfo {get; set;}
    public Boolean atLeastOneAttendeeNeedsMoreInfo {get; set;}
    public String attendanceArray {get; set;}
    
    public String firstNameCollected {get; set;}
    public String lastNameCollected {get; set;}
    public String emailCollected {get; set;}
    public String zipCollected {get; set;}
    public Boolean oefCollected {get; set;}
    public Boolean oifCollected {get; set;}
    public Boolean ondCollected {get; set;}
    public Boolean post911Collected {get; set;}
    public Boolean otherEraCollected {get; set;}
    public Boolean notVeteranCollected {get; set;}
    
    public Boolean hasEvents {get; set;}
    public List<cov_customevent> cEventsList {get; set;}
    public Boolean hasMyEvents {get; set;}
    public List<cov_customevent> mycEventsList {get; set;}
    public Boolean hasMyEventsToTrack {get; set;}
    public List<cov_customevent> mycEventsToTrackList {get; set;}
    public Integer NUM_ROWS_DEFAULT {get; set;}
    public Integer numRows {get; set;}
    public Boolean inInviteMode {get; set;}
    public String inviteeId {get; set;}
    public String inviteeName {get; set;}
    public Set<String> inviteeIds {get; set;}
    public Set<String> inviteeNames {get; set;}
    public Map<String, String> inviteeIdNameMap {get; set;}
    public List<String> successfulInviteeIds {get; set;}
    public List<String> failedInviteeIds {get; set;}
    public String inviteeEmailBox {get; set;}
    public List<String> inviteeEmails {get; set;}
    //public String successfulEmailMessage {get; set;}
    public List<String> successfulEmails {get; set;}
    public List<String> failedEmails {get; set;}
    
    public Integer MAX_DIRECT_MESSAGES {get; set;}
    
    public Boolean includePageRefresher {get; set;}
    public Boolean suppressGroupDisplay {get; set;}
    
    public String currentEncodedUrlWithBase { get { return cov_user_utility.self.getCurrentEncodedUrlWithBase(); } }
    public String currentEncodedUrlWithoutBase { get { return cov_user_utility.self.getCurrentEncodedUrlWithoutBase(); } }
    public String portalLoginBaseUrl { get { return cov_user_utility.self.getPortalLoginBaseUrl(); } }
    
    // guest USER fields (non-authenticated user)
    public String nonAuthReplyFirstName { get; set; }
    public String nonAuthReplyLastName { get; set; }
    public String nonAuthReplyEmail { get; set; }
    public String nonAuthReplyPhone { get; set; }
    public String nonAuthReplyValue { get; set; }
    //public Boolean nonAuthReplyVeteranStatus { get; set; }
    public Boolean nonAuthReplyPost911 { get; set; }
    public Boolean nonAuthReplyOEF { get; set; }
    public Boolean nonAuthReplyOIF { get; set; }
    public Boolean nonAuthReplyOND { get; set; }
    public Boolean nonAuthReplyOtherEra { get; set; }
    public Boolean nonAuthReplyFamily { get; set; }
    public Boolean nonAuthReplyNotVeteran { get; set; }
    public Boolean nonAuthReplied {get; set;}
    
    public Boolean isMobile {get; set;}
    
    // event guest fields (for a person bringing guests)
    public List<SelectOption> guestNumberList {get; set;}
    //public Integer numGuestsChosen {get; set;}
    //public List<cov_customevent.eventGuest> guests {get; set;}
    public Integer guestIndexChosen {get; set;}
    public Integer guestEditIndex {get; set;}
    public Boolean inGuestEditMode {get; set;}
    public String guestInputFirstName {get; set;}
    public String guestInputLastName {get; set;}
    public String guestInputEmail {get; set;}
    public String guestInputPhone {get; set;}
    
    public Set<Id> attendeeIdsFromThisSession {get; set;}
    public Boolean someGuestsHidden {get; set;}
    public Boolean showGuestsHeader {
        get {
            return (inGuestEditMode || (ce.guests != null && ce.guests.size() > 0));
        }
    }
    
    public String newAttendeeFirstName {get; set;}
    public String newAttendeeLastName {get; set;}
    public String newAttendeeEmail {get; set;}
    public Boolean newAttendeeNoEmailAvailable {get; set;}
    public String newAttendeeZip {get; set;}
    public Boolean newAttendeeVeteran {get; set;}
    
    public cov_events_controller() {
        System.debug('in events controller constructor.');
        
        if (con == null) {
            con = cov_user_utility.self.getC();
            conId = con == null ? null : con.Id;
        }
        system.debug('in constructor and con: ' + con);
        //System.debug('conId in events controller after setting: ' + conId);
        NUM_ROWS_DEFAULT = ApexPages.currentPage() != null 
            && ApexPages.currentPage().getUrl() != null 
            && ApexPages.currentPage().getUrl().contains('dashboard') 
            ? 6 : 24;
        //NUM_ROWS_SHORTER_DEFAULT = 6;
        numRows = NUM_ROWS_DEFAULT;
        
        MAX_ATTENDEE_PHOTOS_SHOWN = 24;
        
        Map<String, String> pageParameters = new Map<String,String>();
        try {
            pageParameters = ApexPages.CurrentPage().getParameters();
        } catch(Exception e) {}
        String message = pageParameters.get('msg');
        system.debug('message from msg URL parameter: ' + message);
        if(message != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, message));
        }
        headerParam = pageParameters.get('header');
        if (!String.isEmpty(headerParam) && (headerParam == 'false' || cov_user_utility.self.isMobile())) {
            templateName = 'cov_template_noheader';
        } else {
            templateName = 'cov_template';
        }
        forceLoginParam = pageParameters.get('forcelogin');
        if (!String.isEmpty(headerParam) && (forceLoginParam == 'true' && UserInfo.getUserType() == 'Guest')) {
            // do a DML statement here (not allowed) to artificially trigger the authorization screen
            COV_Error__c err = new COV_Error__c();
            insert err;
        }
        inviterParam = pageParameters.get('inviter');
        startAttendeeParam = pageParameters.get('startAtt');
        endAttendeeParam = pageParameters.get('endAtt');
        tabParam = pageParameters.get('tab');
        
        attendeeIdsFromThisSession = new Set<Id>();
        
        inInviteMode = false;
        inGuestEditMode = false;
        includePageRefresher = false;
        suppressGroupDisplay = false;
        inviteeIds = new Set<String>();
        inviteeNames = new Set<String>();
        inviteeIdNameMap = new Map<String, String>();
        
        MAX_DIRECT_MESSAGES = 30;
        
        isMobile = cov_user_utility.self.getIsMobile();
    }
    
    public void init() {
        getEventID();
        // TODO
        // this is designed to make sure someone doesnt send out the URL with forcelogin still as a param.
        // but it may have been causing some errors.
        /*
        if (forceLoginParam == 'true') {
            return new PageReference(Site.getPathPrefix() + '/cov_event?id=' + ce.eId);
        } else {
            return null;
        }
        */
    }
    
    public void initAttendeePage() {
        getEventID();
        if (ce != null) {
            loadAttendeesList();
        }
    }
    
    /*
    public Boolean getHasEvents() {
        if (cEventsList == null) {
            cEventsList = getcEventsList();
        }
        return hasEvents;
    }
    */
    
    public PageReference getEventID() {
        system.debug('apexpages.currentpage().getparameters().get(\'ev\'): ' + apexpages.currentpage().getparameters().get('ev'));
        Id theId;
        String theEVstring = apexpages.currentpage().getparameters().get('ev');
        String theIDstring = apexpages.currentpage().getparameters().get('id');
        system.debug('the ev parameter is: ' + theEVstring);
        system.debug('the id parameter is: ' + theIDstring);
        theIDstring = theIDstring == null ? theEVstring : theIDstring;
        try {
            theID = (Id)theIDstring;
        } catch(Exception e) {}
        if (theID != null) {
            system.debug('con: ' + con);
            ce = cov_customevent.createCustomEvent(theID, con);
            if (ce != null && ce.guests != null) {
                setDisplayFlagOnGuests(ce.guests);
            }
            
            // if no event found, check if it was an attendee record ID
            /*
            if (ce == null) {
                List<IAVAEvent_Attendee__c> attendeeRecords = [select Id, Event__c from IAVAEvent_Attendee__c where Event__c = :theID];
                if (attendeeRecords.size() > 0) {
                    ce = cov_customevent.createCustomEvent(attendeeRecords[0].Event__c, con);
                }
            }
            */
            
            // if not event found, check if it was a canceled event
            // (extra query but easier than retrofitting createCustomEvent method)
            if (ce == null) {
                try {
                    IAVAEvent__c ev = (IAVAEvent__c)cov_nosharing_utilities.runSingleQuery('select Id, Status__c from IAVAEvent__c where Status__c=\'Canceled\' and Id = \'' + theId + '\'');
                    ce = ev == null ? null : new cov_customevent(ev);
                } catch (Exception e) { cov_log_error.logError(e, 'Error running backup query to find if user is trying to view canceled event page.'); }
            }
            
            if (ce == null) {
                PageReference pr = Page.cov_vettogethers;
                pr = cov_utilities.addAllCurrentParameters(pr);
                String msg = 'That event could not be found, but try checking the list of events below.';
                pr.getParameters().put('msg', msg);
                return pr;
            }
            
            //else {
            //    initiateGuestAttendees(ce);
            //}
        }
        return null;
    }
    
    /*
    public with sharing class eventGuest {
        public String FirstName {get; set;}
        public String LastName {get; set;}
        public String Email {get; set;}
        public String Phone {get; set;}
        public Id contactId {get; set;}
        
        public eventGuest() {}
        
        public eventGuest(Contact cIn) {
            contactId = cIn.Id;
            FirstName = cIn.FirstName;
            LastName = cIn.LastName;
            Email = cIn.Email;
            Phone = cIn.MobilePhone;
        }
    }
    */
    
    /*
    public void initiateGuestAttendees(cov_customevent custEv) {
        if (custEv != null) {
            if (guests == null) {
                guests = new List<cov_customevent.eventGuest>();
            }
            
            //TODO: check if existing guests first
            numGuestsChosen = 0;
            
            if (guestNumberList == null) {
                guestNumberList = new List<SelectOption>();
                guestNumberList.add(new SelectOption('0','0'));
            }
            if (custEv.maxNumGuests > 0) {
                for (Integer i = 0; i < ce.maxNumGuests; i++) {
                    guestNumberList.add(new SelectOption('' + (i+1),'' + (i+1)));
                }
            }
        }
    }
    */
    
    /*
    public PageReference refreshGuestSection() {
        if (guests.size() < numGuestsChosen) {
            Integer diff = numGuestsChosen - guests.size();
            while (guests.size() < numGuestsChosen) {
                guests.add(new cov_customevent.eventGuest(ce.eId));
            }
        } else if (guests.size() > numGuestsChosen) {
            while (numGuestsChosen < guests.size()) {
                guests.remove(guests.size() - 1);
            }
        }
        return null;
    }
    */
    
    public void refreshGuestList() {
        ce.guests = cov_customevent.getEventGuests(ce.eId, ce.attendeeId, conId);
        setDisplayFlagOnGuests(ce.guests);
    }
    
    public void setDisplayFlagOnGuests(List<cov_customevent.eventGuest> guestsIn) {
        for (cov_customevent.eventGuest eg : guestsIn) {
            if (UserInfo.getUserType() != 'Guest' || attendeeIdsFromThisSession.contains(eg.attendeeId)) {
                eg.displayInfo =  true;
            } else {
                eg.displayInfo = false;
                someGuestsHidden = true;
            }
        }
    }
    
    public PageReference addGuest() {
        system.debug('ce.guests: ' + ce.guests);
        system.debug('ce.maxNumGuests: ' + ce.maxNumGuests);
        if (ce.guests == null || ce.guests.size() < ce.maxNumGuests) {
            inGuestEditMode = true;
            guestIndexChosen = null;
        }
        return null;
    }
    
    // commented out until we figure out system for editing guest info that's not a security compromise
    /*
    public PageReference editGuest() {
        if (guestIndexChosen != null && ce.guests != null && ce.guests.size() > guestIndexChosen) {
            guestInputFirstName = ce.guests[guestIndexChosen].FirstName;
            guestInputLastName = ce.guests[guestIndexChosen].LastName;
            guestInputEmail = ce.guests[guestIndexChosen].Email;
            guestInputPhone = ce.guests[guestIndexChosen].Phone;
            inGuestEditMode = true;
            guestEditIndex = guestIndexChosen;
        }
        return null;
    }
    */
    
    public PageReference saveGuest() {
        system.debug('guestEditIndex: ' + guestEditIndex);
        
        cov_customevent.eventGuest evg;
        
        if (guestEditIndex != null && ce.guests != null && ce.guests.size() > guestEditIndex) {
            evg = ce.guests[guestEditIndex];
            system.debug('ce.guests[guestEditIndex].contactId: ' + ce.guests[guestEditIndex].contactId);
        } else {
            evg = new cov_customevent.eventGuest();
            evg.eventId = ce.eId;
            evg.parentAttendeeId = ce.attendeeId;
        }
        evg.FirstName = guestInputFirstName;
        evg.LastName = guestInputLastName;
        evg.Email = guestInputEmail;
        evg.Phone = guestInputPhone;
        
        if (!validateGuest(evg)) {
            return null;
        }
        
        IAVAEvent_Attendee__c attendeeSaved = cov_customevent.upsertAttendeeFromEventGuest(evg, 'Yes');
        if (attendeeSaved != null) {
            attendeeIdsFromThisSession.add(attendeeSaved.Id);
            refreshGuestList();
            inGuestEditMode = false;
            guestIndexChosen = null;
            guestEditIndex = null;
            clearGuestSaveFields();
            
            // now add a relationship between contacts. 
            // dont have new contactId here for a new contact so iterate through refreshed guest list to find it
            Id contactIdForNewAttendee;
            if (String.isNotBlank(evg.contactId)) {
                contactIdForNewAttendee = evg.contactId;
            } else if (String.isBlank(evg.contactId) && String.isNotBlank(evg.Email)) {
                Boolean idMatchFound = false;
                Boolean emailMatchFound = false;
                Integer i = 0;
                while (ce.guests != null && i < ce.guests.size() && !idMatchFound){
                    //for (cov_customevent.eventGuest egg : ce.guests) {
                    if (evg.contactId != null && ce.guests[i].contactId == evg.contactId) {
                        idMatchFound = true;
                        contactIdForNewAttendee = ce.guests[i].contactId;
                    } else if (!emailMatchFound && String.isNotBlank(evg.Email) && ce.guests[i].Email == evg.Email) {
                        emailMatchFound = true;
                        contactIdForNewAttendee = ce.guests[i].contactId;
                    }
                    i++;
                }
            }
            if (conId != null && contactIdForNewAttendee != null) {
                cov_relationships_controller.addRelationship(conId, contactIdForNewAttendee, 'Registered as Event Guest', 'Registered as Event Guest of', true);
            }
        }
        return null;
    }
    
    private void clearGuestSaveFields() {
        guestInputFirstName = null;
        guestInputLastName = null;
        guestInputEmail = null;
        guestInputPhone = null;
    }
    
    /*
    private cov_customevent.eventGuest populateEventGuest(Integer i) {
        if (guests.size() > i) {
            guests[i].FirstName = guestInputFirstName;
            guests[i].LastName = guestInputLastName;
            guests[i].Email = guestInputEmail;
            guests[i].Phone = guestInputPhone;
        }
    }
    */
    
    public PageReference deleteGuest() {
        if (guestIndexChosen != null && ce.guests != null && ce.guests.size() > guestIndexChosen && ce.guests[guestIndexChosen].attendeeId != null) {
            IAVAEvent_Attendee__c deleteAtt;
            try {
                deleteAtt = [select Id from IAVAEvent_Attendee__c where Id = :ce.guests[guestIndexChosen].attendeeId];
            } catch (Exception e) {
                cov_log_error.logDevMsg('Could not find attendee record to delete with Id: ' + ce.guests[guestIndexChosen].attendeeId);
                ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.Error, 'Sorry the guest could not be removed (#da)'));
                return null;
            }
            try {
                delete deleteAtt;
                refreshGuestList();
                return null;
            } catch (Exception e) {
                cov_log_error.logError(e, 'Could not delete attendee record: ' + deleteAtt);
                ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.Error, 'Sorry the guest could not be removed (#db)'));
                return null;
            }
        }
        
        ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.Error, 'Sorry there was an issue trying to remove a guest (#dc)'));
        return null;
    }
    
    public PageReference refreshPage() {
        PageReference refreshPage = Page.cov_event;
        refreshPage.getParameters().put('id', ce.eId);
        includePageRefresher = false;
        suppressGroupDisplay = false;
        return refreshPage;
    }
    
    private Boolean validateGuest(cov_customevent.eventGuest egIn) {
        Boolean hasValidationErrors = false;
        if (ce.collectGuestName && ce.guestNameRequired && ( String.isEmpty(egIn.FirstName) || String.isEmpty(egIn.LastName))) {
            ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.Error, 'Please fill in your guest\'s name'));
            hasValidationErrors = true;
        }
        if (ce.collectGuestEmail && ce.guestEmailRequired && String.isEmpty(egIn.Email)) {
            ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.Error, 'Please fill in your guest\'s email'));
            hasValidationErrors = true;
        } else if (ce.collectGuestEmail && !cov_utilities.validateEmail(egIn.Email)) {
            ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.Error, 'That email address appears to be invalid.'));
            hasValidationErrors = true;
        } else if (con != null && ce.collectGuestEmail && egIn.Email == con.Email) {
            ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.Error, 'Sorry you can\'t use your own email for your guest.'));
            hasValidationErrors = true;
        }
        if (ce.collectGuestPhone && ce.guestPhoneRequired && String.isEmpty(egIn.Phone)) {
            ApexPages.addMessage (new ApexPages.Message(ApexPages.Severity.Error, 'Please fill in your guest\'s phone number.'));
            hasValidationErrors = true;
        }
        system.debug('guest validated: ' + !hasValidationErrors);
        return !hasValidationErrors;
    }
    
    /*
    public PageReference saveGuests() {
        validateGuests();
        // if they're all new guests, just go through and insert contacts and attendee records
        // Q: what do we do if the same person is a guest of multiple people?
        // if there were already guests, go through and if marked as new person, upsert new contact.
        // otherwise edit contact info? eesh.
        
        return null;
    }
    */
    
    public void getEventsList() {
        if (con == null) {
            con = cov_user_utility.self.getC();
        }
        
        // get all events relevant to the user including past events the user owns
        cEventsList = cov_customevent.getAllCustomEvents(con, true); 
        hasEvents = cEventsList.size() > 0 ? true : false;
        
        // create a separate list of My Events and remove past events from All Events
        mycEventsList = new List<cov_customevent>();
        mycEventsToTrackList = new List<cov_customevent>();
        for (Integer i = 0; i < cEventsList.size(); i++) {
            //system.debug('i=' + i + ' and cEventsList[i].name: ' + cEventsList[i].name);
            if (cEventsList[i].organizerId == UserInfo.getUserId()) {
                mycEventsList.add(cEventsList[i]);
                if (cEventsList[i].StartDate != null && cEventsList[i].StartDate <= System.today() && cEventsList[i].StartDate >= System.today().addDays(-2)) {
                    mycEventsToTrackList.add(cEventsList[i]);
                }
            }
            if (cEventsList[i].startDate < System.today()) {
                system.debug('About to remove this already-passed event from cEventsList. i: ' + i + ' and name: ' + cEventsList[i].name);
                cEventsList.remove(i);
                i--;
            }
        }
        hasMyEvents = mycEventsList.size() > 0 ? true : false;
        hasMyEventsToTrack = mycEventsToTrackList.size() > 0 ? true : false;
        mycEventsList = cov_customevent.sortEventsByDate(mycEventsList, false);
        
        //system.debug('cEventsList.size() before reward events: ' + cEventsList.size());
        List<cov_customevent> rewardEvents = getRewardEvents(con);
        //system.debug('rewardEvents: ' + rewardEvents);
        if (rewardEvents.size() >0) {
            //system.debug('about to add rewardEvents with size='+ rewardEvents.size() + ' to cEventsList with size=' + cEventsList.size());
            cEventsList.addAll(rewardEvents);
            //system.debug('just ran addAll and now cEventsList.size: ' + cEventsList.size());
        }
        //system.debug('cEventsList.size() after reward events section: ' + cEventsList.size());
        
        cEventsList = cov_customevent.sortEventsByDate(cEventsList, true);
        //system.debug('just sorted and now cEventsList.size: ' + cEventsList.size());
        cEventsList = cov_customevent.sortLocalEventsFirst(cEventsList);
        
        // on the vettogethers page show all events by default
        try {
            String currentUrl = ApexPages.currentPage().getUrl();
            if (hasEvents && !String.isEmpty(currentUrl) && currentUrl.contains('apex/cov_vettogethers')) {
                numRows = cEventsList.size();
            }
        } catch(Exception e) {}
    }
    
    private List<cov_customevent> getRewardEvents(Contact theContact) {
        List<Give__c> theGives;
        try {
            theGives = [select Id, Name
                        , Earliest_Start_Date__c
                        , Latest_End_Date__c
                        , City_Formula__c, State_Formula__c
                        , Latitude__c, Longitude__c
                        , Status__c
                        , (select Id, Name from Attachments)
                        , (select Id, Start_Date__c from Give_Instances__r)
                        from Give__c
                        where Category__c = 'Events'
                        and ( Status__c = 'Open' OR Status__c = 'Waitlist')
                        and (
                            (Latest_Start_Date__c != null and Latest_Start_Date__c >= TODAY)
                            or
                            Earliest_Start_Date__c = null
                            or 
                            Earliest_Start_Date__c >= TODAY
                            or
                            (Latest_End_Date__c != null and Latest_End_Date__c >= TODAY)
                        )
                       ];
            //system.debug('theGives queried in getRewardEvents: ' + theGives);
        } catch (Exception e) {
            cov_log_error.logError(e, 'Error querying for event-type rewards');
            return null;
        }
        List<cov_customevent> customRewardEvents = new List<cov_customevent>();
        for (Give__c giv : theGives) {
            Double lat = theContact == null ? null : theContact.MA_Latitude__c;
            Double lon = theContact == null ? null : theContact.MA_Longitude__c;
            //system.debug('usermap.get(evnt.OwnerId): ' + usermap.get(evnt.OwnerId));
            cov_customevent newCE = new cov_customevent(giv, lat, lon);
            if (newCE != null) {
                customRewardEvents.add(newCE);
            }
        }
        return customRewardEvents;
    }
    
    public class attendee {
        public IAVAEvent_Attendee__c att {get; set;}
        public String displayName {
            get {
                String dn;
                if (
                    String.isBlank(att.Contact__r.FirstName) 
                    && (att.Contact__r.LastName == 'Unknown' || att.Contact__r.LastName == '(Unknown)')
                    && String.isNotBlank(att.Contact__r.Email)
                ) {
                    dn = att.Contact__r.Email;
                } else {
                    dn = att.Contact__r.LastName + (String.isBlank(att.Contact__r.FirstName) ? '' : ', ' + att.Contact__r.FirstName);
                }
                return dn;
            }
        }
        public Boolean collectFirstName {get; set;}
        public Boolean collectLastName {get; set;}
        public Boolean collectEmail {get; set;}
        public Boolean collectZip {get; set;}
        public Boolean collectVeteranStatus {get; set;}
        public Boolean collectInfo {
            get {
                return (collectFirstName || collectLastName || collectEmail || collectZip || collectVeteranStatus);
            }
        }
        public Integer listIndex {get; set;} // use this to track index in parent list since using variable on vf page gets messed up during rerender
        public attendee(IAVAEvent_Attendee__c attIn) {
            att = attIn;
            this.assessContactFieldCompleteness();
        }
        
        private void assessContactFieldCompleteness() {
            if (
                String.isBlank(att.Contact__r.FirstName) 
                || (String.isNotBlank(att.Contact__r.FirstName) && att.Contact__r.FirstName == att.Contact__r.Email)
            ) {
                this.collectFirstName = true;
            } else {
                this.collectFirstName = false;
            }
            if (
                String.isBlank(att.Contact__r.LastName) 
                || (String.isNotBlank(att.Contact__r.LastName) 
                    && (   att.Contact__r.LastName == att.Contact__r.Email
                        || att.Contact__r.LastName == 'Unknown'
                        || att.Contact__r.LastName == '(Unknown)'
                       )
                   )
            ) {
                this.collectLastName = true;
            } else {
                this.collectLastName = false;
            }
            if (String.isBlank(att.Contact__r.Email) || !cov_utilities.validateEmail(att.Contact__r.Email)) {
                this.collectEmail = true;
            } else {
                this.collectEmail = false;
            }
            if (String.isBlank(att.Contact__r.MailingPostalCode)) {
                this.collectZip = true;
            } else {
                this.collectZip = false;
            }
            if (
                !att.Contact__r.Post_9_11_Veteran__c
                && !att.Contact__r.Veteran_of_OEF__c && !att.Contact__r.Veteran_of_OIF__c && !att.Contact__r.Veteran_of_OND__c
                && !att.Contact__r.Veteran_of_Other_Era__c
                && !att.Contact__r.Not_a_Veteran__c
            ) {
                this.collectVeteranStatus = true;
            } else {
                this.collectVeteranStatus = false;
            }
        }
        
        private void updateAttendeeContactFields(Contact cIn) {
            att.Contact__r.FirstName = cIn.FirstName;
            att.Contact__r.LastName = cIn.LastName;
            att.Contact__r.Email = cIn.Email;
            att.Contact__r.MailingPostalCode = cIn.MailingPostalCode;
            att.Contact__r.Veteran_Member__c = cIn.Veteran_Member__c;
            att.Contact__r.Post_9_11_Veteran__c = cIn.Post_9_11_Veteran__c;
            att.Contact__r.Veteran_of_OEF__c = cIn.Veteran_of_OEF__c;
            att.Contact__r.Veteran_of_OIF__c = cIn.Veteran_of_OIF__c;
            att.Contact__r.Veteran_of_OND__c = cIn.Veteran_of_OND__c;
            att.Contact__r.Veteran_of_Other_Era__c = cIn.Veteran_of_Other_Era__c;
            att.Contact__r.Not_a_Veteran__c = cIn.Not_a_Veteran__c;
        }
    }
    
    public void loadAttendeesList() {
        /*
        List<IAVAEvent_Attendee__c> attendeesFromQuery = [select Id, Attendee_Name__c, Reply_Status__c, Attended__c, Event__c, Contact__c 
                                                          from IAVAEvent_Attendee__c where Event__c = :ce.eId
                                                          Order by Attendee_Name__c
                                                         ];
        attendeesList = cov_customevent.createAttendeeList(attendeesFromQuery);
        
        attendeesList = [select Id, Attendee_Name__c, Reply_Status__c, Attended__c, Event__c, Contact__c 
                         , Contact__r.FirstName, Contact__r.LastName, Contact__r.Email, Contact__r.MailingPostalCode
                         , Contact__r.Post_9_11_Veteran__c, Contact__r.Veteran_of_Other_Era__c, Contact__r.Not_a_Veteran__c
                         , Contact__r.Veteran_of_OEF__c, Contact__r.Veteran_of_OIF__c, Contact__r.Veteran_of_OND__c
                         from IAVAEvent_Attendee__c where Event__c = :ce.eId
                         Order by Attendee_Name__c
                        ];
        */
        
        String q = 'select Id, Attendee_Name__c, Reply_Status__c, Attended__c, Event__c, Contact__c'
            +', Contact__r.FirstName, Contact__r.LastName, Contact__r.Email, Contact__r.MailingPostalCode'
            +', Contact__r.Post_9_11_Veteran__c, Contact__r.Veteran_of_Other_Era__c, Contact__r.Not_a_Veteran__c'
            +', Contact__r.Veteran_Member__c'
            +', Contact__r.Veteran_of_OEF__c, Contact__r.Veteran_of_OIF__c, Contact__r.Veteran_of_OND__c'
            +' from IAVAEvent_Attendee__c where Event__c = \'' + ce.eId + '\'';
        
        if (String.isNotBlank(startAttendeeParam) && String.isNotBlank(endAttendeeParam) ) {
            q += ' AND Attendee_Name__c >= \'' + startAttendeeParam + '\' AND Attendee_Name__c <= \'' + endAttendeeParam + '\'';
        }
        
        q+= ' Order by Attendee_Name__c';
        
        attendeesList = cov_nosharing_utilities.runListQuery(q);
        
        yesAttendeesList = new List<attendee>();
        noAttendeesList = new List<attendee>();
        maybeAttendeesList = new List<attendee>();
        invitedAttendeesList = new List<attendee>();
        notOnListAttendeesList = new List<attendee>();
        atLeastOneAttendeeNeedsMoreInfo = false;
        
        for (IAVAEvent_Attendee__c attnd : attendeesList) {
            attendee theAttendee = new attendee(attnd);
            if (theAttendee.collectInfo) {
                atLeastOneAttendeeNeedsMoreInfo = true;
            }
            
            List<attendee> targetList;
            if (attnd.Reply_Status__c == 'Yes') {
                targetList = yesAttendeesList;
            } else if (attnd.Reply_Status__c == 'No') {
                targetList = noAttendeesList;
            } else if (attnd.Reply_Status__c == 'Maybe') {
                targetList = maybeAttendeesList;
            } else if (attnd.Reply_Status__c == 'Not On List') {
                targetList = notonlistAttendeesList;
                //} else if (attnd.Reply_Status__c == 'Invited') {
            } else {
                targetList = invitedAttendeesList;
            }
            targetList.add(theAttendee);
            theAttendee.listIndex = targetList.size() - 1;
        }
    }
    
    public PageReference eventReply(){
        system.debug('eventIdChosen: ' + eventIdChosen);
        ce.attendeeId = staticEventReply(eventIdChosen, replyValue, cov_user_utility.self.getU(), inviterParam);
        
        if (ce.attendeeId != null) {
            ce.replyStatus = replyValue;
            includePageRefresher = true;
            if (replyValue == 'No') {
                suppressGroupDisplay = true;
            }
        }
        
        return null;
    }
    
    public static Id staticEventReply(Id eventIdChosen, String replyValue, User u, String inviterIdString) {
        if (eventIdChosen == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, please refresh the page and try again.'));
            return null;
        }
        IAVAEvent__c eventChosen;
        try {
            eventChosen = [select Id, Name, Chatter_Group_Mirror__c from IAVAEvent__c where Id = :eventIdChosen];
        } catch (Exception e) { cov_log_error.logError(e); return null; }
        
        return staticEventReply(eventChosen, replyValue, u, inviterIdString);
    }
    
    public static Id staticEventReply(IAVAEvent__c eventChosen, String replyValue, User u, String inviterIdString) {
        // check whether existing event attendee record.  if so update
        // if not create one
        
        System.debug('Event chosen to reply to: ' + eventChosen);
        System.debug('replyValue: ' + replyValue);
        
        IAVAEvent_Attendee__c attendeeRecord;
        Contact con = cov_user_contact_utility.getContactFromUser(u);
        if (con != null) {
            attendeeRecord = addAttendeeRecord(eventChosen.Id, replyValue, con, inviterIdString);
        }
        
        if (UserInfo.getUserType() == 'Guest') { 
            // guest user doesnt seem to have permissions to query collaborationgroup so cant add user to event group (TODO: fix if possible) 
            return (attendeeRecord == null ? null : attendeeRecord.Id);
        }
        
        Chatter_Group_Mirror__c theMirror;
        try {
            theMirror = [select Id, Group_ID__c from Chatter_Group_Mirror__c where Id = :eventChosen.Chatter_Group_Mirror__c];
        } catch(Exception e) { system.debug('Group mirror not found');}
        
        if (attendeeRecord != null && theMirror != null) {
            //if (attendeeRecord != null && theGroup != null) {
            //ce.replyStatus = replyValue;  TODO
            
            //if (ce.eventGroupId != null) {
            List<CollaborationGroupMember> existingGroupMembers = [select Id, CollaborationGroup.OwnerId from CollaborationGroupMember
                                                                   where MemberId = :u.Id
                                                                   and CollaborationGroupId = :theMirror.Group_Id__c];
                                                                   //and CollaborationGroupId = :theGroup.Id];
            if ((replyValue == 'Yes' || replyValue == 'Maybe') && existingGroupMembers.size() == 0) {
                CollaborationGroupMember newGroupMember = new CollaborationGroupMember(
                    CollaborationGroupId = theMirror.Group_Id__c
                    //CollaborationGroupId = theGroup.Id
                    , CollaborationRole = 'Standard'
                    , MemberId = u.Id
                    , NotificationFrequency = 'D'
                );
                try {
                    insert newGroupMember;
                } catch (DMLException e) { cov_log_error.logError(e); return null;}
                
                FeedItem post = new FeedItem();
                post.ParentId = u.Id;
                post.Body = UserInfo.getFirstName() + ' replied "' + replyValue + '" for the Event "' + eventChosen.Name + '"';
                post.LinkUrl = Site.getPathPrefix() + '/cov_event?id=' + eventChosen.Id;
                post.Title = eventChosen.Name;
                post.NetworkScope = Network.getNetworkId();
                System.debug('About to insert post: ' + post);
                try {
                    insert post;
                } catch (DMLException e) { cov_log_error.logError(e); }
            } else if (replyValue == 'No' && existingGroupMembers.size() > 0 && existingGroupMembers[0].CollaborationGroup.OwnerId != u.Id) {
                try {
                    delete existingGroupMembers[0];
                } catch (Exception e) { cov_log_error.logError(e); return null;}
            }
        }
        //}
        return attendeeRecord.Id;
    }
    
    public static IAVAEvent_Attendee__c addAttendeeRecord(Id eventIdChosen, String replyValue, Contact con, String inviterIdString) {
        return addAttendeeRecord(eventIdChosen, replyValue, con, inviterIdString, null);
    }
    
    public static IAVAEvent_Attendee__c addAttendeeRecord(Id eventIdChosen, String replyValue, Contact con, String inviterIdString, String attendeeValue) {
        return addAttendeeRecord(eventIdChosen, replyValue, con, inviterIdString, attendeeValue, true);
    }
    
    public static IAVAEvent_Attendee__c addAttendeeRecord(Id eventIdChosen, String replyValue, Contact con, String inviterIdString, String attendeeValue, Boolean overrideExistingReplyValue) {
        IAVAEvent_Attendee__c attendeeRec;
        
        if (con == null) { return null; }
        Id inviterId;
        try {
            system.debug('inviterIdString (from inviter parameter): ' + inviterIdString);
            inviterId = (Id)inviterIdString;
            system.debug('inviterIdString was a valid Id');
        } catch(Exception e) { system.debug('inviterIdString was NOT a valid Id'); }
        
        try {
            attendeeRec = [select Id from IAVAEvent_Attendee__c where Contact__c = :con.Id and Event__c = :eventIdChosen limit 1];
            System.debug('existing IAVAEvent_Attendee__c record found: ' + attendeeRec);
        } catch(QueryException e){}
        if (attendeeRec == null) {
            System.debug('No existing IAVAEvent_Attendee__c record found.');
            attendeeRec = new IAVAEvent_Attendee__c(Contact__c=con.Id, Event__c=eventIdChosen, Reply_Status__c = replyValue, Inviter__c=inviterId, Attended__c = attendeeValue);
            try {
                system.debug('about to insert attendee record: ' + attendeeRec);
                insert attendeeRec;
                system.debug('inserted.  now returning attendee record');
            } catch (DMLException e) { cov_log_error.logError(e); return null; }
            //if (ce != null) { ce.onList = true; }  TODO
        } else {
            if (overrideExistingReplyValue) {
                attendeeRec.Reply_Status__c = replyValue;
            }
            attendeeRec.Inviter__c = inviterId;
            attendeeRec.Attended__c = attendeeValue;
            try {
                update attendeeRec;
            } catch (DMLException e) { cov_log_error.logError(e); return null; }
        }
        
        if (inviterId != null) {
            List<npe4__Relationship__c> newRels = cov_relationships_controller.addRelationships(inviterId, new List<Id>{con.Id}, 'Invited to event', 'Invited to event by', false);
            system.debug('new relationship with inviter created newRels: ' + newRels);
        }
        
        return attendeeRec;
    }
    
    public PageReference refreshEventsSection() {
        // re-renders events sections on Dashboard
        System.debug('Refreshing events');
        getEventsList();
		return null;
	}
    
    public PageReference showAll() {
        numRows = cEventsList.size();
        return null;
    }
    
    public PageReference showFewer() {
        numRows = NUM_ROWS_DEFAULT;
        return null;
    }
    
    public PageReference toInviteMode() {
        inInviteMode = true;
        return null;
    }
    
    public PageReference addUser() {
        if (inviteeIds.size() < MAX_DIRECT_MESSAGES) {
            system.debug('inviteeId: ' + inviteeId);
            inviteeIds.add(inviteeId);
            system.debug('inviteeIds: ' + inviteeIds);
            
            system.debug('inviteeName: ' + inviteeName);
            inviteeNames.add(inviteeName);
            system.debug('inviteeNames: ' + inviteeNames);
            
            inviteeIdNameMap.put(inviteeId, inviteeName);
            system.debug('inviteeIdNameMap: ' + inviteeIdNameMap);
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, can\'t add any more.'));
        }
        return null;
    }
    
    public PageReference sendInvitesToUsers() {
        system.debug('Attempt to sendInvites for this list of Ids: ' + inviteeIds);
        
        if (inviteeIds.size() > 0) {
            // Map userIds to ContactIds
            Map<Id, Id> userToContactMap = cov_user_contact_utility.getUserIdToContactIdMap(inviteeIds);
            Set<Id> contactIdsToInvite = new Set<Id>(userToContactMap.values());
            
            // Map contact Ids back to User Ids
            Map<Id, Id> contactToUserMap = new Map<Id, Id>();
            for (Id i : userToContactMap.keySet()) {
                contactToUserMap.put(userToContactMap.get(i), i);
            }
            
            // upsert attendee records
            List<String> successfulUserIds = insertAttendeesFromContactIds(contactIdsToInvite, 'Portal_User__c');
            
            // also try to add relationships to all invitees
            Contact theContact = cov_user_utility.self.getC();
            if (theContact != null) {
                cov_relationships_controller.addRelationships(theContact.Id, new List<Id>(userToContactMap.values()), 'Invited to event', 'Invited to event by', true);
            }
            
            // build lists of which records were successful and unsuccessful
            Set<String> successfulUserIdsSet = new Set<String>(successfulUserIds);
            List<String> successfulInviteeIds_prev = new List<String>();
            List<String> failedInviteeIds_prev = new List<String>();
            if (successfulInviteeIds != null && successfulInviteeIds.size() > 0 ) successfulInviteeIds_prev = successfulInviteeIds.clone();
            successfulInviteeIds = new List<String>();
            if (failedInviteeIds != null && failedInviteeIds.size() > 0 ) failedInviteeIds_prev = failedInviteeIds.clone();
            failedInviteeIds = new List<String>();
            for(String s : inviteeIds) {
                if (successfulUserIdsSet.contains(s)) {
                    successfulInviteeIds.add(s);
                } else {
                    failedInviteeIds.add(s);
                }
            }
            successfulInviteeIds.addAll(successfulInviteeIds_prev);
            failedInviteeIds.addAll(failedInviteeIds_prev);
            
            // removed since using notification from attendee workflow instead
            // Send direct messages to invited users
            /*
            Id theNetworkId = cov_user_utility.self.getNetworkId();
            String secureCOVURL;
            IAVAPlus_Portal_Settings__c ps = IAVAPlus_Portal_Settings__c.getInstance('IAVA');
            if (ps != null) {
                //securePortalURL = ps.Secure_Site_URL__c;
                secureCOVURL = ps.Secure_COV_URL__c;
            }
            String theText = UserInfo.getFirstName() + ' ' + UserInfo.getLastName() + ' has invited you to the event: \r\n' 
                + ' \r\n'
                + ce.Name + '\r\n'
                + ce.startDate.format() + ' \r\n'
                + ce.city + ', ' + ce.state + ' \r\n'
                + ' \r\n'
                + secureCOVURL + '/cov_event?id=' + ce.eId;
            
            List<String> inviteeIdsList = new List<String>(inviteeIds); // convert to list so can use index in loop
            system.debug('inviteeIdsList: ' + inviteeIdsList);
            successfulInviteeIds = new List<Id>();
            failedInviteeIds = new List<String>();
            
            for (Integer i = 0; i < inviteeIdsList.size() && i < MAX_DIRECT_MESSAGES; i++) {
                Id theId;
                try {
                    theId = (Id)inviteeIdsList[i];
                    ConnectApi.ChatterMessages.sendMessage(theNetworkId, theText, theId);
                    successfulInviteeIds.add(theId);
                } catch(Exception e) {
                    failedInviteeIds.add(inviteeIdsList[i]);
                }
            }
            */
            
            inviteeIds.clear();
            inviteeNames.clear();
            inviteeId = null;
            inviteeName = null;
        }
        
        return null;
    }
    
    public PageReference sendInvitesToEmails() {
        system.debug('Attempt to sendInvites for this list of Emails: ' + inviteeEmailBox);
        
        // First look at list of emails, find existing Contacts,
        // and add non-existing emails as new Contacts
        
        List<String> legitEmails = new List<String>();
        List<String> successfulEmails_prev = new List<String>();
        List<String> failedEmails_prev = new List<String>();
        if (failedEmails != null && failedEmails.size() > 0 ) failedEmails_prev = failedEmails.clone();
        if (successfulEmails != null && successfulEmails.size() > 0 ) successfulEmails_prev = successfulEmails.clone();
        successfulEmails = new List<String>();
        failedEmails = new List<String>();
        //successfulEmailMessage = null;
        
        if (inviteeEmailBox != null && inviteeEmailBox != '') {
            inviteeEmails = inviteeEmailBox.replaceAll(';',',').replaceAll(':',',').replaceAll(' ', ',').replaceAll('\n', ',').split(',');
            for (String s : inviteeEmails) {
                s = s.trim();
                if (String.isBlank(s)) {
                    // ignore blanks - could have formerly been spaces or newlines
                    //} else if(s.indexOf('@') == -1 
                    //   || s.indexOf('.') == -1
                    //   || s.indexOf('@') != s.lastIndexOf('@')
                    //  ) {
                    //    failedEmails.add(s);
                } else if (!cov_utilities.validateEmail(s)) {
                    failedEmails.add(s);
                } else {
                    legitEmails.add(s.toLowerCase());
                }
                system.debug('after basic validation, legitEmails: ' + legitEmails);
                system.debug('and failedEmails: ' + failedEmails);
            }
            if (legitEmails.size() > 0) {
                List<Contact> contactsFromEmails = [select Id, FirstName, LastName
                                                    , Email
                                                    , npe01__AlternateEmail__c
                                                    , npe01__HomeEmail__c
                                                    , npe01__WorkEmail__c
                                                    from Contact where 
                                                    Email in :legitEmails
                                                    or npe01__AlternateEmail__c in :legitEmails
                                                    or npe01__HomeEmail__c in :legitEmails
                                                    or npe01__WorkEmail__c in :legitEmails
                                                   ];
                Map<String, Contact> existingEmailsToContactMap = new Map<String, Contact>();
                // Map the entered email to the primary email on the record 
                // so we can match successful emails back to the destination email
                //Map<String, String> primaryEmailToEnteredEmailMap = new Map<String, String>();
                Map<String, String> enteredEmailToPrimaryEmailMap = new Map<String, String>();
                for (Contact c : contactsFromEmails) {
                    if (c.Email != null) {
                        existingEmailsToContactMap.put(c.Email, c);
                        //primaryEmailToEnteredEmailMap.put(c.Email, c.Email);
                        enteredEmailToPrimaryEmailMap.put(c.Email, c.Email);
                    }
                    if (c.npe01__AlternateEmail__c != null) {
                        existingEmailsToContactMap.put(c.npe01__AlternateEmail__c, c);
                        //primaryEmailToEnteredEmailMap.put(c.Email, c.npe01__AlternateEmail__c);
                        enteredEmailToPrimaryEmailMap.put(c.npe01__AlternateEmail__c, c.Email);
                    }
                    if (c.npe01__HomeEmail__c != null) {
                        existingEmailsToContactMap.put(c.npe01__HomeEmail__c, c);
                        //primaryEmailToEnteredEmailMap.put(c.Email, c.npe01__HomeEmail__c);
                        enteredEmailToPrimaryEmailMap.put(c.npe01__HomeEmail__c, c.Email);
                    }
                    if (c.npe01__WorkEmail__c != null) {
                        existingEmailsToContactMap.put(c.npe01__WorkEmail__c, c);
                        //primaryEmailToEnteredEmailMap.put(c.Email, c.npe01__WorkEmail__c);
                        enteredEmailToPrimaryEmailMap.put(c.npe01__WorkEmail__c, c.Email);
                    }
                }
                List<Contact> contactsToInsert = new List<Contact>();
                List<Contact> contactsFromEmail = new List<Contact>();
                List<Id> contactIdsToInviteFromEmail = new List<Id>();
                for (String s : legitEmails) {
                    Contact theCon = existingEmailsToContactMap.get(s);
                    if (theCon != null) {
                        contactsFromEmail.add(theCon);
                        system.debug('Found this contact: ' + theCon);
                    } else {
                        system.debug('Adding new contact.');
                        contactsToInsert.add(new Contact(
                            LastName = '(Unknown)'
                            , Email = s
                            , No_Email_Blasts__c = true
                            , Source_Details__c = 'Invited to event ' + ce.Name + ' by ' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName()
                            , Source__c = 'Event'
                        )
                                            );
                        //primaryEmailToEnteredEmailMap.put(s, s);
                        enteredEmailToPrimaryEmailMap.put(s, s);
                    }
                }
                
                // Bulk version:
                // Pre-insert account if it's a portal user as a workaround to NPSP issue
                // where NPSP3 accounts trigger which cant insert an account
                // with a portal user as owner. So instead first create the account before inserting contact
                // If issue gets fixed by NPSP then can remove this code (and part 2 a few lines below).
                Map<Contact, Account> contactToNewAccountMap = cov_npsp_workaround.preInsertAdminOwnedAccounts(contactsToInsert, true);
                if (contactToNewAccountMap != null && contactToNewAccountMap.size() > 0) {
                    for (Contact contactToInsert : contactToNewAccountMap.keySet()) {
                        Account newAccount = contactToNewAccountMap.get(contactToInsert);
                        if (newAccount != null && newAccount.Id != null) {
                            contactToInsert.AccountId = newAccount.Id;
                        }
                    }
                }
                
                try {
                    insert contactsToInsert;
                    contactsFromEmail.addAll(contactsToInsert);
                    system.debug('inserted contactsFromEmail: ' + contactsFromEmail);
                } catch (Exception e) {
                    system.debug('error inserting contacts');
                    cov_log_error.logError(e);
                    //successfulEmailMessage = 'Sorry, there may have been some errors sending the invites.';
                }
                
                // Part 2 of the NPSP account workaround referenced above - bulk version
                List<Account> accountsForPostUpdate = new List<Account>();
                List<Contact> contactsForPostUpdate = new List<Contact>();
                for (Contact contactToUpdate : contactToNewAccountMap.keySet()) {
                    Account newAccount = contactToNewAccountMap.get(contactToUpdate);
                    if (newAccount != null && newAccount.Id != null && newAccount.npe01__One2OneContact__c == null) {
                        contactToUpdate.AccountId = newAccount.Id;
                        accountsForPostUpdate.add(newAccount);
                        contactsForPostUpdate.add(contactToUpdate);
                    }
                }
                if (accountsForPostUpdate.size() > 0) {
                    List<Account> updatedAccounts = cov_npsp_workaround.postUpdateAccountOne2OneContacts(accountsForPostUpdate, contactsForPostUpdate);
                }
                
                // this keyset constructor didnt work to eliminate duplicate emails
                //Set<Id> contactIdsFromEmail = (new Map<Id,SObject>(contactsFromEmail)).keySet();
                Set<Id> contactIdsFromEmail = new Set<Id>();
                for (Contact cfe : contactsFromEmail) {
                    contactIdsFromEmail.add(cfe.Id);
                }
                
                List<String> successfulPrimaryEmails = insertAttendeesFromContactIds(contactIdsFromEmail, 'Email');
                system.debug('successfulPrimaryEmails: ' + successfulPrimaryEmails);
                //if (attendeeRecs.size() > 0) {
                //  successfulEmailMessage = attendeeRecs.size() + ' invites sent.';
                //}
                
                // also try to add relationships to all invitees
                Contact theContact = cov_user_utility.self.getC();
                if (theContact != null) {
                    cov_relationships_controller.addRelationships(theContact.Id, new List<Id>(contactIdsFromEmail), 'Invited to event', 'Invited to event by', true);
                }
                
                // build lists of which records were successful and unsuccessful
                Set<String> successfulEmailsSetLowercase = new Set<String>();
                for (String s : successfulPrimaryEmails) {
                    successfulEmailsSetLowercase.add(s.toLowerCase());
                }
                
                Set<String> alreadyListedSuccessfulEmails = new Set<String>();
                Set<String> alreadyListedFailedEmails = new Set<String>();
                for(String s : legitEmails) {
                    //String emailEntered = primaryEmailToEnteredEmailMap.get(s) == null ? s : primaryEmailToEnteredEmailMap.get(s);
                    String primaryEmail = enteredEmailToPrimaryEmailMap.get(s) == null ? s : enteredEmailToPrimaryEmailMap.get(s);
                    if (!alreadyListedSuccessfulEmails.contains(s)) {
                        if (successfulEmailsSetLowercase.contains(primaryEmail.toLowerCase())) {
                            successfulEmails.add(s);
                            alreadyListedSuccessfulEmails.add(s);
                        } else if (!alreadyListedFailedEmails.contains(s)) {
                            failedEmails.add(s);
                            alreadyListedFailedEmails.add(s);
                        }
                    }
                }
            }
            successfulEmails.addAll(successfulEmails_prev);
            failedEmails.addAll(failedEmails_prev);
            inviteeEmailBox = null;  // use javascript to clear for now, and later maybe use javascript remoting instead
            system.debug('successfulEmails: ' + successfulEmails);
            system.debug('failedEmails: ' + failedEmails);
        }
        
        return null;
    }
    
    public List<String> insertAttendeesFromContactIds(Set<Id> contactIdsToInvite, String returnFieldOnContact) {
        List<IAVAEvent_Attendee__c> existingAttendees = [select Id, Contact__c, Reply_Status__c 
                                                         from IAVAEvent_Attendee__c
                                                         where Contact__c in :contactIdsToInvite
                                                         and Event__c = :ce.eId
                                                        ];
        Map<Id, IAVAEvent_Attendee__c> existingAttendeesMap = new Map<Id, IAVAEvent_Attendee__c>();
        //Set<String> existingAttendeeContactIds = new Set<String>();
        for (IAVAEvent_Attendee__c att : existingAttendees) {
            //existingAttendeeContactIds.add(att.Contact__c);
            existingAttendeesMap.put(att.Contact__c, att);
        }
        
        List<IAVAEvent_Attendee__c> attendeesToUpsert = new List<IAVAEvent_Attendee__c>();
        Contact theContact = cov_user_utility.self.getC();
        Id theContactId = theContact == null ? null : theContact.Id;
        
        for (Id theI : contactIdsToInvite) {
            if (existingAttendeesMap.containsKey(theI)) {
                IAVAEvent_Attendee__c attnd = existingAttendeesMap.get(theI);
                attnd.Inviter__c = theContactId;
                attnd.Notify_attendee_of_invitation__c = true;
                attendeesToUpsert.add(attnd);
            } else {
                IAVAEvent_Attendee__c attnd = new IAVAEvent_Attendee__c(
                    Contact__c = theI
                    , Reply_Status__c = 'Invited'
                    , Event__c = ce.eId
                    , Inviter__c = theContactId
                    , Notify_attendee_of_invitation__c = true
                );
                attendeesToUpsert.add(attnd);
            }
        }
        
        Database.UpsertResult[] urList = Database.upsert(attendeesToUpsert, false);
        system.debug('urList: ' + urList);
        
        List<Id> successfulAttendeeIds = new List<Id>();
        for (Database.UpsertResult ur : urList) {
            if (ur.isSuccess()) {
                successfulAttendeeIds.add(ur.getId());
            }
        }
        String q = 'select Id, Contact__c, Contact__r.' + returnFieldOnContact
            + ' from IAVAEvent_Attendee__c where Id in :successfulAttendeeIds';
        
        List<IAVAEvent_Attendee__c> successfulAttendeeRecords = Database.query(q);
        System.debug('successfulAttendeeRecords: ' + successfulAttendeeRecords);
        
        //List<IAVAEvent_Attendee__c> successfulAttendeeRecords = [select Id, Contact__c 
        //                                                          from IAVAEvent_Attendee__c
        //                                                          where Id in :successfulAttendeeIds
        //                                                          ];
        List<String> returnList = new List<String>();
        for (IAVAEvent_Attendee__c att : successfulAttendeeRecords) {
            returnList.add((String)att.getSObject('Contact__r').get(returnFieldOnContact));
        }
        
        return returnList;
    }
    
    public PageReference toDetailPage() {
        PageReference pageRef = Page.cov_event;
        pageRef.getParameters().put('id', ce.eId);
        if (headerParam != null && headerParam != '') {
            pageRef.getParameters().put('header', headerParam);
        }
        inInviteMode = false;
        return pageRef;
    }
    
    public PageReference nonAuthReply() {
        if (
            String.isEmpty(nonAuthReplyFirstName) || String.isEmpty(nonAuthReplyLastName) || String.isEmpty(nonAuthReplyEmail)
        ) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, name and email are required.'));
            return null;
            //} else if(nonAuthReplyEmail.indexOf('@') == -1 
            //       || nonAuthReplyEmail.indexOf('.') == -1
            //       || nonAuthReplyEmail.indexOf('@') != nonAuthReplyEmail.lastIndexOf('@')
            //  ) {
        } else if (String.isEmpty(nonAuthReplyValue)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select whether you are planning to attend.'));
            return null;
        } else if (!cov_utilities.validateEmail(nonAuthReplyEmail)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'That email appears to be invalid.'));
            return null;
        } else {
            Contact replyCon;
            Boolean isExistingCOVUser = false;
            User relatedU;
            
            String replyConQuery = 'select Id, Email, FirstName, LastName, Veteran_Member__c'
                + ', MobilePhone, npe01__PreferredPhone__c'
                + ', Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, Veteran_of_Other_Era__c, Veteran_Family_Member__c, Not_a_Veteran__c'
                + ', Portal_User__c'
                + ' from Contact where Email = \'' + nonAuthReplyEmail + '\' order by Portal_User__c NULLS LAST limit 1';
            
            replyCon = (Contact)cov_nosharing_utilities.runSingleQuery(replyConQuery);
            
            nonAuthReplyPost911 = nonAuthReplyPost911 == null ? false : nonAuthReplyPost911;
            nonAuthReplyOEF = nonAuthReplyOEF == null ? false : nonAuthReplyOEF;
            nonAuthReplyOIF = nonAuthReplyOIF == null ? false : nonAuthReplyOIF;
            nonAuthReplyOND = nonAuthReplyOND == null ? false : nonAuthReplyOND;
            nonAuthReplyOtherEra = nonAuthReplyOtherEra == null ? false : nonAuthReplyOtherEra;
            nonAuthReplyFamily = nonAuthReplyFamily == null ? false : nonAuthReplyFamily;
            nonAuthReplyNotVeteran = nonAuthReplyNotVeteran == null ? false : nonAuthReplyNotVeteran;
            Boolean post911 = nonAuthReplyPost911 || nonAuthReplyOEF || nonAuthReplyOIF || nonAuthReplyOND;
            
            if (replyCon == null) {
                replyCon = new Contact(
                    FirstName=nonAuthReplyFirstName
                    , LastName=nonAuthReplyLastName
                    , Email=nonAuthReplyEmail
                    , MobilePhone=nonAuthReplyPhone
                    , npe01__PreferredPhone__c='Mobile'
                    , Veteran_Member__c = post911
                    , Veteran_of_OEF__c = nonAuthReplyOEF
                    , Veteran_of_OIF__c = nonAuthReplyOIF
                    , Veteran_of_OND__c = nonAuthReplyOND
                    , Veteran_of_Other_Era__c = nonAuthReplyOtherEra
                    , Veteran_Family_Member__c = nonAuthReplyFamily
                    , Not_a_Veteran__c = nonAuthReplyNotVeteran
                    , Source__c = 'Event'
                    , Source_Details__c = '[Event] - ' + ce.Name
                );
                
                // Pre-insert account if it's a portal user as a workaround to NPSP issue
                // where NPSP3 accounts trigger which cant insert an account
                // with a portal user as owner. So instead first create the account before inserting contact
                // If issue gets fixed by NPSP then can remove this code (and part 2 a few lines below).
                Account a = cov_npsp_workaround.preInsertAdminOwnedAccount(replyCon, true);
                if (a != null && a.Id != null) {
                    replyCon.AccountId = a.Id;
                }
                
                try {
                    insert replyCon;
                } catch (DMLException e) {
                    cov_log_error.logError(e);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry there was an error tracking your reply.'));
                    return null;
                }
                
                // Part 2 of the NPSP account workaround referenced above
                if (a != null && a.npe01__One2OneContact__c == null) {
                    cov_npsp_workaround.postUpdateAccountOne2OneContact(a, replyCon);
                }
            } else {
                relatedU = cov_user_contact_utility.getUserFromContact(replyCon, new List<String>{'ContactId'});
                isExistingCOVUser = cov_gateway_controller.alreadyHasPermissionSet(relatedU, 'COV Access');
                
                // see if existing contact fields need to be updated based on new info
                Boolean updateContact = false;
                if (!replyCon.Veteran_Member__c && post911) {
                    replyCon.Veteran_Member__c = true;
                    updateContact = true;
                }
                if (!replyCon.Veteran_of_OEF__c && nonAuthReplyOEF) {
                    replyCon.Veteran_of_OEF__c = true;
                    updateContact = true;
                }
                if (!replyCon.Veteran_of_OIF__c && nonAuthReplyOIF) {
                    replyCon.Veteran_of_OIF__c = true;
                    updateContact = true;
                }
                if (!replyCon.Veteran_of_OND__c && nonAuthReplyOND) {
                    replyCon.Veteran_of_OND__c = true;
                    updateContact = true;
                }
                if (!replyCon.Veteran_of_Other_Era__c && nonAuthReplyOtherEra) {
                    replyCon.Veteran_of_Other_Era__c = true;
                    updateContact = true;
                }
                if (!replyCon.Veteran_Family_Member__c && nonAuthReplyFamily) {
                    replyCon.Veteran_Family_Member__c = true;
                    updateContact = true;
                }
                if (!replyCon.Not_a_Veteran__c && nonAuthReplyNotVeteran) {
                    replyCon.Not_a_Veteran__c = true;
                    updateContact = true;
                }
                if (String.isEmpty(replyCon.FirstName) || replyCon.FirstName == replyCon.Email) {
                    replyCon.FirstName = nonAuthReplyFirstName;
                    updateContact = true;
                }
                if (String.isEmpty(replyCon.LastName) || replyCon.LastName == '(Unknown)' || replyCon.LastName == replyCon.Email) {
                    replyCon.LastName = nonAuthReplyLastName;
                    updateContact = true;
                }
                if (nonAuthReplyPhone != null) {
                    replyCon.MobilePhone = nonAuthReplyPhone;
                    replyCon.npe01__PreferredPhone__c = 'Mobile';
                    updateContact = true;
                }
                if (updateContact) {
                    try {
                        system.debug('about to try to update contact: ' + replyCon);
                        update replyCon;
                        system.debug('contact updated: ' + replyCon);
                    } catch (DMLException e) {
                        cov_log_error.logError(e);
                    }
                }
            }
            
            if (isExistingCOVUser && relatedU != null) {
                ce.attendeeId = staticEventReply(ce.eId, nonAuthReplyValue, relatedU, inviterParam);
                if (ce.attendeeId != null) {
                    ce.replyStatus = nonAuthReplyValue;
                    String confMsg = 'Thanks, your reply was recorded. You should receive a confirmation email with the details of the event. Remember you can log into myIAVA to change your reply';
                    if (ce.collectGuestInfo && ce.canAddGuests) {
                        confMsg += ' or manage guests.';
                    } else {
                        confMsg += '.';
                    }
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, confMsg));
                    if (conId == null && replyCon != null) {
                        conId = replyCon.Id;
                    }
                    nonAuthReplied = true;
                    return null;
                } else {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry there was a problem adding you to the event.'));
                    return null;
                }
            } else {
                IAVAEvent_Attendee__c attendeeRecord = addAttendeeRecord(ce.eId, nonAuthReplyValue, replyCon, inviterParam);
                if (attendeeRecord == null) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry there was a problem adding you to the event.'));
                    return null;
                } else {
                    ce.attendeeId = attendeeRecord.Id;
                    ce.replyStatus = attendeeRecord.Reply_Status__c;
                    conId = attendeeRecord.Contact__c;
                    nonAuthReplied = true;
                    String confMsg = 'Thanks, your reply was recorded. You should receive a confirmation email with the details of the event.';
                    if (ce.collectGuestInfo && ce.canAddGuests) {
                        confMsg += ' You may also add guests below.';
                    }
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, confMsg));
                    if (ce.replyStatus == 'Yes') {
                        refreshGuestList();
                    }
                    
                    if (ce.eventGroupMirrorId != null) {
                        Id eventAutoAddCampaignId;
                        List<Chatter_Group_Mirror__c> mirrors = [select Id, Group_ID__c, Auto_add_Campaign__c from Chatter_Group_Mirror__c where Id = :ce.eventGroupMirrorId];
                        if (mirrors.size() == 0 || mirrors[0].Auto_add_Campaign__c == null) {
                            Campaign cmp = new Campaign(Name='[Event auto-add] ' + ce.Name.left(53), Type='Contact Grouping', Status='In Progress', isActive=true, AIR_required__c = false);
                            try {
                                insert cmp;
                                mirrors[0].Auto_add_Campaign__c = cmp.Id;
                                system.debug('about to update mirrors[0]: ' + mirrors[0]);
                                update mirrors[0];
                                eventAutoAddCampaignId = cmp.Id;
                            } catch (Exception e) { cov_log_error.logError(e); }
                        } else {
                            eventAutoAddCampaignId = mirrors[0].Auto_add_Campaign__c;
                        }
                        CampaignMember theCM;
                        try {
                            theCM = [select Id from CampaignMember where ContactId = :replyCon.Id and CampaignId = :eventAutoAddCampaignId limit 1];
                            System.debug('existing CampaignMember record found: ' + theCM);
                        } catch(QueryException e){}
                        if (theCM == null && nonAuthReplyValue == 'Yes') {
                            System.debug('No existing CampaignMember record found.');
                            theCM = new CampaignMember(ContactId = replyCon.Id, CampaignId = eventAutoAddCampaignId);
                            try {
                                insert theCM;
                            } catch (DMLException e) { cov_log_error.logError(e); }
                        } else if (theCM != null && nonAuthReplyValue == 'No') {
                            try {
                                delete theCM;
                            } catch (DMLException e) { cov_log_error.logError(e); }
                        }
                        //CampaignMember cm = new CampaignMember(ContactId = replyCon.Id, CampaignId = eventAutoAddCampaignId);
                        //try {
                        //  insert cm;
                        //} catch(Exception e) { if(!e.getMessage().contains('entity is already a member of this campaign')) { cov_log_error.logError(e); } }
                    }
                    
                    return null;
                }
            }
        }
    }
    
    public PageReference changeNonAuthReply() {
        nonAuthReplied = false;
        inGuestEditMode = false;
        ce.replyStatus = null; // to set ce.CanHaveGuests to false and make Add Guests link disappear
        return null;
    }
    
    public PageReference markAttended() {
        system.debug('attendeeListChosen: ' + attendeeListChosen);
        system.debug('attendeeChosenIndex: ' + attendeeChosenIndex);
        
        attendee attendeeChosen = findAttendeeFromListAndIndex(attendeeListChosen, attendeeChosenIndex);
        if (attendeeChosen == null) {
            cov_log_error.logDevMsg('TargetList for event attendee did not have this index: ' + attendeeChosenIndex);
            resetAttendeeChosenFields();
            return null;
        }
        
        attendeeChosen.att.Attended__c = 'Yes';
        try {
            update attendeeChosen.att;
        } catch (Exception e) {
            cov_log_error.logError(e, 'error marking this attendee as Attended: ' + attendeeForMoreInfo.att);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry there was an error making that person as attended.'));
            resetAttendeeChosenFields();
            return null;
        }
        if (attendeeChosen.collectInfo == true) {
            attendeeForMoreInfo = attendeeChosen;
        }
        
        resetAttendeeChosenFields();
        return null;
    }
    
    public void resetAttendeeChosenFields() {
        //attendeeListIndex = 0;
        attendeeListChosen = null;
        attendeeChosenIndex = null;
    }
    
    public PageReference setAttendeeForCollection() {
        attendee attendeeChosen = findAttendeeFromListAndIndex(attendeeListChosen, attendeeChosenIndex);
        if (attendeeChosen == null) {
            cov_log_error.logDevMsg('TargetList for event attendee did not have this index: ' + attendeeChosenIndex);
        } else if (attendeeChosen.collectInfo == true) {
            attendeeForMoreInfo = attendeeChosen;
        }
        resetAttendeeChosenFields();
        return null;
    }
    
    public attendee findAttendeeFromListAndIndex(String listName, Integer listIndex) {
        if (listName == null || listIndex == null) {
            return null;
        } else {
            List<attendee> targetList;
            if (listName == 'Yes') {
                targetList = yesAttendeesList;
            } else if (listName == 'No') {
                targetList = noAttendeesList;
            } else if (listName == 'Maybe') {
                targetList = maybeAttendeesList;
            } else if (listName == 'Invited') {
                targetList = invitedAttendeesList;
            } else if (listName == 'Not on List') {
                targetList = notonlistAttendeesList;
            } else {
                cov_log_error.logDevMsg('Problem identifying targetList for event attendee: ' + listName + '[' + listIndex + ']');
                resetAttendeeChosenFields();
                return null;
            }
            if (targetList.size() > listIndex) {
                return targetList[listIndex];
            } else {
                return null;
            }
        }
    }
    
    public PageReference closeCollectionModal() {
        attendeeForMoreInfo = null;
        return null;
    }
    
    public PageReference saveCollectionModal() {
        system.debug('attendeeForMoreInfo: ' + attendeeForMoreInfo);
        if (attendeeForMoreInfo != null && attendeeForMoreInfo.collectInfo) {
            String conQuery = 'select Id, Email, FirstName, LastName, MailingPostalCode, Veteran_Member__c'
                + ', Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, Veteran_of_Other_Era__c, Not_a_Veteran__c'
                + ', Post_9_11_Veteran__c'
                + ' from Contact where Id = \'' + attendeeForMoreInfo.att.Contact__c + '\'';
            Contact targetCon = (Contact)cov_nosharing_utilities.runSingleQuery(conQuery);
            if (targetCon != null) {
                Boolean updateTheContact;
                if (attendeeForMoreInfo.collectFirstName && firstNameCollected != targetCon.FirstName) {
                    targetCon.FirstName = firstNameCollected;
                    updateTheContact = true;
                }
                if (attendeeForMoreInfo.collectLastName && lastNameCollected != targetCon.LastName) {
                    targetCon.LastName = lastNameCollected;
                    updateTheContact = true;
                }
                if (attendeeForMoreInfo.collectEmail && emailCollected != targetCon.Email) {
                    targetCon.Email = emailCollected;
                    updateTheContact = true;
                }
                if (attendeeForMoreInfo.collectZip && zipCollected != targetCon.MailingPostalCode) {
                    targetCon.MailingPostalCode = zipCollected;
                    updateTheContact = true;
                }
                if (attendeeForMoreInfo.collectVeteranStatus) {
                    if (oefCollected == true && targetCon.Veteran_of_OEF__c != true) {
                        targetCon.Veteran_of_OEF__c = true;
                        targetCon.Veteran_Member__c = true;
                        updateTheContact = true;
                    }
                    if (oifCollected == true && targetCon.Veteran_of_OIF__c != true) {
                        targetCon.Veteran_of_OIF__c = true;
                        targetCon.Veteran_Member__c = true;
                        updateTheContact = true;
                    }
                    if (ondCollected == true && targetCon.Veteran_of_OND__c != true) {
                        targetCon.Veteran_of_OND__c = true;
                        targetCon.Veteran_Member__c = true;
                        updateTheContact = true;
                    }
                    if (post911Collected == true && targetCon.Post_9_11_Veteran__c != true) {
                        targetCon.Post_9_11_Veteran__c = true;
                        targetCon.Veteran_Member__c = true;
                        updateTheContact = true;
                    }
                    if (otherEraCollected == true && targetCon.Veteran_of_Other_Era__c != true) {
                        targetCon.Veteran_of_Other_Era__c = true;
                        updateTheContact = true;
                    }
                    if (notVeteranCollected == true && targetCon.Not_a_Veteran__c != true) {
                        targetCon.Not_a_Veteran__c = true;
                        updateTheContact = true;
                    }
                }
                if (updateTheContact) {
                    Database.SaveResult sr = cov_nosharing_utilities.runDatabaseUpdate(targetCon, false);
                    if (sr.isSuccess()) {
                        attendeeForMoreInfo.updateAttendeeContactFields(targetCon);
                        attendeeForMoreInfo.assessContactFieldCompleteness();
                    } else {
                        cov_log_error.logDevMsg('Error trying to update the Contact from the checkin page: ' + targetCon);
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, there was an error saving that info.'));
                    }
                }
            } else {
                cov_log_error.logDevMsg('Couldnt find Contact to update from the checkin page with Id: ' + attendeeForMoreInfo.att.Contact__c);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, there was an error saving that info.'));
            }
        }
        attendeeForMoreInfo = null;
        wipeCollectionFields();
        return null;
    }
    
    public void wipeCollectionFields() {
        firstNameCollected = null;
        lastNameCollected = null;
        emailCollected = null;
        zipCollected = null;
        post911Collected = null;
        otherEraCollected = null;
        oefCollected = null;
        oifCollected = null;
        ondCollected = null;
        notVeteranCollected = null;
    }
    
    public PageReference saveAttendanceChanges() {
        system.debug('in saveAttendanceChanges');
        Map<Id, String> attendanceReplyMap = new Map<Id, String>();
        Set<Id> attendeeIds = new Set<Id>();
        List<String> replies = attendanceArray == null ? null : attendanceArray.split(';');
        for (String s : replies) {
            s = s.trim();
            Integer colonIndex = s.indexOf(':');
            String attendeeRecId = s.left(colonIndex).trim();
            try {
                attendeeIds.add((Id)attendeeRecId);
                attendanceReplyMap.put((Id)attendeeRecId, s.right(s.length() - colonIndex - 1).trim());
            } catch(Exception e) { cov_log_error.logError(e); }
        }
        system.debug('attendanceReplyMap: ' + attendanceReplyMap);
        
        //List<IAVAEvent_Attendee__c> attendeesRecordsToQuery = [select Id, Attended__c from IAVAEvent_Attendee__c where Id in :attendeeIds];
        List<IAVAEvent_Attendee__c> attendeesToUpdate = new List<IAVAEvent_Attendee__c>();
        //for (IAVAEvent_Attendee__c attnd : attendeesRecordsToQuery) {
        for (IAVAEvent_Attendee__c attnd : attendeesList) {
            String newAttendance = attendanceReplyMap.get(attnd.Id);
            if (attendanceReplyMap.containsKey(attnd.Id) && newAttendance != attnd.Attended__c) {
                attnd.Attended__c = newAttendance;
                attendeesToUpdate.add(attnd);
            }
        }
        if (attendeesToUpdate.size() > 0) {
            Database.SaveResult[] srList = Database.update(attendeesToUpdate, false);
        }
        loadAttendeesList();
        attendanceArray = null;
        
        return null;
    }
    
    public PageReference addNewAttendee() {
        newAttendeeNoEmailAvailable = newAttendeeNoEmailAvailable == null ? false : newAttendeeNoEmailAvailable;
        if (String.isEmpty(newAttendeeFirstName) || String.isEmpty(newAttendeeLastName)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Name is required.'));
            return null;
        } else if (String.isEmpty(newAttendeeEmail) && !newAttendeeNoEmailAvailable) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Email is required or check the box if email is not available.'));
            return null;
        } else if (!newAttendeeNoEmailAvailable && !cov_utilities.validateEmail(newAttendeeEmail)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'That email appears to be invalid.'));
            return null;
        } else {
            Contact newAttendeeCon;
            if (!String.isEmpty(newAttendeeEmail)) {
                try {
                    newAttendeeCon = [select Id, Email, FirstName, LastName, MailingPostalCode, Post_9_11_Veteran__c, Veteran_Member__c
                                      from Contact where Email = :newAttendeeEmail limit 1];
                } catch(QueryException e){}
            }
            if (newAttendeeCon != null) {
                // create eventGuest just as a temp wrapper to update the contact
                Id nullId;
                cov_customevent.eventGuest wrapperGuest = new cov_customevent.eventGuest(nullId);
                wrapperGuest.FirstName = newAttendeeFirstName;
                wrapperGuest.LastName = newAttendeeLastName;
                wrapperGuest.Zip = newAttendeeZip;
                wrapperGuest.post911 = newAttendeeVeteran;
                wrapperGuest.veteranMember = newAttendeeVeteran;
                Boolean b = cov_customevent.fillInContactInfoFromAttendeeInfo(wrapperGuest, newAttendeeCon);
            } else {
                newAttendeeCon = new Contact(
                    FirstName=newAttendeeFirstName
                    , LastName=newAttendeeLastName
                    , Email=newAttendeeEmail
                    , MailingPostalCode = newAttendeeZip
                    , Post_9_11_Veteran__c = newAttendeeVeteran
                    , Veteran_Member__c = newAttendeeVeteran
                    , Source__c = 'Event'
                    , Source_Details__c = '[Event] - Attended ' + ce.Name
                );
                
                // Pre-insert account if it's a portal user as a workaround to NPSP issue
                // where NPSP3 accounts trigger which cant insert an account
                // with a portal user as owner. So instead first create the account before inserting contact
                // If issue gets fixed by NPSP then can remove this code (and part 2 a few lines below).
                Account a = cov_npsp_workaround.preInsertAdminOwnedAccount(newAttendeeCon, true);
                if (a != null && a.Id != null) {
                    newAttendeeCon.AccountId = a.Id;
                }
                
                Database.SaveResult sr = cov_nosharing_utilities.runDatabaseInsert(newAttendeeCon, false);
                if (!sr.isSuccess()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, there was a problem adding this person.'));
                    cov_log_error.logDevMsg('Error inserting a new attendee record from checkin page. newAttendeeCon: ' + newAttendeeCon);
                    for (Database.Error er : sr.getErrors()) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, er.getMessage()));
                        system.debug('the error is ' + er.getMessage());
                    }
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There was a problem adding this person. Please double check whether the person was added to the list above.'));
                    return null;
                } else {
                    // Part 2 of the NPSP account workaround referenced above
                    if (a != null && a.npe01__One2OneContact__c == null) {
                        cov_npsp_workaround.postUpdateAccountOne2OneContact(a, newAttendeeCon);
                    }
                    
                    if (newAttendeeNoEmailAvailable) {
                        String newContactName = newAttendeeCon.FirstName + ' ' + newAttendeeLastName;
                        String caseMsg = 'Contact ' + newContactName + ' created without email during event checkin for event Id ' + ce.eId + '. Check if it\'s a duplicate. Created by ' + UserInfo.getName() + ' (' + UserInfo.getUserId() + ')';
                        //cov_support_controller.createSupportCase('Check for duplicate for: ' + newContactName, caseMsg, 'data', null, newAttendeeCon.Id);
                    }
                }
                /*
                try {
                    insert newAttendeeCon;
                    if (newAttendeeNoEmailAvailable) {
                        String newContactName = newAttendeeCon.FirstName + ' ' + newAttendeeLastName;
                        String caseMsg = 'Contact ' + newContactName + ' created without email during event checkin for event Id ' + ce.eId + '. Check if it\'s a duplicate. Created by ' + UserInfo.getName() + ' (' + UserInfo.getUserId() + ')';
                        cov_support_controller.createSupportCase('Check for duplicate for: ' + newContactName, caseMsg, 'data', null, newAttendeeCon.Id);
                    }
                } catch (DMLException e) {
                    cov_log_error.logError(e);
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, there was a problem adding this person.'));
                    return null;
                }
                */
            }
            
            IAVAEvent_Attendee__c attendeeToInsert = addAttendeeRecord(ce.eId, 'Not on list', newAttendeeCon, null, 'Yes', false);
            
            /*
            IAVAEvent_Attendee__c attendeeToInsert = new IAVAEvent_Attendee__c(
                Event__c = ce.eId
                , Contact__c = newAttendeeCon.Id
                , Reply_Status__c = 'Not on list'
                , Attended__c = 'Yes'
            );
            try {
                insert attendeeToInsert;
            } catch (DMLException e) {
                cov_log_error.logError(e);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, there was a problem adding this person to this event.'));
                return null;
            }
            */
            
            if (attendeeToInsert == null) {
                cov_log_error.logDevMsg('Error adding attendee for Contact ' + newAttendeeCon.Id + ' on event ' + ce.eId);
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, there was a problem adding this person to this event.'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Added.'));
                newAttendeeFirstName = null;
                newAttendeeLastName = null;
                newAttendeeEmail = null;
                newAttendeeNoEmailAvailable = null;
                newAttendeeZip = null;
                newAttendeeVeteran = null;
                loadAttendeesList();
            }
            return null;
        }
    }
    
    public static Map<String, String> getPicsForEventsById(Set<String> eventIdsForPics) {
        Map<String, String> eventIdToImageMap = new Map<String, String>();
        List<IAVAEvent__c> eventsList = [select Id, Name
                                         , (select id, Name from Attachments where name like '%image%' order by CreatedDate DESC)
                                         from IAVAEvent__c where Id in :eventIdsForPics
                                        ];
        for (IAVAEvent__c ev : eventsList) {
            if (ev.Attachments.size() > 0) {
                List<String> imageIds = cov_utilities.parseImagesFromAttachments(ev.Attachments);
                if (!String.isEmpty(imageIds[0])) {
                    eventIdToImageMap.put(ev.Id, 'servlet/servlet.FileDownload?file=' + imageIds[0]);
                }
            }
        }
        return eventIdToImageMap;
    }
}