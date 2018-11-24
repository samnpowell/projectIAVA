@isTest
public class testActivityTACviewoverride
{
    private static testMethod void actuallyATask()
    {
        Task t = new Task(Subject = 'this is actually a task', Priority = 'Normal', Status = 'Not Started', Really_TAC__c = false);
        insert t;
        
        PageReference pageRef = Page.ActivityTACViewOverride;
        pageRef.getParameters().put('id', t.id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(t);
        ActivityTACviewoverride ext = new ActivityTACviewoverride(stdController);
        test.setCurrentPage(pageRef);
        ext.getActivity();
    }
    
    private static testMethod void reallyTrackACall()
    {
        Task t = new Task(Subject = 'this is actually a task', Priority = 'Normal', Status = 'Not Started', Really_TAC__c = true);
        insert t;
        
        PageReference pageRef = Page.ActivityTACViewOverride;
        pageRef.getParameters().put('id', t.id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(t);
        ActivityTACviewoverride ext = new ActivityTACviewoverride(stdController);
        test.setCurrentPage(pageRef);
        ext.getActivity();
    }
}