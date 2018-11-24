public without sharing class iava_counts_controller {

	/*
		// Diplays website counts on iava_counts.page
		// so website can be updated with latest numbers

		// TODO: Could put queries into a custom setting so could be altered without code
		// TODO: Somehow prevent it being run too many times?

	*/

	public Integer veteran_count {get; set;}
	public Integer supporter_count {get; set;}

	public iava_counts_controller() {
		
		veteran_count = [
						SELECT COUNT()
						FROM Contact
						WHERE 
							Veteran_Member_Status__c in ('Confirmed', 'Unconfirmed')
						];

		supporter_count = [
						SELECT COUNT()
						FROM Contact
						WHERE 
							Contact_Primary_Mailing_List__c = 'Supporter'
						];

	}
}