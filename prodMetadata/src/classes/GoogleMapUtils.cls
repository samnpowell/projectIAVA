/*
Copyright (c) 2010 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Nick Koopman, nkoopman@etherios.com
*/

public class GoogleMapUtils {

	// Obtain the Google Key from Custom Settings
	public static String GoogleKey()
	{
		try
		{
			Rucksack_Settings__c RS = Rucksack_Settings__c.getInstance();
			if (RS.UseGoogleProductionKey__c)
				return System.Label.Google_Production_Key;
			else
				return System.Label.Google_Sandbox_Key;
		}
		catch (exception ex)
		{
			// Nothing we can do here ...
			return '';
		}
		return '';
	}

	// LOG an error ...
	private static void LogException(Exception ex, String Method, String Msg)
	{
		Log__c entry = new Log__c();
		entry.message__c = 'Exception: ' + ex.getTypeName() + ', ' + ex.getMessage() + '\n' + Msg;
		entry.Process_Name__c = 'GoogleMapUtils.' + Method;
		insert entry; 
	}

	// Perform a Google API Search by Zip Code
	private static DOM.Document ZipCodeSearchDoc(String ZipCode)
	{
		if (!StringUtilities.ValidZipCode5(ZipCode)) return null;
		DOM.Document DOC = null;
   		HttpRequest req = new HttpRequest();
		try
		{
        	// Obtain our Google Key
			String Key = GoogleKey();
        	string URL = 'http://maps.google.com/maps/api/geocode/xml?address=' + ZipCode + '&output=csv&key=' + Key + '&sensor=false';
        	System.debug(System.LoggingLevel.INFO, 'URL: ' + URL);
       		req.setMethod('GET');
       		req.setEndpoint(URL);
       		Http protocol = new Http();
       		HttpResponse res = protocol.send(req);
       		if (res.getStatusCode() == 200) DOC = res.getBodyDocument();
		}
		catch (exception ex)
		{
			//LogException(ex, 'ZipCodeSearch', 'HttpRequest=' + req);
		}
		return DOC;
	}

	// Returns a MAP of information from the ZipCodeSearchDoc containing: State, Longitude, Latitude
	private static Map<String, String> ZipCodeSearchDoc(DOM.Document DOC)
	{
		if (DOC == null) return null;
		Map<String, String> SearchMap = new Map<String, String>();
		try
		{
			String state = null;
			DOM.XmlNode location = DOC.getRootElement().getChildElement('result',null).getChildElement('geometry',null).getChildElement('location',null);
			for (DOM.XmlNode node : DOC.getRootElement().getChildElement('result',null).getChildElements())
			{
				if (node.getName() == 'address_component')
				{
					state = node.getChildElement('short_name', null).getText();
	      			if (state.length() == 2) break;
	      		}
			}
			SearchMap.put('State', state);
			SearchMap.put('Longitude', location.getChildElement('lng', null).getText());
			SearchMap.put('Latitude', location.getChildElement('lat', null).getText());
			Double Longitude = Double.valueOf(location.getChildElement('lng', null).getText()); 
			Double Latitude = Double.valueOf(location.getChildElement('lat', null).getText()); 
		}
		catch (exception ex)
		{
			return null;
		}
		return SearchMap;
	}

	public static Map<String, String> ZipCodeInformation(String ZipCode)
	{
		if (!StringUtilities.ValidZipCode5(ZipCode)) return null;
		DOM.Document DOC = ZipCodeSearchDoc(ZipCode.trim());
		if (DOC == null) return null;
		return ZipCodeSearchDoc(DOC);
	}

	// Perform a Google API Search by Latitude and Longitude
	private static DOM.Document LatitudeLongitudeSearchDoc(String Latitude, String Longitude)
	{
		if (!StringUtilities.ValidDouble(Latitude)) return null;
		if (!StringUtilities.ValidDouble(Longitude)) return null;
		DOM.Document DOC = null;
   		HttpRequest req = new HttpRequest();
		try
		{
        	// Obtain our Google Key
			String Key = GoogleKey();
        	string URL = 'http://maps.google.com/maps/api/geocode/xml?latlng=' + Latitude + ',' + Longitude + '&output=csv&key=' + Key + '&sensor=false';
       		req.setMethod('GET');
       		req.setEndpoint(URL);
       		Http protocol = new Http();
       		HttpResponse res = protocol.send(req);
       		if (res.getStatusCode() == 200) DOC = res.getBodyDocument();
		}
		catch (exception ex)
		{
			LogException(ex, 'LatitudeLongitudeSearch', 'HttpRequest=' + req);
		}
		return DOC;
	}

