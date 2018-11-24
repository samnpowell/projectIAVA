/*
 * Trigger that adds or removes junction records when you add or remove
 * values from a multi-select picklist
 *
 * Abstracted so it can be used by any two objects with junction records.
 * Works with the PicklistToJunction class.
 *
 * Can be copied to other objects -- just change the variables in the top section.
 *
 *
 * SD 2012
 */



trigger PicklistToJunction_AIR on AIR__c (after insert, after update, after undelete) {


	// ***** CUSTOMIZE THESE VALUES WHEN YOU COPY THE TRIGGER TO OTHER OBJECTS *****

	public static String pickField = 'Related_Focus_Areas__c'; // name of multi-select field on this object
	public static String targetObject = 'Focus_Area__c'; // target object name
	public static String junctionObject = 'Focus_Area_related_to_AIR__c'; // junction object name
	public static String junctHomeLookup = 'AIR__c'; // lookup field on the junction object to this object
	public static String junctTargetLookup = 'Focus_Area__c'; // lookup field on the junction object to the target object
	
	

			if (Trigger.isInsert || Trigger.isUndelete) {
				for(sObject t_new: Trigger.new){
					if (t_new.get(pickField) != NULL)  {
						PicklistToJunction.processJunctionRecs(t_new, PicklistToJunction.arrayFromMulti(t_new, pickField), targetObject, junctionObject, junctHomeLookup, junctTargetLookup, true);
					}
				}
			}
			
			if (Trigger.isUpdate) {
				for(sObject t_new: Trigger.new){
					sObject t_old = Trigger.oldMap.get(t_new.ID);
					if (t_new.get(pickField) != t_old.get(pickField))  {
						PicklistToJunction.updatePicklistToJunction(t_new, t_old, pickField, targetObject, junctionObject, junctHomeLookup, junctTargetLookup);
					}
				}
			}

}