trigger cov_deleteMirrorAfterGroupDelete on CollaborationGroup (after delete) {


	Set<Id> deletedGroupIds = new Set<Id>();
	for (CollaborationGroup cg : Trigger.old) {
		deletedGroupIds.add(cg.Id);
	}

	List<Chatter_Group_Mirror__c> mirrors = [select Id from Chatter_Group_Mirror__c where Group_Id__c in :deletedGroupIds];

	if (mirrors.size() > 0) {
		delete mirrors;
	}



}