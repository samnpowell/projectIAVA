public class bulkGeoCode {
    
    public string nextAddr { get; set; } 
	
	public Give__c give { get; set; } 
	
	public bulkGeoCode() {		nextAddr = getNextAddress(); 	}
	
	public boolean hasNextAddress {	get { return  ( nextAddr != '' ); } 	}
	
  	public static string jsapi_script { get { return  geoApiKey.jsapi_script; }}
 
  	public static string maps_script { get { return  geoApiKey.maps_script; }}

    public string msg {get; set;}  

    public Boolean doGeocode { get; private set; } { doGeocode = false; } 
     
 	public string giveId { get; set; }

 	public string geostatus { get; set; }

 	public string geopoint { get; set; }
 	
    public void newGeoLocation() { 
    	
    	doGeocode = true;
    	// update the database, fetch a new give?
    	Geo_Location__c glnew = new Geo_Location__c( 
	    	name = give.name,
	    	webLink__c = give.More_Info_Link__c,
	    	about_us__c = give.description__c,
	    	lat__c = 0.0 ,
	    	lon__c = 0.0
    	); 
    
    	if (geostatus == null ) {
	    //	msg = 'Geococd status is null';
	    	return;
	    	
        }
        if ( geostatus  == '200' )  { 
            glnew.geocode_status__c = 'G_GEO_SUCCESS';
            string[] lat_lon = geopoint.split(',');
            if ( lat_lon.size() ==2) {
	            glnew.lat__c = Double.valueOf(lat_lon[1]); 
	            glnew.lon__c = Double.valueOf(lat_lon[0]); 
            } 

        } else { 
            
            glnew.geocode_status__c = 
            	GeoUtils.geo_response.get( geostatus )
            	+ ' ('+ geostatus + ')';
        }         
        try {
	 		insert glnew;
	    	give.Geo_Location__c = glnew.id; 
	    	update give;
	    	
	    	nextAddr = getNextAddress();  // fetch next one    	
        } catch (exception e) {
         //   msg = e.getMessage(); 
            doGeocode = false;
        }
    }
    
    /* 
     * pull the give into a class var, and generate an address string to return
     */
    string getNextAddress() { 
    	try {
    	   	
    	   	give = [select id, name,Location_Description__c ,City__c ,Location_by_State_s__c 
        	,	Zip_Code_s__c ,description__c, More_Info_Link__c
              from give__c where geo_location__c = null AND 
              Geocode_Exclude__c != true 
              limit 1];
         	giveId = give.id;
         	
         	return  GeoUtils.accountAddressString(give);
         	 
        } catch (exception e) { 
         //   msg = e.getMessage(); 
            doGeocode = false;
            return '' ;
        }
    }
    
    public static testmethod void t1 () { 
         Partnership_Request__c PR = new Partnership_Request__c();
    	PR = [select id from Partnership_Request__c where Public_Partner_Name__c!=null limit 1];
        Give__c a =  new Give__c( name='foo',Partnership_Request__c = PR.id, Location_Description__c='main', city__c='springfield',Location_by_State_s__c='il'
         );//,billingcountry='us');
         insert a;
        bulkGeoCode e = new bulkGeoCode(); 
        system.debug( e.msg );
        system.assertEquals( e.doGeocode , false);
        e.give = a;
        e.geostatus = '200';
        e.geopoint = '12.0,-33.0';
        e.newGeoLocation();
        e.doGeocode = true;
        system.assertEquals( e.doGeocode , true);
        e.geostatus = '201';
        e.newGeoLocation();
        System.assert( bulkGeoCode.jsapi_script != null);
    }
}