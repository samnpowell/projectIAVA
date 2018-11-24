trigger ContactPolRecJunctionAfterInsert on Contact_PolRec_junction__c (after insert) {
// Developed by Richard Saunders, Exponent Partners for IAVA, 2011

	if (trigger.size == 1 && trigger.new[0].Policy_Rec__c != null && trigger.new[0].Contact__c != null)
		FocusAreaRelatedObjectsManager.createFocusToContactJunction(trigger.new[0].Policy_Rec__c, trigger.new[0].Contact__c);
}