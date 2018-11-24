@isTest
private class cov_autofollow_relationships_TESTS {

	static cov_user_TEST_utility testusers;
	static Contact c1;
	static cov_user_TEST_utility testusers2;
	static Contact c2;
	static cov_user_TEST_utility testusers3;
	static Contact c3;
	static User u3;
	static npe4__Relationship__c r1;
	static npe4__Relationship__c r2;
	static List<String> s;

	static void setUpRelationships() {
       	testusers = new cov_user_TEST_utility();
		c1 = testusers.getPortalContact();
		System.debug('c1: ' + c1);

       	testusers2 = new cov_user_TEST_utility();
		c2 = testusers2.getPortalContact();
		System.debug('c2: ' + c2);

       	testusers3 = new cov_user_TEST_utility();
		c3 = testusers3.getPortalContact();
		u3 = testusers3.getPortalUser();
		System.debug('c3: ' + c3);


		r1 = new npe4__Relationship__c(
											npe4__Contact__c = c1.Id
											, npe4__RelatedContact__c = c2.Id
											, npe4__Type__c = 'Vouched for'
											, npe4__Status__c = 'Current'
											);
		r2 = new npe4__Relationship__c(
											npe4__Contact__c = c3.Id
											, npe4__RelatedContact__c = c2.Id
											, npe4__Type__c = 'Vouched for'
											, npe4__Status__c = 'Current'
											);
		insert new List<npe4__Relationship__c>{r1, r2};


		s = new List<String>();
		s.add('Vouched for');
	}

	
	@isTest static void test_autofollow_relationships() {
		
  //     	cov_user_TEST_utility testusers = new cov_user_TEST_utility();
		//Contact c1 = testusers.getPortalContact();
		////Contact c1 = cov_user_TEST_utility.getPortalContact();
		//System.debug('c1: ' + c1);

  //     	cov_user_TEST_utility testusers2 = new cov_user_TEST_utility();
		//Contact c2 = testusers2.getPortalContact();
		////Contact c2 = cov_user_TEST_utility.getInternalContact();
		//System.debug('c2: ' + c2);

  //     	cov_user_TEST_utility testusers3 = new cov_user_TEST_utility();
		//Contact c3 = testusers3.getPortalContact();
		//User u3 = testusers3.getPortalUser();
		////Contact c2 = cov_user_TEST_utility.getInternalContact();
		//System.debug('c3: ' + c3);


		//npe4__Relationship__c r1 = new npe4__Relationship__c(
		//									npe4__Contact__c = c1.Id
		//									, npe4__RelatedContact__c = c2.Id
		//									, npe4__Type__c = 'Vouched for'
		//									, npe4__Status__c = 'Current'
		//									);
		//insert r1;

		//npe4__Relationship__c r2 = new npe4__Relationship__c(
		//									npe4__Contact__c = c3.Id
		//									, npe4__RelatedContact__c = c2.Id
		//									, npe4__Type__c = 'Vouched for'
		//									, npe4__Status__c = 'Current'
		//									);
		//insert r2;


		//List<String> s = new List<String>();
		//s.add('Vouched for');

		setUpRelationships();

		cov_autofollow_relationships.followOneRelationship(c1.Id, c2.Id, s, true);
		List <EntitySubscription> follows = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid = :c1.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
		System.assertEquals(1, follows.size());

		delete follows;


		cov_autofollow_relationships.followAllRelationships(c1.Id, s, true);
		List <EntitySubscription> follows2 = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid = :c1.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
		System.assertEquals(1, follows2.size());

		delete follows2;


		cov_autofollow_relationships.followAllRelationships(c1.Id, 'Vouched for', true);
		List <EntitySubscription> follows3 = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid = :c1.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
		System.assertEquals(1, follows3.size());

		//delete follows3;

	}

	@isTest static void test_autofollow_relationships_2() {
		
		setUpRelationships();

		List<Contact> cl = new List<Contact>();
		cl.add(c1);
		cl.add(c2);
		cl.add(c3);
		cov_autofollow_relationships.followAllRelationships(cl, s, true);
		List <EntitySubscription> follows4a = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid = :c1.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
		System.assertEquals(1, follows4a.size());
		List <EntitySubscription> follows4b = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid = :c2.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
		System.assertEquals(0, follows4b.size());
		List <EntitySubscription> follows4c = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid = :c3.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
		System.assertEquals(1, follows4c.size());

		follows4a.addAll(follows4b);
		follows4a.addAll(follows4c);
		delete follows4a;

		// if a user is inactive it should not add a follow for that user
		System.runAs ( new User(Id = UserInfo.getUserId()) ) {
        // to avoid mixedDML error (http://salesforce.stackexchange.com/questions/13318/error-mixed-dml-operation-on-setup-and-non-setup-objects)
			u3.isActive = false;
			update u3;
		}
		cov_autofollow_relationships.followAllRelationships(cl, s, true);
		follows4a = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid = :c1.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
		System.assertEquals(1, follows4a.size());
		follows4b = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid = :c2.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
		System.assertEquals(0, follows4b.size());
		follows4c = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid = :c3.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
		System.assertEquals(0, follows4c.size());

	}

	@isTest static void test_autofollow_relationships_3() {



		
       	setUpRelationships();

		//follows4a.addAll(follows4b);
		//follows4a.addAll(follows4c);
		//delete follows4a;

		Test.startTest();

		List<String> sl = new List<String>();
		sl.add(c1.Id);
		cov_autofollow_relationships.followAllRelationships(sl, s, true);
		List <EntitySubscription> follows5 = [select parentId, subscriberid, networkId from EntitySubscription
				where subscriberid = :c1.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
		System.assertEquals(1, follows5.size());

		delete follows5;

		Test.stopTest();

	}


	// TODO - figure out why this was causing Too Many DML Statements error
	// seemingly triggered by adding follows
	//@isTest static void test_autofollow_relationships_4() {

	//	setUpRelationships();

	//	User u = testusers.getInternalUser();

	//	u.Everyone_follows_in_COV__c = true;
	//	update u;

	//	// Should add a follow between u and the context user.

	//	System.RunAs(u1) {

	//		cov_user_utility.self.refreshSelf();

	//		Test.startTest();

	//		List<Id> il = new List<Id>();
	//		il.add(c1.Id);
	//		cov_autofollow_relationships.followAllRelationships(il, s, true);

	//	}
	//	List <EntitySubscription> follows6 = [select parentId, subscriberid, networkId from EntitySubscription
	//			where subscriberid = :c1.Portal_User__c and parentid = :c2.Portal_User__c limit 1000];	
	//	System.assertEquals(1, follows6.size());

	//	List <EntitySubscription> follows7 = [select parentId, subscriberid, networkId from EntitySubscription
	//			where subscriberid = :c1.Portal_User__c and parentid = :u.Id limit 1000];	
	//	System.assertEquals(1, follows7.size());


	//	// get test coverage for the IDPair.equals method
	//	//cov_autofollow_relationships.IdPair ip =  new cov_autofollow_relationships.IdPair(c1.id, c2.id);
	//	//System.assertEquals(ip.equals(ip), true);
	//	//System.assertEquals(ip.equals(c1), false);

	//	Test.stopTest();


	//}
	
	
}