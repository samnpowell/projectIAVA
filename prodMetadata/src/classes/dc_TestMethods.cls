@isTest
private class dc_TestMethods {
        
    public static testMethod void dc_ctrl_RewardSearch()
    {
            List<Give__c> listgive =  new List<Give__c>(); 
            List<Give_Instance__c> listgiveinstance =  new List<Give_Instance__c>(); 
            List<Give__c> customgivelist = new list<Give__c>();
        
        // Partnership_Request__c PR = new Partnership_Request__c();
        // PR = [select id from Partnership_Request__c limit 1];
         
        Partnership_Request__c PR = test_Utilities.createPartnership(); 
         
        Geo_Location__c geo = new Geo_Location__c();
        geo.name = 'Test';
        geo.lat__c = 40;
        geo.lon__c = 120;
        insert geo; 
        Geo_Location__c closedgeo = new Geo_Location__c();
        geo.name = 'Test';
        geo.lat__c = 50;
        geo.lon__c = 120;
        insert closedgeo;   
        

        listgive.add( new Give__c( Name = 'Test Give', Geo_Location__c = geo.id, Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', National_Give__c = false, Zip_Code_s__c = '95050', Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        listgive.add( new Give__c( Name = 'Test Give', Geo_Location__c = geo.id, Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', National_Give__c = true, Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        listgive.add( new Give__c( Name = 'Test Give', Geo_Location__c = geo.id, Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', Location_by_State_s__c = 'IL', Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        listgive.add( new Give__c( Name = 'Test Give', Geo_Location__c = closedgeo.id, Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', National_Give__c = false, Zip_Code_s__c = '95040', Location_Description__c = 'Test',Status__c = 'Closed Visible', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));       
        insert listgive;
        
        listgiveinstance.add( new Give_Instance__c( Give__c = listgive[0].id, Status__c = 'Open' , Number_of_Units__c = 100));
        listgiveinstance.add( new Give_Instance__c( Give__c = listgive[1].id, Status__c = 'Open' , Number_of_Units__c = 100));
        listgiveinstance.add( new Give_Instance__c( Give__c = listgive[2].id, Status__c = 'Open' , Number_of_Units__c = 100));
        listgiveinstance.add( new Give_Instance__c( Give__c = listgive[3].id, Status__c = 'Open' , Number_of_Units__c = 100));
        listgiveinstance.add( new Give_Instance__c( Give__c = listgive[0].id, Status__c = 'Open' , Number_of_Units__c = 100));
        insert listgiveinstance;

        customgivelist = [select id, Category__c, status__c,available__c, Deadline__c,type__c, name,Number_Remaining__c,City__c, Location_Formula__c,Location_by_State_s__c,Zip_Code_s__c,
                                description__c,Partnership_Request__c,Latest_Application_Deadline__c,Must_be_21__c,
                                location_description__c,Partnership_Request__r.Public_Partner_Name__c,Maximum_Units_per_Member__c
                                , Fulfillment_Instructions_for_Winner__c
                                , Latitude__c, Longitude__c
                                ,(select id, start_date__c, start_time__c, 
                                end_date__c, end_time__c, date_to__c, date_from__c, Year_Start_Date__c from Give_Instances__r order by start_date__c asc),(select id From Attachments where Name like '%logo%' limit 1) from Give__c 
                                where name = 'Test Give'
                                ] ; 
        string geoid = '(' + '\'' + geo.id + '\'' + ')';
        string closedgeoid = '(' + '\'' + closedgeo.id + '\'' + ')';
        Contact con = new Contact();
        con.lastname = 'last';
        con.email = 'test@test.com';
        con.Membership_Id__c = '12345';
        con.Veteran_Member__c = true;
        con.Paperwork_Confirmation__c = 'Paperwork Accepted';
        con.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
        insert con;
        Contact cont = new Contact();
        cont.lastname = 'last1';
        cont.email = 'test@test1.com';
        cont.Membership_Id__c = '123456';
        cont.Veteran_Member__c = true;
        insert cont;
        
        PageReference pageRef1 = Page.dc_RewardList;
        
        Test.setCurrentPage(pageRef1);
        Test.startTest();
        dc_ctrl_RewardSearch RS = new dc_ctrl_RewardSearch();

        RS.getdc_homepage();
        RS.getdc_rewardsearch();
        RS.getdc_rewarddetail();
        RS.getdc_claimreward();
        RS.getdc_partner();
        RS.getdc_faq();
        RS.getoif_val();
        RS.getoef_val();
        RS.setoif_val('test');
        RS.setoef_val('test');
        RS.getstart_date();
        RS.setstart_date('test');
        RS.getpName();
        RS.setpName('test');
        RS.getvalidate();
        RS.setvalidate('test');
        
        
        RS.getgivelist();
        RS.getBasicSearchResult();  
        RS.getRequestReward() ;
        RS.getRewardMultipleDateTime() ;
        RS.setZip_Value('95050'); 
        System.currentPageReference().getParameters().put('zip','95050');
        RS.getZip_Value(); 
        RS.getCategory_value();
        RS.setCategory_value('Events');
        System.currentPageReference().getParameters().put('cat','Events');
        RS.getDistance_value();
        RS.setDistance_value('50 Miles');
        System.currentPageReference().getParameters().put('dist','50 Miles');
        System.currentPageReference().getParameters().put('zip','95050');
        System.currentPageReference().getParameters().put('cat','Events');
        System.currentPageReference().getParameters().put('sd','06/12/2010');
        System.currentPageReference().getParameters().put('ed','MM/DD/YYYY');
        RS.searchval();
        System.currentPageReference().getParameters().put('dist','');
        System.currentPageReference().getParameters().put('zip','');
        System.currentPageReference().getParameters().put('cat','All');
        System.currentPageReference().getParameters().put('sd','');
        System.currentPageReference().getParameters().put('ed','');
        RS.searchval();
        System.currentPageReference().getParameters().put('dist','');
        System.currentPageReference().getParameters().put('zip','95010');
        System.currentPageReference().getParameters().put('cat','All');
        System.currentPageReference().getParameters().put('sd','');
        System.currentPageReference().getParameters().put('ed','');
        RS.searchval();
        RS.getMembership_Number();
        RS.setMembership_Number('12345');
        RS.getEmail();
        RS.setEmail('test@test.com');
        RS.getMember_Name();
        RS.getDistance();
        RS.getCategory();
        RS.getListPartners();
        RS.getRewardDetails();
        RS.setoef(true);
        RS.getoef();
        RS.its();
        RS.setoif(true);
        RS.getoif();
        RS.validateinfo();
        RS.getZip_value();
        RS.setemailtoreg('test1@test1.com');
        RS.signup();
        RS.setemailtoreg('test@test.com');
        RS.signup();
        RS.setemailtoreg('test@test1.com');
        RS.signup();
        RS.getemailtoreg();
        RS.setCategory_value('Event');
        RS.setDistance_value('50 Miles');
        RS.setZip_value('95050');
        RS.searchval();    
        RS.Email_Member = 'test@test.com';  
        RS.mail_memberid();
        date smydate = date.parse('06/01/10');
        string sd = string.valueof(smydate);
        date emydate = date.parse('07/01/10');
        string ed = string.valueof(emydate);
        system.debug('sd---------------------------' + sd);
        system.debug('ed---------------------------' + ed);
        
        //test.starttest();
        
        RS.searchlogic('Events', 'IL', geoid,sd ,ed , '95050');
        RS.searchlogic('All', 'IL', geoid,sd,ed , '95050');
         RS.searchlogic('Events', '', geoid,sd,ed , '95050');
        RS.searchlogic('Events', 'IL', '',sd,ed , '95050');
        RS.searchlogic('Events', 'IL', closedgeoid,sd,ed , '95040');
        RS.searchlogic('Events', 'IL', '','' ,sd , '95050');
        RS.searchlogic('Events', 'IL', '',sd ,'' , '95050');
        RS.searchlogic('Events', 'YY', '',sd ,'' , '');
        RS.searchlogic('', '', '','' ,'' , '');
        
        
        test.stoptest();
        
        RS.validateinfo();
        List<string> dc_cg = new list<string>();  
        dc_cg.clear();
        for(integer i=0; i<customgivelist.size(); i++)
        {
            dc_CustomGive dc = new dc_CustomGive();     
                dc_cg = dc.dc_createlist(customgivelist[i]);
                
                if(dc_cg.size() > 11 )
                    {
                        dc = new dc_customgive(
                        customgivelist[i].id, dc_cg[0],dc_cg[1],dc_cg[2],dc_cg[3],dc_cg[4],dc_cg[5],dc_cg[6],dc_cg[7],dc_cg[8],dc_cg[9],dc_cg[10],dc_cg[11],dc_cg[12],dc_cg[13],dc_cg[14],dc_cg[15],dc_cg[16],dc_cg[17]
                        );
                    }
        }
            dc_cg.clear();
             dc_CustomGive dcinst = new dc_CustomGive();        
            dc_cg = dcinst.dc_createinstlist(listgiveinstance[0]);        
    }
    
    public static testMethod void dc_calout()
    
    {
        String defaultDistance = '100';
        try { defaultDistance = Rucksack_Mobile_Services__c.getAll().get('Default Search Radius').Value__c; } catch (Exception e) {}
        
       dc_GetLatitudeLongitudeForRadiusSearch.dc_GetLatLon('95050', defaultDistance+' Miles');
        HTTPResponse res = new HTTPResponse();
        double distance = double.valueOf(defaultDistance); double lat = 40; double lon = 120; string state_xml = 'CA';
        dc_GetLatitudeLongitudeForRadiusSearch.dc_GetLatitudeLongitudeForRadiusSearch(lon, lat, state_xml,distance);
        dc_GetLatitudeLongitudeForRadiusSearch.dc_GetLatitudeLongitudeForRadiusSearch(-120, 40, state_xml,distance);
        dc_GetLatitudeLongitudeForRadiusSearch.dc_GetLatitudeLongitudeForRadiusSearch(0, 0, state_xml,distance);


       dc_GetLatitudeLongitudeForRadiusSearch.dc_GetLatLon(null, defaultDistance+' Miles');
        res = new HTTPResponse();
        distance = double.valueOf(defaultDistance); lat = 40;  lon = 120;  state_xml = 'CA';
        dc_GetLatitudeLongitudeForRadiusSearch.dc_GetLatitudeLongitudeForRadiusSearch(lon, lat, state_xml,distance);
        dc_GetLatitudeLongitudeForRadiusSearch.dc_GetLatitudeLongitudeForRadiusSearch(-120, 40, state_xml,distance);
        dc_GetLatitudeLongitudeForRadiusSearch.dc_GetLatitudeLongitudeForRadiusSearch(0, 0, state_xml,distance);
  
    }
    
    public static testMethod void dc_ctrl_homepage()
    {
        
        dc_ctrl_homepage home = new dc_ctrl_homepage();
        home.getPostImgId();
        home.getfeature_reward();
        home.its();
        home.its_Partner();
        home.getFeaturedPartnerLogo();
        home.getPartners();
        home.Feed();
        home.PartnerPage();
        home.previous();
        home.next();
        home.getFeedList();
        
        // Partnership_Request__c PR = new Partnership_Request__c();
        // PR = [select id from Partnership_Request__c limit 1];
         
        Partnership_Request__c PR = test_Utilities.createPartnership();
            
        System.currentPageReference().getParameters().put('id', PR.id);
        dc_ctrl_PartnerDetails PD = new dc_ctrl_PartnerDetails();
        //PD.dc_ctrl_PartnerDetails();
        PD.getPartner();
        PD.its();   
    }
    
   public static testMethod void dc_ctrl_FAQ()
    {
    	FAQ__c f = new FAQ__c();
    	f.Category__c = 'Catagory';
    	f.Question__c = 'Question';
    	f.Answer__c = 'Answer';
    	
    	insert f;
    	
    dc_ctrl_FAQ FAQ = new dc_ctrl_FAQ();
        FAQ.getResultSize() ;
        FAQ.getFaqs();      
        FAQ.its();  
        FAQ.getCUSTFAQ();
        
        //dc_ctrl_FAQ.dc_CustomFAQ f2 = dc_ctrl_FAQ.dc_CustomFAQ('Catagory', 'Question', 'Answer', 'Change1', 'Change2');
        //List<dc_ctrl_FAQ.dc_CustomFAQ> l = f2.getCUSTFAQ();
        
    }
    
     public static testMethod void dc_ctrl_partner()
    {
        // Partnership_Request__c PR = new Partnership_Request__c();
        // PR = [select id from Partnership_Request__c limit 1];
         
        Partnership_Request__c PR = test_Utilities.createPartnership();
            
        System.currentPageReference().getParameters().put('id', PR.id);

        dc_ctrl_PartnerDetails PD = new dc_ctrl_PartnerDetails();
        PD.getPartner();
        PD.its();  
    }
    
    public static testMethod void dc_ctrl_requestreward() {
        
    }
    
    /*
    public static testMethod void dc_ctrl_requestreward()
    {
        List<Give__c> customgivelist = new list<Give__c>();
         customgivelist = [select id, Category__c, status__c,available__c, Deadline__c,type__c, name,Number_Remaining__c,City__c, Location_Formula__c,Location_by_State_s__c,Zip_Code_s__c,
                                description__c,Partnership_Request__c,Latest_Application_Deadline__c,Must_be_21__c,
                                location_description__c,Partnership_Request__r.Public_Partner_Name__c,Maximum_Units_per_Member__c,(select id, start_date__c, start_time__c, 
                                end_date__c, end_time__c, date_to__c, date_from__c from Give_Instances__r order by start_date__c asc),(select id From Attachments where Name like '%logo%' limit 1) from Give__c 
                                limit 1
                                ] ;
        Give_Instance__c GI = new Give_Instance__c();
        GI = customgivelist[0].Give_Instances__r.get(0);
        id giveinstanceid = GI.id;
        dc_ctrl_requestreward RR = new dc_ctrl_requestreward();
        System.currentPageReference().getParameters().put('giveid',customgivelist[0].id);
        System.currentPageReference().getParameters().put('mem-id','12345');
        System.currentPageReference().getParameters().put('Email','test@test.com');
        Contact con = new Contact();
        con.lastname = 'last';
        con.email = 'test@test.com';
        con.Membership_Id__c = '12345';
        con.Veteran_Member__c = true;
        con.Paperwork_Confirmation__c = 'Paperwork Accepted';
        con.Discharge_Status__c =  'General';
        con.Mailingstreet = 'test';
        insert con;
        RR.givedetlist();
        RR.setpEmail('test@test.com');
        RR.getpEmail() ;
        RR.its() ;
        RR.getgwhen() ;
        RR.setprecord(true) ;
        RR.getprecord() ;
        RR.getstate_value() ;
        RR.setstate_value('IL') ;
        RR.getstate() ;
        RR.setAddressLine1('test'); 
        RR.getAddressLine1() ;
        RR.setAddressLine2('test'); 
        RR.getAddressLine2() ;
        RR.setnumberofinst(true); 
        RR.getnumberofinst() ;
        RR.setspecialresponse ('test'); 
        RR.getspecialresponse() ;
        RR.setspecialque ('test'); 
        RR.getspecialque() ;
        RR.setconfirmevent ('test') ;
        RR.getconfirmevent() ;
        RR.settickets ('test'); 
        RR.gettickets() ;
        RR.setagelimit ('test'); 
        RR.getagelimit(); 
        RR.getGiveDet();
        RR.getGiveList(); 
        RR.getrewardque();
        RR.getinstances();
        RR.getinstances_value();
        RR.setinstances_value(giveinstanceid);
        RR.getticket();
        RR.getticket_value();
        RR.setticket_value(4);
        RR.getage();
        RR.getage_value();
        RR.setage_value('YES');
        RR.getcontactinfo();
        RR.submitrequest();
    }
    */
    
        public static testmethod void dc_ctrl_RewardDetails(){
        
        List<Give__c> customgivelist = new list<Give__c>();
         customgivelist = [select id, Category__c, status__c,available__c, Deadline__c,type__c, name,Number_Remaining__c,City__c, Location_Formula__c,Location_by_State_s__c,Zip_Code_s__c,
                                description__c,Partnership_Request__c,Latest_Application_Deadline__c,Must_be_21__c,
                                location_description__c,Partnership_Request__r.Public_Partner_Name__c,Maximum_Units_per_Member__c,(select id, start_date__c, start_time__c, 
                                end_date__c, end_time__c, date_to__c, date_from__c from Give_Instances__r order by start_date__c asc),(select id From Attachments where Name like '%logo%' limit 1) from Give__c 
                                limit 1
                                ] ;
        customgivelist[0].Location_Description__c = 'bla';
        update customgivelist;
        
        dc_ctrl_RewardDetails RD = new dc_ctrl_RewardDetails();
        System.currentPageReference().getParameters().put('giveid',customgivelist[0].id);
        RD.givedetlist();
        RD.getGiveList();
        RD.its();
        RD.getGiveInstList();
        RD.getPartnerLogo();
        RD.getgiveid() ;  
        RD.setgiveid(customgivelist[0].id);
        
    }
    
    public static testmethod void dc_GeoCode(){
        
        // Partnership_Request__c PR = new Partnership_Request__c();
        // PR = [select id from Partnership_Request__c limit 1];
         
        Partnership_Request__c PR = test_Utilities.createPartnership();
        
        Geo_Location__c geo = new Geo_Location__c();
        geo.name = 'Test';
        geo.lat__c = 50;
        geo.lon__c = 120;
        insert geo;     
        
        List<Give__c> listgive = new List<Give__c>();
        listgive.add( new Give__c( Name = 'Test Give', Geo_Location__c = geo.id, Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', National_Give__c = false, Zip_Code_s__c = '95050', Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        listgive.add( new Give__c( Name = 'Test Give', Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', Zip_Code_s__c = '95050', Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        listgive.add( new Give__c( Name = 'Test Give', Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', Zip_Code_s__c = '60613', Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        insert listgive;
                
        Give__c give = test_Utilities.createSimpleGive();
        give.Zip_Code_s__c = '11111';
        update give;       
                        
        test.starttest();
        dc_Give_GeoCodeBatchProcessScheduler geosch = new dc_Give_GeoCodeBatchProcessScheduler();        
        String sch = '0 0 23 * * ?';        
        system.schedule('Geo', sch, geosch);
        
        dc_Give_GeoCodeBatchProcessor geobatch = new dc_Give_GeoCodeBatchProcessor();
        
        geobatch.batchquery= 'select id, Zip_Code_s__c, city__c, Geo_Location__c from give__c where Id = \'' + give.Id + '\'';
        ID batchprocessid = Database.executeBatch(geobatch);
        Test.StopTest();        
    }
    
    public static testmethod void dc_GeoCode2(){
        
        // Partnership_Request__c PR = new Partnership_Request__c();
        // PR = [select id from Partnership_Request__c limit 1];
         
        Partnership_Request__c PR = test_Utilities.createPartnership();
        
        Geo_Location__c geo = new Geo_Location__c();
        geo.name = 'Test';
        geo.lat__c = 50;
        geo.lon__c = 120;
        insert geo;     
        
        List<Give__c> listgive = new List<Give__c>();
        listgive.add( new Give__c( Name = 'Test Give', Geo_Location__c = geo.id, Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', National_Give__c = false, Zip_Code_s__c = '95050', Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        listgive.add( new Give__c( Name = 'Test Give', Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', Zip_Code_s__c = '95050', Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        listgive.add( new Give__c( Name = 'Test Give', Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', Zip_Code_s__c = '60613', Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        insert listgive;
                
        Give__c give = test_Utilities.createSimpleGive();
        give.Zip_Code_s__c = '11111';
        update give;       
                        
        test.starttest();
        dc_Give_GeoCodeBatchProcessScheduler geosch = new dc_Give_GeoCodeBatchProcessScheduler();        
        String sch = '0 0 23 * * ?';        
        system.schedule('Geo', sch, geosch);
        
        dc_Give_GeoCodeBatchProcessor geobatch = new dc_Give_GeoCodeBatchProcessor();
        geobatch.isTest = true;
        
        geobatch.batchquery= 'select id, Zip_Code_s__c, city__c, Geo_Location__c from give__c where Id = \'' + give.Id + '\'';
        ID batchprocessid = Database.executeBatch(geobatch);
        Test.StopTest();        
    }
    
    public static testMethod void dc_ctrl_ext_GiveInstance()
    {
        
        // Partnership_Request__c PR = new Partnership_Request__c();
        // PR = [select id from Partnership_Request__c limit 1];
         
        Partnership_Request__c PR = test_Utilities.createPartnership();
        Contact con = new Contact();
        con.lastname = 'last';
        con.email = 'test@test.com';
        con.Membership_Id__c = '12345';
        con.Veteran_Member__c = true;
        con.Paperwork_Confirmation__c = 'Paperwork Accepted';
        con.Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
        insert con; 
        Geo_Location__c geo = new Geo_Location__c();
        geo.name = 'Test';
        geo.lat__c = 40;
        geo.lon__c = 120;
        insert geo; 
        Geo_Location__c closedgeo = new Geo_Location__c();
        geo.name = 'Test';
        geo.lat__c = 50;
        geo.lon__c = 120;
        insert closedgeo;   
        
        List<Give__c> listgive =  new List<Give__c>(); 
        List<Give_Instance__c> listgiveinstance =  new List<Give_Instance__c>(); 
        listgive.add( new Give__c( Name = 'Test Give', Geo_Location__c = geo.id, Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', National_Give__c = false, Zip_Code_s__c = '95050', Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        listgive.add( new Give__c( Name = 'Test Give', Geo_Location__c = geo.id, Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', National_Give__c = true, Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        listgive.add( new Give__c( Name = 'Test Give', Geo_Location__c = geo.id, Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', Location_by_State_s__c = 'IL', Location_Description__c = 'Test',Status__c = 'Open', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));
        listgive.add( new Give__c( Name = 'Test Give', Geo_Location__c = closedgeo.id, Partnership_Request__c = PR.id, Category__c = 'Events', City__c = 'Test City', National_Give__c = false, Zip_Code_s__c = '95040', Location_Description__c = 'Test',Status__c = 'Closed Visible', Maximum_Units_per_Member__c = 10,  Description__c = 'Test'));       
        insert listgive;
        
        listgiveinstance.add( new Give_Instance__c( Give__c = listgive[0].id, Status__c = 'Open' , Number_of_Units__c = 100));
        listgiveinstance.add( new Give_Instance__c( Give__c = listgive[1].id, Status__c = 'Open' , Number_of_Units__c = 100));
        listgiveinstance.add( new Give_Instance__c( Give__c = listgive[2].id, Status__c = 'Open' , Number_of_Units__c = 100));
        listgiveinstance.add( new Give_Instance__c( Give__c = listgive[3].id, Status__c = 'Open' , Number_of_Units__c = 100));
        listgiveinstance.add( new Give_Instance__c( Give__c = listgive[0].id, Status__c = 'Open' , Number_of_Units__c = 100));
        insert listgiveinstance;
        
        
        ApexPages.standardController sc= new ApexPages.standardController(listgiveinstance[0]); 
        dc_ctrl_ext_GiveInstance GI = new dc_ctrl_ext_GiveInstance(sc);
        
        GI.selectedstage = 'Give requested';
        GI.selectedStartstage = 'Give requested';
        GI.selectedEndstage = 'Give requested';
        GI.updateSelectedStage();
        GI.massUpdateStage();
        
        //GI.RequestSelect(GR);
        //GI.getstageOptions();
        
    }
    
    private static testMethod void testGeoCriteria() {
    	String s = RewardUtilities.GeoCriteria('11111', '100');
    	s = RewardUtilities.GeoCriteria('100', '100', '100');
    }
    
    private static testMethod void testSearchRewards() {
    	Partnership_Request__c part = test_Utilities.createPartnership();
    	Give__c give = test_Utilities.createSimpleGive(part);
    	Give_Instance__c instance = test_Utilities.createSimpleGiveInstance(give);
    	SET<String> gstatus = new SET<String>();
    	gstatus.add('Open');
    	SET<String> istatus = new SET<String>();
    	istatus.add('Open');
    	
    	List<RewardUtilities.Reward> rewards = RewardUtilities.SearchRewards(part.Id, give.Id, instance.Id, true, gstatus, istatus, '11111', '100', '100', '100', 1);   	
    }
}