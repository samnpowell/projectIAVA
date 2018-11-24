@isTest(SeeAllData=true)
private class ChatterAnswersCreateAccountTest {
	static testMethod void validateAccountCreation() {
		Profile[] p = [SELECT Id FROM Profile WHERE UserType = 'Standard'];
		User[] user = [SELECT Id, Firstname, Lastname FROM User WHERE IsActive = true and ProfileId =: p[0].Id];
		// We cannot create account without a user.
		if (user.size() == 0) { return; }
		String firstName = user[0].FirstName;
		String lastName = user[0].LastName;
		String userId = user[0].Id;
		String accountId = new ChatterAnswersRegistration().createAccount(firstName, lastName, userId);
		Account account = [SELECT name, ownerId from Account where Id =: accountId];
		System.assertEquals(firstName + ' ' + lastName, account.name);
		System.assertEquals(userId, account.ownerId);
	}
    
    static testMethod void testAuthProviderReg()
    {
        User thisUser = [select Id from User where Id = :UserInfo.getUserId()];
        System.runAs(thisUser)
        {
            Auth.UserData userData = new Auth.UserData('testId', 'testFirst', 'testLast', 'testFirst testLast', 'no-reply@salesforce.com', null, 'testuserlong', 'en_US', 'facebook', null, new Map<String, String>{'language' => 'en_US'});
            
            ChatterAnswersAuthProviderRegistration reg = new ChatterAnswersAuthProviderRegistration();
            
            Profile[] p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            User[] adminUser = [SELECT Id, Firstname, Lastname FROM User WHERE IsActive = true and ProfileId =: p[0].Id LIMIT 1];
            //reg.setSiteAdminUserId(adminUser[0].Id);
            Id nId = [SELECT Id FROM Network WHERE Name = 'myIAVA' LIMIT 1].Id;
            User newUser = reg.createUser(nId, userData);
            
            //System.assert(newUser != null, 'A new user should have been created');
            //System.assertEquals(newUser.Firstname, 'testFirst', 'First name should have been same');
            //System.assertEquals(newUser.Lastname, 'testLast', 'Last name should have been same');
            //System.assertEquals(newUser.Email, 'no-reply@salesforce.com', 'Email should have been same');
            /*
            Contact c = new Contact();
            c.AccountId = new ChatterAnswersRegistration().createAccount('testFirst', 'testLast', adminUser[0].Id);
            c.LastName = 'contactLast';
            insert(c);
            
            newUser.Alias = 'firstusr';
            newUser.TimeZoneSidKey = 'America/Los_Angeles';
            newUser.LocaleSidKey = 'en_US';
            newUser.EmailEncodingKey = 'UTF-8';
            newUser.LanguageLocaleKey = 'en_US';
            newUser.ContactId = c.Id;
            insert(newUser);
            
            Auth.UserData updateUserData = new Auth.UserData('testId', 'updatedFirst', 'updatedLast', 'updatedFirst updatedLast', 'no-reply@new.salesforce.com', null, 'testuserlong', 'en_US', 'facebook', null, new Map<String, String>{'language' => 'en_US'});
            
            reg.updateUser(newUser.Id, nId, updateUserData);
            
            User dbUser =  [SELECT Id, Firstname, Lastname, Email FROM User WHERE Id = :newUser.Id];
            
            System.assertEquals(dbUser.Firstname, 'updatedFirst', 'First name should have been updated');
            System.assertEquals(dbUser.Lastname, 'updatedLast', 'Last name should have been updated');
            System.assertEquals(dbUser.Email, 'no-reply@new.salesforce.com', 'Email should have been updated');*/
        }
    }
    /*static testMethod void testAuthProviderReg()
    {
        Contact c = new Contact(FirstName = 'Portal', LastName = 'User', Email = 'puser@iava.test');
        insert c;
        
        Profile[] p = [SELECT Id FROM Profile WHERE UserType = 'Standard'];
        system.debug('profile id: ' + p);
        
        User u = new User(FirstName = 'Chatter', LastName = 'Answers', Username = 'cans@iava.test', Email = 'cans@iava.test', CommunityNickname = 'cans' + System.currentTimeMillis(), UserPermissionsChatterAnswersUser = true, Alias = 'cans', TimeZoneSidKey = 'America/New_York', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', ProfileId = p[0].Id, LanguageLocaleKey = 'en_US', ContactId = c.Id);
        insert u;
        
		User[] user = [SELECT Id, Firstname, Lastname, UserPermissionsChatterAnswersUser FROM User WHERE Id =: u.Id];
		// We cannot create account without a user.
		if (user.size() == 0) { return; }
		String firstName = user[0].FirstName;
		String lastName = user[0].LastName;
		String userId = user[0].Id;
		String accountId = new ChatterAnswersRegistration().createAccount(firstName, lastName, userId);
		Account account = [SELECT name, ownerId from Account where Id =: accountId];
        Site.setPortalUserAsAuthProvider(user[0], accountId);
		System.assertEquals(firstName + ' ' + lastName, account.name);
		System.assertEquals(userId, account.ownerId);
    }*/
}