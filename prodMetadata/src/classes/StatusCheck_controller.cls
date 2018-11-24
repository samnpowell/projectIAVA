public with sharing class StatusCheck_controller {
	// https://my.iava.org/StatusCheck?u=12345&v=y&o=n

	// Here is the requested business logic:
	//
	// v=y checks Veteran_Member__c, and un-checks Not_a_Veteran__c if checked
	// v=n checks Not_a_Veteran__c but doesn't uncheck anything - workflow will notify a staff member to review
	// o=y checks Veteran_of_Other_Era__c, and un-checks Not_a_Veteran__c if checked
	// o=n is ignored and has no effect
	// f=y checks Veteran_Family_Member__c and does not un-check anything
	// f=n is ignored and has no effect
	//
	// After contact updated, send to join step 2 and pre-fill contact ID (hidden)
	// If no valid contact ID provided, send to join step 1 with nothing pre-filled
	// If neither v, o, or f has a valid option, dont update anything and send to join step 1
	// If firstname, lastname, or email are blank on the contact record, send to join step 1




    private Map<String, String> theParams { get; set; }
    private Id cId {get; set;}
    private Contact c {get; set;}
    private String v_value {get; set;}
    private String o_value {get; set;}
    private String f_value {get; set;}


	public StatusCheck_controller() {}

	public PageReference init() {

		PageReference pageref;
		String joinPageMessage = '';
		Boolean updateTheContact = false;
		Boolean contactUpdated = false;
		Boolean enoughParamsPresent = false;
		Boolean sendToStep2 = false;

		Map<String, String> paramsForJoinPage = new Map<String, String>();

		theParams = ApexPages.currentPage().getParameters();

        String c_string = theParams.get('c'); // '12345'
        try {
        	cId = (Id)c_string;
        } catch (Exception e) {
        	enoughParamsPresent = false;
        }

        if (cId != null) {

	        String q = 'select Id, FirstName, LastName, Email, MailingPostalCode, Portal_User__c, Veteran_Member__c, Not_a_Veteran__c, Veteran_of_Other_Era__c, Veteran_Family_Member__c from Contact where Id=\'' + cId + '\'';
	        c = (Contact)cov_nosharing_utilities.runSingleQuery(q);

	        if (c == null) {
	        	system.debug('no contact found with that Id');
	        } else {    
		    
		       	v_value = theParams.get('v');
		        o_value = theParams.get('o');
		        f_value = theParams.get('f');

		        if ((v_value == null && o_value == null && f_value == null)
		        	|| (v_value != 'y' && v_value != 'n' && o_value != 'y' && f_value != 'y')) {
		        	enoughParamsPresent = false;
		        } else {
		        	enoughParamsPresent = true;
		        	sendToStep2 = true;

			        if (v_value == 'y') {
			        	paramsForJoinPage.put('vt', 'y');
			        	if (c.Veteran_Member__c == false || c.Not_a_Veteran__c == true) {
				        	c.Veteran_Member__c = true;
				        	c.Not_a_Veteran__c = false;
				        	updateTheContact = true;
				        }
			        } else if (v_value == 'n') {
			        	paramsForJoinPage.put('vt', 'n');
			        	if (c.Veteran_Member__c == true || c.Not_a_Veteran__c == false) {
				        	c.Veteran_Member__c = false;
				        	c.Not_a_Veteran__c = true;
				        	updateTheContact = true;
				        }
			        }

			        if (o_value == 'y') {
			        	paramsForJoinPage.put('oe', 'y');
			        	if (!c.Veteran_of_Other_Era__c || c.Not_a_Veteran__c) {
				        	c.Veteran_of_Other_Era__c = true;
				        	c.Not_a_Veteran__c = false;
				        	updateTheContact = true;
				        }
			        }

			        if (f_value == 'y') {
			        	paramsForJoinPage.put('fm', 'y');
			        	if (!c.Veteran_Family_Member__c) {
				        	c.Veteran_Family_Member__c = true;
				        	updateTheContact = true;
				        }
			        }

			        if (updateTheContact) {
			        	Database.SaveResult sr = cov_nosharing_utilities.runDatabaseUpdate(c, true);
			        	if (sr.isSuccess()) {
			        		contactUpdated = true;
		        		} else {
			        		cov_log_error.logDevMsg('problem updating the contact on the StatusCheck page');
		        		}
			        }

		        }

		    }

		}

		if (c != null && (contactUpdated || !updateTheContact)) {
			if (String.isEmpty(c.FirstName) || String.isEmpty(c.FirstName) || String.isEmpty(c.Email) 
				|| c.LastName == '(Unknown)' || c.LastName == c.Email) {
				sendToStep2 = false;
				joinPageMessage = 'Thanks, got it! Looks like we are missing some other basic info, too. Mind filling out this form so we can keep you in the loop?';
			} else {
				joinPageMessage = 'Thanks, got it! Mind filling out the rest of this form so we can keep you in the loop?';
			}
		} else {
			joinPageMessage = 'Whoops, something went wrong recording your response. Mind filling out this form instead so we can keep you in the loop?';
		}


	    // redirect to join form regardless
    	pageref = new PageReference('http://iava.org');
    	//pageref = new PageReference('http://join-prepop.iavan.dev.echoditto.com');
    	pageref.setAnchor('join');
	    if (c != null) {
	    	pageref.getParameters().put('cId', cId);
	    }
	    // only redirect to step 2 if everything was kosher
	    if (sendToStep2) {
	    	pageref.getParameters().put('st', '2');
	    	pageref.getParameters().put('url-msg-join2', joinPageMessage);
	    } else {
	    	pageref.getParameters().put('url-msg-join', joinPageMessage);
	    }
    	for (String s : paramsForJoinPage.keySet()) {
    		pageref.getParameters().put(s, paramsForJoinPage.get(s));
    	}

    	system.debug('StatusCheck page about to return pageref: ' + pageref);
    	return pageref;

	}


}