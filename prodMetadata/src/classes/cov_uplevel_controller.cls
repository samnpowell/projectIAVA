public with sharing class cov_uplevel_controller {

	public Boolean isConfirmed {get; set;}
	public Boolean isUnconfirmed {get; set;}
	public String paperworkStatus {get; set;}
	public String paperworkIssue {get; set;}
	public String paperworkComments {get; set;}
	private User u;
	private Contact c;
	public Id contactId {get; set;}
	public Attachment paperworkFile {
	  get {
	      if (paperworkFile == null) {
	      	paperworkFile = new Attachment();
	      }
	      return paperworkFile;
	    }
	  set;
	}

	public cov_uplevel_controller() {
	
        u = cov_user_utility.self.getU();
        c = cov_user_utility.self.getC(new List<String>{'Paperwork_Confirmation__c', 'Paperwork_Issue__c', 'Approval_Related_Comments__c'});
        contactId = c == null ? '' : c.Id;

		isConfirmed =   c != null && cov_user_utility.self.getIsMemberVeteran() && cov_user_utility.self.getIsConfirmed();
		isUnconfirmed = c != null && cov_user_utility.self.getIsMemberVeteran() && !cov_user_utility.self.getIsConfirmed();

		paperworkStatus = c.Paperwork_Confirmation__c;
		paperworkIssue = c.Paperwork_Issue__c;
		paperworkComments = c.Approval_Related_Comments__c;		

	}

	public PageReference uploadPaperwork() {

		// UPLOAD NEW IMAGE FILE
   		system.debug('paperworkFile: ' + paperworkFile);
    	if (paperworkFile.Body == null) {
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please select a file to upload.'));
			return null;
    	} else {
    		system.debug('User uploaded a file.');
            //Boolean uploadThumbnail = false;

            paperworkFile.ParentId = c.Id;
            //String originalFileName = paperworkFile.Name;
    		//paperworkFile.Name = 'image-full';
            //paperworkFile.isPrivate = false;
            system.debug('About to try to insert the file: ' + paperworkFile);
            system.debug('UserInfo.getUserId(): ' + UserInfo.getUserId());
            system.debug('User u: ' + u);
            Database.SaveResult sr = cov_nosharing_utilities.runDatabaseInsert(paperworkFile, false);
    		//try {
	    	//	insert paperworkFile;
      		//  system.debug('file attachment inserted.');
    		//} catch (Exception e) {
    		if (!sr.isSuccess()) {
                system.debug('error while inserting the file:');
				cov_log_error.logDevMsg('Error uploading paperwork file for user ' + UserInfo.getUserId());
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error uploading the file.'));
				paperworkFile = null;
				return null;
    		}

    		if (c.Paperwork_Confirmation__c != 'Paperwork Accepted') {
	    		c.Paperwork_Confirmation__c = 'Paperwork Received';
	            try {
	            	update c;
	            	system.debug('Contact updated to Paperwork Received');
	            	paperworkStatus = 'Paperwork Received';
	            	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm, 'File uploaded. You will hear back from us when we have reviewed your papework.'));
	            } catch (Exception e) {
					cov_log_error.logError(e, 'Error updating contact to Paperwork Received for user ' + UserInfo.getUserId()); 
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error. Your file was uploaded but was not added to the queue. Please ask IAVA staff to review it.'));
					paperworkFile = null;
					return null;
	        	}
    		}
		}
		paperworkFile = null;
		return null;

	}


}