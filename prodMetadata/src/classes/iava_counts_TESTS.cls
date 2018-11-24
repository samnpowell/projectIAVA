@isTest
private class iava_counts_TESTS {
	
	@isTest static void test_counts() {
		iava_counts_controller controller = new iava_counts_controller();
		system.assertEquals(controller.veteran_count, [SELECT COUNT() FROM Contact WHERE Veteran_Member_Status__c in ('Confirmed', 'Unconfirmed')]);
		system.assertEquals(controller.supporter_count, [SELECT COUNT() FROM Contact WHERE Contact_Primary_Mailing_List__c = 'Supporter']);
	}
		
}