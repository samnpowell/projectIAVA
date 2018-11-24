public class press_hits_controller_extn {
 
    Press_Hit__c ph;

    public press_hits_controller_extn(ApexPages.StandardController controller) {
      ph = (Press_Hit__c) controller.getRecord();        
    }


    public List<Press_Hit__c> getPressHits() {
      return [select Press_Outlet__r.Name, Article_Title__c, Article_Teaser__c, Article_Text__c,
      				Story_Date__c, Link__c, Tier__c, Topic__c, Details_Show__c from Press_Hit__c 
      				where Publish_on_website__c=true order by Story_Date__c DESC];
    }



/*
   public press_hits_controller_extn(ApexPages.StandardSetController setController)
    {
        if ( setController == null )
        {
            setController = new ApexPages.StandardSetController(Database.getQueryLocator(
            	[select Press_Outlet__r.Name, Article_Title__c, Article_Teaser__c, Article_Text__c,
      				Story_Date__c, Link__c, Tier__c, Topic__c, Details_Show__c from Press_Hit__c 
      				where Publish_on_website__c = true order by Story_Date__c DESC]
            ));
        }
    }
*/

}