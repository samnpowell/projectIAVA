@isTest
public class weResultAfter_TEST
{
    static testMethod void contactOnly()
    {
        // create a new contact
        Contact c0 = new Contact(FirstName = 'Bob', LastName = 'Burger', Email = 'bburger@iava.test');
        insert c0;
        
        // create wealthengine result with no giving data
        WE_FW8_NP__WESearchResult__c r0 = new WE_FW8_NP__WESearchResult__c(WE_FW8_NP__Contact__c = c0.Id);
        insert r0;
        
        // make sure none of the fields were mirrored on the contact
        c0 = [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id =: c0.Id];
        system.assertEquals(c0.WE_Results_Date__c, null);
        system.assertEquals(c0.WE_Estimated_Annual_Donations__c, null);
        system.assertEquals(c0.WE_Gift_Capacity_Range__c, null);
        system.assertEquals(c0.WE_Net_Worth__c, null);
        system.assertEquals(c0.WE_P2G_Score__c, null);
        system.assertEquals(c0.WE_P2G_Description__c, null);
        system.assertEquals(c0.Age_Number__c, null);
        system.assertEquals(c0.WE_Total_Assets__c, null);
    }
    
    static testMethod void estDonationsOnly()
    {
        // create a new contact
        Contact c0 = new Contact(FirstName = 'Gene', LastName = 'Burger', Email = 'gburger@iava.test');
        insert c0;
        
        // create wealthengine result with estimated annual donations
        WE_FW8_NP__WESearchResult__c r0 = new WE_FW8_NP__WESearchResult__c(WE_FW8_NP__Contact__c = c0.Id, WE_FW8_NP__EAD__c = 'They have the potential to give more');
        insert r0;
        
        // make sure only the date and estimated annual donations were mirrored on the contact
        c0 = [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id =: c0.Id];
        system.assertEquals(c0.WE_Results_Date__c, date.today());
        system.assertEquals(c0.WE_Estimated_Annual_Donations__c, 'They have the potential to give more');
        system.assertEquals(c0.WE_Gift_Capacity_Range__c, null);
        system.assertEquals(c0.WE_Net_Worth__c, null);
        system.assertEquals(c0.WE_P2G_Score__c, null);
        system.assertEquals(c0.WE_P2G_Description__c, null);
        system.assertEquals(c0.WE_Total_Assets__c, null);
        system.assertEquals(c0.Age_Number__c, null);
    }
    
    static testMethod void givingCapOnly()
    {
        // create a new contact
        Contact c0 = new Contact(FirstName = 'Sterling', LastName = 'Archer', Email = 'dangerzone@iava.test');
        insert c0;
        
        // create wealthengine result with gift capacity range
        WE_FW8_NP__WESearchResult__c r0 = new WE_FW8_NP__WESearchResult__c(WE_FW8_NP__Contact__c = c0.Id, WE_FW8_NP__GiftCapacityRange__c = 'This person can give us lots of money');
        insert r0;
        
        // make sure only the date and gift capacity range were mirrored on the contact
        c0 = [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id =: c0.Id];
        system.assertEquals(c0.WE_Results_Date__c, date.today());
        system.assertEquals(c0.WE_Estimated_Annual_Donations__c, null);
        system.assertEquals(c0.WE_Gift_Capacity_Range__c, 'This person can give us lots of money');
        system.assertEquals(c0.WE_Net_Worth__c, null);
        system.assertEquals(c0.WE_P2G_Score__c, null);
        system.assertEquals(c0.WE_P2G_Description__c, null);
        system.assertEquals(c0.WE_Total_Assets__c, null);
        system.assertEquals(c0.Age_Number__c, null);
    }
    
    static testMethod void netWorthOnly()
    {
        // create a new contact
        Contact c0 = new Contact(FirstName = 'Louise', LastName = 'Buger', Email = 'lburger@iava.test');
        insert c0;
        
        // create wealthengine result with net worth
        WE_FW8_NP__WESearchResult__c r0 = new WE_FW8_NP__WESearchResult__c(WE_FW8_NP__Contact__c = c0.Id, WE_FW8_NP__NetworthRange__c = 'Wealthiest person in NYC');
        insert r0;
        
        // make sure only the date and net worth were mirrored on the contact
        c0 = [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id =: c0.Id];
        system.assertEquals(c0.WE_Results_Date__c, date.today());
        system.assertEquals(c0.WE_Estimated_Annual_Donations__c, null);
        system.assertEquals(c0.WE_Gift_Capacity_Range__c, null);
        system.assertEquals(c0.WE_Net_Worth__c, 'Wealthiest person in NYC');
        system.assertEquals(c0.WE_P2G_Score__c, null);
        system.assertEquals(c0.WE_P2G_Description__c, null);
        system.assertEquals(c0.WE_Total_Assets__c, null);
        system.assertEquals(c0.Age_Number__c, null);
    }
    
