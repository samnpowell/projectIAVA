/* http://jessealtman.com/2014/03/extending-chatter-image-gallery-using-connectapi/ */

public with sharing class cov_image_gallery_controller {

    public transient List<ChatterImage> images;

    public transient Map<Id, User> userMap;
    
   public cov_image_gallery_controller(){
        instantiateImages();
        ConnectApi.FeedItemPage feedPage = getFirstFeedItemPageOfInternalPosts();
        generateImages(feedPage);
    }
    
    private void instantiateImages(){
        images = new List<ChatterImage>();
    }
    
    private ConnectApi.FeedItemPage getFirstFeedItemPageOfInternalPosts(){
        return ConnectApi.ChatterFeeds.getFeedItemsFromFeed(cov_user_utility.self.getNetworkId()	, ConnectApi.FeedType.Files, UserInfo.getUserId());
    }
    
    private void generateImages(ConnectApi.FeedItemPage feedPage){
        for(ConnectApi.FeedItem item:feedPage.items){
            if(doesFeedItemContainContentAttachment(item)){
                ifAttachmentIsImageAddToList(item);
            }
        }
    }
    
    private Boolean doesFeedItemContainContentAttachment(ConnectApi.FeedItem item){
        return item.attachment != null && item.attachment instanceOf ConnectApi.ContentAttachment;
    }
    
    private void ifAttachmentIsImageAddToList(ConnectApi.FeedItem item){
        ConnectApi.ContentAttachment image = (ConnectApi.ContentAttachment)item.attachment;
        if(image.mimeType.contains('image')){
            images.add(new ChatterImage(item, image));
        }
    }
    
    public List<ChatterImage> getImages(){
        return images;
    }
    
    @RemoteAction
    public static List<ConnectApi.ChatterLike> getLikesForImage(String feedItemId){
        ConnectApi.ChatterLikePage likePage;
        likePage = ConnectApi.ChatterFeeds.getLikesForFeedItem(cov_user_utility.self.getNetworkId()	, feedItemId);
        return likePage.likes;
    }
    
    public class ChatterImage{
        public transient ConnectApi.FeedItem item;
        public transient ConnectApi.ContentAttachment image;

        public transient Id insertedById {get;}


        //public ChatterImage(ConnectApi.FeedItem item, ConnectApi.ContentAttachment image, Id insertedById){
        public ChatterImage(ConnectApi.FeedItem item, ConnectApi.ContentAttachment image){
            this.item = item;
            this.image = image;
            //this.insertedById = insertedById;
        }
        
        public ConnectApi.FeedItem getItem(){
            return item;
        }
        
        public ConnectApi.ContentAttachment getImage(){
            return image;
        }
    }
}