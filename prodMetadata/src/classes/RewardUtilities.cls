public class RewardUtilities {
    
    public class Reward
    {
        // First, fields from the Give Instance Object
        public ID       GiveInstanceID;
        public String   DateFrom;
        public String   DateTo;
        public Date     EndDate;
        public String   EndTime;
        public Decimal  NumInstances;
        public Decimal  NumRemaining;
        public Decimal  NumUnits;
        public Date     StartDate;
        public String   StartTime;
        public String   InstanceStatus;
        public String   YearEndDate;
        public String   YearStartDate;
        public Decimal  TentativeRemaining;
        // Next, fields from the Give Object
        public ID       GiveID;
        public String   Title;
        public String   Available;
        public String   Category;
        public String   Deadline;
        public String   Disclaimer;
        public String   Eligibility;
        public String   Fulfillment;
        public Boolean  Highlight;
        public String   LocationByStreet;
        public String   LocationByState;
        public String   LocationByZip;
        public String   LocationFormula;
        public String   LocationDescription;
        public Decimal  MaximumUnits;
        public Boolean  QtyNonSelect;
        public String   MoreInfoLink;
        public Boolean  MustBe21;
        public Boolean  NationalGive;
        public Boolean  SpecialResponse;
        public String   ShortDescription;
        public String   SpecialInstructions;
        public String   GiveStatus;
        public String   SubCategory;
        public String   RewardType;
        public String   GiveDateDisplay;
        public String   Waitlist;
        public String   CityST;
        // Next, fields from the Partnership Object
        public ID       PartnershipID;
        public Boolean  FeaturedPartner;
        public Boolean  PartnerOnHome;
        public Boolean  PartnerOnSite;
        public String   BriefDescription;
        public String   DetailDescription;
        public String   PublicName;
        public Decimal  LogoBlockSortOrder;
        public Decimal  PartnerSortOrder;
        public String   Stage;
        // Finally fields for the images ... (relative URL)
        public String   PartnerImage;
        public String   Image;
        // NEW FIELDS - Latitude, Longitude, Distance (From Searched Latitude, Longitude)
        public Double   Latitude;
        public Double   Longitude;
        public Double   Distance;
        
        public String   CollectGuestDOB;
        public String   CollectGuestDLNum;
        public String   CollectGuestName;
        public String   CollectGuestShirtSize;
        public String   CollectMemberDOB;
        public String   CollectMemberDLNum;
        public String   CollectMemberShirtSize;
        public String   CollectSpecialResponse2;
        public String   CollectSpecialResponse3;
        public String   CollectSpecialResponse4;
        public String   CollectSpecialResponse5;
        public Boolean  MustBe21ForGuest;
        public String   SpecialInstructions2;
        public String   SpecialInstructions3;
        public String   SpecialInstructions4;
        public String   SpecialInstructions5;
        
    }

    private static final String fieldList = 'Id, Date_From__c, Date_To__c, End_Date__c, End_Time__c' 
        + ', Num_Inst__c, Number_Remaining__c, Number_of_Units__c, Start_Date__c, Start_Time__c'
        + ', Status__c, Year_End_Date__c, Year_Start_Date__c, Tentative_Number_Remaining__c'
        + ', Give__r.Id, Give__r.Name, Give__r.Available__c, Give__r.Category__c'
        + ', Give__r.Deadline__c, Give__r.Disclaimer__c, Give__r.Eligibility_Description__c'
        + ', Give__r.Fulfillment_Instructions_for_Winner__c, Give__r.Highlight_Listing__c'
        + ', Give__r.Location_Street_Address__c, Give__r.Location_by_State_s__c, Give__r.Zip_Code_s__c'
        + ', Give__r.Location_Formula__c, Give__r.Location_Description__c, Give__r.City__c'
        + ', Give__r.Maximum_Units_per_Member__c, Give__r.Member_Cannot_Select_Quantity__c'
        + ', Give__r.More_Info_Link__c, Give__r.Must_be_21__c, Give__r.National_Give__c'
        + ', Give__r.Requires_Special_Response__c, Give__r.Description__c, Give__r.Special_Instructions__c'
        + ', Give__r.Status__c, Give__r.Subcategory__c, Give__r.Type__c, Give__r.Give_Date_Display__c, Give__r.Waitlist__c'
        + ', Give__r.Partnership_Request__r.Featured_Partner__c'
        + ', Give__r.Partnership_Request__r.Show_partner_logo_on_rewards_homepage__c'
        + ', Give__r.Partnership_Request__r.Show_Partner_Logo__c'
        + ', Give__r.Partnership_Request__r.Public_Description__c'
        + ', Give__r.Partnership_Request__r.Public_Detail_Description__c'
        + ', Give__r.Partnership_Request__r.Public_Partner_Name__c'
        + ', Give__r.Partnership_Request__r.Sort_Order_in_Logo_block__c'
        + ', Give__r.Partnership_Request__r.Sort_Order_on_Partners_page__c'
        + ', Give__r.Partnership_Request__r.Stage__c'
        + ', Give__r.Partnership_Request__r.Id'
        + ', Give__r.Geo_Location__r.lat__c'
        + ', Give__r.Collect_Guest_DL_Num__c'
        + ', Give__r.Collect_Guest_DOB__c'
        + ', Give__r.Collect_Guest_Name__c'
        + ', Give__r.Collect_Guest_Shirt_Size__c'
        + ', Give__r.Collect_Member_DL_Num__c'
        + ', Give__r.Collect_Member_DOB__c'
        + ', Give__r.Collect_Member_Shirt_Size__c'
        + ', Give__r.Collect_Special_Response_2__c'
        + ', Give__r.Collect_Special_Response_3__c'
        + ', Give__r.Collect_Special_Response_4__c'
        + ', Give__r.Collect_Special_Response_5__c'
        + ', Give__r.Must_be_21_for_guest__c'
        + ', Give__r.Special_Instructions_2__c'
        + ', Give__r.Special_Instructions_3__c'
        + ', Give__r.Special_Instructions_4__c'
        + ', Give__r.Special_Instructions_5__c'
        + ', Give__r.Geo_Location__r.lon__c';

    private static Reward populateReward(Give_Instance__c give)
    {
        if (give == null) return null;
        System.Debug('Populating a reward: ' + give);
        Reward reward = new Reward();       
        // First, populate the fields from the Give Instance
        reward.GiveInstanceID = give.Id;
        reward.DateFrom = give.Date_From__c;
        reward.DateTo = give.Date_To__c;
        reward.EndDate = give.End_Date__c;
        reward.EndTime = give.End_Time__c;
        reward.NumInstances = give.Num_Inst__c;
        reward.NumRemaining = give.Number_Remaining__c;
        reward.NumUnits = give.Number_of_Units__c;
        reward.StartDate = give.Start_Date__c;
        reward.StartTime = give.Start_Time__c;
        reward.InstanceStatus = give.Status__c;
        reward.YearEndDate = give.Year_End_Date__c;
        reward.YearStartDate = give.Year_Start_Date__c;
        reward.TentativeRemaining = give.Tentative_Number_Remaining__c;
        // System.Debug('Populated Instance: ' + reward);
        // Next, populate the fields from the Give itself
        reward.GiveID = give.Give__r.Id;
        reward.Title = give.Give__r.Name;
        reward.Available = give.Give__r.Available__c;
        reward.Category = give.Give__r.Category__c;
        reward.Deadline = give.Give__r.Deadline__c;
        reward.Disclaimer = give.Give__r.Disclaimer__c;
        reward.Eligibility = give.Give__r.Eligibility_Description__c;
        reward.Fulfillment = give.Give__r.Fulfillment_Instructions_for_Winner__c;
        reward.Highlight = give.Give__r.Highlight_Listing__c;
        reward.LocationByStreet = give.Give__r.Location_Street_Address__c;
        reward.LocationByState = give.Give__r.Location_by_State_s__c;
        reward.LocationByZip = give.Give__r.Zip_Code_s__c;
        reward.LocationFormula = give.Give__r.Location_Formula__c;
        reward.LocationDescription = give.Give__r.Location_Description__c;
        reward.MaximumUnits = give.Give__r.Maximum_Units_per_Member__c;
        reward.QtyNonSelect = give.Give__r.Member_Cannot_Select_Quantity__c;
        reward.MoreInfoLink = give.Give__r.More_Info_Link__c;
        reward.MustBe21 = give.Give__r.Must_be_21__c;
        reward.NationalGive = give.Give__r.National_Give__c;
        reward.SpecialResponse = give.Give__r.Requires_Special_Response__c;
        reward.ShortDescription = give.Give__r.Description__c;
        reward.SpecialInstructions = give.Give__r.Special_Instructions__c;
        reward.GiveStatus = give.Give__r.Status__c;
        reward.SubCategory = give.Give__r.Subcategory__c;
        reward.RewardType = give.Give__r.Type__c;
        reward.GiveDateDisplay = give.Give__r.Give_Date_Display__c;
        reward.Waitlist = give.Give__r.Waitlist__c;
        reward.CityST = give.Give__r.City__c;
        // System.Debug('Populated Give: ' + reward);
        // Next, populate the fields from the Partnership
        reward.PartnershipID = give.Give__r.Partnership_Request__r.Id;
        reward.FeaturedPartner = give.Give__r.Partnership_Request__r.Featured_Partner__c;
        reward.PartnerOnHome = give.Give__r.Partnership_Request__r.Show_partner_logo_on_rewards_homepage__c;
        reward.PartnerOnSite = give.Give__r.Partnership_Request__r.Show_Partner_Logo__c;
        reward.BriefDescription = give.Give__r.Partnership_Request__r.Public_Description__c;
        reward.DetailDescription = give.Give__r.Partnership_Request__r.Public_Detail_Description__c;
        reward.PublicName = give.Give__r.Partnership_Request__r.Public_Partner_Name__c;
        reward.LogoBlockSortOrder = give.Give__r.Partnership_Request__r.Sort_Order_in_Logo_block__c;
        reward.PartnerSortOrder = give.Give__r.Partnership_Request__r.Sort_Order_on_Partners_page__c;
        reward.Stage = give.Give__r.Partnership_Request__r.Stage__c;
        reward.PartnerImage = null; // FOR NOW
        reward.Image = null;        // FOR NOW
        // Finally, populate the Geo Location Information
        reward.Latitude = give.Give__r.Geo_Location__r.lat__c;
        reward.Longitude = give.Give__r.Geo_Location__r.lon__c;
        
        reward.CollectGuestDLNum = give.Give__r.Collect_Guest_DL_Num__c;
        reward.CollectGuestDOB = give.Give__r.Collect_Guest_DOB__c;
        reward.CollectGuestName = give.Give__r.Collect_Guest_Name__c; 
        reward.CollectGuestShirtSize = give.Give__r.Collect_Guest_Shirt_Size__c;
        reward.CollectMemberDLNum = give.Give__r.Collect_Member_DL_Num__c;
        reward.CollectMemberDOB = give.Give__r.Collect_Member_DOB__c;
        reward.CollectMemberShirtSize = give.Give__r.Collect_Member_Shirt_Size__c;
        reward.CollectSpecialResponse2 = give.Give__r.Collect_Special_Response_2__c;
        reward.CollectSpecialResponse3 = give.Give__r.Collect_Special_Response_3__c;
        reward.CollectSpecialResponse4 = give.Give__r.Collect_Special_Response_4__c;
        reward.CollectSpecialResponse5 = give.Give__r.Collect_Special_Response_5__c;
        reward.MustBe21ForGuest = give.Give__r.Must_be_21_for_guest__c;
        reward.SpecialInstructions2 = give.Give__r.Special_Instructions_2__c;
        reward.SpecialInstructions3 = give.Give__r.Special_Instructions_3__c;
        reward.SpecialInstructions4 = give.Give__r.Special_Instructions_4__c;
        reward.SpecialInstructions5 = give.Give__r.Special_Instructions_5__c;

        System.Debug('Populated reward: ' + reward);
        return reward;
    }

    private static void populateImageURLs(List<Reward> rewards)
    {
        if ((rewards != null) && (rewards.size() > 0))
        {
            Set<ID> gIDs = new Set<ID>();       // A set of Give IDs
            Set<ID> prIDs = new Set<ID>();      // A set of Partnership IDs
            for(Reward reward : rewards)
            {
                reward.Image = reward.GiveID;                   // FOR NOW
                reward.PartnerImage = reward.PartnershipID;     // FOR NOW
                gIDs.add(reward.GiveID);
                prIDs.add(reward.PartnershipID);
            }
            if (gIDs.size() > 0)
            {
                List<Attachment> Attachments = new List<Attachment>(); 
                Attachments = [SELECT Id, ParentId FROM Attachment WHERE Name LIKE '%logo%' AND BodyLength < 51200 AND ParentId IN :gIDs];
                for (Reward reward : Rewards)
                    for (Attachment attachment : Attachments)
                        if ((reward.Image != null) && (reward.Image.length() < 20) && (reward.Image == attachment.ParentId))
                            reward.Image = '/servlet/servlet.FileDownload?file=' + attachment.Id; 
            }
            if (prIDs.size() > 0)
            {
                System.Debug('Site URL: ' + Site.getCurrentSiteUrl());
                List<Attachment> Attachments = new List<Attachment>(); 
                Attachments = [SELECT Id, ParentId FROM Attachment WHERE Name LIKE '%logo%' AND BodyLength < 512000 AND ParentId IN :prIDs];
                for (Reward reward : Rewards)
                    for (Attachment attachment : Attachments)
                        if ((reward.PartnerImage != null) && (reward.PartnerImage.length() < 20) && (reward.PartnerImage == attachment.ParentId))
                            reward.PartnerImage = '/servlet/servlet.FileDownload?file=' + attachment.Id; 
            }
            for (Reward reward : Rewards)
            {
                if ((reward.Image != null) && (reward.Image.length() < 20))                 // Still a pointer ???
                    reward.Image = null;
                if ((reward.PartnerImage != null) && (reward.PartnerImage.length() < 20))   // Still a pointer ???
                    reward.PartnerImage = null;
            }
        }
    }

    public static String GeoCriteria(String ZipCode, String Distance)
    {
        try {
        String Criteria = null;
        // Always include the National Gives and those matching the selected ZipCode
        String NationalCriteria = '(Give__r.National_Give__c = true)';
        if (StringUtilities.ValidZipCode5(ZipCode))
            Criteria = '(' + NationalCriteria + ' OR (Give__r.Zip_Code_s__c = \'' + ZipCode + '\'))';
        else Criteria = NationalCriteria;
        Map<String, List<String>> gMAP = GoogleMapUtils.GeoLocationMap(ZipCode, Distance);
        if (gMAP == null) return Criteria;
        Set<String> States = gMAP.keySet();
        Set<String> gLOCs = new Set<String>();
        for (String State : States) gLOCs.addAll(gMAP.get(State));
        String LocationCriteria = QueryCriteria.setCriteria('Give__r.Geo_Location__c', gLOCs);
        // String StateCriteria = QueryCriteria.setCriteria('Give__r.Location_by_State_s__c', States);
        String StateCriteria = QueryCriteria.multiPicklistCriteria('Give__r.Location_by_State_s__c', States);
        if ((LocationCriteria == null) && (StateCriteria == null)) return Criteria;
        if (LocationCriteria == null) return '(' + StateCriteria + ' OR ' + Criteria + ')';
        if (StateCriteria == null) return '(' + LocationCriteria + ' OR ' + Criteria + ')';
        return '(' + LocationCriteria + ' OR ' + StateCriteria + ' OR ' + Criteria + ')';
        }
        catch (exception ex) { System.Debug(ex); return null; }
        return null;
    }

    public static String GeoCriteria(String Latitude, String Longitude, String Distance)
    {
        try {
        System.Debug('Searching by Latitude, Longitude, Distance: ' + Latitude + ' ' + Longitude + ' ' + Distance);
        String Criteria = null;
        // Always include the National Gives
        String NationalCriteria = '(Give__r.National_Give__c = true)';
        Criteria = NationalCriteria;
        Map<String, List<String>> gMAP = GoogleMapUtils.GeoLocationMap(Latitude, Longitude, Distance);
        System.Debug('Found: ' + gMap);
        if (gMAP == null) return Criteria;
        Set<String> States = gMAP.keySet();
        Set<String> gLOCs = new Set<String>();
        for (String State : States) gLOCs.addAll(gMAP.get(State));
        System.Debug('States: ' + States);
        System.Debug('gLOCs: ' + gLOCs);
        String LocationCriteria = QueryCriteria.setCriteria('Give__r.Geo_Location__c', gLOCs);
        System.Debug('LocationCriteria: ' + LocationCriteria);
        // String StateCriteria = QueryCriteria.setCriteria('Give__r.Location_by_State_s__c', States);
        String StateCriteria = null;
        if ((States != null) && (States.size() == 1) && (!States.contains('UNKNOWN')))
            StateCriteria = QueryCriteria.multiPicklistCriteria('Give__r.Location_by_State_s__c', States);
        System.Debug('StateCriteria: ' + StateCriteria);
        if ((LocationCriteria == null) && (StateCriteria == null)) return Criteria;
        if (LocationCriteria == null) return '(' + StateCriteria + ' OR ' + Criteria + ')';
        if (StateCriteria == null) return '(' + LocationCriteria + ' OR ' + Criteria + ')';
        return '(' + LocationCriteria + ' OR ' + StateCriteria + ' OR ' + Criteria + ')';
        }
        catch (exception ex) { System.Debug(ex); return null; }
        return null;
    }

    public static List<Reward> SearchRewards(
        String PartnerID, String GiveID, String InstanceID,         // Main Criteria - Partner, Give, Instance ID
        Boolean DeDupByGiveID,                                      // Return Single Instance Per Give 
        Set<String> GiveStatus, Set<String> InstanceStatus,         // Give Status and Instance Status ...
        String ZipCode, String Distance,                            // Zip Code and Distance ...
        String LAT, String LON,                                     // Latitude and Longitude ...
        Integer records)                                            // LIMIT on returned rows (further limited by DeDup)
    {
        System.debug(System.LoggingLevel.INFO, 'SearchRewards START');
        System.debug(System.LoggingLevel.INFO, 'PartnerID: ' + PartnerID);
        System.debug(System.LoggingLevel.INFO, 'GiveID: ' + GiveID);
        System.debug(System.LoggingLevel.INFO, 'InstanceID: ' + InstanceID);
        System.debug(System.LoggingLevel.INFO, 'DeDupByGiveID: ' + DeDupByGiveID);
        System.debug(System.LoggingLevel.INFO, 'GiveStatus: ' + GiveStatus);
        System.debug(System.LoggingLevel.INFO, 'InstanceStatus' + InstanceStatus);
        System.debug(System.LoggingLevel.INFO, 'ZipCode: ' + ZipCode);
        System.debug(System.LoggingLevel.INFO, 'Distance: ' + Distance);
        System.debug(System.LoggingLevel.INFO, 'LAT: ' + LAT);
        System.debug(System.LoggingLevel.INFO, 'LONG: ' + LON);
        System.debug(System.LoggingLevel.INFO, 'Records: ' + records);
        
        Boolean CalculateDistance = false;
        Double fmLat = 0.0;
        Double fmLon = 0.0;
        List<Give_Instance__c> Gives = new List<Give_Instance__c>();
        QueryCriteria criteria = new QueryCriteria();
        if (GiveStatus != null) criteria.addTo(QueryCriteria.setCriteria('Give__r.Status__c', GiveStatus));
        if (InstanceStatus != null) criteria.addTo(QueryCriteria.setCriteria('Status__c', InstanceStatus));
        if (InstanceID != null) criteria.addTo('Id = ' + '\'' + InstanceID + '\'');
        if (GiveID != null) criteria.addTo('Give__r.Id = ' + '\'' + GiveID + '\'');
        if (PartnerID != null) criteria.addTo('Give__r.Partnership_Request__r.Id = ' + PartnerID);
        if ((ZipCode != null) && (StringUtilities.ValidZipCode5(ZipCode)))
        {
            System.debug(System.LoggingLevel.INFO, 'Searching by Zip');
            
            if (Distance == null) Distance = Rucksack_Mobile_Services__c.getAll().get('Default Search Radius').Value__c;
            
            System.debug(System.LoggingLevel.INFO, 'Distance: ' + Distance);
            
            criteria.addTo(GeoCriteria(ZipCode, Distance));
            Map<String, String> ZipDetails = GoogleMapUtils.ZipCodeInformation(ZipCode);

            System.debug(System.LoggingLevel.INFO, 'Here');
            
            if (ZipDetails != null) {
                String xLat = ZipDetails.get('Latitude');
                String xLon = ZipDetails.get('Longitude');
                
                System.debug(System.LoggingLevel.INFO, 'xLat: ' + xLat);
                System.debug(System.LoggingLevel.INFO, 'xLon: ' + xLon);
                
                if ((xLat != null) && (xLon != null) && (StringUtilities.ValidDouble(xLat)) && (StringUtilities.ValidDouble(xLon))) {
                    fmLat = Double.valueOf(xLat);
                    fmLon = Double.valueOf(xLon); 
                    CalculateDistance = true;
                    System.debug(System.LoggingLevel.INFO, 'CalculateDistance: ' + CalculateDistance);
                }
            }
        }
        else if ((LAT != null) && (LON != null) && (StringUtilities.ValidDouble(LAT)) && (StringUtilities.ValidDouble(LON))) {
            if (Distance == null) Distance = Rucksack_Mobile_Services__c.getAll().get('Default Search Radius').Value__c;
            criteria.addTo(GeoCriteria(LAT, LON, Distance));
            CalculateDistance = true;
            fmLat = Double.valueOf(LAT);
            fmLon = Double.valueOf(LON);
        }
        System.Debug('Query Criteria: ' + criteria.Criteria);
        String queryString = 'SELECT ' + fieldList + ' FROM Give_Instance__c ' + criteria.Criteria;
        if (CalculateDistance)
            queryString += ' ORDER BY Give__r.Location_Sort__c, Give__r.Earliest_Start_Date__c';
        else
            queryString += ' ORDER BY Give__r.Highlight_Listing__c DESC, Give__r.Location_Sort__c, Give__r.Earliest_Start_Date__c';
        if ((records != null) && (records > 0)) queryString += ' LIMIT ' + records;
        try
        {
            System.Debug('Executing query: [' + queryString + ']');
            Gives = Database.query(queryString);
        }
        catch (exception ex)
        {
            System.Debug('Query exception: ' + ex.getMessage());
            return null;
        }
        if ((Gives == null) || (Gives.size() == 0)) return null;
        // Prepare the reward list
        List<Reward> rewards = new List<Reward>();
        Set<ID> GiveIDs = new Set<ID>();        // A set of GiveIDs for DeDuping by Give
        for (Give_Instance__c give : Gives)
            if ((!DeDupByGiveID) || (GiveIDs.add(give.Give__r.Id)))
                rewards.add(populateReward(give));
        populateImageURLs(rewards);
        if (CalculateDistance) {
            for (Reward rwd : rewards) {
                if ((rwd.Latitude != null) && (rwd.Longitude != null))
                    rwd.Distance = GoogleMapUtils.DistanceBetween(fmLat, fmLon, rwd.Latitude, rwd.Longitude);
                else rwd.Distance = null;
            }
            List<Reward> RwD = new List<Reward>();  // Rewards with Distance
            List<Reward> RoD = new List<Reward>();  // Rewards without Distance
            for (Reward r : rewards) {
                if (r.Distance != null) RwD.add(r);
                else RoD.add(r);
            }
            RwD = SortRewardsByDistance(RwD);
            rewards.clear();
            for (Reward r : RwD) rewards.add(r);
            for (Reward r : RoD) rewards.add(r);
        }
        
        System.debug(System.LoggingLevel.INFO, 'SearchRewards END');
        
        return rewards;
    }

    // Sort rewards by Distance
    public static List<Reward> SortRewardsByDistance(List<Reward> ListToSort) {
        System.Debug('SORTING: ' + ListToSort);
        if ((ListToSort == null) || (ListToSort.size() <= 1)) return ListToSort;
        List<Reward> SortedList = new List<Reward>();
        while (ListToSort.size() > 0) {
            integer i = 0;
            integer smallest = 0;
            for (i = 0; i < ListToSort.size(); i++)
                if (ListToSort[i].Distance < ListToSort[smallest].Distance)
                    smallest = i;
            System.Debug('Smallest: ' + ListToSort[smallest].Distance);
            SortedList.add(ListToSort[smallest]);
            ListToSort.remove(smallest);
        }
        System.Debug('SORTED: ' + SortedList);
        return SortedList; 
    }

    public static Reward InstanceDetails(String GiveInstanceID)
    {
        List<Reward> rewards = SearchRewards(null, null, GiveInstanceID, false, null, null, null, null, null, null, 1);
        if ((rewards != null) && (rewards.size() == 1)) return rewards[0];
        return null;
    }

    public static List<Reward> sampleRewards(Map<String, String> request)
    {
        String ZipCode = request.get('ZipCode');
        String Latitude = request.get('Latitude');
        String Longitude = request.get('Longitude');
        String Distance = request.get('Distance');
        System.Debug('Obtaining sampleRewards ...');
        Set<String> status = new Set<String>{'Open', 'Waitlist'};
        return SearchRewards(null, null, null, true, status, status, ZipCode, Distance, Latitude, Longitude, 250);
    }
    
    public static void updateRegisteredDevice(Map<String, String> request){
        String DeviceToken = request.get('DeviceToken');
        String ZipCode = request.get('ZipCode');
        String Latitude = request.get('Latitude');
        String Longitude = request.get('Longitude');
        
        if(DeviceToken != null){
            try {
                Registered_Device__c rD = [ SELECT  New_Rewards__c, 
                                                    Last_Latitude__c, 
                                                    Last_Longitude__c,
                                                    Last_Zip_Code__c,
                                                    Last_Search_By__c,
                                                    Last_Search_On__c 
                                            FROM    Registered_Device__c 
                                            WHERE   Device_Token__c =: DeviceToken];
                
                rD.Last_Latitude__c = '';
                rD.Last_Longitude__c = '';
                rD.Last_Zip_Code__c = '';
                rD.Last_Search_By__c = null;
                rD.Last_Search_On__c = Datetime.now();
                rD.New_Rewards__c = 0;
                
                if(ZipCode != null){
                    rD.Last_Search_By__c = 'Zip Code';
                    rD.Last_Zip_Code__c = ZipCode;
                }else if(Latitude != null || Longitude != null){
                    rD.Last_Search_By__c = 'Latitude and Longitude';
                    rD.Last_Latitude__c = Latitude;
                    rD.Last_Longitude__c = Longitude;
                }
                update rD;
            }catch(QueryException e){
                System.debug(e.getMessage());
            }catch(DmlException e){
                System.debug(e.getMessage());
            }
        }
    }
    
    public static List<Reward> RewardDetails(String GiveID)
    {   
        System.Debug('Obtaining RewardDetails for: ' + GiveID);
        Set<String> status = new Set<String>{'Open', 'Waitlist'};
        return SearchRewards(null, GiveID, null, false, status, status, null, null, null, null, null);
    }       

    public static final String msgTentative = 'Thanks.  We have received your request and you are tentatively on the list to receive the reward. However we\'ll be in touch before the reward date to confirm the availability of the reward.';
    public static final String msgWaitlist = 'Thanks, we have received your request and you are now on the waitlist.  Because of high demand for this reward, there is limited availability. We\'ll be in touch to let you know if your request has been approved.';
    public static final String msgConfirmed = 'Congratulations, you are now on the list for this reward.';
    public static final String msgPremium = 'Thanks, we have received your request.  This is a Premium Reward, so availability is very limited. We\'ll be in touch before the reward date to let you know whether you\'ve received the reward.';
    // public static final String msgSorry = 'Sorry';   // if the returned message begins with 'Sorry' the request failed.
    public static final String msgUnavailable = 'Sorry, this reward was not available. Please check out some of the other rewards available.';
    // public static final String msgRequested = 'Sorry, you have already requested this reward.';
    public static final String msgRequested = System.Label.dc_multiple_giverequest_error;
    public static final String msgOther = 'Sorry, your request could not be completed due to the following error(s): ';

    public static Map<String, String> RequestReward(Map<String, String> IncomingMap)
    {
        String MemberID = IncomingMap.get('MemberID');
        String eMail = IncomingMap.get('eMail');
        String GiveInstanceID = IncomingMap.get('GiveInstanceID');
        String SpecialResponse = IncomingMap.get('SpecialResponse');
        String TicketValue = IncomingMap.get('TicketValue');
        String AddressLine1 = IncomingMap.get('AddressLine1');
        String AddressLine2 = IncomingMap.get('AddressLine2');
        String City = IncomingMap.get('City');
        String State = IncomingMap.get('State');
        String Zip = IncomingMap.get('Zip');
        String Phone = IncomingMap.get('Phone');
        String NewEmailAddress = IncomingMap.get('NewEmailAddress');
        String MakeAddressPrimary = IncomingMap.get('MakeAddressPrimary');
        String MakeEmailPrimary = IncomingMap.get('MakeEmailPrimary');
        String MakePhonePrimary = IncomingMap.get('MakePhonePrimary');
        String Confirmed21 = IncomingMap.get('Confirmed21');
        String DeviceType = IncomingMap.get('DeviceType');
        String DeviceModel = IncomingMap.get('DeviceModel');
        String DeviceOS = IncomingMap.get('DeviceOS');
        String AppVersion = IncomingMap.get('AppVersion');
        Map<String, String> response = new Map<String, String>();
        response.put('status','Request failed.');
        if ((MemberID == null) || (eMail == null) || (GiveInstanceID == null))
        {
            response.put('message', msgOther + '\nRequired parameters are missing.');
            return response;
        }
        String ContactID = ContactUtilities.ConfirmedMemberID(MemberID, eMail);
        if (ContactID == null)
        {
            response.put('message', msgOther + '\nMemberID / eMail is NOT a confirmed member.');
            return response;
        }
        Reward reward = InstanceDetails(GiveInstanceID);
        if (reward == null)
        {
            response.put('message', msgOther + '\nGiveInstance with provided ID was not found.');
            return response;
        }
        Give_Request__c request = new Give_Request__c();
        request.Applicant__c = ContactID;
        if (SpecialResponse != null)
            request.Special_Response__c = SpecialResponse;
        if (TicketValue != null) 
            if (StringUtilities.ValidDecimal(TicketValue))
                request.Units_Requested__c  = Decimal.valueOf(TicketValue);
        /*  else
            {
                response.put('message', msgOther + '\nInvalid Quantity requested.');
                return response;
            }
        else
            request.Units_Requested__c = 1; */
        request.Address__c = AddressLine1 + ' ' + AddressLine2;
        request.Give_Instance__c = GiveInstanceID;
        request.Contact_ID_plus_Give_ID__c = ContactID + reward.GiveID;
        if ((NewEmailAddress != null) && (NewEmailAddress != ''))
            request.Email_Address__c = NewEmailAddress;
        else
            request.Email_Address__c = eMail;
        if (City != null)   request.City__c = City;
        if (State != null)  request.State__c = State;
        if (Zip != null)    request.Zip_Code__c = Zip;
        if (Phone != null)  request.Primary_Phone__c = Phone;
        if ((MakeAddressPrimary != null) && (MakeAddressPrimary == 'true'))
            request.Make_Address_Primary__c = true;
        if ((MakeEmailPrimary != null) && (MakeEmailPrimary == 'true'))
            request.Make_Email_Primary__c = true;
        if ((MakePhonePrimary != null) && (MakePhonePrimary == 'true'))
            request.Make_Phone_Primary__c = true;
        if ((Confirmed21 != null) && (Confirmed21 == 'true'))
            request.Confirmed_21__c = true;
        if ((DeviceType == 'iPhone') && (AppVersion != null))
            request.Platform__c = 'iPhone app';
        else
            request.Platform__c = 'Website';
        if (DeviceModel != null)    request.Platform_Device_Model__c = DeviceModel;
        if (DeviceOS != null)       request.Platform_Device_OS__c = DeviceOS;
        if (AppVersion != null)     request.Platform_Version__c = AppVersion;
        System.Debug('Inserting a Reward Request: ' + request);
        Database.SaveResult sr = Database.insert(request, false);
        System.Debug('SaveResult: ' + sr);
        if (!sr.isSuccess())
        {
            List<Database.Error> errorList = sr.getErrors();
            String ErrorMessage = '';
            for (Database.Error error : errorList)
                if (error.getMessage().contains('Contact_ID_plus_Give_ID__c duplicates value on record'))
                    ErrorMessage += '\n' + msgRequested;
                else
                    ErrorMessage += '\n' + error.getMessage();
            response.put('message', ErrorMessage);
            return response;
        }
        // The request succeeded, so populate the rest of the response ...
        response.put('status','Successful');
        //request = [SELECT Id, Stage__c, Applicant__r.Name, Giveas_Fulfillment_Instructions__c FROM Give_Request__c WHERE Id = :request.Id];        
        request = [SELECT Id, Stage__c, Applicant__r.Name, Give_Instance__r.Give__r.Fulfillment_Instructions_for_Winner__c FROM Give_Request__c WHERE Id = :request.Id];        
        response.put('stage', request.Stage__c);
        response.put('eMail', eMail);
        response.put('applicant', request.Applicant__r.Name);
        if (reward.StartDate != null)    response.put('StartDate', reward.StartDate.format());
        response.put('Title', reward.Title);
        response.put('message', msgUnavailable);
        response.put('GiveURL', 'dc_RewardDetails?giveID=' + reward.GiveID);
        if (request.Stage__c == 'Tentative confirmation') response.put('message', msgTentative);
        if (request.Stage__c == 'Wait-list') response.put('message', msgWaitlist);
        if (request.Stage__c == 'Give requested') response.put('message', msgPremium);
        if (request.Stage__c == 'Final Confirmation')
        {
            String FullMessage = msgConfirmed;
            if (request.Give_Instance__r.Give__r.Fulfillment_Instructions_for_Winner__c != null)
                FullMessage += '\n\r\n\r' + request.Give_Instance__r.Give__r.Fulfillment_Instructions_for_Winner__c;
            response.put('message', FullMessage);
        }
        return response;
    }
    
    /*
    *   (New) Check Give
    *   The Check Give method will be used to create Pending Notifications as necessary 
    *   when indicated by the user on the Give page.
    *
    *   The pseudo-code required is as follows:
    *   ·   If the Send Notifications checkbox is checked
    *       o   Validate the input fields within the New Notification section
    *           §   Indicate Errors on the page at the field level if necessary
    *       o   Insert a Pending Notification as follows
    *           §   If this is for a Campaign, populate the Campaign and Message
    *           §   Else, populate the Give, Criteria, and the Message
    *       o   Clear the Send Notifications checkbox
    */
    
    public static void CheckGive(List<Give__c> gives){
        
        List<Pending_Notification__c> notifications = new List<Pending_Notification__c>();
        Boolean isValid = true;
        Boolean isNational = false;
        String states = '';
        String zipCode = '';
        for(Give__c theGive: gives){
            if(theGive.Message_Text__c != null){
                if(theGive.Notification_Take_Defaults__c){
                    isNational = theGive.National_Give__c;
                    states = theGive.Location_by_State_s__c;
                    zipCode = theGive.Zip_Code_s__c;
                }else if(   (theGive.State__c != null && !theGive.National__c && theGive.Zip_Code__c == null) ||
                            (theGive.State__c == null && theGive.National__c && theGive.Zip_Code__c == null) ||
                            (theGive.State__c == null && !theGive.National__c && theGive.Zip_Code__c != null) ){
                    isNational = theGive.National__c;
                    states = theGive.State__c;
                    zipCode = theGive.Zip_Code__c;
                }else {
                    isValid = false;
                    theGive.State__c.addError('At least ONE of these location fields must be used: Zip Code -OR- State -OR- National.');
                }
            }else {
                theGive.Message_Text__c.addError('The Message Text is required if the Send Notification is enabled.');
                if( (theGive.State__c != null && !theGive.National__c && theGive.Zip_Code__c == null) ||
                    (theGive.State__c == null && theGive.National__c && theGive.Zip_Code__c == null) ||
                    (theGive.State__c == null && !theGive.National__c && theGive.Zip_Code__c != null) ){
                    isValid = false;
                    theGive.State__c.addError('At least ONE of these location fields must be used: Zip Code -OR- State -OR- National.');    
                }
            }
                        
            if(isValid){
                Pending_Notification__c pN = new Pending_Notification__c();
                pN.Message_Text__c = theGive.Message_Text__c;
                pN.Distance__c = theGive.Distance__c;
                
                if(theGive.Campaign__c != null){
                    pN.Campaign__c = theGive.Campaign__c;
                }else {
                    pN.Give__c = theGive.Id;
                    pN.National__c = isNational;
                    pN.State__c = states;
                    pN.Zip_Code__c = zipCode;
                }
            
                notifications.add(pN);
            }
        }
        try{
            insert notifications;
        }catch(DmlException e){
            System.debug(e.getMessage());
        }
    }
    
    private class NotificationException extends Exception{}
}