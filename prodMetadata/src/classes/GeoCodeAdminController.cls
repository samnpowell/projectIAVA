public class GeoCodeAdminController {
	
	public String zip { get; set; }
	
	public List<Give__c> updatedGives { get; private set; }
	public List<Give__c> gives { get; private set; }
	
	public GeoCodeAdminController() {
		Map<String, String> params = ApexPages.currentPage().getParameters();
		System.debug('>>>>>>>>>> params: ' + params);
		zip = params.get('zip');
		
		if (zip != null && zip != '') {
			updatedGives = [select Id, Name, Zip_Code_s__c, City__c, Geo_Location__r.lat__c, Geo_Location__r.lon__c from Give__c where Zip_Code_s__c = :zip and Geo_Location__c != null];
		}
		
		loadGives();
	}
	
	// query for Gives with zip but no Geo Location for display on page
	private void loadGives() {
		// TODO: check if Geo Location already exists for zip and update the Gives, leaving only with no Geo Location existing for their zip
		gives = [select Id, Name, Zip_Code_s__c, City__c from Give__c where Zip_Code_s__c != null and Geo_Location__c = null];
	}
	
	public PageReference getGeoLocation() {
		// work done in page action called from JS
		return null;
	}
}