    static testMethod void p2GScoreOnly()
    {
        // create a new contact
        Contact c0 = new Contact(FirstName = 'Gob', LastName = 'Bluth', Email = 'gbluth@iava.test');
        insert c0;
        
        // create wealthengine result with p2g score
        WE_FW8_NP__WESearchResult__c r0 = new WE_FW8_NP__WESearchResult__c(WE_FW8_NP__Contact__c = c0.Id, WE_FW8_NP__P2G_SCORE__c = 'So rich, much money, all donations');
        insert r0;
        
        // make sure only the date and p2g score were mirrored on the contact
        c0 = [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id =: c0.Id];
        system.assertEquals(c0.WE_Results_Date__c, date.today());
        system.assertEquals(c0.WE_Estimated_Annual_Donations__c, null);
        system.assertEquals(c0.WE_Gift_Capacity_Range__c, null);
        system.assertEquals(c0.WE_Net_Worth__c, null);
        system.assertEquals(c0.WE_P2G_Score__c, 'So rich, much money, all donations');
        system.assertEquals(c0.WE_P2G_Description__c, null);
        system.assertEquals(c0.WE_Total_Assets__c, null);
        system.assertEquals(c0.Age_Number__c, null);
    }
    
    static testMethod void p2GDescOnly()
    {
        // create a new contact
        Contact c0 = new Contact(FirstName = 'George-Michael', LastName = 'Bluth', Email = 'gmbluth@iava.test');
        insert c0;
        
        // create wealthengine result with p2g description
        WE_FW8_NP__WESearchResult__c r0 = new WE_FW8_NP__WESearchResult__c(WE_FW8_NP__Contact__c = c0.Id, WE_FW8_NP__P2G_Description__c = 'They are likely to give lots of money');
        insert r0;
        
        // make sure only the date and p2g description were mirrored on the contact
        c0 = [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id =: c0.Id];
        system.assertEquals(c0.WE_Results_Date__c, date.today());
        system.assertEquals(c0.WE_Estimated_Annual_Donations__c, null);
        system.assertEquals(c0.WE_Gift_Capacity_Range__c, null);
        system.assertEquals(c0.WE_Net_Worth__c, null);
        system.assertEquals(c0.WE_P2G_Score__c, null);
        system.assertEquals(c0.WE_P2G_Description__c, 'They are likely to give lots of money');
        system.assertEquals(c0.WE_Total_Assets__c, null);
        system.assertEquals(c0.Age_Number__c, null);
    }
    
    static testMethod void totAssetsOnly()
    {
        // create a new contact
        Contact c0 = new Contact(FirstName = 'Maeby', LastName = 'Bluth', Email = 'mbluth@iava.test');
        insert c0;
        
        // create wealthengine result with total assets
        WE_FW8_NP__WESearchResult__c r0 = new WE_FW8_NP__WESearchResult__c(WE_FW8_NP__Contact__c = c0.Id, WE_FW8_NP__AssetRange__c = 'Planes, trains, and automobiles');
        insert r0;
        
        // make sure only the date and total assets were mirrored on the contact
        c0 = [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id =: c0.Id];
        system.assertEquals(c0.WE_Results_Date__c, date.today());
        system.assertEquals(c0.WE_Estimated_Annual_Donations__c, null);
        system.assertEquals(c0.WE_Gift_Capacity_Range__c, null);
        system.assertEquals(c0.WE_Net_Worth__c, null);
        system.assertEquals(c0.WE_P2G_Score__c, null);
        system.assertEquals(c0.WE_P2G_Description__c, null);
        system.assertEquals(c0.WE_Total_Assets__c, 'Planes, trains, and automobiles');
        system.assertEquals(c0.Age_Number__c, null);
    }
    
    static testMethod void weAgeOnly()
    {
        // create a new contact
        Contact c0 = new Contact(FirstName = 'Arthur', LastName = 'Dent', Email = 'adent@iava.test');
        insert c0;
        
        // create wealthengine result with age
        WE_FW8_NP__WESearchResult__c r0 = new WE_FW8_NP__WESearchResult__c(WE_FW8_NP__Contact__c = c0.Id, WE_FW8_NP__GC_AGE_USED__c = '42');
        insert r0;
        
        // make sure only the date and age were mirrored on the contact
        c0 = [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id =: c0.Id];
        system.assertEquals(c0.WE_Results_Date__c, date.today());
        system.assertEquals(c0.WE_Estimated_Annual_Donations__c, null);
        system.assertEquals(c0.WE_Gift_Capacity_Range__c, null);
        system.assertEquals(c0.WE_Net_Worth__c, null);
        system.assertEquals(c0.WE_P2G_Score__c, null);
        system.assertEquals(c0.WE_P2G_Description__c, null);
        system.assertEquals(c0.WE_Total_Assets__c, null);
        system.assertEquals(c0.Age_Number__c, 42);
    }
    
