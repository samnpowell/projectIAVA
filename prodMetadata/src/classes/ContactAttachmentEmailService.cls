/*
 * Email service to accept paperwork attached in incoming email from a member.
 *
 * 1) Match existing Contact using the fromAddress in the incoming email
 *		No action if no existing Contact is matched
 * 2) Get binary document attached in the incoming email and insert it as an attachment to the matched Contact
 *		No action if incoming email has no binary attachment
 *		Email attachment below a minimum size is ignored
 * 3) Update Paperwork Confirmation status of the matched Contact to 'Paperwork Received'
 *		No update if status is already 'Paperwork Received', 'Paperwork Accepted', or 'Paperwork Rejected'
 *
 * WH, Exponent Partners, 2011
 */
global class ContactAttachmentEmailService implements Messaging.InboundEmailHandler {
	
	private static Integer MinFileSize = 20000;

	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
		
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		result.success = false;		// if exits early
		
		String fromEmailAddress = email.fromAddress;
		
		if (fromEmailAddress != null && fromEmailAddress != '' && email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
			
			// match Contact record by email
			List<Contact> conts = [select Paperwork_Confirmation__c, Veteran_Member__c from Contact 
									where Email = :fromEmailAddress or 
										npe01__WorkEmail__c = :fromEmailAddress or 
										npe01__HomeEmail__c = :fromEmailAddress or 
										npe01__AlternateEmail__c = :fromEmailAddress];
			
			// matched contact found
			if (conts.size() > 0) {
				
				Contact c;
				// favor contact with Veteran_Member__c == true if there are multiple contacts matching incoming email address
				if (conts.size() > 1) {
					for (Contact ct : conts) {
						if (ct.Veteran_Member__c) {
							c = ct;
							break;
						}
					}
				}
				// otherwise, take the first matched contact
				if (c == null) c = conts[0];
					
				// get minimum attachment file size from custom settings
				if (!Test.isRunningTest()) {	// allow custom settings to be overridden in unit tests
					Contact_Attachment_Email_Service__c caes = Contact_Attachment_Email_Service__c.getInstance('IAVA');
					if (caes != null && caes.Minimum_Attachment_Size__c != null) {
						MinFileSize = caes.Minimum_Attachment_Size__c.intValue();
					}
				}
				
				// set Attachment.Description with email subject and body
				Integer descLength = Attachment.Description.getDescribe().getLength();
				String description = 'Subject: ' + (email.subject != null ? email.subject : '') + 
									'\n\n' + 
									'Body:\n' + (email.plainTextBody != null ? email.plainTextBody : (email.htmlBody != null ? email.htmlBody : ''));
				description = (description.length() > descLength) ? description.substring(0, descLength) : description;
				
				// create attachment for each non-empty document attached in the incoming email
				List<Attachment> attachmentsToInsert = new List<Attachment>();
				for (Messaging.InboundEmail.BinaryAttachment ba : email.binaryAttachments) {
					//System.debug('>>>>>>>>>> Attachment file size: ' + ba.body.size());
					if (ba.body != null && ba.body.size() > MinFileSize) {
						Attachment attachment = new Attachment(ParentId = c.Id, Body = ba.body, Name = ba.fileName, Description = description);
						attachmentsToInsert.add(attachment);
					}
				}
				
				if (!attachmentsToInsert.isEmpty()) {
					
					try {
						// attach paerwork file(s) to Contact record
						insert attachmentsToInsert;
					} catch (DMLException de) {
						System.debug('Insert Attachment failed: ' + de.getMessage());
						return result;
					}
					
					try {
						// update Paperwork Confirmation field on Contact if needed
						if (c.Paperwork_Confirmation__c != 'Paperwork Received' && c.Paperwork_Confirmation__c != 'Paperwork Accepted' && c.Paperwork_Confirmation__c != 'Paperwork Rejected') {
							c.Paperwork_Confirmation__c = 'Paperwork Received';
							update c;
						}
					} catch (DMLException de) {
						System.debug('Update Contact failed: ' + de.getMessage());
						return result;
					}
					
					// non-empty document attached, contact found, attachment(s) successfully inserted, and contact successfully updated
					result.success = true;
					
				}
				
			// no matched contact found
			} else {
				
				// email back to sender
				//Messaging.reserveSingleEmailCapacity(1);
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] { fromEmailAddress };
				mail.setToAddresses(toAddresses);
				try {
					ID fromId = [Select Id From OrgWideEmailAddress where DisplayName = 'IAVA Membership Team'].Id;
					mail.setOrgWideEmailAddressId(fromId);
				} catch (Exception e) {
					System.debug('>>>>>>>>>> Failed to get org wide Email Id for IAVA Membership Team' + e.getMessage());
				}
				
				String mailSubject = 'Membership paperwork attachment failed';
				String mailBody = 'Unfortunately we could not find your email address in our system. Please re-send your paperwork from the address you used to sign up, or contact membership@iava.org for assistance.';
				Contact_Attachment_Email_Service__c caes = Contact_Attachment_Email_Service__c.getInstance('IAVA');
				if (caes != null) {
					if (caes.Error_Message_Subject__c != null && caes.Error_Message_Subject__c != '') mailSubject = caes.Error_Message_Subject__c;
					if (caes.Error_Message_Body__c != null && caes.Error_Message_Body__c != '') mailBody = caes.Error_Message_Body__c;
				}
				mail.setSubject(mailSubject);
				mail.setPlainTextBody(mailBody);
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			}
		}
		
		return result;
	}
	
	////////// Tests //////////
	
	// positive test
	// 1) paperwork exceeding min attachment size attached to the correct contact matched by from email address
	// 2) inbound email subject and body stored in attachment description field
	// 3) paperwork status updated on the matched contact
	public static testMethod void newAttachmentInsertedAndStatusUpdatedForContact(){
		
		List<Contact> conts = new List<Contact> {
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 1', Email = 'utcontact1@iava.org.test'),
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 2', Email = 'utcontact2@iava.org.test')
		};
		insert conts;
		
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		Messaging.InboundEmail.BinaryAttachment attach1 = new Messaging.InboundEmail.BinaryAttachment();
		Messaging.InboundEmail.BinaryAttachment attach2 = new Messaging.InboundEmail.BinaryAttachment();
		
		email.fromAddress = 'utcontact1@iava.org.test';
		email.subject = 'Contact Paperwork';
		email.plainTextBody = 'Some message body';
		attach1.body = Blob.valueOf('Some attachment');
		attach1.fileName = 'Large Attachment.doc';
		attach2.body = Blob.valueOf('Short');
		attach2.fileName = 'Small Attachment.doc';
		email.binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[] { attach1, attach2 };
		
		ContactAttachmentEmailService.MinFileSize = 10;		// override custom settings
		ContactAttachmentEmailService service = new ContactAttachmentEmailService();
		Messaging.InboundEmailResult result = service.handleInboundEmail(email, env);
		
		System.assertEquals(true, result.success);
		
		// large doc with size > MinFileSize is attached, but not the small doc
		List<Attachment> attachments = [select ParentId, body, Description, Name from Attachment where parentId in :conts];
		System.assertEquals(1, attachments.size());
		System.assertEquals(conts[0].Id, attachments[0].ParentId);
		System.assertNotEquals(null, attachments[0].body);
		System.assertEquals('Subject: Contact Paperwork\n\nBody:\nSome message body', attachments[0].Description);
		System.assertEquals('Large Attachment.doc', attachments[0].Name);
		
		for (Contact c : [select Id, Paperwork_Confirmation__c from Contact where Id in :conts]) {
			if (c.Id == conts[0].Id)
				System.assertEquals('Paperwork Received', c.Paperwork_Confirmation__c);
			else
				System.assertEquals(null, c.Paperwork_Confirmation__c);
		}
		
	}
	
	// positive test
	// 1) paperwork attached to the correct contact matched by from email address
	// 2) paperwork status not updated 'backwards' on the matched contact
	// 3) prefer matched contact with Veteran_Member__c == true
	public static testMethod void newAttachmentInsertedStatusNotUpdatedForContact(){
		
		List<Contact> conts = new List<Contact> {
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 1', Email = 'utcontact1@iava.org.test', Paperwork_Confirmation__c = 'Paperwork Accepted', Paperwork_Confirmation_Type__c = 'Deployed OEF/OIF/OND'),
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 2', npe01__WorkEmail__c = 'utcontact2@iava.org.test', Paperwork_Confirmation__c = 'Paperwork Rejected'),
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 3', Email = 'utcontact3@iava.org.test'),
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 4', npe01__HomeEmail__c = 'utcontact3@iava.org.test', Veteran_Member__c = true),
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 5', npe01__AlternateEmail__c = 'utcontact4@iava.org.test'),
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 6', Email = 'utcontact4@iava.org.test')
		};
		insert conts;
		
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		Messaging.InboundEmail.BinaryAttachment attach = new Messaging.InboundEmail.BinaryAttachment();
		
		email.fromAddress = 'utcontact1@iava.org.test';
		email.subject = 'Contact Paperwork';
		email.plainTextBody = 'Some message body';
		attach.body = Blob.valueOf('Some attachment');
		attach.fileName = 'Attachment.doc';
		email.binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[] { attach };
		
		ContactAttachmentEmailService.MinFileSize = 10;		// override custom settings
		ContactAttachmentEmailService service = new ContactAttachmentEmailService();
		Messaging.InboundEmailResult result = service.handleInboundEmail(email, env);
		
		System.assertEquals(true, result.success);
		
		// paperwork status not updated 'backwards' from 'Paperwork Accepted'
		List<Attachment> attachments = [select ParentId, body from Attachment where parentId in :conts];
		System.assertEquals(1, attachments.size());
		System.assertEquals(conts[0].Id, attachments[0].ParentId);
		System.assertNotEquals(null, attachments[0].body);
		
		for (Contact c : [select Id, Paperwork_Confirmation__c from Contact where Id in :conts]) {
			if (c.Id == conts[0].Id)
				System.assertEquals('Paperwork Accepted', c.Paperwork_Confirmation__c);
			else if (c.Id == conts[1].Id)
				System.assertEquals('Paperwork Rejected', c.Paperwork_Confirmation__c);
			else
				System.assertEquals(null, c.Paperwork_Confirmation__c);
		}
		
		email.fromAddress = 'utcontact2@iava.org.test';
		
		service = new ContactAttachmentEmailService();
		result = service.handleInboundEmail(email, env);
		
		System.assertEquals(true, result.success);
		
		// paperwork status not updated 'backwards' from 'Paperwork Rejected'
		attachments = [select ParentId, body from Attachment where parentId in :conts order by Id];
		System.assertEquals(2, attachments.size());
		System.assertEquals(conts[1].Id, attachments[1].ParentId);
		System.assertNotEquals(null, attachments[1].body);
		
		for (Contact c : [select Id, Paperwork_Confirmation__c from Contact where Id in :conts]) {
			if (c.Id == conts[0].Id)
				System.assertEquals('Paperwork Accepted', c.Paperwork_Confirmation__c);
			else if (c.Id == conts[1].Id)
				System.assertEquals('Paperwork Rejected', c.Paperwork_Confirmation__c);
			else
				System.assertEquals(null, c.Paperwork_Confirmation__c);
		}
		
		email.fromAddress = 'utcontact3@iava.org.test';
		
		service = new ContactAttachmentEmailService();
		result = service.handleInboundEmail(email, env);
		
		System.assertEquals(true, result.success);
		
		// prefer contact with Veteran_Member__c == true when multiple contacts match the incoming email address
		attachments = [select ParentId, body from Attachment where parentId in :conts order by Id];
		System.assertEquals(3, attachments.size());
		System.assertEquals(conts[3].Id, attachments[2].ParentId);
		System.assertNotEquals(null, attachments[2].body);
		
		for (Contact c : [select Id, Paperwork_Confirmation__c from Contact where Id in :conts]) {
			if (c.Id == conts[0].Id)
				System.assertEquals('Paperwork Accepted', c.Paperwork_Confirmation__c);
			else if (c.Id == conts[1].Id)
				System.assertEquals('Paperwork Rejected', c.Paperwork_Confirmation__c);
			else if (c.Id == conts[3].Id)
				System.assertEquals('Paperwork Received', c.Paperwork_Confirmation__c);
			else
				System.assertEquals(null, c.Paperwork_Confirmation__c);
		}
		
		email.fromAddress = 'utcontact4@iava.org.test';
		
		service = new ContactAttachmentEmailService();
		result = service.handleInboundEmail(email, env);
		
		System.assertEquals(true, result.success);
		
		// if none of the multiple matched contacts has Veteran_Member__c == true, pick the first matched contact
		attachments = [select ParentId, body from Attachment where parentId in :conts order by Id];
		System.assertEquals(4, attachments.size());
		System.assertEquals(conts[4].Id, attachments[3].ParentId);
		System.assertNotEquals(null, attachments[3].body);
		
		for (Contact c : [select Id, Paperwork_Confirmation__c from Contact where Id in :conts]) {
			if (c.Id == conts[0].Id)
				System.assertEquals('Paperwork Accepted', c.Paperwork_Confirmation__c);
			else if (c.Id == conts[1].Id)
				System.assertEquals('Paperwork Rejected', c.Paperwork_Confirmation__c);
			else if (c.Id == conts[3].Id || c.Id == conts[4].Id)
				System.assertEquals('Paperwork Received', c.Paperwork_Confirmation__c);
			else
				System.assertEquals(null, c.Paperwork_Confirmation__c);
		}
	}
	
	// negative test
	// 1) no attachment with no matched contact
	// 2) no paperwork status update on unmatched contacts
	public static testMethod void noAttachmentInsertedWithNoMatchedContact(){
		
		List<Contact> conts = new List<Contact> {
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 1', Email = 'utcontact1@iava.org.test'),
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 2', Email = 'utcontact2@iava.org.test')
		};
		insert conts;
		
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		Messaging.InboundEmail.BinaryAttachment attach = new Messaging.InboundEmail.BinaryAttachment();
		
		email.fromAddress = 'unmatchedEmail@iava.org.test';
		email.subject = 'Contact Paperwork';
		email.plainTextBody = 'Some message body';
		attach.body = Blob.valueOf('Some attachment');
		attach.fileName = 'Attachment.doc';
		email.binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[] { attach };
		
		ContactAttachmentEmailService.MinFileSize = 10;		// override custom settings
		ContactAttachmentEmailService service = new ContactAttachmentEmailService();
		Messaging.InboundEmailResult result = service.handleInboundEmail(email, env);
		
		System.assertEquals(false, result.success);
		
		List<Attachment> attachments = [select ParentId, body from Attachment where parentId in :conts];
		System.assertEquals(0, attachments.size());
		
		for (Contact c : [select Id, Paperwork_Confirmation__c from Contact where Id in :conts]) {
			System.assertEquals(null, c.Paperwork_Confirmation__c);
		}
		
	}
	
	// negative test
	// 1) no paperwork attachment to matched contact when there is no attachment in email
	// 2) no paperwork status update on matched or unmatched contacts
	public static testMethod void noAttachmentInsertedWithNoEmailAttachment(){
		
		List<Contact> conts = new List<Contact> {
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 1', Email = 'utcontact1@iava.org.test'),
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 2', Email = 'utcontact2@iava.org.test')
		};
		insert conts;
		
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		
		email.fromAddress = 'utcontact1@iava.org.test';
		email.subject = 'Contact Paperwork';
		email.plainTextBody = 'Some message body';
		
		ContactAttachmentEmailService.MinFileSize = 10;		// override custom settings
		ContactAttachmentEmailService service = new ContactAttachmentEmailService();
		Messaging.InboundEmailResult result = service.handleInboundEmail(email, env);
		
		System.assertEquals(false, result.success);
		
		List<Attachment> attachments = [select ParentId, body from Attachment where parentId in :conts];
		System.assertEquals(0, attachments.size());
		
		for (Contact c : [select Id, Paperwork_Confirmation__c from Contact where Id in :conts]) {
			System.assertEquals(null, c.Paperwork_Confirmation__c);
		}
		
	}
	
	// negative test
	// 1) no paperwork attachment to matched contact if attachment in email is blank
	// 2) no paperwork status update on matched or unmatched contacts
	public static testMethod void noAttachmentInsertedWithEmptyEmailAttachment(){
		
		List<Contact> conts = new List<Contact> {
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 1', Email = 'utcontact1@iava.org.test'),
			new Contact(FirstName = 'Unit', LastName = 'Test Contact 2', Email = 'utcontact2@iava.org.test')
		};
		insert conts;
		
		Messaging.InboundEmail email = new Messaging.InboundEmail();
		Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
		Messaging.InboundEmail.BinaryAttachment attach = new Messaging.InboundEmail.BinaryAttachment();
		
		email.fromAddress = 'utcontact1@iava.org.test';
		email.subject = 'Contact Paperwork';
		email.plainTextBody = 'Some message body';
		attach.body = null;
		attach.fileName = 'Attachment.doc';
		email.binaryAttachments = new Messaging.InboundEmail.BinaryAttachment[] { attach };
		
		ContactAttachmentEmailService.MinFileSize = 10;		// override custom settings
		ContactAttachmentEmailService service = new ContactAttachmentEmailService();
		Messaging.InboundEmailResult result = service.handleInboundEmail(email, env);
		
		System.assertEquals(false, result.success);
		
		List<Attachment> attachments = [select ParentId, body from Attachment where parentId in :conts];
		System.assertEquals(0, attachments.size());
		
		for (Contact c : [select Id, Paperwork_Confirmation__c from Contact where Id in :conts]) {
			System.assertEquals(null, c.Paperwork_Confirmation__c);
		}
		
	}
}