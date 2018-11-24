/*
Copyright (c) 2009 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Nick Koopman, nkoopman@etherios.com
*/
@isTest
private class NewCampaignOverrideExtension_Tests {

    static testMethod void NewCampaignOverrideExtension_Test() {
        // System.debug('NewCampaignOverrideExtension_Test: Start');
        Campaign c = new Campaign();
        Pagereference pr = Page.NewCampaignOverride;
		Test.setCurrentPage(pr);
		ApexPages.StandardController sc = new ApexPages.StandardController(c);
		NewCampaignOverrideExtension ext1 = new NewCampaignOverrideExtension(sc);
		c.Name = 'myTemplate';
        c.Template__c = true;
        insert c;
		NewCampaignOverrideExtension ext2 = new NewCampaignOverrideExtension(sc);
        // System.debug('NewCampaignOverrideExtension_Test: Finish');
    }
}