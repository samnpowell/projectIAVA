public with sharing class dc_ctrl_FAQ 
{
    private ApexPages.StandardSetController setController;
    
    public dc_ctrl_FAQ()
    {
        if ( setController == null )
        {
            setController = new ApexPages.StandardSetController(Database.getQueryLocator([select Category__c, Question__c, Answer__c from FAQ__c order by Category__c asc]));
        }
    }
    
    // Initialize setCon and return a list of records  
    
    public List<FAQ__c> getFaqs() {
         return (List<FAQ__c>) setController.getRecords();
    }

    public Integer getResultSize() {
         return setController.getResultSize();
    }
    
    public void its()
    {
        Staticvar.dc_homepage = false;
        Staticvar.dc_rewardsearch = false;
        Staticvar.dc_rewarddetail = false;
        Staticvar.dc_claimreward = false;
        Staticvar.dc_partner =false;
        Staticvar.dc_faq = true;
        Staticvar.title = 'IAVA Rucksack - FAQ';

    } 
    
    public with sharing class dc_CustomFAQ {
        public string cat {get; set;}
        public string que {get; set;}
        public string ans {get; set;}
        public string changetitle {get; set;}
        public string changeline {get; set;}
        public dc_CustomFAQ(string cat1, string que1, string ans1, string change1, string change2)      
            {           
                cat = cat1;
                que = que1;
                ans = ans1;
                changetitle = change1;
                changeline = change2;
            }
        }
        public List<dc_CustomFAQ> customfaq = new List<dc_CustomFAQ>(); 
        public List<dc_CustomFAQ> getCUSTFAQ()
        {
            List<FAQ__c> faqlist = new List<FAQ__c>();
            customfaq.clear();
            string changecat;
            string changeline;
            faqlist = [select Category__c, Question__c, Answer__c from FAQ__c order by Category__c asc, Sort_order__c asc];
            for(integer i=0;i<faqlist.size();i++) 
            { 
                if(i ==0 || (i > 0 && faqlist[i].category__c != faqlist[i-1].category__c))
                    changecat = 'true';
                else changecat = 'false';
                if(i == faqlist.size()-1 || ( i < faqlist.size()-1 && faqlist[i].category__c != faqlist[i+1].category__c))
                    changeline = 'true';
                else changeline = 'false';
                customfaq.add(new dc_CustomFAQ(
                faqlist[i].category__c,
                faqlist[i].Question__c,
                faqlist[i].Answer__c,
                changecat,
                changeline
            ));
            
            }
            return customfaq;
        }   
        
    
}