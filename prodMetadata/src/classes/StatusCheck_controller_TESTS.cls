@isTest
private class StatusCheck_controller_TESTS {
	
	@isTest static void test_StatusCheck() {
		
		PageReference pr;
		Map<String, String> prParams;

		StatusCheck_controller controller = new StatusCheck_controller();

		// Test that no url params will just redirect to regular join page
		PageReference pageRef = Page.StatusCheck;
		Test.setCurrentPage(pageRef);	

		pr = controller.init();
		System.assert(pr.getUrl().contains('iava.org'));
		System.assertEquals('join', pr.getAnchor());
		prParams = pr.getParameters();
		system.debug('prParams: ' + prParams);
		System.assertEquals(null, prParams.get('cId'));
		System.assertEquals(null, prParams.get('st'));
		System.assertEquals(null, prParams.get('vt'));
		System.assertEquals(null, prParams.get('fm'));
		System.assertEquals(null, prParams.get('oe'));
		System.assert(prParams.get('url-msg-join').contains(EncodingUtil.urlDecode('Whoops, something went wrong', 'UTF-8')));


		// Test that incorrect contact ID will just redirect to regular join page
		Account notContact = new Account(Name='AnAccount');
		insert notContact;

		pageRef = Page.StatusCheck;
		pageRef.getParameters().put('c', notContact.Id);
		pageRef.getParameters().put('v', 'y');
		Test.setCurrentPage(pageRef);	

		pr = controller.init();
		System.assert(pr.getUrl().contains('iava.org'));
		System.assertEquals('join', pr.getAnchor());
		prParams = pr.getParameters();
		system.debug('prParams: ' + prParams);
		System.assertEquals(null, prParams.get('cId'));
		System.assertEquals(null, prParams.get('st'));
		System.assertEquals(null, prParams.get('vt'));
		System.assertEquals(null, prParams.get('fm'));
		System.assertEquals(null, prParams.get('oe'));
		System.assert(prParams.get('url-msg-join').contains(EncodingUtil.urlDecode('Whoops, something went wrong', 'UTF-8')));


		// Test that correct contact ID and v param will not redirect to join page step 2
		// if contact info is incomplete
		Contact c1 = new Contact(LastName='Succotash');
		insert c1;

		pageRef = Page.StatusCheck;
		pageRef.getParameters().put('c', c1.Id);
		pageRef.getParameters().put('v', 'y');
		Test.setCurrentPage(pageRef);	

		pr = controller.init();
		System.assert(pr.getUrl().contains('iava.org'));
		System.assertEquals('join', pr.getAnchor());
		prParams = pr.getParameters();
		system.debug('prParams: ' + prParams);
		System.assertEquals(c1.Id, prParams.get('cId'));
		System.assertEquals(null, prParams.get('st'));
		System.assertEquals('y', prParams.get('vt'));
		System.assertEquals(null, prParams.get('fm'));
		System.assertEquals(null, prParams.get('oe'));
		System.assert(prParams.get('url-msg-join').contains(EncodingUtil.urlDecode('we are missing some other basic info', 'UTF-8')));


		// Test that correct contact ID and v param will redirect to join page step 2
		c1.FirstName = 'Firsty';
		c1.Email = 'test123098@iava.org';
		update c1;

		pr = controller.init();
		System.assert(pr.getUrl().contains('iava.org'));
		System.assertEquals('join', pr.getAnchor());
		prParams = pr.getParameters();
		system.debug('prParams: ' + prParams);
		System.assertEquals(c1.Id, prParams.get('cId'));
		System.assertEquals('2', prParams.get('st'));
		System.assertEquals('y', prParams.get('vt'));
		System.assertEquals(null, prParams.get('fm'));
		System.assertEquals(null, prParams.get('oe'));
		System.assert(prParams.get('url-msg-join2').contains(EncodingUtil.urlDecode('Mind filling out the rest of this form', 'UTF-8')));


		// But wait, if lastname is "(Unknown)" it shouldnt go to step 2 after all
		c1.LastName = '(Unknown)';
		update c1;

		pr = controller.init();
		System.assert(pr.getUrl().contains('iava.org'));
		System.assertEquals('join', pr.getAnchor());
		prParams = pr.getParameters();
		system.debug('prParams: ' + prParams);
		System.assertEquals(c1.Id, prParams.get('cId'));
		System.assertEquals(null, prParams.get('st'));
		System.assertEquals('y', prParams.get('vt'));
		System.assertEquals(null, prParams.get('fm'));
		System.assertEquals(null, prParams.get('oe'));
		System.assert(prParams.get('url-msg-join').contains(EncodingUtil.urlDecode('we are missing some other basic info', 'UTF-8')));		


		// But wait, if lastname is the same as email it shouldnt go to step 2 after all
		c1.LastName = c1.Email;
		update c1;

		pr = controller.init();
		System.assert(pr.getUrl().contains('iava.org'));
		System.assertEquals('join', pr.getAnchor());
		prParams = pr.getParameters();
		system.debug('prParams: ' + prParams);
		System.assertEquals(c1.Id, prParams.get('cId'));
		System.assertEquals(null, prParams.get('st'));
		System.assertEquals('y', prParams.get('vt'));
		System.assertEquals(null, prParams.get('fm'));
		System.assertEquals(null, prParams.get('oe'));
		System.assert(prParams.get('url-msg-join').contains(EncodingUtil.urlDecode('we are missing some other basic info', 'UTF-8')));	

		// go back to regular LastName
		c1.LastName = 'Succotash';
		update c1;

		// now check that other parameters get passed through correctly
		pageRef = Page.StatusCheck;
		pageRef.getParameters().put('c', c1.Id);
		pageRef.getParameters().put('v', 'n');
		pageRef.getParameters().put('f', 'y');
		Test.setCurrentPage(pageRef);	

		pr = controller.init();
		System.assert(pr.getUrl().contains('iava.org'));
		System.assertEquals('join', pr.getAnchor());
		prParams = pr.getParameters();
		system.debug('prParams: ' + prParams);
		System.assertEquals(c1.Id, prParams.get('cId'));
		System.assertEquals('2', prParams.get('st'));
		System.assertEquals('n', prParams.get('vt'));
		System.assertEquals('y', prParams.get('fm'));
		System.assertEquals(null, prParams.get('oe'));
		System.assert(prParams.get('url-msg-join2').contains(EncodingUtil.urlDecode('Mind filling out the rest of this form', 'UTF-8')));	


		// now check that other parameters get passed through correctly
		pageRef = Page.StatusCheck;
		pageRef.getParameters().put('c', c1.Id);
		pageRef.getParameters().put('v', 'y');
		pageRef.getParameters().put('o', 'y');
		Test.setCurrentPage(pageRef);	

		pr = controller.init();
		System.assert(pr.getUrl().contains('iava.org'));
		System.assertEquals('join', pr.getAnchor());
		prParams = pr.getParameters();
		system.debug('prParams: ' + prParams);
		System.assertEquals(c1.Id, prParams.get('cId'));
		System.assertEquals('2', prParams.get('st'));
		System.assertEquals('y', prParams.get('vt'));
		System.assertEquals(null, prParams.get('fm'));
		System.assertEquals('y', prParams.get('oe'));
		System.assert(prParams.get('url-msg-join2').contains(EncodingUtil.urlDecode('Mind filling out the rest of this form', 'UTF-8')));	






	}
	
}