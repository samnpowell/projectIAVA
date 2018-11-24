/* http://jessealtman.com/2014/03/extending-chatter-image-gallery-using-connectapi/ */

@isTest
private class cov_image_gallery_controller_TESTS {

   static testMethod void testEmptyFeed(){
        instantiateMockFeedItems(false);
        
        Test.startTest();
        cov_image_gallery_controller controller = new cov_image_gallery_controller();
        Test.stopTest();
        
        System.assertEquals(0, controller.getImages().size());
    }
    
    static testMethod void testFeedWithItems(){
        instantiateMockFeedItems(true);
        
        Test.startTest();
        cov_image_gallery_controller controller = new cov_image_gallery_controller();
        Test.stopTest();
        
        System.assertEquals(3, controller.getImages().size());
    }
    
    //@IsTest(SeeAllData=true)
    //static void testGetLikesForImage(){
    //    FeedItem item = generateFeedItemWithLikes();
        
    //    Test.startTest();
    //    List<ConnectApi.ChatterLike> chatterLikes;
    //    chatterLikes = cov_image_gallery_controller.getLikesForImage(item.Id);
    //    Test.stopTest();
        
    //    System.assertEquals(1, chatterLikes.size());
    //}
    
    static testMethod void testGetCallsFromChatterImage(){
        ConnectApi.FeedItem mockFeedItem = generateMockFeedItem(true, true);
        ConnectApi.ContentAttachment mockContentAttachment = (ConnectApi.ContentAttachment)mockFeedItem.attachment;
      
        Test.startTest();
        cov_image_gallery_controller.ChatterImage chatterImage = new cov_image_gallery_controller.ChatterImage(mockFeedItem, mockContentAttachment);
       Test.stopTest();
        
        System.assertEquals(mockFeedItem, chatterImage.getItem());
        System.assertEquals(mockContentAttachment, chatterImage.getImage());
    }
    
    private static void instantiateMockFeedItems(Boolean hasFeedItems){
        ConnectApi.FeedItemPage mockFeedItemPage = generateMockFeedItemPage(hasFeedItems);
        ConnectApi.ChatterFeeds.setTestGetFeedItemsFromFeed(cov_user_utility.self.getNetworkId(), ConnectApi.FeedType.Files, UserInfo.getUserId(), mockFeedItemPage);
    }
    
    private static ConnectApi.FeedItemPage generateMockFeedItemPage(Boolean addFeedItems){
        ConnectApi.FeedItemPage mockFeedItemPage = new ConnectApi.FeedItemPage();
        mockFeedItemPage.items = new List<ConnectApi.FeedItem>();
        if(addFeedItems){
            mockFeedItemPage.items = generateMockFeedItems();
        }
        
        return mockFeedItemPage;
    }
    
    private static List<ConnectApi.FeedItem> generateMockFeedItems(){
        List<ConnectApi.FeedItem> mockItems = new List<ConnectApi.FeedItem>();
        mockItems.add(generateMockFeedItem(true, true));
        mockItems.add(generateMockFeedItem(true, false));
        mockItems.add(generateMockFeedItem(false, false));
        mockItems.add(generateMockFeedItem(true, true));
        mockItems.add(generateMockFeedItem(true, true));
        return mockItems;
    }
    
    private static ConnectApi.FeedItem generateMockFeedItem(Boolean hasAttachment, Boolean isImageType){
        ConnectApi.FeedItem mockFeedItem = new ConnectApi.FeedItem();
        if(hasAttachment){
            mockFeedItem.attachment = generateMockContentAttachment(isImageType);
        }
        
        return mockFeedItem;
    }
    
    private static ConnectApi.ContentAttachment generateMockContentAttachment(Boolean isImageType){
        ConnectApi.ContentAttachment mockContentAttachment = new ConnectApi.ContentAttachment();
        if(isImageType){
           mockContentAttachment.mimeType = 'image';   
        }else{
            mockContentAttachment.mimeType = 'pdf';
        }
        
        return mockContentAttachment;
    }
    
    private static FeedItem generateFeedItemWithLikes(){
        FeedItem item = new FeedItem();
        item.Body = 'Test';
        item.ParentId = UserInfo.getUserId();
        insert item;
        
        generateFeedLike(item);
        
        return item;
    }
    
    private static void generateFeedLike(FeedItem item){
        FeedLike fdLike = new FeedLike();
        fdLike.FeedItemId = item.Id;
        insert fdLike;
    }
}