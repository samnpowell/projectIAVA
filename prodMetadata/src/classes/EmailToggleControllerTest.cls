/**
 * Created by tarren.anderson on 8/23/17.
 */
//TODO : Improve tests - these were created very quickly as a demo.
@IsTest
private class EmailToggleControllerTest {
	private static User u;
	static{
		Account ac = new Account(name ='TestAccount') ;
		insert ac;

		Contact con = new Contact(LastName ='TestContact', AccountId = ac.Id);
		insert con;

		Profile p = [SELECT Id FROM Profile WHERE UserType = 'CSPLitePortal' limit 1];

		u = new User(alias = 'user123', email='testuser123@example.com',
				emailencodingkey='UTF-8', lastname='testuser', languagelocalekey='en_US',
				localesidkey='en_US', profileid = p.Id, country='United States',IsActive =true,
				ContactId = con.Id,
				timezonesidkey='America/Los_Angeles', username='tester@noemail.com');

		insert u;
	}

	private static testMethod void testGetEmailState(){
		system.runAs(u) {
			EmailToggleController.ToggleResponse tr = EmailToggleController.getEmailState();
			System.assertEquals(true, tr.success);
		}
	}

	private static testMethod void testToggleEmail(){
		system.runAs(u) {
			EmailToggleController.ToggleResponse tr = EmailToggleController.toggleEmail();
			System.assertEquals(false, tr.success);
		}
	}
}