@isTest
private class cov_people_controller_TESTS {
	
	@isTest static void cov_people_controller_TEST() {
		
		cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getPortalUser();

		cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		User u2 = testusers2.getPortalUser();


		System.runAs(u) {
	        
	    	cov_people_controller controller = new cov_people_controller();
	    	controller.featuredPeople = controller.getPeople();

	    }


	}
	

	
}