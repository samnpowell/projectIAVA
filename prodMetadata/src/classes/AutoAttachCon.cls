/*
Copyright (c) 2009 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Nick Koopman, nkoopman@etherios.com
*/

public class AutoAttachCon {

	public String JSON {get; set;}
	private String error {get; set;}

    private List<String> ParameterList = new List<String>();
    private Map<String, String> IncomingMap = new Map<String, String>();
    public Attachment newAttachment {
		get {
			if (newAttachment == null)
				newAttachment = new Attachment();
			return newAttachment;
		}
		set;
	}
    public Contact oldContact {
		get {
			if (oldContact == null)
				oldContact = new Contact();
			return oldContact;
		}
		set;
	}
    private String existingContactId = '';
    
    private void populateParameterList() {   // Salesforce Field / Input Parameter
    	ParameterList.add('ContactID');
        ParameterList.add('FileName');
        ParameterList.add('Attachment');
    }

    private void processParameter (String parm) {
        String input = ApexPages.currentPage().getParameters().get(parm);
        System.debug('AutoAttachCon: |' + parm + '|: ' + input);
        IncomingMap.put(parm,input);
    }

    private void processAttachment() {
    	
    	existingContactId = IncomingMap.get('ContactID');
        newAttachment.Name = IncomingMap.get('FileName');
        newAttachment.Body = EncodingUtil.base64Decode(IncomingMap.get('Attachment'));
    }

	private void buildJSON() {
		JSON = '';
		JSON += '{ "AutoAttach": {\n\r';
		JSON += '       "status": "' + error + '",\n\r';
		JSON += '       "attachment": {\n\r';
		JSON += '            "field": [\n\r';
		JSON += '                    {"fieldname": "Id", "value": "' + newAttachment.Id + '"},\n\r';
        JSON += '                    {"fieldname": "FileName", "value": "' + newAttachment.Name + '"}\n\r';
		JSON += '             ]\n\r';
		JSON += '}      }      }';
	}

	public PageReference ProcessInsert() {	// Called as the page action when the page loads
		try {
	        populateParameterList();	// This sets up the list of fields we expect to receive
    	    for (String s : ParameterList)	// This build a map of fields to what we actually receive
        	    processParameter(s);
        	processAttachment();
			if (existingContactId.length() == 18)
				oldContact = [SELECT Id FROM Contact WHERE Id = :existingContactId];
			newAttachment.ParentId = oldContact.Id;
			insert newAttachment;
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

    public AutoAttachCon() {
        System.debug('AutoAttachCon: Start');
        System.debug('AutoAttachCon: ' + ApexPages.currentPage().getHeaders());
        System.debug('AutoAttachCon: ' + ApexPages.currentPage().getParameters());
        System.debug('AutoAttachCon: Finish');
    }
    
}