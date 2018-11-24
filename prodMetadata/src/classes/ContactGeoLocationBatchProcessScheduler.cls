global class ContactGeoLocationBatchProcessScheduler implements Schedulable{

	List<Contact> listContact = new List<Contact>();
	
	/* Necessary method which implements the Schedulable interface */
    global void execute(SchedulableContext sc){	
		try{	
			listContact = [	Select	MailingPostalCode, OtherPostalCode, Latitude__c, Longitude__c  
							From 	Contact 
							Where	(Latitude__c = null Or Longitude__c = null )
							And		(MailingPostalCode != null Or OtherPostalCode != null)];
			if(listContact.size() > 0)
			{
				ContactGeoLocationBatchProcessor contactGeoLocationBatchProcessor = new ContactGeoLocationBatchProcessor();
	    		ID batchJobId = Database.executeBatch(contactGeoLocationBatchProcessor,1);
	    		System.debug('GeoCodeBatchProcessor Request Enqueued: '+batchJobId);
			}
			
		}
		catch(QueryException e){
			System.debug(e.getMessage());
		}
    }
    
    public static void start() 
 	{
		//Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
		System.schedule('Contact Geo Location 9AM ET - 9PM PT', '0 10 10-1 ? * 1-7', new ContactGeoLocationBatchProcessScheduler());
	}
}