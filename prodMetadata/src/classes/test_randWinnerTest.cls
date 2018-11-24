@isTest
public class test_randWinnerTest
{
    static testMethod void checkPageErrorSelectGiveAndEvent()
    {
        test.startTest();
        randWinnerTest controller = new randWinnerTest();
        
        PageReference rwPage = Page.randomWinner;
        test.setCurrentPage(rwPage);
        controller.isEvent = true;
        controller.isGive = true;
        controller.name = 'Test VT 1';
        controller.numWins = 1;
        controller.onScreen = true;
        controller.inCsv = false;
        pageReference newRef = controller.getWinner();
    }
    
    static testMethod void checkPageErrorDontSelectGiveOrEvent()
    {
        test.startTest();
        randWinnerTest controller = new randWinnerTest();
        
        PageReference rwPage = Page.randomWinner;
        test.setCurrentPage(rwPage);
        controller.isEvent = false;
        controller.isGive = false;
        controller.name = 'Test VT 1';
        controller.numWins = 1;
        controller.onScreen = true;
        controller.inCsv = false;
        pageReference newRef = controller.getWinner();
    }
    
    static testMethod void checkPageErrorNoWinners()
    {
        test.startTest();
        randWinnerTest controller = new randWinnerTest();
        
        PageReference rwPage = Page.randomWinner;
        test.setCurrentPage(rwPage);
        controller.isEvent = true;
        controller.isGive = false;
        controller.name = 'Test VT 1';
        controller.numWins = 0;
        controller.onScreen = true;
        controller.inCsv = false;
        pageReference newRef = controller.getWinner();
    }
    
    static testMethod void checkPageErrorSelectScreenAndCSV()
    {
        test.startTest();
        randWinnerTest controller = new randWinnerTest();
        
        PageReference rwPage = Page.randomWinner;
        test.setCurrentPage(rwPage);
        controller.isEvent = true;
        controller.isGive = false;
        controller.name = 'Test VT 1';
        controller.numWins = 1;
        controller.onScreen = true;
        controller.inCsv = true;
        pageReference newRef = controller.getWinner();
    }
    
    static testMethod void checkPageErrorDontSelectScreenOrCSV()
    {
        test.startTest();
        randWinnerTest controller = new randWinnerTest();
        
        PageReference rwPage = Page.randomWinner;
        test.setCurrentPage(rwPage);
        controller.isEvent = true;
        controller.isGive = false;
        controller.name = 'Test VT 1';
        controller.numWins = 1;
        controller.onScreen = false;
        controller.inCsv = false;
        pageReference newRef = controller.getWinner();
    }
    
    static testMethod void checkEventCSVWinners()
    {
        IAVAEvent__c e = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(10));
        insert e;
        
        List<Contact> conList = new List<Contact>();
        Contact c0 = new Contact(FirstName = 'new', LastName = 'contact0', Email = 'newcon0@iava.test');
        conList.add(c0);
        Contact c1 = new Contact(FirstName = 'new', LastName = 'contact1', Email = 'newcon1@iava.test');
        conList.add(c1);
        Contact c2 = new Contact(FirstName = 'new', LastName = 'contact2', Email = 'newcon2@iava.test');
        conList.add(c2);
        Contact c3 = new Contact(FirstName = 'new', LastName = 'contact3', Email = 'newcon3@iava.test');
        conList.add(c3);
        insert conList;
        
        List<IAVAEvent_Attendee__c> attList = new List<IAVAEvent_Attendee__c>();
        IAVAEvent_Attendee__c eA0 = new IAVAEvent_Attendee__c(Event__c = e.Id, Contact__c = c0.Id, Reply_Status__c = 'Yes');
        attList.add(eA0);
        IAVAEvent_Attendee__c eA1 = new IAVAEvent_Attendee__c(Event__c = e.Id, Contact__c = c1.Id, Reply_Status__c = 'Yes');
        attList.add(eA1);
        IAVAEvent_Attendee__c eA2 = new IAVAEvent_Attendee__c(Event__c = e.Id, Contact__c = c2.Id, Reply_Status__c = 'Yes');
        attList.add(eA2);
        IAVAEvent_Attendee__c eA3 = new IAVAEvent_Attendee__c(Event__c = e.Id, Contact__c = c3.Id, Reply_Status__c = 'Yes');
        attList.add(eA3);
        insert attList;
        
