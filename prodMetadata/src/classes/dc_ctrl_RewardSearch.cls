// Distribution Center - Controller Class for Searching Rewards
// Created By - Puneet Aggarwal - 5/14/2010
// Modified Versions

//-----------------------------------------------------------------------------------------------------
public with sharing class dc_ctrl_RewardSearch {

    /******************************  Properties *********************************************/
    private static final String CONFIRMED_VET = 'Paperwork Accepted';
    
    
    /******************************  Accessor Methods  *********************************************/
    
    
    
    /******************************  Constructors  *********************************************/
    public dc_ctrl_RewardSearch(){
        Map<String, Rucksack_Mobile_Services__c> settings = Rucksack_Mobile_Services__c.getAll();
        if (settings != null) {
            defaultDistance = '100';
            try {defaultDistance = settings.get('Default Search Radius').Value__c;} catch (Exception e) {}
        }
        else
            defaultDistance = '100';
        searchVal(); 
    }
    
    
    /******************************  Action Methods  *********************************************/
    
    
    
    /******************************  Helper/Utility Methods  *********************************************/
    
    
    // Declare Variables
    public String Zip_Value;                                //Zip entered by user
    public String Category_value;                           //Category entered by user
    public String Distance_value;                           //Distance entered by user
    public String Membership_Number = 'Membership Number';  //Membership Number entered by user
    public String Email = 'Email';                          //Email entered by user
    public boolean validated;                               //boolean flag to check if user has been validated
    public String Member_Name;                              //Member name retreived
    public boolean BasicSearchResult ;
    public boolean RequestReward ;
    public boolean RewardMultipleDateTime ;
    public boolean FAQ  {get; set;}
    public string emailtoreg = 'Email';
    public boolean oif ;
    public boolean oef ;
    public boolean ond ;
    public string multigive {get; set;}
    public id giveid {get; set;}
    public string defaultlogo  {get; set;}
    public string noresults_msg  {get; set;}
    public string start_date;
    public string end_date  {get; set;}
    public string Email_Member  {get; set;}
    public boolean Email_MemberConf  {get; set;}
    public string validate = ' ';
    public string contactid = ' ';
    public string pName = ' ';
    public boolean oldiever ;
    public boolean userinput ;
    public string oif_val;
    public string oef_val;
    public string ond_val;
    public String defaultDistance {get; set;}
    
	public String UserId {
        get { return UserInfo.getUserId(); }
	}
    
    public boolean getdc_homepage() 
    {
        return StaticVar.dc_homepage;   
    }
    public boolean getdc_rewardsearch() 
    {
        return StaticVar.dc_rewardsearch;   
    }
    public boolean getdc_rewarddetail() 
    {
        return StaticVar.dc_rewarddetail;   
    }
    public boolean getdc_claimreward() 
    {
        return StaticVar.dc_claimreward;    
    }
    public boolean getdc_partner() 
    {
        return StaticVar.dc_partner;    
    }

    public boolean getdc_faq() 
    {
        return StaticVar.dc_faq;    
    }

    public boolean getListPartners() 
    {
        return StaticVar.ListPartners;  
    }
    
    public boolean getoldiever() 
    {
        system.debug('oldiever' + oldiever);
        return StaticVar.oldiever;  
    }
    
    public boolean getRewardDetails() 
    {
        return StaticVar.RewardDetails; 
    }

    public void setoef (boolean s) 
    {
        oef = s;
    }
    public boolean getoef() 
    {
        return oef; 
    }
    
    public void setoif (boolean s) 
    {
        oif = s;
    }
    public boolean getoif() 
    {
        return oif; 
    }
    
    public void setond (boolean s) 
    {
        ond = s;
    }
    public boolean getond() 
    {
        return ond; 
    }
    
    public void setemailtoreg (String s) 
    {
        emailtoreg = s;
    }
    public String getemailtoreg() 
    {
        return emailtoreg;  
    }
    
    public void setoif_val (String s) 
    {
        oif_val = s;
    }
    public String getoif_val() 
    {
        return oif_val; 
    }
    
    public void setoef_val (String s) 
    {
        oef_val = s;
    }
    public String getoef_val() 
    {
        return oef_val; 
    }
    
    public void setond_val (String s) 
    {
        ond_val = s;
    }
    public String getond_val() 
    {
        return ond_val; 
    }
    

    public void setstart_date (String s) 
    {
        start_date = s;
    }
    public String getstart_date() 
    {
        return start_date;  
    }

    public void setpName (String s) 
    {
        pName = s;
    }
    public String getpName() 
    {
        return pName;   
    }

    public void setvalidate (String s) 
    {
        validate = s;
    }
    public String getvalidate() 
    {
        return validate;    
    }

    public void setcontactid (String s) 
    {
        contactid = s;
    }
    public String getcontactid() 
    {
        return contactid;   
    }

    // Get Set for Zip

    public boolean getBasicSearchResult() 
    {
        return BasicSearchResult;   
    }
    
        public boolean getRequestReward() 
    {
        return StaticVar.ClaimReward;   
    }
    
        public boolean getRewardMultipleDateTime() 
    {
        return RewardMultipleDateTime;  
    }

    public void setZip_Value (String s) 
    {
        Zip_Value = s;
    }
    public String getZip_Value() 
    {
        return Zip_Value;   
    }
    
    // Get Set for Category
    
    public string getCategory_value()
    {
        return Category_value;
    }
    public void setCategory_value(string s)
    {
        Category_value = s;
    }
    
    // Get Set for Distance
    
    public string getDistance_value()
    {
        return Distance_value;
    }
    public void setDistance_value(string s)
    {
        Distance_value = s;
    }

    public string getMembership_Number()
    {
        return Membership_Number;
    }
    public void setMembership_Number(string s)
    {
        Membership_Number = s;
    } 

    public string getEmail()
    {
        return Email;
    }
    public void setEmail(string s)
    {
        Email = s;
    } 

    public string getMember_Name()
    {
        return Member_Name;
    }
    public void setMember_Name(string s)
    {
        Member_Name = s;
    } 
    
    public String IAVAHost {
    	get {
    		IAVAPlus_Portal_Settings__c ps = IAVAPlus_Portal_Settings__c.getInstance('IAVA');
    		return (ps == null ? '' : ps.Secure_Site_URL__c);
    	}
    }

    /** Temporary instance of Give to use input date fields in search criteria for Date from and Date to **/
    public Give_Instance__c tempgiveinst{
        get{
            if (tempgiveinst == null) tempgiveinst = new Give_Instance__c();
            return tempgiveinst;
        }
        set; 
    } 

    /** Creating picklist for Category **/
    public List<SelectOption> getCategory()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult =
                    Give__c.Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        options.add(new SelectOption('All', 'All'));
        for( Schema.PicklistEntry f : ple)
        {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return options;    
    }
  
    /** Creating picklist for Distance from Custom Settings **/
    public List<SelectOption> getDistance()
    {
        List<SelectOption> options = new List<SelectOption>();    
        // Must sort the list, start by retrieving the unsorted list
        List<dc_searchdistance__c> unsortedList;
        try{
            unsortedList = dc_searchdistance__c.getAll().values();       
        } catch (System.Nullpointerexception npe){
            unsortedList = null;
        }   
        
        if(unsortedList!=null){
            // Build a Map using the Number of Miles as key and the setting record as value 
            Map <Double,dc_searchdistance__c> distMap = new Map<Double,dc_searchdistance__c>();
            for(dc_searchdistance__c dist : unsortedList){ distMap.put(dist.number_of_miles__c,dist); }
            // Build a sorted list based on the map keys
            List<Double> sortOrder = new List<Double>(distMap.keySet());        
            sortOrder.sort();
            for (Double d : sortOrder){
                options.add(new SelectOption(distMap.get(d).Distance__c,distMap.get(d).Distance__c));
            }
        }
        
        return options;       
       
    }
    
    /** Method will be called in Result page to retreive the results **/
    public list<dc_CustomGive> getGiveList()
    {   
        if(customgivelist!= null)
            return customgivelist ;
        else return null;
    } 
    
    /** Declaring custom list of wrapper class **/
    public List<dc_CustomGive> customgivelist = new List<dc_CustomGive>(); 
  
    /** -----------------------Method called when search button is clicked --------------------------------**/
    public Pagereference searchval () 
    {
        System.Debug('NGKJ +---------------------------+');
        System.Debug('NGKJ + Executing searchval() ... +');
        System.Debug('NGKJ +---------------------------+');
        try
        {    
            String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
            system.debug('userAgent::::::::::::::::::::::' + userAgent);
            /** Variables (used to highlight appropriate values in IN THIS SECTION sidebar) are being set to false when user clicks on Search**/
                //  pageReference cView = new ApexPages.StandardController(cView).view();
                //  string fullURL = BaseURL + cView.getUrl();
            //system.debug('fullURL::::::::::::::::::::::' + fullURL);
            system.debug('testing::::end:::::::::::::::::::::::' + apexpages.currentpage().getparameters().get('ed'));
            system.debug('testing::::start:::::::::::::::::::::::' + apexpages.currentpage().getparameters().get('Sd'));
            noresults_msg = '';
            FAQ = false;
            StaticVar.ListPartners = false;
            StaticVar.RewardDetails = false;   
            StaticVar.ClaimReward = false;
            //oldiever = StaticVar.oldiever;
            //system.debug('oldiever in search' + ApexPages.currentPage());
            /** Two variables below are being set accordingly because they are used to render apprpriate page.
                Since user has clicked search, basic search result page needs to come up **/
            BasicSearchResult = true;
            RequestReward = false;

            /** Converting the Start Date and End Date in strings to be used in Search query **/
            string sd; //start date
            string ed; // end date
            double latitude = 0;        // NGKJ - initialize
            double longitude = 0;       // NGKJ - initialize
            string state = null;        // NGKJ - initialize
            string slat = null;         // NGKJ - aviod exception
            string slon = null;         // NGKJ - avoid exception
            slat = apexpages.currentpage().getparameters().get('lat');  // NGKJ - do this first
            slon = apexpages.currentpage().getparameters().get('lon');  // NGKJ - do this first
            if ((slat != null) && (slat.length() > 0))  // NGKJ - now check !!!
                latitude = double.valueof(slat);
            if ((slon != null) && (slon.length() > 0))  // NGKJ - now check !!!
                longitude = double.valueof(slon);
            state = apexpages.currentpage().getparameters().get('state');
            sd = apexpages.currentpage().getparameters().get('sd');
            ed = apexpages.currentpage().getparameters().get('ed');
            if(zip_value == null || zip_value == '')
                zip_value = apexpages.currentpage().getparameters().get('zip');
            category_value = apexpages.currentpage().getparameters().get('cat');
            if(Distance_value == null || Distance_value == '')
                Distance_value = apexpages.currentpage().getparameters().get('dist');
            system.debug('sde**************************************' + sd);
            system.debug('ed**before**************************************' + ed);
            system.debug('zip_value**************************************' + zip_value);
            system.debug('category_value**************************************' + category_value);
            system.debug('Distance_value**************************************' + Distance_value);
            system.debug('userinput**************************************' + userinput);
            double distance;
            if(Distance_value != null)
                distance = double.valueof(Distance_value.split(' ')[0]);
                
            system.debug('latitude**************************************' + latitude);
            system.debug('longitude**************************************' + longitude);
            system.debug('state**************************************' + state);
            system.debug('distance**************************************' + distance);
            if(sd != null && sd.trim() != '')
            {
                try
                {
                    system.debug('sd**before**************************************' + sd);
                    date smydate = date.parse(sd);
                    sd = string.valueof(smydate);
                    system.debug('smydate****************************************' + smydate);
                    system.debug('sd****************************************' + sd);
                }
                catch(exception e)
                {
                    sd = '';
                }
            }
            if(ed != null && ed.trim() != '')
            {
                try
                {
                    system.debug('ed**before**************************************' + ed);
                    date emydate = date.parse(ed);
                    ed = string.valueof(emydate);
                    system.debug('emydate****************************************' + emydate);
                    system.debug('ed****************************************' + ed);
                }
                catch(exception e)
                {
                    ed = '';
                }
            }
            /**if(tempgiveinst.Start_Date__c != null)
                sd = string.valueof(tempgiveinst.Start_Date__c).split(' ')[0];
            else if (start_date != 'YYYY-MM-DD' && start_date != null && start_date.trim() != '')
                sd = start_date;
            if(tempgiveinst.End_Date__c != null)
                ed = string.valueof(tempgiveinst.End_Date__c).split(' ')[0];
            else if (end_date != 'YYYY-MM-DD' && end_date != null && end_date.trim() != '')
                ed = end_date;**/
                
                system.debug('sd:::::::::::::::::::::::::::::::::::::' + sd);
                system.debug('ed:::::::::::::::::::::::::::::::::::::' + ed);
                system.debug('zip_value:::::::::::::::::::::::::::::::' + zip_value);
        
            /** Declaration of variables used to fetch the values from radius search **/
            Set<string> setstate = new set<string>();   //Set will have only single element and stores the state of the zip code for which search was executed
            //string state; // string will take the value of state from set above
            List<string> ListSetGeoLocId = new List<string>();  // List will have only single element and stores the Relevant Ids of Geo Location in a List of string
            string SetGeoLocId; // string will store relevant Ids from Geo Location
            Map<String, string> MapStateGeoId = new Map<String, string>(); //Map is returned from class where radius search is performed
            
            /** ---------------Radius search is performed only when zip has a value------------- **/
            if(latitude != 0 && longitude != 0 && distance_value != 'Any')
            {
                /** if distance searched for is null, assign value of default distance **/
                if(Distance_value == null)
                    distance = double.valueof(defaultDistance);
            
                /** Seperate Class is called where Radius search is performed and Map is returned with key as state and 
                    value as string of all relevant ids of Geo Location. Map will have only single value. **/
                MapStateGeoId = dc_GetLatitudeLongitudeForRadiusSearch.dc_GetLatitudeLongitudeForRadiusSearch(longitude, latitude, state, distance);
            
                /** if nothing was returned from the class, and distance searched for was not default distance, then
                    search again with distance as default distance **/
                if((Distance_value != defaultDistance+' Miles') && (MapStateGeoId == null || MapStateGeoId.isEmpty() || (MapStateGeoId != null && MapStateGeoId.containsKey('XX'))))
                {
                    distance = double.valueof(defaultDistance);
                    system.debug('going again for zipcode search');
                    MapStateGeoId = dc_GetLatitudeLongitudeForRadiusSearch.dc_GetLatitudeLongitudeForRadiusSearch(longitude, latitude, state, distance);
                }
            
                /** Fetch value of state in string state, and Geo Location Ids in string SetGeoLocId **/
                if(MapStateGeoId != null && !MapStateGeoId.isEmpty())
                    ListSetGeoLocId = MapStateGeoId.values();
                if(!ListSetGeoLocId.isempty())
                {
                    SetGeoLocId = ListSetGeoLocId[0];
                /** setstate = MapStateGeoId.keyset();
                    for(string st: setstate)
                        state = st;**/
                }   
            }
            /**----------------Radius Search Ends--------------------------------**/
            
            /**----- Method called for search and custom list is created for the result list -------**/
            List<Give__c> givelist = new list<Give__c>();
            Set<Id> giveid = new set<Id>(); //Deprecate variable
            
            /** Method within same class called where query is created and executed **/ 
            givelist = searchlogic(category_value, state, SetGeoLocId, sd, ed, zip_value);
            
            customgivelist.clear(); // Clear result
            if(!givelist.isEmpty())
            {                   
                List<string> dc_cg = new list<string>();
                dc_cg.clear();
                /** Looping through all the Gives that came as a result **/
                for(integer loopcase=0; loopcase<givelist.size(); loopcase++)
                {
                    /** Seperate Wrapper Class dc_CustomGive **/
                    dc_CustomGive dc = new dc_CustomGive();
                    
                    /** dc_createlist is a method in the above mentioned class where result list is created in
                        the desired format **/
                    dc_cg = dc.dc_createlist(givelist[loopcase]);
                    
                    if(dc_cg.size() > 11 )
                    {
                        customgivelist.add(new dc_customgive(
                        givelist[loopcase].id, dc_cg[0],dc_cg[1],dc_cg[2],dc_cg[3],dc_cg[4],dc_cg[5],dc_cg[6],dc_cg[7],dc_cg[8],dc_cg[9],dc_cg[10],dc_cg[11],dc_cg[12],dc_cg[13],dc_cg[14],dc_cg[15],dc_cg[16],dc_cg[17]
                        ));
                    }
                }// end of for loop
            }// end of givelist.isEmpty
                PageReference pageRef = Page.dc_RewardList;
            return Page.dc_RewardList; // RewardList page is returned with the search results
        
        }// end of try
        
        catch(exception e)
        { 
            noresults_msg = System.Label.dc_noresult_mesg_display;
            return Page.dc_RewardList;
        }   
    }//end of method searchval
    /**-----------------------------Method called when search button is clicked ENDS ---------------------**/
       /** When a user is validated on the popup, user is then navigated to Request Reward page **/
    public void validateinfo () 
    {
        try
        {
            validate = 'false';
            contactid = ' ';
            /** Query on Contact to validate the user **/
            List<Contact> listcont = new list<Contact>();
            listcont = [select id, Name, npe01__HomeEmail__c, Membership_ID__c,Paperwork_Confirmation__c from contact where
            (Email = :Email or npe01__HomeEmail__c = :Email or npe01__WorkEmail__c = :Email 
            or npe01__AlternateEmail__c = :Email ) and Membership_Id__c =: Membership_Number and Veteran_Member__c = true and 
            Paperwork_Confirmation__c = :CONFIRMED_VET limit 1];
            
            /** Navigate user to Request Reward Page once the user is validated **/
            if(listcont.size() > 0 && Email.trim() != '' && Membership_Number.trim() != '')
            {
                /** Setting the variables so that appropriate page is rendered, and Item in IN THIS SECTION is highlighted **/
                BasicSearchResult =false;
                RequestReward = true;
                StaticVar.RewardDetails = false;
                validate = 'true';  
                contactid = listcont[0].id; 
            }

        } // end of try
        catch(exception e)
        {
            System.debug(e);
            ApexPages.addMessages(e);
            return;     
        }
    }// end of method validateinfo
  
    
    /** --------------------Method below is being used to create and execute the query for SEARCH------------ **/
    public List<Give__c> searchlogic(string category_value, string state, string SetGeoLocId, string sd, string ed, string zip_value)
    {
        try
        {
            System.Debug('NGKJ +-----------------------------+');
            System.Debug('NGKJ + Executing searchlogic() ... +');
            System.Debug('NGKJ +-----------------------------+');
            System.Debug('NGKJ + category_value: ' + category_value);
            System.Debug('NGKJ +          state: ' + state);
            System.Debug('NGKJ +    SetGeoLocId: ' + SetGeoLocId);
            System.Debug('NGKJ +             sd: ' + sd);
            System.Debug('NGKJ +             ed: ' + ed);
            System.Debug('NGKJ +      zip_value: ' + zip_value);
            System.Debug('NGKJ +-----------------------------+');
            List<Give_Instance__c> searchlist = new list<Give_Instance__c>(); // query result will be stored in searchlist
            string qrystring;   // qrystring is created
            qryString = 'SELECT Id, Give__c FROM Give_Instance__c WHERE ';
            
            /** If Category is not selected, or 'All' is selected, then modify query to include all categories **/
            if(Category_value == null || Category_value == 'All')
            {
                Schema.DescribeFieldResult fieldResult =
                    Give__c.Category__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
                integer counter = 0;
                qryString = qryString + ' ( ';
                for( Schema.PicklistEntry f : ple)
                {
                    if(Counter != 0)
                    {
                        qrystring = qrystring + ' or ';
                    }
                    qryString = qryString + 'Give__r.Category__c = ' + '\'' + f.getValue() + '\'';
                    Counter = 1;
                }       
                    qryString = qryString + ' ) ';
            }
            else
            {
                qryString = qryString + ' Give__r.Category__c = ' + '\'' + category_value + '\'' ;
            }
            /** Query formation for Category  ends **/
            
            /** Query formation for start date and end date **/         
            if(ed != null && ed != '')
                qryString = qryString + ' and ( start_date__c <=  '  + ed  + '  ) ';
            if(sd != null && sd != '')
                qryString = qryString + ' and (( start_date__c >= '  + sd +   '  ) OR ( end_date__c >= '  + sd +   '  ) ) ';
//                fixed date query logic by replacing line below with line above - SD 10/22/12
//                qryString = qryString + ' and (( end_date__c >= '  + sd +   '  ) OR ( end_date__c = null ) ) ';
            /** date criteria ends **/
        
            /** Variables being used to create query **/
            boolean setgeo = false; // to check if Geo Location Ids were present and criteria is included in query or not
            string qrystring_open; // formulate the query for Open and Waitlisted Gives. If it does not bring any result, search for closed gives as well.
            string qrystring_close; // a string of query which will have the criteria of Closed Visible gives.
            string qrystring_2 = ' '; // part of the query to be added to the final query string later
            string geo ;    // part of query which has Geo Location Ids as a criteria
            string strstate; //part of query to include state as a criteria
            // NGKJ - test replacement ...
            // string status =  ' and ( Give__r.status__c =  ' + '\'' + 'Open' + '\'' + ' or Give__r.status__c = ' + '\'' + 'Waitlist' + '\'' + ')';
            string status =  ' and ( Give__r.status__c !=  ' + '\'' + 'Planned' + '\'' + ' and Give__r.status__c != ' + '\'' + 'Closed Invisible' + '\'' + ')';
            // NGKJ - end test replacement ...
            string national = '  Give__r.National_Give__c = true';
            string notnational = ' and Give__r.National_Give__c != true';
            string qry_close;
            
            /** Query formation for the Geo Location (radius) criteria **/
            if(SetGeoLocId != null && SetGeoLocId != '' && SetGeoLocId != 'null')
            {
                system.debug('SetGeoLocId,,,,,,,,,,,,,,' + SetGeoLocId);
                system.debug('state,,,,,,,,,,,,,,' + state);
                geo = 'Give__r.Geo_Location__c in '  + SetGeoLocId; 
                // NGKJ - test replacement ...
                // qrystring_open = qryString +  ' and ' + geo + ' and ( Give__r.status__c =  ' + '\'' + 'Open' + '\'' + ' or Give__r.status__c = ' + '\'' + 'Waitlist' + '\'' + ')';
                qrystring_open = qryString +  ' and ' + geo + ' and ( Give__r.status__c !=  ' + '\'' + 'Planned' + '\'' + ' and Give__r.status__c != ' + '\'' + 'Closed Invisible' + '\'' + ')';
                // NGKJ - end test replacement ...
                system.debug('qrystring_open::::::::' + qrystring_open);
                qrystring_close = 'and (( ' + geo + ' and Give__r.status__c = ' + '\'' + 'Closed Visible' + '\'' + ')';
                qry_close = 'and ( ' + geo + ' and Give__r.status__c = ' + '\'' + 'Closed Visible' + '\'' + ')';
                system.debug('qrystring_close::::::::' + qrystring_close);
                setgeo = true;
            }
        
            boolean setstate = false;//to check if state was retreived and is being used in the query or not
            
            /** Query formation for the state criteria **/
            if(state != null && state != '' && state != 'null')
            {
                system.debug('inside state');
                if(setgeo == false)
                    qryString_2 = ' and ((';
                strstate = ' Give__r.Location_by_State_s__c includes ' + '(\'' + state + '\')' ;
                qrystring_2 = qryString_2 + state;
                qryString_2 = qryString_2 + ' or ';
                setstate = true;
            }
            
            string qry1; //final query which will include closed gives
            string qryString_3; //part of query
            string qzip;
            
            /** include the criteria of substring of '3' for zip code if radius search does not bring any results **/
            if (zip_value != null && zip_value.length() >= 3 && geo == null)
            {
                if(setstate == true || setgeo == true)
                    qrystring_2 = qryString_2 + ' Give__r.Zip_Code_s__c Like ' + '\'' + zip_value.substring(0,3) +  '%' + '\'' + ' or Give__r.National_Give__c = true ) ';
                else qryString_2 = qryString_2 + ' and (( ' + ' Give__r.Zip_Code_s__c Like ' + '\'' + zip_value.substring(0,3) +  '%' + '\'' + ' or Give__r.National_Give__c = true ) ';            
                qzip = '  Give__r.Zip_Code_s__c Like ' + '\'' + zip_value.substring(0,3) +  '%' + '\'' ;
            }
            else
            {
                if(setstate == true || setgeo == true)
                    qrystring_2 = qryString_2 + '  Give__r.National_Give__c = true ) ';
                else qryString_2 = qryString_2 + ' and (( Give__r.National_Give__c = true ) ';
            }
            
            /** include criteria of open and waitlisted gives **/
            // NGKJ - test replacement ...
            // qrystring_2 = qryString_2 + ' and ( Give__r.status__c = ' + + '\'' + 'Open' + '\'' + ' or Give__r.status__c = ' + '\'' + 'Waitlist' + '\'' + '))';
            qrystring_2 = qryString_2 + ' and ( Give__r.status__c != ' + + '\'' + 'Planned' + '\'' + ' and Give__r.status__c != ' + '\'' + 'Closed Invisible' + '\'' + '))';
            // NGKJ - end test replacement ...
            if(geo != null)
                qry1 = qrystring + qryString_close + ' or (  ( ' + qryString_2 + ' ) ';
            
            /** include application deadline criteria **/
            string tod = string.valueof(date.today()).split(' ')[0];
            qryString_3 = ' and ( Give__r.Latest_Application_Deadline__c = null or Give__r.Latest_Application_Deadline__c >= ' +  tod + ') ';
            qrystring_2 = qryString_2 + qryString_3;

            string qry2;// final query which will not have closed gives as a criteria
        
            /** 3 query strings are created below
                1. qryString_open - To find if open gives are present in the zip code area searched for
                2. qry1 - To look for closed gives if nothing comes up as open give in radius search
                3. qry2 - To look for open gives in case some results come up as open give in radius search **/
            if(geo != null)
                qry1 = qry1 + qryString_3;
            if(geo != null)
                qry2 = qryString + 'and ((' + geo + ' or ' + qryString_2;
            else if(geo == null)
                qry2 = qryString + qryString_2;
        
            string qrystate;
            string qrynat;
            string qryclose;
            string qryzip;
            string qrystatus;
            if(qzip != null)
                qryzip = qrystring + ' and ' + qzip + status;
            if(strState != null)
                qrystate = qrystring + ' and ' + strstate + status;
            // NGKJ - test replacement
            // qrynat = qrystring + ' and ' + national + status;
            // qrynat = qrystring + status;
            // NGKJ - test replacement
            
            // SD test replacement
            // If it's a zip or state search, limit the national query
            // to just national Gives, which get tacked on at end of zip results.
            // Otherwise expand national search to include all Gives, e.g. for Find Rewards link.
            if(qzip != null || strState != null)
            {
                qrynat = qrystring + ' and ' + national + status;
            }
            else
            {
                qrynat = qrystring + status;
            }
            // SD end test replacement

            qryclose = qrystring + qry_close;
            qrystatus = qryString + status + notnational;
            system.debug('qrystatus*********************************' + qrystatus);
            system.debug('qrystring_open*********************************' + qrystring_open);
            system.debug('qryclose*********************************' + qryclose);
            system.debug('qryzip*********************************' + qryzip);
            system.debug('qrystate*********************************' + qryState);
            system.debug('qrynat*********************************' + qrynat);
            
            boolean close = false; // being used to see if closed give query was executed or not

            List<Give__c> glist = new List<Give__c>();
            try
            {
                searchlist.clear();
                glist.clear();
                if(geo != null && qryString_open != null)
                {
                    system.debug('qryString_open ********************************' + qryString_open);
                    searchlist = Database.query(qryString_open) ;
                    if(searchlist.size() > 0)
                    {
                        List<Id> giveid_open = new List<Id>();
                        for(integer x=0;x<searchlist.size();x++)
                        {
                            giveid_open.add(searchlist[x].give__c);
                        }
                        List<Give__c> glist_open = new List<Give__c>();
                        glist_open = [select id, Category__c, status__c,available__c, Deadline__c,type__c, name,Number_Remaining__c,City__c, Location_Formula__c,Location_by_State_s__c,Zip_Code_s__c,
                                description__c,Partnership_Request__c,Latest_Application_Deadline__c,Must_be_21__c,
                                location_description__c,Partnership_Request__r.Public_Partner_Name__c,Maximum_Units_per_Member__c,(select id, start_date__c, start_time__c, 
                                end_date__c, end_time__c, date_to__c, year_start_date__c,year_end_date__c,date_from__c from Give_Instances__r order by start_date__c asc),(select id From Attachments where Name like '%logo%' limit 1) from Give__c 
                                where id in: giveid_open
                                ] ;
                        if(glist_open.size() > 0)
                        {
                            glist.addall(glist_open);
                        searchlist.clear();
                        system.debug('glist_open.size()**********************' + glist_open.size());
                        }
                        else if(qryclose != null)
                        {
                            system.debug('qryclose *****************************' + qryclose);
                            searchlist = Database.query(qryclose) ;
                            if(searchlist.size() > 0)
                            {
                                List<Id> giveid_close = new List<Id>();
                                for(integer x=0;x<searchlist.size();x++)
                                {
                                    giveid_close.add(searchlist[x].give__c);
                                }
                                List<Give__c> glist_close = new List<Give__c>();
                                glist_close = [select id, Category__c, status__c,available__c, Deadline__c,type__c, name,Number_Remaining__c,City__c, Location_Formula__c,Location_by_State_s__c,Zip_Code_s__c,
                                    description__c,Partnership_Request__c,Latest_Application_Deadline__c,Must_be_21__c,
                                    location_description__c,Partnership_Request__r.Public_Partner_Name__c,Maximum_Units_per_Member__c,(select id, start_date__c, start_time__c, 
                                    end_date__c, end_time__c, date_to__c, year_start_date__c,year_end_date__c,date_from__c from Give_Instances__r order by start_date__c asc),(select id From Attachments where Name like '%logo%' limit 1) from Give__c 
                                    where id in: giveid_close
                                    ] ;
                                if(glist_close.size() > 0)
                                    glist.addall(glist_close);
                                searchlist.clear();
                                system.debug('glist_close.size()**********************' + glist_close.size());
                            }
                        }
                    }
                    
                }
                if(qryzip != null && geo == null)
                {
                    searchlist = Database.query(qryzip) ;
                    if(searchlist.size() > 0)
                    {
                        List<Id> giveid_zip = new List<Id>();
                        for(integer x=0;x<searchlist.size();x++)
                        {
                            giveid_zip.add(searchlist[x].give__c);
                        }
                        List<Give__c> glist_zip = new List<Give__c>();
                        glist_zip = [select id, Category__c, status__c,available__c, Deadline__c,type__c, name,Number_Remaining__c,City__c, Location_Formula__c,Location_by_State_s__c,Zip_Code_s__c,
                                description__c,Partnership_Request__c,Latest_Application_Deadline__c,Must_be_21__c,
                                location_description__c,Partnership_Request__r.Public_Partner_Name__c,Maximum_Units_per_Member__c,(select id, start_date__c, start_time__c, 
                                end_date__c, end_time__c, date_to__c,year_start_date__c,year_end_date__c, date_from__c from Give_Instances__r order by start_date__c asc),(select id From Attachments where Name like '%logo%' limit 1) from Give__c 
                                where id in: giveid_zip
                                ] ;
                        if(glist_zip.size() > 0)
                            glist.addall(glist_zip);
                        searchlist.clear();
                        system.debug('glist_zip.size()**********************' + glist_zip.size());
                    }
                }
                if(qrystate != null)
                {
                    searchlist = Database.query(qrystate) ;
                    if(searchlist.size() > 0)
                    {
                        List<Id> giveid_state = new List<Id>();
                        for(integer x=0;x<searchlist.size();x++)
                        {
                            giveid_state.add(searchlist[x].give__c);
                        }
                        List<Give__c> glist_state = new List<Give__c>();
                        glist_state = [select id, Category__c, status__c,available__c, Deadline__c,type__c, name,Number_Remaining__c,City__c, Location_Formula__c,Location_by_State_s__c,Zip_Code_s__c,
                                description__c,Partnership_Request__c,Latest_Application_Deadline__c,Must_be_21__c,
                                location_description__c,Partnership_Request__r.Public_Partner_Name__c,Maximum_Units_per_Member__c,(select id, start_date__c, start_time__c, 
                                end_date__c, end_time__c, date_to__c,year_start_date__c,year_end_date__c, date_from__c from Give_Instances__r order by start_date__c asc),(select id From Attachments where Name like '%logo%' limit 1) from Give__c 
                                where id in: giveid_state
                                ] ;
                        if(glist_state.size() > 0)
                            glist.addall(glist_state);
                        searchlist.clear();
                        system.debug('glist_state.size()**********************' + glist_state.size());
                    }
                }
                if(qrynat != null)
                {
                    if(glist.size() == 0)
                        userinput = false;
                    searchlist = Database.query(qrynat) ;
                    if(searchlist.size() > 0)
                    {
                        List<Id> giveid_nat = new List<Id>();
                        for(integer x=0;x<searchlist.size();x++)
                        {
                            giveid_nat.add(searchlist[x].give__c);
                        }
                        List<Give__c> glist_nat = new List<Give__c>();
                        glist_nat = [select id, Category__c, status__c,available__c, Deadline__c,type__c, name,Number_Remaining__c,City__c, Location_Formula__c,Location_by_State_s__c,Zip_Code_s__c,
                                description__c,Partnership_Request__c,Latest_Application_Deadline__c,Must_be_21__c,
                                location_description__c,Partnership_Request__r.Public_Partner_Name__c,Maximum_Units_per_Member__c,(select id, start_date__c, start_time__c, 
                                end_date__c, end_time__c, date_to__c,year_start_date__c,year_end_date__c, date_from__c from Give_Instances__r order by start_date__c asc),(select id From Attachments where Name like '%logo%' limit 1) from Give__c 
                                where id in: giveid_nat
                                ] ;
                        if(glist_nat.size() > 0)
                            glist.addall(glist_nat);
                        searchlist.clear();
                        system.debug('glist_nat.size()**********************' + glist_nat.size());
                    }
                }
            }
            catch(exception e){}    
            if(glist.size() > 0)
                return glist;
            else return null;
        
        }
        catch(exception e)
        {
            return null;
        }
    }
    
    /** Below method is used in FAQ page to set the variable as true. It is being used in IN THIS SECTION to highlight the FAQ link**/
    public void FAQ()
    {
        FAQ = true;
    }
    /** Below method is used in to call IAVA signup page. **/
    
    public PageReference mail_memberid() 
    {
        try
        {
            
            /** Query on Contact to find any existing user **/
            List<Contact> listcont = new list<Contact>();
            listcont = [select id, Name,  Email, npe01__HomeEmail__c,lastname, Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c,
            Veteran_Member__c,Membership_Id__c,Submitted_Application__c,
            Submitted_DIA_Member_App__c   from contact where
            (Email = :Email_Member or npe01__HomeEmail__c = :Email_Member or npe01__WorkEmail__c = :Email_Member 
            or npe01__AlternateEmail__c = :Email_Member ) and Membership_Id__c!= null limit 1];
            if(listcont.size() > 0 && Email_Member.trim() != '')
            {
                // Use the OrgWideEmailAddress that has the address of the custom Label
                OrgWideEmailAddress orgEmail = [SELECT Id, Address, DisplayName from OrgWideEmailAddress where address = :System.Label.dc_OrgWideEmailAddress limit 1];
                
                //New instance of a single email message
                Messaging.SingleEmailMessage mail = 
                            new Messaging.SingleEmailMessage();
 
                // Who you are sending the email to
                mail.setTargetObjectId(listcont[0].id);

                // The email template ID used for the email
                mail.setTemplateId(System.Label.dc_ForgotMemberIDTemplate);
          
                mail.setBccSender(false);
                mail.setUseSignature(false);
                if(orgEmail!=null){
                    mail.setOrgWideEmailAddressId(orgEmail.id);
                } else {
                    mail.setReplyTo('rucksack@iava.org');
                    mail.setSenderDisplayName('IAVA Rucksack');
                }
                mail.setSaveAsActivity(true);  
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                Email_MemberConf = true;
                system.debug('Email_MemberConf:::::::::::::::::' + Email_MemberConf);
                if (ApexPages.currentPage().getUrl().toLowerCase().contains(Page.dc_getMemberNumber_mobile.getUrl().toLowerCase())) {
                    return Page.dc_GetMemberNumber_mobile;
                } else {
                    return Page.dc_GetMembershipNumber;
                }
        //      return Page.dc_GetMembershipNumber;
                
            }
            Email_MemberConf = true;
            if (ApexPages.currentPage().getUrl().toLowerCase().contains(Page.dc_getMemberNumber_mobile.getUrl().toLowerCase())) {
                return Page.dc_GetMemberNumber_mobile;
            } else {
                return Page.dc_GetMembershipNumber;
            }
        }
        catch(exception e)
        {
            System.debug(e);
            ApexPages.addMessages(e);
            return null;
        }
    }

    // NGKJ - move Contact outside of signup()
    // private Contact cont;
    
    public void signup() 
    {
        System.Debug('>>> signup() email: ' + Emailtoreg + ' OEF: ' + OEF + ' OIF: ' + OIF + ' OND: ' + OND);
        try
        {
            
            validate = 'false';
            
            // 6/10 MD: These queries should be combined into 1.  no need to basically do the exact same query twice
            /** Query on Contact to validate the user **/
            List<Contact> listcon = new list<Contact>();
            listcon = [select id, Name, npe01__HomeEmail__c, Membership_ID__c from contact where
            (Email = :Emailtoreg or npe01__HomeEmail__c = :Emailtoreg or npe01__WorkEmail__c = :Emailtoreg 
            or npe01__AlternateEmail__c = :Emailtoreg )  and Membership_Id__c != null and Veteran_Member__c = true and 
            Paperwork_Confirmation__c =:CONFIRMED_VET limit 1];
            
            /** Navigate user to Request Reward Page once the user is validated **/
            if(listcon.size() > 0 && Emailtoreg.trim() != '' && Emailtoreg != 'Email')
            {
                validate = 'true';
                system.debug('********************validate =;******************' + validate);
                //return pageref;           
            }
            
            boolean step2;
            /** Query on Contact to find any existing user **/
            List<Contact> listcont = new list<Contact>();
            Contact cont;
            listcont = [select id, Name,  Email, npe01__HomeEmail__c,lastname, Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c,
            Veteran_Member__c,Membership_Id__c,Paperwork_Confirmation__c,Submitted_Application__c,
            Submitted_DIA_Member_App__c   from contact where
            (Email = :emailtoreg or npe01__HomeEmail__c = :emailtoreg or npe01__WorkEmail__c = :emailtoreg 
            or npe01__AlternateEmail__c = :emailtoreg ) limit 1];
            if(listcont.size() > 0 && emailtoreg.trim() != ''  && Emailtoreg.contains('@') && Emailtoreg.contains('.'))
            {
                cont = listcont[0];
                system.debug('listcont*****************' + listcont[0]);
                listcont[0].Veteran_of_OEF__c = OEF;
                listcont[0].Veteran_of_OIF__c = OIF;
                listcont[0].Veteran_of_OND__c = OND;
                listcont[0].Veteran_Member__c = true;
                update listcont[0];
                if(listcont[0].Paperwork_Confirmation__c != CONFIRMED_VET && (listcont[0].Submitted_DIA_Member_App__c == true || listcont[0].Submitted_Application__c == true ))
                {
                    system.debug('INSIDE STEP 2');
                    step2 = true;
                }
            }
            else if(Emailtoreg.contains('@') && Emailtoreg.contains('.'))
            {
                cont = new Contact(lastname='(Unknown)',
                                    email=emailtoreg,
                                    npe01__HomeEmail__c=emailtoreg,
                                    Veteran_of_OEF__c=OEF,
                                    Veteran_of_OIF__c=OIF,
                                    Veteran_of_OND__c=OND,
                                    Veteran_Member__c=true);
               system.debug('INSERT.................................');
               insert cont;
            }
            
            /*
            Pagereference pr = step2 ? new PageReference(System.Label.dc_MemberSignupURLStep2) : new PageReference(System.Label.dc_MemberSignupURLStep1);
            if(OIF) pr.getParameters().put('tfa_OIFIraq','1');
            if(OEF) pr.getParameters().put('tfa_OEFAfghanistan1','1');
            if(emailtoreg!=null && emailtoreg!='') pr.getParameters().put('tfa_EMAIL',emailtoreg);
            return pr;
            */
            if(OIF == true)
            {
                oif_val = 'tfa_OIFIraq';
            }
            else
            {
                oif_val = '';
            }
            if(OEF == true)
            {
                oef_val = 'tfa_OEFAfghanistan1';
            }
            else
            {
                oef_val = '';
            }       
            if(OND == true)
            {
                ond_val = 'tfa_ONDIraq';
            }
            else
            {
                ond_val = '';
            }  
            system.debug('emailtoreg::::::::::::::::::::::' + emailtoreg);
            system.debug('OIF:::::::::::::::::::::' + OIF);
            system.debug('OEF::::::::::::::::::::::' + OEF);
            system.debug('OND::::::::::::::::::::::' + OND);
            system.debug('pName::::::::::::::::::::::' + pName);
            if(validate != 'true')
            {
                if(step2 == true)
                    // pName = 'https://secure.iava.org/veteran-paperwork?tfa_email=' + emailtoreg ;  
                    pName = System.Label.dc_MemberSignupURLStep2 + (System.Label.dc_MemberSignupURLStep2.contains('?') ? '&' : '?') + 'tfa_EMAIL=' + emailtoreg;
                else pName = System.Label.dc_MemberSignupURLStep1 + (System.Label.dc_MemberSignupURLStep1.contains('?') ? '&' : '?') + 'tfa_EMAIL=' + emailtoReg;
                // else pName = 'https://secure.iava.org/veteran-join?tfa_EMAIL=' + emailtoreg  ;
            }
            else
                pName = 'none';                     
                system.debug('pName::::::::::::::::::::::' + pName);
            
        } // end of try
        catch(exception e)
        {
            pName = System.Label.dc_MemberSignupURLStep1 + (System.Label.dc_MemberSignupURLStep1.contains('?') ? '&' : '?') + 'tfa_EMAIL=' + emailtoReg;
            System.debug(e);
            ApexPages.addMessages(e);
            return;
        }
    }// end of method signup
    
    public void its()
    {
        Staticvar.dc_homepage = false;
        Staticvar.dc_rewardsearch = true;
        Staticvar.dc_rewarddetail = false;
        Staticvar.dc_claimreward = false;
        Staticvar.dc_partner =false;
        Staticvar.dc_faq = false;
        StaticVar.title = 'IAVA Rucksack - Search Results';

    } 
    
    public void defaultEmail()
    {
        Email_Member = 'Email Address';
    }   
    
    public string getoldieversion()
    {
        String userAgent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        system.debug('userAgent::::::::::::::::::::::' + userAgent);
        if(userAgent.contains('MSIE 6.0'))
            return 'true';
        else if(userAgent.contains('MSIE'))
            return 'false';
        else return 'none';         
    }
    
    public string getMacos()
    {
        String user_Agent = ApexPages.currentPage().getHeaders().get('USER-AGENT');
        system.debug('userAgent::::::::::::::::::::::' + user_Agent);
        if(user_Agent.contains('Mac'))
            return 'true';
        else return 'none';         
    }   
    
}