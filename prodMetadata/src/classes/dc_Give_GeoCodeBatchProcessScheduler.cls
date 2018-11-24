global class dc_Give_GeoCodeBatchProcessScheduler implements Schedulable{

	List<Give__c> listgive = new List<Give__c>();
	
	/* Necessary method which implements the Schedulable interface */
    global void execute(SchedulableContext sc){	
	try{	
		listgive = [select id, Zip_Code_s__c, city__c, Geo_Location__c from give__c where Zip_Code_s__c != null and Geo_Location__c = null limit 1];
		if(listgive.size() > 0)
		{
			dc_Give_GeoCodeBatchProcessor GeoCodeBatchProcessor = new dc_Give_GeoCodeBatchProcessor();
    		ID batchJobId = Database.executeBatch(GeoCodeBatchProcessor,1);
    		System.debug('GeoCodeBatchProcessor Request Enqueued: '+batchJobId);
		}
		
	}
	catch(exception e){}
    }
}