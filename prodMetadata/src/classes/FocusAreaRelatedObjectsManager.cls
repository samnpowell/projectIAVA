public with sharing class FocusAreaRelatedObjectsManager {
// Developed by Richard Saunders, Exponent Partners for IAVA, 2011
// Class to create the related junction objects for focus areas
// This class is called from the triggers for the respective junction objects

	public static void createFocusToLegJunction(Id prid, Id legid){
		
		if (prid != null && legid != null) {
			Policy_Rec__c pr;
			
			try {
				pr = [select id, Meta_Focus_Area__c from Policy_Rec__c where id=:prid limit 1];
			} catch (DmlException e) {
				system.debug('Error querying focus area: '+e);
				return;
			}
			
			if (pr.Meta_Focus_Area__c != null) {
				// Only create the junction if a relationship doesn't already exist
				Focus_related_to_Legislation__c existing;
				try {
					existing = [select id from Focus_related_to_Legislation__c 
								where Related_Focus_Area__c =: pr.Meta_Focus_Area__c 
								and Related_Legislation__c =: legid 
								limit 1];
				} catch (QueryException e) {
					system.debug('No relationship appears to exist: ' + e);	
				}
				
				if (existing == null) {
					Focus_related_to_Legislation__c fl = new Focus_related_to_Legislation__c (
						Related_Focus_Area__c = pr.Meta_Focus_Area__c,
						Related_Legislation__c = legid	
					);
					insert fl;
				}
			}
		}
	}
	
	public static void createFocusToDCEventJunction(Id prid, Id dcid){
		
		if (prid != null && dcid != null) {
			Policy_Rec__c pr;
			
			try {
				pr = [select id, Meta_Focus_Area__c from Policy_Rec__c where id=:prid limit 1];
			} catch (DmlException e) {
				system.debug('Error querying focus area: '+e);
				return;
			}
			
			if (pr.Meta_Focus_Area__c != null) {
				// Only create the junction if a relationship doesn't already exist
				Focus_related_to_DC_Event__c existing;
				try {
					existing = [select id from Focus_related_to_DC_Event__c 
								where Related_Focus_Area__c =: pr.Meta_Focus_Area__c
								and Related_DC_Event__c =: dcid	
								limit 1];
				} catch (QueryException e) {
					system.debug('No relationship appears to exist: ' + e);	
				}
				
				if (existing == null) {
					Focus_related_to_DC_Event__c fdc = new Focus_related_to_DC_Event__c (
						Related_Focus_Area__c = pr.Meta_Focus_Area__c,
						Related_DC_Event__c = dcid	
					);
					insert fdc;
				}
			}
		}
	}
	
	public static void createFocusToContactJunction(Id prid, Id cid){
		
		if (prid != null && cid != null) {
			Policy_Rec__c pr;
			
			try {
				pr = [select id, Meta_Focus_Area__c from Policy_Rec__c where id=:prid limit 1];
			} catch (DmlException e) {
				system.debug('Error querying focus area: '+e);
				return;
			}
			
			if (pr.Meta_Focus_Area__c != null) {
				// Only create the junction if a relationship doesn't already exist
				Contact_related_to_Focus__c existing;
				try {
					existing = [select id from Contact_related_to_Focus__c 
								where Related_Focus_Area__c =: pr.Meta_Focus_Area__c
								and Related_Contact__c =: cid
								limit 1];
				} catch (QueryException e) {
					system.debug('No relationship appears to exist: ' + e);	
				}
				
				if (existing == null) {
					Contact_related_to_Focus__c fdc = new Contact_related_to_Focus__c (
						Related_Focus_Area__c = pr.Meta_Focus_Area__c,
						Related_Contact__c = cid	
					);
					insert fdc;
				}
			}
		}
	}
	

	
	// Tests
	
	static testMethod void policyRecJunctionsUnitTest() {
    // Test to verify the P_Rec_DC_Event_junction__c, PRec_Leg_junction__c, and Contact_PolRec_junction__c triggers
    
    	Focus_Area__c fa = new Focus_Area__c(Name='test focus area');
    	insert fa;
    	
        Policy_Rec__c pr = new Policy_Rec__c(Name= 'test policy rec', Meta_Focus_Area__c = fa.id);
        insert pr;
        
        Legislation__c leg = new Legislation__c(Name = 'test leg', Bill_Number__c = decimal.valueOf(1), Bill_Prefix__c='bill');
        insert leg;
        
        PRec_Leg_junction__c prleg = new PRec_Leg_junction__c(Policy_Rec__c = pr.id, Legislation__c = leg.id);
        PRec_Leg_junction__c prleg2 = new PRec_Leg_junction__c(Policy_Rec__c = pr.id, Legislation__c = leg.id);
        insert prleg;
        insert prleg2; // test to make sure we do not create multiple 
        
        DC_Event__c dc = new DC_Event__c(Name = 'test dc event');
        insert dc;
        
        P_Rec_DC_Event_junction__c prdce = new P_Rec_DC_Event_junction__c(Policy_Rec__c = pr.id, DC_Event__c = dc.id);
        P_Rec_DC_Event_junction__c prdce2 = new P_Rec_DC_Event_junction__c(Policy_Rec__c = pr.id, DC_Event__c = dc.id);
        insert prdce;
        insert prdce2;
        
        Contact con = new Contact(FirstName='fname', LastName='lname');
        insert con;
        
        Contact_PolRec_junction__c cpr = new Contact_PolRec_junction__c(Policy_Rec__c = pr.id, Contact__c = con.id);
        Contact_PolRec_junction__c cpr2 = new Contact_PolRec_junction__c(Policy_Rec__c = pr.id, Contact__c = con.id);
        insert cpr; 
        insert cpr2;
        
        // verify that related records were created on the Focus Area
        List<Focus_related_to_Legislation__c> flegs = [select id, Related_Legislation__c from Focus_related_to_Legislation__c where Related_Focus_Area__c =:fa.id];
        system.assertEquals(1, flegs.size());
        system.assertEquals(leg.id, flegs[0].Related_Legislation__c);
        
        List<Focus_related_to_DC_Event__c> fdces = [select id, Related_DC_Event__c from Focus_related_to_DC_Event__c where Related_Focus_Area__c =:fa.id]; 
        system.assertEquals(1, fdces.size());
        system.assertEquals(dc.id, fdces[0].Related_DC_Event__c);
        
        List<Contact_related_to_Focus__c> fcons = [select id, Related_Contact__c from Contact_related_to_Focus__c where Related_Focus_Area__c =: fa.id];
        system.assertEquals(1, fcons.size());
        system.assertEquals(con.id, fcons[0].Related_Contact__c);
        
    }
}