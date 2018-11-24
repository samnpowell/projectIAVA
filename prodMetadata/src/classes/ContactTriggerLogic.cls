/*
Copyright (c) 2010 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Mike Dannenfeldt, mike@etherios.com
*/
public class ContactTriggerLogic {

    public final static String CONFIRMED_VETERAN = 'Paperwork Accepted';
    public final static String CUSTOM_SETTINGS_NAME = 'Main';
    public final static String StubContact = '(Unknown)';

    // Called from ContactBeforeInsert.trigger to eliminate duplicate Stub Contacts
    public static List<Contact> kickDuplicateContacts(List<Contact> newContacts) {
        Set<String> eaddrs = new Set<String>();
        List<Contact> originals = new List<Contact>();
        for (Contact con : newContacts) if ((con.Name == StubContact) && (con.email != null)) eaddrs.add(con.email);
        if (eaddrs.size() == 0) return newContacts; // No eliminations required
        List<Contact> existing = [SELECT email FROM Contact WHERE Name = :StubContact AND email IN :eaddrs];
        eaddrs.clear();
        for (Contact con : existing) if (con.email != null) eaddrs.add(con.email);
        for (Contact con : newContacts)
            if ((con.Name == StubContact) && eaddrs.contains(con.email))
                con.addError('Contact ' + StubContact + ' with email address: ' + con.email + ' is a duplicate.');
            else {
                originals.add(con);
                if ((con.Name == StubContact) && (con.email != null)) eaddrs.add(con.email);
            }
        return originals;
    }
    
    // filters the contacts before generating membership IDs for the contacts.
    public static void generateMembershipIDs(List<Contact> contacts){
        // filter out those Contacts that already have a MembershipID or are not Confirmed
        List<Contact> filteredContacts = new List<Contact>();
        for(Contact c : contacts){
            if(c.Membership_ID__c==null && c.Paperwork_Confirmation__c!=null && c.Paperwork_Confirmation__c.equalsIgnoreCase(CONFIRMED_VETERAN))  filteredContacts.add(c);
        }
        if(!filteredContacts.isEmpty()) forceGenerateMembershipIDs(filteredContacts);
    }
    
    
    // Generates a Membership ID regardless if the Contact is confirmed or already has an ID.
    public static void forceGenerateMembershipIDs(List<Contact> contacts){
        
        // Retrieve the last membership ID value given out
        IAVA_Rewards_Settings__c settings = getMainSettings();
        
        if(settings!=null && !contacts.isEmpty()){
            // Loop through the contacts and assign the new value
            Integer startValue = integer.valueOf(settings.last_member_ID__c);
            Integer nextValue = startValue;
            for(Contact c : contacts){
                nextValue++;
                c.Membership_ID__c = string.valueOf(nextValue);
            }
            // Set the IAVA Rewards Setting value to the latest ID string
            settings.last_member_id__c = string.valueOf(nextValue);
            try{                
                update settings;
            } catch(Exception ex){
                String err = '************* ERROR updating IAVA_Rewards_Settings__c - '+CUSTOM_SETTINGS_NAME+': '+ex.getTypeName() +', '+ex.getMessage() +
                                '\nsettings.last_member_id__c='+settings.last_member_id__c;
                System.debug(err);
                insert new Log__c(message__c=err,process_name__c='ContactTriggerLogic : forceGenerateMembershipIDs');
                return;
            }
        } else {
            String err = '************* ERROR generating membership IDs: IAVA_Rewards_Settings==null';
            System.debug(err);
            return;
        }
    }
    
    public static void resetContactLatitudeLongitude(List<Contact> contacts, Map<Id, Contact> oldMap){
        for(Contact c: contacts){
            Contact oldContact = oldMap.get(c.Id);
            if( c.OtherPostalCode != oldContact.OtherPostalCode ||
                c.MailingPostalCode != oldContact.MailingPostalCode){
                c.Latitude__c = '';
                c.Longitude__c = '';
            }
        }
        return;
    }
    
    
    /***********************************  Helper / Utility Methods ***************************************/
    public static IAVA_Rewards_Settings__c getMainSettings(){   
        // Retrieve the last membership ID value given out
        try{
            IAVA_Rewards_Settings__c settings = [select id,name,last_member_id__c from IAVA_Rewards_Settings__c where name=:CUSTOM_SETTINGS_NAME limit 1];
            return settings;
        } catch(Exception e){
            String err = '*********** Error retrieving IAVA Rewards Settings: '+e.getTypeName() + ', '+e.getMessage();
            System.debug(err);
            insert new Log__c(message__c=err,process_name__c='ContactTriggerLogic : getMainSettings');
            // ApexPages.addMessages(e);
            return null;
        }
    }
    
}