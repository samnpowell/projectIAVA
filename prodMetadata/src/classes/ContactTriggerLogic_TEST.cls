@isTest
private class ContactTriggerLogic_TEST {

    static testMethod void contactBeforeInsertTest() {
        List<Contact> contacts = createContactList(20, 'Paperwork Accepted', 'Honorable', true, false);
        
        test.startTest();
        insert contacts;
        test.stopTest();
        
        // Verify the Membership_ID value was created
        contacts = [select id,name,membership_id__c from Contact where id IN :contacts];
        for(Integer i=0;i<20;i++){
        	System.debug('i='+i + ', membership_id__c='+contacts[i].membership_id__c);
        	System.assertNotEquals(null,contacts[i].membership_id__c);
        }
    }
    
    static testMethod void contactBeforeUpdateTest() {
        List<Contact> contacts = createContactList(20);
		
		// insert the contacts
        insert contacts;
        
        // Verify the Membership_ID value was NOT created
        contacts = [select id,name,membership_id__c,paperwork_confirmation__c from Contact where id IN :contacts];
        for(Integer i=0;i<20;i++){
        	System.debug('i='+i + ', membership_id__c='+contacts[i].membership_id__c);
        	System.assertEquals(null,contacts[i].membership_id__c);
        	
        	// update the contact field now so we don't have to loop through the contacts for a 2nd time just to set the Paperwork_Confirmation__c field
        	contacts[i].Paperwork_Confirmation__c = 'Paperwork Accepted';
            contacts[i].Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND';
        }
        
        // Update the contacts        
        test.startTest();
        update contacts;
        test.stopTest();
        
        // Verify the Membership_ID value was created
        contacts = [select id,name,membership_id__c from Contact where id IN :contacts];
        for(Integer i=0;i<20;i++){
        	System.debug('i='+i + ', membership_id__c='+contacts[i].membership_id__c);
        	System.assertNotEquals(null,contacts[i].membership_id__c);
        }
    }
    
    private static List<Contact> createContactList(Integer howMany){
    	return createContactList(howMany,null,null,false,false);
    }
    
    private static List<Contact> createContactList(Integer howMany,String paperworkConfirmation, String dischargeStatus, Boolean isOEF, Boolean isOIF){
    	if(howMany==null || howMany==0)howMany=1;
 		List<Contact> contacts = new List<Contact>();
 		if(isOEF || isOIF){
 			for(Integer i=0;i<howMany;i++){
 				contacts.add(new Contact(firstname='(Unknown)',lastname=generateRandomString(10),Veteran_of_OEF__c=isOEF,Veteran_of_OIF__c=isOIF,veteran_member__c=true,paperwork_confirmation__c=paperworkConfirmation,Paperwork_Confirmation_Type__c='Deployed OEF/OIF/OND',discharge_status__c=dischargeStatus));
 			}
 		}  else {
 			for(Integer i=0;i<howMany;i++){
 				contacts.add(new Contact(firstname='(Unknown)',lastname=generateRandomString(10)));
 			}
 		} 	
 		return contacts;
    }
    
    private static String generateRandomString(Integer numChars) {
        
        //declare local vars
        String randomNumString = '';
        String returnVal = '';
        List <String> charArray = new String [] {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','0','1','2','3','4','5','6','7','8','9','-','$','#','!','@','+','=','%'};
        
        // determine how many random number strings we need 
        //System.debug('Number of requested characters: ' + numChars);
        
        // generate the requisite random number strings
        for (Integer x = 0; x < 100; x++) {
        	// generate a random number
        	String tempStr = String.valueOf(Math.random());
        	//System.debug('Generated random number string: ' + tempStr);
        	
        	// take all of the digits to the right of the decimal point
        	randomNumString += tempStr.substring(2);
        	//System.debug('Running random number string: ' + randomNumString);
        	 
        	// determine if we have enough characters
        	if (randomNumString.length() >= numChars) {
        		//System.debug('Number string has ' + randomNumString.length() + ' chars and is long enough');
        		x = 101;
        	}
        }
        // trim the string if we ran over
        if (randomNumString.length() > numChars) {
        	//System.debug('Generated string is too long.  Trimming...');
        	randomNumString = randomNumString.substring(0,numChars);
        	//System.debug('Trimming complete.  Requested Length: ' + numChars + '; Actual Length: ' + randomNumString.length());
        	//System.debug('Final Random Number String: ' + randomNumString);
        }
        
        // build the random character string
        for (Integer x = 0; x < randomNumString.length(); x++) {
        
	        // declare local vars
	        String currentNum = '';
	        String newChar = '';
	        String randomNum = String.valueOf(Math.random());
	        Integer ndxMultiplier = 0;
        
        	// get a handle on the current character
        	currentNum = randomNumString.substring(x,x+1);
        	//System.debug('Current number char is: ' + currentNum);
        	
        	// get the multiplier from the new random number string
        	for (Integer y = 2; y < randomNum.length(); y++) {
        		ndxMultiplier = Integer.valueOf(randomNum.substring(y,y+1));
        		if (ndxMultiplier < 8) {
        			newChar = charArray[ndxMultiplier * Integer.valueOf(currentNum)];
        			y = randomNum.length();
        		}
        	} 
        	returnVal += newChar; 
        }
        //System.debug('Generated Random String: ' + returnVal);
        
  		// return the random character string
        return returnVal; 
    }
    
}