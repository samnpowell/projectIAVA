trigger PRecDCEventJunctionAfterInsert on P_Rec_DC_Event_junction__c (after insert) {
// Developed by Richard Saunders, Exponent Partners for IAVA, 2011

	if (trigger.size == 1 && trigger.new[0].Policy_Rec__c != null && trigger.new[0].DC_Event__c != null)
		FocusAreaRelatedObjectsManager.createFocusToDCEventJunction(trigger.new[0].Policy_Rec__c, trigger.new[0].DC_Event__c);
}