@isTest
public class testContactGeoLocationBatchProcessing
{
    public static testMethod void consWithMailingZip()
    {
        List<Contact> conList = new List<Contact>();
        for(integer i=0; i<200; i++)
        {
            Contact con = new Contact();
            con.LastName = 'cName' + i;
            con.Latitude__c = null;
            con.Longitude__c = null;
            con.MailingPostalCode = '07730';
            conList.add(con);
        }
        
        test.startTest();
        ContactGeoLocationBatchProcessor batchJob = new ContactGeoLocationBatchProcessor();
        batchJob.execute(null, conList);
        test.stopTest();
    }
    
    public static testMethod void consWithOtherZip()
    {
        List<Contact> conList = new List<Contact>();
        for(integer i=0; i<200; i++)
        {
            Contact con = new Contact();
            con.LastName = 'cName' + i;
            con.Latitude__c = null;
            con.Longitude__c = null;
            con.OtherPostalCode = '07730';
            conList.add(con);
        }
        
        test.startTest();
        ContactGeoLocationBatchProcessor batchJob = new ContactGeoLocationBatchProcessor();
        batchJob.execute(null, conList);
        test.stopTest();
    }
    
    public static testMethod void standardBatchRun()
    {
        List<Contact> conList = new List<Contact>();
        for(integer i=0; i<200; i++)
        {
            Contact con = new Contact();
            con.LastName = 'cName' + i;
            con.Latitude__c = null;
            con.Longitude__c = null;
            con.OtherPostalCode = '07730';
            conList.add(con);
        }
        
        test.startTest();
        ContactGeoLocationBatchProcessor batchJob = new ContactGeoLocationBatchProcessor();
        database.executeBatch(batchJob);
        test.stopTest();
    }
    
    public static testMethod void consWithoutZip()
    {
        List<Contact> conList = new List<Contact>();
        for(integer i=0; i<200; i++)
        {
            Contact con = new Contact();
            con.LastName = 'cName' + i;
            con.Latitude__c = null;
            con.Longitude__c = null;
            conList.add(con);
        }
        
        test.startTest();
        ContactGeoLocationBatchProcessor batchJob = new ContactGeoLocationBatchProcessor();
        batchJob.execute(null, conList);
        test.stopTest();
    }
    
    public static testMethod void executeScheduledBatch()
    {
        test.startTest();
        schedulableContext sched;
        ContactGeoLocationBatchProcessScheduler geoSched = new ContactGeoLocationBatchProcessScheduler();
        geoSched.execute(sched);
        system.schedule('Contact Geo Location 9AM ET - 9PM PT', '0 10 10-1 ? * 1-7', geoSched);
        test.stopTest();
    }
}