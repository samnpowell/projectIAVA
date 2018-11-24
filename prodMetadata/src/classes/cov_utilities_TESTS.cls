@isTest
private class cov_utilities_TESTS {
	
	@isTest static void test_validate_email() {
		system.assertEquals(false, cov_utilities.validateEmail('testbadaddress.com'));
		system.assertEquals(false, cov_utilities.validateEmail(''));
		system.assertEquals(false, cov_utilities.validateEmail(null));
		system.assertEquals(false, cov_utilities.validateEmail('test@bad@address.com'));
		system.assertEquals(false, cov_utilities.validateEmail('test$@bad@address.com'));
		system.assertEquals(false, cov_utilities.validateEmail('@bad@address.com'));
		system.assertEquals(false, cov_utilities.validateEmail('test@badaddresscom'));
		system.assertEquals(false, cov_utilities.validateEmail('test@badaddress.com;'));
		system.assertEquals(false, cov_utilities.validateEmail('test@badaddress.c'));

		system.assertEquals(true, cov_utilities.validateEmail('test@goodaddress.com'));
		system.assertEquals(true, cov_utilities.validateEmail('test@good.address.com'));
		system.assertEquals(true, cov_utilities.validateEmail('test+125@goodaddress.com'));
		system.assertEquals(true, cov_utilities.validateEmail('test@goodaddress.net'));
		system.assertEquals(true, cov_utilities.validateEmail('test@goodaddress.org'));
		system.assertEquals(true, cov_utilities.validateEmail('test@goodaddress.co'));
		system.assertEquals(true, cov_utilities.validateEmail('t@goodaddress.co'));

	}

	// helper method
	private static List<Attachment> queryForAttachments(Id parentId) {
		return [select Id, Name from Attachment where parentId = :parentId];
	}
	
	@isTest static void test_parseImagesFromAttachments() {
		// test with both a contact and a give
		Contact c = new Contact(Lastname='Laster');
		insert c;
		Partnership_Request__c p = new Partnership_Request__c(Name='Test Partner', Public_Partner_Name__c = 'Public Test Partner');
		insert p;
		Give__c g = new Give__c(Name='Test Give', Zip_Code_s__c='10012', Partnership_Request__c=p.Id);
		insert g;

		List<String> resultStrings;


		// Should return nothing if no attachment
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(c.Id));
		system.assertEquals('', resultStrings[0]);
		system.assertEquals('', resultStrings[1]);
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(c.Id), 'image-full', 'image-thumb');
		system.assertEquals('', resultStrings[0]);
		system.assertEquals('', resultStrings[1]);

		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(g.Id));
		system.assertEquals('', resultStrings[0]);
		system.assertEquals('', resultStrings[1]);
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(g.Id), 'image-full', 'image-thumb');
		system.assertEquals('', resultStrings[0]);
		system.assertEquals('', resultStrings[1]);

		Blob theBlob = EncodingUtil.base64decode('R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==');

		// Insert a non-image attachment
		Attachment c_att1 = new Attachment(ParentId = c.Id, Name='Nonimage.pdf', Body=theBlob);
		insert c_att1;
		Attachment g_att1 = new Attachment(ParentId = g.Id, Name='Nonimage.pdf', Body=theBlob);
		insert g_att1;

		// Should return nothing for non-image attachment
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(c.Id));
		system.assertEquals('', resultStrings[0]);
		system.assertEquals('', resultStrings[1]);
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(c.Id), 'image-full', 'image-thumb');
		system.assertEquals('', resultStrings[0]);
		system.assertEquals('', resultStrings[1]);

		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(g.Id));
		system.assertEquals('', resultStrings[0]);
		system.assertEquals('', resultStrings[1]);
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(g.Id), 'image-full', 'image-thumb');
		system.assertEquals('', resultStrings[0]);
		system.assertEquals('', resultStrings[1]);

		// Insert an image attachment with random name
		Attachment c_att2 = new Attachment(ParentId = c.Id, Name='Howard.gif', Body=theBlob);
		insert c_att2;
		Attachment g_att2 = new Attachment(ParentId = g.Id, Name='Filippe.jpg', Body=theBlob);
		insert g_att2;

		// should return the image even without a name match
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(c.Id));
		system.assertEquals((String)c_att2.Id, resultStrings[0]);
		system.assertEquals((String)c_att2.Id, resultStrings[1]);
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(c.Id), 'image-full', 'image-thumb');
		system.assertEquals((String)c_att2.Id, resultStrings[0]);
		system.assertEquals((String)c_att2.Id, resultStrings[1]);

		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(g.Id));
		system.assertEquals((String)g_att2.Id, resultStrings[0]);
		system.assertEquals((String)g_att2.Id, resultStrings[1]);
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(g.Id), 'image-full', 'image-thumb');
		system.assertEquals((String)g_att2.Id, resultStrings[0]);
		system.assertEquals((String)g_att2.Id, resultStrings[1]);

		// Insert a fullsize image attachment with specified name
		Attachment c_att3 = new Attachment(ParentId = c.Id, Name='fullpic.png', Body=theBlob);
		insert c_att3;
		Attachment g_att3 = new Attachment(ParentId = g.Id, Name='lupe_fullpic_smile.jpg', Body=theBlob);
		insert g_att3;

		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(c.Id));
		system.assertEquals((String)c_att3.Id, resultStrings[0]);
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(c.Id), 'image-full', 'image-thumb');
		system.assertEquals((String)c_att3.Id, resultStrings[0]);
		system.assertEquals((String)c_att3.Id, resultStrings[0]);

		// should return the fullsize image for fullsize when requested by name
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(c.Id), 'fullpic', 'image-thumb');
		system.assertEquals((String)c_att3.Id, resultStrings[0]);
		// thumbnail pic should also match since no other thumbnail image
		system.assertEquals((String)c_att3.Id, resultStrings[1]);

		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(g.Id), 'fullpic', 'image-thumb');
		system.assertEquals((String)g_att3.Id, resultStrings[0]);
		// thumbnail pic should also match since no other thumbnail image
		system.assertEquals((String)g_att3.Id, resultStrings[1]);

		// Insert a thumbnail image attachment with specified name
		Attachment c_att4 = new Attachment(ParentId = c.Id, Name='thumby.png', Body=theBlob);
		insert c_att4;
		Attachment g_att4 = new Attachment(ParentId = g.Id, Name='harrisonthumbywumby250.jpg', Body=theBlob);
		insert g_att4;

		// Also insert more wrong-name attachments to ensure that it's not just pulling the latest
		Attachment c_att5 = new Attachment(ParentId = c.Id, Name='wrong-name.gif', Body=theBlob);
		insert c_att5;
		Attachment g_att5 = new Attachment(ParentId = g.Id, Name='yowza.jpg', Body=theBlob);
		insert g_att5;


		// should return no image for fullsize when requested by mismatch name
		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(c.Id), 'nonfull', 'thumby');
		// if no matching name it will return one of the image files
		system.assert(resultStrings[0] == (String)c_att2.Id || resultStrings[0] == (String)c_att3.Id || resultStrings[0] == (String)c_att4.Id || resultStrings[0] == (String)c_att5.Id);
		// thumbnail pic should match when requested by name
		system.assertEquals((String)c_att4.Id, resultStrings[1]);

		resultStrings = cov_utilities.parseImagesFromAttachments(queryForAttachments(g.Id), 'fullpic', 'thumby');
		// full size pic should still come up when requested by name
		system.assertEquals((String)g_att3.Id, resultStrings[0]);
		// thumbnail pic should match when requested by name
		system.assertEquals((String)g_att4.Id, resultStrings[1]);


	}
	
}