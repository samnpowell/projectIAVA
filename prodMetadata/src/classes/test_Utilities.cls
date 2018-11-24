public class test_Utilities {
    public static Give_Instance__c createSimpleGiveInstance() {
        return createSimpleGiveInstance(createSimpleGive());  
    }
    
    public static Give_Instance__c createSimpleGiveInstance(Give__c give) {
        Give_Instance__c instance = new Give_Instance__c();
        System.debug(System.LoggingLevel.INFO, give);
        instance.Give__c = give.Id;
        instance.Status__c = 'Open';
        instance.Number_of_Units__c = 100;
        insert instance;
        return instance;
    }

    public static Give__c createSimpleGive() {
        Partnership_Request__c PR = createPartnership();
        Geo_Location__c geo = createGeo('Test', 40, 120);
        Geo_Location__c closedgeo = createGeo('Test', 50, 120);
        
        Give__c give = new Give__c( Name = 'Test Simple Give', Geo_Location__c = geo.id, Partnership_Request__c = PR.id, 
        	Category__c = 'Events', City__c = 'Test City', National_Give__c = false, Zip_Code_s__c = '95050', 
        	Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  
        	Description__c = 'Test');
        
        insert give;
        return give;
    }

    public static Give__c createSimpleGive(Partnership_Request__c PR) {
        Geo_Location__c geo = createGeo('Test', 40, 120);
        Geo_Location__c closedgeo = createGeo('Test', 50, 120);
        
        Give__c give = new Give__c( Name = 'Test Simple Give', Geo_Location__c = geo.id, Partnership_Request__c = PR.id, 
        	Category__c = 'Events', City__c = 'Test City', National_Give__c = false, Zip_Code_s__c = '95050', 
        	Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  
        	Description__c = 'Test');
        
        insert give;
        return give;
    }
    
    public static Geo_Location__c createGeo(String name, Double lat, Double lon) {
        Geo_Location__c geo = new Geo_Location__c();
        geo.name = name;
        geo.lat__c = lat;
        geo.lon__c = lon;
        insert geo; 
        return geo;
    }
    
    public static Partnership_Request__c createPartnership(){
        Account a = new Account(name='testtesttesttest');
        insert a;
        
        Partnership_Request__c PR = new Partnership_Request__c(name='testtest',organization__c=a.id,public_partner_name__c='testtesttest', Show_partner_logo_on_rewards_homepage__c=true);
                
        insert PR;
        
        return PR; 
    }
    
    public static Contact createSimpleContact(String lastName, String email, string memId) {
		Contact con = new Contact();
        con.lastname = lastName;
        con.email = email;
        con.Membership_Id__c = memId;
        con.Veteran_Member__c = true;
        con.Paperwork_Confirmation__c = 'Paperwork Accepted';
        con.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
        con.Discharge_Status__c =  'General';
 		con.Mailingstreet = 'test';
        insert con;
        return con;
    }
    
    public static Give_Request__c createSimpleGiveRequest(Give__c give, Give_Instance__c instance, Contact con) {
    	Give_Request__c request = new Give_Request__c();
    	
    	request.Address__c = '1000 Grand Ave';
    	request.Applicant__c = con.Id;
    	request.City__c = 'New York';
    	request.Confirmed_21__c = true;
    	request.Email_Address__c = con.Email;
    	request.Give_Instance__c = instance.Id;
    	request.Guest_s_21_and_Over__c = true;
    	request.Member_DL_Num__c = 'asdf';
    	request.Member_DOB__c = Date.Today().addYears(-18);
    	request.Member_Shirt_Size__c = 'Adult – Large (L)';
    	request.Primary_Phone__c = '111-222-3333';
    	request.Stage__c = 'Tentative confirmation';
    	request.Units_Requested__c = 2;
    	request.State__c = 'NY';
    	request.Zip_Code__c = '95050';
    	insert request;
    	
    	createSimpleGuest(request, con);
    	
    	return request;
    }
    
    public static Give_Request_Guest__c createSimpleGuest(Give_Request__c request, Contact con) {
    	Give_Request_Guest__c guest = new Give_Request_Guest__c();
    	guest.Applicant__c = con.Id;
    	guest.Birthdate__c = Date.Today().addYears(-50);
    	guest.Drivers_License__c = 'sadsadfsdaf';
    	guest.First_Name__c = 'First';
    	guest.Last_Name__c = 'Last';
    	guest.Give_Request__c = request.Id;
    	guest.Shirt_Size__c = 'Adult - Large (L)';
    	
    	insert guest;
    	
    	return guest;
    }
}