trigger weResultAfter on WE_FW8_NP__WESearchResult__c (after insert, after update)
{
    Map<Id,String> estGiving = new Map<Id,String>(); // map contact id (key) to estimated annual donations (value)
    Map<Id,String> givingCap = new Map<Id,String>(); // map contact id (key) to gift capacity range (value)
    Map<Id,String> netWorth = new Map<Id,String>(); // map contact id (key) to net worth (value)
    Map<Id,String> p2gScore = new Map<Id,String>(); // map contact id (key) to p2g score (value)
    Map<Id,String> p2gDesc = new Map<Id,String>(); // map contact id (key) to p2g description (value)
    Map<Id,String> totAssets = new Map<Id,String>(); // map contact id (key) to total assets (value)
    Map<Id,Integer> weAge = new Map<Id,Integer>(); // map contact id (key) to age (value)
    List<Contact> updCon = new List<Contact>(); // list of contacts to update
       
    for(WE_FW8_NP__WESearchResult__c r: trigger.new)
    {
        if(r.WE_FW8_NP__Contact__c != null)
        {
            system.debug('there is a contact to update: ' + r.WE_FW8_NP__Contact__c);
            if(r.WE_FW8_NP__EAD__c != null && r.WE_FW8_NP__EAD__c != 'Unable to rate')
            {
                estGiving.put(r.WE_FW8_NP__Contact__c, r.WE_FW8_NP__EAD__c);
                system.debug('estimated annual donations: ' + r.WE_FW8_NP__EAD__c);
            } // if the result has estimated annual donations, map the contact to the estimated donations so we can update the contact
            else{system.debug('no estimated annual donations or unable to rate');}
            
            if(r.WE_FW8_NP__GiftCapacityRange__c != null && r.WE_FW8_NP__GiftCapacityRange__c != 'Unable to rate')
            {
                givingCap.put(r.WE_FW8_NP__Contact__c, r.WE_FW8_NP__GiftCapacityRange__c);
                system.debug('gift capacity range: ' + r.WE_FW8_NP__GiftCapacityRange__c);
            } // if the result has a gift capacity range, map the contact to the range so we can update the contact
            else{system.debug('no gift capacity range or unable to rate');}
            
            if(r.WE_FW8_NP__NetworthRange__c != null && r.WE_FW8_NP__NetworthRange__c != 'Unable to rate')
            {
                netWorth.put(r.WE_FW8_NP__Contact__c, r.WE_FW8_NP__NetworthRange__c);
                system.debug('net worth: ' + r.WE_FW8_NP__NetworthRange__c);
            } // if the result has a net worth, map the contact to the net worth so we can update the contact
            else{system.debug('no net worth or unable to rate');}
            
            if(r.WE_FW8_NP__P2G_SCORE__c != null && r.WE_FW8_NP__P2G_Description__c != 'Unmatched')
            {
                p2gScore.put(r.WE_FW8_NP__Contact__c, r.WE_FW8_NP__P2G_SCORE__c);
                system.debug('p2g score: ' + r.WE_FW8_NP__P2G_SCORE__c);
            } // if the result has a p2g score, map the contact to the score so we can update the contact
            else{system.debug('no p2g score or umatched');}
            
            if(r.WE_FW8_NP__P2G_Description__c != null && r.WE_FW8_NP__P2G_Description__c != 'Unmatched')
            {
                p2gDesc.put(r.WE_FW8_NP__Contact__c, r.WE_FW8_NP__P2G_Description__c);
                system.debug('p2g description: ' + r.WE_FW8_NP__P2G_Description__c);
            } // if the result has a p2g description, map the contact to the description so we can update the contact
            else{system.debug('no p2g description or umatched');}
            
            if(r.WE_FW8_NP__AssetRange__c != null && r.WE_FW8_NP__AssetRange__c != 'Unable to rate')
            {
                totAssets.put(r.WE_FW8_NP__Contact__c, r.WE_FW8_NP__AssetRange__c);
                system.debug('total assets: ' + r.WE_FW8_NP__AssetRange__c);
            } // if the result has total assets, map the contact to the assets so we can update the contact
            else{system.debug('no total assets or unable to rate');}
            
            if(r.WE_FW8_NP__GC_AGE_USED__c != null && r.WE_FW8_NP__GC_AGE_USED__c != 'Unable to rate')
            {
                weAge.put(r.WE_FW8_NP__Contact__c, integer.valueOf(r.WE_FW8_NP__GC_AGE_USED__c));
                system.debug('reported age: ' + r.WE_FW8_NP__GC_AGE_USED__c);
            } // if the result has a reported age, map the contact to the age so we can update the contact
            else{system.debug('no reported age or unable to rate');}
        } // if the result is related to a contact
        else{system.debug('no contact on the results record');}
    } // loop through result records in trigger new
    
    if(!estGiving.isEmpty() || !givingCap.isEmpty() || !netWorth.isEmpty() || !p2gScore.isEmpty() || !p2gDesc.isEmpty() || !totAssets.isEmpty() || !weAge.isEmpty())
    {
        for(Contact c: [SELECT Id, WE_Results_Date__c, WE_Estimated_Annual_Donations__c, WE_Gift_Capacity_Range__c, WE_Net_Worth__c, WE_P2G_Score__c, WE_P2G_Description__c, WE_Total_Assets__c, Age_Number__c FROM Contact WHERE Id IN: estGiving.keySet() OR Id IN: givingCap.keySet() OR Id IN: netWorth.keySet() OR Id IN: p2gScore.keySet() OR Id IN: p2gDesc.keySet() OR Id IN: totAssets.keySet() OR Id IN: weAge.keySet()])
        {
            c.WE_Results_Date__c = date.today();
            if(estGiving.containsKey(c.Id))
            {
                c.WE_Estimated_Annual_Donations__c = estGiving.get(c.Id);
            }
            if(givingCap.containsKey(c.Id))
            {
                c.WE_Gift_Capacity_Range__c = givingCap.get(c.Id);
            }
            if(netWorth.containsKey(c.Id))
            {
                c.WE_Net_Worth__c = netWorth.get(c.Id);
            }
            if(p2gScore.containsKey(c.Id))
            {
                c.WE_P2G_Score__c = p2gScore.get(c.Id);
            }
            if(p2gDesc.containsKey(c.Id))
            {
                c.WE_P2G_Description__c = p2gDesc.get(c.Id);
            }
            if(totAssets.containsKey(c.Id))
            {
                c.WE_Total_Assets__c = totAssets.get(c.Id);
            }
            if(weAge.containsKey(c.Id))
            {
                c.Age_Number__c = weAge.get(c.Id);
            }
            updCon.add(c);
            system.debug('contact added to list of records to update: ' + c);
        } // loop through contacts in the maps and set the wealth engine mirror fields
    } // if the map isn't empty (there were results to push to a contact)
    
    system.debug('list of contacts to update: ' + updCon);
    
    if(!updCon.isEmpty())
    {
        update updCon;
    } // if there are contacts to update, update them
}