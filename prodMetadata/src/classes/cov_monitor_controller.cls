/*
	This controller/page originally created by Nick Bailey for the Power of Us Hub and used by permission
*/

public without sharing class cov_monitor_controller {


	public list<FeedItem> ignoredChatter {get;set;}
	public list<FeedItem> popularChatter {get;set;}
	public list<FeedItem> recentChatter {get;set;}
	public list<FeedItem> myCustomerChatter {get;set;}

	public list<CollaborationGroup> recentGroups {get;set;}

	public list<User> recentMembers {get;set;}

	public map<id, string> groupNameMap {get;set;}

	public id networkId {get;set;}

	public integer chatterPostsToday {get;set;}
	public integer chatterCommentsToday {get;set;}
	public integer questionsToday {get;set;}
	public integer answersToday {get;set;}

	public static set<string> disallowedtypes = new set<string>{'TrackedChange','CreateRecordEvent','CollaborationGroupCreated'};
	public static set<string> disallowedscopes = new set<string>{null, 'AllNetworks'};

	public cov_monitor_controller() {
		
		networkId = Network.getNetworkId();
		getGroupNames();
		ignoredChatter = getRecentIgnoredChatter();
		popularChatter = getPopularChatter();
		recentChatter = getRecentChatter();
		recentGroups = getRecentGroups();
		recentMembers = getRecentMembers();
		myCustomerChatter = getMyCustomerChatter();
		getTodaysStats();
	}

	public list<FeedItem> getRecentIgnoredChatter(){
		return [select id, body, type, networkScope, createdBy.Name, CreatedDate, CommentCount, ParentId from FeedItem 
		WHERE commentCount = 0 
		AND isDeleted = false 
		AND (type != :disallowedtypes) 
		AND (NetworkScope != :disallowedscopes) 
		ORDER BY CreatedDate 
		DESC LIMIT 50];
	}

	public list<FeedItem> getPopularChatter(){
		return [select id, body, type, networkScope, createdBy.Name, CreatedDate, CommentCount, ParentId from FeedItem 
		WHERE commentCount > 0 
		AND isDeleted = false 
		AND (type != :disallowedtypes) 
		AND (NetworkScope != :disallowedscopes) 
		ORDER BY commentCount 
		DESC LIMIT 50];
	}

	public list<FeedItem> getRecentChatter(){
		return [select id, body, type, networkScope, createdBy.Name, CreatedDate, CommentCount, ParentId from FeedItem 
		WHERE isDeleted = false 
		AND (type != :disallowedtypes) 
		AND (NetworkScope != :disallowedscopes) 
		ORDER BY CreatedDate 
		DESC LIMIT 50];
	}

	public list<FeedItem> getMyCustomerChatter(){
		return [select id, body, type, networkScope, createdBy.Name, createdById, CreatedDate, CommentCount, ParentId from FeedItem 
		WHERE isDeleted = false 
		AND createdById = :[select id from User where User.Contact.Account.OwnerId = :UserInfo.getUserId() ORDER BY LastLoginDate DESC LIMIT 1000]
		AND (type != :disallowedtypes) 
		AND (NetworkScope != :disallowedscopes) 
		ORDER BY CreatedDate 
		DESC LIMIT 50];
	}

	public map<id, string> getGroupNames(){
		groupNameMap = new map<id, string>();
		list<CollaborationGroup> gg = [select id, name from CollaborationGroup where networkId != null];
		for(CollaborationGroup g :gg){
			groupNameMap.put(g.id, g.name);
		}
		return groupNameMap;
	}

	public list<CollaborationGroup> getRecentGroups(){
		return [select id, name, smallPhotoUrl from CollaborationGroup where networkId = :networkId ORDER BY CreatedDate DESC LIMIT 10];

	}

	public list<User> getRecentMembers(){
		return [select id, name, companyname, smallPhotoUrl from User where id in (select memberId from NetworkMember where networkId = :networkId) 
		// AND UserType = 'PowerPartner' 
		ORDER BY CreatedDate DESC LIMIT 10 ];
	}

	public void getTodaysStats(){
		chatterPostsToday = [select count() from FeedItem 
			WHERE isDeleted = false 
			AND (type != :disallowedtypes) 
			AND (NetworkScope != :disallowedscopes) 
			AND CreatedDate >= :Date.TODAY()];
		chatterCommentsToday = [select count() from FeedComment 
			WHERE isDeleted = false
			AND CreatedDate >= :Date.TODAY()];
		questionsToday = [select count() from Question 
			WHERE CreatedDate >= :Date.TODAY()];
		answersToday = [select count() from Reply 
			WHERE CreatedDate >= :Date.TODAY()];
	}



}