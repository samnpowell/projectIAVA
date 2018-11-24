trigger cov_profile_updateCompany on Contact (after insert, after update)
{
    // using company name field on user to display service details for community members
    // this trigger calls the cov_profile_controller updateUserCompanyName method in order to pass details from the contact to the corresponding user
    // had been Replaced with process builder process to update Company Name when the Community Title Formula on contact is changed
    // reactivating because process builder was throwing errors. added intermediary future method to prevent mixed dml errors
    // also did my best to comment sam's code
    
    set<id> UserIDs = new set<id>(); // set (because it ensures unique values) of user ids to pass through to cov_profile_controller updateUserCompanyNames method
    
    for(Contact c: trigger.new)
    {
        Contact c_old = new Contact();
        if(trigger.isUpdate)
        {
            c_old = trigger.oldMap.get(c.ID);
        } // if the contact was updated, pull the old values for comparison
        if(
            (trigger.isInsert && c.Portal_User__c != null &&
             (c.Veteran_Member__c || c.Veteran_of_OEF__c || c.Veteran_of_OIF__c || c.Veteran_of_OND__c)
            ) ||
            (trigger.isUpdate && c.Portal_User__c != null &&
             (c.Veteran_Member__c <> c_old.Veteran_Member__c || c.Veteran_of_OEF__c <> c_old.Veteran_of_OEF__c || c.Veteran_of_OIF__c <> c_old.Veteran_of_OIF__c || c.Veteran_of_OND__c <> c_old.Veteran_of_OND__c || c.Branch_of_Service__c <> c_old.Branch_of_Service__c)
            ) ||
            (trigger.isUpdate && c.Portal_User__c != null && (c.Paperwork_Confirmation__c <> c_old.Paperwork_Confirmation__c))
        )
        {
            UserIds.add(c.Portal_User__c);
        } // if there is a portal user and either the contact is new or the veteran member/oif/oef/ond/branch are changed, add the user ids to the list of users to update
    } // loop through contacts in trigger new
    
    if(!UserIds.isEmpty())
    {
        futureMethodForCOVProfileCompanyUpdate.updateCompanyName(UserIds);
    } // if users were added to this set, pass through to update the user company name (community title)
}

// keeping the old trigger for posterity
/*		list<id> UserIDs = new list<id>();


//		for(Contact c :trigger.new){
//			Contact c_old = new Contact();
//			if (Trigger.isUpdate){
//				c_old = Trigger.oldMap.get(c.ID);
//			}
//			if (
//					(Trigger.isInsert && c.Portal_User__c != null &&
//						(c.Veteran_Member__c != null
//						|| 
//						c.Veteran_of_OEF__c != null
//						|| 
//						c.Veteran_of_OIF__c != null
//						|| 
//						c.Veteran_of_OND__c != null
//						)
//					)
			
//				|| 
//					(Trigger.isUpdate && c.Portal_User__c != null && 
//						(c.Veteran_Member__c <> c_old.Veteran_Member__c
//						|| 
//						c.Veteran_of_OEF__c <> c_old.Veteran_of_OEF__c
//						|| 
//						c.Veteran_of_OIF__c <> c_old.Veteran_of_OIF__c
//						|| 
//						c.Veteran_of_OND__c <> c_old.Veteran_of_OND__c
//						|| 
//						c.Branch_of_Service__c <> c_old.Branch_of_Service__c
//						)
//					)
//				) {
//					UserIds.add(c.Portal_User__c);
//			}
							
//		}

//		if (UserIds.size() > 0) {
//			cov_profile_controller.updateUserCompanyNames(UserIds);
//		}
		

}*/