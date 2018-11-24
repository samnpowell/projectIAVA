public with sharing class dc_ctrl_PartnerDetails 
{
	private Partnership_Request__c partner;
	public string logoURL {get; set;}
	public string Partnerdefaultlogo {get; set;}
	

	public dc_ctrl_PartnerDetails()
	{
		if ( partner == null )
		{
				logoURL = ' ';
				Partnerdefaultlogo = 'Partner.jpg';
			partner = [SELECT id,
				        Contact_Information__c,
				        End_Date__c,
				        Featured_Partner__c,
				        Number_of_Total_Gives__c,
				        Organization__c,
				        Partnership_Type__c,
				        Priority__c,
				        Public_Description__c,
				        Public_Detail_Description__c,
				        Public_Partner_Name__c,
				        Show_Partner_Logo__c,
				        Show_partner_logo_on_rewards_homepage__c,
				        Stage__c,
				        Start_Date__c,
				        Ticket_Give_Stage__c, (select id From Attachments where Name like '%logo%' limit 1)
	        		FROM Partnership_Request__c
	                WHERE id = :ApexPages.currentPage().getParameters().get('id')];
	                
	                if(partner.Attachments.size() > 0)
					{
						Attachment at = new Attachment();
						for(integer i=0;i<partner.Attachments.size();i++)
						{	
							at = partner.Attachments.get(i);
							logoURL = '/servlet/servlet.FileDownload?file=' +  at.id;
						}
					}
		}
			
	}
	

    public Partnership_Request__c getPartner() {
        return partner;
    }	
    
    public void its()
  	{
  		Staticvar.dc_homepage = false;
  		Staticvar.dc_rewardsearch = false;
  		Staticvar.dc_rewarddetail = false;
  		Staticvar.dc_claimreward = false;
  		Staticvar.dc_partner = true;
  		Staticvar.dc_faq = false;
  		Staticvar.title = 'IAVA Rucksack - Partners';

  	}
}