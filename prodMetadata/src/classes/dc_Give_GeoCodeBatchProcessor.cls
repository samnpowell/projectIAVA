global class dc_Give_GeoCodeBatchProcessor implements Database.Batchable<sObject> {
   
   	global String batchQuery;
	global Boolean isTest = false;
	
   global dc_Give_GeoCodeBatchProcessor(){
   			batchQuery='select id, Zip_Code_s__c, city__c, Geo_Location__c from give__c where Zip_Code_s__c != null and Geo_Location__c = null';
			System.debug('batchQuery='+batchQuery);
   }

   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(batchQuery);
   }
   
   global void execute(Database.BatchableContext BC, List<sObject> scope){
      
      try{
      List<Geo_Location__c> listgeoloc = new List<Geo_Location__c>();
      integer counter =0;
      double latitude;
	  double longitude;
	  List<Give__c> givelist = new List<Give__c>();
	  List<Give__c> updgive = new List<Give__c>();
      for(Sobject s : scope)
      {
      		Give__c s_give = (Give__c) s;
      		givelist = [Select id, Geo_Location__c from Give__c where Zip_Code_s__c =: s_give.Zip_Code_s__c and Geo_Location__c != null limit 1];
      		if(givelist.size() > 0 && !isTest)
      		{
      			s_give.Geo_Location__c = givelist[0].Geo_Location__c;
      			update s;
      		}
      }      
   }
   catch(exception e){}
   }
   

   global void finish(Database.BatchableContext BC){

   }

}