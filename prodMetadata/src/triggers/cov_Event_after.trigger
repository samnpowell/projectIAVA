trigger cov_Event_after on IAVAEvent__c (after insert, after update)
{
    /* begin bulkified trigger */
    
    // rename Group when Event is renamed
    // add link on Group page to Event page
    // flag when an Event is changed
    
    IAVAEvent__c oe; // to hold the old event for comparisons
    Boolean updateGroupName = false; // flag to let us know if we need to update the group name
    Boolean updateGroupInfo = false; // flag to let us know if we need to update the group info
    Map<Id,Boolean> notifyAttendeesOfChange = new Map<Id,Boolean>(); // map of event id to flag that will let us know if we need to notify attendees of a change
    String fieldFlag; // string to contain list of fields that have changed
    Map<Id,String> flagChangedFields = new Map<Id,String>(); // map of event id to string containing changed fields (to include in email)
    //Boolean notifyAttendeesOfChange = false; // flag to let us know if we need to notify attendees of a change
    Map<Id,Boolean> suppressAttendeeEmails = new Map<Id,Boolean>(); // map of event id to flag that will let us know if we need to suppress attendee notifications
    //Boolean suppressAttendeeEmails = false; // flag to let us know if we need to suppress attendee notifications
    List<Id> theMirrorIds = new List<Id>(); // list of chatter group mirror ids to pass to cov_groups_controller
    Map<Id,String> nameMap = new Map<Id,String>(); // map of collaboration group id (key) to event name (value)
    Map<Id,Id> idMap = new Map<Id,Id>(); // map of collaboration group id (key) to event id (value)
    Set<Id> changedEventIds = new Set<Id>(); // set of updated event ids
    Set<Id> suppressEventIds = new Set<Id>(); // set of event ids where emails have been suppressed
    List<CollaborationGroup> groupsToUpdate = new List<CollaborationGroup>(); // list of groups to update
    List<IAVAEvent_Attendee__c> attendeesToUpdate = new List<IAVAEvent_Attendee__c>(); // list of event attendees to update
    
    for(IAVAEvent__c e: trigger.new)
    {
        fieldFlag = null; // reset the field flag at the start of the loop
        
        if(trigger.isUpdate)
        {
            oe = trigger.oldMap.get(e.Id);
        } // if the trigger runs on update, capture the old event so it can be compared to the new one
        
        if(trigger.isUpdate && (e.Name != oe.Name) && e.Chatter_Group_Mirror__c != null)
        {
            updateGroupName = true;
            nameMap.put(e.Chatter_Group_Mirror_Group_Id__c,e.Name);
            system.debug('Event name has changed, going to update the group name to reflect new name');
            system.debug('the name map now contains: ' + nameMap);
        } // if the event name is changed and already had a chatter group mirror, flag that the group name needs to be updated
        
        if(trigger.isInsert || (trigger.isUpdate && e.Chatter_Group_Mirror__c != null && oe.Chatter_Group_Mirror__c == null))
        {
            updateGroupInfo = true;
            idMap.put(e.Chatter_Group_Mirror_Group_Id__c,e.Id);
            system.debug('Need to add link to event in the group info section');
        } // if the event is inserted or a chatter group mirror is added, flag that the group info needs to be updated
        
        system.debug('updateGroupName: ' + updateGroupName);
        system.debug('updateGroupInfo: ' + updateGroupInfo);
        if(updateGroupName || updateGroupInfo)
        {
            theMirrorIds.add(e.Chatter_Group_Mirror__c);
            system.debug('the mirror ids: ' + theMirrorIds);
        } // if the group needs to be updated (name or info), add the group id to the list
        
        if(trigger.isUpdate && e.Event_Date__c >= system.today() && e.Suppress_Attendee_Notifications__c != true)
        {
            /*
            if(e.Status__c == 'Published' && ((e.Event_Date__c != oe.Event_Date__c) || (e.Start_Time__c != oe.Start_Time__c) || (e.End_Time__c != oe.End_Time__c) || (e.Location_Street_Address__c != oe.Location_Street_Address__c) || (e.Location_Venue__c != oe.Location_Venue__c) || (e.Associated_Cost__c != oe.Associated_Cost__c) || (e.Event_Public_Details__c != oe.Event_Public_Details__c)))
            {
                notifyAttendeesOfChange = true;
            } // if the event is published and the date, start time, street address, or venue is changed flag that attendees must be notified
			// added criteria to also flag is end time, cost, or event public details is changed
			*/
            if(e.Status__c == 'Published')
            {
                if(e.Event_Date__c != oe.Event_Date__c)
                {
                    date dt = e.Event_Date__c;
                    string formatDate = dt.format();
                    //string formatDate = dt.format('YYYY-MM-dd', 'America/New_York');
                    notifyAttendeesOfChange.put(e.Id,true);
                    if(string.isBlank(fieldFlag))
                    {
                        fieldFlag = 'Event Date: ' + formatDate;
                    }
                    else
                    {
                        fieldFlag += '\nEvent Date: ' + formatDate;
                    }
                    flagChangedFields.put(e.Id,fieldFlag);
                }
                if((e.Start_Time__c != oe.Start_Time__c) || (e.End_Time__c != oe.End_Time__c))
                {
                    notifyAttendeesOfChange.put(e.Id,true);
                    if(string.isBlank(fieldFlag) && !string.isBlank(e.Start_Time__c) && !string.isBlank(e.End_Time__c))
                    {
                        fieldFlag = 'Event Time: ' + e.Start_Time__c + ' - ' + e.End_Time__c;
                    }
                    else if(string.isBlank(fieldFlag) && !string.isBlank(e.Start_Time__c) && string.isBlank(e.End_Time__c))
                    {
                        fieldFlag = 'Start Time: ' + e.Start_Time__c;
                    }
                    else if(string.isBlank(fieldFlag) && string.isBlank(e.Start_Time__c) && !string.isBlank(e.End_Time__c))
                    {
                        fieldFlag = 'End Time: ' + e.End_Time__c;
                    }
                    else if(!string.isBlank(fieldFlag) && !string.isBlank(e.Start_Time__c) && !string.isBlank(e.End_Time__c))
                    {
                        fieldFlag += '\nEvent Time: ' + e.Start_Time__c + ' - ' + e.End_Time__c;
                    }
                    else if(!string.isBlank(fieldFlag) && !string.isBlank(e.Start_Time__c) && string.isBlank(e.End_Time__c))
                    {
                        fieldFlag += '\nStart Time: ' + e.Start_Time__c;
                    }
                    else if(!string.isBlank(fieldFlag) && string.isBlank(e.Start_Time__c) && !string.isBlank(e.End_Time__c))
                    {
                        fieldFlag += '\nEnd Time: ' + e.End_Time__c;
                    }
                    flagChangedFields.put(e.Id,fieldFlag);
                }
                if((e.Location_Venue__c != oe.Location_Venue__c) || (e.Location_Street_Address__c != oe.Location_Street_Address__c))
                {
                    notifyAttendeesOfChange.put(e.Id,true);
                    if(string.isBlank(fieldFlag))
                    {
                        fieldFlag = 'Location: ' + e.Location_Venue__c + ' - ' + e.Location_Street_Address__c + ', ' + e.Location_City__c + ', ' + e.Location_State__c + ' ' + e.Location_Zip_Code__c;
                    }
                    else
                    {
                        fieldFlag += '\nLocation: ' + e.Location_Venue__c + ' - ' + e.Location_Street_Address__c + ', ' + e.Location_City__c + ', ' + e.Location_State__c + ' ' + e.Location_Zip_Code__c;
                    }
                    flagChangedFields.put(e.Id,fieldFlag);
                }
                if(e.Associated_Cost__c != oe.Associated_Cost__c)
                {
                    notifyAttendeesOfChange.put(e.Id,true);
                    if(string.isBlank(fieldFlag) && (e.Associated_Cost__c > 0))
                    {
                        fieldFlag = 'Cost: ' + e.Associated_Cost__c;
                    }
                    else if(string.isBlank(fieldFlag) && (e.Associated_Cost__c == 0 || e.Associated_Cost__c == null))
                    {
                        fieldFlag = 'Cost: the charge for this event has been removed';
                    }
                    else if(!string.isBlank(fieldFlag) && (e.Associated_Cost__c > 0))
                    {
                        fieldFlag += '\nCost: ' + e.Associated_Cost__c;
                    }
                    else if(!string.isBlank(fieldFlag) && (e.Associated_Cost__c == 0 || e.Associated_Cost__c == null))
                    {
                        fieldFlag += '\nCost: the charge for this event has been removed';
                    }
                    flagChangedFields.put(e.Id,fieldFlag);
                }
                if((e.Event_Public_Details__c != oe.Event_Public_Details__c) && e.Event_Public_Details__c != null)
                {
                    notifyAttendeesOfChange.put(e.Id,true);
                    string aDetU = e.Event_Public_Details__c;
                    boolean tooLong = aDetU.contains('...');
                    /*string dets = e.Event_Public_Details__c;
                    //string detsRepl = dets.replace('<br>', '\n');
                    //string detsAbbr = detsRepl.abbreviate(255);
                    //string aDetU = detsAbbr.unescapeHtml3();
                    //boolean tooLong = detsAbbr.contains('...');*/
                    if(string.isBlank(fieldFlag) && tooLong)
                    {
                        fieldFlag = 'Details: ' + aDetU + ' (please refer to the event page for full details)';
                    }
                    else if(string.isBlank(fieldFlag) && !tooLong)
                    {
                        fieldFlag = 'Details: ' + aDetU;
                    }
                    else if(!string.isBlank(fieldFlag) && tooLong)
                    {
                        fieldFlag += '\nDetails: ' + aDetU + ' (please refer to the event page for full details)';
                    }
                    else if(!string.isBlank(fieldFlag) && !tooLong)
                    {
                        fieldFlag += '\nDetails: ' + aDetU;
                    }
                    flagChangedFields.put(e.Id,fieldFlag);
                }
                if((e.Event_Public_Details__c != oe.Event_Public_Details__c) && e.Event_Public_Details__c == null)
                {
                    notifyAttendeesOfChange.put(e.Id,false);
                    string aDetU = e.Event_Public_Details__c;
                    /*boolean tooLong = aDetU.contains('...');
                    //string dets = e.Event_Public_Details__c;
                    //string detsRepl = dets.replace('<br>', '\n');
                    //string detsAbbr = detsRepl.abbreviate(255);
                    //string aDetU = detsAbbr.unescapeHtml3();
                    //boolean tooLong = detsAbbr.contains('...');*/
                    if(string.isBlank(fieldFlag))
                    {
                        fieldFlag = null;
                    }
                    else if(!string.isBlank(fieldFlag))
                    {
                        fieldFlag += null;
                    }
                    flagChangedFields.put(e.Id,fieldFlag);
                }
            } // if the event is published and the date, start or end time, venue, address, cost, or details changed, flag that attendees must be notified
            else if((e.Status__c == 'Canceled' || e.Status__c == 'Flagged/Removed') && oe.Status__c == 'Published')
            {
                notifyAttendeesOfChange.put(e.Id,true);
                fieldFlag = 'This event has been published';
            } // if the event status was changed from published to canceled or flagged/removed, flag that attendees must be notified
        } // if a future event has been updated and notifications are not being suppressed
        
        /*
        if(notifyAttendeesOfChange)
        {
            changedEventIds.add(e.Id);
            system.debug('changed event ids: ' + changedEventIds);
        } // if attendees must be notified, add the event id to the set
		*/
        
        if(trigger.isUpdate && e.Suppress_Attendee_Notifications__c && !oe.Suppress_Attendee_Notifications__c)
        {
            suppressAttendeeEmails.put(e.Id,true);
        } // if email notifications have been suppressed for an event in the future
        // not needed on insert since attendees cannot be added until after insert
        // and the workflow rules check the event to see if notifications are suppressed when the attendee is created
        
        /*
        if(suppressAttendeeEmails)
        {
            suppressEventIds.add(e.Id);
            system.debug('suppress event ids: ' + suppressEventIds);
        } // if email notifications have been suppressed, add the event id to the set
		*/
    } // loop through events in trigger new
    
    if(!theMirrorIds.isEmpty())
    {
        groupsToUpdate = cov_groups_controller.findGroupsByMirrorIds(theMirrorIds);
        system.debug('groups to update: ' + groupsToUpdate);
    } // if there are groups to update, pass the list through to cov_groups_controller
    
    if(!groupsToUpdate.isEmpty())
    {
        for(CollaborationGroup cg: groupsToUpdate)
        {
            if(nameMap.containsKey(cg.Id))
            {
                cg.Name = cov_groups_controller.createUniqueGroupName(nameMap.get(cg.Id), '[Event] ');
                system.debug('new group name is: ' + cov_groups_controller.createUniqueGroupName(nameMap.get(cg.Id), '[Event]'));
            } // if the group name needs to be updated, use cov_groups_controller to create a unique group name
            if(idMap.containsKey(cg.Id))
            {
                string pathPrefix = string.isEmpty(site.getPathPrefix()) ? '' : site.getPathPrefix();
                system.debug('pathPrefix: ' + pathPrefix);
                string newInfoBody = '<a href="' + pathPrefix + '/cov_event?id=' + idMap.get(cg.Id) + '"' + ' target="_self">' + 'See event page here' + '</a>';
                if(cg.InformationBody == null)
                {
                    cg.InformationBody = newInfoBody;
                } // if the group did not previously have info
                else
                {
                    cg.InformationBody = newInfoBody + '<br/>' + cg.InformationBody;
                } // if the group did previously have info, add the new info before the old
            } // if the gorup info needs to be updated, create a new body to hold the link to the event
        } // loop through groups to update
    } // if there are groups to update
    
    if(!notifyAttendeesOfChange.keySet().isEmpty() || !suppressAttendeeEmails.keySet().isEmpty())
    {
        for(IAVAEvent_Attendee__c ea: [SELECT Id, Notify_attendee_of_changed_event__c, change_tracking_for_email__c, Suppress_Attendee_Notifications__c, Event__c FROM IAVAEvent_Attendee__c WHERE Event__c =: notifyAttendeesOfChange.keySet() OR Event__c =: suppressAttendeeEmails.keySet()])
        {
            if(notifyAttendeesOfChange.containsKey(ea.Event__c))
            {
                /*if(notifyAttendeesOfChange.get(ea.Event__c))
                {
                    ea.Notify_attendee_of_changed_event__c = true;
                    ea.change_tracking_for_email__c = flagChangedFields.get(ea.Event__c);
                    attendeesToUpdate.add(ea);
                }*/
                ea.Notify_attendee_of_changed_event__c = notifyAttendeesOfChange.get(ea.Event__c);
                ea.change_tracking_for_email__c = flagChangedFields.get(ea.Event__c);
                attendeesToUpdate.add(ea);
            } // if the attendee is on an event that was changed
            if(suppressAttendeeEmails.containsKey(ea.Event__c))
            {
                if(suppressAttendeeEmails.get(ea.Event__c))
                {
                    ea.Suppress_Attendee_Notifications__c = true;
                    attendeesToUpdate.add(ea);
                }
            } // if the attendee is on an event where notifications were suppressed
        } // loop through attendees that are children of changed events or events where emails were suppressed
    } // if there are changed events
    
    if(!groupsToUpdate.isEmpty())
    {
        system.debug('updating this list: ' + groupsToUpdate);
        try
        {
            update groupsToUpdate;
        } // try to update the groups
        catch(Exception e){} // catch any exceptions
    } // if there are groups to update
    
    if(!attendeesToUpdate.isEmpty())
    {
        system.debug('updating these attendees: ' + attendeesToUpdate);
        try
        {
            update attendeesToUpdate;
        } // try to update attendees
        catch(Exception e){} // catch any exceptions
    } // if there are attendees to notify
    
    /* end bulkified trigger */
    
    /* begin old trigger
	// Not a bulk trigger
	// Rename group when Event is renamed
	// Add link on group page to Event page
	// When event is changed

	Boolean updateGroupName = false;
	if (Trigger.isUpdate && Trigger.old[0].Name != Trigger.new[0].Name && Trigger.new[0].Chatter_Group_Mirror__c != null) {
		updateGroupName = true;
		system.debug('Event name has changed, going to update group name to reflect new name');
	}

	Boolean updateGroupInfo = false;
	if (trigger.isInsert || (Trigger.isUpdate && Trigger.old[0].Chatter_Group_Mirror__c == null && Trigger.new[0].Chatter_Group_Mirror__c != null)) {
		updateGroupInfo = true;
		system.debug('Need to add link to event in the group Info section.');
	}

	Boolean notifyAttendeesOfChange = false;
	if (trigger.isUpdate 
		&& Trigger.new[0].Event_Date__c >= System.Today()
		&& Trigger.new[0].Suppress_Attendee_Notifications__c != true
		&& Trigger.new[0].Status__c == 'Published'
		&&
			(
				//(Trigger.old[0].Status__c == 'Published' && Trigger.new[0].Status__c != 'Published')
				//|| 
				Trigger.new[0].Event_Date__c != Trigger.old[0].Event_Date__c
				|| Trigger.new[0].Start_Time__c != Trigger.old[0].Start_Time__c
				|| Trigger.new[0].Location_Street_Address__c != Trigger.old[0].Location_Street_Address__c
				|| Trigger.new[0].Location_Venue__c != Trigger.old[0].Location_Venue__c
			)
		) {
		notifyAttendeesOfChange = true;
	}


	system.debug('updateGroupInfo: ' + updateGroupInfo);
	system.debug('updateGroupName: ' + updateGroupName);
	//system.debug('Trigger.new[0].Chatter_Group_Mirror__r.Group_ID__c: ' + Trigger.new[0].Chatter_Group_Mirror__r.Group_ID__c);

	if (updateGroupInfo || updateGroupName) {
		CollaborationGroup theGroup = cov_groups_controller.findGroupByMirrorId(Trigger.new[0].Chatter_Group_Mirror__c);

		//List<CollaborationGroup> groupList = [select Id, Name, Description, InformationBody from CollaborationGroup 
		//										where Id = :Trigger.new[0].Chatter_Group_Mirror__r.Group_ID__c];
		system.debug('theGroup: ' + theGroup);

		if (theGroup != null) {
			//CollaborationGroup theGroup = groupList[0];

			if (updateGroupName) {
				theGroup.Name = cov_groups_controller.createUniqueGroupName(Trigger.new[0].Name, '[Event] ');
			}

			if (updateGroupInfo) {
				String pathPrefix = String.isEmpty(Site.getPathPrefix()) ? '' : Site.getPathPrefix();
            	system.debug('pathPrefix: ' + pathPrefix);
				String newInfoBody = '<a href="' + pathPrefix + '/cov_event?id=' + Trigger.new[0].Id + '"'
										+ ' target="_self">'
					+ 'See event page here'
					+ '</a>';
				if (theGroup.InformationBody == null) {
					theGroup.InformationBody = newInfoBody;
				} else {
					theGroup.InformationBody = newInfoBody + '<br />' + theGroup.InformationBody;
				}
			}

			try {
				system.debug('updateGroupName: ' + updateGroupName);
				system.debug('updateGroupInfo: ' + updateGroupInfo);
				system.debug('about to update theGroup: ' + theGroup);
				update theGroup;
				system.debug('ok, it should be updated now');
			} catch (Exception e) { Trigger.new[0].addError(e); }

		}
	}

	if (notifyAttendeesOfChange) {
		List<IAVAEvent_Attendee__c> attendees = [select Id, Notify_attendee_of_changed_event__c from IAVAEvent_Attendee__c where Event__c = :Trigger.new[0].Id];
		if (attendees.size() > 0) {
			for (IAVAEvent_Attendee__c a : attendees) {
				a.Notify_attendee_of_changed_event__c = true;
			}
			try {
				update attendees;
			} catch (Exception e) {}
		}
	}
	end old trigger */
} // end trigger