	// Returns a MAP of information from the LatitudeLongitudeSearchDoc containing: State
	private static Map<String, String> LatitudeLongitudeSearchDoc(DOM.Document DOC)
	{
		if (DOC == null) return null;
		Map<String, String> SearchMap = new Map<String, String>();
		try
		{
			String state = null;
			String zip = null;
			DOM.XmlNode location = DOC.getRootElement().getChildElement('result',null).getChildElement('geometry',null).getChildElement('location',null);
			for (DOM.XmlNode node : DOC.getRootElement().getChildElement('result',null).getChildElements())
			{
				System.Debug('Current Node: >>>>>' + node);
				if (node.getName() == 'address_component')
				{
					state = node.getChildElement('short_name', null).getText();
	      			if (state.length() == 2) break;
	      		}
			}
			SearchMap.put('State', state);
		}
		catch (exception ex)
		{
			return null;
		}
		return SearchMap;
	}

	public static Map<String, String> LatitudeLongitudeInformation(String Latitude, String Longitude)
	{
		if (!StringUtilities.ValidDouble(Latitude)) return null;
		if (!StringUtilities.ValidDouble(Longitude)) return null;
		DOM.Document DOC = LatitudeLongitudeSearchDoc(Latitude.trim(), Longitude.trim());
		if (DOC == null) return null;
		return LatitudeLongitudeSearchDoc(DOC);
	}

	// Calculates the approximate distance in miles between two Lat / Lng
	public static Double DistanceBetween(Double FmLat, Double FmLon, Double ToLat, Double ToLon) {
		Double LatFactor = (ToLat - FmLat) * 69.1;
		Double LonFactor = (ToLon - FmLon) * 53.0;
		return Math.sqrt(LatFactor * LatFactor + LonFactor * LonFactor);
	}

	// Returns the State and a List of Geo Location ID's that are within a Radius of a given Zip Code 
	public static Map<String, List<String>> GeoLocationMap(String ZipCode, String Distance) 
	{
		if (!StringUtilities.ValidZipCode5(ZipCode)) return null;
		Map<String, String> ZipInfo = ZipCodeInformation(ZipCode);
		System.Debug('ZipInfo: ' + ZipInfo);
		if (ZipInfo == null) return null;
		String State = ZipInfo.get('State');
		String Longitude = ZipInfo.get('Longitude');
		String Latitude = ZipInfo.get('Latitude');
		Double LAT = Double.valueOf(Latitude);
		Double LON = Double.valueOf(Longitude);
		Double DST = double.valueOf(Rucksack_Mobile_Services__c.getAll().get('Default Search Radius').Value__c); // Default to Custom Settings: Default Search Radius
		if ((!StringUtilities.ISnullORblank(Distance)) && (StringUtilities.ValidDouble(Distance)))
			DST = Double.valueOf(Distance);
		Double Delta = DST / 69;
       	Double minLAT = LAT - Delta;  
		Double maxLAT = LAT + Delta;
		Double minLON = LON - Delta;
		Double maxLON = LON + Delta;
		System.Debug('GEO Search: LAT: ' + minLAT + ' - ' + maxLAT + ' LON: ' + minLON + ' - ' + maxLON);
		List<String> gIDs = new List<String>();
		List<Geo_Location__c> Locations =
			[SELECT Id FROM Geo_Location__c WHERE
			lat__c >= :minLAT AND lat__c <= :maxLAT AND lon__c >= :minLON AND lon__c <= :maxLON];
		for (Geo_Location__c location : Locations) gIDs.add(location.Id);
		Map<String, List<String>> gMAP = new Map<String, List<String>>();
		gMAP.put(State, gIDs);
		return gMAP;
    }

	// Returns the State and a List of Geo Location ID's that are within a Radius of a given Latitude and Longitude 
	public static Map<String, List<String>> GeoLocationMap(String Latitude, String Longitude, String Distance) 
	{
		if ((!StringUtilities.ValidDouble(Latitude)) || (!StringUtilities.ValidDouble(Longitude))) return null;
		Map<String, String> LLinfo = LatitudeLongitudeInformation(Latitude, Longitude);
		String State = null;
		// if (LLinfo != null) State = LLinfo.get('State');
		if (State == null) State = 'UNKNOWN';
		Double LAT = Double.valueOf(Latitude);
		Double LON = Double.valueOf(Longitude);
		Double DST = double.valueOf(Rucksack_Mobile_Services__c.getAll().get('Default Search Radius').Value__c); // Default to Custom Settings: Default Search Radius
		if ((!StringUtilities.ISnullORblank(Distance)) && (StringUtilities.ValidDouble(Distance)))
			DST = Double.valueOf(Distance);
		Double Delta = DST / 69;
       	Double minLAT = LAT - Delta;  
		Double maxLAT = LAT + Delta;
		Double minLON = LON - Delta;
		Double maxLON = LON + Delta;
		System.Debug('GEO Search: LAT: ' + minLAT + ' - ' + maxLAT + ' LON: ' + minLON + ' - ' + maxLON);
		List<String> gIDs = new List<String>();
		List<Geo_Location__c> Locations =
			[SELECT Id FROM Geo_Location__c WHERE
			lat__c >= :minLAT AND lat__c <= :maxLAT AND lon__c >= :minLON AND lon__c <= :maxLON];
		for (Geo_Location__c location : Locations) gIDs.add(location.Id);
		Map<String, List<String>> gMAP = new Map<String, List<String>>();
		gMAP.put(State, gIDs);
		return gMAP;
    }
}