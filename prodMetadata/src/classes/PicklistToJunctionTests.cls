/*
 * Test of class PicklistToJunction that adds or removes junction records 
 * when you add or remove values from a multi-select picklist
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


@isTest
private class PicklistToJunctionTests {

  ////////// Tests //////////

    static testMethod void testPicklistToJunction() {
       
		Focus_Area__c fa1 = new Focus_Area__c (Name = 'Test Area 1');
    	insert fa1;

    	Focus_Area__c fa2 = new Focus_Area__c (Name = 'Test Area 2');
    	insert fa2;

    	Focus_Area__c fa3 = new Focus_Area__c (Name = 'Test Area 3');
    	insert fa3;

    	
    	Media_Request__c mr1 = new Media_Request__c(Name = 'Unit Test 1', Related_to_program__c = 'Test Area 1; Test Area 3');
    	insert mr1;
    	
    	System.assertEquals(1, [select count() from Focus_Area_Media_Request_junction__c
    		where Media_Request__c = :mr1.id and Focus_Area__c = :fa1.id]);
    	System.assertEquals(0, [select count() from Focus_Area_Media_Request_junction__c
    		where Media_Request__c = :mr1.id and Focus_Area__c = :fa2.id]);
    	System.assertEquals(1, [select count() from Focus_Area_Media_Request_junction__c
    		where Media_Request__c = :mr1.id and Focus_Area__c = :fa3.id]);
    	
		mr1.Related_to_program__c = 'Test Area 2; Test Area 3';
		update mr1;
		
    	System.assertEquals(0, [select count() from Focus_Area_Media_Request_junction__c
    		where Media_Request__c = :mr1.id and Focus_Area__c = :fa1.id]);
    	System.assertEquals(1, [select count() from Focus_Area_Media_Request_junction__c
    		where Media_Request__c = :mr1.id and Focus_Area__c = :fa2.id]);
    	System.assertEquals(1, [select count() from Focus_Area_Media_Request_junction__c
    		where Media_Request__c = :mr1.id and Focus_Area__c = :fa3.id]);
		


    }
}