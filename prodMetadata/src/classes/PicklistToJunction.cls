/*
 * Class that adds or removes junction records when you add or remove
 * values from a multi-select picklist
 *
 * Abstracted so it can be used by any two objects with junction records.
 *
 * More technically: Given a list of values (from a multi-select picklist, for example)
 * add or remove junction objects between the "home" object and the
 * target object with the same name as each value.
 *
 *
 * SD 2012
 */


public with sharing class PicklistToJunction {

	public static String[] arrayFromMulti(sObject t, String pickfield) {
		return ((String)t.get(pickField)).split(';');
	}


	public static void processJunctionRecs(sObject t, String[] theValues, String targetObject,
		String junctionObject, String junctHomeLookup, String junctTargetLookup, Boolean adder) {
      	
      	// if adder==true then add junction records for the records named in theValues[]
      	// if adder==false then delete junction records for the records named in theValues[]
      		
   		String objectName = t.getSObjectType().getDescribe().getName();
   		System.debug('|||||||||||||| objectName: ' + objectName);
	
		//String[] fieldValues = ((String)t.get(pickField)).split(';');
		For(String fieldValue : theValues) {
   		
			// Find the record with the same name on the targetObject
	   		String q2 = 'Select id from ' + targetObject + ' where '
	   			+ targetObject + '.Name = \'' + fieldValue + '\'';
	   		System.debug('|||||||||| q2: ' + q2);
	   		List<sObject> targetObjectRecords = Database.query(q2);
			if(targetObjectRecords.size() > 0) {
				System.debug('Found the ' + targetObject + ' record with Name "' + fieldValue + '"');
			
				// Check if there is already a junction record for this combo		
		   		String q3 = 'Select id from '
		   			+ junctionObject
		   			+ ' where '
		   			+ junctHomeLookup + ' = \'' + t.id
		   			+ '\' and ' + junctTargetLookup
		   			+ ' = \'' + targetObjectRecords[0].id + '\''; 
				System.debug('|||||||||| q3: ' + q3);
				List<sObject> existingJunctRecords = Database.query(q3);
				if ((existingJunctRecords.size() == 0) && adder==true) {
					System.debug('No existing junction record, need to create one.');
					System.debug('Adding junction record for ' + fieldValue);
	                sObject sObj = Schema.getGlobalDescribe().get(junctionObject).newSObject() ;  
	                sObj.put(junctHomeLookup , t.id);  
	                sObj.put(junctTargetLookup , targetObjectRecords[0].id); 
	                insert sObj ; 
				} else if ((existingJunctRecords.size() > 0) && adder==false) {
					System.debug('There are junction record(s) to delete');
					for(sObject junctionRec : existingJunctRecords ) {
						System.debug('Deleting junction record for ' + fieldValue);
						delete junctionRec;
					}
				}
	
			} else {
 				System.debug('Couldnt find a + ' + targetObject + ' record with Name "' + fieldValue +'"');
			}
	   		
	   		
		} //for
   
	}
		
	
	public static void updatePicklistToJunction(sObject t_new, sObject t_old, String pickField, String targetObject,
		String junctionObject, String junctHomeLookup, String junctTargetLookup) {
		
		String newValues = (String)t_new.get(pickField);
		String[] fieldValues_new = new String[]{};
		if(newValues != null && newValues.length() > 0)
			fieldValues_new = newValues.split(';');
		String oldValues = (String)t_old.get(pickField);
		String[] recordsToAdd = new String[]{};
		String[] recordsToRemove = new String[]{};
		if(oldValues != null && oldValues.length() > 0)
			recordsToRemove = oldValues.split(';');
		for (String fieldValue_new : fieldValues_new) {
			System.debug('Now looking at ' + fieldValue_new);
			if (oldValues != null && oldValues.contains(fieldValue_new)) {
				Integer i=-1;
				do {
					i++;
					System.debug('recordsToRemove.size()=' + recordsToRemove.size() + ' and i=' + i);
					if (recordsToRemove[i] == fieldValue_new) {
						System.debug('The value ' + fieldValue_new + ' was in both old and new.');
						recordsToRemove.remove(i);
						if(i>0) i=i-1; // to compensate for having removed an item
					}
				} while ((recordsToRemove.size() > 0) && (recordsToRemove[i] != fieldValue_new) && (i < recordsToRemove.size()-1));
			} else {
				System.debug('The value ' + fieldValue_new + ' was in new but not old.');
				recordsToAdd.add(fieldValue_new);
			}
		}
		//call add for recordsToAdd
		System.debug('Junction records to add: ' + recordsToAdd);
		if (recordsToAdd.size() > 0)
			PicklistToJunction.processJunctionRecs(t_new, recordsToAdd, targetObject, junctionObject, junctHomeLookup, junctTargetLookup, true);
		//call nix for recordsToRemove
		System.debug('Junction records to delete: ' + recordsToRemove);
		if (recordsToRemove.size() > 0)
			PicklistToJunction.processJunctionRecs(t_new, recordsToRemove, targetObject, junctionObject, junctHomeLookup, junctTargetLookup, false);
	}
	

}