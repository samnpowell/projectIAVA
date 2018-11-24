@isTest
private class cov_monitor_controller_TESTS {
	

	static testMethod void cov_monitor_controller_Test() {


       	cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		User u = testusers.getInternalUser();

		System.RunAs(u) {

			cov_monitor_controller controller = new cov_monitor_controller();

		}

	}


	
}