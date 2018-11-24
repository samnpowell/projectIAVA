trigger cov_createGroupFromEvent on IAVAEvent__c (before insert, before update, after delete) {


	// Not a bulk trigger, too damn complicated at the moment


	if (
			(Trigger.isInsert || 
				(Trigger.isUpdate && (
									Trigger.old[0].Dont_create_Chatter_Group__c 
									||
									Trigger.old[0].Status__c != 'Published' && Trigger.new[0].Status__c == 'Published'
									)
				)
			) 
			&&
			!Trigger.new[0].Dont_create_Chatter_Group__c
			&& Trigger.new[0].Chatter_Group_Mirror__c == null
		) {


			String groupName = cov_groups_controller.createUniqueGroupName(Trigger.new[0].Name, '[Event] ');


			Id theNetworkId;
			If (Test.isRunningTest()) {
				theNetworkId = cov_user_utility.self.getNetworkId();
			} else {
				try {
					theNetworkId = [select Id from Network where name like '%Community%' or Name like '%COV%' or Name like '%myIAVA%' limit 1].Id;
				} catch (Exception e) {}
			}

			CollaborationGroup eventGroup = new CollaborationGroup(
				Name = groupName
				//, CollaborationType = 'Private'
				//, CollaborationType = 'Public'
				, CollaborationType = 'Unlisted'
				, Description = 'Group for Event: ' + Trigger.new[0].Name
				//, InformationBody = '<a href="https://cov.force.com/iava/cov_event?id=' + Trigger.new[0].Id + '">See event details here</a>' 
				//, IsAutoArchiveDisabled = false
				, NetworkId = theNetworkId
				, OwnerId = Trigger.new[0].OwnerId
			);
			system.debug('about to insert eventGroup: ' + eventGroup);
			try {
				insert eventGroup;
				system.debug('inserted eventGroup. eventGroup.Id: ' + eventGroup.Id);
				// else {
				//	return null;
				//}
			} catch (Exception e) { 
				//cov_log_error.logError(e); 
				//return null;
			}
			if (eventGroup.Id != null) {
				try {
					CollaborationGroupMember cgm = [select Id, NotificationFrequency from CollaborationGroupMember 
														where CollaborationGroupId = :eventGroup.Id
														and MemberId = :UserInfo.getUserId()
														limit 1
														];
					cgm.NotificationFrequency = 'P';
					update cgm;
					} catch (Exception e) {}

				Chatter_Group_Mirror__c newCgm = cov_groups_controller.createMirrorFromGroup(eventGroup, 'Event');
				system.debug('newCgm: ' + newCgm);
				if (newCgm != null) {
					Trigger.new[0].Chatter_Group_Mirror__c = newCgm.Id;
					system.debug('About to add Group Mirror ID (' + newCgm.Id + ') to the Event: ' + Trigger.new[0]);
					// it's a before insert/update so no need to update the record
					//try {
					//	update Trigger.new[0];
					//	system.debug('Event updated with group mirror ID');
					//} catch (Exception e) { 
					//	system.debug('Event not updated with group mirror ID. Exception: ' + e);
					//	//cov_log_error.logError(e); 
					//}
				}
			}


		}
		// else {
		//	return theEvent.Chatter_Group_Mirror__c;
		//}

		// if deleting the Event, delete the Group and the Mirror
		else if (Trigger.isDelete && Trigger.old[0].Chatter_Group_Mirror__c != null) {
			CollaborationGroup cg = cov_groups_controller.findGroupByMirrorId(Trigger.old[0].Chatter_Group_Mirror__c);
			if (cg != null) {
				try {
					delete cg;
				} catch (Exception e) { 
					//cov_log_error.logError(e); 
				}
			}
		}





}