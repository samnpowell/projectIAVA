/*
Copyright (c) 2009 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Nick Koopman, nkoopman@etherios.com
*/

public class AutoMemberCon {

	public String JSON {get; set;}
	private String error {get; set;}

    private List<String> ParameterList = new List<String>();
    private Map<String, String> IncomingMap = new Map<String, String>();
    public Contact newContact {
		get {
			if (newContact == null)
				newContact = new Contact();
			return newContact;
		}
		set;
	}
    
    private void populateParameterList() {   // Salesforce Field / Input Parameter
        ParameterList.add('FirstName');
        ParameterList.add('LastName');
        ParameterList.add('Email');
        ParameterList.add('Phone');
        ParameterList.add('MailingStreet');
        ParameterList.add('MailingCity');
        ParameterList.add('MailingState');
        ParameterList.add('MailingPostalCode');
        ParameterList.add('MailingCountry');
        ParameterList.add('Veteran_of_OEF__c');
        ParameterList.add('Veteran_of_OIF__c');
        ParameterList.add('Rank__c');
        ParameterList.add('Branch_of_Service__c');
        ParameterList.add('Current_Status__c');
        ParameterList.add('Service_Type__c');
        ParameterList.add('Most_Recent_Unit__c');
    }

    private void processParameter (String parm) {
        String input = ApexPages.currentPage().getParameters().get(parm);
        System.debug('AutoMemberCon: |' + parm + '|: ' + input);
        IncomingMap.put(parm,input);
    }

    private void processContact() {
        newContact.FirstName = IncomingMap.get('FirstName');
        newContact.LastName = IncomingMap.get('LastName');
        newContact.Email = IncomingMap.get('Email');
        newContact.Phone = IncomingMap.get('Phone');
        newContact.MailingStreet = IncomingMap.get('MailingStreet');
        newContact.MailingCity = IncomingMap.get('MailingCity');
        newContact.MailingState = IncomingMap.get('MailingState');
        newContact.MailingPostalCode = IncomingMap.get('MailingPostalCode');
        newContact.MailingCountry = IncomingMap.get('MailingCountry');
        newContact.Veteran_of_OEF__c = (IncomingMap.get('Veteran_of_OEF__c') == 'true') ? true : false;
        newContact.Veteran_of_OIF__c = (IncomingMap.get('Veteran_of_OIF__c') == 'true') ? true : false;
        newContact.Rank__c = IncomingMap.get('Rank__c');
        newContact.Branch_of_Service__c = IncomingMap.get('Branch_of_Service__c');
        newContact.Current_Status__c = IncomingMap.get('Current_Status__c');
        newContact.Service_Type__c = IncomingMap.get('Service_Type__c');
        newContact.Most_Recent_Unit__c = IncomingMap.get('Most_Recent_Unit__c');
        // Requested Hardcoded Fields
        newContact.Submitted_Application__c = true;
        newContact.Veteran_Member__c = true;
    }

	private void buildJSON() {
		JSON = '';
		JSON += '{ "AutoMember": {\n\r';
		JSON += '       "status": "' + error + '",\n\r';
		JSON += '       "member": {\n\r';
		JSON += '            "field": [\n\r';
		JSON += '                    {"fieldname": "Id", "value": "' + newcontact.Id + '"},\n\r';
		JSON += '                    {"fieldname": "FirstName", "value": "' + newcontact.FirstName + '"},\n\r';
        JSON += '                    {"fieldname": "LastName", "value": "' + newcontact.LastName + '"},\n\r';
        JSON += '                    {"fieldname": "Email", "value": "' + newcontact.Email + '"},\n\r';
        JSON += '                    {"fieldname": "Phone", "value": "' + newcontact.Phone + '"},\n\r';
        JSON += '                    {"fieldname": "MailingStreet", "value": "' + newcontact.MailingStreet + '"},\n\r';
        JSON += '                    {"fieldname": "MailingCity", "value": "' + newcontact.MailingCity + '"},\n\r';
        JSON += '                    {"fieldname": "MailingState", "value": "' + newcontact.MailingState + '"},\n\r';
        JSON += '                    {"fieldname": "MailingPostalCode", "value": "' + newcontact.MailingPostalCode + '"},\n\r';
        JSON += '                    {"fieldname": "MailingCountry", "value": "' + newcontact.MailingCountry + '"},\n\r';
        JSON += '                    {"fieldname": "Veteran_of_OEF__c", "value": "' + newcontact.Veteran_of_OEF__c + '"},\n\r';
        JSON += '                    {"fieldname": "Veteran_of_OIF__c", "value": "' + newcontact.Veteran_of_OIF__c + '"},\n\r';
        JSON += '                    {"fieldname": "Rank__c", "value": "' + newcontact.Rank__c + '"},\n\r';
        JSON += '                    {"fieldname": "Branch_of_Service__c", "value": "' + newcontact.Branch_of_Service__c + '"},\n\r';
        JSON += '                    {"fieldname": "Current_Status__c", "value": "' + newcontact.Current_Status__c + '"},\n\r';
        JSON += '                    {"fieldname": "Service_Type__c", "value": "' + newcontact.Service_Type__c + '"},\n\r';
        JSON += '                    {"fieldname": "Most_Recent_Unit__c", "value": "' + newcontact.Most_Recent_Unit__c + '"}\n\r';
		JSON += '             ]\n\r';
		JSON += '}      }      }';
	}

	public PageReference ProcessInsert() {	// Called as the page action when the page loads
		try {
			insert newContact;
			error = 'Success';
			buildJSON();
			return null;
		}
	    catch (Exception e){
	    	// ApexPages.addMessages(e);
	    	error = e.getMessage();
	    	buildJSON();
			return null;
	    }
	}

    public AutoMemberCon() {
        System.debug('AutoMemberCon: Start');
        System.debug('AutoMemberCon: ' + ApexPages.currentPage().getParameters());
        populateParameterList();	// This sets up the list of fields we expect to receive
        for (String s : ParameterList)	// This build a map of fields to what we actually receive
            processParameter(s);
        processContact();
        System.debug('AutoMemberCon: Finish');
    }
    
}