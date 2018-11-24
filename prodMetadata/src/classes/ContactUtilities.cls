/*
Copyright (c) 2010 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Nick Koopman, nkoopman@etherios.com
*/
public class ContactUtilities {
	
    public static final String CONFIRMED_VET = 'Paperwork Accepted';

	// Returns the Salesforce ID for a confirmed Member 
	public static ID ConfirmedMemberID(String MemberID, String eMail)
	{
		if ((StringUtilities.ISnullORblank(MemberID)) || (StringUtilities.ISnullORblank(eMail))) return null;
		List<Contact> contacts = new List<Contact>();
		contacts = [SELECT Id FROM Contact WHERE
			((Membership_Id__c = :MemberID) AND
			 (Veteran_Member__c = true) AND
			 (Paperwork_Confirmation__c = :CONFIRMED_VET) AND
			 ((Email = :eMail) OR (npe01__HomeEmail__c = :eMail) OR (npe01__AlternateEmail__c = :eMail))
			)];
		if ((contacts != null) && (contacts.size() == 1))
			return contacts[0].Id;
		return null;
	}

	// Returns true / false indicating if a member is a confirmed member
	/*public static Boolean IsConfirmedMember(String MemberID, String eMail)
	{
		ID id = ConfirmedMemberID(MemberID, eMail);
		if (id != null) return true;
		return false;
	}*/

	// Returns additional information for a confirmed Member
	public static Contact ConfirmedContactInfo(String MemberID, String eMail, String DeviceToken)
	{
		if ((StringUtilities.ISnullORblank(MemberID)) || (StringUtilities.ISnullORblank(eMail))) return null;
		List<Contact> contacts = new List<Contact>();
		contacts = [SELECT Id, Name, Email, npe01__HomeEmail__c, npe01__AlternateEmail__c,
					MailingStreet, MailingCity, MailingState, MailingPostalCode, 
					HomePhone, MobilePhone, npe01__WorkPhone__c, Phone, Drivers_License__c, Shirt_size__c
					FROM Contact WHERE
			((Membership_Id__c = :MemberID) AND
			 (Veteran_Member__c = true) AND
			 (Paperwork_Confirmation__c = :CONFIRMED_VET) AND
			 ((Email = :eMail) OR (npe01__HomeEmail__c = :eMail) OR (npe01__AlternateEmail__c = :eMail))
			)];
			
		if ((contacts != null) && (contacts.size() == 1)){
			Contact c = contacts[0];
			if(DeviceToken != null){
				try {
					Registered_Device__c rD = [SELECT Device_Owner__c FROM Registered_Device__c Where Device_Token__c =: DeviceToken];
					
					rD.Device_Owner__c = c.Id;
					update rD;
				}catch(QueryException e){
					System.debug(e.getMessage());
				}catch(DmlException e){
					System.debug(e.getMessage());
				}
			}
			return c;
		}
		return null;
	}
}