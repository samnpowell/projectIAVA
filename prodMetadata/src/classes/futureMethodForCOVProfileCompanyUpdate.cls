public class futureMethodForCOVProfileCompanyUpdate
{
    // using a future class to avoid mixed dml error when updating user company name (community title) after contact insert/update
    @future
    public static void updateCompanyName(Set<Id> uIds)
    {
        if(!uIds.isEmpty())
        {
            List<Id> userIds = new List<Id>(); // need a list for updateUserCompanyNames method
            userIds.addAll(uIds); // add ids from the set passed through to this class to a list
            
            cov_profile_controller.updateUserCompanyNames(userIds);
        } // if we passed a set of users through from the cov_profile_updateCompany trigger
          // convert the set to a list then pass the list through to the cov profile controller
    }
}