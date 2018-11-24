@isTest
public class sponsorshipTicket_Test
{
    static testMethod void newSinglePurchaserOneTypePositiveTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='spOTCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contact
        Contact con = new Contact(FirstName='single',LastName='purch',Email='singlepurch@test.test');
        insert con;
        
        // create the campaign member
        CampaignMember mem = new CampaignMember(CampaignId=camp.Id,ContactId=con.Id);
        insert mem;
        
        // create the sponsorship/ticket
        Sponsorship_Ticket__c st = new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Supporter Individual',Quantity__c=2);
        insert st;
        
        // test the assumptions
        mem = [SELECT CampaignId, Ally_Sponsor__c, Champion_Sponsor__c, Friend_Individual__c, Hero_Sponsor__c, Platinum_Hero__c, Supporter_Individual__c, Valor_Sponsor__c FROM CampaignMember WHERE Id =: st.CampaignMemberId__c];
        camp = [SELECT Ally_Sponsorships__c, Champion_Sponsorships__c, Friend_Individual_Tickets__c, Hero_Sponsorships__c, Platinum_Hero_Sponsorships__c, Supporter_Individual_Tickets__c, Valor_Sponsorships__c FROM Campaign WHERE Id =: mem.CampaignId];
        
        system.assertEquals(null,mem.Ally_Sponsor__c);
        system.assertEquals(null,mem.Champion_Sponsor__c);
        system.assertEquals(null,mem.Friend_Individual__c);
        system.assertEquals(null,mem.Hero_Sponsor__c);
        system.assertEquals(null,mem.Platinum_Hero__c);
        system.assertEquals(2,mem.Supporter_Individual__c);
        system.assertEquals(null,mem.Valor_Sponsor__c);
        system.assertEquals(0,camp.Ally_Sponsorships__c);
        system.assertEquals(0,camp.Champion_Sponsorships__c);
        system.assertEquals(0,camp.Friend_Individual_Tickets__c);
        system.assertEquals(0,camp.Hero_Sponsorships__c);
        system.assertEquals(0,camp.Platinum_Hero_Sponsorships__c);
        system.assertEquals(2,camp.Supporter_Individual_Tickets__c);
        system.assertEquals(0,camp.Valor_Sponsorships__c);
    }
    
    static testMethod void newMultPurchaserOneTypePositiveTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='mpOTCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contacts
        List<Contact> cons = new List<Contact>();
        cons.add(new Contact(FirstName='mult',LastName='purch0',Email='multpurch0@test.test'));
        cons.add(new Contact(FirstName='mult',LastName='purch1',Email='multpurch1@test.test'));
        cons.add(new Contact(FirstName='mult',LastName='purch2',Email='multpurch2@test.test'));
        insert cons;
        
        // create the campaign members
        List<CampaignMember> mems = new List<CampaignMember>();
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[0].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[1].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[2].Id));
        insert mems;
        
        // create the sponsorships/tickets
        List<Sponsorship_Ticket__c> sts = new List<Sponsorship_Ticket__c>();
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[0].Id,Type__c='Ally Sponsor',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[1].Id,Type__c='Champion Sponsor',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[2].Id,Type__c='Friend Individual',Quantity__c=2));
        insert sts;
        
        // add sponsorship/ticket campaign member ids to a set
        Set<Id> memIds = new Set<Id>();
        memIds.add(sts[0].CampaignMemberId__c);
        memIds.add(sts[1].CampaignMemberId__c);
        memIds.add(sts[2].CampaignMemberId__c);
        
        // test the assumptions
        mems = [SELECT CampaignId, Ally_Sponsor__c, Champion_Sponsor__c, Friend_Individual__c, Hero_Sponsor__c, Platinum_Hero__c, Supporter_Individual__c, Valor_Sponsor__c FROM CampaignMember WHERE Id =: memIds];
        camp = [SELECT Ally_Sponsorships__c, Champion_Sponsorships__c, Friend_Individual_Tickets__c, Hero_Sponsorships__c, Platinum_Hero_Sponsorships__c, Supporter_Individual_Tickets__c, Valor_Sponsorships__c FROM Campaign WHERE Id =: mems[0].CampaignId];
        
        // asserts for mem0 - Ally Sponsor (1)
        system.assertEquals(1,mems[0].Ally_Sponsor__c);
        system.assertEquals(null,mems[0].Champion_Sponsor__c);
        system.assertEquals(null,mems[0].Friend_Individual__c);
        system.assertEquals(null,mems[0].Hero_Sponsor__c);
        system.assertEquals(null,mems[0].Platinum_Hero__c);
        system.assertEquals(null,mems[0].Supporter_Individual__c);
        system.assertEquals(null,mems[0].Valor_Sponsor__c);
        // asserts for mem1 - Champion Sponsor (1)
        system.assertEquals(null,mems[1].Ally_Sponsor__c);
        system.assertEquals(1,mems[1].Champion_Sponsor__c);
        system.assertEquals(null,mems[1].Friend_Individual__c);
        system.assertEquals(null,mems[1].Hero_Sponsor__c);
        system.assertEquals(null,mems[1].Platinum_Hero__c);
        system.assertEquals(null,mems[1].Supporter_Individual__c);
        system.assertEquals(null,mems[1].Valor_Sponsor__c);
        // asserts for mem2 - Friend Individual (2)
        system.assertEquals(null,mems[2].Ally_Sponsor__c);
        system.assertEquals(null,mems[2].Champion_Sponsor__c);
        system.assertEquals(2,mems[2].Friend_Individual__c);
        system.assertEquals(null,mems[2].Hero_Sponsor__c);
        system.assertEquals(null,mems[2].Platinum_Hero__c);
        system.assertEquals(null,mems[2].Supporter_Individual__c);
        system.assertEquals(null,mems[2].Valor_Sponsor__c);
        // asserts for camp
        system.assertEquals(1,camp.Ally_Sponsorships__c);
        system.assertEquals(1,camp.Champion_Sponsorships__c);
        system.assertEquals(2,camp.Friend_Individual_Tickets__c);
        system.assertEquals(0,camp.Hero_Sponsorships__c);
        system.assertEquals(0,camp.Platinum_Hero_Sponsorships__c);
        system.assertEquals(0,camp.Supporter_Individual_Tickets__c);
        system.assertEquals(0,camp.Valor_Sponsorships__c);
    }
    
    static testMethod void singlePurchaserMultTicketPositiveTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='spmtCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contact
        Contact con = new Contact(FirstName='singP',LastName='multT',Email='singPmultT@test.test');
        insert con;
        
        // create the campaign member
        CampaignMember mem = new CampaignMember(CampaignId=camp.Id,ContactId=con.Id);
        insert mem;
        
        // create the sponsorships/tickets
        List<Sponsorship_Ticket__c> sts = new List<Sponsorship_Ticket__c>();
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Champion Sponsor',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Friend Individual',Quantity__c=2));
        insert sts;
        
        // query for the campaign member and campaign
        mem = [SELECT CampaignId, Ally_Sponsor__c, Champion_Sponsor__c, Friend_Individual__c, Hero_Sponsor__c, Platinum_Hero__c, Supporter_Individual__c, Valor_Sponsor__c FROM CampaignMember WHERE Id =: mem.Id];
        camp = [SELECT Ally_Sponsorships__c, Champion_Sponsorships__c, Friend_Individual_Tickets__c, Hero_Sponsorships__c, Platinum_Hero_Sponsorships__c, Supporter_Individual_Tickets__c, Valor_Sponsorships__c FROM Campaign WHERE Id =: mem.CampaignId];
        
        // asserts for purchaser - champion sponsor (1); friend individual (2)
        system.assertEquals(null,mem.Ally_Sponsor__c);
        system.assertEquals(1,mem.Champion_Sponsor__c);
        system.assertEquals(2,mem.Friend_Individual__c);
        system.assertEquals(null,mem.Hero_Sponsor__c);
        system.assertEquals(null,mem.Platinum_Hero__c);
        system.assertEquals(null,mem.Supporter_Individual__c);
        system.assertEquals(null,mem.Valor_Sponsor__c);
        // asserts for campaign - champion sponsor (1); friend individual (2)
        system.assertEquals(0,camp.Ally_Sponsorships__c);
        system.assertEquals(1,camp.Champion_Sponsorships__c);
        system.assertEquals(2,camp.Friend_Individual_Tickets__c);
        system.assertEquals(0,camp.Hero_Sponsorships__c);
        system.assertEquals(0,camp.Platinum_Hero_Sponsorships__c);
        system.assertEquals(0,camp.Supporter_Individual_Tickets__c);
        system.assertEquals(0,camp.Valor_Sponsorships__c);
    }
    
    static testMethod void multPurchaserMultTixCampWTixPosTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='mpmtCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contacts
        List<Contact> cons = new List<Contact>();
        cons.add(new Contact(FirstName='mult',LastName='tix0',Email='multtix0@test.test'));
        cons.add(new Contact(FirstName='mult',LastName='tix1',Email='multtix1@test.test'));
        cons.add(new Contact(FirstName='mult',LastName='tix2',Email='multtix2@test.test'));
        cons.add(new Contact(FirstName='mult',LastName='tix3',Email='multtix3@test.test'));
        insert cons;
        
        // create the campaign members - add some w/ tix
        List<CampaignMember> mems = new List<CampaignMember>();
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[0].Id,Ally_Sponsor__c=1));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[1].Id,Supporter_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[2].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[3].Id,Friend_Individual__c=1));
        insert mems;
        
        // create the sponsorships/tickets
        List<Sponsorship_Ticket__c> sts = new List<Sponsorship_Ticket__c>();
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[0].Id,Type__c='Champion Sponsor',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[1].Id,Type__c='Platinum Hero',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[2].Id,Type__c='Hero Sponsor',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[2].Id,Type__c='Supporter Individual',Quantity__c=2));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[3].Id,Type__c='Valor Sponsor',Quantity__c=1));
        insert sts;
        
        // add sponsorship/ticket campaign member ids to a set
        Set<Id> memIds = new Set<Id>();
        memIds.add(sts[0].CampaignMemberId__c);
        memIds.add(sts[1].CampaignMemberId__c);
        memIds.add(sts[2].CampaignMemberId__c);
        memIds.add(sts[4].CampaignMemberId__c);
        
        // query for the campaign member and campaign
        mems = [SELECT CampaignId, Ally_Sponsor__c, Champion_Sponsor__c, Friend_Individual__c, Hero_Sponsor__c, Platinum_Hero__c, Supporter_Individual__c, Valor_Sponsor__c FROM CampaignMember WHERE Id =: memIds];
        camp = [SELECT Ally_Sponsorships__c, Champion_Sponsorships__c, Friend_Individual_Tickets__c, Hero_Sponsorships__c, Platinum_Hero_Sponsorships__c, Supporter_Individual_Tickets__c, Valor_Sponsorships__c FROM Campaign WHERE Id =: mems[0].CampaignId];
        
        // asserts for mem0 - ally sponsor (1); champion sponsor (1)
        system.assertEquals(1,mems[0].Ally_Sponsor__c);
        system.assertEquals(1,mems[0].Champion_Sponsor__c);
        system.assertEquals(null,mems[0].Friend_Individual__c);
        system.assertEquals(null,mems[0].Hero_Sponsor__c);
        system.assertEquals(null,mems[0].Platinum_Hero__c);
        system.assertEquals(null,mems[0].Supporter_Individual__c);
        system.assertEquals(null,mems[0].Valor_Sponsor__c);
        // asserts for mem1 - platinum hero (1); supporter individual (2)
        system.assertEquals(null,mems[1].Ally_Sponsor__c);
        system.assertEquals(null,mems[1].Champion_Sponsor__c);
        system.assertEquals(null,mems[1].Friend_Individual__c);
        system.assertEquals(null,mems[1].Hero_Sponsor__c);
        system.assertEquals(1,mems[1].Platinum_Hero__c);
        system.assertEquals(2,mems[1].Supporter_Individual__c);
        system.assertEquals(null,mems[1].Valor_Sponsor__c);
        // asserts for mem2 - hero sponsor (1); supporter individual (2)
        system.assertEquals(null,mems[2].Ally_Sponsor__c);
        system.assertEquals(null,mems[2].Champion_Sponsor__c);
        system.assertEquals(null,mems[2].Friend_Individual__c);
        system.assertEquals(1,mems[2].Hero_Sponsor__c);
        system.assertEquals(null,mems[2].Platinum_Hero__c);
        system.assertEquals(2,mems[2].Supporter_Individual__c);
        system.assertEquals(null,mems[2].Valor_Sponsor__c);
        // asserts for mem3 - friend individual (1); valor sponsor (1)
        system.assertEquals(null,mems[3].Ally_Sponsor__c);
        system.assertEquals(null,mems[3].Champion_Sponsor__c);
        system.assertEquals(1,mems[3].Friend_Individual__c);
        system.assertEquals(null,mems[3].Hero_Sponsor__c);
        system.assertEquals(null,mems[3].Platinum_Hero__c);
        system.assertEquals(null,mems[3].Supporter_Individual__c);
        system.assertEquals(1,mems[3].Valor_Sponsor__c);
        // asserts for campaign - ally sponsor (1); champion sponsor (1); friend individual (1); hero sponsor (1);
        // platinum hero (1); supporter individual (4); valor sponsor (1)
        system.assertEquals(1,camp.Ally_Sponsorships__c);
        system.assertEquals(1,camp.Champion_Sponsorships__c);
        system.assertEquals(1,camp.Friend_Individual_Tickets__c);
        system.assertEquals(1,camp.Hero_Sponsorships__c);
        system.assertEquals(1,camp.Platinum_Hero_Sponsorships__c);
        system.assertEquals(4,camp.Supporter_Individual_Tickets__c);
        system.assertEquals(1,camp.Valor_Sponsorships__c);
    }
    
    static testMethod void plusEqualsPosTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='peCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contacts
        List<Contact> cons = new List<Contact>();
        cons.add(new Contact(FirstName='ally',LastName='tix',Email='allytix@test.test'));
        cons.add(new Contact(FirstName='champ',LastName='tix',Email='champtix@test.test'));
        cons.add(new Contact(FirstName='frnd',LastName='tix',Email='frndtix@test.test'));
        cons.add(new Contact(FirstName='hero',LastName='tix',Email='herotix@test.test'));
        cons.add(new Contact(FirstName='plat',LastName='tix',Email='plattix@test.test'));
        cons.add(new Contact(FirstName='supp',LastName='tix',Email='supptix@test.test'));
        cons.add(new Contact(FirstName='valor',LastName='tix',Email='valortix@test.test'));
        insert cons;
        
        // create the campaign members - add some w/ tix
        List<CampaignMember> mems = new List<CampaignMember>();
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[0].Id,Ally_Sponsor__c=1));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[1].Id,Champion_Sponsor__c=1));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[2].Id,Friend_Individual__c=1));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[3].Id,Hero_Sponsor__c=1));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[4].Id,Platinum_Hero__c=1));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[5].Id,Supporter_Individual__c=1));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[6].Id,Valor_Sponsor__c=1));
        insert mems;
        
        // create the sponsorships/tickets
        List<Sponsorship_Ticket__c> sts = new List<Sponsorship_Ticket__c>();
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[0].Id,Type__c='Ally Sponsor',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[1].Id,Type__c='Champion Sponsor',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[2].Id,Type__c='Friend Individual',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[3].Id,Type__c='Hero Sponsor',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[4].Id,Type__c='Platinum Hero',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[5].Id,Type__c='Supporter Individual',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[6].Id,Type__c='Valor Sponsor',Quantity__c=1));
        insert sts;
        
        // add sponsorship/ticket campaign member ids to a set
        Set<Id> memIds = new Set<Id>();
        memIds.add(sts[0].CampaignMemberId__c);
        memIds.add(sts[1].CampaignMemberId__c);
        memIds.add(sts[2].CampaignMemberId__c);
        memIds.add(sts[3].CampaignMemberId__c);
        memIds.add(sts[4].CampaignMemberId__c);
        memIds.add(sts[5].CampaignMemberId__c);
        memIds.add(sts[6].CampaignMemberId__c);
        
        // query for the campaign member and campaign
        mems = [SELECT CampaignId, Ally_Sponsor__c, Champion_Sponsor__c, Friend_Individual__c, Hero_Sponsor__c, Platinum_Hero__c, Supporter_Individual__c, Valor_Sponsor__c FROM CampaignMember WHERE Id =: memIds];
        camp = [SELECT Ally_Sponsorships__c, Champion_Sponsorships__c, Friend_Individual_Tickets__c, Hero_Sponsorships__c, Platinum_Hero_Sponsorships__c, Supporter_Individual_Tickets__c, Valor_Sponsorships__c FROM Campaign WHERE Id =: mems[0].CampaignId];
        
        // asserts for mem0 - ally sponsor (2)
        system.assertEquals(2,mems[0].Ally_Sponsor__c);
        system.assertEquals(null,mems[0].Champion_Sponsor__c);
        system.assertEquals(null,mems[0].Friend_Individual__c);
        system.assertEquals(null,mems[0].Hero_Sponsor__c);
        system.assertEquals(null,mems[0].Platinum_Hero__c);
        system.assertEquals(null,mems[0].Supporter_Individual__c);
        system.assertEquals(null,mems[0].Valor_Sponsor__c);
        // asserts for mem1 - champion sponsor (2)
        system.assertEquals(null,mems[1].Ally_Sponsor__c);
        system.assertEquals(2,mems[1].Champion_Sponsor__c);
        system.assertEquals(null,mems[1].Friend_Individual__c);
        system.assertEquals(null,mems[1].Hero_Sponsor__c);
        system.assertEquals(null,mems[1].Platinum_Hero__c);
        system.assertEquals(null,mems[1].Supporter_Individual__c);
        system.assertEquals(null,mems[1].Valor_Sponsor__c);
        // asserts for mem2 - friend individual (2)
        system.assertEquals(null,mems[2].Ally_Sponsor__c);
        system.assertEquals(null,mems[2].Champion_Sponsor__c);
        system.assertEquals(2,mems[2].Friend_Individual__c);
        system.assertEquals(null,mems[2].Hero_Sponsor__c);
        system.assertEquals(null,mems[2].Platinum_Hero__c);
        system.assertEquals(null,mems[2].Supporter_Individual__c);
        system.assertEquals(null,mems[2].Valor_Sponsor__c);
        // asserts for mem3 - hero sponsor (2)
        system.assertEquals(null,mems[3].Ally_Sponsor__c);
        system.assertEquals(null,mems[3].Champion_Sponsor__c);
        system.assertEquals(null,mems[3].Friend_Individual__c);
        system.assertEquals(2,mems[3].Hero_Sponsor__c);
        system.assertEquals(null,mems[3].Platinum_Hero__c);
        system.assertEquals(null,mems[3].Supporter_Individual__c);
        system.assertEquals(null,mems[3].Valor_Sponsor__c);
        // asserts for mem4 - platinum hero (2)
        system.assertEquals(null,mems[4].Ally_Sponsor__c);
        system.assertEquals(null,mems[4].Champion_Sponsor__c);
        system.assertEquals(null,mems[4].Friend_Individual__c);
        system.assertEquals(null,mems[4].Hero_Sponsor__c);
        system.assertEquals(2,mems[4].Platinum_Hero__c);
        system.assertEquals(null,mems[4].Supporter_Individual__c);
        system.assertEquals(null,mems[4].Valor_Sponsor__c);
        // asserts for mem5 - supporter individual (2)
        system.assertEquals(null,mems[5].Ally_Sponsor__c);
        system.assertEquals(null,mems[5].Champion_Sponsor__c);
        system.assertEquals(null,mems[5].Friend_Individual__c);
        system.assertEquals(null,mems[5].Hero_Sponsor__c);
        system.assertEquals(null,mems[5].Platinum_Hero__c);
        system.assertEquals(2,mems[5].Supporter_Individual__c);
        system.assertEquals(null,mems[5].Valor_Sponsor__c);
        // asserts for mem6 - valor sponsor (2)
        system.assertEquals(null,mems[6].Ally_Sponsor__c);
        system.assertEquals(null,mems[6].Champion_Sponsor__c);
        system.assertEquals(null,mems[6].Friend_Individual__c);
        system.assertEquals(null,mems[6].Hero_Sponsor__c);
        system.assertEquals(null,mems[6].Platinum_Hero__c);
        system.assertEquals(null,mems[6].Supporter_Individual__c);
        system.assertEquals(2,mems[6].Valor_Sponsor__c);
        // asserts for campaign - ally sponsor (2); champion sponsor (2); friend individual (2); hero sponsor (2);
        // platinum hero (2); supporter individual (2); valor sponsor (2)
        system.assertEquals(2,camp.Ally_Sponsorships__c);
        system.assertEquals(2,camp.Champion_Sponsorships__c);
        system.assertEquals(2,camp.Friend_Individual_Tickets__c);
        system.assertEquals(2,camp.Hero_Sponsorships__c);
        system.assertEquals(2,camp.Platinum_Hero_Sponsorships__c);
        system.assertEquals(2,camp.Supporter_Individual_Tickets__c);
        system.assertEquals(2,camp.Valor_Sponsorships__c);
    }
    
    static testMethod void singlePurchThreeFriendIndivNegTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='sptfiCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contact
        Contact con = new Contact(FirstName='sing',LastName='failF',Email='singfailF@test.test');
        insert con;
        
        // create the campaign member
        CampaignMember mem = new CampaignMember(CampaignId=camp.Id,ContactId=con.Id);
        insert mem;
        
        // create the sponsorship/ticket - 3 friend indiv - try/catch
        Sponsorship_Ticket__c st = new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Friend Individual',Quantity__c=3);
        try
        {
            insert st;
        }
        catch(dmlException e)
        {
            // assert for FIELD_CUSTOM_VALIDATION_ERROR
            system.assert(e.getMessage().contains('We have limited purchase of Friend Individual ($1250) to two tickets per purchaser. Please contact heroesgala@iava.org with any questions.'));
            system.debug('the error message is: ' + e.getMessage());
        }
    }
    
    static testMethod void goOverFriendIndivNegTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='sptfiCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contact
        Contact con = new Contact(FirstName='sing',LastName='failF',Email='singfailF@test.test');
        insert con;
        
        // create the campaign member - already has 1 friend indiv ticket
        CampaignMember mem = new CampaignMember(CampaignId=camp.Id,ContactId=con.Id,Friend_Individual__c=1);
        insert mem;
        
        // create the sponsorship/ticket - 2 friend indiv - try/catch
        Sponsorship_Ticket__c st = new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Friend Individual',Quantity__c=2);
        try
        {
            insert st;
        }
        catch(dmlException e)
        {
            // assert for FIELD_CUSTOM_VALIDATION_ERROR
            system.assert(e.getMessage().contains('We have limited purchase of Friend Individual ($1250) to two tickets per purchaser. Please contact heroesgala@iava.org with any questions.'));
            system.debug('the error message is: ' + e.getMessage());
        }
    }
    
    static testMethod void singlePurchFiveSupIndivNegTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='spfsiCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contact
        Contact con = new Contact(FirstName='sing',LastName='failS',Email='singfailS@test.test');
        insert con;
        
        // create the campaign member - with supporter indiv tickets
        CampaignMember mem = new CampaignMember(CampaignId=camp.Id,ContactId=con.Id,Supporter_Individual__c=2);
        insert mem;
        
        // create the sponsorship/ticket - go over sup indiv - try/catch
        Sponsorship_Ticket__c st = new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Supporter Individual',Quantity__c=3);
        try
        {
            insert st;
        }
        catch(dmlException e)
        {
            // assert for FIELD_CUSTOM_VALIDATION_ERROR
            system.assert(e.getMessage().contains('We have limited purchase of Supporter Individual ($2500) to four tickets per purchaser. Please contact heroesgala@iava.org with any questions.'));
            system.debug('the error message is: ' + e.getMessage());
        }
    }
    
    static testMethod void goOverOnMemberSideNegTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='gomsCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contact
        Contact con = new Contact(FirstName='already',LastName='tixF',Email='alreadytixF@test.test');
        insert con;
        
        // create the campaign member - go over indiv tix - try/catch
        CampaignMember mem = new CampaignMember(CampaignId=camp.Id,ContactId=con.Id,Friend_Individual__c=3);
        try
        {
            insert mem;
        }
        catch(dmlException e)
        {
            // assert for FIELD_CUSTOM_VALIDATION_ERROR
            system.assert(e.getMessage().contains('We have limited purchase of Friend Individual ($1250) to two tickets per purchaser.'));
            system.debug('the error message is: ' + e.getMessage());
        }
    }
    
    static testMethod void goOverFrndOnCampaignSideNegTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='gocsCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contacts
        List<Contact> cons = new List<Contact>();
        cons.add(new Contact(FirstName='over',LastName='camp0',Email='overcamp0@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp1',Email='overcamp1@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp2',Email='overcamp2@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp3',Email='overcamp3@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp4',Email='overcamp4@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp5',Email='overcamp5@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp6',Email='overcamp6@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp7',Email='overcamp7@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp8',Email='overcamp8@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp9',Email='overcamp9@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp10',Email='overcamp10@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp11',Email='overcamp11@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp12',Email='overcamp12@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp13',Email='overcamp13@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp14',Email='overcamp14@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp15',Email='overcamp15@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp16',Email='overcamp16@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp17',Email='overcamp17@test.test'));
        insert cons;
        
        // create the campaign members - all but one have indiv tix
        List<CampaignMember> mems = new List<CampaignMember>();
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[0].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[1].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[2].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[3].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[4].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[5].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[6].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[7].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[8].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[9].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[10].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[11].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[12].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[13].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[14].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[15].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[16].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[17].Id,Friend_Individual__c=2));
        insert mems;
        
        // create the sponsorships/tickets - go over indiv tix - try/catch
        Sponsorship_Ticket__c st = new Sponsorship_Ticket__c(CampaignMemberId__c=mems[9].Id,Type__c='Friend Individual',Quantity__c=2);
        try
        {
            insert st;
        }
        catch(dmlException e)
        {
            // assert for FIELD_CUSTOM_VALIDATION_ERROR
            system.assert(e.getMessage().contains('We have limited the sale of Friend Individual ($1250) to 35 tickets'));
            system.debug('the error message is: ' + e.getMessage());
        }
    }
    
    static testMethod void goOverSupOnCampaignSideNegTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='gocsCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contacts
        List<Contact> cons = new List<Contact>();
        cons.add(new Contact(FirstName='over',LastName='camp0',Email='overcamp0@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp1',Email='overcamp1@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp2',Email='overcamp2@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp3',Email='overcamp3@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp4',Email='overcamp4@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp5',Email='overcamp5@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp6',Email='overcamp6@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp7',Email='overcamp7@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp8',Email='overcamp8@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp9',Email='overcamp9@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp10',Email='overcamp10@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp11',Email='overcamp11@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp12',Email='overcamp12@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp13',Email='overcamp13@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp14',Email='overcamp14@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp15',Email='overcamp15@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp16',Email='overcamp16@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp17',Email='overcamp17@test.test'));
        insert cons;
        
        // create the campaign members - all but one have indiv tix
        List<CampaignMember> mems = new List<CampaignMember>();
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[0].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[1].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[2].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[3].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[4].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[5].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[6].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[7].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[8].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[9].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[10].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[11].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[12].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[13].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[14].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[15].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[16].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[17].Id,Supporter_Individual__c=4));
        insert mems;
        
        // create the sponsorships/tickets - go over indiv tix - try/catch
        Sponsorship_Ticket__c st = new Sponsorship_Ticket__c(CampaignMemberId__c=mems[9].Id,Type__c='Supporter Individual',Quantity__c=4);
        try
        {
            insert st;
        }
        catch(dmlException e)
        {
            // assert for FIELD_CUSTOM_VALIDATION_ERROR
            system.assert(e.getMessage().contains('We have limited the sale of Supporter Individual ($2500) to 70 tickets'));
            system.debug('the error message is: ' + e.getMessage());
        }
    }
    
    static testMethod void alreadyOverFrndOnCampaignSideNegTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='aocsCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contacts
        List<Contact> cons = new List<Contact>();
        cons.add(new Contact(FirstName='over',LastName='camp0',Email='overcamp0@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp1',Email='overcamp1@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp2',Email='overcamp2@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp3',Email='overcamp3@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp4',Email='overcamp4@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp5',Email='overcamp5@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp6',Email='overcamp6@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp7',Email='overcamp7@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp8',Email='overcamp8@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp9',Email='overcamp9@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp10',Email='overcamp10@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp11',Email='overcamp11@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp12',Email='overcamp12@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp13',Email='overcamp13@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp14',Email='overcamp14@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp15',Email='overcamp15@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp16',Email='overcamp16@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp17',Email='overcamp17@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp18',Email='overcamp18@test.test'));
        insert cons;
        
        // create the campaign members - all but one have indiv tix
        List<CampaignMember> mems = new List<CampaignMember>();
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[0].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[1].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[2].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[3].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[4].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[5].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[6].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[7].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[8].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[9].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[10].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[11].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[12].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[13].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[14].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[15].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[16].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[17].Id,Friend_Individual__c=2));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[18].Id,Friend_Individual__c=2));
        insert mems;
        
        // create the sponsorships/tickets - go over indiv tix - try/catch
        Sponsorship_Ticket__c st = new Sponsorship_Ticket__c(CampaignMemberId__c=mems[9].Id,Type__c='Friend Individual',Quantity__c=2);
        try
        {
            insert st;
        }
        catch(dmlException e)
        {
            // assert for FIELD_CUSTOM_VALIDATION_ERROR
            system.assert(e.getMessage().contains('We have limited the sale of Friend Individual ($1250) to 35 tickets'));
            system.debug('the error message is: ' + e.getMessage());
        }
    }
    
    static testMethod void alreadyOverSupOnCampaignSideNegTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='aocsCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contacts
        List<Contact> cons = new List<Contact>();
        cons.add(new Contact(FirstName='over',LastName='camp0',Email='overcamp0@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp1',Email='overcamp1@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp2',Email='overcamp2@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp3',Email='overcamp3@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp4',Email='overcamp4@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp5',Email='overcamp5@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp6',Email='overcamp6@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp7',Email='overcamp7@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp8',Email='overcamp8@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp9',Email='overcamp9@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp10',Email='overcamp10@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp11',Email='overcamp11@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp12',Email='overcamp12@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp13',Email='overcamp13@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp14',Email='overcamp14@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp15',Email='overcamp15@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp16',Email='overcamp16@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp17',Email='overcamp17@test.test'));
        cons.add(new Contact(FirstName='over',LastName='camp18',Email='overcamp18@test.test'));
        insert cons;
        
        // create the campaign members - all but one have indiv tix
        List<CampaignMember> mems = new List<CampaignMember>();
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[0].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[1].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[2].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[3].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[4].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[5].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[6].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[7].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[8].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[9].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[10].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[11].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[12].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[13].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[14].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[15].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[16].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[17].Id,Supporter_Individual__c=4));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[18].Id,Supporter_Individual__c=4));
        insert mems;
        
        // create the sponsorships/tickets - go over indiv tix - try/catch
        Sponsorship_Ticket__c st = new Sponsorship_Ticket__c(CampaignMemberId__c=mems[9].Id,Type__c='Supporter Individual',Quantity__c=4);
        try
        {
            insert st;
        }
        catch(dmlException e)
        {
            // assert for FIELD_CUSTOM_VALIDATION_ERROR
            system.assert(e.getMessage().contains('We have limited the sale of Supporter Individual ($2500) to 70 tickets'));
            system.debug('the error message is: ' + e.getMessage());
        }
    }
    
    static testMethod void updateTicketsPositiveTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='utCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contacts
        List<Contact> cons = new List<Contact>();
        cons.add(new Contact(FirstName='ally',LastName='tix',Email='allytix@test.test'));
        cons.add(new Contact(FirstName='champ',LastName='tix',Email='champtix@test.test'));
        cons.add(new Contact(FirstName='frnd',LastName='tix',Email='frndtix@test.test'));
        cons.add(new Contact(FirstName='hero',LastName='tix',Email='herotix@test.test'));
        cons.add(new Contact(FirstName='plat',LastName='tix',Email='plattix@test.test'));
        cons.add(new Contact(FirstName='supp',LastName='tix',Email='supptix@test.test'));
        cons.add(new Contact(FirstName='valor',LastName='tix',Email='valortix@test.test'));
        insert cons;
        
        // create the campaign members - add some w/ tix
        List<CampaignMember> mems = new List<CampaignMember>();
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[0].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[1].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[2].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[3].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[4].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[5].Id));
        mems.add(new CampaignMember(CampaignId=camp.Id,ContactId=cons[6].Id));
        insert mems;
        
        // create the sponsorships/tickets
        List<Sponsorship_Ticket__c> sts = new List<Sponsorship_Ticket__c>();
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[0].Id,Type__c='Ally Sponsor',Quantity__c=3));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[1].Id,Type__c='Champion Sponsor',Quantity__c=2));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[2].Id,Type__c='Friend Individual',Quantity__c=2));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[3].Id,Type__c='Hero Sponsor',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[4].Id,Type__c='Platinum Hero',Quantity__c=5));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[5].Id,Type__c='Supporter Individual',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mems[6].Id,Type__c='Valor Sponsor',Quantity__c=4));
        insert sts;
        
        // add sponsorship/ticket campaign member ids to a set
        Set<Id> memIds = new Set<Id>();
        memIds.add(sts[0].CampaignMemberId__c);
        memIds.add(sts[1].CampaignMemberId__c);
        memIds.add(sts[2].CampaignMemberId__c);
        memIds.add(sts[3].CampaignMemberId__c);
        memIds.add(sts[4].CampaignMemberId__c);
        memIds.add(sts[5].CampaignMemberId__c);
        memIds.add(sts[6].CampaignMemberId__c);
        
        sts[0].Quantity__c = 1;
        sts[1].Quantity__c = 1;
        sts[2].Quantity__c = 1;
        sts[3].Quantity__c = 2;
        sts[4].Quantity__c = 1;
        sts[5].Quantity__c = 4;
        sts[6].Quantity__c = 1;
        
        test.startTest();
        update sts;
        test.stopTest();
        
        // query for the campaign member and campaign
        mems = [SELECT CampaignId, Ally_Sponsor__c, Champion_Sponsor__c, Friend_Individual__c, Hero_Sponsor__c, Platinum_Hero__c, Supporter_Individual__c, Valor_Sponsor__c FROM CampaignMember WHERE Id =: memIds];
        camp = [SELECT Ally_Sponsorships__c, Champion_Sponsorships__c, Friend_Individual_Tickets__c, Hero_Sponsorships__c, Platinum_Hero_Sponsorships__c, Supporter_Individual_Tickets__c, Valor_Sponsorships__c FROM Campaign WHERE Id =: mems[0].CampaignId];
        
        // asserts for mem0 - ally sponsor (1)
        system.assertEquals(1,mems[0].Ally_Sponsor__c);
        system.assertEquals(null,mems[0].Champion_Sponsor__c);
        system.assertEquals(null,mems[0].Friend_Individual__c);
        system.assertEquals(null,mems[0].Hero_Sponsor__c);
        system.assertEquals(null,mems[0].Platinum_Hero__c);
        system.assertEquals(null,mems[0].Supporter_Individual__c);
        system.assertEquals(null,mems[0].Valor_Sponsor__c);
        // asserts for mem1 - champion sponsor (1)
        system.assertEquals(null,mems[1].Ally_Sponsor__c);
        system.assertEquals(1,mems[1].Champion_Sponsor__c);
        system.assertEquals(null,mems[1].Friend_Individual__c);
        system.assertEquals(null,mems[1].Hero_Sponsor__c);
        system.assertEquals(null,mems[1].Platinum_Hero__c);
        system.assertEquals(null,mems[1].Supporter_Individual__c);
        system.assertEquals(null,mems[1].Valor_Sponsor__c);
        // asserts for mem2 - friend individual (1)
        system.assertEquals(null,mems[2].Ally_Sponsor__c);
        system.assertEquals(null,mems[2].Champion_Sponsor__c);
        system.assertEquals(1,mems[2].Friend_Individual__c);
        system.assertEquals(null,mems[2].Hero_Sponsor__c);
        system.assertEquals(null,mems[2].Platinum_Hero__c);
        system.assertEquals(null,mems[2].Supporter_Individual__c);
        system.assertEquals(null,mems[2].Valor_Sponsor__c);
        // asserts for mem3 - hero sponsor (2)
        system.assertEquals(null,mems[3].Ally_Sponsor__c);
        system.assertEquals(null,mems[3].Champion_Sponsor__c);
        system.assertEquals(null,mems[3].Friend_Individual__c);
        system.assertEquals(2,mems[3].Hero_Sponsor__c);
        system.assertEquals(null,mems[3].Platinum_Hero__c);
        system.assertEquals(null,mems[3].Supporter_Individual__c);
        system.assertEquals(null,mems[3].Valor_Sponsor__c);
        // asserts for mem4 - platinum hero (1)
        system.assertEquals(null,mems[4].Ally_Sponsor__c);
        system.assertEquals(null,mems[4].Champion_Sponsor__c);
        system.assertEquals(null,mems[4].Friend_Individual__c);
        system.assertEquals(null,mems[4].Hero_Sponsor__c);
        system.assertEquals(1,mems[4].Platinum_Hero__c);
        system.assertEquals(null,mems[4].Supporter_Individual__c);
        system.assertEquals(null,mems[4].Valor_Sponsor__c);
        // asserts for mem5 - supporter individual (4)
        system.assertEquals(null,mems[5].Ally_Sponsor__c);
        system.assertEquals(null,mems[5].Champion_Sponsor__c);
        system.assertEquals(null,mems[5].Friend_Individual__c);
        system.assertEquals(null,mems[5].Hero_Sponsor__c);
        system.assertEquals(null,mems[5].Platinum_Hero__c);
        system.assertEquals(4,mems[5].Supporter_Individual__c);
        system.assertEquals(null,mems[5].Valor_Sponsor__c);
        // asserts for mem6 - valor sponsor (1)
        system.assertEquals(null,mems[6].Ally_Sponsor__c);
        system.assertEquals(null,mems[6].Champion_Sponsor__c);
        system.assertEquals(null,mems[6].Friend_Individual__c);
        system.assertEquals(null,mems[6].Hero_Sponsor__c);
        system.assertEquals(null,mems[6].Platinum_Hero__c);
        system.assertEquals(null,mems[6].Supporter_Individual__c);
        system.assertEquals(1,mems[6].Valor_Sponsor__c);
        // asserts for campaign - ally sponsor (1); champion sponsor (1); friend individual (1); hero sponsor (2);
        // platinum hero (1); supporter individual (4); valor sponsor (1)
        system.assertEquals(1,camp.Ally_Sponsorships__c);
        system.assertEquals(1,camp.Champion_Sponsorships__c);
        system.assertEquals(1,camp.Friend_Individual_Tickets__c);
        system.assertEquals(2,camp.Hero_Sponsorships__c);
        system.assertEquals(1,camp.Platinum_Hero_Sponsorships__c);
        system.assertEquals(4,camp.Supporter_Individual_Tickets__c);
        system.assertEquals(1,camp.Valor_Sponsorships__c);
    }
    
    static testMethod void deleteTicketsPositiveTest()
    {
        // create the campaign
        Campaign camp = new Campaign(Name='utCampaign',AIR_Required__c=false);
        insert camp;
        
        // create the contact
        Contact con = new Contact(FirstName='all',LastName='tix',Email='allytix@test.test');
        insert con;
        
        // create the campaign member
        CampaignMember mem = new CampaignMember(CampaignId=camp.Id,ContactId=con.Id);
        insert mem;
        
        // create the sponsorships/tickets
        List<Sponsorship_Ticket__c> sts = new List<Sponsorship_Ticket__c>();
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Ally Sponsor',Quantity__c=3));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Champion Sponsor',Quantity__c=2));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Friend Individual',Quantity__c=2));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Hero Sponsor',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Platinum Hero',Quantity__c=5));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Supporter Individual',Quantity__c=1));
        sts.add(new Sponsorship_Ticket__c(CampaignMemberId__c=mem.Id,Type__c='Valor Sponsor',Quantity__c=4));
        insert sts;
                
        test.startTest();
        delete sts;
        test.stopTest();
        
        // query for the campaign member and campaign
        mem = [SELECT CampaignId, Ally_Sponsor__c, Champion_Sponsor__c, Friend_Individual__c, Hero_Sponsor__c, Platinum_Hero__c, Supporter_Individual__c, Valor_Sponsor__c FROM CampaignMember WHERE Id =: mem.Id];
        camp = [SELECT Ally_Sponsorships__c, Champion_Sponsorships__c, Friend_Individual_Tickets__c, Hero_Sponsorships__c, Platinum_Hero_Sponsorships__c, Supporter_Individual_Tickets__c, Valor_Sponsorships__c FROM Campaign WHERE Id =: mem.CampaignId];
        
        // asserts for mem - ally sponsor (0); champion sponsor (0); friend individual (0); hero sponsor (0);
        // platinum hero (0); supporter individual (0); valor sponsor (0)
        system.assertEquals(0,mem.Ally_Sponsor__c);
        system.assertEquals(0,mem.Champion_Sponsor__c);
        system.assertEquals(0,mem.Friend_Individual__c);
        system.assertEquals(0,mem.Hero_Sponsor__c);
        system.assertEquals(0,mem.Platinum_Hero__c);
        system.assertEquals(0,mem.Supporter_Individual__c);
        system.assertEquals(0,mem.Valor_Sponsor__c);
        // asserts for campaign - ally sponsor (0); champion sponsor (0); friend individual (0); hero sponsor (0);
        // platinum hero (0); supporter individual (0); valor sponsor (0)
        system.assertEquals(0,camp.Ally_Sponsorships__c);
        system.assertEquals(0,camp.Champion_Sponsorships__c);
        system.assertEquals(0,camp.Friend_Individual_Tickets__c);
        system.assertEquals(0,camp.Hero_Sponsorships__c);
        system.assertEquals(0,camp.Platinum_Hero_Sponsorships__c);
        system.assertEquals(0,camp.Supporter_Individual_Tickets__c);
        system.assertEquals(0,camp.Valor_Sponsorships__c);
    }
}