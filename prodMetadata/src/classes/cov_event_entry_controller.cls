public with sharing class cov_event_entry_controller {

	private ApexPages.StandardController sController;
	private IAVAEvent__c theEvent {get; set;}
	public String eventId {get; set;}
    public Boolean isEventOwner {get; set;}
    public List<SelectOption> stateOptions;
    private String previousStreet {get; set;}
    private String previousCity {get; set;}
    private String previousState {get; set;}
    private String previousZip {get; set;}
    private Decimal previousCost {get; set;}
    private String previousCostDescription {get; set;}

    public Id currentUserContactId {get; set;}

    public Boolean hostTOSAccepted {get; set;}

    public Boolean allowNonAuthEventCreation {get; set;}
    public String nonAuthFirstName {get; set;}
    public String nonAuthLastName {get; set;}
    public String nonAuthEmail {get; set;}
    public String nonAuthPhone {get; set;}
    public String nonAuthZip {get; set;}
    public Boolean nonAuthOEF {get; set;}
    public Boolean nonAuthOIF {get; set;}
    public Boolean nonAuthOND {get; set;}
    public Boolean nonAuthPost911 {get; set;}
    public Boolean nonAuthOtherEra {get; set;}
    public Boolean nonAuthFamily {get; set;}
    public Boolean nonAuthNotVeteran {get; set;}
    public Boolean nonAuthAgreeToTerms {get; set;}

    public String uploadImageContentType {get; set;}
    public Attachment existingImage {get; set;}
    public String existingImageMsg {get; set;}
    public Id existingImageIdCopy { get; set; } // avoid querying twice
    public Id existingImageId {
    	get {
    		System.debug('getting existingImageId. existingImageId=' + existingImageId + ' and eventId=' + eventId);
	    	if (eventId != null) {
		      	List<Attachment> atts = [select Id, Name, CreatedDate from Attachment where ParentId = :eventId and Name like '%image-full%' order by CreatedDate DESC];
			    if (atts.size() > 0) {
					existingImageId = atts[0].Id;
                    existingImageIdCopy = existingImageId;
					existingImage = atts[0];
			    }
	    	}
	    	return existingImageId;
	    }
    	set;
    	}
   // public Attachment imageFile {
	  //get {
	  //    if (imageFile == null) {
	  //    	imageFile = new Attachment();
	  //    }
	  //    return imageFile;
	  //  }
	  //set;
	  //}
    public String newImageFull {get; set;}
    public String newImageThumb {get; set;}
    public String newImageName {get; set;}
    public String newImageType {get; set;}

    public Boolean costCheckbox {get; set;}

    public Boolean modalParamPresent {
        get {
            return apexpages.currentpage().getparameters().get('modal') == 'true';   
        }
    }
    public String templateName {
        //unused because dynamic template binding seems
        //to break the standard controller for some unknown reason
        get{
            return 'cov_template' + (modalParamPresent ? '_noheader' : '');
        }
    }


    public cov_event_entry_controller(ApexPages.StandardController stdController) {
        sController = stdController;
        currentUserContactId = cov_user_utility.self.getCId();

		eventId = ApexPages.currentPage().getParameters().get('id');
		if(eventId != null && eventId!='') {
            if (UserInfo.getUserType() != 'Guest') {
                this.theEvent = (IAVAEvent__c)stdController.getRecord();
                isEventOwner = theEvent.OwnerId == UserInfo.getUserId();
            } else {
                isEventOwner = false;
                this.theEvent = null; //doesnt seem to actually set it to null
            }
	        //this.theEvent = UserInfo.getUserType() == 'Guest' ? null : (IAVAEvent__c)stdController.getRecord();
	    } else { 
		   this.theEvent = new IAVAEvent__c();  
		}

        previousStreet = this.theEvent.Location_Street_Address__c;
        previousCity = this.theEvent.Location_City__c;
        previousState = this.theEvent.Location_State__c;
        previousZip = this.theEvent.Location_Zip_Code__c;
        previousCost = this.theEvent.Associated_Cost__c;
        previousCostDescription = this.theEvent.Cost_Description__c;
        costCheckbox = (this.theEvent.Associated_Cost__c == null || this.theEvent.Associated_Cost__c == 0) && this.theEvent.Cost_Description__c == null ? false : true;

		String message = ApexPages.CurrentPage().getParameters().get('msg');
		system.debug('message from msg URL parameter: ' + message);
		if(message != null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info, message));
		}

        IAVA_switches__c sw_disable_nonauth_eventcreation = IAVA_switches__c.getInstance('myIAVA_nonAuth_event_creation');
        allowNonAuthEventCreation = sw_disable_nonauth_eventcreation == null || !sw_disable_nonauth_eventcreation.Disable__c ? true : false;

        hostTOSAccepted = this.theEvent.Date_Accepted_Host_TOS__c != null;

    }


    public List<SelectOption> getStateOptions() {
    	system.debug('getting state options');
    	String theState = theEvent == null ? null : theEvent.Location_State__c;
		return cov_profile_controller.getStateOptions(theState);
    }

    public pageReference savePublish() {
   		IAVAEvent__c theRecord = (IAVAEvent__c)sController.getRecord();
        system.debug('in savePublish and theRecord: ' + theRecord);
		return saveMethod(theRecord, 'Published');   
    }

    public pageReference saveCancel() {
   		IAVAEvent__c theRecord = (IAVAEvent__c)sController.getRecord();
		return saveMethod(theRecord, 'Canceled');   	    	
    }


    public pageReference save() {
   		IAVAEvent__c theRecord = (IAVAEvent__c)sController.getRecord();
        system.debug('in save() and theRecord: ' + theRecord);
    	return saveMethod(theRecord, null);
	}


    public pageReference saveMethod(IAVAEvent__c theRecord, String newStatus) {
    	system.debug('theRecord: ' + theRecord);
    	Id theNetworkId = cov_user_utility.self.getNetworkId();
    	String previousStatus = theRecord.Status__c;

    	if (newStatus != null) {
    		theRecord.Status__c = newStatus;
    		system.debug('Just set theRecord.Status__c to: ' + newStatus);
    	} else if (theEvent.id == null) {
    		system.debug('New event saved, set status to Unpublished');
    		theRecord.Status__c = 'Unpublished';
    	}
    	if (theRecord.Event_Date__c == null && theRecord.Status__c == 'Published') {
    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please select a date.'));
    		return null;
    	}
        if (theRecord.Event_Date__c != null) {
            try {
                Date dt = Date.valueOf(theRecord.Event_Date__c);
            } catch (Exception e) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Invalid date.'));
                return null;
            }
        }
        if (!hostTOSAccepted) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please agree to the IAVA Leader Code of Conduct to create an event.'));
            return null;
        }

        //if (imageFile.Body != null && !uploadImageContentType.contains('image')) {
        //    system.debug('non-image contenttype: ' + uploadImageContentType);
        //    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'The image must be a JPG, GIF, or PNG.'));
        //    imageFile = new Attachment();
        //    return null;            
        //}


    	system.debug('theEvent.Id: ' + theEvent.Id);
    	if (theRecord.id == null) { // initial record creation
    		system.debug('This is a new Event record.');
    		//IAVAEvent__c theRecord = (IAVAEvent__c)sController.getRecord();
    		theRecord.Origin__c = 'COV';
    		theRecord.Organizer_Type__c = 'Distributed';
            theRecord.Tier__c = '3';
            if (currentUserContactId != null) {
                theRecord.Creator_Contact__c = currentUserContactId;
            }

			//theRecord.Chatter_Group_Mirror__c = createGroup(theRecord);  // TODO: this creates the group before the event is created
			System.debug('new event getting created: ' + theRecord);
    	}
        if (theRecord.Date_Accepted_Host_TOS__c == null & hostTOSAccepted) {
            theRecord.Date_Accepted_Host_TOS__c = System.now();
        }

        if (!costCheckbox && (previousCost != null || previousCostDescription != null)) {
            theRecord.Associated_Cost__c = null;
            theRecord.Cost_Description__c = null;
        }

    	// Create a chatter group if appropriate
    	if (theRecord.Chatter_Group_Mirror__c == null ) {
    		system.debug('There is no Group yet associated with this event. theRecord.Status__c = ' + theRecord.Status__c);
	    	if (theRecord.Status__c != 'Published') {
	    		system.debug('Event not published, hold off on creating the group.');
				theRecord.Dont_create_Chatter_Group__c = true;
			} else if (theRecord.Status__c == 'Published' && previousStatus != 'Published') {
				system.debug('Publishing so dont suppress group creation.');
				theRecord.Dont_create_Chatter_Group__c = false;
			}
		}
   		
		system.debug('About to save the event record theRecord: ' + theRecord);
    	PageReference pr = sController.save();
		system.debug('pageref pr from the save method: ' + pr);
    	if (pr == null) {
    		//if (ApexPages.getMessages().size() == 0) {
    			String errorMsg = 'Sorry, there was a problem saving the Event. Please let us know what happened so we can help.';
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, errorMsg));
			//}
			return null;
    	}
    	system.debug('pr from sController.save(): ' + pr);
    	system.debug('sController.getId(): ' + sController.getId());
    	//system.debug('theEvent.id: ' + theEvent.Id);
    	theRecord = (IAVAEvent__c)sController.getRecord();
    	system.debug('theRecord after save: ' + theRecord);
        system.debug('theRecord.Id after save: ' + theRecord.Id);
        //system.debug('theRecord.Chatter_Group_Mirror__c after save: ' + theRecord.Chatter_Group_Mirror__c);
        Id theRecordId = theRecord.Id != null ? theRecord.Id : sController.getId();

        // Not sure why test doesnt get new values during sController.getRecord()
        If(Test.isRunningTest() && theRecord.Id != null) {
            theRecord.Chatter_Group_Mirror__c = [select Chatter_Group_Mirror__c from IAVAEvent__c where Id = :theRecord.Id limit 1].Chatter_Group_Mirror__c;
        }

		CollaborationGroup theGroup;
		if (theRecord.Chatter_Group_Mirror__c != null) {
			theGroup = cov_groups_controller.findGroupByMirrorId(theRecord.Chatter_Group_Mirror__c);
			system.debug('theGroup: ' + theGroup);
		}



        // Upload image attachments

        Attachment imageFileFull;
        Attachment imageFileThumb;
        newImageName = String.isBlank(newImageName) ? 'uploaded-file' : newImageName;
        List<Attachment> attachmentsToInsert = new List<Attachment>();

        if (!String.isBlank(newImageFull)) {
            imageFileFull = createAttachmentFromDataString('image-full-' + newImageName, theRecord.Id, newImageFull, false);
            if (imageFileFull != null) {
                attachmentsToInsert.add(imageFileFull);
            }
        }

        if (!String.isBlank(newImageThumb)) {
            imageFileThumb = createAttachmentFromDataString('image-thumb-' + newImageName, theRecord.Id, newImageThumb, false);
            if (imageFileThumb != null) {
                attachmentsToInsert.add(imageFileThumb);
            }
        }

        if (attachmentsToInsert.size() > 0) {

            system.debug('About to try to insert the image attachments: ' + attachmentsToInsert);

            Database.SaveResult[] srs = cov_nosharing_utilities.runDatabaseInsert(attachmentsToInsert, false);

            for (Database.SaveResult sr : srs) {
                if (!sr.isSuccess()) {
                    cov_log_error.logDevMsg('Error(s) inserting attachments for an event: ' + attachmentsToInsert);
                    for (Database.Error er : sr.getErrors()) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, er.getMessage()));
                    }
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'There was an error uploading an image.'));
                    return null;
                } else {
                    system.debug('image attachments inserted.');
                }
            }

            if (imageFileThumb != null && imageFileThumb.Id != null) {
                theRecord.Thumbnail_image_URL__c = Site.getBaseUrl() + '/servlet/servlet.FileDownload?file=' + imageFileThumb.Id;
                Database.SaveResult sr = cov_nosharing_utilities.runDatabaseUpdate(theRecord, false);
                if (!sr.isSuccess()) {
                    cov_log_error.logDevMsg('error while updating thumbnail for an event: ' + sr.getErrors());
                } else {
                    system.debug('thumbnail field updated.');
                }
            }

            if (theGroup != null) {
                try {
                    system.debug('prep image to be added to the group');
                    ConnectApi.BinaryInput theFile = new ConnectApi.BinaryInput(imageFileFull.Body, newImageType, newImageName);
                    system.debug('about to add the image to the group');
                    ConnectApi.Photo photo = ConnectApi.ChatterGroups.setPhoto(theNetworkId, theGroup.Id, theFile);
                    system.debug('photo for group inserted: ' + photo);
                    system.debug('photo.smallPhotoUrl: ' + photo.smallPhotoUrl);
                    //addEventThumbnailFromGroupThumbnail(photo.smallPhotoUrl, theRecord.Id);
                    //theRecord.Thumbnail_image_URL__c = photo.smallPhotoUrl;
                    //update theRecord;
                } catch (Exception e) {
                    cov_log_error.logError(e);
                    system.debug('error inserting photo for group');
                }
            }

            clearNewImageVars(); // clear new images to avoid max view state error
        }




        // moved to separate remoting process
		//// UPLOAD NEW IMAGE FILE
  // 		system.debug('imageFile: ' + imageFile);
  //  	if (imageFile.Body != null) {
  //  		system.debug('User uploaded an image.');
  //          Boolean uploadThumbnail = false;

  //          imageFile.ParentId = theRecordId;
  //          String originalFileName = imageFile.Name;
  //  		imageFile.Name = 'image-full';
  //          imageFile.isPrivate = false;
  //          system.debug('About to try to insert the image: ' + imageFile);
  //  		try {
	 //   		insert imageFile;
  //              system.debug('image attachment inserted.');
  //  		} catch (Exception e) {
  //              system.debug('error while inserting the image:' + e);
		//		cov_log_error.logError(e); return null;
		//		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error uploading the image.'));
  //  		}

  //          if (theGroup != null) {
  //              try {
  //                  system.debug('prep image to be added to the group');
  //                  ConnectApi.BinaryInput theFile = new ConnectApi.BinaryInput(imageFile.Body, uploadImageContentType, originalFileName);
  //                  system.debug('about to add the image to the group');
  //                  ConnectApi.Photo photo = ConnectApi.ChatterGroups.setPhoto(theNetworkId, theGroup.Id, theFile);
  //                  system.debug('photo for group inserted: ' + photo);
  //                  system.debug('photo.smallPhotoUrl: ' + photo.smallPhotoUrl);
  //                  //addEventThumbnailFromGroupThumbnail(photo.smallPhotoUrl, theRecord.Id);
  //                  theRecord.Thumbnail_image_URL__c = photo.smallPhotoUrl;
  //                  update theRecord;
  //              } catch (Exception e) {
  //                  cov_log_error.logError(e);
  //                  system.debug('error inserting photo for group');
  //              }
  //          }
  //  	}

    	// DELETE DEFAULT GROUP CHATTER FEEDITEM AND REPLACE WITH EVENT CREATED FEEDITEM
    	if (previousStatus != 'Published' && theRecord.Status__c == 'Published') {
    		system.debug('Event was published.');
    		User theU = cov_user_utility.self.getU();

    		if (theGroup != null) {
    			system.debug('There is an associated group.');
	    		Id attendeeRecId = cov_events_controller.staticEventReply(theRecord, 'Yes', theU, null);
	    		system.debug('Signed the event owner up as an attendee. attendeeRecId: ' + attendeeRecId);

	    		system.debug('Now try to delete the feed announcement about the group and the changed info announcment about the group.');

	    		List<String> criteriaStrings = new List<String>();
	    		String q1 = 'Type = \'CollaborationGroupCreated\' and ParentId = \'' + theU.Id + '\' and CreatedDate > ' + Datetime.now().addMinutes(-1).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
	    		criteriaStrings.add(q1);
	    		//Boolean deleteSuccess = cov_feed_utility.deleteFeedItem(q1);
	    		//system.debug('deleteSuccess 1: ' + deleteSuccess);
	    		
	    		// The following attempt doesnt work -- perhaps the feeditem hasnt been created by the time this runs
	    		String q2 = 'Type = \'TrackedChange\' and ParentId = \'' + theGroup.Id + '\' and CreatedDate > ' + Datetime.now().addMinutes(-1).format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
	    		criteriaStrings.add(q2);
	    		//deleteSuccess = cov_feed_utility.deleteFeedItem(q2);
	    		//system.debug('deleteSuccess 2: ' + deleteSuccess);

	    		Boolean deleteSuccess = cov_feed_utility.deleteFeedItems(criteriaStrings);
	    		system.debug('deleteSuccess 2: ' + deleteSuccess);

	    	}

	    	system.debug('And now try to insert a new feed announcement about the Event');
            String pathPrefix = String.isEmpty(Site.getPathPrefix()) ? '' : Site.getPathPrefix();
            system.debug('pathPrefix: ' + pathPrefix);
    		FeedItem f = new FeedItem(ParentId = theU.Id
    									//, RelatedRecordId = theRecordId
    									//, Type = 'TextPost'
    									, Type = 'LinkPost'
    									, LinkURL = pathPrefix + '/cov_event?id=' + theRecordId
    									, NetworkScope = theNetworkId
    									, Body = 'Created an event.'
    										//+ '<a href="cov_event?id=' + theRecordId + '">'
    										//+ theRecord.Name 
    										//+ '</a>'
    									, Title = theRecord.Name
    			);
    		try {
				system.debug('about to insert feeditem: ' + f);
    			insert f;
    			system.debug('inserted.');
    		} catch (Exception e) { cov_log_error.logError(e); }

    	}
    	system.debug('Return to event detail page, or get geolocation data first.');

        PageReference pageRef;
        if (theRecord.Location_Street_Address__c != previousStreet
            || theRecord.Location_City__c != previousCity
            || theRecord.Location_State__c != previousState
            || theRecord.Location_Zip_Code__c != previousZip
            ) {
            system.debug('Location field(s) have changed, send to geolocate page');
            pageRef = Page.cov_event_geolocate;
            String addressParam = String.isNotBlank(theRecord.Location_Street_Address__c) ? theRecord.Location_Street_Address__c : '';
            addressParam += String.isNotBlank(theRecord.Location_City__c) ? ' ' + theRecord.Location_City__c : '';
            addressParam += String.isNotBlank(theRecord.Location_State__c) ? ' ' + theRecord.Location_State__c : '';
            addressParam += String.isNotBlank(theRecord.Location_Zip_Code__c) ? ' ' + theRecord.Location_Zip_Code__c : '';
            addressParam = addressParam.replaceAll(' ', '+');
            pageRef.getParameters().put('address', addressParam);
        } else {
        	pageRef = Page.cov_event;
        }

    	pageRef.getParameters().put('id', theRecordId);
        String headerParam = ApexPages.CurrentPage().getParameters().get('header');
        if (headerParam != null && headerParam != '') {
            pageRef.getParameters().put('header', headerParam);
        }
		if (newStatus == 'Published') {
			system.debug('Event was published so add that to the pageref msg param.');
			pageRef.getParameters().put('msg', 'Published.');
		} 	
    	return pageRef;
    }


    public pageReference nonAuthSave() {
        IAVAEvent__c theRecord = (IAVAEvent__c)sController.getRecord();

        Boolean hasPermSet = false;
        Boolean alreadyHadUser = false;
        Boolean addedToPermSet = false;

        Contact hostCon;
        User relatedU;


        // validate form
        if (
          String.isEmpty(nonAuthFirstName) || String.isEmpty(nonAuthLastName) || String.isEmpty(nonAuthEmail)
            ) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, name and email are required.'));
          return null;
        } else if (String.isEmpty(nonAuthZip)) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Zip or Postal Code is required.'));
          return null;
        } else if (!cov_utilities.validateEmail(nonAuthEmail)) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'That email appears to be invalid.'));
              return null;
        } else if (!nonAuthAgreeToTerms) {
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You must agree to the myIAVA terms to continue.'));
              return null;            
        } else {

            // ok it passes validation, let's continue

            String hostConQuery = 'select Id, Email, FirstName, LastName, Veteran_Member__c'
                                  + ', MobilePhone, npe01__PreferredPhone__c'
                                  + ', Veteran_of_OEF__c, Veteran_of_OIF__c, Veteran_of_OND__c, Veteran_of_Other_Era__c, Veteran_Family_Member__c, Not_a_Veteran__c'
                                  + ', Portal_User__c, myIAVA_Pre_User_TOS_Accept_Date__c'
                                  + ' from Contact where Email = \'' + nonAuthEmail + '\' order by Portal_User__c NULLS LAST limit 1';

            hostCon = (Contact)cov_nosharing_utilities.runSingleQuery(hostConQuery);

            // set null booleans to false
            nonAuthPost911 = nonAuthPost911 == null ? false : nonAuthPost911;
            nonAuthOEF = nonAuthOEF == null ? false : nonAuthOEF;
            nonAuthOIF = nonAuthOIF == null ? false : nonAuthOIF;
            nonAuthOND = nonAuthOND == null ? false : nonAuthOND;
            nonAuthOtherEra = nonAuthOtherEra == null ? false : nonAuthOtherEra;
            nonAuthFamily = nonAuthFamily == null ? false : nonAuthFamily;
            nonAuthNotVeteran = nonAuthNotVeteran == null ? false : nonAuthNotVeteran;
            nonAuthAgreeToTerms = nonAuthAgreeToTerms == null ? false : nonAuthAgreeToTerms;
            Boolean post911 = nonAuthPost911 || nonAuthOEF || nonAuthOIF || nonAuthOND;

            if (hostCon == null) {
              // if no contact was found with that email, create one
              // and check the Create Portal User checkbox
              hostCon = new Contact(
                FirstName=nonAuthFirstName
                , LastName=nonAuthLastName
                , Email=nonAuthEmail
                , MobilePhone=nonAuthPhone
                , npe01__PreferredPhone__c='Mobile'
                , MailingPostalCode = nonAuthZip
                , Veteran_Member__c = post911
                , Veteran_of_OEF__c = nonAuthOEF
                , Veteran_of_OIF__c = nonAuthOIF
                , Veteran_of_OND__c = nonAuthOND
                , Veteran_of_Other_Era__c = nonAuthOtherEra
                , Veteran_Family_Member__c = nonAuthFamily            
                , Not_a_Veteran__c = nonAuthNotVeteran
                , Source__c = 'Event'
                , Source_Details__c = '[Event Host] - ' + theRecord.Name
                , Create_Portal_User__c = true
                , myIAVA_Pre_User_TOS_Accept_Date__c = System.Today()
              );
              try {
                insert hostCon;      
              } catch (DMLException e) { 
                cov_log_error.logError(e, 'error inserting new contact for event host: ' + hostCon); 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry there was an error creating your account.'));
                return null;
              }
            } else {

              // if a contact already existed
              // see if existing contact fields need to be updated based on new info
              Boolean updateContact = false;

              if (hostCon.Portal_User__c == null) {
                hostCon.Create_Portal_User__c = true;
                updateContact = true;
              } else {
                alreadyHadUser = true;
              }

              if (hostCon.myIAVA_Pre_User_TOS_Accept_Date__c == null && nonAuthAgreeToTerms) {
                hostCon.myIAVA_Pre_User_TOS_Accept_Date__c = System.Today();
                updateContact = true;
              }



              if (!hostCon.Veteran_Member__c && post911) {
                hostCon.Veteran_Member__c = true;
                updateContact = true;
              }
              if (!hostCon.Veteran_of_OEF__c && nonAuthOEF) {
                hostCon.Veteran_of_OEF__c = true;
                updateContact = true;
              }
              if (!hostCon.Veteran_of_OIF__c && nonAuthOIF) {
                hostCon.Veteran_of_OIF__c = true;
                updateContact = true;
              }
              if (!hostCon.Veteran_of_OND__c && nonAuthOND) {
                hostCon.Veteran_of_OND__c = true;
                updateContact = true;
              }
              if (!hostCon.Veteran_of_Other_Era__c && nonAuthOtherEra) {
                hostCon.Veteran_of_Other_Era__c = true;
                updateContact = true;
              }
              if (!hostCon.Veteran_Family_Member__c && nonAuthFamily) {
                hostCon.Veteran_Family_Member__c = true;
                updateContact = true;
              }
              if (!hostCon.Not_a_Veteran__c && nonAuthNotVeteran) {
                hostCon.Not_a_Veteran__c = true;
                updateContact = true;
              }
              if (String.isEmpty(hostCon.FirstName) || hostCon.FirstName == hostCon.Email) {
                hostCon.FirstName = nonAuthFirstName;
                updateContact = true;
              }
              if (String.isEmpty(hostCon.LastName) || hostCon.LastName == '(Unknown)' || hostCon.LastName == hostCon.Email) {
                hostCon.LastName = nonAuthLastName;
                updateContact = true;
              }
              if (!String.isEmpty(nonAuthPhone)) {
                hostCon.MobilePhone = nonAuthPhone;
                hostCon.npe01__PreferredPhone__c = 'Mobile';
                updateContact = true;
              }
              if (!String.isEmpty(nonAuthZip)) {
                hostCon.MailingPostalCode = nonAuthZip;
                updateContact = true;
              }

              if (updateContact) {
                    system.debug('about to try to update contact: ' + hostCon);
                    Database.SaveResult sr = cov_nosharing_utilities.runDatabaseUpdate(hostCon, false);
                    if (!sr.isSuccess()) {
                        cov_log_error.logDevMsg('error(s) while updating contact for event creator: ' + sr.getErrors());
                    } else {
                        system.debug('contact updated: ' + hostCon);
                    }
              }
            }

            // get the user for the hostCon
            if (hostCon.Portal_User__c == null) {
                // find newly provisioned user
                // have to query user because Portal_User__c might not be populated yet (happens via @future method)
                relatedU = (User)cov_nosharing_utilities.runSingleQuery('select Id, ContactId, Profile.UserLicenseId from User where ContactId = \'' + hostCon.Id + '\' limit 1');
                if (relatedU == null) {
                    cov_log_error.logDevMsg('A user should have been created for this event creator but cant find it: ' + hostCon);
                }
            } else {
                relatedU = cov_user_contact_utility.getUserFromContact(hostCon, new List<String>{'ContactId, Profile.UserLicenseId'});
            }

            if (UserInfo.getUserType() != 'Guest') {
                // guest user gets insufficient privileges if doesnt own contact
                theRecord.Creator_Contact__c = hostCon.Id;
            }
            if (relatedU != null) {
                // set OwnerId so the user can edit the event once logged in
                theRecord.OwnerId = relatedU.Id;
                system.debug('just set the ownerId to theRecord.OwnerId: ' + theRecord.OwnerId);
                hasPermSet = cov_gateway_controller.alreadyHasPermissionSet(relatedU, 'COV Access');
                if (!hasPermSet) {
                    // have to use @future method to avoid mixed DML error
                    cov_gateway_controller.addCOVPermissionSetFutureMethod(relatedU.Id);
                }
            } 

        }

        // now run the save method but send user to login page instead of event page
        PageReference savePageRef = saveMethod(theRecord, null);

        IAVAEvent__c savedEvent = (IAVAEvent__c)sController.getRecord();
        Id newEventId = savedEvent == null ? null : savedEvent.Id;
        //Id newEventId = sController.getId();
        if (savePageRef == null || newEventId == null) {
            cov_log_error.logDevMsg('Error saving event for nonAuth user w/ email: ' + nonAuthEmail + ' . newEventId: ' + newEventId + ' and savePageRef: ' + savePageRef);
            return null;
        } else {

            if (UserInfo.getUserType() == 'Guest') {
                // guest user gets insufficient privileges when saving event if doesnt own contact
                // so update separately here as a separate transaction after saving
                savedEvent.Creator_Contact__c = hostCon.Id;
                Database.SaveResult sr = cov_nosharing_utilities.runDatabaseUpdate(savedEvent, false);
                if (!sr.isSuccess()) {
                    cov_log_error.logDevMsg('error while updating creator contact for an event via get user: ' + sr.getErrors());
                } else {
                    system.debug('creator contact updated.');
                }
            }


            PageReference loginPageRef = Page.cov_login;
            String msg;
            if (!alreadyHadUser) {
                msg = 'Please check your email for a temporary password and log in to finish creating your event.';
            } else if (alreadyHadUser && hasPermSet) {
                msg = 'Please log in to finish creating your event.';
            } else {                
                msg = 'To finish creating your event you must log in. If you can\'t log in please let us know at community@iava.org';
            }
            loginPageRef.getParameters().put('msg', msg);
            loginPageRef.getParameters().put('username', nonAuthEmail);
            loginPageRef.getParameters().put('startURL', '/cov_event_entry?id=' + newEventId);
            system.debug('about to return this loginPageRef: ' + loginPageRef);
            return loginPageRef;
        }
    }



    public pageReference deletePic() {

    	system.debug('deletePic() called and existingImage: ' + existingImage);
		if (existingImage != null) {
            List<Attachment> imagesToDelete = new List<Attachment> {existingImage};
            String thumbnailName = existingImage.Name.replace('image-full', 'image-thumb');
            Datetime existingImageDate = existingImage.CreatedDate;
            List<Attachment> thumbnails = [select Id, Name from Attachment 
                                                where ParentId = :eventId
                                                and Name = :thumbnailName
                                                and CreatedDate > :existingImageDate.addMinutes(-1)
                                                and CreatedDate < :existingImageDate.addMinutes(1)
                                                ];
            if (thumbnails.size() == 1) {
                imagesToDelete.addAll(thumbnails); // only delete if there is one clear winner
                theEvent.Thumbnail_image_URL__c = null;
                try {
                    update theEvent;
                } catch (Exception e) {
                    system.debug('error while clearing thumbnail field:' + e);
                    cov_log_error.logError(e);
                }
            }
			try {
				system.debug('about to delete images: ' + imagesToDelete);
				delete imagesToDelete;
				system.debug('images deleted');				
				existingImageMsg = 'Image deleted.';
				existingImageId = null;
			} catch (Exception e) { cov_log_error.logError(e); return null; }

			if (theEvent.Chatter_Group_Mirror__c != null) {
				CollaborationGroup cg = cov_groups_controller.findGroupByMirrorId(theEvent.Chatter_Group_Mirror__c);
				Id theNetworkId = cov_user_utility.self.getNetworkId();
				if (cg != null && theNetworkId != null) {
					try {
						ConnectApi.ChatterGroups.deletePhoto(theNetworkId, cg.Id);
					} catch(Exception e) { cov_log_error.logError(e); }
				}
			}

		}
		return null;
	}

    public static Attachment createAttachmentFromDataString(String filename, Id parentId, String data, Boolean isPrivate) {
        Attachment file;
        if (data != null) {
            file = new Attachment();
            file.Body = EncodingUtil.base64Decode(data);
            file.ParentId = parentId;
            file.Name = filename;
            file.isPrivate = isPrivate;
        }
        return file;
    }

    public void clearNewImageVars() {
        newImageFull = null;
        newImageThumb = null;
        newImageName = null;
        newImageType = null;
    }


    //@RemoteAction public static Id uploadImage(Id recordId, String sitePrefix, String name, String contentType, String data) {
    //    system.debug('data.length(): ' + data.length());
    //    Attachment imageFile = createAttachmentFromDataString(name, recordId, data, false);
    //    if (imageFile != null) {
    //    //Attachment imageFile = new Attachment();
    //    //if (data != null) {
    //    //    system.debug('User uploaded an image.');
    //    //    imageFile.Body = EncodingUtil.base64Decode(data);
    //    //    imageFile.ParentId = recordId;
    //    //    String originalFileName = imageFile.Name;
    //    //    imageFile.Name = name;
    //    //    imageFile.isPrivate = false;
    //        system.debug('About to try to insert the image: ' + imageFile);
    //        try {
    //            insert imageFile;
    //            system.debug('image attachment inserted.');
    //        } catch (Exception e) {
    //            system.debug('error while inserting the image:' + e);
    //            cov_log_error.logError(e);
    //            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'There was an error uploading the image.'));
    //            return null;
    //        }

    //        if (name.contains('image-thumb')) {
    //            List<IAVAEvent__c> evs = [select Id, Thumbnail_image_URL__c from IAVAEvent__c where Id = :recordId];
    //            if (evs.size() > 0) {
    //                evs[0].Thumbnail_image_URL__c = sitePrefix + 'servlet/servlet.FileDownload?file=' + imageFile.Id;
    //                try {
    //                    update evs[0];
    //                    system.debug('thumbnail field updated.');
    //                } catch (Exception e) {
    //                    system.debug('error while updating thumbnail:' + e);
    //                    cov_log_error.logError(e);
    //                }
    //            }

    //        }

    //        return imageFile.Id;

    //    } 
    //    return null;       
    //}







    // TODO:
    // √ switch image system to attachment
    // √ provide image upload mechanism
    // √ change dashboard layout to include host and such
    // x vettogether auto-name
    // √ chatter group or event feed
    // √ trigger to create the chatter group
    // √ link to create an event
    // √ link to edit an event
    // x probably some other stuff too
    // √ on delete event, delete corresponding group?  or maybe inactivate?
    // √ check for group name duplicates and use the -2 convention
    // √ auto-add event creator as attendee
    // √ when closing event box after updating event, refresh.
    // √ refresh icon like recent activity
    // √ refreshing panel breaks popup functionality
    // √ trigger on group delete to delete mirror?
    // √ make sure it works for portal user
    // √ field validation for entry page on other fields
    // √ add feed announcement about someone joining an event
    // √ disable No button for group owner, or better yet just dont remove them from the group
    // √ limit # displayed on homepage and link to full list page
    // √ geolocation
    // x default start/end times to evening times
    // √ maybe remove group creation announcement from feed or replace with event creation announcement
    // √ allow creator to save as draft and publish event / status field
    // √ trigger on change group name to change mirror name
    // √ direct links
    // √ fix link on group page to Event
    // x handle special characters for event name
    // √ show attendees on event page
    // √ copy event image to group image
    // √ notify attendees on event cancel or event info change
    // √ allow event owner to cancel event

    // √ prevent past event date

    // invites
    // possibly reorganize cov dashboard to separate events (incl give events with rucksack icon) and rewards
    // allow user to change post frequency for group
    // see about auto-thumbnail and/or vettogether auto-thumbnail
    // cant seem to delete info changed feeditem (doesnt come up in query in apex but does in soqlxplorer)

    // tier 2 or pending:
    // make them unlisted events when in unlisted groups pilot
    // visible to/joinable by fields
    // investigate pulling events into rucksack

}