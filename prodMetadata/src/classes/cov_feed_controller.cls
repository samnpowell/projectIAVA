public with sharing class cov_feed_controller {

    public Map<String, String> imageIdToLargeImageMap {
        get {
            populateFeedPages();
            if (showBigPhotosInFeed) {
                Map<string, string> returnMap = generateImageMap(feedPageOfFiles);
                returnMap.putAll(generateImageMapFromComments(feedPageOfNews));
                return returnMap;
            } else {
                return null;
            }
        }
    }
    public Map<String, String> eventIdToLargeImageMap {
        get {
            populateFeedPages();
            if (showBigPhotosOnEventLinkPosts) {
                return getImageMapForEventPosts(feedPageOfNews);
            } else {
                return null;
            }
        }
    }
    public Boolean showBigPhotosInFeed {get; set;}
    public Boolean showBigPhotosOnEventLinkPosts {get; set;}
    private transient ConnectApi.FeedElementPage feedPageOfFiles { get; set; }
    private transient ConnectApi.FeedElementPage feedPageOfNews { get; set; }


    public Boolean inEveryoneGroup {
        get {
            if (inEveryoneGroup == null) {
                return checkIfInEveryoneGroup();
            } else {
                return inEveryoneGroup;
            }
        }
    }

    public Boolean isMobile {
        get {
            return cov_user_utility.self.isMobile();
        }
    }

    public Id entityIdPassedIn {get; set;}


	public cov_feed_controller() {

		//instantiateMap();

		IAVA_switches__c sw_big_photos = IAVA_switches__c.getInstance('myIAVA_feed_big_photos');
        showBigPhotosInFeed = sw_big_photos == null || !sw_big_photos.Disable__c ? true : false;
		IAVA_switches__c sw_event_photos = IAVA_switches__c.getInstance('myIAVA_feed_big_photos_on_event_links');
        showBigPhotosOnEventLinkPosts = sw_event_photos == null || !sw_event_photos.Disable__c ? true : false;

    }

    public void populateFeedPages() {
        if (feedPageOfNews == null && (showBigPhotosInFeed || showBigPhotosOnEventLinkPosts)) {
            feedPageOfNews = getFirstPageOfNewsPosts();
        }
        if (feedPageOfFiles == null && showBigPhotosInFeed) {
            feedPageOfFiles = getFirstPageOfFilePosts();
        }

    }


    private ConnectApi.FeedElementPage getFirstPageOfFilePosts(){
        system.debug('entityIdPassedIn: ' + entityIdPassedIn);
        Id theId;
        ConnectApi.FeedType type;
        if (entityIdPassedIn == null) {
            theId = UserInfo.getUserId();
            type = ConnectApi.FeedType.Files;
        } else {
            theId = entityIdPassedIn;
            type = ConnectApi.FeedType.Record;
        }
        return ConnectApi.ChatterFeeds.getFeedElementsFromFeed(cov_user_utility.self.getNetworkId(), type, theId);
    }

    private ConnectApi.FeedElementPage getFirstPageOfNewsPosts(){
        return ConnectApi.ChatterFeeds.getFeedElementsFromFeed(cov_user_utility.self.getNetworkId(), ConnectApi.FeedType.News, UserInfo.getUserId());
    }


    private Map<String, String> generateImageMap(ConnectApi.FeedElementPage feedPage){
        Map<String, String> returnMap = new Map<String, String>();
        for(ConnectApi.FeedElement elem : feedPage.elements){
            if(elem.capabilities != null && elem.capabilities.content != null){
				String targetFullImageUrl;
		    	if (elem.capabilities.content.thumb720By480RenditionStatus == 'Success') {
		    		targetFullImageUrl = elem.capabilities.content.renditionUrl720By480;
		    	} else {
		    		targetFullImageUrl = elem.capabilities.content.downloadUrl;
		    	}
		    	//system.debug('elem.capabilities.content.fileType: ' + elem.capabilities.content.fileType);
		    	if (elem.capabilities.content.fileType.startsWith('Image')) {
		    		returnMap.put(elem.Id, targetFullImageUrl);
		    	}                
            }
        }
        return returnMap;
    }

    private Map<String, String> generateImageMapFromComments(ConnectApi.FeedElementPage feedPage){
        Map<String, String> returnMap = new Map<String, String>();
        for(ConnectApi.FeedElement elem : feedPage.elements){
            if(elem.capabilities != null 
            	&& elem.capabilities.comments != null
            	&& elem.capabilities.comments.page != null 
            	&& elem.capabilities.comments.page.items != null
            	){
            	system.debug('COMMM: this one has ' + elem.capabilities.comments.page.items.size() + ' comment(s)');
            	for(ConnectApi.Comment com : elem.capabilities.comments.page.items) {
            		if(com.type == ConnectApi.CommentType.ContentComment && com.capabilities != null && com.capabilities.content != null) {
	            	system.debug('COMMM: this comment is an image');
            			String targetFullImageUrl;
				    	if (com.capabilities.content.thumb720By480RenditionStatus == 'Success') {
				    		targetFullImageUrl = com.capabilities.content.renditionUrl720By480;
				    	} else {
				    		targetFullImageUrl = com.capabilities.content.downloadUrl;
				    	}
				    	if (com.capabilities.content.fileType.startsWith('Image')) {
				    		returnMap.put(com.capabilities.content.versionId, targetFullImageUrl);
			            	system.debug('the filetype is an image');
			            	system.debug('com.capabilities.content.versionId: ' + com.capabilities.content.versionId);
			            	system.debug('targetFullImageUrl: ' + targetFullImageUrl);
				    	}                
				    	else {
				    		system.debug('filetype wasnt an image');
				    	}
            		}
            		else {
            			system.debug('COMMM: this comment is not an image');
            		}
            	}
            } 
            else {
            	system.debug('COMMM: this one did not have comments');
            }
        }
        return returnMap;
    }

    private Map<String, String> getImageMapForEventPosts(ConnectApi.FeedElementPage feedPage){

		String SEARCH_STRING = 'cov_event?id='; // search link for this string to determine Event post

    	Set<String> eventIdsForPics = new Set<String>();
        for(ConnectApi.FeedElement elem : feedPage.elements){
            if(elem.capabilities != null && elem.capabilities.link != null){
            	system.debug('it is a linkPost');
				String theLink = elem.capabilities.link.url;
		    	if (theLink.contains(SEARCH_STRING)) {
		    		String rightSideOfLink = theLink.substringAfter(SEARCH_STRING);
		    		if (!String.isEmpty(rightSideOfLink)) {
		    			List<String> linkSegments = rightSideOfLink.split('&');
		    			if (linkSegments.size() > 0) {
		    				eventIdsForPics.add(linkSegments[0]);
		    			}
		    		}
		    	}
            }
        }

        if (eventIdsForPics.size() > 0) {
        	return cov_events_controller.getPicsForEventsById(eventIdsForPics);
        } else {
            return null;
        }

    }

    public Boolean checkIfInEveryoneGroup() {
        List<CollaborationGroupMember> gpms = [
            select Id from CollaborationGroupMember 
            where MemberId = :UserInfo.getUserId()
            and CollaborationGroup.NetworkId = :cov_user_utility.self.getNetworkId()
            and CollaborationGroup.Name = 'Everyone!'
            ];
        return gpms != null && gpms.size() > 0;
    }




}