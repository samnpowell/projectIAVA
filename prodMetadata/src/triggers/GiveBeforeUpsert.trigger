trigger GiveBeforeUpsert on Give__c bulk (before insert, before update) {
	
	List<Give__c> notifiableGives = new List<Give__c>();
	for(Give__c theGive: Trigger.new){
		if(theGive.Send_Notifications__c){
			notifiableGives.add(theGive);
		}
	}
	RewardUtilities.CheckGive(notifiableGives);
}