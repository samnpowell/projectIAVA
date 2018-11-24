public with sharing class test_batch_notification_controller {

	public PageReference execute(){
		List<Pending_Notification__c> listPendingNotifications = new List<Pending_Notification__c>();
		try{	
			listPendingNotifications = [Select	Zip_Code__c, State__c, Processed__c, OwnerId, National__c, 
												Name, Message_Text__c, Give__c, Give__r.Geo_Location__c, Distance__c, Campaign__c 
										From 	Pending_Notification__c
										Where	Processed__c = false];
			if(listPendingNotifications.size() > 0)
			{
				PendingNotificationBatchProcessor pendingNotificationBatchProcessor = new PendingNotificationBatchProcessor();
	    		ID batchJobId = Database.executeBatch(pendingNotificationBatchProcessor,1);
	    		System.debug('PendingNotificationBatchProcessor Request Enqueued: '+batchJobId);
			}
			
		}
		catch(QueryException e){
			System.debug(e.getMessage());
		}
		return null;
	}	

}