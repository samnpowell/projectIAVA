public class GeoUtils {
	// generate a KML string given a page reference, call getContent() 
	// then cleanup the output.
	public static string generateFromContent(PageReference pr) { 
		string ret = ''; 
		try {  
	        ret = (string) pr.getContent().toString();
			
			ret = ret.replaceAll('"','\'' ); // get content produces quote chars \"  
	        ret = ret.replaceAll( '&','&amp;');// we need to escape these in the node value
        } catch (exception e ) { 
        	system.debug( 'ERROR '+e); 
        }
   		
   		ret = ret.replaceAll('\n',' ');	// must use ALL since many new line may get 
        ret = ret.replaceAll('\r',' ');	// get these also!
      //  system.debug( ret); // dump the KML 
        return ret ;
	}
	
	public static Map<String, String> geo_response = new Map<String, String>{'200'=>'G_GEO_SUCCESS',
    '400'=>'G_GEO_BAD_REQUEST',
    '500'=>'G_GEO_SERVER_ERROR',
    '601'=>'G_GEO_MISSING_ADDRESS',
    '602'=>'G_GEO_UNKNOWN_ADDRESS',
    '603'=>'G_GEO_UNAVAILABLE_ADDRESS',
    '604'=>'G_GEO_UNKNOWN_DIRECTIONS',
    '610'=>'G_GEO_BAD_KEY',
    '620'=>'G_GEO_TOO_MANY_QUERIES'
    };
        
	public static string accountAddressString ( give__c give ) {
    	// form an address string given an account object
    	string adr = give.Location_Description__c + ',' + give.City__c + ',' + give.Location_by_State_s__c; 
       // if ( acct.billingcountry != null ) adr += ',' + acct.billingcountry; 
        adr = adr.replaceAll('\"', '' );
        adr = adr.replaceAll('\'', '' );
        adr = adr.replaceAll( '\n', ' ' );    
        adr = adr.replaceAll( '\r', ' ' );    
        system.debug( adr );  
        return adr;	
    }
     
	public static testmethod void t1() { 
		PageReference pageRef =  Page.kmlPreviewTemplate;
        Test.setCurrentPage(pageRef);
        Partnership_Request__c PR = new Partnership_Request__c();
    	PR = [select id from Partnership_Request__c where Public_Partner_Name__c!=null limit 1];
        system.assert ( GeoUtils.generateFromContent( pageRef ) != null );
        Give__c a =  new Give__c( name='foo', Partnership_Request__c = PR.id, Location_Description__c='main', city__c='springfield',Location_by_State_s__c='il'
         );//,billingcountry='us');
        insert a;
        system.assertEquals( 'main,springfield,il',accountAddressString( a) );
       
	}
}