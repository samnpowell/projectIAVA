// Distribution Center - Controller Class for Home Page
					// Created By - Puneet Aggarwal - 5/21/2010
					// Modified Versions
					
public with sharing class dc_ctrl_homepage {
		
	/***********************************************************  Properties *********************************************/
	
	List<String> strImgLink = new List<String>();
	List<string> att_id = new List<String>();
	List<string> listtitle = new List<String>();
	List<string> listloc = new List<String>();
	List<Id> listgiveid = new List<String>();
	List<string> listdl = new List<String>();
	List<string> listavail = new List<String>();
	List<FeatureReward> FeatureReward = new List<FeatureReward>();	
	public List<dc_Customfeed> customfeedlist = new List<dc_Customfeed>(); 
	Attachment at = new Attachment();
	Attachment fd = new Attachment();
	Attachment FP_at = new Attachment();
		
	/***************************************************  Accessor Methods  *********************************************/
	
	public string defaultlogo  {get; set;}
	public string Partnerdefaultlogo  {get; set;}
 	public ID featuredPartnerId	{get;set;}
 	public string strFP {get; set;}
 	public string strFPdesc {get; set;}
 	public boolean showFP {get; set;}
	
	/**--------------------------------Below method is used to retreive the Partner Logos for the section 
	where Partner Logos are displayed above the footer------------------------------------------------------**/
	public List<PartnerDetails> getPostImgId()        
	{ 
		try
		{		        	
			List<PartnerDetails> retList = new List<PartnerDetails>();
			PartnerDetails partnerDetails;	//Custom List
			strImgLink.clear();
			integer c = 0;

			// NGKJ - ORDER BY Sort_Order_in_Logo_block__c (new field on Partnership_Request__c and LIMIT to 100 logos) 
			for(Partnership_Request__c att:[Select Id,(select id From Attachments where Name like '%logo%' limit 1) from Partnership_Request__c where Show_partner_logo_on_rewards_homepage__c = true ORDER BY Sort_Order_in_Logo_block__c LIMIT 100])
			{
				partnerDetails = new PartnerDetails();
				if(att.Attachments.size() > 0)
				{
					for(integer i=0;i<att.Attachments.size();i++)
					{	
						c = c+1;
						at = att.Attachments.get(i);
						partnerDetails.logoId = att.id;
						partnerDetails.logoURL = '/servlet/servlet.FileDownload?file=' +  at.id;
						partnerDetails.PartnerDesc = '';
						strImgLink.add('/servlet/servlet.FileDownload?file=' + at.id);
						retList.add(partnerDetails);
					}
				}
				// NGKJ - Limit by LIMIT clause (100) instead ...
				// if(c == 6)	//Ensuring that only 6 logos are visible
				//	break;
			}
			return retList; 
		}
		catch(exception e)
    	{
    		return null;		
    	}      
	}
	/** -------------------------Method to retreive Partner Logos for footer ends----------------------------------------**/
	
	/** -------Method below retreives and creates the custom list for the Featured Rewards Section -------------**/
	public List<FeatureReward> getfeature_reward()        
	{ 		
		try
		{        	
			integer d=0;
			for(Give__c featreward:[Select Id, name, category__c, location_formula__c, Available__c, (select id From Attachments where Name like '%logo%' limit 1) from Give__c where Highlight_Listing__c = true])
			{
				System.debug('featreward.name: ' + featreward.name);
				d = d+1;
				if(featreward.Attachments.size() > 0)
				{	
						fd = featreward.Attachments.get(0);
						att_id.add('/servlet/servlet.FileDownload?file=' + fd.id);	//Logo for Reward
						listdl.add(featreward.category__c + '.jpg');
				}
				else
				{
					att_id.add('false');
					listdl.add(featreward.category__c + '.jpg');	//Default logo when logo is not found for reward
				}	
					listtitle.add(featreward.name);		//Name of Reward
					listloc.add(featreward.location_formula__c);	//Location of Reward
					listgiveid.add(featreward.id);	//Id of Reward
					listavail.add(featreward.Available__c);  //Status of Reward
				if(d ==6)
					break;
			}
			/** Since each row has two rewards, below section divides rewards into odd and even
			and create a list such that singe record has two Reward records (odd and even)**/
			id odd_gid;			
			id even_gid;
			string odd_att = '';
			string even_att = '';
			string odd_title = '';
			string odd_defaultlogo = '';
			string even_defaultlogo = '';
			string even_title = '';	
			string odd_loc = '';
			string even_loc = '';
			string odd_avail = '';
			string even_avail = '';
			FeatureReward.clear();
			for(integer n=0;n<att_id.size();n++)
			{
				if(att_id.size() > n+1)
					even_att=att_id[n+1];
				odd_att = att_id[n];
				if(listtitle.size() > n+1)
					even_title=listtitle[n+1];
				odd_title = listtitle[n];
				if(listloc.size() > n+1)
					even_loc=listloc[n+1];
				odd_loc = listloc[n];
				if(listgiveid.size() > n+1)
					even_gid=listgiveid[n+1];
				odd_gid = listgiveid[n];
				if(listdl.size() > n+1)
					even_defaultlogo=listdl[n+1];
				odd_defaultlogo = listdl[n];
				if(listavail.size() > n+1)
					even_avail=listavail[n+1];
				odd_avail = listavail[n];
				
				/** Single list record of custom list contains both odd and even reward record details**/
				/** Details being added into the custom list below**/
				FeatureReward.add(new FeatureReward(odd_gid,odd_title,odd_loc,odd_att,odd_defaultlogo,odd_avail,even_gid,even_title,even_loc,even_att, even_defaultlogo, even_avail ));
				
				/** Initializing the strings again to ensure that in case odd number of featured rewards are found,
				then the broken url is not created for the even record place holder **/
				n= n+1;
				odd_att = '';
				even_att = '';
				odd_title = '';
				even_title = '';								
				odd_loc = '';
				even_loc = '';
				odd_avail = '';
				even_avail = '';
			} // end of For Loop
								
			system.debug('FeatureReward::::' + FeatureReward);
			return FeatureReward;   //return custom list
		}
		catch(exception e)
    	{
    		return null;		
    	}			
					     
	}
	/** ----------------------Method to created list of Featured Rewards ends here-----------------------------------**/
	
	/** ----------------------Method below creates the list of Partners on Partners Page --------------------**/

	// NGKJ - Set LIMIT to 100 records (quick workaround for disabling paging)
	// NGKJ - ORDER BY Sort_Order_on_Partners_page__c (new field on Partnership_Request__c) 
	public ApexPages.StandardSetController setCon 
	{
		get 
		{
    		if(setCon == null) 
    		{
				setCon = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id,(select id From Attachments where Name like '%logo%' limit 1),Public_Description__c,Public_Partner_Name__c, Stage__c from Partnership_Request__c where Show_Partner_Logo__c = true AND Stage__c='Active Partnership' ORDER BY Sort_Order_on_Partners_page__c LIMIT 100] ));
    		}
        	return setCon;
        }
        set;
    }
	
	// indicates whether there are more records before the current page set.				
	public Boolean hasNext 
	{
		get 
		{
			return setcon.getHasNext();
		}
		set;
	}
	
	// indicates whether there are previous records before the current page set.
	public Boolean hasPrevious {
		get {
			return setcon.getHasPrevious();
		}
		set;
	}
	
 	// returns the previous page of records
 	public void previous() {
 		setcon.previous();
 	}
 
 	// returns the next page of records
 	public void next() {
 		setcon.next();
 	}	
 	//Creating the list of Partners using Std. APEX controller
 	public List<PartnerDetails> getPartners() 
    {
    	List<PartnerDetails> retList = new List<PartnerDetails>();
    	PartnerDetails partnerDetails;
		for (Partnership_Request__c PR : (List<Partnership_Request__c>)setCon.getRecords())
		{
			partnerDetails = new PartnerDetails();
			partnerDetails.partnershipRec = (Partnership_Request__c)PR;
			if(PR.Attachments.size() > 0)
			{
				for(integer i=0;i<PR.Attachments.size();i++)
				{	
					partnerDetails.logoId = PR.Attachments.get(i).id;
					partnerDetails.logoURL = '/servlet/servlet.FileDownload?file=' + PR.Attachments.get(i).id;
				}
			}
			else
			{
				partnerDetails.logoId = 'No Company Logo';
				partnerDetails.logoURL = ' ';
			}
				Partnerdefaultlogo = 'Partner.jpg'; //default logo name if Partner does not have a logo
				if(PR.Public_Description__c != null && PR.Public_Description__c.length() > 100)
					partnerDetails.PartnerDesc = PR.Public_Description__c.substring(0,100) + '...';
				else partnerDetails.PartnerDesc = PR.Public_Description__c;
				
				retList.add(partnerDetails);
		}	
    	return retList;
    }
    /**-----------------Method to create list of Partners on Partners Page ends here---------------------**/
    
 	/** --------------------------Method below gets the Featured Partner details --------------------------**/
 	public string getFeaturedPartnerLogo()        
	{ 	
		try
		{	        	
			strFP = ' ';
			strFPdesc = ' ';
			for(Partnership_Request__c FP:[Select Id, Public_Description__c,(select id From Attachments where Name like '%logo%' limit 1) from Partnership_Request__c where Featured_Partner__c = true limit 1])
			{
				if(FP.Attachments.size() > 0){
				for(integer i=0;i<FP.Attachments.size();i++)
				{	
					FP_at = FP.Attachments.get(i);
					strFP = '/servlet/servlet.FileDownload?file=' + FP_at.id;
				}
				}
				strFPdesc =  FP.Public_Description__c;
				featuredPartnerId=FP.Id;
				showFP = true;
			}
			return strFP;  
		}
		catch(exception e)
		{ 
			return null;
		}					
	}			
	/**---------------Method to get the Featured Partner details ends here---------------------------**/

    
    	public list<dc_CustomFeed> getFeedList()
  	{   
    	if(customfeedlist!= null)
    		return customfeedlist ;
    	else return null;
  	} 	
	
	/*************************************  Action Methods  *********************************************/
	
	/**----------------MEthod below directs to the Partner Page ---------------------**/
	public PageReference PartnerPage()
	{
		PageReference pageRef = Page.dc_Partners;
	
		return pageRef;
	}
	/** Below method is called from dc_homepage to ensure the 'IAWA Rewards' in IN THIS SECTION is highlighted**/
	public void its()
  	{
  		Staticvar.dc_homepage = true;
  		Staticvar.dc_rewardsearch = false;
  		Staticvar.dc_rewarddetail = false;
  		Staticvar.dc_claimreward = false;
  		Staticvar.dc_partner = false;
  		Staticvar.dc_faq = false;

  	}	
  	/** Below method is called from dc_Partners to ensure the 'Partners' in IN THIS SECTION is highlighted**/
  	public void its_Partner()
  	{
  		Staticvar.dc_homepage = false;
  		Staticvar.dc_rewardsearch = false;
  		Staticvar.dc_rewarddetail = false;
  		Staticvar.dc_claimreward = false;
  		Staticvar.dc_partner = true;
  		Staticvar.dc_faq = false;
		Staticvar.title = 'IAVA Rucksack - Partners';
  	}
 	
	/****************************************  Helper/Utility Methods  *********************************************/
	
	/** --------------------Wrapper class for custom list of Featured Rewards-----------------------**/
		public class FeatureReward {
		public id giveid_1 {get; set;}
		public string title_1 {get; set;}
		public string location_1 {get; set;}
		public string attachment_1 {get; set;}
		public string defaultlogo_1 {get; set;}
		public string available_1 {get; set;}
		public id giveid_2 {get; set;}
		public string title_2 {get; set;}
		public string location_2 {get; set;}
		public string attachment_2 {get; set;}
		public string defaultlogo_2 {get; set;}
		public string available_2 {get; set;}
		public FeatureReward(id gid_1, string t_1, string loc_1, string a_1, string dl_1, string av_1, id gid_2, string t_2, string loc_2, string a_2, string dl_2, string av_2)
		{
			giveid_1 = gid_1;
			title_1 = t_1;
			location_1 =  loc_1;
			attachment_1 = a_1;
			defaultlogo_1 = dl_1;
			available_1 = av_1;
			giveid_2 = gid_2;
			title_2 = t_2;
			location_2 =  loc_2;
			attachment_2 = a_2;
			defaultlogo_2 = dl_2;
			available_2 = av_2;
		}		
	}		
	/** -------------------------Wrapper class for custom list of Featured Rewards ENDS-----------------------**/

 	/** -------------------------Wrapper class for custom list of RSS Feed-----------------------**/
		
		public with sharing class dc_Customfeed {
		public string pubdate_1 {get; set;}
		public string title_1 {get; set;}
		public string link_1 {get; set;}
		public string description_1 {get; set;}
		public string pubdate_2 {get; set;}
		public string title_2 {get; set;}
		public string link_2 {get; set;}
		public string description_2 {get; set;}
		public string pubdate_3 {get; set;}
		public string title_3 {get; set;}
		public string link_3 {get; set;}
		public string description_3 {get; set;}
		public dc_customfeed(string pdate_1, string t_1, string li_1, string descr_1,
		string pdate_2, string t_2, string li_2, string descr_2,string pdate_3, string t_3, string li_3, string descr_3)		
			{			
				pubdate_1 = pdate_1;
				title_1 = t_1;
				link_1 = li_1;
				description_1 =  descr_1;
				pubdate_2 = pdate_2;
				title_2 = t_2;
				link_2 = li_2;
				description_2 =  descr_2;
				pubdate_3 = pdate_3;
				title_3 = t_3;
				link_3 = li_3;
				description_3 =  descr_3;
			}
		}
	
	/** ------------------------------Wrapper class for custom list of RSS Feed ENDS-----------------------**/
	
	/** -----------------------------------------Method to create RSS Feed-----------------------**/
	public void Feed()
	{

		Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('http://iava.org/partnerships/feed');
        List<string> title = new list<string>();
		List<string> link = new list<string>();
		List<string> description = new list<string>();
		List<string> pubdate = new list<string>();
		customfeedlist.clear();
		integer n =0;

		HTTPResponse res;
		// 10/2015 quick fix - avoid test callout error
		// TODO: implement mock callout feature
        if (!Test.isRunningTest()) {
	        res = h.send(req);
	    
	        dom.Document doc = res.getBodyDocument();
			//item
			dom.XmlNode location = doc.getRootElement(); 
			List<string> strFeed = new List<String>();  
			strFeed.clear();      
			for(dom.XmlNode node : doc.getRootElement().getChildElement('channel',null).getChildElements()) {
	   			if(node.getName()=='item' && n < 3) {
	      			//customfeedlist.add(new dc_customfeed(
	              	strFeed.add(node.getChildElement('pubDate', null).getText().substring(0, 11));
	              	strFeed.add(node.getChildElement('title', null).getText());
	      			strFeed.add(node.getChildElement('link', null).getText());
	      			strFeed.add(node.getChildElement('description', null).getText().substring(0, 100));              	
	              	n = n + 1;
	   			}
	   		}
	   		if(strFeed.size() > 11)
	   		{	
	   			customfeedlist.add(new dc_customfeed(
	   			strFeed[0],strFeed[1],strFeed[2],strFeed[3],strFeed[4],strFeed[5],strFeed[6],strFeed[7],strFeed[8],strFeed[9],strFeed[10],strFeed[11]
	   			));
	   		}
	   	}
	}
	/** ----------------------------Method to create RSS Feed ENDS--------------------------------------**/
}