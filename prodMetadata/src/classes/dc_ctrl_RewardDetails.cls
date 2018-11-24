// Distribution Center - Controller Class for Reward Detail Page
                    // Created By - Puneet Aggarwal - 5/21/2010
                    // Modified Versions
                    
public with sharing class dc_ctrl_RewardDetails {
    
    /******************************  Properties *********************************************/
    
    public List<dc_CustomGive> gcustom = new List<dc_CustomGive>();
    public List<dc_CustomGive> ginst = new List<dc_CustomGive>();
    List<Give__c> givedetlist = new List<Give__c>();
    List<Give_Instance__c> giveinstlist = new List<Give_Instance__c>();
    public id giveid;
    Attachment FP_at = new Attachment();
            
    /******************************  Accessor Methods  *********************************************/
    
    public string gwhen { get; set; }
    public string available { get; set; }
    public string glogo { get; set; }
    public string gwhere { get; set; }
    public string gqty { get; set; }
    public string grest { get; set; }
    public string gprov { get; set; }
    public string gdeadline { get; set; }
    public boolean multigive { get; set; }
    public string give_title { get; set; }
    public string mail_body { get; set; }
    public string tw_msg { get; set; }
    public id PR_id { get; set; }
    public string details { get; set; }
    public string addrDet { get; set; }
    public string addrStreet { get; set; }    
    public string venue { get; set; }
    public string strFP {get; set;}
    public string strFPdesc {get; set;}

    public Give_Request__c existingRequest {get; set;}
    public string gAvailableTo {get; set;} // SD - 5/14
    public Boolean isMobile {get; set;}
    
    public String IAVAHost {
        get {
            IAVAPlus_Portal_Settings__c ps = IAVAPlus_Portal_Settings__c.getInstance('IAVA');
            return (ps == null ? '' : ps.Secure_Site_URL__c);
        }
    }
    
    public void setgiveid (id s) 
    {
        giveid = s;
    }
    public id getgiveid() 
    {
        return giveid;  
    }
        
    public list<dc_CustomGive> getGiveList()
    {   
        try
        {
            if(gcustom!= null)
                return gcustom ;
            else return null;
            }
            catch(exception e)
            { return null;}
        } 
        
    public list<dc_CustomGive> getGiveInstList()
    {   
        try
        {
            if(ginst!= null)
                return ginst ;
            else return null;
            }
        catch(exception e)
        { 
            return null;
        }
    } 
    
    /**----------------Method below gets the Partner Details corresponding to the Reward--------------**/
    public string getPartnerLogo()        
    {       
        try
        {           
            strFP = ' ';
            strFPdesc = ' ';
            for(Partnership_Request__c FP:[Select Id, Public_Description__c,(select id From Attachments where Name like '%logo%' limit 1) from Partnership_Request__c where id = :PR_id limit 1])
            {
                if(FP.Attachments.size() > 0)
                {
                    for(integer i=0;i<FP.Attachments.size();i++)
                    {   
                        FP_at = FP.Attachments.get(i);
                        strFP = '/servlet/servlet.FileDownload?file=' + FP_at.id;
                    }
                }
                //if(FP.Public_Description__c != null && FP.Public_Description__c.length() > 101)
                //    strFPdesc =  FP.Public_Description__c.substring(0,100) + '...';
                //else
                    strFPdesc =  FP.Public_Description__c;
            }
            return strFP;       
        }
        catch(exception e)
        { 
            return null;    
        }   
    }   
    /**--------------------Method to retreive Partner details ends here------------------------------**
    
    /********************************************  Action Methods  *********************************************/
    
    /**----- Below Method is called as an action on dc_RequestReward page to retrieve reward details---**/
    public void givedetlist()
    {                   
        try
        {
            if(apexpages.currentpage().getparameters().get('giveid') != null)
            {
                givedetlist = [select id, Category__c , available__c,details__c, type__c, status__c, deadline__c,location_formula__c,name,Number_Remaining__c,City__c, Location_by_State_s__c,Zip_Code_s__c,
                    description__c,Partnership_Request__c,Requires_Special_Response__c,Special_Instructions__c,Latest_Application_Deadline__c,Must_be_21__c,
                    location_description__c,Location_Street_Address__c,Member_Cannot_Select_Quantity__c,Partnership_Request__r.Public_Partner_Name__c,Maximum_Units_per_Member__c
                    , Available_To__c, Fulfillment_Instructions_for_Winner__c, Latitude__c, Longitude__c
                    ,(select id, status__c, start_date__c, Location__c,start_time__c, 
                    end_date__c, end_time__c, date_to__c, year_start_date__c,year_end_date__c, date_from__c, Differentiator__c from Give_Instances__r order by start_date__c asc)
                    ,(select id, Name From Attachments)
                    From Give__c 
                    Where Id=:apexpages.currentpage().getparameters().get('giveid')];
            }
            if(givedetlist.size() > 0)
            {
                PR_id = givedetlist[0].Partnership_Request__c; //Setting Partner Id
                give_title = givedetlist[0].name;   //give title
                details = givedetlist[0].details__c;
                Staticvar.title = 'IAVA Rucksack - ' + give_title;
                /** Setting variables for mailto: URL link in APEX **/
                mail_body =  System.Label.dc_RewardDetail_Mail_Body +  '%0d' + '%0d' + 'Reward Title: ' + give_title + '%0d' + 'Reward Link: ' ;
                tw_msg = givedetlist[0].id ;
                
                /** Below is the logic to display "Where:" details in Reward Detail page**/
                addrDet = '';
                venue = '';
                addrStreet = '';
                if(givedetlist[0].Location_Description__c != null)
                {
                    venue = givedetlist[0].Location_Description__c;
                    if(givedetlist[0].City__c != null)
                        addrDet = givedetlist[0].City__c;
                    if(givedetlist[0].City__c != null && givedetlist[0].Zip_Code_s__c != null)
                        addrDet = addrDet + ', ';
                    if(givedetlist[0].Zip_Code_s__c != null)
                        addrDet = addrDet + givedetlist[0].Zip_Code_s__c;
                    if(givedetlist[0].Location_Street_Address__c != null)
                        addrStreet = givedetlist[0].Location_Street_Address__c;
                }

                /** SD - 5/14 - include who the give is available to **/
                String giveCategories = givedetlist[0].Available_To__c == null ? 'Confirmed' : givedetlist[0].Available_To__c;
                gAvailableTo = dc_ctrl_requestreward.cleanAvailableCategories(giveCategories.split(';', 0));

                /** Creating the custom list and adding Give specific details **/
                gcustom.clear();
                List<string> dc_cg = new list<string>();
                dc_cg.clear();
                dc_CustomGive dc = new dc_CustomGive();
                dc_cg = dc.dc_createlist(givedetlist[0]);
                if(dc_cg.size() > 0 )
                {
                    gcustom.add(new dc_customgive(
                    givedetlist[0].id, dc_cg[0],dc_cg[1],dc_cg[2],dc_cg[3],dc_cg[4],dc_cg[5],dc_cg[6],dc_cg[7],dc_cg[8],dc_cg[9],dc_cg[10],dc_cg[11],dc_cg[12],dc_cg[13],dc_cg[14],dc_cg[15],dc_cg[16],dc_cg[17]
                    ));
                }
                
                /** Creating custom list for give instances of the give **/
                giveinstlist = [Select Id, status__c, End_Date__c, End_Time__c, Give__c, 
                    Start_Time__c, Start_Date__c, date_from__c, date_to__c, year_start_date__c,year_end_date__c,Number_Remaining__c, Differentiator__c
                    From Give_Instance__c 
                    Where Give__c =:apexpages.currentpage().getparameters().get('giveid') order by start_date__c asc];
                    system.debug('giveinstlist:::::::::' + giveinstlist);
                ginst.clear();
                List<string> dc_cgi = new list<string>();
                if(giveinstlist.size() > 1)
                {
                    multigive = true;
                    for(integer n=0;n<giveinstlist.size();n++)
                    {
                        dc_CustomGive dci = new dc_CustomGive();
                        dc_cgi = dci.dc_createinstlist(giveinstlist[n]);
                        if(dc_cgi.size() > 0 )
                        {
                            dc_CustomGive cgInst = new dc_customgive(givedetlist[0].id, dc_cgi[0],givedetlist[0].description__c,dc_cgi[2],dc_cgi[3],dc_cgi[4],dc_cgi[5],dc_cgi[6],dc_cgi[7],dc_cgi[8],dc_cgi[9],dc_cgi[10],dc_cgi[11],dc_cgi[12],dc_cg[13],dc_cg[14],dc_cg[15],dc_cg[16],dc_cg[17]);
                            cgInst.instanceId = giveinstlist[n].id;
                            cgInst.instDifferentiator = giveinstlist[n].Differentiator__c;
                            ginst.add(cgInst);
                        }
                    }//end for
                }//end if

                Id conId = cov_user_utility.self.getCId();
                if (conId != null) {
                    queryExistingRequest(givedetlist[0].Id, conId);
                }
                //if (conId != null) {
                //    try {
                //        existingRequest = [select Id, Give_Instance__c, Stage__c, Give_Instance__r.date_from__c, Give_Instance_Start_Date__c from Give_Request__c where Give_Instance__r.Give__c = :givedetlist[0].Id and Applicant__c = :conId];
                //        system.debug('Existing request on file: ' + existingRequest);
                //    } catch (QueryException e) {
                //        system.debug('No existing request on file');
                //    } catch (Exception e) {
                //        cov_log_error.logError(e, 'Error querying for give request');
                //    }
                //}



            }//end if give exists
            isMobile = cov_user_utility.self.getIsMobile();
        }
        catch(exception e)
        {
        }
    }

    public void queryExistingRequest(Id theGiveId, Id theContactId) {
        if (theGiveId != null && theContactId != null) {
            try {
                existingRequest = [select Id, Give_Instance__c, Stage__c, Give_Instance__r.date_from__c, Give_Instance_Start_Date__c from Give_Request__c where Give_Instance__r.Give__c = :theGiveId and Applicant__c = :theContactId];
                system.debug('Existing request on file: ' + existingRequest);
            } catch (QueryException e) {
                system.debug('No existing request on file');
            } catch (Exception e) {
                cov_log_error.logError(e, 'Error querying for give request');
            }
        } else {
            cov_log_error.logDevMsg('give Id or contact Id was null when trying to query for give request.');
        }
    }

    public PageReference cancelRequest() {
        String giveId = Apexpages.currentpage().getparameters().get('giveid');
        Id conId = cov_user_utility.self.getCId();
        if (conId == null || String.isEmpty(giveId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry there was an error canceling your request. Please contact IAVA staff for assistance.'));            
        } else {
            system.debug('About to try to cancel. giveId: ' + giveId + ' and conId: ' + conId);
            Give_Request__c theRequest = dc_ctrl_requestreward.updateStage(giveId, conId, 'Canceled');
            if (theRequest != null && theRequest.Stage__c == 'Canceled') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, 'Request Canceled.'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry there was an error canceling your request. Please contact IAVA staff for assistance.'));            
            }
            queryExistingRequest(giveId, conId); // to refresh the request record when redisplayed
        }
        return null;
    }
    
    /** Method below is to ensure that 'Find Reward' is highlighted in IN THIS SECTION **/      
    public void its()
    {
        Staticvar.dc_homepage = false;
        Staticvar.dc_rewardsearch = false;
        Staticvar.dc_rewarddetail = true;
        Staticvar.dc_claimreward = false;
        Staticvar.dc_partner =false;
        Staticvar.dc_faq = false;
    } 
}