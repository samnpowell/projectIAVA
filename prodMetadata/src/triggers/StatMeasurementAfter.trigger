trigger StatMeasurementAfter on Stat_Measurement__c (after delete, after insert, after update) {
// Developed by Richard Saunders, Exponent Partners, for IAVA 2011
// Trigger to keep the Stat.Most_Recent_Amount__c field up to date based on the date of related Stat_Mearsurement__c records


	if (trigger.size == 1) {
		
		system.debug('TESTING>>> StatMeasurementAfter trigger.new: '+trigger.new);
		
		StatAction.SetMeasurementAmount((trigger.isDelete) ? trigger.old[0].Stat__c : trigger.new[0].Stat__c);
		
	}
}