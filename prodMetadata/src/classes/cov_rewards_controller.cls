public without sharing class cov_rewards_controller {

    public static Integer NUM_REWARDS_ON_DASHBOARD = 5;
    //public static String SEARCH_RADIUS_STR = '50'; //miles
    public static Double SEARCH_RADIUS = 50; //miles

    public static String conId {get; set;}

    public Give__c g { get; set; }
	//public RewardUtilities.Reward r { get; set; }
	public string addrDet { get; set; }
    public string addrStreet { get; set; }    
    public string venue { get; set; }

    //public List<Give__c> standardRewardsOld {get; set;}
    //public List<Give__c> eventRewardsOld {get; set;}
    //private List<Give__c> rewardsOld {get; set;}
    public List<customReward> standardRewards {get; set;}
    public List<customReward> eventRewards {get; set;}
    //public List<RewardUtilities.Reward> rewardsNew {get; set;}
    public List<customReward> rewards {get; set;}

    //public Boolean hasRewards {get; set;}
    //public Boolean hasEventRewards {get; set;}
    //public Boolean hasStandardRewards {get; set;}

	public cov_rewards_controller(){

		if (conId == null) {
			conId = cov_user_utility.self.getCId();
        }


        if (rewards == null) {
            rewards = getRewards();
        }

    /*		
				
		 // Below is the logic to display "Where:" details in Reward Detail page
		 // lifted from dc_ctrl_RewardDetail
                addrDet = '';
                venue = '';
                addrStreet = '';
                if(g.Location_Description__c != null)
                {
                    venue = g.Location_Description__c;
                    if(g.City__c != null)
                        addrDet = g.City__c;
                    if(g.City__c != null && g.Zip_Code_s__c != null)
                        addrDet = addrDet + ', ';
                    if(g.Zip_Code_s__c != null)
                        addrDet = addrDet + g.Zip_Code_s__c;
                    if(g.Location_Street_Address__c != null)
                        addrStreet = g.Location_Street_Address__c;
                }
     */
		
	}

	public Give__c getGive() {
		return g;
	}
	
	public List<Give__c> getGiveList() {
		List<Give__c> givelist = new List<Give__c>();
		givelist.add(g);
		return givelist;
		
	}

    public class customRewardRequest {
        public Id grId { get; private set; }
        public String giveName { get; private set; }
        public String stage { get; private set; }
        public String attended { get; private set; }
        public String publicStage {get; private set;}
        public Date instanceStartDate {get; private set; }

        public customRewardRequest(Id grIdIn, String gnameIn, String stageIn, String attendedIn, Date startDateIn) {
            grId = grIdIn;
            giveName = gnameIn;
            stage = stageIn;
            attended = attendedIn;
            instanceStartDate = startDateIn;
    
            if (attendedIn == 'Yes') {
                publicStage = 'Attended';
            } else if (attendedIn == 'No') {
                publicStage = 'Did not attend';
            } else if (stageIn == 'Give requested') {
                publicStage = 'Requested';
            } else if (stageIn == 'Ineligible' || stageIn == 'Denied') {
                publicStage = 'Did not get reward';
            } else {
                publicStage = stageIn;
            }
        }
    }

            public List<customRewardRequest> customRequestList(List<Give_Request__c> requestList) {
            List<customRewardRequest> crs = new List<customRewardRequest>();
            for (Give_Request__c gr : requestList) {
                crs.add(new customRewardRequest(gr.Id, gr.Give_Name__c, gr.Stage__c, gr.Attended__c, gr.Give_Instance_Start_Date__c));
            }
            return crs;
        }


    //public String publicRequestStage(String stage, String attended) {
    //    String ps;
    //    if (attended == 'Yes') {
    //        ps = 'Attended';
    //    } else if (attended == 'No') {
    //        ps = 'Did not attend';
    //    } else if (stage == 'Give requested') {
    //        ps = 'Requested';
    //    } else if (stage == 'Ineligible' || stage == 'Denied') {
    //        ps = 'Did not get reward';
    //    } else {
    //        ps = stage;
    //    }
    //    return ps;
    //}

    //public List<Give_Request__c> getGiveRequests() {

    //    return [select Id, Give_Name__c, Stage__c, Attended__c, Give_Instance_Start_Date__c from Give_Request__c 
    //                where Applicant__c=:conId order by Give_Instance_Start_Date__c DESC];
    //}

    public List<customRewardRequest> getRewardRequests() {

        return customRequestList([select Id, Give_Name__c, Stage__c, Attended__c, Give_Instance_Start_Date__c from Give_Request__c 
                    where Applicant__c=:conId order by Give_Instance_Start_Date__c DESC]);
    }



    //public List<Give__c> getRewardsOld(){
    
    //    List<Give__c> glist = new List<Give__c>();

    //    glist = [select id, Name, Location_Formula__c, Category__c,
    //              (select id From Attachments where Name like '%logo%' limit 1)
    //              from Give__c where Highlight_Listing__c = true limit :NUM_REWARDS_ON_DASHBOARD];
    //    System.debug('glist: ' + glist);

    //    standardRewardsOld = new List<Give__c>();
    //    eventRewardsOld = new List<Give__c>();
    //    for (Give__c g : glist) {
    //        if (g.Category__c == 'Events') {
    //            eventRewardsOld.add(g);
    //        } else {
    //            standardRewardsOld.add(g);
    //        }
    //    }

    //    //hasRewards = (glist.size() > 0) ? true : false;
    //    //hasEventRewards = (eventRewards.size() > 0) ? true : false;
    //    //hasStandardRewards = (standardRewards.size() > 0) ? true : false;

    //    return glist;
                        
    //}  

    //public List<customReward> getRewards_using_RewardUtilities(){

    //    ////FROM RewardUtilities, pasted here for reference:
    //    //public static List<Reward> SearchRewards(
    //    //    String PartnerID, String GiveID, String InstanceID,         // Main Criteria - Partner, Give, Instance ID
    //    //    Boolean DeDupByGiveID,                                      // Return Single Instance Per Give 
    //    //    Set<String> GiveStatus, Set<String> InstanceStatus,         // Give Status and Instance Status ...
    //    //    String ZipCode, String Distance,                            // Zip Code and Distance ...
    //    //    String LAT, String LON,                                     // Latitude and Longitude ...
    //    //    Integer records)                                            // LIMIT on returned rows (further limited by DeDup)


    //    Contact c = cov_user_utility.self.getC();
    //    Set<String> status = new Set<String>{'Open', 'Waitlist'};
    //    //System.debug

    //    //List<RewardUtilities.Reward> rewardlist = RewardUtilities.SearchRewards(null, null, null, true, status, status, c.MailingPostalCode, SEARCH_RADIUS, null, null, NUM_REWARDS_ON_DASHBOARD);
    //    List<RewardUtilities.Reward> rewardlist = RewardUtilities.SearchRewards(null, null, null, true, status, status, null, SEARCH_RADIUS_STR, c.MA_Latitude__c.toPlainString(), c.MA_Longitude__c.toPlainString(), NUM_REWARDS_ON_DASHBOARD);

    //    rewards = new List<customReward>();
    //    for (RewardUtilities.Reward r : rewardlist) {
    //        rewards.add(new customReward(r));
    //    }

    //    standardRewards = new List<customReward>();
    //    eventRewards = new List<customReward>();
    //    for (customReward r : rewards) {
    //        if (r.Category == 'Events') {
    //            eventRewards.add(r);
    //        } else {
    //            standardRewards.add(r);
    //        }
    //    }

    //    return rewards;

    //}

    public List<customReward> getRewards(){

        Contact c = cov_user_utility.self.getC();
        Set<String> status = new Set<String>{'Open', 'Waitlist'};

        List<Give__c> glist = new List<Give__c>();
        String criteria = 'WHERE Status__c in (\'Open\', \'Waitlist\')'
                        + ' AND (National_Give__c = TRUE';

        if (c != null) {

            // LAT/LON CRITERIA
            Double lat = c.MA_Latitude__c;
            Double lon = c.MA_Longitude__c;
            if (lat != null && lon != null) {

                Double DST = SEARCH_RADIUS;
                Double Delta = DST / 69;
                System.debug('Delta: ' + Delta);
                Double minLAT = LAT - Delta;  
                Double maxLAT = LAT + Delta;
                Double minLON = LON - Delta;
                Double maxLON = LON + Delta;
                System.Debug('GEO Search: LAT: ' + minLAT + ' - ' + maxLAT + ' LON: ' + minLON + ' - ' + maxLON);

                criteria += ' OR (' 
                        + ' Geo_location__r.lat__c>=' + minLAT
                        + ' and Geo_location__r.lat__c<=' + maxLAT
                        + ' and Geo_location__r.lon__c>=' + minLON
                        + ' and Geo_location__r.lon__c<=' + maxLON
                        + ')';
            }

            // STATE CRITERIA
            if (c.MailingState != '' && c.MailingState != null) {
                criteria += ' OR ('
                        + 'Location_by_State_s__c includes (\'' + c.MailingState + '\')'
                        + ')';
            }
            
        }

        criteria += ')';

        String giveQuery = 
            'SELECT id, Name, Location_Formula__c, Category__c,'
            + ' (select id, Name From Attachments)'
            + ' FROM Give__c '
            + criteria
            + ' ORDER BY Location_Sort__c'
            + ' LIMIT ' + NUM_REWARDS_ON_DASHBOARD;

            System.debug('criteria: ' + criteria);
            System.debug('giveQuery: ' + giveQuery);

        try {
            glist = Database.query(giveQuery);
        } catch (Exception e) {cov_log_error.logError(e);}

        System.debug('glist: ' + glist);


        if (glist.size() < NUM_REWARDS_ON_DASHBOARD) {
            Set<Id> existingIds = (new Map<Id,SObject>(glist)).keySet();
            List<Give__c> highlightedGives = [select id, Name, Location_Formula__c, Category__c,
                  (select id, Name From Attachments)
                  from Give__c where Highlight_Listing__c = true 
                  and Id not in :existingIds
                  limit :NUM_REWARDS_ON_DASHBOARD];
            System.debug('highlightedGives not already in list: ' + highlightedGives);
            for (Give__c g : highlightedGives) {
                if (glist.size() < NUM_REWARDS_ON_DASHBOARD) {
                    glist.add(g);
                }
            }
            System.debug('glist: ' + glist);
        }

        rewards = new List<customReward>();
        for (Give__c g : glist) {
            rewards.add(new customReward(g));
        }

        standardRewards = new List<customReward>();
        eventRewards = new List<customReward>();
        for (customReward r : rewards) {
            if (r.Category == 'Events') {
                eventRewards.add(r);
            } else {
                standardRewards.add(r);
            }
        }

        return rewards;
    }




    public class customReward {
        public Id GiveId {get; set;}
        public String Title {get; set;}
        public String LocationFormula {get; set;}
        public String ImageURL {get; set;}
        public String Category {get; set;}
        //public customReward(RewardUtilities.Reward r) {
        //    GiveId = r.GiveId;
        //    Title = r.Title;
        //    LocationFormula = r.LocationFormula;
        //    ImageURL = r.Image;
        //    Category = r.Category;
        //}
        public customReward(Give__c g) {
            GiveId = g.Id;
            Title = g.Name;
            LocationFormula = g.Location_Formula__c;
            Category = g.Category__c;
            if (g.Attachments.size()>0) {
                //ImageURL = '/servlet/servlet.FileDownload?file=' + g.Attachments[0].id;

                List<String> imageIds = cov_utilities.parseImagesFromAttachments(g.Attachments);
                if (!String.isEmpty(imageIds[1])) {
                    ImageURL = 'servlet/servlet.FileDownload?file=' + imageIds[1];
                } else if (!String.isEmpty(imageIds[0])) {
                    ImageURL = 'servlet/servlet.FileDownload?file=' + imageIds[0];
                }

            }
        }
    }

}