        test.startTest();
        randWinnerTest controller = new randWinnerTest();
        
        PageReference rwPage = Page.randomWinner;
        test.setCurrentPage(rwPage);
        controller.isEvent = true;
        controller.isGive = false;
        controller.name = 'Test VT 1';
        controller.numWins = 1;
        controller.onScreen = false;
        controller.inCsv = true;
        pageReference newRef = controller.getWinner();
    }
    
    static testMethod void checkEventOnScreenWinners()
    {
        IAVAEvent__c e = new IAVAEvent__c(Name='Test VT 1', Type__c='VetTogether', Status__c = 'Published', Dont_create_Chatter_Group__c = false, Organizer_Type__c = 'Distributed', Event_Public_Details__c ='These are the public details for e1', Event_Date__c = System.today().addDays(10));
        insert e;
        
        List<Contact> conList = new List<Contact>();
        Contact c0 = new Contact(FirstName = 'new', LastName = 'contact0', Email = 'newcon0@iava.test');
        conList.add(c0);
        Contact c1 = new Contact(FirstName = 'new', LastName = 'contact1', Email = 'newcon1@iava.test');
        conList.add(c1);
        Contact c2 = new Contact(FirstName = 'new', LastName = 'contact2', Email = 'newcon2@iava.test');
        conList.add(c2);
        Contact c3 = new Contact(FirstName = 'new', LastName = 'contact3', Email = 'newcon3@iava.test');
        conList.add(c3);
        insert conList;
        
        List<IAVAEvent_Attendee__c> attList = new List<IAVAEvent_Attendee__c>();
        IAVAEvent_Attendee__c eA0 = new IAVAEvent_Attendee__c(Event__c = e.Id, Contact__c = c0.Id, Reply_Status__c = 'Yes');
        attList.add(eA0);
        IAVAEvent_Attendee__c eA1 = new IAVAEvent_Attendee__c(Event__c = e.Id, Contact__c = c1.Id, Reply_Status__c = 'Yes');
        attList.add(eA1);
        IAVAEvent_Attendee__c eA2 = new IAVAEvent_Attendee__c(Event__c = e.Id, Contact__c = c2.Id, Reply_Status__c = 'Yes');
        attList.add(eA2);
        IAVAEvent_Attendee__c eA3 = new IAVAEvent_Attendee__c(Event__c = e.Id, Contact__c = c3.Id, Reply_Status__c = 'Yes');
        attList.add(eA3);
        insert attList;
        
        test.startTest();
        randWinnerTest controller = new randWinnerTest();
        
        PageReference rwPage = Page.randomWinner;
        test.setCurrentPage(rwPage);
        controller.isEvent = true;
        controller.isGive = false;
        controller.name = 'Test VT 1';
        controller.numWins = 1;
        controller.onScreen = true;
        controller.inCsv = false;
        pageReference newRef = controller.getWinner();
    }
    
    static testMethod void checkGiveCSVWinners()
    {
        Account a = new Account(Name = 'Account for Partnership');
        insert a;
        
        Partnership_Request__c p = new Partnership_Request__c(Name = 'Partnership for Give', Organization__c = a.Id, Public_Partner_Name__c = 'Give Partnership');
        insert p;
        
        Give__c g = new Give__c(Name='Test Give 1', Partnership_Request__c = p.Id, National_Give__c = true);
        insert g;
        
        Give_Instance__c gI = new Give_Instance__c(Give__c = g.Id);
        insert gI;
        
        List<Contact> conList = new List<Contact>();
        Contact c0 = new Contact(FirstName = 'new', LastName = 'contact0', Email = 'newcon0@iava.test');
        conList.add(c0);
        Contact c1 = new Contact(FirstName = 'new', LastName = 'contact1', Email = 'newcon1@iava.test');
        conList.add(c1);
        Contact c2 = new Contact(FirstName = 'new', LastName = 'contact2', Email = 'newcon2@iava.test');
        conList.add(c2);
        Contact c3 = new Contact(FirstName = 'new', LastName = 'contact3', Email = 'newcon3@iava.test');
        conList.add(c3);
        insert conList;
        
        List<Give_Request__c> grList = new List<Give_Request__c>();
        Give_Request__c gR0 = new Give_Request__c(Give_Instance__c = gI.Id, Applicant__c = c0.Id, Stage__c = 'Give Requested', Email_Address__c = 'newcon0@iava.test');
        grList.add(gR0);
        Give_Request__c gR1 = new Give_Request__c(Give_Instance__c = gI.Id, Applicant__c = c1.Id, Stage__c = 'Give Requested', Email_Address__c = 'newcon1@iava.test');
        grList.add(gR1);
        Give_Request__c gR2 = new Give_Request__c(Give_Instance__c = gI.Id, Applicant__c = c2.Id, Stage__c = 'Give Requested', Email_Address__c = 'newcon2@iava.test');
        grList.add(gR2);
        Give_Request__c gR3 = new Give_Request__c(Give_Instance__c = gI.Id, Applicant__c = c3.Id, Stage__c = 'Give Requested', Email_Address__c = 'newcon3@iava.test');
        grList.add(gR3);
        insert grList;
        
        test.startTest();
        randWinnerTest controller = new randWinnerTest();
        
        PageReference rwPage = Page.randomWinner;
        test.setCurrentPage(rwPage);
        controller.isEvent = false;
        controller.isGive = true;
        controller.name = 'Test Give 1';
        controller.numWins = 1;
        controller.onScreen = false;
        controller.inCsv = true;
        pageReference newRef = controller.getWinner();
    }
    
    static testMethod void checkGiveOnScreenWinners()
    {
        Account a = new Account(Name = 'Account for Partnership');
        insert a;
        
        Partnership_Request__c p = new Partnership_Request__c(Name = 'Partnership for Give', Organization__c = a.Id, Public_Partner_Name__c = 'Give Partnership');
        insert p;
        
        Give__c g = new Give__c(Name='Test Give 1', Partnership_Request__c = p.Id, National_Give__c = true);
        insert g;
        
        Give_Instance__c gI = new Give_Instance__c(Give__c = g.Id);
        insert gI;
        
        List<Contact> conList = new List<Contact>();
        Contact c0 = new Contact(FirstName = 'new', LastName = 'contact0', Email = 'newcon0@iava.test');
        conList.add(c0);
        Contact c1 = new Contact(FirstName = 'new', LastName = 'contact1', Email = 'newcon1@iava.test');
        conList.add(c1);
        Contact c2 = new Contact(FirstName = 'new', LastName = 'contact2', Email = 'newcon2@iava.test');
        conList.add(c2);
        Contact c3 = new Contact(FirstName = 'new', LastName = 'contact3', Email = 'newcon3@iava.test');
        conList.add(c3);
        insert conList;
        
        List<Give_Request__c> grList = new List<Give_Request__c>();
        Give_Request__c gR0 = new Give_Request__c(Give_Instance__c = gI.Id, Applicant__c = c0.Id, Stage__c = 'Give Requested', Email_Address__c = 'newcon0@iava.test');
        grList.add(gR0);
        Give_Request__c gR1 = new Give_Request__c(Give_Instance__c = gI.Id, Applicant__c = c1.Id, Stage__c = 'Give Requested', Email_Address__c = 'newcon1@iava.test');
        grList.add(gR1);
        Give_Request__c gR2 = new Give_Request__c(Give_Instance__c = gI.Id, Applicant__c = c2.Id, Stage__c = 'Give Requested', Email_Address__c = 'newcon2@iava.test');
        grList.add(gR2);
        Give_Request__c gR3 = new Give_Request__c(Give_Instance__c = gI.Id, Applicant__c = c3.Id, Stage__c = 'Give Requested', Email_Address__c = 'newcon3@iava.test');
        grList.add(gR3);
        insert grList;
        
        test.startTest();
        randWinnerTest controller = new randWinnerTest();
        
        PageReference rwPage = Page.randomWinner;
        test.setCurrentPage(rwPage);
        controller.isEvent = false;
        controller.isGive = true;
        controller.name = 'Test Give 1';
        controller.numWins = 1;
        controller.onScreen = true;
        controller.inCsv = false;
        pageReference newRef = controller.getWinner();
    }
}