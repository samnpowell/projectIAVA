/*
 *
 * Check or uncheck the "AIR Complete" checkbox on any related record
 * based on whether there is an associated AIR with the Completed checkbox checked.
 *
 * Parent fields and target field name specified in custom setting AIR_Completed_Settings__c.
 *
 * SD 2012
 */

public without sharing class AIRCompleteChecker {

    public static boolean IDisvalid(String theID) {
        Id returnID;
        try {
            returnID = theID;
            System.debug('|||||||||| ID \'' + theID + '\' is valid');
            return true;
        } catch (System.StringException e) {
            System.debug('|||||||||| ID \'' + theID + '\' is not valid');
            return false;
        }
    }


    public static void CountCompleteAIRs(Id recID, String parentField, String completedField, String targetField) {
         
        String recIDstring = recID; //used to include the 15-character ID
        If (recIDstring.length() == 18) {
                recIDstring = recIDstring.left(15);
        }
        
        System.debug('|||||||||| recID: ' + recID); 
        System.debug('|||||||||| recIDstring: ' + recIDstring); 
         
        String objectName = recID.getSObjectType().getDescribe().getName();

        // Grab the record from the passed Id
        String q1 = 'select ' + targetField + ' from ' 
            + objectName 
            + ' where id = \'' + recID + '\''
            + ' or id = \'' + recIDstring + '\'';
        System.debug('|||||||||| q1: ' + q1);
        
        List<sObject> theRecords = Database.query(q1);
        System.debug('|||||||||| theRecords: ' + theRecords);

        sObject theRecord = theRecords[0];
        System.debug('|||||||||| theRecord: ' + theRecord);
        
        // Count how many AIRs are complete related to the record
        String q2 = 'select count() from AIR__c where '
            + parentField + ' in (\''+ recID + '\', \'' + recIDstring + '\')' 
            + ' and AIR__c.' + completedField + ' = true';
        System.debug('|||||||||| q2: ' + q2);

        Integer howManyComplete = Database.countquery(q2);
        System.debug('|||||||||| howManyComplete: ' + howManyComplete);

        // update the record's target field accordingly
        if (howManyComplete > 0) {
            theRecord.put(targetField, true);
        } else {
            theRecord.put(targetField, false);
        }
        update theRecord;
        
    }  
  
}