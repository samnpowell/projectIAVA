public class caseCommentNotification {
 
    public static void sendCaseCommentNotification(CaseComment incc) {
 
        for(CaseComment com : [select isPublished, Parent.id, Parent.Subject, Parent.Owner.Email, Parent.Requestor__r.email, Parent.Requestor__r.Name, Parent.Requestor__r.id, Parent.RecordType.Name, Parent.CaseNumber, Parent.Status, Parent.Owner.Name, Parent.Description, CommentBody, CreatedBy.Name, CreatedById from casecomment where id = :incc.id]) { 
    
          if (com.isPublished && com.Parent.Requestor__r.email != null && com.Parent.Requestor__r.id != com.CreatedById && com.Parent.RecordType.Name != 'Referral System') {
          // since only sending to Requestor, skip if Requestor email is empty or Requestor created comment
          
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setSenderDisplayName(com.CreatedBy.Name + ' via IAVA Case');
            msg.setSubject('New comment on case: ' + com.Parent.Subject);
//            msg.setCCAddresses(new String[] { 'name@iava.org' });
//            msg.setToAddresses(new String[] { (com.CreatedById == com.Parent.Requestor__r.id ? com.Parent.Owner.Email : com.Parent.Requestor__r.email) });
            msg.setToAddresses(new String[] { com.Parent.Requestor__r.email });
            msg.setHTMLBody(
                '<p>A new case comment has been added by ' + com.CreatedBy.Name + '</p>'
                + '<p>Case #: ' + com.Parent.CaseNumber + '<br />'
                + 'Status: ' + com.Parent.Status + '<br />' 
                + 'Requestor: ' + com.Parent.Requestor__r.Name + '<br /><br />' 
                + 'Link: ' + System.URL.getSalesforceBaseURL().toExternalForm() + '/' + com.Parent.id + '</p>' 
                + '<p>Subject: ' + com.Parent.Subject + '</p>'
                + '<p>Comment: <br />'
                + com.CommentBody + '</p><br /><br/>'
                + '<p>Original Case Description: <br />'
                + com.Parent.Description + '</p><br /><br /><br />'
                + '[sent by sendCaseCommentNotification trigger]<br />'
          );

    
          Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.Email[] { msg });
          
        }
      }
   
    }   
 
    public static testMethod void testSendMail() {
        Case c = new Case(Subject = 'Unit Test Case');
        insert c;   
        
        String uniqueUserName = 'devuser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Development'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName=uniqueUserName);
        
        CaseComment cc = new CaseComment(ParentId = c.id, CommentBody = 'testing comment', isPublished = true);
        system.runAs(u)
        {
            insert cc;
        }
     
        sendCaseCommentNotification(cc);
    }
 
}