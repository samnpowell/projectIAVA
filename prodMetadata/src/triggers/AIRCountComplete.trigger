/*
 *
 * Check or uncheck the "AIR Complete" checkbox on the parent records
 * based on whether there is an associated AIR with the Completed checkbox checked.
 *
 * Parent fields and completed checkbox fieldname specified in Custom Setting AIR_Completed_Settings__c.
 *
 * SD 2012
 */



trigger AIRCountComplete on AIR__c (after delete, after insert, after update) {

	List<AIR_Completed_Settings__c> theSettings = AIR_Completed_Settings__c.getAll().values();
	
	private static final String completedField = 'Completed__c'; // the field on the AIR that indicates it's complete
	private static String targetField = 'AIR_Completed__c'; // default fieldname on each parent object to be checked

// *Deprecated section from before used custom settings*
// Below is the list of parent lookup fields on the AIR record.
// private static final String[] parentFields = new String[]{'Activity_ID__c', 'Campaign__c', 'Give__c', 'DC_Event__c', 'Track_a_Call__c'};
//	for (String theField : parentFields) {
	for (AIR_Completed_Settings__c theSetting : theSettings) {
		System.debug('|||||||||||||| theSetting: ' + theSetting);

		String theField = theSetting.Field_API_Name__c;
		if(theSetting.AIR_Completed_field__c != null)
			targetField = theSetting.AIR_Completed_field__c;
			
		if(theSetting.Active__c){
		
			System.debug('Now looking at ' + theField );
			
			if (Trigger.isInsert) {
				for(AIR__c a_new: Trigger.new){
					// If AIR's completed=true AND AIR's parent field is not blank then run the count on the parent        
					if (a_new.get(theField) != NULL && a_new.get(completedField) == true)  {
						if (AIRCompleteChecker.IDisvalid((String)a_new.get(theField)))          
							AIRCompleteChecker.CountCompleteAIRs((Id)a_new.get(theField), theField, completedField, targetField);
						else
							a_new.addError('The value in ' + theField + ' does not appear to be a valid ID.');
					}
				}
			}
		
		    if (Trigger.isDelete) {  
		    	for(AIR__c a_old: Trigger.old){
			        // If the former AIR had parent field not blank and Completed was true then run the count on old parent
			        if (a_old.get(theField) != NULL && a_old.get(completedField) == true)            
						if (AIRCompleteChecker.IDisvalid((String)a_old.get(theField)))          
							AIRCompleteChecker.CountCompleteAIRs((Id)a_old.get(theField), theField, completedField, targetField);
						else
							System.debug('The value in ' + theField + '  not valid -- skipping.');
		      	}  
		  
		    }
		   
		    if (Trigger.isUpdate) {  
		       for(AIR__c a_new : Trigger.new) {
		           AIR__c a_old = Trigger.oldMap.get(a_new.ID);    
		   			
		   		   // if the old and new parents are different, run count on both parents
		           if (a_old.get(theField) != NULL && a_new.get(theField) != NULL) { 
		               if ((a_old.get(theField) != a_new.get(theField)) || (a_old.get(completedField) != a_new.get(completedField)) ) {           
							if (AIRCompleteChecker.IDisvalid((String)a_old.get(theField)))          
								AIRCompleteChecker.CountCompleteAIRs((Id)a_old.get(theField), theField, completedField, targetField);
							else
								System.debug('The value in ' + theField + '  not valid -- skipping.');
							if (AIRCompleteChecker.IDisvalid((String)a_new.get(theField)))          
								AIRCompleteChecker.CountCompleteAIRs((Id)a_new.get(theField), theField, completedField, targetField);
							else
								a_new.addError('The value in ' + theField + ' does not appear to be a valid ID.');
		               }
		           }
		           else if (a_old.get(theField) != NULL) {
							if (AIRCompleteChecker.IDisvalid((String)a_old.get(theField)))          
								AIRCompleteChecker.CountCompleteAIRs((Id)a_old.get(theField), theField, completedField, targetField);
							else
								System.debug('The value in ' + theField + '  not valid -- skipping.');
		           }
		           else if (a_new.get(theField) != NULL) {
							if (AIRCompleteChecker.IDisvalid((String)a_new.get(theField)))          
								AIRCompleteChecker.CountCompleteAIRs((Id)a_new.get(theField), theField, completedField, targetField);
							else
								a_new.addError('The value in ' + theField + ' does not appear to be a valid ID.');	           } 
		           
		        }
		   
		    }
		} //if

	} //for
}