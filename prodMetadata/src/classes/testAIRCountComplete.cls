@isTest(seeAllData = true)
public class testAIRCountComplete
{
    private static testMethod void insertCampaignAIR()
    {
        Campaign c = new Campaign(Name = 'airRequiredCampaign', isActive = true, AIR_Required__c = true);
        insert c;
        
        AIR__c a = new AIR__c(Name = 'airRequiredCampaign AIR', Campaign__c = c.Id, Completed__c = true);
        insert a;
    }

    private static testMethod void insertEventAIR()
    {
        IAVAEvent__c ie = new IAVAEvent__c(Name = 'airRequiredEvent');
        insert ie;
        
        AIR__c a = new AIR__c(Name = 'airRequiredCampaign AIR', Event__c = ie.Id, Completed__c = true);
        try
        {
            insert a;
        }
        catch (Exception e)
        {
            System.debug('ERROR:' + e);
        }
    }
    
    private static testMethod void deleteCampaignAIR()
    {
        Campaign c = new Campaign(Name = 'airRequiredCampaign', isActive = true, AIR_Required__c = true);
        insert c;
        
        AIR__c a = new AIR__c(Name = 'airRequiredCampaign AIR', Campaign__c = c.Id, Completed__c = true);
        insert a;
        
        test.startTest();
        delete a;
        test.stopTest();
    }
    
    private static testMethod void completeCampaignAIR()
    {
        Campaign c = new Campaign(Name = 'airRequiredCampaign', isActive = true, AIR_Required__c = true);
        insert c;
        
        AIR__c a = new AIR__c(Name = 'airRequiredCampaign AIR', Campaign__c = c.Id);
        insert a;
        
        a.Completed__c = true;
        test.startTest();
        update a;
        test.stopTest();
    }
    
    private static testMethod void changeAIRParent()
    {
        Campaign c = new Campaign(Name = 'airRequiredCampaign', isActive = true, AIR_Required__c = true);
        insert c;
        
        AIR__c a = new AIR__c(Name = 'airRequiredCampaign AIR', Campaign__c = c.Id, Completed__c = true);
        insert a;
        
        Partnership_Request__c p = new Partnership_Request__c(Name = 'partnershipForGive', Public_Partner_Name__c = 'partner');
        insert p;
        
        Give__c g = new Give__c(Name = 'airRequiredGive', AIR_Required__c = true, Partnership_Request__c = p.Id, National__c = true, National_Give__c = true);
        insert g;
        
        a.Campaign__c = null;
        a.Give__c = g.Id;
        test.startTest();
        update a;
        test.stopTest();
    }
}