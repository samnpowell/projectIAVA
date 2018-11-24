trigger PolicyRecLegJunctionAfterInsert on PRec_Leg_junction__c (after insert) {
// Developed by Richard Saunders, Exponent Partners for IAVA, 2011

	if (trigger.size == 1 && trigger.new[0].Policy_Rec__c != null && trigger.new[0].Legislation__c != null)
		FocusAreaRelatedObjectsManager.createFocusToLegJunction(trigger.new[0].Policy_Rec__c, trigger.new[0].Legislation__c);
}