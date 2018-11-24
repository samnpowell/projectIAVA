trigger ContactBeforeInsert on Contact (before insert) {
	ContactTriggerLogic.generateMembershipIDs(ContactTriggerLogic.kickDuplicateContacts(Trigger.new));
}