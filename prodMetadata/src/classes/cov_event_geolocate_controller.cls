public with sharing class cov_event_geolocate_controller {

	private String idString {get; set;}
	public Id eventId {get; set;}
	private String address {get; set;}
	private String lat {get; set;}
	private String lon {get; set;}
	public String otherParams {get; set;}

	public cov_event_geolocate_controller() { }

	public pageReference init() {
		Map<String, String> params = ApexPages.currentPage().getParameters();
		System.debug('>>>>>>>>>> params: ' + params);
		lat = params.get('lat');
		params.remove('lat'); // also remove param so can tack on rest of params at end
		lon = params.get('lon');
		params.remove('lon');
		address = params.get('address');
		params.remove('address');
		idString = params.get('id');
		params.remove('id');

		otherParams = '';
		for (String key : params.keySet()) {
			otherParams += '&' + key + '=' + params.get(key);
		}

		if (idString == null || idString == '') {
			return Page.cov_dashboard;
		}

		try {
			eventId = (Id)idString;
		} catch (Exception e) {
			system.debug('id parameter wasnt an id: ' + idString);
			return Page.cov_dashboard;
		}

		pageReference retPR;
		
		if ((lat != null && lat != '' && lon != null && lon != '') || address == '') {
			Double latitude;
			Double longitude;
			if (lat != 'x' && lon != 'x' && lat != null && lon != null) { // x means delete value so keep latitude and longitude as null values
				try {
					latitude = Decimal.valueOf(lat);
					longitude = Decimal.valueOf(lon);
				} catch (Exception e) {
					system.debug('couldnt convert lat or long parameter to a Double: ' + lat + ' ' + lon);
					retPR = Page.cov_event;
					retPR.getParameters().put('id', eventId);
					retPR = tackOnParameters(retPR, params);
					return retPR;
				}
			}

			IAVAEvent__c theEvent;
			try {
				theEvent = [select Id, Latitude__c, Longitude__c from IAVAEvent__c where Id = :eventId];
			} catch (Exception e) {
				system.debug('no event found with that id: ' + eventId);
				return Page.cov_dashboard;
			}

			theEvent.Latitude__c = latitude;
			theEvent.Longitude__c = longitude;

			try {
				update theEvent;
				system.debug('event updated');
			} catch (Exception e) {
				system.debug('error updating event');
				return Page.cov_dashboard;
			}

			retPR = Page.cov_event;
			retPR.getParameters().put('id', eventId);
			retPR = tackOnParameters(retPR, params);
			system.debug('updated, returning this pageref: ' + retPR);
			return retPR;

		} else if (address != null) {
			system.debug('id is valid and there is an address parameter: ' + address);
			return null;
		} else {
			system.debug('either no lat/lon parameters or no address parameter.');
			retPR = Page.cov_event;
			retPR.getParameters().put('id', eventId);
			retPR = tackOnParameters(retPR, params);
			return retPR;
		}
	}

	private pageReference tackOnParameters(PageReference inputPR, Map<String, String> params) {
		pageReference outputPR = inputPR;
		for (String key : params.keySet()) {
			outputPR.getParameters().put(key, params.get(key));
		}
		return outputPR;
	}
}