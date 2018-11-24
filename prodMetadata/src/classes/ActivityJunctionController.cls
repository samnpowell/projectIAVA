public with sharing class ActivityJunctionController {

    
// Developed by Richard Saunders, Exponent Partners, for IAVA 2011

    public Activity_Junction__c trackacall {get;set;}
    String legid, dcid, stid, faid, prid, retUrl;  // potential ids passed in on the command line
    public Task followuptask {get;set;}
    public Boolean schedfutask {get;set;}
    public Set<Id> faset = new Set<Id>();   // focus area set
    private Map<Id, Id> prToFAMap = new Map<Id, Id>();
    private static final String errtxt = 'Error creating the Track a Call junction records. Please contact the administrator. Error: ';
    
    public Integer focusAreaSize { get; private set; }
    public Integer policyRecSize { get; private set; }
    public Integer legislationSize { get; private set; }
    public Integer DCEventSize { get; private set; }
    public Integer statSize { get; private set; }
    
    private static final Integer MaxListSize = 20;      // maximum number of select list items displayed
    private static final Integer MaxLabelLength = 60;   // maximum length of select list label
    
    public ActivityJunctionController(Apexpages.Standardcontroller stdcon) {
        trackacall = (Activity_Junction__c) stdcon.getRecord();
        
        // defaults track a call record
        trackacall.Name = 'Track a Call';
        trackacall.Assigned_To__c = UserInfo.getUserId();
        trackacall.Date_of_Call__c = system.today();
        trackacall.Status__c = 'Completed';
        
        SelectedLeg = new List<String>();
        SelectedDCEvents = new List<String>();
        SelectedStats = new List<String>();
        SelectedFocusAreas = new List<String>();
        SelectedPolicyRecs = new List<String>();
        
        // get any command line options. Get the 18 char Ids. 15 wont work for this implementation
        retUrl = ApexPages.currentPage().getParameters().get('returl');
        legid = ApexPages.currentPage().getParameters().get('legid');
        if (legid != null) 
            legid = (String) [select id from Legislation__c where id=:(Id)legid].id;
        dcid = ApexPages.currentPage().getParameters().get('dcid');
        if (dcid != null) 
            dcid = (String) [select id from DC_Event__c where id=:(Id)dcid].id; 
        stid = ApexPages.currentPage().getParameters().get('stid'); 
        if (stid != null) 
            stid = (String) [select id from Stat__c where id=:(Id)stid].id;
        faid = ApexPages.currentPage().getParameters().get('faid'); 
        if (faid != null) 
            faid = (String) [select id from Focus_Area__c where id=:(Id)faid].id;
        prid = ApexPages.currentPage().getParameters().get('prid'); 
        if (prid != null) 
            prid = (String) [select id from Policy_Rec__c where id=:(Id)prid].id;
        
        system.debug('TESTING>>> legid: '+ legid);
        system.debug('TESTING>>> faid: '+ faid);
        
    }
    
    public PageReference init() {
        // create the follow up task
        schedfutask = false;
        followuptask = new Task(
            Subject = 'Call Follow Up',
            Type = 'Follow Up',
            OwnerId = UserInfo.getUserId(),
            Status = 'Not Started'
        );
        
        return null;
    }

    // Focus Areas
    List<String> SelectedFocusAreas; 

    public List<String> getSelectedFocusAreas() {
        // set the selected options
        if (faid != null)
            SelectedFocusAreas.add(faid);
            
        if (SelectedPolicyRecs != null) {
            for (String pr : SelectedPolicyRecs) {
                String fa = prToFAMap.get((Id)pr);
                if (!InList(SelectedFocusAreas, fa))
                    SelectedFocusAreas.add(fa);
            }
        }

        system.debug('TESTING>>> getSelectedFocusAreas(): '+ SelectedFocusAreas);        
        return SelectedFocusAreas;
    }
    
    Boolean InList(List<String> lst, String str) {
        
        for (String s : lst)
            if (s!= null && s.equals(str))
                return true;
        
        return false;
        
    }
            
    public void setSelectedFocusAreas(List<String> fas) {
        
        this.SelectedFocusAreas = fas;
        system.debug('TESTING>>> setSelectedFocusAreas(): '+ SelectedFocusAreas);
    }
        
    public List<SelectOption> getFocusAreas() {
        List<SelectOption> options = new List<SelectOption>();      
        
        for (Focus_Area__c fa : [select id, Name from Focus_Area__c ORDER BY Active__c DESC, Name limit 999]) {
            options.add(new SelectOption(fa.id, fa.Name));
        }
        focusAreaSize = (options.size() > MaxListSize) ? MaxListSize : options.size();
        return options;
    }
    
    // Policy Requirements
    List<String> SelectedPolicyRecs; 

    public List<String> getSelectedPolicyRecs() {
        // set the selected options
        if (prid != null)
            SelectedPolicyRecs.add(prid);

        return SelectedPolicyRecs;
    }
            
    public void setSelectedPolicyRecs(List<String> pl) {
        this.SelectedPolicyRecs = pl;
    }
           
    public List<SelectOption> getPolicyRecs() {
        List<SelectOption> options = new List<SelectOption>();
        List<Policy_Rec__c> prlist;
        prToFAMap.clear();
        
        prlist = [select id, Name, Meta_Focus_Area__c, Active__c from Policy_Rec__c order by Active__c desc, Name limit 999];
        
        String policyLabel;
        for (Policy_Rec__c pr : prlist) {
            policyLabel = pr.Name + ' - ' + ((pr.Active__c) ? '(Active)' : '(Not Active)');
            policyLabel = (policyLabel.length() > MaxLabelLength) ? policyLabel.substring(0, MaxLabelLength-3) + '...': policyLabel;
            options.add(new SelectOption(pr.id, policyLabel));
            //options.add(new SelectOption(pr.id, pr.Name + ' - ' + ((pr.Active__c) ? '(Active)' : '(Not Active)')));
            prToFAMap.put(pr.id, pr.Meta_Focus_Area__c);
        }
        policyRecSize = (options.size() > MaxListSize) ? MaxListSize : options.size();
        return options;
    }
    
    // Legislation
    List<String> SelectedLeg; 

    public List<String> getSelectedLeg() {
        // set the selected options
        if (legid != null)
            SelectedLeg.add(legid);
        system.debug('TESTING>>> getSelectedLeg(): '+ SelectedLeg);
        
        return SelectedLeg;
    }
            
    public void setSelectedLeg(List<String> legs) {
        this.SelectedLeg = legs;
    }
        
    public List<SelectOption> getLegislation() {
        List<SelectOption> options = new List<SelectOption>();
        
        // SD - edited 6/2015 to limit to last 2 congressional sessions (first two values in picklist)
        Schema.DescribeFieldResult fieldResult = Legislation__c.Congressional_Session__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        String legQuery = 'select id, Name, Bill_Title__c from Legislation__c';
        legQuery += (ple.size() > 1 ? ' where (Congressional_Session__c = \'' + ple[0].getValue() + '\'' : '');
        legQuery += (ple.size() > 2 ? ' or Congressional_Session__c = \'' + ple[1].getValue() + '\')' : ')');
        legQuery += ' order by Active__c desc, Congressional_Session__c asc, Name asc'; //not sure why it's asc for session but fine
        legQuery += ' limit 999';
        List<Legislation__c> recentLeg = Database.query(legQuery);
        String legLabel;
        //for (Legislation__c l : [select id, Name, Bill_Title__c from Legislation__c order by Active__c desc, Name asc]) {
        for (Legislation__c l : recentLeg) {
            legLabel = l.Name + ' - ' + ((l.Bill_Title__c != null) ? l.Bill_Title__c : '(No Title)');
            legLabel = (legLabel.length() > MaxLabelLength) ? legLabel.substring(0, MaxLabelLength-3) + '...': legLabel;
            options.add(new SelectOption(l.id, legLabel));
            //options.add(new SelectOption(l.id, l.Name + ' - ' + ((l.Bill_Title__c != null) ? l.Bill_Title__c : '(No Title)')));
        }
        system.debug('TESTING>>> getLegislation() options: '+ options);
        legislationSize = (options.size() > MaxListSize) ? MaxListSize : options.size();
        return options;
    }            
    
    // DC Events
    List<String> SelectedDCEvents; 

    public List<String> getSelectedDCEvents() {
        // set the selected options
        if (dcid != null)
            SelectedDCEvents.add(dcid);
            
        return SelectedDCEvents;
    }
            
    public void setSelectedDCEvents(List<String> dces) {
        this.SelectedDCEvents = dces;
        system.debug('TESTING>>> this.SelectedDCEvents: ' + this.SelectedDCEvents);
        system.debug('TESTING>>> SelectedDCEvents: ' + SelectedDCEvents);
    }
        
    public List<SelectOption> getDCEvents() {
        List<SelectOption> options = new List<SelectOption>();
        String datest;
        
        for (DC_Event__c dc : [select id, Name, Date_and_Time__c from DC_Event__c order by Date_and_Time__c desc limit 999]) {
            datest = (dc.Date_and_Time__c !=null) ? dc.Date_and_Time__c.format() : '(No Date)';
            options.add(new SelectOption(dc.id, datest + ' - ' + dc.Name));
        }
        DCEventSize = (options.size() > MaxListSize) ? MaxListSize : options.size();
        return options;
    }      
    
    // Stats
    List<String> SelectedStats; 

    public List<String> getSelectedStats() {
        // set the selected options
        if (stid != null)
            SelectedStats.add(stid);
            
        return SelectedStats;
    }
            
    public void setSelectedStats(List<String> sts) {
        this.SelectedStats = sts;
    }
        
    public List<SelectOption> getStats() {
        List<SelectOption> options = new List<SelectOption>();
        
        for (Stat__c s : [select id, Name from Stat__c limit 999]) {
            options.add(new SelectOption(s.id, s.Name));
        }
        statSize = (options.size() > MaxListSize) ? MaxListSize : options.size();
        return options;
    }  
    
    public PageReference refresh() {
        return null;
    }
    
    public PageReference Save(){
        System.debug('TESTING>>> Lists on Save:');
        System.debug('- SelectedLeg: ' + SelectedLeg);
        System.debug('- SelectedStats: ' + SelectedStats);
        System.debug('- SelectedDCEvents: ' + SelectedDCEvents);
        System.debug('- SelectedFocusAreas: ' + SelectedFocusAreas);
        System.debug('- SelectedPolicyRecs: ' + SelectedPolicyRecs);
        
        if (SelectedLeg.isEmpty() &&
            SelectedStats.isEmpty() &&
            SelectedDCEvents.isEmpty() &&
            SelectedFocusAreas.isEmpty() &&
            SelectedPolicyRecs.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No records are selected. Please select at least one record from the lists below.'));
                return null;
        }
        // insert the new record
        insert trackacall;
        
        //create a task activity
        Task newTask = new Task(
            WhatId = trackacall.id,
            Description = trackacall.Call_Notes__c,
            ActivityDate = trackacall.Date_of_Call__c,
            Status = trackacall.Status__c,
            WhoId = trackacall.Contact__c,
            Subject = trackacall.Name,
            OwnerId = trackacall.Assigned_To__c,
            Really_TAC__c = true,
            Priority = 'Normal'
        );
        insert newTask;
        
        // optionally create follow up task
        if (schedfutask){
            followuptask.WhatId = trackacall.id;
            insert followuptask;
        }
        
        // create the activity junctions
        List<Activity_Junction_to_Legislation__c> leglist = new List<Activity_Junction_to_Legislation__c>();
        for (String lid : SelectedLeg) {
            leglist.add(new Activity_Junction_to_Legislation__c(
                            Legislation__c = (Id)lid,
                            Track_a_Call__c = trackacall.id
                       ));  
        }
        
        List<Activity_Junction_to_Stat__c> statlist = new List<Activity_Junction_to_Stat__c>();
        for (String sid : SelectedStats) {
            statlist.add(new Activity_Junction_to_Stat__c(
                            Stat__c = (Id)sid,
                            Track_a_Call__c = trackacall.id
                       ));  
        }
        
        List<Activity_Junction_to_DC_Event__c> dcelist = new List<Activity_Junction_to_DC_Event__c>();
        for (String dcid : SelectedDCEvents) {
            dcelist.add(new Activity_Junction_to_DC_Event__c(
                            DC_Event__c = (Id)dcid,
                            Track_a_Call__c = trackacall.id
                       ));  
        }
        
        List<Activity_Junction_to_Focus_Area__c> falist = new List<Activity_Junction_to_Focus_Area__c>();
        for (String faid : SelectedFocusAreas) {
            falist.add(new Activity_Junction_to_Focus_Area__c(
                            Focus_Area__c = (Id)faid,
                            Track_a_Call__c = trackacall.id
                       ));  
        }
        
        List<Activity_Junction_to_Policy_Rec__c> prlist = new List<Activity_Junction_to_Policy_Rec__c>();
        for (String prid : SelectedPolicyRecs) {
            prlist.add(new Activity_Junction_to_Policy_Rec__c(
                            Policy_Recommendation__c = (Id)prid,
                            Track_a_Call__c = trackacall.id
                       ));  
        }
        
        // create the junction records
        try {
            insert leglist;
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errtxt + e.getMessage()));
            system.debug(e);
        }
        
        try {
            insert statlist;
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errtxt + e.getMessage()));
            system.debug(e);
        }
                
        try {
            insert dcelist;
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errtxt + e.getMessage()));
            system.debug(e);
        }
        
        try {
            insert falist;
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errtxt + e.getMessage()));
            system.debug(e);
        }
        
        try {
            insert prlist;
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errtxt + e.getMessage()));
            system.debug(e);
        }
        // if errors return to page
        if (ApexPages.hasMessages())
            return null;
        
        PageReference pr = getNavURL();
        pr.setRedirect(true);
        
        return pr;
    }
    
    public PageReference Cancel(){
        
        PageReference pr = getNavURL();
        pr.setRedirect(true);
        
        return pr;
        
    }
    
    public PageReference getNavURL() {
        
        return new PageReference(((retUrl!=null) ? retUrl : 
                                                    ((legid!=null) ? '/'+legid : 
                                                        ((dcid!=null)? '/'+dcid : 
                                                            ((stid!=null) ? '/'+stid : 
                                                                ((faid!=null) ? '/'+faid : '/home/home.jsp'))))));
    }
    
    
    /**************************************************************************
     * 
     * TESTS
     *
     **************************************************************************/
    
    public static testMethod void testActivityJunctionControllerOne() {
        ApexPages.StandardController sc = new ApexPages.StandardController(new Activity_Junction__c());
        ActivityJunctionController ajc = new ActivityJunctionController(sc);
        PageReference pageRef = Page.TrackACall; 
        Test.setCurrentPageReference(pageRef);
        ajc.init();
        ajc.Save();
    }
    
    public static testMethod void testActivityJunctionControllerTwo() {
        
        integer num = 10;
        String tag = 'testtagg';
        
        // create the test data
        Contact con = new Contact(
            FirstName = 'fname',
            LastName = 'lname',
            AccountId = [select id from Account limit 1].id
        );
        insert con;
        User auser = [select id from User where IsActive=true limit 1];
        
        List<Legislation__c> leglist = new List<Legislation__c>();
        List<DC_Event__c> dcelist = new List<DC_Event__c>();
        List<Stat__c> statlist = new List<Stat__c>();
        List<Focus_Area__c> falist = new List<Focus_Area__c>();
        List<Policy_Rec__c> prlist = new List<Policy_Rec__c>();

        // SD - edited 6/2015 to limit to last 2 congressional sessions (first two values in picklist)
        Schema.DescribeFieldResult fieldResult = Legislation__c.Congressional_Session__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        String currentSession = ple.size() > 1 ? ple[0].getValue() : null;
        String prevSession = ple.size() > 2 ? ple[1].getValue() : null;
        String prevprevSession = ple.size() > 3 ? ple[2].getValue() : null;
        List<String> sessions = new List<String>();

        for (integer i=0; i<num; i++) {
            String session = i == num-1 ? prevprevSession : (Math.mod(i,2) == 0 ? currentSession : prevSession);
            leglist.add(new Legislation__c(Bill_Number__c=decimal.valueOf(i), Bill_Title__c =tag + i.format(), Congressional_Session__c = session));
            dcelist.add(new DC_Event__c(Name=tag + i.format()));
            statlist.add(new Stat__c(Name=tag + i.format()));
            falist.add(new Focus_Area__c(Name=tag + i.format()));
        }
        
        insert leglist;
        insert dcelist;
        insert statlist;
        insert falist;
        
        for (Focus_Area__c fa : falist) 
            for (integer i=0; i<num/2; i++)
                prlist.add(new Policy_Rec__c(Name = tag + i.format(), Meta_Focus_Area__c = fa.id));
        
        insert prlist;
         
        // verify correct record creation
        prlist = [select id, name, Meta_Focus_Area__c from Policy_Rec__c where Meta_Focus_Area__c in:falist];
        system.assertEquals((num / 2) * num, prlist.size());
        falist = [select id, name from Focus_Area__c where id in:falist];
        system.assertEquals(num, falist.size());
        dcelist = [select id, name from DC_Event__c where id in:dcelist];
        system.assertEquals(num, dcelist.size());
        statlist = [select id, name from Stat__c where id in:statlist];
        system.assertEquals(num, statlist.size());
        leglist = [select id, name from Legislation__c where id in:leglist];
        system.assertEquals(num, leglist.size());
        
        Test.startTest();
        // create the controller
        PageReference pageRef = Page.TrackACall; 
        Test.setCurrentPageReference(pageRef);
        ApexPages.currentPage().getParameters().put('legid', leglist[0].id);
        ApexPages.StandardController sc = new ApexPages.StandardController(new Activity_Junction__c());
        ActivityJunctionController ajc = new ActivityJunctionController(sc);
        ajc.init();
        
        // Set the values in the list boxes
        List<String> options = new List<String>();
        for (SelectOption so : ajc.getDCEvents()) {
            if (so.getLabel().contains(tag)) {
                system.debug('TESTING>>> so: '+ so);
                options.add(so.getValue());
            }
        }
        system.debug('TESTING>>> dce options: '+ options);
        system.assertEquals(num, options.size());
        ajc.setSelectedDCEvents(options);
        system.debug('TESTING>>> ajc.getSelectedDCEvents(): '+ ajc.getSelectedDCEvents());
        system.debug('TESTING>>> ajc.SelectedDCEvents: ' + ajc.SelectedDCEvents);
        options = new List<String>();
        
        for (SelectOption so : ajc.getLegislation())
            if (so.getLabel().contains(tag))
                options.add(so.getValue());
        system.debug('TESTING>>> leg options: '+ options);
        system.assertEquals(num - 1, options.size()); // the last leg should be from a congressional session that gets screened out
        ajc.setSelectedLeg(options);
        options = new List<String>();
        
        for (SelectOption so : ajc.getFocusAreas())
            if (so.getLabel().contains(tag))
                options.add(so.getValue());
        system.debug('TESTING>>> fa options: '+ options);
        system.assertEquals(num, options.size());
        ajc.setSelectedFocusAreas(options);
        options = new List<String>();
        
        for (SelectOption so : ajc.getStats())
            if (so.getLabel().contains(tag))
                options.add(so.getValue());
        system.debug('TESTING>>> stat options: '+ options);
        system.assertEquals(num, options.size());
        ajc.setSelectedStats(options);
        options = new List<String>();
        
        for (SelectOption so : ajc.getPolicyRecs())
            if (so.getLabel().contains(tag))
                options.add(so.getValue());
        system.debug('TESTING>>> pr options: '+ options);
        system.assertEquals((num/2)* num, options.size());
        ajc.setSelectedPolicyRecs(options);
        system.debug('TESTING>>> before save ajc.SelectedPoicyRecs: ' + ajc.SelectedPolicyRecs);
        
        ajc.schedfutask = true; // set create follow up task
        ajc.followuptask.Status = 'hi there';
        ajc.trackacall.Assigned_To__c = auser.id;
        ajc.trackacall.Contact__c = con.id;
        ajc.trackacall.Status__c = 'big time';
        
        ajc.Save();
        
        Test.stopTest();
        
        // verify the tasks were created
        List<Task> tasklist = [select id, Status, Really_TAC__c from Task where WhatId=:ajc.trackacall.id];
        system.assertEquals(2, tasklist.size());    // one followup task + one shadow activity pointing to TAC for reporting purposes
        for (Task t : tasklist) {
            if (t.Really_TAC__c)
                system.assertEquals('big time', t.Status);    // shadow activity
            else
                system.assertEquals('hi there', t.Status);    // followup task
        }

        // verify all the junction objects were created
        Activity_Junction__c aj;
        List<Activity_Junction__c> ajlist = [select id, Name, Date_of_Call__c, Status__c, Call_Notes__c, Assigned_To__c, Contact__c from Activity_Junction__c where id=:ajc.trackacall.id];
        system.assertEquals(1, ajlist.size());
        aj = ajlist[0];
        system.assertEquals('big time', aj.Status__c);
        system.assertEquals(con.id, aj.Contact__c);
        system.assertEquals(auser.id, aj.Assigned_To__c);
        
        system.debug('TESTING>>> after save prlist: ' + prlist);
        List<Activity_Junction_to_Policy_Rec__c> ajprlist = [select id from Activity_Junction_to_Policy_Rec__c where Policy_Recommendation__c in:prlist and Track_a_Call__c=:aj.id];
        
        List<Activity_Junction_to_Focus_Area__c> ajfalist = [select id from Activity_Junction_to_Focus_Area__c where Focus_Area__c in:falist and Track_a_Call__c=:aj.id];
        system.assertEquals(num, ajfalist.size());
        
        List<Activity_Junction_to_Legislation__c> ajleglist = [select id from Activity_Junction_to_Legislation__c where Legislation__c in:leglist and Track_a_Call__c=:aj.id];
        system.assertEquals(num-1, ajleglist.size());
        
        List<Activity_Junction_to_Stat__c> ajstatlist = [select id from Activity_Junction_to_Stat__c where Stat__c in:statlist and Track_a_Call__c=:aj.id];
        system.assertEquals(num, ajstatlist.size());
        
        List<Activity_Junction_to_DC_Event__c> ajdcelist = [select id from Activity_Junction_to_DC_Event__c where DC_Event__c in:dcelist and Track_a_Call__c=:aj.id];
        system.assertEquals(num, ajdcelist.size());
        
        
        
    }
    
}