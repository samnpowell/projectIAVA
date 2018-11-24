public class PipelineController {
	
	private static final String SignInMethod = 'sign_in';
	private static final String SignUpMethod = 'sign_up';
	private static final String AlgorithmName = 'hmacSHA1';
	private static final Boolean useURLEncode = true;
	
	private final String Endpoint;
	private final String APIKey;
	private final String SecretKey;
	private final String RedirectUrl;
	
	public PipelineController() {
		Pipeline_Settings__c ps = Pipeline_Settings__c.getInstance('IAVA');
		if (ps != null) {
			Endpoint = ps.End_Point__c;
			APIKey = ps.API_Key__c;
			SecretKey = ps.Secret_Key__c;
			RedirectUrl = ps.Redirect_URL__c;
		}
	}
	
	public PageReference goToPipeline() {
		PageReference pRef = null;
		
		User u = [select ContactId, Contact.Email, Contact.FirstName, Contact.LastName, Contact.Pipeline_User_ID__c, Contact.Pipeline_User_Token__c 
					from User where Id = :UserInfo.getUserId()];
		
		if (u.Contact.Pipeline_User_ID__c != null && u.Contact.Pipeline_User_Token__c != null) {
			// registered Pipeline user
			DateTime d = Datetime.now();
			// The date format is yyyy-MM-ddTHH:mm:ss.SSSZ in UTC
			String timestamp = '' + d.yearGmt() + '-' + d.monthGmt() + '-' + d.dayGmt() + 'T' + 
								d.hourGmt() + ':' + d.minuteGmt() + ':' + d.secondGmt() + '.' + d.millisecondGmt() + 'Z';
			List<String> keys = new List<String>{'timestamp', 'user_id', 'user_token'};
			List<String> vals = new List<String>{timestamp, u.Contact.Pipeline_User_ID__c, u.Contact.Pipeline_User_Token__c};
			// sign_in to Pipeline
			pRef = new PageReference(buildUrl(SignInMethod, keys, vals, true));
		} else {
			// new Pipeline user
			//String returnUrl = EncodingUtil.urlEncode(RedirectUrl + '?cid=' + u.ContactId, 'UTF-8');
			String returnUrl = RedirectUrl + '?cid=' + u.ContactId;
			List<String> keys = new List<String>{'email', 'first_name', 'last_name', 'redirect_url'};
			List<String> vals = new List<String>{u.Contact.Email, u.Contact.FirstName, u.Contact.LastName, returnUrl};
			// sign_up as Pipeline user
			pRef = new PageReference(buildUrl(SignUpMethod, keys, vals, false));
		}
		
		System.debug('>>>>>>>>>> url: ' + pRef.getUrl());
		return pRef;
	}
	
	public PageReference updateUser() {
		PageReference pRef = null;
		
		String contactId = ApexPages.currentPage().getParameters().get('cid');
		String pipelineUserId = ApexPages.currentPage().getParameters().get('user_id');
		String pipelineUserToken = ApexPages.currentPage().getParameters().get('user_token');
		
		System.debug('>>>>>>>>>> contactId: ' + contactId);
		System.debug('>>>>>>>>>> pipelineUserId: ' + pipelineUserId);
		System.debug('>>>>>>>>>> pipelineUserToken: ' + pipelineUserToken);
		
		if (contactId != null && pipelineUserId != null && pipelineUserToken != null) {
			try {
				Contact c = [select Id from Contact where Id = :contactId];
				
				//TODO: check for confirmed IAVA member with IAVA Plus portal login?
				
				// update Pipeline info if contact exists
				pipelineUserId = EncodingUtil.urlDecode(pipelineUserId, 'UTF-8');
				pipelineUserToken = EncodingUtil.urlDecode(pipelineUserToken, 'UTF-8');
				c.Pipeline_User_ID__c = pipelineUserId;
				c.Pipeline_User_Token__c = pipelineUserToken;
				update c;
				
				// redirect back to Pipeline
				DateTime d = Datetime.now();
				// The date format is yyyy-MM-ddTHH:mm:ss.SSSZ in UTC
				String timestamp = '' + d.yearGmt() + '-' + d.monthGmt() + '-' + d.dayGmt() + 'T' + 
								d.hourGmt() + ':' + d.minuteGmt() + ':' + d.secondGmt() + '.' + d.millisecondGmt() + 'Z';
				List<String> keys = new List<String>{'timestamp', 'user_id', 'user_token'};
				List<String> vals = new List<String>{timestamp, pipelineUserId, pipelineUserToken};
				pRef = new PageReference(buildUrl(SignInMethod, keys, vals, true));
				
			} catch (Exception e) {
				// do nothing
				System.debug('>>>>>>>>>> Pipeline user update failed: ' + e.getMessage());
			}
		}
		
		//System.debug('>>>>>>>>>> url: ' + pRef.getUrl());
		return pRef;
	}
	
	////////// Utility methods //////////
	
	// List of keys sorted in alphabetical order
	//	- To accommodate optional params, only add to query string if param value is not null
	private String buildUrl(String method, List<String> keys, List<String> values, Boolean addSignature) {
		
		// Build parameters string
		Integer i = 0;
		String params = '';
		for (String k : keys) {
			if (values.get(i) != null && values.get(i) != '') {
				if (useURLEncode)
					params = params + k + '=' + EncodingUtil.urlEncode(values.get(i), 'UTF-8') + '&';
				else
					params = params + k + '=' + values.get(i) + '&';
			}
			i++;
		}
		params = params.substring(0, params.length()-1);
		
		// Construct URL
		String url = Endpoint + '/' + method + '?api_key=' + APIKey + '&' + params;
		if (addSignature) {
			String signature = getSignature(url);
			url = url + '&' + 'signature=' + EncodingUtil.urlEncode(signature, 'UTF-8');
		}
		
		System.debug('>>>>>>>>>> url: ' + url);
		return url;
	}
	
	private String getSignature(String params) {
		Blob digest = Crypto.generateMac(AlgorithmName, Blob.valueOf(params), Blob.valueOf(SecretKey));
		//return EncodingUtil.convertToHex(digest);
		return EncodingUtil.base64Encode(digest);
	}
	
	////////// Tests //////////
	
	static void createSettings() {
		Pipeline_Settings__c ps = new Pipeline_Settings__c();
		ps.Name = 'IAVA';
		ps.API_Key__c = '73105c8b46cac9dd8ef37d1ecb978686eb541207';
		ps.End_Point__c = 'http://www.pipeline.com';
		ps.Redirect_URL__c = 'http://iava.expdev.cs14.force.com/rucksack/apex/PipelineUpdate';
		ps.Secret_Key__c = '7905cae4da4eea83f9b84b7d91dc6a704e12de23';
		insert ps;
	}
	
	static testMethod void testGetSignature() {
		createSettings();
		
		PipelineController controller = new PipelineController();
		
		String params = 'timestamp=2013-1-15T19%3A52%3A51.636Z&user_id=p12345678&user_token=91dc6a704e12de23';
		//System.assertEquals('9ed4395be4d4dc3b1794740d3e5ebaabba616232', controller.getSignature(params));
		System.assertEquals('ntQ5W+TU3DsXlHQNPl66q7phYjI=', controller.getSignature(params));
	}
	
	static testMethod void testBuildUrl() {
		createSettings();
		
		PipelineController controller = new PipelineController();
		
		List<String> keys = new List<String>{'email', 'first_name', 'last_name', 'redirect_url'};
		List<String> vals = new List<String>{'test@exp.com', 'test', 'new user', 'http://www.redirect.com/update?cid=a0123456789'};
		String url = controller.buildUrl(SignUpMethod, keys, vals, false);
		
		System.assertNotEquals(null, url);
		System.assert(url.startsWith(controller.Endpoint + '/' + SignUpMethod + '?api_key=73105c8b46cac9dd8ef37d1ecb978686eb541207'));
		System.assert(!url.contains('signature='));
		if (useURLEncode)
			System.assert(url.contains('&email=test%40exp.com&first_name=test&last_name=new+user&redirect_url=http%3A%2F%2Fwww.redirect.com%2Fupdate%3Fcid%3Da0123456789'));
		else
			System.assert(url.contains('&email=test@exp.com&first_name=test&last_name=new user&redirect_url=http://www.redirect.com/update?cid=a0123456789'));
		
		keys = new List<String>{'timestamp', 'user_id', 'user_token'};
		vals = new List<String>{'2013-1-15T19:52:51.636Z', 'p12345678', '91dc6a704e12de23'};
		url = controller.buildUrl(SignInMethod, keys, vals, true);
		
		System.assertNotEquals(null, url);
		System.assert(url.startsWith(controller.Endpoint + '/' + SignInMethod + '?api_key=73105c8b46cac9dd8ef37d1ecb978686eb541207'));
		System.assert(url.contains('signature='));
		if (useURLEncode)
			System.assert(url.contains('&timestamp=2013-1-15T19%3A52%3A51.636Z&user_id=p12345678&user_token=91dc6a704e12de23'));
		else
			System.assert(url.contains('&timestamp=2013-1-15T19:52:51.636Z&user_id=p12345678&user_token=91dc6a704e12de23'));
	}
	
	static testMethod void testUpdateUser() {
		createSettings();
		
		Contact cont = new Contact(FirstName = 'Test', LastName = 'Member', Email = 'test@member.org');
		insert cont;
		
		ApexPages.currentPage().getParameters().put('cid', cont.Id);
		ApexPages.currentPage().getParameters().put('user_id', 'p12345678');
		ApexPages.currentPage().getParameters().put('user_token', '91dc6a704e12de23');
		
		PipelineController controller = new PipelineController();
		
		PageReference pRef = controller.updateUser();
		
		Contact c = [select Pipeline_User_ID__c, Pipeline_User_Token__c from Contact where Id = :cont.Id];
		
		System.assertEquals('p12345678', c.Pipeline_User_ID__c);
		System.assertEquals('91dc6a704e12de23', c.Pipeline_User_Token__c);
		
		String url = pRef.getUrl();
		System.assertNotEquals(null, url);
		System.assert(url.startsWith(controller.Endpoint + '/' + SignInMethod + '?api_key=73105c8b46cac9dd8ef37d1ecb978686eb541207'));
		System.assert(url.contains('signature='));
		System.assert(url.contains('&user_id=p12345678&user_token=91dc6a704e12de23'));
		System.assert(url.contains('&timestamp='));
	}
	
	static testMethod void testGoToPipeline() {
		createSettings();
		
		Contact cont = new Contact(FirstName = 'Test', LastName = 'Member', Email = 'test@member.org');
		insert cont;
		
		// create portal user
		PortalUserProvisioning.createPortalUsers(new List<Contact> { cont });
		
		User u = [select Id from User where ContactId = :cont.Id];
		
		// new Pipeline user
		System.runAs(u) {
			PipelineController controller = new PipelineController();
			
			PageReference pRef = controller.goToPipeline();
			
			String url = pRef.getUrl();
			System.assertNotEquals(null, url);
			System.assert(url.startsWith(controller.Endpoint + '/' + SignUpMethod + '?api_key=73105c8b46cac9dd8ef37d1ecb978686eb541207'));
			System.assert(!url.contains('signature='));
			System.assert(url.contains('&email=test%40member.org&first_name=Test&last_name=Member&redirect_url=' + EncodingUtil.urlEncode(controller.RedirectUrl + '?cid=' + cont.Id, 'UTF-8')));
		}
		
		cont.Pipeline_User_ID__c = 'p12345678';
		cont.Pipeline_User_Token__c = '91dc6a704e12de23';
		update cont;
		
		// registered Pipeline user
		System.runAs(u) {
			PipelineController controller = new PipelineController();
			
			PageReference pRef = controller.goToPipeline();
			
			String url = pRef.getUrl();
			System.assertNotEquals(null, url);
			System.assert(url.startsWith(controller.Endpoint + '/' + SignInMethod + '?api_key=73105c8b46cac9dd8ef37d1ecb978686eb541207'));
			System.assert(url.contains('signature='));
			System.assert(url.contains('&user_id=p12345678&user_token=91dc6a704e12de23'));
			System.assert(url.contains('&timestamp='));
		}
	}
	
}