public with sharing class cov_people_controller {

	public static User u;

	// declare as public var so can check whether to display section and then display without repeating queries twice
    public list<FeaturedPerson> featuredPeople;


	public cov_people_controller() {

        if (u == null) {
			u = cov_user_utility.self.getU();
        }
        System.debug('u.SmallPhotoUrl: ' + u.SmallPhotoUrl);
    }
    
    public User getU() {
        if (u == null) {
			u = cov_user_utility.self.getU();
        }
        return u;
    }

    public class FeaturedPerson {
        public id uid { get; private set; }
        public string smallPhotoUrl { get; private set; }
        public string fullName { get; private set; }
        public string orgName { get; private set; }
        public Boolean displayFollowTag {get; private set; }

        public FeaturedPerson(id userid,string url,string personName,string organizationName) {
            uid = userid;
            smallPhotoUrl = url;
            fullName = personName;
            orgName = organizationName;

			// Keep track of which chatter follow tags have been
			// displayed so as not to trigger a VF error by
			// displaying one for the same entity twice
			displayFollowTag = cov_user_utility.self.displayFollowTagChecker(uid);

            System.debug('displayFollowTag: ' + displayFollowTag);
        }
    }

    public list<FeaturedPerson> getPeople(){
    	
    	if (featuredPeople == null) {

			Id theNetworkId = cov_user_utility.self.getNetworkId();

	        
	        //find a list of users that the running user is already following
	        Set<Id> peopleIFollow = new Set<id>();
	        
	        for (EntitySubscription es : [SELECT parentId FROM EntitySubscription 
	        							  WHERE 
	        							  NetworkId = :theNetworkId AND
	                                      subscriberId = :u.Id
	                                      limit 1000]) {
	            peopleIFollow.add(es.parentId);
	        }
	        system.debug('PEOPLE FOLLOWED: ' + peopleIFollow);
	
	        
	        //fetch the most active users in the community
	        list<ChatterActivity> activities = [SELECT ParentId FROM ChatterActivity 
	                                            WHERE 
	                                            NetworkId = :theNetworkId AND 
	                                            ParentId NOT IN :peopleIFollow AND
	                                            ParentId in (SELECT MemberId FROM NetworkMember where NetworkId = :theNetworkId)
	                                            ORDER BY InfluenceRawRank ASC 
	                                            LIMIT 5];
	        system.debug('INFLUENTIAL USERS: ' + activities);
	        set<id> activeUserIds = new set<id>();
	        for (ChatterActivity a : activities) {
	            activeUserIds.add(a.ParentId);
	        }
	        system.debug('activeUserIds: ' + activeUserIds);

	        //// make sure the user is still in the network
	        //set<id> activeUserIdsInNetwork = new set<id>();
	        //for (NetworkMember nm : [SELECT MemberId FROM NetworkMember where MemberId in :activeUserIds AND NetworkId = :theNetworkId]) {
	        //	activeUserIdsInNetwork.add(nm.MemberId);
	        //}
	        
	        featuredPeople = new list<FeaturedPerson>();
	        map<id,User> featuredUsers = new map<id,User>(
	            [SELECT id,FirstName,LastName,SmallPhotoUrl,CompanyName 
	             FROM User 
	             WHERE id IN :activeUserIds 
	             AND IsActive = true
	             AND (id != :u.Id)
	             AND (id NOT IN :peopleIFollow)
	             AND Don_t_Feature_on_COV__c = false
	             //AND (NOT SmallPhotoUrl LIKE '/profilephoto/005/T')
	             LIMIT 5]
	            );
	        system.debug('USERS QUERIED: ' + featuredUsers);
	       
	        for (User uzr : featuredUsers.values()) {
	            FeaturedPerson person = new FeaturedPerson(uzr.id,uzr.SmallPhotoUrl,uzr.FirstName + ' ' + uzr.LastName,uzr.CompanyName);
	            featuredPeople.add(person);
	        } 
    	}
        return featuredPeople;
    }

}