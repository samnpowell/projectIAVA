/*
Copyright (c) 2009 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Nick Koopman, nkoopman@etherios.com
*/

public class NewCampaignOverrideExtension {

	// Selection dropdown for Campaign Templates

	public Boolean error { get; set; }
	public String selection { get; set; }

    public List<ApexPages.SelectOption> templates = new List<ApexPages.SelectOption>();

	public List<ApexPages.SelectOption> getTemplates()
	{	if (templates.size() == 0)
		{
			List<Campaign> campaigns = [SELECT id, name FROM Campaign WHERE template__c = true];
			for(Campaign campaign : campaigns)
			{
				templates.add(new ApexPages.SelectOption(campaign.id,campaign.name));
			}
		}
		return templates;
	}

    private final ApexPages.Standardcontroller sctrl;

	// Constructor Class

    public NewCampaignOverrideExtension(ApexPages.StandardController controller) {
    	error = false;
    	Integer count = [SELECT COUNT() FROM Campaign WHERE template__c = true];
		if (count < 1) {
   			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'There are no templates to use.  Click Cancel or New Template.'));
   			error = true;
		}
		sctrl = controller;
    }

}