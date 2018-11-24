public class GeoCodeUpdateController {
	
	// create Geo Location for this zip/lat/lon if none exists and set Gives with this zip to reference this Geo Location
	public PageReference updateGives() {
		Map<String, String> params = ApexPages.currentPage().getParameters();
		System.debug('>>>>>>>>>> params: ' + params);
		String latitude = params.get('lat');
		String longitude = params.get('lon');
		String zip = params.get('zip');
		String city = '';
		
		if (latitude != null && latitude != '0' && longitude != null && longitude != '0' && zip != null && zip != '') {
			
			// get all Gives with this zip that need Geo Location set
			List<Give__c> givesToUpdate = [select Id, City__c from Give__c where Zip_Code_s__c = :zip and Geo_Location__c = null];
			if (!givesToUpdate.isEmpty()) {
				city = givesToUpdate[0].City__c;
			}
			
			// check if a Geo Location already exists for this zip
			String geolocName = zip + ' - %';
			List<Geo_Location__c> geolocs = [select Id from Geo_Location__c where Name like :geolocName];
			
			Geo_Location__c geoloc;
			
			// create new Geo Location if none exists for this zip
			if (geolocs.isEmpty()) {
				geoloc = new Geo_Location__c(lat__c = Decimal.valueOf(latitude), lon__c = Decimal.valueOf(longitude), Name = zip + ' - ' + city);
				insert geoloc;
			} else {
				geoloc = geolocs[0];
			}
			
			// set geo location reference on all Gives with this zip
			for (Give__c g : givesToUpdate) {
				g.Geo_Location__c = geoloc.Id;
			}
			update givesToUpdate;
			
		}
		
		PageReference pr = Page.GeoCodeAdmin;
		if (zip!= null && zip != '') {
			pr.getParameters().put('zip', zip);
		}
		pr.setRedirect(true);
		return pr;
	}
	
}