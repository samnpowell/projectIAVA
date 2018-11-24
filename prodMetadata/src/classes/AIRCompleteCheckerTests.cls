/*
 *
 * Tests for AIRCountComplete trigger and AIRCompleteChecker class.
 *
 * SD 2012
 */
 
 @isTest
private class AIRCompleteCheckerTests {

  ////////// Tests //////////
  
  static testMethod void testAIRCompleteChecker() {

    Campaign c = new Campaign(Name = 'Unit Test Campaign');
    insert c;

    Campaign c2 = new Campaign(Name = 'Unit Test Campaign 2');
    insert c2;
    
    Partnership_Request__c p = new Partnership_Request__c(Name = 'Unit Test Partnership', Public_Partner_Name__c = 'Unit Test Partner Name');
    insert p;

    Give__c g = new Give__c(Name = 'Unit Test Give', Zip_Code_s__c = '10012', Partnership_Request__c = p.id);
    insert g;
    
    AIR_Completed_Settings__c s_g = new AIR_Completed_Settings__c(Name='Give', Active__c=true, Field_API_Name__c='Give__c');
    insert s_g;
    AIR_Completed_Settings__c s_c = new AIR_Completed_Settings__c(Name='Campaign', Active__c=true, Field_API_Name__c='Campaign__c');
    insert s_c;
    AIR_Completed_Settings__c s_a = new AIR_Completed_Settings__c(Name='Activity', Active__c=true, Field_API_Name__c='Activity_ID__c');
    insert s_a;
    
    AIR__c air1 = new AIR__c (Name = 'Unit Test AIR 1', Completed__c = false, Give__c = g.id);
    insert air1;
    System.assertEquals(false, [select AIR_Completed__c from Give__c where id = :g.id].AIR_Completed__c);
    
    AIR__c air2 = new AIR__c (Name = 'Unit Test AIR 2', Completed__c = true, Give__c = g.id);
    insert air2;
    System.assertEquals(true, [select AIR_Completed__c from Give__c where id = :g.id].AIR_Completed__c);

    System.assertEquals(false, [select AIR_Completed__c from Campaign where id = :c.id].AIR_Completed__c);
    air2.Campaign__c = c.id;
    update air2;
    System.assertEquals(true, [select AIR_Completed__c from Campaign where id = :c.id].AIR_Completed__c);

    System.assertEquals(false, [select AIR_Completed__c from Campaign where id = :c2.id].AIR_Completed__c);
    air1.Campaign__c = c2.id;
    update air1;
    System.assertEquals(false, [select AIR_Completed__c from Campaign where id = :c2.id].AIR_Completed__c);

    air1.Completed__c = true;
    update air1;
    System.assertEquals(true, [select AIR_Completed__c from Campaign where id = :c2.id].AIR_Completed__c);

    air1.Campaign__c = c.id;
    update air1;
    System.assertEquals(false, [select AIR_Completed__c from Campaign where id = :c2.id].AIR_Completed__c);

    air1.Give__c = NULL;
    update air1;
    System.assertEquals(true, [select AIR_Completed__c from Give__c where id = :g.id].AIR_Completed__c);

    air2.Give__c = NULL;
    update air2;
    System.assertEquals(false, [select AIR_Completed__c from Give__c where id = :g.id].AIR_Completed__c);


    delete air1;
    System.assertEquals(true, [select AIR_Completed__c from Campaign where id = :c.id].AIR_Completed__c);

    delete air2;
    System.assertEquals(false, [select AIR_Completed__c from Campaign where id = :c.id].AIR_Completed__c);
 
 	// Now test the Activity_ID__c field which is a Text instead of a Lookup
 
    Task t = new Task(OwnerId = UserInfo.getUserId());
    insert t;

    AIR__c air3 = new AIR__c (Name = 'Unit Test AIR 3', Completed__c = true, Activity_ID__c = (String)t.Id);
    insert air3;
    System.assertEquals(true, [select AIR_Completed__c from Task where id = :t.id].AIR_Completed__c);   

	air3.Completed__c = false;
	update air3;
    System.assertEquals(false, [select AIR_Completed__c from Task where id = :t.id].AIR_Completed__c);   

	air3.Activity_ID__c = 'test non-ID string';	
	try {
            update air3;
        } catch (DmlException e) {
            //Assert Error Message 
            System.assert( e.getMessage().contains('The value in Activity_ID__c' + 
            	' does not appear to be a valid ID.'), 
                e.getMessage() );
        } //catch 	

    AIR__c air4 = new AIR__c (Name = 'Unit Test AIR 4', Completed__c = true, Activity_ID__c = (String)t.Id);
    insert air4;
    System.assertEquals(true, [select AIR_Completed__c from Task where id = :t.id].AIR_Completed__c);   

	delete air4;
    System.assertEquals(false, [select AIR_Completed__c from Task where id = :t.id].AIR_Completed__c);   

  }
  
}