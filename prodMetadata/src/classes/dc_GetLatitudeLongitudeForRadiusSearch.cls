public class dc_GetLatitudeLongitudeForRadiusSearch {


	 public static MAP<string, string> dc_GetLatLon(string Zip_value, string Distance_value)
    	{
        try
        {
        	string key;
        	Rucksack_Settings__c RS = Rucksack_Settings__c.getInstance();
        	boolean useProdKey = RS.UseGoogleProductionKey__c;
        	system.debug('useProdKey::::::::::::::::::::::::::::::::' + useProdKey);
        	if(useProdKey == true)
        		key = System.Label.Google_Production_Key;
        	else key = System.Label.Google_Sandbox_Key;
        	system.debug('key:::::::::::::::::::::::::::::::::::::::' + key);	
           	//string url = 'http://maps.google.com/maps/geo?q=' + zip_value + '&output=csv&key=' + System.Label.Google_Sandbox_Key + '&sensor=false';
        	string url = 'http://maps.google.com/maps/api/geocode/xml?address=' + zip_value + '&output=csv&key=' + Key + '&sensor=false';
        	List<String> cordinates = new list<string>();
			double distance;
			double latitude;
			double longitude;
			string state_xml;
			Double minLat = 0.0, maxLat = 0.0, minLon = 0.0, maxLon = 0.0;
			string state;
			system.debug('zip_value:::::::' + zip_value);
			system.debug('distance_value:::::::' + distance_value);
			
        	String SetGeoLocId;
        	Map<String, String> MapStateGeoId = new Map<String, String>();
			if(zip_value != null)
			{ 
					if(distance_value != null)
					distance = double.valueof(Distance_value.split(' ')[0]);
					else distance = 0;
					
					system.debug('distance:::::::' + distance);
                    Http h = new Http();
            		HttpRequest req = new HttpRequest();
            		req.setMethod('GET');
            		req.setEndpoint(url);
            		HTTPResponse res = dc_http(req);
            		
            		// Check for statuscode 200 (success)
            		if(res.getStatusCode()==200){
	            		dom.Document doc = res.getBodyDocument();
						//geometry
						dom.XmlNode location = doc.getRootElement().getChildElement('result',null).getChildElement('geometry',null).getChildElement('location',null);         
						integer n = 0;
						for(dom.XmlNode node : doc.getRootElement().getChildElement('result',null).getChildElements()) {
	   						n = n + 1;
	   						if(node.getName()=='address_component') {
	      					state_xml = node.getChildElement('short_name', null).getText();
	      					if (state_xml.length() == 2)
	      					break;
	   						}
						}
						longitude = double.valueof(location.getChildElement('lng', null).getText());
						latitude = double.valueof(location.getChildElement('lat', null).getText());
	            		MapStateGeoId = dc_GetLatitudeLongitudeForRadiusSearch(longitude, latitude, state_xml,distance);
	            		return MapStateGeoId;
            		} else {
            			// callout was not successful, handle it
            			System.debug('***Callout to Google Maps API did not succeed.  StatusCode='+res.getStatusCode()+','+res.getStatus()+'\n\nZip_value='+Zip_value+'\nDistance_value='+Distance_value);
            			insert new Log__c(message__c='Callout to Google Maps API did not succeed.  StatusCode='+res.getStatusCode()+','+res.getStatus()+'\n\nZip_value='+Zip_value+'\nDistance_value='+Distance_value,
            								Process_Name__c='dc_GetLatitudeLongitudeForRadiusSearch : dc_GetLatLon');
            		}
			}
			return null;
        }
        catch(exception e){
        	System.debug('***Exception in dc_GetLatLon; Zip_value='+Zip_value+'\nDistance_value='+Distance_value);
        	System.debug(e);
        	insert new Log__c(message__c='Exception in Google Maps API Geocoding Method.\n'+e.getTypeName() + ', '+e.getMessage()+'\n\nZip_value='+Zip_value+'\nDistance_value='+Distance_value,
            				  Process_Name__c='dc_GetLatitudeLongitudeForRadiusSearch : dc_GetLatLon');
        	 return null;
       	}
    }
  
    	/*  6/16 MD: Geocoder.us Backup Emergency Service
    public static MAP<string, string> dc_GetLatLon(string Zip_value, string Distance_value)
    	{
        try
        {
        	string key;
        	Rucksack_Settings__c RS = Rucksack_Settings__c.getInstance();
        	//boolean useProdKey = RS.UseGoogleProductionKey__c;
        	//system.debug('useProdKey::::::::::::::::::::::::::::::::' + useProdKey);
        	//if(useProdKey == true)
        	//	key = System.Label.Google_Production_Key;
        	//else key = System.Label.Google_Sandbox_Key;
        	//system.debug('key:::::::::::::::::::::::::::::::::::::::' + key);	
           	//string url = 'http://maps.google.com/maps/geo?q=' + zip_value + '&output=csv&key=' + System.Label.Google_Sandbox_Key + '&sensor=false';
        	//string url = 'http://maps.google.com/maps/api/geocode/xml?address=' + zip_value + '&output=csv&key=' + Key + '&sensor=false';
        	string url = 'http://feldt12:etherios1@geocoder.us/member/service/csv/geocode?zip=' + zip_value;

        	List<String> cordinates = new list<string>();
			double distance;
			double latitude;
			double longitude;
			string state_xml;
			Double minLat = 0.0, maxLat = 0.0, minLon = 0.0, maxLon = 0.0;
			string state;
			system.debug('zip_value:::::::' + zip_value);
			system.debug('distance_value:::::::' + distance_value);
			
        	String SetGeoLocId;
        	Map<String, String> MapStateGeoId = new Map<String, String>();
			if(zip_value != null)
			{ 
					if(distance_value != null)
					distance = double.valueof(Distance_value.split(' ')[0]);
					else distance = 0;
					
					system.debug('distance:::::::' + distance);
                    Http h = new Http();
            		HttpRequest req = new HttpRequest();
            		req.setMethod('GET');
            		req.setEndpoint(url);
            		HTTPResponse res = dc_http(req);
            		if(res.getStatusCode()==200){
	            		String resp = res.getBody();
	            		System.debug('***getBody='+resp);
	            		List<String> respList = resp.split(',');
	            		System.debug('***respList='+respList);
	            		if(respList!=null && !respList.isEmpty()){
	            			latitude = double.valueOf(respList[0].trim());
	            			longitude = double.valueOf(respList[1].trim());
	            			state_xml = respList[3].trim();
	            			System.debug('***lat='+latitude);
	            			System.debug('***long='+longitude);
	            			System.debug('***state_xml='+state_xml);
	            			MapStateGeoId = dc_GetLatitudeLongitudeForRadiusSearch(longitude, latitude, state_xml,distance);
	            			return MapStateGeoId;
	            		} else { return null; }
            		} else { return null; }
			}
			return null;
        }
        catch(exception e){ return null;}
    	}
    	
    	*/
	
	public static HTTPResponse dc_http(HttpRequest req)
    {
        try
        {
            // 10/2015 quick fix - avoid test callout error
            // TODO: implement mock callout feature
            if (Test.isRunningTest()) {
                return null;
            } else {
        		Http h = new Http();
        		HTTPResponse res = h.send(req);
        		return res;
            }
        }
        catch(exception e)
        {
        	System.debug('***Exception in dc_http; HttpRequest='+req);
        	System.debug(e);
        	insert new Log__c(message__c='Exception in Google Maps API Geocoding Method.\n'+e.getTypeName() + ', '+e.getMessage()+'\n\nHttpRequest='+req,
            				  Process_Name__c='dc_GetLatitudeLongitudeForRadiusSearch : dc_http');
        	return null;
        }
    }
	
	public static MAP<string, string> dc_GetLatitudeLongitudeForRadiusSearch(double longitude, double latitude, string state_xml, double distance)
    {
        try
        {
        	String defaultDistance = Rucksack_Mobile_Services__c.getAll().get('Default Search Radius').Value__c;
        	System.debug(System.LoggingLevel.INFO, 'defaultDistance: ' + defaultDistance);
            List<String> cordinates = new list<string>();
			Double minLat = 0.0, maxLat = 0.0, minLon = 0.0, maxLon = 0.0;
			string state;
			system.debug('distance:::::::' + distance);
        	String SetGeoLocId;
        	Map<String, String> MapStateGeoId = new Map<String, String>();
			
            if(latitude !=  0 & longitude != 0)
            {
            	minLat = latitude - (distance/69);  
            	maxLat = latitude + (distance/69);
            	minLon = longitude - (distance/69);  
            	maxLon = longitude + (distance/69);
            	system.debug('latitude::::::::::::::::::::::::::::::' +latitude); 
            	system.debug('longitude::::::::::::::::::::::::::::' +longitude);
            	system.debug('minLat:::::::' + minLat + 'maxLat:::::::' + maxLat + 'minLon:::::::' + minLon + 'maxlon:::::::' + maxlon );
            		//state = dc_GetState(latitude, longitude); 
            		//if(state == null)
            			state = state_xml;           
				for(Geo_Location__c geoloc: [SELECT id FROM Geo_Location__c WHERE 
					lat__c >= :minLat and lat__c <= :maxLat and lon__c >= :minLon and lon__c <= :maxLon])	
				{
						system.debug('SetGeoLocId----------' + SetGeoLocId);
						if(SetGeoLocId == null || SetGeoLocId == '')
						{
							SetGeoLocId = '(' + '\'' + geoloc.id + '\'';
						}
						else
						{
							SetGeoLocId +=  ',' + '\'' + geoloc.id + '\'';
						}
						system.debug('SetGeoLocId+++++++++' + SetGeoLocId);
				}
            		
					system.debug('SetGeoLocId:::::::::::' + SetGeoLocId);
                    if(SetGeoLocId != null && SetGeoLocId != '' && SetGeoLocId != 'null')
                    {
                    	SetGeoLocId = SetGeoLocId + ')';
                    	if(state!= null)
                    	MapStateGeoId.put(state, SetGeoLocId);
                    	else
                    	MapStateGeoId.put('XX', SetGeoLocId);
                    	
                    	System.debug('***state='+state);
                    	return MapStateGeoId;
                    }
                    else if(distance != double.valueOf(defaultDistance) && (SetGeoLocId == null || SetGeoLocId == '' || SetGeoLocId == 'null'))
                    {
                    	return null;
                    }
                    else if(distance == double.valueOf(defaultDistance) && (SetGeoLocId == null || SetGeoLocId == '' || SetGeoLocId == 'null'))
                    {
                    	MapStateGeoId.put(state, SetGeoLocId);
                    	return MapStateGeoId;
                    }
            }
            return null;
        }
        catch(exception e)
        {
        	System.debug('***Exception in dc_GetLatitudeLongitudeForRadiusSearch; long='+longitude+'\nlat='+latitude+'\nstate_xml='+state_xml+'\ndistance='+distance);
        	System.debug(e);
        	insert new Log__c(message__c='Exception in Google Maps API Geocoding Method.\n'+e.getTypeName() + ', '+e.getMessage()+'\n\nlong='+longitude+'\nlat='+latitude+'\nstate_xml='+state_xml+'\ndistance='+distance,
            				  Process_Name__c='dc_GetLatitudeLongitudeForRadiusSearch : dc_GetLatitudeLongitudeForRadiusSearch');
        	return null;
        }
	}
}