trigger ContactBeforeUpdate on Contact (before update) {
	ContactTriggerLogic.generateMembershipIDs(Trigger.new); 
}