trigger cov_group_after on CollaborationGroup (after update, after insert) {

	// changes the name of any chatter group mirror for the group

	// also formerly tried to upload the thumbnail version of 
	// the group photo to a linked event for the group
	// but the trigger didnt run after inserting the photo via the connectapi
	// so that code is commented out below

	system.debug('in cov_group_after trigger.');

	//final String DEFAULT_PHOTO_URL_ENDING = '0F9/T';

	// when group Name is changed, change the name of 
	// any Chatter Group Mirror record for that group

		Set<Id> groupIdsWithChangedNames = new Set<Id>();
		Map<Id, String> newGroupNames = new Map<Id, String>();

		//Set<Id> groupIdsWithChangedPhotos = new Set<Id>();
		//Map<Id, String> groupToPhotoURLMap = new Map<Id, String>();
		//Map<Id, String> mirrorToPhotoURLMap = new Map<Id, String>();


		for (CollaborationGroup cg : Trigger.new) {
			if (Trigger.isUpdate && cg.Name != Trigger.oldMap.get(cg.Id).Name) {
				groupIdsWithChangedNames.add(cg.Id);
				newGroupNames.put(cg.Id, cg.Name);
			}
			//if (
			//	Trigger.isUpdate && cg.smallPhotoUrl != Trigger.oldMap.get(cg.Id).smallPhotoUrl
			//	|| 
			//	Trigger.isInsert && !cg.smallPhotoUrl.endsWith(DEFAULT_PHOTO_URL_ENDING)
			//	) {
			//		groupIdsWithChangedPhotos.add(cg.Id);
			//		groupToPhotoURLMap.put(cg.Id, cg.smallPhotoUrl);
			//}
		}

	List<Chatter_Group_Mirror__c> mirrors;

	if (Trigger.isUpdate) {

		mirrors = [select Id, Name, Group_ID__c from Chatter_Group_Mirror__c 
												where Group_Id__c in :groupIdsWithChangedNames
												];
												//or Group_Id__c in :groupIdsWithChangedPhotos

		for (Chatter_Group_Mirror__c m : mirrors) {
			//if (groupIdsWithChangedNames.contains(m.Group_ID__c)) {
				m.Name = newGroupNames.get(m.Group_ID__c);
			//}
			//if (groupIdsWithChangedPhotos.contains(m.Group_ID__c)) {
			//	mirrorToPhotoURLMap.put(m.Id, groupToPhotoURLMap.get(m.Group_ID__c));
			//}
		}

		try {
			update mirrors;
		} catch (Exception e) {}
	}

	//List<IAVAEvent__c> events = [select Id, Name, Chatter_Group_Mirror__c from IAVAEvent__c where Chatter_Group_Mirror__c in :mirrors];

	//List<Attachment> newEventThumbnails = new List<Attachment>();
	//for (IAVAEvent__c ev : events) {
	//	HttpRequest req = new HttpRequest();
 //       req.setEndpoint(mirrorToPhotoURLMap.get(ev.Chatter_Group_Mirror__c));
 //       req.setMethod('GET');
 //       Http binding = new Http();
 //       HttpResponse res = binding.send(req);
 //       Blob thumbImage = res.getBodyAsBlob();
	//	newEventThumbnails.add(new Attachment(
	//		ParentId = ev.Id
	//		, Body = thumbImage
	//		, Name = 'image-thumb'
	//		, isPrivate = false
	//		)
	//	);
	//}
	//try {
	//	insert newEventThumbnails;
	//} catch(Exception e) {
	//	system.debug('error inserting newEventThumbnails. e: ' + e);
	//}




}