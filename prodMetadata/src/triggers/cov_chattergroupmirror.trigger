trigger cov_chattergroupmirror on Chatter_Group_Mirror__c (before insert, before update) {

	if (UserInfo.getUserType() != 'Guest') { 
		// guest user doesnt seem to have permissions to query collaborationgroup so cant validate (TODO: fix if possible)
		cov_groups_controller.validateGroupMirrors(Trigger.new);
	}

}