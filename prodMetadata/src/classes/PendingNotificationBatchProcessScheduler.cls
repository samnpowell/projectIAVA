global class PendingNotificationBatchProcessScheduler implements Schedulable{
	
	List<Pending_Notification__c> listPendingNotifications = new List<Pending_Notification__c>();
	
	/* Necessary method which implements the Schedulable interface */
    global void execute(SchedulableContext sc){	
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
    }
    
    public static void start() 
 	{
		//Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
		System.schedule('Pending Notifications 9AM ET - 9PM PT', '0 15 10-1 ? * 1-7', new PendingNotificationBatchProcessScheduler());
	}
}