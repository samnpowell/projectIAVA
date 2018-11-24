/*
	custom object to store info for use in COV

*/
public with sharing class cov_customevent {
    @AuraEnabled
	public Id eId {get; set;}
	@AuraEnabled
	public String name {get; set;}
	@AuraEnabled
	public Date startDate {get; set;}
	@AuraEnabled
	public Date endDate {get; set;} // deprec - from campaign events
	@AuraEnabled
	public Date nextDate {get; set; } // used for multiple-date events, like gives
	@AuraEnabled
	public String startTime {get; set;}
	@AuraEnabled
	public String endTime {get; set;}
	@AuraEnabled
	public String city {get; set;}
	@AuraEnabled
	public String venue {get; set;}
	@AuraEnabled
	public String street {get; set;}
	@AuraEnabled
	public String state {get; set;}
	@AuraEnabled
	public String zip {get; set;}
	@AuraEnabled
	public String description {get; set;}
	@AuraEnabled
	public String details {get; set;}
	@AuraEnabled
	public String status {get; set;}
	@AuraEnabled
	public Boolean onList {get; set;} // deprec - from campaign events
	@AuraEnabled
	public String replyStatus {get; set;}
	@AuraEnabled
	public Id attendeeId {get; set;}
	@AuraEnabled
	public String attended {get; set;}
	@AuraEnabled
	public Boolean past {get; set;}
	@AuraEnabled
	public Attachment imageFile {get; set;}
	@AuraEnabled
	public Integer imageAttachmentIndex {get; set;}
	@AuraEnabled
	public Boolean hasPicThumb {get; set;}
	@AuraEnabled
	public Boolean hasPicFull {get; set;}
	@AuraEnabled
	public String picThumb {get; set;}
	@AuraEnabled
	public String picFull {get; set;}
	@AuraEnabled
	public Id picThumbId {get; set;}
	@AuraEnabled
	public Id picFullId {get; set;}
	@AuraEnabled
	public String organizerId {get; set;}
	@AuraEnabled
	public Boolean organizerIsContact {get; set;}
	@AuraEnabled
	public String organizerName {get; set;}
	@AuraEnabled
	public String organizerShortName {get; set;}
	@AuraEnabled
	public String organizerPhotoURL {get; set;}
	@AuraEnabled
	public String organizerType {get; set;}
	@AuraEnabled
	public String eventType {get; set;}
    // lines 76-78 added 2016-10-27 by SP for IAVA Endorsed Event flags
    @AuraEnabled
    public Boolean isEndorsed {get; set;}
	@AuraEnabled
	public Id eventGroupMirrorId {get; set;}
	@AuraEnabled
	public Id eventGroupId {get; set;}
	@AuraEnabled
	public Boolean eventGroupIsPrivate {get; set;}
	@AuraEnabled
	public Boolean isInGroup {get; set;}
	@AuraEnabled
	public Boolean isLocal {get; set;}
	@AuraEnabled
	public Map<Id, String> attendeeStatusMap {get; set;}
	@AuraEnabled
	public Integer numAttendees {get; set;}
	//@AuraEnabled
	public Boolean hostAttending {get; set;}
	@AuraEnabled
	public List<User> yesAttendees {get; set;}
	@AuraEnabled
	public List<User> noAttendees {get; set;}
	@AuraEnabled
	public List<User> maybeAttendees {get; set;}
	@AuraEnabled
	public Integer numRepliesYesRollup {get; set;}
	@AuraEnabled
	public Boolean openForSignup {get; set;}
	@AuraEnabled
	public Integer replyCap {get; set;}
	@AuraEnabled
	public Decimal cost {get; set;}
	@AuraEnabled
	public String costDescription {get; set;}
	@AuraEnabled
	public Double latitude {get; set;}
	@AuraEnabled
	public Double longitude {get; set;}

	@AuraEnabled
	public Boolean collectGuestInfo {get; set;}
	//@AuraEnabled
	public Integer maxNumUnits {get; set;}
	@AuraEnabled
	public Integer maxNumGuests {get; set;}
	@AuraEnabled
	public Boolean collectGuestName {get; set;}
	@AuraEnabled
	public Boolean guestNameRequired {get; set;}
	@AuraEnabled
	public Boolean collectGuestEmail {get; set;}
	@AuraEnabled
	public Boolean guestEmailRequired {get; set;}
	@AuraEnabled
	public Boolean collectGuestPhone {get; set;}
	@AuraEnabled
	public Boolean guestPhoneRequired {get; set;}

	@AuraEnabled
	public List<eventGuest> guests {get; set;}

	@AuraEnabled
	public Boolean canAddGuests {
		get {
			return (!past && replyStatus == 'Yes' && collectGuestInfo && (guests == null || guests.size() < maxNumGuests));
		}
	}
	@AuraEnabled
	public Boolean guestListFull {
		get {
			return (collectGuestInfo!= null && collectGuestInfo && (maxNumGuests == 0 || (guests != null && guests.size() == maxNumGuests)));
		}
	}

	//@AuraEnabled
	public Integer numGuestsChosen {get; set;}
	
	
	public cov_customevent() {}
	

	
	public with sharing class eventGuest {
		@AuraEnabled
	public String FirstName {get; set;}
		@AuraEnabled
	public String LastName {get; set;}
		@AuraEnabled
	public String Email {get; set;}
		@AuraEnabled
	public String Phone {get; set;}
		@AuraEnabled
	public String Zip {get; set;}
		@AuraEnabled
	public Boolean post911 {get; set;}
		@AuraEnabled
	public Boolean veteranMember {get; set;}
		@AuraEnabled
	public Id contactId {get; set;}
		@AuraEnabled
	public Id eventId {get; set;}
		@AuraEnabled
	public Id attendeeId {get; set;}
		@AuraEnabled
	public Id parentAttendeeId {get; set;}
		@AuraEnabled
	public Boolean displayInfo {get; set;} // used to hide guest info for nonAuth user

	public eventGuest() {}

	public eventGuest(Id eventIdIn) {
			eventId = eventIdIn;
		}

	public eventGuest(IAVAEvent_Attendee__c attIn) {
			attendeeId = attIn.Id;
			contactId = attIn.Contact__c;
			eventId = attIn.Event__c;
			parentAttendeeId = attIn.Parent_Attendee__c;
			FirstName = attIn.Contact__r.FirstName;
			LastName = attIn.Contact__r.LastName;
			Email = attIn.Contact__r.Email;
			Phone = attIn.Contact__r.MobilePhone;
			Zip = attIn.Contact__r.MailingPostalCode;
			post911 = attIn.Contact__r.Post_9_11_Veteran__c;
			veteranMember = attIn.Contact__r.Veteran_Member__c;
		}
	}	


	@AuraEnabled
	public static List<cov_customevent> getAllCustomEvents(Contact theContact) {
		return getAllCustomEvents(theContact, false);
	}

	@AuraEnabled
	public static List<cov_customevent> getAllCustomEvents(Contact theContact, Boolean includeAllOwnedEvents) {
		// Return all custom events from today or in future
		// optionally past events owned by the contact's portal user

		return createCustomEventsList(new List<Id>(), theContact, includeAllOwnedEvents);
	}
	
	@AuraEnabled
	public static cov_customevent createCustomEvent(Id eventId, Contact theContact) {
		// Return a single custom event from an Event ID
		
		System.debug('Creating customevent for event ' + eventId + ' and contact ' + theContact);
		
		List<Id> IdsList = new List<Id>();
		IdsList.add(eventId);
		List<cov_customevent> cEvents = createCustomEventsList(IdsList, theContact);
		if (cEvents.size() > 0) {
			cov_customevent theEvent = cEvents[0];
			// for a single event query for the CollaborationGroup Id so can display the feed
			//system.debug('about to call setGroupInfo');
			theEvent = setGroupInfo(theEvent, theContact);

		    // get User details for attendees
		    Map<Id, User> attendeeUsersMap = new Map<Id, User>([Select Id, FirstName, LastName, SmallPhotoURL, FullPhotoURL 
		    													from User 
		    													where Id in :theEvent.attendeeStatusMap.keySet()]);
		    theEvent.yesAttendees = new List<User>();
		    theEvent.maybeAttendees = new List<User>();
		    theEvent.noAttendees = new List<User>();
		    for (Id userId : theEvent.attendeeStatusMap.keySet()) {
		    	if (theEvent.attendeeStatusMap.get(userId) == 'Yes') {
		    		theEvent.yesAttendees.add(attendeeUsersMap.get(userId));
		    	} else if (theEvent.attendeeStatusMap.get(userId) == 'Maybe') {
		    		theEvent.maybeAttendees.add(attendeeUsersMap.get(userId));
		    	} else if (theEvent.attendeeStatusMap.get(userId) == 'No') {
		    		theEvent.noAttendees.add(attendeeUsersMap.get(userId));
		    	}
		    }
		    theEvent.yesAttendees = cov_utilities.sortUsersWithPhotosFirst(theEvent.yesAttendees);
		    theEvent.maybeAttendees = cov_utilities.sortUsersWithPhotosFirst(theEvent.maybeAttendees);
		    theEvent.noAttendees = cov_utilities.sortUsersWithPhotosFirst(theEvent.noAttendees);

		    Id contactIdToPass = theContact == null ? null : theContact.Id;
		    theEvent.guests = getEventGuests(theEvent.eId, theEvent.attendeeId, contactIdToPass);

			return theEvent;
		} else {
			return null;
		}
	}

	@AuraEnabled
	public static List<eventGuest> getEventGuests(Id eventIdIn, Id attendeeIdIn, Id contactIdIn) {

		String criteria;

		if (String.isNotBlank(attendeeIdIn)) {
			system.debug('using the Parent Attendee Id to find guest attendee records: ' + attendeeIdIn);
			criteria = 'Parent_Attendee__c = \'' + attendeeIdIn + '\'';
		} else if (String.isNotBlank(contactIdIn)) {
			system.debug('using the Parent Attendee\'s Contact Id to find guest attendee records: ' + contactIdIn);
			criteria = 'Parent_Attendee__r.Contact__c = \'' + contactIdIn + '\'';
		} else {
			return null;
		}

		String q = 'select Id, Reply_Status__c, Event__c, Parent_Attendee__c'
					+ ', Contact__c, Contact__r.FirstName, Contact__r.LastName'
					+ ', Contact__r.Email, Contact__r.MobilePhone, Contact__r.MailingPostalCode, Contact__r.Post_9_11_Veteran__c, Contact__r.Veteran_Member__c'
					+ ' from IAVAEvent_Attendee__c'
					+ ' where Event__c = \'' + eventIdIn + '\''
					+ ' and ' + criteria;
		List<IAVAEvent_Attendee__c> guestAttendees = (List<IAVAEvent_Attendee__c>)cov_nosharing_utilities.runListQuery(q);


		//List<IAVAEvent_Attendee__c> guestAttendees = [
		//	select Id, Reply_Status__c
		//		, Event__c
		//		, Parent_Attendee__c
		//		, Contact__c
		//		, Contact__r.FirstName
		//		, Contact__r.LastName
		//		, Contact__r.Email
		//		, Contact__r.MobilePhone
		//		from IAVAEvent_Attendee__c
		//		where Event__c = :eventIdIn
		//			and Parent_Attendee__r.Contact__c = :ContactIdIn
		//	];
		List<eventGuest> guestsForReturn = new List<eventGuest>();
		for (IAVAEvent_Attendee__c guestAtt : guestAttendees) {
			guestsForReturn.add(new eventGuest(guestAtt));
		}
		return guestsForReturn;
	}


	@AuraEnabled
	public static cov_customevent setGroupInfo(cov_customevent theEvent, Contact theContact) {
		system.debug('going to find the Group via theEvent.eventGroupMirrorId: ' + theEvent.eventGroupMirrorId);
	    CollaborationGroup theGroup = cov_groups_controller.findGroupByMirrorId(theEvent.eventGroupMirrorId);
		system.debug('found the Group : ' + theGroup);
	    if (theGroup != null) {
	      theEvent.eventGroupId = theGroup.Id;
	      theEvent.eventGroupIsPrivate = theGroup.CollaborationType == 'Private' || theGroup.CollaborationType == 'Unlisted' ? true : false;
	      if (theContact!= null && theContact.Portal_User__c != null) {
		      try {
					CollaborationGroupMember groupmemb = [select Id from CollaborationGroupMember 
		      										where CollaborationGroupId = :theGroup.Id
		      										and MemberId = :UserInfo.getUserId()
		      										limit 1
		      										];
		      										//and MemberId = :theContact.Portal_User__c
					system.debug('CollaborationGroupMember record found');
		      		theEvent.isInGroup = true;
		      } catch (Exception e) {
				system.debug('CollaborationGroupMember record not found');
		      	theEvent.isInGroup = false;
		      }
		  }
	    }
	    system.debug('about to return from setGroupInfo and theEvent.eventGroupIsPrivate: ' + theEvent.eventGroupIsPrivate);
	    system.debug('and theEvent.isInGroup: ' + theEvent.isInGroup);
	    return theEvent;
	}

	@AuraEnabled
	public static List<cov_customevent> createCustomEventsList(List<Id> eventIds, Contact theContact) {
		return createCustomEventsList(eventIds, theContact, false);
	}

	@AuraEnabled
	public static List<cov_customevent> createCustomEventsList(List<Id> eventIds, Contact theContact, Boolean includeAllOwnedEvents) {
			// If eventIds is null, return all custom events with Show_Inside_COV__c
			// Otherwise return all custom events with Event Ids listed in eventIds

			// If theContact is null, return all events relevant to context user
			// Otherwise return events relevant to Contact's portal user

			// If includeAllOwnedEvents, also return past events owned by the user
			// (in order to populate My Events tab including past events)


			String userId;
			if (theContact == null || theContact.Portal_User__c == null) { 
				userId = UserInfo.getUserId();
			} else {
				userId = theContact.Portal_User__c;
			}


			String q = 'select Id, Name, Event_Date__c, Start_Time__c, End_Time__c'
						+ ', Event_public_Details__c, Brief_Description__c'
						+ ', Type__c, Organizer_Type__c'
                        // lines 366-367 added 2016-10-27 by SP for IAVA Endorsed Event flags
                        + ', isIAVAEndorsed__c'
						+ ', Chatter_Group_Mirror__c, Chatter_Group_Mirror__r.Group_ID__c'
						+ ', Thumbnail_image_URL__c'
						//+ ', Organizer_contact__r.Portal_user__r.Name, Organizer_contact__r.Portal_user__r.SmallPhotoURL'
						+ ', OwnerId, Owner.Name'
						+ ', Status__c'
						+ ', Location_City__c, Location_State__c'
						+ ', Location_Zip_Code__c, Location_Street_Address__c, Location_Venue__c'
						+ ', Latitude__c, Longitude__c'
						+ ', Reply_Cap__c, Num_Replies_Yes__c, Num_Replies_Remaining__c'
						+ ', Associated_Cost__c, Cost_Description__c'
						+ ', Creator_Contact__c, Creator_Contact__r.FirstName, Creator_Contact__r.LastName'
						+ ', Max_number_of_guests__c'
						+ ', Collect_Guest_Name__c, Collect_Guest_Email__c, Collect_Guest_Phone__c'
						//+ ', Event_Image__c'
						+ ', (select id, Name from Attachments where name like \'%image%\' order by CreatedDate DESC)';

					// attendee subquery only used for event page, not checkin page
					if(eventIds.size() > 0) {
						q+= ', (select Id, Reply_Status__c, Attended__c, Contact__c, Contact__r.Portal_User__c from Event_Attendees__r order by Reply_Status__c DESC limit 100' 
							//+ ' where Contact__c = \'' + theContact.Id + '\'' 
							+ ')';
					}

						q+= ' from IAVAEvent__c'
						+ ' where'
						//+ ' where Type=\'Event\'';
						//+ ' where ('
						//	+ '(Status__c = \'Published\''
						//	//+ ' OR ('
						//	//	+ (userId == null ? '' : 'OwnerId = \'' + userId + '\' AND')
						//	//	+ ' Organizer_Type__c = \'Distributed\''
						//	//	+ ' AND (Status__c = null OR Status__c = \'Unpublished\')' 
						//	//	+ ')'
						//	+ ')'
						//+ ')'
						;
			if(eventIds.size() > 0) {
				//q+= ' and Id in :eventIds';
				q+= ' Id in (';
				for (Integer i=0; i < eventIds.size(); i++) {
					if (i != 0) {
						q+= ', ';
					}
					q+= '\'' + eventIds[i] + '\'';
				}
				q+= ')';
				System.debug('query for events by Id list: ' + q);
			} else {

				//Date todayDate = System.Today();
				DateTime todayDate = System.now();
				//q+= ' and Show_Inside_COV__c = true'
				//q+= ' and (Event_Date__c >= :todayDate or Event_Date__c = null)'
				q+= ' ('
					+ 'Status__c = \'Published\''
					+ ' AND (Event_Date__c >= ' + todayDate.format('yyyy-MM-dd') + ' or Event_Date__c = null)'
					+ ')';

				if (includeAllOwnedEvents && userId != null) {
					q+= ' or (OwnerId = \'' + userId + '\' and Status__c != \'Canceled\' and Status__c != \'Flagged/Removed\')';
				}
				
				q+= ' order by Event_Date__c';
				System.debug('query for all events: ' + q);
			}

			
			//List<IAVAEvent__c> theEvents = Database.query(q);
			List<IAVAEvent__c> theEvents = (List<IAVAEvent__c>)cov_nosharing_utilities.runListQuery(q);
			// without sharing since attendee records have a lookup to Contact
			// so they are not visible to users who dont have access to those contacts

			System.debug('theEvents: ' + theEvents);
			//if (theEvents.size() > 0) {
			//	system.debug('theEvents[0].Event_Attendees__r: ' + theEvents[0].Event_Attendees__r);
			//}

  			List<cov_customevent> cEvents_main = new List<cov_customevent>();

			if (theEvents.size() > 0) {

				// also get user photo urls
				Set<Id> ownerIds = new Set<Id>();
				Set<String> groupIds = new Set<String>();
				for (IAVAEvent__c ev : theEvents) {
					ownerIds.add(ev.OwnerId);
					groupIds.add(ev.Chatter_Group_Mirror__r.Group_ID__c);
				}

				// changed these to nosharing queries
				//Map<Id, User> usermap = new Map<Id, User>([select Name, FirstName, LastName, SmallPhotoURL, UserType from User where Id in :ownerIds]);
				//Map<Id, CollaborationGroup> groupMap = new Map<Id, CollaborationGroup>([select Id, Name, SmallPhotoURL from CollaborationGroup where Id in :groupIds]);

				String setString = '';
				for (Id i : ownerIds) {
				   setString += (setString==''?'':',')+ '\'' + (i==null ? '' : i) + '\'';
				}
				String userQuery = 'select Name, FirstName, LastName, SmallPhotoURL, UserType from User where Id in (' + setString + ')';
				Map<Id, User> usermap = new Map<Id, User>((List<User>)cov_nosharing_utilities.runListQuery(userQuery));

				setString = '';
				for (Id i : groupIds) {
				   setString += (setString==''?'':',')+ '\'' + (i==null ? '' : i) + '\'';
				}
				String groupQuery = 'select Id, Name, SmallPhotoURL, CollaborationType from CollaborationGroup where Id in (' + setString + ')';
				Map<Id, CollaborationGroup> groupMap = new Map<Id, CollaborationGroup>((List<CollaborationGroup>)cov_nosharing_utilities.runListQuery(groupQuery));

	  				
	  			//List<cov_customevent> cEvents_nonlocal = new List<cov_customevent>();
	  			for (IAVAEvent__c evnt : theEvents) {
	  				Double lat = theContact == null ? null : theContact.MA_Latitude__c;
	  				Double lon = theContact == null ? null : theContact.MA_Longitude__c;
	  				//system.debug('usermap.get(evnt.OwnerId): ' + usermap.get(evnt.OwnerId));
	  				cov_customevent newCE = new cov_customevent(evnt, usermap.get(evnt.OwnerId), lat, lon);

	  				// if no thumbnail use group thumbnail instead
	  				Id evntGroupId;
	  				if (evnt.Chatter_Group_Mirror__c != null) {
	  					evntGroupId = evnt.Chatter_Group_Mirror__r.Group_ID__c;
	  				}
	  				CollaborationGroup evntGroup = groupMap.get(evntGroupId);
	  				if (!newCE.hasPicThumb && evntGroupId != null && evntGroup != null && evntGroup.CollaborationType != 'Unlisted' && !Test.isRunningTest()) {
	  					// TODO: instead of filtering out Unlisted, possibly find a way to check if user has access (is a member) before running the connectAPI method
	  					// cant use ConnectApi methods in test without using UseAllData which messes up the tests
	  					try {
		  					ConnectApi.Photo photoconnect = ConnectAPI.ChatterGroups.getPhoto(cov_user_utility.self.getNetworkId(), evntGroupId);
	  					// the IF statement below would prevent it from using the default group thumbnail,
	  					// but actually it's better than the default event thumbnail anyway
	  					//if (!photoconnect.smallPhotoUrl.contains('default_group_profile') && !photoconnect.smallPhotoUrl.endsWith('0F9/T')) {
		  					newCe.picThumb = photoconnect == null ? null : photoconnect.smallPhotoUrl;
		  					newCe.picThumbId = photoconnect == null ? null : photoconnect.photoVersionId;
		  					newCe.hasPicThumb = photoconnect == null ? false : true;
		  				//}
		  				} catch (Exception e) { cov_log_error.logError(e, 'Error running connectAPI method to get thumbnail photo from group'); }
	  				}

	  				// eliminate local sorting here because gets wiped out by date sorting
	  				//if (newCE.isLocal == null || newCE.isLocal) {
	  				//	system.debug('isLocal is true for: ' + newCE.name);
	  					cEvents_main.add(newCE);
	  				//} else {
	  				//	system.debug('isLocal is false for: ' + newCE.name);
	  				//	cEvents_nonlocal.add(newCE);
	  				//}
	  			}
	  			//system.debug('cEvents_main: ' + cEvents_main);
	  			//system.debug('cEvents_nonlocal: ' + cEvents_nonlocal);
	  			//cEvents_main.addAll(cEvents_nonlocal);
	  		}
  			return cEvents_main;
	}


	
	public cov_customevent(IAVAEvent__c theEvent) {
		// stub constructor for a canceled event
		// used by cov_events_controller.getEventID()
		if (theEvent != null) {
			eId = theEvent.Id;
			status = theEvent.Status__c;
		}
	}


	public cov_customevent(IAVAEvent__c theEvent, User hostUser, Double lat, Double lon) {

		Integer SEARCH_RADIUS = 25; // miles
		
		//System.debug('theEvent: ' + theEvent);
		//System.debug('hostUser: ' + hostUser);
		
		eId = theEvent.Id;
		name = theEvent.Name;
		startDate = theEvent.Event_Date__c;
		nextDate = startDate == null ? System.today().addDays(30) : startDate;
		startTime = theEvent.Start_Time__c;
		endTime = theEvent.End_Time__c;
		city = theEvent.Location_City__c;
		state = theEvent.Location_State__c;
		zip = theEvent.Location_Zip_Code__c;
		street = theEvent.Location_Street_Address__c;
		venue = theEvent.Location_Venue__c;
		details = theEvent.Event_public_Details__c;
		description = theEvent.Brief_Description__c;
		eventType = theEvent.Type__c;
        // lines 553-554 added 2016-10-27 by SP for IAVA Endorsed Event flags
        isEndorsed = theEvent.isIAVAEndorsed__c;
		organizerType = theEvent.Organizer_Type__c;
		status = theEvent.Status__c;
		latitude = theEvent.Latitude__c;
		longitude = theEvent.Longitude__c;
		//maxNumUnits = theEvent.Max_units_per_request__c != null ? theEvent.Max_units_per_request__c.intValue() : 0;
		//maxNumGuests = maxNumUnits != null && maxNumUnits > 0 ? maxNumUnits - 1 : 0;
		maxNumGuests = theEvent.Max_number_of_guests__c != null ? theEvent.Max_number_of_guests__c.intValue() : 0;
		collectGuestName = (theEvent.Collect_Guest_Name__c == 'Optional' || theEvent.Collect_Guest_Name__c == 'Required') ? true : false;
		guestNameRequired = theEvent.Collect_Guest_Name__c == 'Required' ? true : false;
		collectGuestEmail = (theEvent.Collect_Guest_Email__c == 'Optional' || theEvent.Collect_Guest_Email__c == 'Required') ? true : false;
		guestEmailRequired = theEvent.Collect_Guest_Email__c == 'Required' ? true : false;
		collectGuestPhone = (theEvent.Collect_Guest_Phone__c == 'Optional' || theEvent.Collect_Guest_Phone__c == 'Required') ? true : false;
		guestPhoneRequired = theEvent.Collect_Guest_Phone__c == 'Required' ? true : false;
		collectGuestInfo = maxNumGuests > 0 && (collectGuestName || collectGuestEmail || collectGuestPhone) ? true : false;
		numRepliesYesRollup = theEvent.Num_Replies_Yes__c == null ? 0 : theEvent.Num_Replies_Yes__c.intValue();
		//onList = theEvent.Event_Attendees__r.size() >= 1 ? true : false;
      	past = theEvent.Event_Date__c < Date.Today() ? true : false;
      	hasPicThumb = false;
      	hasPicFull = false;
      	imageFile = new Attachment();
      	//picFull = theEvent.Event_Image__c;
      	//hasPicFull = picFull == null ? false : true;
      	//organizerId = theEvent.Organizer_contact__c == null ? null : theEvent.Organizer_contact__c;
      	//organizerName = theEvent.Organizer_contact__c == null || theEvent.Organizer_contact__r.Portal_user__r == null ? null : theEvent.Organizer_contact__r.Portal_user__r.Name;
      	//organizerShortName = theEvent.Organizer_contact__c == null || theEvent.Organizer_contact__r.Portal_user__r == null ? null : theEvent.Organizer_contact__r.Portal_user__r.Name;
      	//organizerPhotoURL = theEvent.Organizer_contact__c == null || theEvent.Organizer_contact__r.Portal_user__r == null ? null : theEvent.Organizer_contact__r.Portal_user__r.SmallPhotoURL;
      	organizerId = hostUser == null ? null : hostUser.Id;
      	organizerIsContact = theEvent.Creator_Contact__c != null && hostUser != null && hostUser.UserType == 'Standard' ? true : false;
      	//organizerName = hostUser.Name;
      	//organizerShortName = hostUser.FirstName + ' ' + hostUser.LastName.left(1) + '.';
      	if (organizerType == 'Staff') {
      		organizerName = 'IAVA';
      		organizerShortName = 'IAVA';
  		} else {
	      	organizerName = organizerIsContact ? theEvent.Creator_Contact__r.FirstName + ' ' + theEvent.Creator_Contact__r.LastName : hostUser.Name;
	      	organizerShortName = organizerIsContact ? theEvent.Creator_Contact__r.FirstName + ' ' + theEvent.Creator_Contact__r.LastName.left(1) + '.' : hostUser.FirstName + ' ' + hostUser.LastName.left(1) + '.';
	      	organizerPhotoURL = hostUser == null ? null : hostUser.SmallPhotoURL;
	    }
      	eventGroupMirrorId = theEvent.Chatter_Group_Mirror__c;

      	numAttendees = 0;
      	//hostAttending = false;
      	Id currentUserContactId = cov_user_utility.self.getCID();
      	attendeeStatusMap = new Map<Id, String>();
      	for (IAVAEvent_Attendee__c ea : theEvent.Event_Attendees__r) {
      		if (ea.Contact__c == currentUserContactId && currentUserContactId != null) {
	      		replyStatus = ea.Reply_Status__c;
	      		attended = ea.Attended__c;
	      		attendeeId = ea.Id;
	      	}
	      	if (ea.Reply_Status__c == 'Yes' || ea.Reply_Status__c == 'Maybe') {
	      		numAttendees++;
	      		//if (ea.Contact__c == hostUser.Id) {
	      		//	hostAttending = true;
	      		//}
	      	}
	      	if (ea.Contact__c != null) {
		      	attendeeStatusMap.put(ea.Contact__r.Portal_User__c, ea.Reply_Status__c);
		    }
      	}
      	replyCap = (Integer)theEvent.Reply_Cap__c;
      	cost = theEvent.Associated_Cost__c;
      	costDescription = theEvent.Cost_Description__c;
      	openForSignup = (theEvent.Reply_Cap__c == null || theEvent.Num_Replies_Remaining__c > 0);

      	//system.debug('attendeeStatusMap: ' + attendeeStatusMap);

      	List<String> imageIds = cov_utilities.parseImagesFromAttachments(theEvent.Attachments);
      	if (!String.isEmpty(imageIds[0])) {
      		hasPicFull = true;
      		picFullId = imageIds[0];
      		picFull = 'servlet/servlet.FileDownload?file=' + imageIds[0];
      	} else {
      		hasPicFull = false;
      	}
      	if (!String.isEmpty(imageIds[1])) {
      		hasPicThumb = true;
      		picThumbId = imageIds[1];
      		picThumb = 'servlet/servlet.FileDownload?file=' + imageIds[1];
      	} else {
      		hasPicThumb = false;
      	}

      	// if there's a thumbnail URL specified on the record, overwrite what was captured
		if(theEvent.Thumbnail_image_URL__c != null) {
			picThumb = theEvent.Thumbnail_image_URL__c;
			hasPicThumb = true;
		}


		// MOVED TO SEPARATE UTILITY (ABOVE)
		//Integer numImages = theEvent.Attachments.size();
		//Integer i = 0;
		//if(theEvent.Thumbnail_image_URL__c != null) {
		//	picThumb = theEvent.Thumbnail_image_URL__c;
		//	hasPicThumb = true;
		//}
		//if(numImages > 0) {

		//	String backupImage;
		//	Id backupImageId;
		//	Attachment backupImageFile;
			
		//	while (i < numImages && (!hasPicThumb || !hasPicFull)) {
		//		String attachmentName = theEvent.Attachments[i].Name;
		//		//system.debug('attachmentName: ' + attachmentName);
		//		if (attachmentName == 'image-thumb' && !hasPicThumb) {
		//			hasPicThumb = true;
		//			picThumb = 'servlet/servlet.FileDownload?file=' + theEvent.Attachments[i].Id;
		//			picThumbId = theEvent.Attachments[i].Id;
		//		} else if (attachmentName == 'image-full' && !hasPicFull) {
		//			hasPicFull = true;
		//			picFull = 'servlet/servlet.FileDownload?file=' + theEvent.Attachments[i].Id;
		//			picFullId = theEvent.Attachments[i].Id;
		//			imageFile = theEvent.Attachments[i];
		//			imageAttachmentIndex = i;
		//		} else if (!hasPicFull && (attachmentName.right(4) == '.jpg' || attachmentName.right(4) == '.gif' || attachmentName.right(4) == '.png')) {
		//			//system.debug('appears to be an image file ending with: ' + attachmentName.right(4));
		//			backupImage = 'servlet/servlet.FileDownload?file=' + theEvent.Attachments[i].Id;
		//			backupImageId = theEvent.Attachments[i].Id;
		//			backupImageFile = theEvent.Attachments[i];
		//		}
		//		i++;

		//	} 
		//	if (!hasPicFull && !String.isEmpty(backupImage)) {
		//		picFull = backupImage;
		//		picFullId = backupImageId;
		//		imageFile = backupImageFile;
		//		hasPicFull = true;
		//	}

		//	if (hasPicFull && !hasPicThumb) {
		//		picThumb = picFull;
		//		picThumbId = picFullId;
		//		hasPicThumb = true;
		//	}
			
		//}

        if (lat != null && lon != null && theEvent.Latitude__c != null && theEvent.Longitude__c != null) {

            Double DST = SEARCH_RADIUS;
            Double Delta = DST / 69;
            System.debug('Delta: ' + Delta);
            Double minLAT = LAT - Delta;  
            Double maxLAT = LAT + Delta;
            Double minLON = LON - Delta;
            Double maxLON = LON + Delta;
            if (theEvent.Latitude__c >= minLAT
            	&& theEvent.Latitude__c <=  maxLAT
            	&& theEvent.Longitude__c >= minLON
                && theEvent.Longitude__c <= maxLON
                 ) {
            	isLocal = true;
            } else {
            	isLocal = false;
            }
        } else {
        	isLocal = false;
        }
		
		
	}	

	// custom attendee class not necessary after all, using custom object instead for better permissions security
	//public with sharing class cov_customevent_attendee {

	//public Id attendeeRecordId {get; set;}
	//public Id eventId {get; set;}
	//public Id contactId {get; set;}
	//public String attendeename {get; set;}
	//public String replystatus {get; set;}
	//public String attended {get; set;}

	//public cov_customevent_attendee(IAVAEvent_Attendee__c attnd) {
	//		attendeeRecordId = attnd.Id;
	//		eventId = attnd.Event__c;
	//		contactId = attnd.Contact__c;
	//		attendeename = attnd.Attendee_Name__c;
	//		replystatus = attnd.Reply_Status__c;
	//		attended = attnd.Attended__c;
	//	}

	//}

	// public static List<cov_customevent_attendee> createAttendeeList(List<IAVAEvent_Attendee__c> attendeeList) {
	//	List<cov_customevent_attendee> returnList = new List<cov_customevent_attendee>();
	//	for (IAVAEvent_Attendee__c attnd : attendeeList) {
	//		returnList.add(new cov_customevent_attendee(attnd));
	//	}
	//	return returnList;
	//}


	// adapted from http://www.sundoginteractive.com/sunblog/posts/sorting-lists-in-apex
	//  This is a simple quicksort algorithm to sort a SelectOption list (dropdown) by label alphabetically.	


	public cov_customevent(Give__c theGive, Double lat, Double lon) {

		Integer SEARCH_RADIUS = 25; // miles
		
		//System.debug('theEvent: ' + theEvent);
		//System.debug('hostUser: ' + hostUser);
		
		eId = theGive.Id;
		name = theGive.Name;
		startDate = theGive.Earliest_Start_Date__c;
		endDate = theGive.Latest_End_Date__c;
		//startTime = theEvent.Start_Time__c;
		//endTime = theEvent.End_Time__c;
		city = theGive.City_Formula__c;
		state = theGive.State_Formula__c;
		//zip = theEvent.Location_Zip_Code__c;
		//street = theEvent.Location_Street_Address__c;
		//venue = theEvent.Location_Venue__c;
		//details = theEvent.Event_public_Details__c;
		//description = theEvent.Brief_Description__c;
		eventType = 'Reward';
		organizerType = 'Staff';
  		organizerName = 'IAVA';
  		organizerShortName = 'IAVA';
		status = theGive.Status__c == 'Open' || theGive.Status__c == 'Waitlist' ? 'Published' : '';
		latitude = theGive.Latitude__c;
		longitude = theGive.Longitude__c;

		system.debug('theGive.Give_Instances__r: ' + theGive.Give_Instances__r);
		if (endDate != null && startDate < System.today() && endDate >= System.today()) {
			nextDate = System.today();
		} else if (theGive.Give_Instances__r.size() > 1) {
			for (Give_Instance__c gi : theGive.Give_Instances__r) {
				if (gi.Start_Date__c != null && gi.Start_Date__c > System.today() && (nextDate == null || gi.Start_Date__c < nextDate)) {
					nextDate = gi.Start_Date__c;
				}
			}
		} else {
			nextDate = startDate;
		}
		nextDate = nextDate == null ? System.today().addDays(30) : nextDate;

      	past = nextDate != null && nextDate < Date.Today() ? true : false;
      	imageFile = new Attachment();



      	organizerId = null;
      	organizerIsContact = false;

      	List<String> imageIds = cov_utilities.parseImagesFromAttachments(theGive.Attachments);
      	if (!String.isEmpty(imageIds[0])) {
      		hasPicFull = true;
      		picFullId = imageIds[0];
      		picFull = 'servlet/servlet.FileDownload?file=' + imageIds[0];
      	} else {
      		hasPicFull = false;
      	}
      	if (!String.isEmpty(imageIds[1])) {
      		hasPicThumb = true;
      		picThumbId = imageIds[1];
      		picThumb = 'servlet/servlet.FileDownload?file=' + imageIds[1];
      	} else {
      		hasPicThumb = false;
      	}



        if (lat != null && lon != null && theGive.Latitude__c != null && theGive.Longitude__c != null) {

            Double DST = SEARCH_RADIUS;
            Double Delta = DST / 69;
            System.debug('Delta: ' + Delta);
            Double minLAT = LAT - Delta;  
            Double maxLAT = LAT + Delta;
            Double minLON = LON - Delta;
            Double maxLON = LON + Delta;
            if (theGive.Latitude__c >= minLAT
            	&& theGive.Latitude__c <=  maxLAT
            	&& theGive.Longitude__c >= minLON
                && theGive.Longitude__c <= maxLON
                 ) {
            	isLocal = true;
            } else {
            	isLocal = false;
            }
        } else {
        	isLocal = false;
        }
		
		
	}	




	@AuraEnabled
	public static List<cov_customevent> sortEventsByDate(List<cov_customevent> ListToSort, Boolean ascending)	{
		// sorting doesnt really work if an event date is null

		if(ListToSort == null || ListToSort.size() <= 1) {
			return ListToSort;					
		}
		
		List<cov_customevent> EarlierInList = new List<cov_customevent>();		
		List<cov_customevent> LaterInList = new List<cov_customevent>();	
			
		integer pivot = 0;
		// save the pivot and remove it from the list		
		cov_customevent pivotValue = ListToSort[pivot];		
		ListToSort.remove(pivot);				
		for(cov_customevent x : ListToSort) {
			if (x.nextDate == null) {
				LaterInList.add(x);
			} else if(x.nextDate <= pivotValue.nextDate) {
				if (ascending) {
					EarlierInList.add(x);
				} else {
					LaterInList.add(x);
				}
			} else if(x.nextDate > pivotValue.nextDate) {
				if (ascending) {
					LaterInList.add(x);
				} else {
					EarlierInList.add(x);
				}
			} 	
		}		
		List<cov_customevent> returnList = new List<cov_customevent> ();		
		returnList.addAll(sortEventsByDate(EarlierInList, ascending));
		returnList.add(pivotValue);	
		returnList.addAll(sortEventsByDate(LaterInList, ascending));	
		
		return returnList; 
	}

	@AuraEnabled
	public static List<cov_customevent> sortLocalEventsFirst(List<cov_customevent> ListToSort) {
		return sortLocalEventsFirst(ListToSort, null);
	}

	@AuraEnabled
	public static List<cov_customevent> sortLocalEventsFirst(List<cov_customevent> ListToSort, Integer numDaysUntilIgnoreLocalness)	{
		// numDaysUntilIgnoreLocalness is the number of days from now after which
		// if the event starts after that, the localness of an event is ignored
		if (numDaysUntilIgnoreLocalness == null || numDaysUntilIgnoreLocalness < 0) {
			numDaysUntilIgnoreLocalness = 30;
		}

		if(ListToSort == null || ListToSort.size() <= 1) {
			return ListToSort;					
		}
		
		List<cov_customevent> localEvents = new List<cov_customevent>();		
		List<cov_customevent> nonLocalEvents = new List<cov_customevent>();	

		system.debug('ok flip through these custom events bruh');
		for(cov_customevent x : ListToSort) {
			system.debug('now lookin at: ' + x.name);
			if (x.isLocal && (x.nextDate == null || x.nextDate <= Date.Today().addDays(numDaysUntilIgnoreLocalness) )) {
				localEvents.add(x);
			} else {
				nonLocalEvents.add(x);
			}
		}
		if (nonLocalEvents.size() > 0) {
			localEvents.addAll(nonLocalEvents);
		}
		return localEvents;

	}
	

	@AuraEnabled
	public static IAVAEvent_Attendee__c upsertAttendeeFromEventGuest(EventGuest egIn, String replyValue) {
		system.debug('Upsert attendee record from this eventGuest: ' + egIn);

		// First find or insert the Contact

		Contact attendeeContact;

		// find contact using the Id in the eventGuest record
		if (egIn.contactId != null) {
			try {
				attendeeContact = [select Id, FirstName, LastName, Email, MobilePhone, MailingPostalCode, Post_9_11_Veteran__c from Contact where Id = :egIn.contactId limit 1];
			} catch (Exception e) { cov_log_error.logError(e, 'no contact found for the Id in the eventGuest record: ' + egIn);}
		} 

		// if not found, try finding contact via Email
		if (attendeeContact == null) {
			if (String.isNotBlank(egIn.Email)) {
				List<Contact> existingContacts = cov_user_contact_utility.getContactsFromEmail(egIn.Email, new List<String>{'MobilePhone'});
				if (existingContacts.size() > 0) {
					attendeeContact = existingContacts[0];
					system.debug('attendee contact found via email: ' + attendeeContact);
				}
			}
			if (attendeeContact == null) {
				// if still not found insert new contact
				String theLastName = String.isBLank(egIn.LastName) ? (String.isBLank(egIn.Email) ? '(Unknown)' : egIn.Email) : egIn.LastName;
				attendeeContact = new Contact(FirstName = egIn.FirstName, LastName = theLastName, Email = egIn.Email, MobilePhone = egIn.Phone);
				
		        // Pre-insert account if it's a portal user as a workaround to NPSP issue
		        // where NPSP3 accounts trigger which cant insert an account
		        // with a portal user as owner. So instead first create the account before inserting contact
		        // If issue gets fixed by NPSP then can remove this code (and part 2 a few lines below).
		        Account a = cov_npsp_workaround.preInsertAdminOwnedAccount(attendeeContact, true);
		        if (a != null && a.Id != null) {
		          attendeeContact.AccountId = a.Id;
		        }

				Database.SaveResult sr = cov_nosharing_utilities.runDatabaseInsert(attendeeContact, false);
				if (sr.isSuccess()) {
					system.debug('new contact successfully inserted: ' + attendeeContact);
				} else {
					cov_log_error.logDevMsg('Error inserting a new contact while saving an event guest. attendeeContact: ' + attendeeContact);
					ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, there was a problem registering this guest.  (Code #cstev-b)'));
					return null;
				}

				//try {
				//	insert attendeeContact;
				//	system.debug('new contact successfully inserted: ' + attendeeContact);
				//} catch (Exception e) {
				//	cov_log_error.logError(e, 'Error inserting a new contact while saving an event guest. attendeeContact: ' + attendeeContact);
				//	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, there was a problem registering this guest.  (Code #cstev-b)'));
				//	return null;
				//}

	            // Part 2 of the NPSP account workaround referenced above
		        if (a != null && a.npe01__One2OneContact__c == null) {
		          cov_npsp_workaround.postUpdateAccountOne2OneContact(a, attendeeContact);
		        }
		        
			}
		} 

		IAVAEvent_Attendee__c attendeeToReturn;

		// Now update or insert attendee record

		IAVAEvent_Attendee__c existingAttendee;

		// First see if there's an existing attendee record
		try {
			existingAttendee = 
				[select Id, Reply_Status__c, Parent_Attendee__c, Contact__c 
					from IAVAEvent_Attendee__c
					where Event__c = :egIn.eventId
					and Contact__c = :attendeeContact.Id
				];
			system.debug('existing attendee record found: ' + existingAttendee);
		} catch (Exception e) {system.debug('existing attendee record NOT found.');}

		// if existing attendee record found, update as necessary
		if (existingAttendee != null) {
			if (existingAttendee.Parent_Attendee__c != null && existingAttendee.Parent_Attendee__c != egIn.parentAttendeeId) {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'That person is already registered for this event.'));
				Boolean updatedContact = fillInContactInfoFromAttendeeInfo(egIn, attendeeContact);
				return null;
			} else if (existingAttendee.Id != egIn.attendeeId && existingAttendee.Reply_Status__c == 'Yes' && replyValue == 'Yes') {
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'That person is already registered for this event.'));	
				Boolean updatedContact = fillInContactInfoFromAttendeeInfo(egIn, attendeeContact);
				return null;				
			} else {
				Boolean updateTheAttendeeRecord = false;
				if (existingAttendee.Reply_Status__c != 'Yes' && existingAttendee.Parent_Attendee__c == null) {
					system.debug('need to update existingAttendee.Parent_Attendee__c to: ' + egIn.parentAttendeeId);
					existingAttendee.Parent_Attendee__c = egIn.parentAttendeeId;
					updateTheAttendeeRecord = true;
				}
				if (replyValue != existingAttendee.Reply_Status__c) {
					existingAttendee.Reply_Status__c = replyValue;
					updateTheAttendeeRecord = true;
				}
				if (updateTheAttendeeRecord) {

					Database.SaveResult sr = cov_nosharing_utilities.runDatabaseUpdate(existingAttendee, false);

					if (!sr.isSuccess()) {
						cov_log_error.logDevMsg('Error updating the attendee record while saving an event guest: ' + egIn);
			            for (Database.Error er : sr.getErrors()) {
			                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, er.getMessage()));
			            }
						ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, there was a problem registering this guest. (Code #cstev-a)'));
						return null;
			        } else {
			        	attendeeToReturn = existingAttendee;
			        }
			    }

			}
		} else {
			// if no existing attendee record found, insert new attendee record
			IAVAEvent_Attendee__c newAttendee = new IAVAEvent_Attendee__c(
				Event__c = egIn.eventId
				, Contact__c = attendeeContact.Id
				, Parent_Attendee__c = egIn.parentAttendeeId
				, Reply_Status__c = replyValue
				);

			system.debug('about to insert this newAttendee: ' + newAttendee);
			Database.SaveResult sr = cov_nosharing_utilities.runDatabaseInsert(newAttendee, false);

			if (!sr.isSuccess()) {
				cov_log_error.logDevMsg('Error inserting a new attendee record while saving an event guest. newAttendee: ' + newAttendee);
	            for (Database.Error er : sr.getErrors()) {
	                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, er.getMessage()));
	            }
				ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Sorry, there was a problem registering this guest.  (Code #cstev-c)'));
				return null;
	        } else {
	            system.debug('attendee record inserted with id: ' + sr.getId());
	            attendeeToReturn = newAttendee;
	        }
		}

		Boolean updatedContact = fillInContactInfoFromAttendeeInfo(egIn, attendeeContact);


		return attendeeToReturn;

	}

	@AuraEnabled
	public static Boolean fillInContactInfoFromAttendeeInfo(eventGuest egstIn, Contact cIn) {
		// If appropriate, also update the Contact

		Boolean updateTheContactRecord = false;
		if(String.isNotBlank(egstIn.FirstName) && String.isBlank(cIn.FirstName)) {
			cIn.FirstName = egstIn.FirstName;
			updateTheContactRecord = true;
		}
		if(String.isNotBlank(egstIn.LastName) && 
			(String.isBlank(cIn.LastName) || (String.isNotBlank(cIn.LastName) && (cIn.LastName == cIn.Email || cIn.LastName == '(Unknown)')) )
				) {
			cIn.LastName = egstIn.LastName;
			updateTheContactRecord = true;
		}
		if(String.isNotBlank(egstIn.Email) && String.isBlank(cIn.Email)) {
			cIn.Email = egstIn.Email;
			updateTheContactRecord = true;
		}
		if(String.isNotBlank(egstIn.Phone) && String.isBlank(cIn.MobilePhone)) {
			cIn.MobilePhone = egstIn.Phone;
			updateTheContactRecord = true;
		}
		if(egstIn.post911 == true && cIn.Post_9_11_Veteran__c != true) {
			cIn.Post_9_11_Veteran__c = true;
			updateTheContactRecord = true;
		}
		if(egstIn.veteranMember == true && cIn.Veteran_Member__c != true) {
			cIn.Veteran_Member__c = true;
			updateTheContactRecord = true;
		}
		if(String.isNotBlank(egstIn.Zip) && String.isBlank(cIn.MailingPostalCode)) {
			cIn.MailingPostalCode = egstIn.Zip;
			updateTheContactRecord = true;
		}
		if (updateTheContactRecord) {
			Database.SaveResult sr = cov_nosharing_utilities.runDatabaseUpdate(cIn, false);
			if (sr.isSuccess()) {
				return true;
			} else {
				cov_log_error.logDevMsg('Error updating the contact while saving an event guest: ' + egstIn + ' and contact: ' + cIn);
				// probably no need to throw an error if this contact update doesnt work
	            //for (Database.Error er : sr.getErrors()) {
	            //    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, er.getMessage()));
	            //}
				//return new ApexPages.Message(ApexPages.Severity.Error, 'There was a problem updating that person\'s info');
				return false;
	        } 

		} else {
			return false;
		}
	}

}