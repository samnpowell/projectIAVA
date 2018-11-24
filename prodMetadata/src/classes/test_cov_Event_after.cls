@isTest
public class test_cov_Event_after
{
    static testMethod void changeEventName()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Dont_create_Chatter_Group__c = false, Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e = [SELECT Id, Chatter_Group_Mirror__c, Name FROM IAVAEvent__c WHERE Id =: e.Id];
        system.assertNotEquals(null, e.Chatter_Group_Mirror__c);
                
        e.Name = 'This is a test event';
        test.startTest();
        update e;
        test.stopTest();
        
        e = [SELECT Id, Chatter_Group_Mirror__c, Name FROM IAVAEvent__c WHERE Id =: e.Id];
        system.assertNotEquals(null, e.Chatter_Group_Mirror__c);
        
        CollaborationGroup cg = cov_groups_controller.findGroupByMirrorId(e.Chatter_Group_Mirror__c);
        system.assertEquals('[Event] This is a test event',cg.Name);
        system.assertNotEquals(null, cg.InformationBody);
    }
    
    static testMethod void changeEventNameOnUpdatedCG()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Dont_create_Chatter_Group__c = false, Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
                
        e = [SELECT Id, Chatter_Group_Mirror__c, Name FROM IAVAEvent__c WHERE Id =: e.Id];
        
        CollaborationGroup cg = cov_groups_controller.findGroupByMirrorId(e.Chatter_Group_Mirror__c);
        system.assertEquals('[Event] Test Event', cg.Name);
        
        cg.InformationBody = 'i updated the body before updating the group';
        update cg;
        system.assertNotEquals(null, cg.InformationBody);
        
        e.Name = 'This is a test event';
        test.startTest();
        update e;
        test.stopTest();
        
        e = [SELECT Id, Chatter_Group_Mirror__c, Name FROM IAVAEvent__c WHERE Id =: e.Id];
        cg = cov_groups_controller.findGroupByMirrorId(e.Chatter_Group_Mirror__c);
        system.assertEquals('[Event] This is a test event',cg.Name);
        system.assertNotEquals(null, cg.InformationBody);
    }
    
    static testMethod void changeEventDate()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        date dN = dE.addDays(10);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published');
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
        
        e.Event_Date__c = dN;
        test.startTest();
        update e;
        test.stopTest();
        
        List<IAVAEvent_Attendee__c> ea = [SELECT Id, Notify_attendee_of_changed_event__c, change_tracking_for_email__c, Suppress_Attendee_Notifications__c, Event__c FROM IAVAEvent_Attendee__c WHERE Event__c =: e.Id];
        system.assert(ea[0].change_tracking_for_email__c.contains('Event Date: '));
    }
    
    static testMethod void changeEventStart()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Start_Time__c = '12:00 PM');
        insert e;
        
        e.Start_Time__c = '6:00 PM';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventEnd()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', End_Time__c = '12:00 PM');
        insert e;
        
        e.End_Time__c = '6:00 PM';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventTimes()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Start_Time__c = '12:00 PM', End_Time__c = '3:00 PM');
        insert e;
        
        e.Start_Time__c = '6:00 PM';
        e.End_Time__c = '9:00 PM';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventDateAndTimes()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        date dN = dE.addDays(10);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Start_Time__c = '12:00 PM', End_Time__c = '3:00 PM');
        insert e;
        
        e.Event_Date__c = dN;
        e.Start_Time__c = '6:00 PM';
        e.End_Time__c = '9:00 PM';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventDateAndStart()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        date dN = dE.addDays(10);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Start_Time__c = '12:00 PM');
        insert e;
        
        e.Event_Date__c = dN;
        e.Start_Time__c = '6:00 PM';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventDateAndEnd()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        date dN = dE.addDays(10);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', End_Time__c = '12:00 PM');
        insert e;
        
        e.Event_Date__c = dN;
        e.End_Time__c = '6:00 PM';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventVenue()
    {
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Status__c = 'Published', Location_Venue__c = 'here', Location_Street_Address__c = 'here street', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Location_Venue__c = 'there';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventStreet()
    {
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Status__c = 'Published', Location_Venue__c = 'here', Location_Street_Address__c = 'here street', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Location_Street_Address__c = 'there';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventDateAndLocation()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        date dN = dE.addDays(10);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Event_Date__c = dN;
        e.Location_Venue__c = 'there';
        e.Location_Street_Address__c = 'there';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventCost()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Associated_Cost__c = 20;
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void removeEventCost()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Associated_Cost__c = 0;
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventDateAndCost()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        date dN = dE.addDays(10);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Event_Date__c = dN;
        e.Associated_Cost__c = 20;
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventDateAndRemoveCost()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        date dN = dE.addDays(10);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Event_Date__c = dN;
        e.Associated_Cost__c = 0;
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventPublicDetails()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Event_Public_Details__c = 'these are the details', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Event_Public_Details__c = 'these are the new and improved public details';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventPublicDetailsTooLong()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Event_Public_Details__c = 'these are the details', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Event_Public_Details__c = 'these are the new and improved public details...';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventDateAndPublicDetails()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        date dN = dE.addDays(10);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Event_Public_Details__c = 'these are the details', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Event_Date__c = dN;
        e.Event_Public_Details__c = 'these are the new and improved public details';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventDateAndPublicDetailsTooLong()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        date dN = dE.addDays(10);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Event_Public_Details__c = 'these are the details', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Event_Date__c = dN;
        e.Event_Public_Details__c = 'these are the new and improved public details...';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void removeEventPublicDetails()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Event_Public_Details__c = 'these are the details', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Event_Public_Details__c = null;
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void changeEventDateAndRemovePublicDetails()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        date dN = dE.addDays(10);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Event_Public_Details__c = 'these are the details', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Event_Date__c = dN;
        e.Event_Public_Details__c = null;
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void cancelEvent()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Event_Public_Details__c = 'these are the details', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
        insert e;
        
        e.Status__c = 'Canceled';
        test.startTest();
        update e;
        test.stopTest();
    }
    
    static testMethod void suppressNotifications()
    {
        date dT = date.today();
        date dE = dT.addDays(5);
        
        IAVAEvent__c e = new IAVAEvent__c(Name = 'Test Event', Suppress_Attendee_Notifications__c = false, Event_Date__c = dE, Status__c = 'Published', Event_Public_Details__c = 'these are the details', Associated_Cost__c = 15, Location_Venue__c = 'here', Location_Street_Address__c = 'here', Location_City__c = 'here city', Location_State__c = 'here state', Location_Zip_Code__c = '12345');
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
        
        e.Suppress_Attendee_Notifications__c = true;
        test.startTest();
        update e;
        test.stopTest();
        
        List<IAVAEvent_Attendee__c> ea = [SELECT Id, Notify_attendee_of_changed_event__c, change_tracking_for_email__c, Suppress_Attendee_Notifications__c, Event__c FROM IAVAEvent_Attendee__c WHERE Event__c =: e.Id];
        system.assert(ea[0].Suppress_Attendee_Notifications__c);
    }
}