    static testMethod void allAttributesScore()
    {
        // create a new contact
        Contact c0 = new Contact(FirstName = 'Tina', LastName = 'Burger', Email = 'tburger@iava.test');
        insert c0;
        
        // create wealthengine result with all attributes
        WE_FW8_NP__WESearchResult__c r0 = new WE_FW8_NP__WESearchResult__c(WE_FW8_NP__Contact__c = c0.Id, WE_FW8_NP__EAD__c = 'Money, lots & lots of money', WE_FW8_NP__GiftCapacityRange__c = 'This person can give us all the money', WE_FW8_NP__NetworthRange__c = 'More than your education', WE_FW8_NP__P2G_SCORE__c = 'Super-funder', WE_FW8_NP__P2G_Description__c = 'Our dream donor', WE_FW8_NP__AssetRange__c = 'Richer than a leprechaun', WE_FW8_NP__GC_AGE_USED__c = '42');
        insert r0;
        
        // make sure all attributes (and date) were mirrored on the contact
        c0 = [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id =: c0.Id];
        system.assertEquals(c0.WE_Results_Date__c, date.today());
        system.assertEquals(c0.WE_Estimated_Annual_Donations__c, 'Money, lots & lots of money');
        system.assertEquals(c0.WE_Gift_Capacity_Range__c, 'This person can give us all the money');
        system.assertEquals(c0.WE_Net_Worth__c, 'More than your education');
        system.assertEquals(c0.WE_P2G_Score__c, 'Super-funder');
        system.assertEquals(c0.WE_P2G_Description__c, 'Our dream donor');
        system.assertEquals(c0.WE_Total_Assets__c, 'Richer than a leprechaun');
        system.assertEquals(c0.Age_Number__c, 42);
    }
    
    static testMethod void unmatchedContact()
    {
        // create a new contact
        Contact c0 = new Contact(FirstName = 'Ford', LastName = 'Prefect', Email = 'fprefect@iava.test');
        insert c0;
        
        // create wealthengine result with all attributes
        WE_FW8_NP__WESearchResult__c r0 = new WE_FW8_NP__WESearchResult__c(WE_FW8_NP__Contact__c = c0.Id, WE_FW8_NP__EAD__c = 'Unable to rate', WE_FW8_NP__GiftCapacityRange__c = 'Unable to rate', WE_FW8_NP__NetworthRange__c = 'Unable to rate', WE_FW8_NP__P2G_SCORE__c = '5', WE_FW8_NP__P2G_Description__c = 'Unmatched', WE_FW8_NP__AssetRange__c = 'Unable to rate', WE_FW8_NP__GC_AGE_USED__c = null);
        insert r0;
        
        // make sure no attributes (and date) were mirrored on the contact
        c0 = [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id =: c0.Id];
        system.assertEquals(c0.WE_Results_Date__c, null);
        system.assertEquals(c0.WE_Estimated_Annual_Donations__c, null);
        system.assertEquals(c0.WE_Gift_Capacity_Range__c, null);
        system.assertEquals(c0.WE_Net_Worth__c, null);
        system.assertEquals(c0.WE_P2G_Score__c, null);
        system.assertEquals(c0.WE_P2G_Description__c, null);
        system.assertEquals(c0.WE_Total_Assets__c, null);
        system.assertEquals(c0.Age_Number__c, null);
    }
    
    static testMethod void unmatchedContactNoOverwrite()
    {
        // create a new contact
        Contact c0 = new Contact(FirstName = 'Zaphod', LastName = 'Beeblebrox', Email = 'galaxyprez@iava.test', WE_Results_Date__c = date.today().addDays(-5), WE_Estimated_Annual_Donations__c = 'somewhere around $5M', WE_Gift_Capacity_Range__c = 'around $10M', WE_Net_Worth__c = 'about $30B', WE_P2G_Score__c= '1|0', WE_P2G_Description__c = 'huge giving potential, highly rated', WE_Total_Assets__c = 'more than you can imagine', Age_Number__c = 42);
        insert c0;
        
        // create wealthengine result with all attributes
        WE_FW8_NP__WESearchResult__c r0 = new WE_FW8_NP__WESearchResult__c(WE_FW8_NP__Contact__c = c0.Id, WE_FW8_NP__EAD__c = 'Unable to rate', WE_FW8_NP__GiftCapacityRange__c = 'Unable to rate', WE_FW8_NP__NetworthRange__c = 'Unable to rate', WE_FW8_NP__P2G_SCORE__c = '5', WE_FW8_NP__P2G_Description__c = 'Unmatched', WE_FW8_NP__AssetRange__c = 'Unable to rate', WE_FW8_NP__GC_AGE_USED__c = null);
        insert r0;
        
        // make sure no attributes (and date) were mirrored on the contact
        c0 = [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id =: c0.Id];
        system.assertEquals(c0.WE_Results_Date__c, date.today().addDays(-5));
        system.assertEquals(c0.WE_Estimated_Annual_Donations__c, 'somewhere around $5M');
        system.assertEquals(c0.WE_Gift_Capacity_Range__c, 'around $10M');
        system.assertEquals(c0.WE_Net_Worth__c, 'about $30B');
        system.assertEquals(c0.WE_P2G_Score__c, '1|0');
        system.assertEquals(c0.WE_P2G_Description__c, 'huge giving potential, highly rated');
        system.assertEquals(c0.WE_Total_Assets__c, 'more than you can imagine');
        system.assertEquals(c0.Age_Number__c, 42);
    }
}