/*
Copyright (c) 2009 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Nick Koopman, nkoopman@etherios.com
*/
@isTest
private class AutoX_Tests {

    static testMethod void AutoX_Test() {

        System.debug('AutoX_Test: Start AutoMember');

		Map<String, String> AutoMemberMap = new Map<String, String>();
        // Salesforce Field / Input Parameter
        AutoMemberMap.put('FirstName','Fluffy');
        AutoMemberMap.put('LastName','Duff');
        AutoMemberMap.put('Email','Fluffy@Duff.net');
        AutoMemberMap.put('Phone','999-555-1212');
        AutoMemberMap.put('MailingStreet','987 Fluffy Duff Terrace');
        AutoMemberMap.put('MailingCity','Podunk');
        AutoMemberMap.put('MailingState','IL');
        AutoMemberMap.put('MailingPostalCode','54321');
        AutoMemberMap.put('MailingCountry','USA');
        AutoMemberMap.put('Veteran_of_OEF__c','true');
        AutoMemberMap.put('Veteran_of_OIF__c','false');
        AutoMemberMap.put('Veteran_of__c','OEF');
        AutoMemberMap.put('Rank__c','E1');
        AutoMemberMap.put('Branch_of_Service__c','Army');
        AutoMemberMap.put('Current_Status__c','Currently Serving');
        AutoMemberMap.put('Service_Type__c','Active Duty');
        AutoMemberMap.put('Most_Recent_Unit__c','Unit 123');

        Pagereference pAutoMember = Page.AutoMember;
        for (String id : AutoMemberMap.keySet()) {
			String value = AutoMemberMap.get(id);
			System.debug('AutoX_Test AutoMember: adding id:' + id + ' with value:' + value);
			pAutoMember.getParameters().put(id,value);
        }
        
		Test.setCurrentPage(pAutoMember);
		AutoMemberCon amcon = new AutoMemberCon();
		amcon.ProcessInsert();
		Contact c = [SELECT Id,Phone,MailingStreet,MailingCity,MailingState,MailingPostalCode,MailingCountry,Veteran_of_OEF__c,Veteran_of_OIF__c,Rank__c,Branch_of_Service__c,Current_Status__c,Service_Type__c,Most_Recent_Unit__c FROM Contact WHERE FirstName = 'Fluffy' AND LastName = 'Duff' AND Email = 'Fluffy@Duff.net' LIMIT 1];
		System.assertEquals(c.Phone,'999-555-1212');
        System.assertEquals(c.MailingStreet,'987 Fluffy Duff Terrace');
        System.assertEquals(c.MailingCity,'Podunk');
        System.assertEquals(c.MailingState,'IL');
        System.assertEquals(c.MailingPostalCode,'54321');
        System.assertEquals(c.MailingCountry,'USA');
        System.assertEquals(c.Veteran_of_OEF__c,true);
        System.assertEquals(c.Veteran_of_OIF__c,false);
        System.assertEquals(c.Rank__c,'E1');
        System.assertEquals(c.Branch_of_Service__c,'Army');
        System.assertEquals(c.Current_Status__c,'Currently Serving');
        System.assertEquals(c.Service_Type__c,'Active Duty');
        System.assertEquals(c.Most_Recent_Unit__c,'Unit 123');
		System.debug('AutoX_Test: Finish AutoMember');
		
        System.debug('AutoX_Test: Start AutoAttach');

		Map<String, String> AutoAttachMap = new Map<String, String>();
		// Salesforce Field / Input Parameter
		AutoAttachMap.put('ContactID',c.Id);
        AutoAttachMap.put('FileName','Sample.TXT');
        AutoAttachMap.put('Attachment','Tm93IGlzIHRoZSB0aW1lIGZvciBpbnRlZ3JhdGlvbi4=');

        Pagereference pAutoAttach = Page.AutoAttach;
        for (String id : AutoAttachMap.keySet()) {
			String value = AutoAttachMap.get(id);
			System.debug('AutoX_Test AutoAttach: adding id:' + id + ' with value:' + value);
			pAutoAttach.getParameters().put(id,value);
        }

		Test.setCurrentPage(pAutoAttach);
		AutoAttachCon aacon = new AutoAttachCon();
		aacon.ProcessInsert();
		Attachment a = [SELECT Id, Name, ParentID FROM Attachment WHERE ParentID = :c.ID];
        System.assertEquals(a.ParentID,c.Id);
        System.assertEquals(a.Name,'Sample.TXT');
		System.debug('AutoX_Test: Finish AutoAttach');
    }

}