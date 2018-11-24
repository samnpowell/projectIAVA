global class ContactGeoLocationBatchProcessor implements Database.Batchable<sObject>, Database.AllowsCallouts{
	
	final String batchQuery;
	
   	global ContactGeoLocationBatchProcessor(){
   		try{
			batchQuery='Select MailingPostalCode, OtherPostalCode, Latitude__c, Longitude__c From Contact Where (Latitude__c = null Or Longitude__c = null ) And (MailingPostalCode != null Or OtherPostalCode != null)';
			System.debug('batchQuery='+batchQuery);
		}catch(Exception e){
			System.debug(e.getMessage());
		}
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(batchQuery);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope){
      
		try{
			Map<String, String> geoLocData = new Map<String, String>();
			String zipCode = '';
			for(Sobject s : scope){
				Contact c = (Contact) s;
				if(c.OtherPostalCode != null){
					zipCode = c.OtherPostalCode;
				}else if(c.MailingPostalCode != null){
					zipCode = c.MailingPostalCode;
				}else continue;
				
				geoLocData = GoogleMapUtils.ZipCodeInformation(zipCode);
				if(geoLocData != null){	
					c.Latitude__c = geoLocData.get('Latitude');
					c.Longitude__c = geoLocData.get('Longitude');
				}
			}
			
			update scope;
	    }catch(DmlException e){
			System.debug(e.getMessage());
		}
	}
   

	global void finish(Database.BatchableContext BC){}
}