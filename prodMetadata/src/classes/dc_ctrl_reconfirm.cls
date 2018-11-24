public with sharing class dc_ctrl_reconfirm extends dc_Request_Page_Handler {

/******************************  Variables declaration *********************************************/	

	public boolean reconfirmed{get;set;}
	public string confirm {get;set;}
	public string confirmAge21 { get; set;}

	public dc_ctrl_reconfirm() {
		super('at re-confirm');
		
		System.debug(System.LoggingLevel.INFO, 'dc_ctrl_reconfirm() START');
								
		loadRequest(params.get('GiveRequestID'));
		
		if (request != null)
			loadInstance(request.Give_Instance__c);
		else if (params.get('instanceId') != null && params.get('instanceId').trim() != '')
			loadInstance(params.get('instanceId'));
		
		if (instance != null) loadGive(instance.Give__c);
		
		if (request != null)
			loadContact(request.Applicant__c);
		else if (params.get('ContactID') != null && params.get('ContactID').trim() != '')
			loadContact(params.get('ContactID'));
		
		if (request == null) return;
		
		//precord = false;
		initializeValues();
		this.init();
		    	refreshGuests();
		
		if (contact != null) {
			if (getCollectMemberDLNum()) // && isNullOrEmpty(request.Member_DL_Num__c))
				request.Member_DL_Num__c = contact.Drivers_License__c;
				
			if (getCollectMemberDOB()) // && isNullOrEmpty(request.Member_DOB__c)) 
				request.Member_DOB__c = contact.Birthdate;
				
			if (getCollectMemberShirtSize() ) //&& isNullOrEmpty(request.Member_Shirt_Size__c))
				request.Member_Shirt_Size__c = contact.Shirt_size__c;
		}
		
		//contact = getcontactinfo();
		System.debug(System.LoggingLevel.INFO, 'dc_ctrl_reconfirm() END');
	}
	
	
	private void initializeValues(){
		if (params.get('GiveRequestID')!=null && params.get('ContactID')!=null && params.get('PageAction')!=null){
			//errorMessage='';
			setReconfirmed();
		}
	}
	private void setReconfirmed()
	{
		if(request!=null) {
			if(request.Re_confirm_Status__c=='Re-confirmed') {
				reconfirmed=true;
			} else {
				reconfirmed=false;
			}
		}
	}

	public void submitrequest(){
		System.debug(System.LoggingLevel.INFO, 'submitrequest START');
		//PageReference redirecturl=new PageReference('https://cs1.salesforce.com/apex/dc_ReConfirm');
		saveError = 'false';
		Savepoint sp = null;
		
		try{
			System.debug(System.LoggingLevel.INFO, 'confirm: ' + confirm);
			if (confirm.toLowerCase() == 'yes') {

				saveFields();
								
				if (!validateFields()) { 
					saveError = 'true';
					System.debug(System.LoggingLevel.INFO, 'validateFields failed.');
				}
				
				if (!validateGuests()) {
					saveError = 'true';
					System.debug(System.LoggingLevel.INFO, 'validateGuests failed.');
				}

				if (saveError != 'false') return;

				request.Date_of_Re_confirm__c=Date.today();
				request.Re_confirm_Status__c='Re-confirmed';
				
				sp = Database.setSavepoint();
				
				upsert contact;
				upsert request;
				
				if (!commitGuests()) {
					Database.rollback(sp);
					saveError = 'true';
					return;
				}
			}
			else if (confirm.toLowerCase() == 'no')
			{
				request.Date_of_Re_confirm__c=Date.today();
				request.Re_confirm_Status__c='Re-confirmed';
				request.Stage__c = 'Cancelled';
				upsert request;
			}
        } 
        catch(Exception e)
        {
        	System.debug(System.LoggingLevel.INFO, 'Exception occured while saving.');
        	ApexPages.addMessages(e);
        	
        	if (sp != null) {
        		try {
        			Database.rollback(sp);
        		}
        		catch (Exception e2) {ApexPages.addMessages(e2);}
        	}
        	
        	saveError = 'true';        	
        }	
        
        System.debug(System.LoggingLevel.INFO, 'submitrequest END saveError: ' + saveError);
	}
	
	public PageReference redirectOnSave(){		
		//return new PageReference('http://iava.dev.cs1.force.com/rucksack');
		return Page.dc_ReconfirmConfirmation;
	}

	public Boolean getShouldShowReConfirmedMessage() {
		return (give != null && request != null && request.Stage__c != 'Cancelled' && request.Re_confirm_Status__c == 'Re-confirmed');
	}

	public Boolean getShouldShowCancelledMessage() {
		return (give == null || request == null || request.Stage__c == 'Cancelled');
	}
	
	public String getdc_reconfirmed_confirmation_message() {
		return System.Label.dc_reconfirmed_confirmation_message;
	}
	
	public String getdc_cancelled_confirmation_message() {
		return System.Label.dc_cancelled_confirmation_message;
	}
	
     /** Creating radio checkboxes for Age (to be 21+) **/
    public List<SelectOption> getAge()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('YES','YES'));
        options.add(new SelectOption('NO','NO'));
        return options;    
    }
      	
    public void age_y()
    {
        system.debug('age_y:::::::::::::::::before::::::' + age_y);
        age_y = true;
        system.debug('age_y:::::::::::::::::after::::::' + age_y);
        //submitrequest();
    }
    
    public void age_n()
    {
        system.debug('age_y:::::::::::::::::before::::::' + age_y);
        age_y = false;
        system.debug('age_y:::::::::::::::::after::::::' + age_y);
        //submitrequest();
    }
 	
 	public Boolean getHasPersonalDetails() {
 		return 	getCollectMemberDOB() || 
 				getCollectMemberDLNum() || 
 				getCollectMemberShirtSize();
 	}
 	
 	public Boolean getHasSpecialQuestions() {
 		return	getCollectSpecialResponse2() ||
 				getCollectSpecialResponse3() ||
 				getCollectSpecialResponse4() ||
 				getCollectSpecialResponse5();
 	}
 	
 	public Boolean getPromptForGuests() {	
		//if ( give.Maximum_Units_per_Member__c == null) return false;
		
		return 	selectedNumberOfGuests > 0 && (
				getCollectGuestName() ||
			 	getCollectGuestDLNum() ||
			   	getCollectGuestDOB() ||
			   	getCollectGuestShirtSize() );
		/*
		return (give.Collect_Guest_DL_Num__c == 'at request' || 
				give.Collect_Guest_DOB__c == 'at request' ||
				give.Collect_Guest_Shirt_Size__c == 'at request' ||
				give.Guest_Name_Required__c);
				*/
	}
 	
 	public Boolean getShouldShowReConfirmBody() {
 		return (give != null && request != null && !getShouldShowCancelled() && !getShouldShowAlreadyConfirmed());
 	}
 	
 	public Boolean getShouldShowReadonlyFields() {
 		return false;
 		return give != null && request != null && (getShouldShowCancelled() || getShouldShowAlreadyConfirmed());
 	}
 	
 	public Boolean getShouldShowHeader() {
 		return give != null;
 	}
 	
 	public Boolean getShouldShowConfirmationQuestion() {
 		System.debug(System.LoggingLevel.INFO, 'getShouldShowConfirmationQuestion(request=null: ' + (request == null) + '; give=null: ' + (give == null) + ')');
 		if (request == null || give == null) return false;
 		return request.Re_confirm_Status__c != 'Re-confirmed' && request.Stage__c != 'Cancelled' && request.Stage__c != 'Ineligible' && request.Stage__c != 'Denied';
 	}
 	
 	public Boolean getShouldShowAlreadyConfirmed() {
 		if (request == null || give == null) return false;
 		return request.Re_confirm_Status__c == 'Re-confirmed' && request.Stage__c != 'Cancelled' && request.Stage__c != 'Ineligible' && request.Stage__c != 'Denied';
 	}
 	
 	public Boolean getShouldShowCancelled() {
 		return request == null || give == null || request.Stage__c == 'Cancelled' || request.Stage__c == 'Ineligible' || request.Stage__c == 'Denied';
 	}
 	
 	/*
 	public Boolean getPromptForGuestAge21() {
 		return give != null && give.Must_be_21_for_guest__c;
 	}
 	*/
 	
 	public Boolean getShouldShowGuestsDivider() {
		if (getPromptForGuestAge21()) return true;
		if (getPromptForGuests()) return true;
		return false;
	}
 	
}