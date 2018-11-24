public without sharing class cov_recentactivity_controller {

    public String theC { get; set; }

	public static Integer MAX_POSTS = 6;
	public static Integer MAX_POSTS_FROM_SINGLE_USER = 2;
	public static Integer POST_PREVIEW_CHAR_LENGTH = 100;
	public static Integer POST_MAX_WORD_LENGTH = 30;

	public static set<string> disallowedtypes = new set<string>{'TrackedChange','CreateRecordEvent','CollaborationGroupCreated'};
	public static set<string> disallowedscopes = new set<string>{null, 'AllNetworks'};


	public List<customGroupedPost> posts {get; set;}

    //public transient List<cov_image_gallery_controller.ChatterImage> images { get; set; }

    public transient Map<Id, User> userMap;


	public cov_recentactivity_controller() {
		
		posts = getRecentGroupedPosts();
		// disabled until we bring back a photos widget
		//images = new cov_image_gallery_controller().getImages();

	}

	public Boolean getIsMobile() {
		return cov_user_utility.self.getIsMobile();
	}

	public class customPost {
		public Id feedItemId {get; private set;}
		public String body {get; private set;}
		public String bodyShortened {get; private set;}
		public Id creatorId {get; private set;}
		public String creatorPublicName {get; private set;}
		public String creatorPublicNameNonBreaking {get; private set;}
		public Id parentId {get; private set;}
		public String smallPhotoUrl {get; private set;}
		public customPost(Id feedItemIdIn, String bodyIn, Id creatorIdIn, String creatorFirstNameIn, String creatorLastNameIn, Id parentIdIn, String smallPhotoUrlIn) {
			feedItemId = feedItemIdIn;
			body = bodyIn;
			Boolean truncatedFlag = false;
			creatorId = creatorIdIn;
			creatorPublicName = creatorFirstNameIn + ' ' + creatorLastNameIn.left(1) + '.';
			creatorPublicNameNonBreaking = creatorFirstNameIn + '&nbsp;' + creatorLastNameIn.left(1) + '.';
			parentId = parentIdIn;
			smallPhotoUrl = smallPhotoUrlIn;

			//System.debug('about to check body.length() for body: ' + body);

			if (body != null && body.length() > POST_PREVIEW_CHAR_LENGTH) {
				//System.debug('body.length(): ' + body.length());
				//System.debug('body too long, must be shortened');
				bodyShortened = body.left(POST_PREVIEW_CHAR_LENGTH);
				truncatedFlag = true;
			} else {
				//System.debug('body not too long');
				bodyShortened = body;
			}
			//System.debug('Finishing checking body length');
			Boolean longWordFlag = false;
			String bodyShortenedPiecedBackTogether = '';
			List<String> bodyWords = bodyShortened == null ? new List<String>() : bodyShortened.split('[\n\r ]');
			//System.debug('bodywords: ' + bodywords);
			for (String s : bodyWords) {
				//System.debug('String s: ' + s);
				if (s.length() > POST_MAX_WORD_LENGTH) {
					//System.debug('s.length: ' + s.length() + ' was greater than POST_MAX_WORD_LENGTH: ' + POST_MAX_WORD_LENGTH);
					s = s.left(POST_MAX_WORD_LENGTH - 7) + '...' + s.right(4);
					longWordFlag = true;
				}
				bodyShortenedPiecedBackTogether += s + ' ';
			}
			if (longWordFlag) {
				bodyShortened = bodyShortenedPiecedBackTogether.trim();
			}
			if (truncatedFlag) { 
				bodyShortened += '...';
			}
		}
	}

	public class customGroupedPost {
		// CustomPosts grouped together with parent Group
		public CollaborationGroup g {get; set;}
		public List<customPost> postList {get; set;}
		public Boolean isMember {get; set;}
        public Boolean isOwner {get; set;}
        public Boolean isPrivate {get; set;}

		public customGroupedPost() {
			//plist = new List<FeedItem>();
			postList = new List<customPost>();
			isMember = false;
			isOwner = false;
			isPrivate = false;
		}
	}


	public List<customGroupedPost> getRecentGroupedPosts() {

		Id uID = UserInfo.getUserId();

		// Pull recent feedItems from Groups not by the current user
		List<FeedItem> fs =
			[select id, body, type, linkurl, networkScope, CreatedById, createdBy.Name, createdBy.FirstName, createdBy.LastName, CreatedDate, CommentCount, ParentId, parent.name 
			from FeedItem 
			WHERE isDeleted = false 
			AND (type != :disallowedtypes) 
			AND (NetworkScope != :disallowedscopes) 
			AND Parent.Type = 'CollaborationGroup'
			AND CreatedById != :uID
			AND ParentId not in (select Id from CollaborationGroup where Name like '[Event]%')
			ORDER BY CreatedDate 
			DESC LIMIT 100];
		System.debug('fs: ' + fs);

				//// also pull feedcomments
				//,(select id, commentbody, commenttype, CreatedById, createdBy.Name, createdBy.FirstName, createdBy.LastName, CreatedDate, ParentId from FeedComment 
				//	WHERE isDeleted = false 
				//	ORDER BY CreatedDate 
				//	DESC LIMIT 5)



		Set<Id> userIds = new Set<Id>();
		Set<Id> groupIds = new Set<Id>();
		for (FeedItem f : fs) {
			userIds.add(f.CreatedById);
			groupIds.add(f.ParentId);
		}
		//System.debug('userIds: ' + userIds);
		//System.debug('groupIds: ' + groupIds);

		// now get the groups
		List<CollaborationGroup> groupList = 
			[select id, Name, Owner.Name, Owner.Id, CollaborationType, MemberCount, 
            SmallPhotoUrl, Description, LastFeedModifiedDate 
            from CollaborationGroup 
			where Id in :groupIds
            ];
        //System.debug('groupList: ' + groupList);

        // and the groupmembers
		List<CollaborationGroupMember> groupMemberships = [select CollaborationGroupId, MemberId
                                          from CollaborationGroupMember 
                                          where MemberId = :uID
                                          and CollaborationGroupId in :groupIds
                                          ];
        //System.debug('groupMemberships: ' + groupMemberships);
                                          
        set<Id> groupMemberset = new set<Id>(); 
        For(CollaborationGroupMember cgm : groupMemberships){ 
            groupMemberset.add(cgm.CollaborationGroupId); 
        } 
        //System.debug('groupMemberset: ' + groupMemberset);


     	// create a map to access customGroupedPosts by groupId
		Map<Id, customGroupedPost> groupedPostsLibrary = new Map<Id, customGroupedPost>();

        // iterate through the groups and if user has access add the group 
        // to the customGroupedPostsLibrary map while also setting group properties
        for (CollaborationGroup g : groupList) {
        	//customGroupedPost gee = groupedPosts.get(g.Id);
        	customGroupedPost gee = new customGroupedPost();
        	gee.g = g;
        	if(groupMemberset.contains(g.Id)) {
                gee.isMember = true;
            } 
            if(g.Owner.Id == uID) {
                gee.isOwner = true;
            }
            // if it's a private group and the user is not a member then remove from map to avoid displaying private groups
            if(g.CollaborationType == 'Private' || g.CollaborationType == 'Unlisted') {
                gee.isPrivate = true;
            //    if (!gee.isMember && !gee.isOwner) {
            //    	groupedPosts.remove(g.Id);
            //    }
            }
            if (!gee.isPrivate || gee.isMember || gee.isOwner) {
            	groupedPostsLibrary.put(g.Id, gee);
            }
        }
        System.debug('groupedPostsLibrary: ' + groupedPostsLibrary);


     	// create a map to hold final results
		Map<Id, customGroupedPost> groupedPosts = new Map<Id, customGroupedPost>();

		// create a map of feedItem creator userIds to users
		Map<ID, User> userMap = new Map<ID, User>([select SmallPhotoUrl from User where Id in :userIds]);
		System.debug('userMap: ' + userMap);

		// create a map to count how many posts displayed from each user
		Map<ID, Integer> userPostCountMap = new Map<Id, Integer>();
		for (Id i : userMap.keySet()) {
			userPostCountMap.put(i, 0);
		}
        //System.debug('userPostCountMap: ' + userPostCountMap);		


		Integer numPostsAdded = 0;

		// iterate through posts grabbing groupIds, creatorIds, and adding posts to the customGroupedPosts map
		for (Integer i = 0; i < fs.size() && numPostsAdded < MAX_POSTS; i++) {
			System.debug('looping i=' + i);

			//System.debug('fs[i].ParentId: ' + fs[i].ParentId);

			Id gId = fs[i].ParentId;

			if (groupedPostsLibrary.containsKey(gId) && userPostCountMap.get(fs[i].CreatedById) < MAX_POSTS_FROM_SINGLE_USER) {

				// if it's a new group, add another entry to the customGroupedPosts map
				if (!groupedPosts.containsKey(gId)) {
					//System.debug('new group. gId: ' + gId);
					groupedPosts.put(gId, groupedPostsLibrary.get(gId));
					//groupedPosts.get(gId).aaa_sortOrder = i;
				}
				// add the customPost
				System.debug('Creating a new custom post with fs[i].Id=' + fs[i].Id 
					+ ' and fs[i].Body=' + fs[i].Body
					+ ' and fs[i].CreatedById=' + fs[i].CreatedById
					+ ' and fs[i].CreatedBy.FirstName=' + fs[i].CreatedBy.FirstName
					+ ' and fs[i].CreatedBy.LastName=' + fs[i].CreatedBy.LastName
					+ ' and gId=' + gId
					+ ' and userMap.get(fs[i].CreatedById).SmallPhotoUrl=' + userMap.get(fs[i].CreatedById).SmallPhotoUrl
					);
				String bodyAdjusted;
				if (fs[i].body == null && fs[i].LinkURL != null) {
					bodyAdjusted = fs[i].LinkURL;
				} else {
					bodyAdjusted = fs[i].body;
				}
				groupedPosts.get(gId).postList.add(
					new customPost(fs[i].Id, bodyAdjusted, fs[i].CreatedById, fs[i].CreatedBy.FirstName, fs[i].CreatedBy.LastName, gId, userMap.get(fs[i].CreatedById).SmallPhotoUrl)
				);
				userPostCountMap.put(fs[i].CreatedById, userPostCountMap.get(fs[i].CreatedById)+1);
				numPostsAdded++;
			}
		}

        
        List<customGroupedPost> cgps = groupedPosts.values();
//        cgps.sort(); // should sort by aaa_sortOrder since it's alphabetically first
        return cgps;

	}

	public PageReference refresh() {
		posts = getRecentGroupedPosts();
		//images = new cov_image_gallery_controller().getImages();
		return null;
	}


}