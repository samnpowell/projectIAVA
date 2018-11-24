/*
 * Controller for Member Settings page
 *	1) Easy button that increments the IAVA Rewards Setting object's Last Member ID field
 *
 * WH, Exponent Partners, 2012
 */
public class MemberSettingsController {
	
	public final static String CUSTOM_SETTINGS_NAME = 'Main';
	
	public IAVA_Rewards_Settings__c settings { get; private set; }
	
	public MemberSettingsController() {
		try {
			settings = [select Name, Last_Member_ID__c from IAVA_Rewards_Settings__c where Name =:CUSTOM_SETTINGS_NAME limit 1];
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error retrieving IAVA Rewards Settings.'));
			System.debug('>>>>>>>>>> Error retrieving IAVA Rewards Settings: ' + e.getMessage());
		}
	}
	
	public PageReference incrementMemberId() {
		try {
			settings = [select Name, Last_Member_ID__c from IAVA_Rewards_Settings__c where Name =:CUSTOM_SETTINGS_NAME limit 1];
			settings.Last_Member_ID__c = String.valueOf(Integer.valueOf(settings.Last_Member_ID__c) + 1);
			update settings;
		} catch (Exception e) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error incrementing Last Member ID in IAVA Rewards Settings.'));
			System.debug('>>>>>>>>>> Error incrementing Last Member ID in IAVA Rewards Settings: ' + e.getMessage());
		}
		return null;
	}
	
	////////// Tests //////////
	
	static void setupSettings() {
		IAVA_Rewards_Settings__c settings = new IAVA_Rewards_Settings__c(Name = CUSTOM_SETTINGS_NAME, Last_Member_ID__c = '11111');
		insert settings;
	}
	
	static testMethod void testMemberSettingsController() {
		setupSettings();
		MemberSettingsController controller = new MemberSettingsController();
		System.assertNotEquals(null, controller.settings);
	}
	
	static testMethod void testIncrementMemberId() {
		setupSettings();
		MemberSettingsController controller = new MemberSettingsController();
		Integer oldMemberNumber = Integer.valueOf(controller.settings.Last_Member_ID__c);
		controller.incrementMemberId();
		System.assertEquals(oldMemberNumber + 1, Integer.valueOf(controller.settings.Last_Member_ID__c));
	}
	
}