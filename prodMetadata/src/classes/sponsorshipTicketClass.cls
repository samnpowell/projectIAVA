public class sponsorshipTicketClass
{
    public static void ticketInsertedUpdateMember(List<Sponsorship_Ticket__c> newTicketRecords)
    {
        String timingI = 'Insert';
        List<CampaignMember> cmUpd = new List<CampaignMember>(); // list of campaign members to update
        
        Map<Id,Integer> allyTixI = getAllyTix(newTicketRecords,null,timingI); // map campaign member id to number of ally sponsorships
        Map<Id,Integer> champTixI = getChampTix(newTicketRecords,null,timingI); // map campaign member id to number of champion sponsorships
        Map<Id,Integer> frndTixI = getFrndTix(newTicketRecords,null,timingI); // map campaign member id to number of friend indiv tickets
        Map<Id,Integer> heroTixI = getHeroTix(newTicketRecords,null,timingI); // map campaign member id to number of hero sponsorships
        Map<Id,Integer> platTixI = getPlatTix(newTicketRecords,null,timingI); // map campaign member id to number of platinum hero sponsorships
        Map<Id,Integer> suppTixI = getSuppTix(newTicketRecords,null,timingI); // map campaign member id to number of supporter indiv tickets
        Map<Id,Integer> valorTixI = getValorTix(newTicketRecords,null,timingI); // map campaign member id to number of valor sponsorships
        
        system.debug('did i map any ally sponsors? ' + allyTixI);
        system.debug('did i map any champion sponsors? ' + champTixI);
        system.debug('did i map any friend individuals? ' + frndTixI);
        system.debug('did i map any hero sponsors? ' + heroTixI);
        system.debug('did i map any platinum heroes? ' + platTixI);
        system.debug('did i map any supporter individuals? ' + suppTixI);
        system.debug('did i map any valor sponsors? ' + valorTixI);
        
        Set<Id> cmIds = getCMIds(allyTixI,champTixI,frndTixI,heroTixI,platTixI,suppTixI,valorTixI); // set of all campaign member ids to make the query loop easier to write
        system.debug('did i find any campaign member ids?' + cmIds);
                        
        if(!cmIds.isEmpty())
        {
            cmUpd = getCMToUpd(cmIds,allyTixI,champTixI,frndTixI,heroTixI,platTixI,suppTixI,valorTixI,timingI);
        }
        
        if(!cmUpd.isEmpty())
        {
            update cmUpd;
        }
    }
    
    public static void ticketUpdatedUpdateMember(List<Sponsorship_Ticket__c> newTicketRecords,Map<Id,Sponsorship_Ticket__c> oldTicketMap)
    {
        String timingU = 'Update';
        List<CampaignMember> cmUpd = new List<CampaignMember>(); // list of campaign members to update
        
        Map<Id,Integer> allyTixU = getAllyTix(newTicketRecords,oldTicketMap,timingU); // map campaign member id to number of ally sponsorships
        Map<Id,Integer> champTixU = getChampTix(newTicketRecords,oldTicketMap,timingU); // map campaign member id to number of champion sponsorships
        Map<Id,Integer> frndTixU = getFrndTix(newTicketRecords,oldTicketMap,timingU); // map campaign member id to number of friend indiv tickets
        Map<Id,Integer> heroTixU = getHeroTix(newTicketRecords,oldTicketMap,timingU); // map campaign member id to number of hero sponsorships
        Map<Id,Integer> platTixU = getPlatTix(newTicketRecords,oldTicketMap,timingU); // map campaign member id to number of platinum hero sponsorships
        Map<Id,Integer> suppTixU = getSuppTix(newTicketRecords,oldTicketMap,timingU); // map campaign member id to number of supporter indiv tickets
        Map<Id,Integer> valorTixU = getValorTix(newTicketRecords,oldTicketMap,timingU); // map campaign member id to number of valor sponsorships
        
        system.debug('did i map any ally sponsors? ' + allyTixU);
        system.debug('did i map any champion sponsors? ' + champTixU);
        system.debug('did i map any friend individuals? ' + frndTixU);
        system.debug('did i map any hero sponsors? ' + heroTixU);
        system.debug('did i map any platinum heroes? ' + platTixU);
        system.debug('did i map any supporter individuals? ' + suppTixU);
        system.debug('did i map any valor sponsors? ' + valorTixU);
        
        Set<Id> cmIds = getCMIds(allyTixU,champTixU,frndTixU,heroTixU,platTixU,suppTixU,valorTixU); // set of all campaign member ids to make the query loop easier to write
        system.debug('did i find any campaign member ids?' + cmIds);
        
        if(!cmIds.isEmpty())
        {
            cmUpd = getCMToUpd(cmIds,allyTixU,champTixU,frndTixU,heroTixU,platTixU,suppTixU,valorTixU,timingU);
        }
        
        if(!cmUpd.isEmpty())
        {
            update cmUpd;
        }
    }
    
    public static void ticketDeletedUpdateMember(List<Sponsorship_Ticket__c> oldTicketRecords)
    {
        String timingD = 'Delete';
        system.debug('now were running on ' + timingD);
        List<CampaignMember> cmUpd = new List<CampaignMember>(); // list of campaign members to update
        
        Map<Id,Integer> allyTixD = getAllyTix(oldTicketRecords,null,timingD); // map campaign member id to number of ally sponsorships
        Map<Id,Integer> champTixD = getChampTix(oldTicketRecords,null,timingD); // map campaign member id to number of champion sponsorships
        Map<Id,Integer> frndTixD = getFrndTix(oldTicketRecords,null,timingD); // map campaign member id to number of friend indiv tickets
        Map<Id,Integer> heroTixD = getHeroTix(oldTicketRecords,null,timingD); // map campaign member id to number of hero sponsorships
        Map<Id,Integer> platTixD = getPlatTix(oldTicketRecords,null,timingD); // map campaign member id to number of platinum hero sponsorships
        Map<Id,Integer> suppTixD = getSuppTix(oldTicketRecords,null,timingD); // map campaign member id to number of supporter indiv tickets
        Map<Id,Integer> valorTixD = getValorTix(oldTicketRecords,null,timingD); // map campaign member id to number of valor sponsorships
        
        system.debug('did i map any ally sponsors? ' + allyTixD);
        system.debug('did i map any champion sponsors? ' + champTixD);
        system.debug('did i map any friend individuals? ' + frndTixD);
        system.debug('did i map any hero sponsors? ' + heroTixD);
        system.debug('did i map any platinum heroes? ' + platTixD);
        system.debug('did i map any supporter individuals? ' + suppTixD);
        system.debug('did i map any valor sponsors? ' + valorTixD);
        
        Set<Id> cmIds = getCMIds(allyTixD,champTixD,frndTixD,heroTixD,platTixD,suppTixD,valorTixD); // set of all campaign member ids to make the query loop easier to write
        system.debug('did i find any campaign member ids (delete class)? ' + cmIds);
        
        if(!cmIds.isEmpty())
        {
            cmUpd = getCMToUpd(cmIds,allyTixD,champTixD,frndTixD,heroTixD,platTixD,suppTixD,valorTixD,timingD);
            system.debug('what updates am I making for the delete? ' + cmUpd);
        }
        
        if(!cmUpd.isEmpty())
        {
            update cmUpd;
        }
    }
    
    public static Map<Id,Integer> getAllyTix(List<Sponsorship_Ticket__c> stList, Map<Id,Sponsorship_Ticket__c> ostMap, String timing)
    {
        Map<Id,Integer> allyMap = new Map<Id,Integer>();
        for(Sponsorship_Ticket__c st: stList)
        {
            if(st.Type__c == 'Ally Sponsor')
            {
                if(timing == 'Insert')
                {
                    allyMap.put(st.CampaignMemberId__c,integer.valueOf(st.Quantity__c));
                }
                else if(timing == 'Update')
                {
                    Sponsorship_Ticket__c ost = ostMap.get(st.Id);
                    if(st.Quantity__c != ost.Quantity__c)
                    {
                        decimal tixD = st.Quantity__c - ost.Quantity__c;
                        integer tix = integer.valueOf(tixD);
                        allyMap.put(st.CampaignMemberId__c,tix);
                    }
                }
                else if(timing == 'Delete')
                {
                    integer dTix = integer.valueOf(st.Quantity__c);
                    integer negTix = dTix * -1;
                    system.debug('allyTix to remove ' + negTix);
                    allyMap.put(st.CampaignMemberId__c,negTix);
                }
            }
        }
        return allyMap;
    }
    
    public static Map<Id,Integer> getChampTix(List<Sponsorship_Ticket__c> stList, Map<Id,Sponsorship_Ticket__c> ostMap, String timing)
    {
        Map<Id,Integer> champMap = new Map<Id,Integer>();
        for(Sponsorship_Ticket__c st: stList)
        {
            if(st.Type__c == 'Champion Sponsor')
            {
                if(timing == 'Insert')
                {
                    champMap.put(st.CampaignMemberId__c,integer.valueOf(st.Quantity__c));
                }
                else if(timing == 'Update')
                {
                    Sponsorship_Ticket__c ost = ostMap.get(st.Id);
                    if(st.Quantity__c != ost.Quantity__c)
                    {
                        decimal tixD = st.Quantity__c - ost.Quantity__c;
                        integer tix = integer.valueOf(tixD);
                        champMap.put(st.CampaignMemberId__c,tix);
                    }
                }
                else if(timing == 'Delete')
                {
                    integer dTix = integer.valueOf(st.Quantity__c);
                    integer negTix = dTix * -1;
                    system.debug('champTix to remove ' + negTix);
                    champMap.put(st.CampaignMemberId__c,negTix);
                }
            }
        }
        return champMap;
    }
    
    public static Map<Id,Integer> getFrndTix(List<Sponsorship_Ticket__c> stList, Map<Id,Sponsorship_Ticket__c> ostMap, String timing)
    {
        Map<Id,Integer> frndMap = new Map<Id,Integer>();
        for(Sponsorship_Ticket__c st: stList)
        {
            if(st.Type__c == 'Friend Individual')
            {
                if(timing == 'Insert')
                {
                    frndMap.put(st.CampaignMemberId__c,integer.valueOf(st.Quantity__c));
                }
                else if(timing == 'Update')
                {
                    Sponsorship_Ticket__c ost = ostMap.get(st.Id);
                    if(st.Quantity__c != ost.Quantity__c)
                    {
                        decimal tixD = st.Quantity__c - ost.Quantity__c;
                        integer tix = integer.valueOf(tixD);
                        frndMap.put(st.CampaignMemberId__c,tix);
                    }
                }
                else if(timing == 'Delete')
                {
                    integer dTix = integer.valueOf(st.Quantity__c);
                    integer negTix = dTix * -1;
                    system.debug('frndTix to remove ' + negTix);
                    frndMap.put(st.CampaignMemberId__c,negTix);
                }
            }
        }
        return frndMap;
    }
    
    public static Map<Id,Integer> getHeroTix(List<Sponsorship_Ticket__c> stList, Map<Id,Sponsorship_Ticket__c> ostMap, String timing)
    {
        Map<Id,Integer> heroMap = new Map<Id,Integer>();
        for(Sponsorship_Ticket__c st: stList)
        {
            if(st.Type__c == 'Hero Sponsor')
            {
                if(timing == 'Insert')
                {
                    heroMap.put(st.CampaignMemberId__c,integer.valueOf(st.Quantity__c));
                }
                else if(timing == 'Update')
                {
                    Sponsorship_Ticket__c ost = ostMap.get(st.Id);
                    if(st.Quantity__c != ost.Quantity__c)
                    {
                        decimal tixD = st.Quantity__c - ost.Quantity__c;
                        integer tix = integer.valueOf(tixD);
                        heroMap.put(st.CampaignMemberId__c,tix);
                    }
                }
                else if(timing == 'Delete')
                {
                    integer dTix = integer.valueOf(st.Quantity__c);
                    integer negTix = dTix * -1;
                    system.debug('heroTix to remove ' + negTix);
                    heroMap.put(st.CampaignMemberId__c,negTix);
                }
            }
        }
        return heroMap;
    }
    
    public static Map<Id,Integer> getPlatTix(List<Sponsorship_Ticket__c> stList, Map<Id,Sponsorship_Ticket__c> ostMap, String timing)
    {
        Map<Id,Integer> platMap = new Map<Id,Integer>();
        for(Sponsorship_Ticket__c st: stList)
        {
            if(st.Type__c == 'Platinum Hero')
            {
                if(timing == 'Insert')
                {
                    platMap.put(st.CampaignMemberId__c,integer.valueOf(st.Quantity__c));
                }
                else if(timing == 'Update')
                {
                    Sponsorship_Ticket__c ost = ostMap.get(st.Id);
                    if(st.Quantity__c != ost.Quantity__c)
                    {
                        decimal tixD = st.Quantity__c - ost.Quantity__c;
                        integer tix = integer.valueOf(tixD);
                        platMap.put(st.CampaignMemberId__c,tix);
                    }
                }
                else if(timing == 'Delete')
                {
                    integer dTix = integer.valueOf(st.Quantity__c);
                    integer negTix = dTix * -1;
                    system.debug('platTix to remove ' + negTix);
                    platMap.put(st.CampaignMemberId__c,negTix);
                }
            }
        }
        return platMap;
    }
    
    public static Map<Id,Integer> getSuppTix(List<Sponsorship_Ticket__c> stList, Map<Id,Sponsorship_Ticket__c> ostMap, String timing)
    {
        Map<Id,Integer> suppMap = new Map<Id,Integer>();
        for(Sponsorship_Ticket__c st: stList)
        {
            if(st.Type__c == 'Supporter Individual')
            {
                if(timing == 'Insert')
                {
                    suppMap.put(st.CampaignMemberId__c,integer.valueOf(st.Quantity__c));
                }
                else if(timing == 'Update')
                {
                    Sponsorship_Ticket__c ost = ostMap.get(st.Id);
                    if(st.Quantity__c != ost.Quantity__c)
                    {
                        decimal tixD = st.Quantity__c - ost.Quantity__c;
                        integer tix = integer.valueOf(tixD);
                        suppMap.put(st.CampaignMemberId__c,tix);
                    }
                }
                else if(timing == 'Delete')
                {
                    integer dTix = integer.valueOf(st.Quantity__c);
                    integer negTix = dTix * -1;
                    system.debug('suppTix to remove ' + negTix);
                    suppMap.put(st.CampaignMemberId__c,negTix);
                }
            }
        }
        return suppMap;
    }
    
    public static Map<Id,Integer> getValorTix(List<Sponsorship_Ticket__c> stList, Map<Id,Sponsorship_Ticket__c> ostMap, String timing)
    {
        Map<Id,Integer> valorMap = new Map<Id,Integer>();
        for(Sponsorship_Ticket__c st: stList)
        {
            if(st.Type__c == 'Valor Sponsor')
            {
                if(timing == 'Insert')
                {
                    valorMap.put(st.CampaignMemberId__c,integer.valueOf(st.Quantity__c));
                }
                else if(timing == 'Update')
                {
                    Sponsorship_Ticket__c ost = ostMap.get(st.Id);
                    if(st.Quantity__c != ost.Quantity__c)
                    {
                        decimal tixD = st.Quantity__c - ost.Quantity__c;
                        integer tix = integer.valueOf(tixD);
                        valorMap.put(st.CampaignMemberId__c,tix);
                    }
                }
                else if(timing == 'Delete')
                {
                    integer dTix = integer.valueOf(st.Quantity__c);
                    integer negTix = dTix * -1;
                    system.debug('valorTix to remove ' + negTix);
                    valorMap.put(st.CampaignMemberId__c,negTix);
                }
            }
        }
        return valorMap;
    }
    
    public static Set<Id> getCMIds(Map<Id,Integer> ally, Map<Id,Integer> champ, Map<Id,Integer> frnd, Map<Id,Integer> hero, Map<Id,Integer> plat, Map<Id,Integer> supp, Map<Id,Integer> valor)
    {
        Set<Id> memIds = new Set<Id>();
        memIds.addAll(ally.keySet());
        memIds.addAll(champ.keySet());
        memIds.addAll(frnd.keySet());
        memIds.addAll(hero.keySet());
        memIds.addAll(plat.keySet());
        memIds.addAll(supp.keySet());
        memIds.addAll(valor.keySet());
        return memIds;
    }
    
    public static List<CampaignMember> getCMToUpd(Set<Id> mems, Map<Id,Integer> ally, Map<Id,Integer> champ, Map<Id,Integer> frnd, Map<Id,Integer> hero, Map<Id,Integer> plat, Map<Id,Integer> supp, Map<Id,Integer> valor, String timing)
    {
        List<CampaignMember> cmList = new List<CampaignMember>();
        for(CampaignMember cm: [SELECT Id, Ally_Sponsor__c, Champion_Sponsor__c, Friend_Individual__c, Hero_Sponsor__c, Platinum_Hero__c, Supporter_Individual__c, Valor_Sponsor__c, Campaign.Friend_Individual_Tickets__c, Campaign.Supporter_Individual_Tickets__c FROM CampaignMember WHERE Id IN: mems])
        {
            if(timing == 'Insert' && cm.Campaign.Friend_Individual_Tickets__c > 35)
            {
                throw new gala35FriendException('We have limited the sale of Friend Individual ($1250) to 35 tickets. Please contact heroesgala@iava.org with any questions.');
            }
            if(timing == 'Insert' && cm.Campaign.Supporter_Individual_Tickets__c > 70)
            {
                throw new gala70SuppException('We have limited the sale of Supporter Individual ($2500) to 70 tickets. Please contact heroesgala@iava.org with any questions.');
            }
            if(!ally.isEmpty() && ally.containsKey(cm.Id))
            {
                if(cm.Ally_Sponsor__c > 0)
                {
                    cm.Ally_Sponsor__c += ally.get(cm.Id);
                    system.debug('adding ' + ally.get(cm.Id) + ' tickets to ally');
                }
                else
                {
                    cm.Ally_Sponsor__c = ally.get(cm.Id);
                }
            }
            if(!champ.isEmpty() && champ.containsKey(cm.Id))
            {
                if(cm.Champion_Sponsor__c > 0)
                {
                    cm.Champion_Sponsor__c += champ.get(cm.Id);
                    system.debug('adding ' + champ.get(cm.Id) + ' tickets to champ');
                }
                else
                {
                    cm.Champion_Sponsor__c = champ.get(cm.Id);
                }
            }
            if(!frnd.isEmpty() && frnd.containsKey(cm.Id))
            {
                if(cm.Campaign.Friend_Individual_Tickets__c + frnd.get(cm.Id) > 35)
                {
                    throw new gala35FriendException('We have limited the sale of Friend Individual ($1250) to 35 tickets. Please contact heroesgala@iava.org with any questions.');
                }
                else if(cm.Friend_Individual__c > 0 && (cm.Friend_Individual__c + frnd.get(cm.Id) > 2))
                {
                    throw new gala2FriendPerException('We have limited purchase of Friend Individual ($1250) to two tickets per purchaser. Please contact heroesgala@iava.org with any questions.');
                }
                else if(cm.Friend_Individual__c > 0)
                {
                    cm.Friend_Individual__c += frnd.get(cm.Id);
                    system.debug('adding ' + frnd.get(cm.Id) + ' tickets to frnd');
                }
                else
                {
                    cm.Friend_Individual__c = frnd.get(cm.Id);
                }
            }
            if(!hero.isEmpty() && hero.containsKey(cm.Id))
            {
                if(cm.Hero_Sponsor__c > 0)
                {
                    cm.Hero_Sponsor__c += hero.get(cm.Id);
                    system.debug('adding ' + hero.get(cm.Id) + ' tickets to hero');
                }
                else
                {
                    cm.Hero_Sponsor__c = hero.get(cm.Id);
                }
            }
            if(!plat.isEmpty() && plat.containsKey(cm.Id))
            {
                if(cm.Platinum_Hero__c > 0)
                {
                    cm.Platinum_Hero__c += plat.get(cm.Id);
                    system.debug('adding ' + plat.get(cm.Id) + ' tickets to plat');
                }
                else
                {
                    cm.Platinum_Hero__c = plat.get(cm.Id);
                }
            }
            if(!supp.isEmpty() && supp.containsKey(cm.Id))
            {
                if(cm.Campaign.Supporter_Individual_Tickets__c + supp.get(cm.Id) > 70)
                {
                    throw new gala70SuppException('We have limited the sale of Supporter Individual ($2500) to 70 tickets. Please contact heroesgala@iava.org with any questions.');
                }
                else if(cm.Supporter_Individual__c > 0 && (cm.Supporter_Individual__c + supp.get(cm.Id) > 4))
                {
                    throw new gala4SuppPerException('We have limited purchase of Supporter Individual ($2500) to four tickets per purchaser. Please contact heroesgala@iava.org with any questions.');
                }
                else if(cm.Supporter_Individual__c > 0)
                {
                    cm.Supporter_Individual__c += supp.get(cm.Id);
                    system.debug('adding ' + supp.get(cm.Id) + ' tickets to supp');
                }
                else
                {
                    cm.Supporter_Individual__c = supp.get(cm.Id);
                }
                //system.debug('how many supporter individual tickets for ' + cm.Id + '? ' + supp.get(cm.Id));
            }
            if(!valor.isEmpty() && valor.containsKey(cm.Id))
            {
                if(cm.Valor_Sponsor__c > 0)
                {
                    cm.Valor_Sponsor__c += valor.get(cm.Id);
                    system.debug('adding ' + valor.get(cm.Id) + ' tickets to valor');
                }
                else
                {
                    cm.Valor_Sponsor__c = valor.get(cm.Id);
                }
            }
            cmList.add(cm);
        }
        return cmList;
    }
    
    public class gala35FriendException extends Exception {}
    public class gala70SuppException extends Exception {}
    public class gala2FriendPerException extends Exception {}
    public class gala4SuppPerException extends Exception {}
}