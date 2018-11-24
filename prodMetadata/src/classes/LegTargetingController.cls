/*

TO DO:

- use something more universal than AIR__c for the Campaign lookup
- separate page 2 forms into two separate forms so the enter key works
- separate contacts list into separate component (requires some controller stuff i dont quite get)

*/



public with sharing class LegTargetingController {

	private final Legislation__c leg;

    public SelectOption[] allPositions { get; set; }
    public SelectOption[] selectedPositions { get; set; }
    public SelectOption[] allRoles { get; set; }
    public SelectOption[] selectedRoles { get; set; }

    public String positions { get; set; }
    public String roles { get; set; }
    //public String qresult1 { get; set; }
    //public String qresult2 { get; set; }
    public String confMsg { get; set; }
    
    public Campaign theCampaign { get; set; }
    
    public Integer numContactsTargeted { get; set; }
    public Integer numContactsAdded { get; set; }
    public Integer numContactsAlreadyThere { get; set; }

    public String newCampaignName { get; set; }
    public AIR__c idHolder { get; set; }

    
    //public List<Contact_Leg_junction__c> cl { get; set; }
    //public List<Contact> ctcs1 { get; set; }
    //public List<Account> accts { get; set; }
    public List<Contact> ctcs2 { get; set; }

    public LegTargetingController(ApexPages.StandardController stdController) {
		// System.debug('in LegTargetingController()');

		 this.leg = (Legislation__c)stdController.getRecord();
		 
		 
		 idHolder = new AIR__c();
		 
		 //ctcs1 = new List<Contact>();
		 //accts = new List<Account>();
		 ctcs2 = new List<Contact>();

         selectedPositions = new List<SelectOption>();
         allPositions = new List<SelectOption>();

         Schema.DescribeFieldResult positionResult = Contact_Leg_junction__c.Role__c.getDescribe();
         List<Schema.PicklistEntry> ple = positionResult.getPicklistValues();
         for( Schema.PicklistEntry f : ple) {
             allPositions.add(new SelectOption(f.getLabel(), f.getValue()));
         }
		// System.debug('allPositions: ' + allPositions);  
       
         selectedRoles = new List<SelectOption>();
         allRoles = new List<SelectOption>();

         allRoles.add(new SelectOption('KW_IsTheMember__c','The Member'));
         allRoles.add(new SelectOption('KW_Chief_of_Staff__c','Chief of Staff'));
         allRoles.add(new SelectOption('KW_Comms_Director__c','Communications Director'));
         allRoles.add(new SelectOption('KW_Leg_Assistant__c','Legislative Assistant'));
         allRoles.add(new SelectOption('KW_Leg_Director__c','Legislative Director'));
         allRoles.add(new SelectOption('KW_Scheduler__c','Scheduler'));

		 // System.debug('allRoles: ' + allRoles);  

}

	public Legislation__c getTheLeg()
	{
	   return [select Name from Legislation__c limit 1];
	}
	
	public PageReference step1() {
		return Page.LegTarget;
	}
	public PageReference step2() {
		return Page.LegTarget2;
	}
	public PageReference step3() {
		return Page.LegTarget3;
	}

	public PageReference doIt() {
		if (selectedPositions.size() == 0) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'You have to select at least one Position on the bill to target.'));
			return null;
		} else {
			getContacts();
			return step2();
		}
	}
	
    public void getContacts() {
		System.debug('in getContacts()');
    	
        positions = '';
        Boolean first = true;
        for ( SelectOption sp : selectedPositions ) {
            if (!first) {
                positions += ', ';
            }
            positions += sp.getLabel();
            first = false;
        }
        
        roles = '';
        Boolean firstrole1 = true;
        for ( SelectOption sr : selectedRoles ) {
            if (!firstrole1) {
                roles += ', ';
            }
            roles += sr.getLabel();
            firstrole1 = false;
        }
        
		System.debug('positions: ' + positions);   
		
		String q1 = 'SELECT Contact__c from Contact_Leg_junction__c where Legislation__c = \'' + leg.Id + '\'';
		q1 += ' and Role__c in (';
        Boolean firstposition = true;
        for ( SelectOption sp : selectedPositions ) {
            if (!firstposition) {
                q1 += ', ';
            }
            q1 += '\'' + sp.getLabel() + '\'';
            firstposition = false;
        }
        q1 += ')';

		System.debug ('q1: ' + q1);

		/*
		List<Contact_Leg_junction__c> cl = new List<Contact_Leg_junction__c>();
		cl = Database.query(q1);
		*/
		
		String q2= 'SELECT AccountId from Contact where id in (' + q1 + ')';
		System.debug ('q2: ' + q2);
		List<Contact> ctcs1 = Database.query(q2);

		list<id> AccountIDs = new list<id>();
		map<id, Account> AccountMap = new map<id, Account>();

		for (Contact ctc1 : ctcs1) {
			AccountIDs.add(ctc1.AccountId);			
		}

		String q4= 'SELECT Id, Name, AccountId, Account.Name, ' +
		+ 'KW_IsTheMember__c, KW_Chief_of_Staff__c, KW_Comms_Director__c, KW_Scheduler__c, KW_Leg_Assistant__c, KW_Leg_Director__c ' 
		+ 'from Contact where AccountId in :AccountIDs';
		
        Boolean firstrole = true;
        for ( SelectOption sr : selectedRoles ) {
            if (firstrole) {
            	q4 += ' and (';
            }
            else {
                q4 += ' or ';
            }
	        q4 += sr.getValue() + '=\'True\'';
            firstrole = false;
        }		
        if (selectedRoles.size() > 0) q4 += ')';
		
		System.debug ('q4: ' + q4);
		ctcs2 = Database.query(q4);
		numContactsTargeted = ctcs2.size();
		
		
		     
		System.debug('about to return from getContacts()');        
        //return null;       
    }
	
	
	public PageReference addToNew(){
		
		if (newCampaignName == null || newCampaignName == '') {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please enter a name for the new campaign to be created.'));
			return null;			
		} else {
			theCampaign = new Campaign(Name=newCampaignName, IsActive=true);	
			try {
				insert theCampaign;
			} catch (Exception e) {
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getMessage()));
				return null;			
			}
			System.debug('theCampaign: ' + theCampaign);
			System.debug('theCampaign.Id: ' + theCampaign.Id);
			List<CampaignMember> CampaignMembersToInsert = new List<CampaignMember>();
			for (Contact theContact : ctcs2) {
				CampaignMembersToInsert.add(new CampaignMember(ContactId=theContact.Id, CampaignId=theCampaign.Id));
			}
			try {
				insert CampaignMembersToInsert;
			} catch (Exception e) {
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getMessage()));
				return null;
			}
			numContactsAdded = CampaignMembersToInsert.size();		
			confMsg = 'Done.  Hot Damn.';
			return step3();
		}
		
	}

    public PageReference addToExisting(){
    	
 		if (idHolder.Campaign__c == null ) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Please select an existing campaign to which to add the contacts.'));
			return null;			
		} else {
			theCampaign = [select Id, Name from Campaign where id = :idHolder.Campaign__c];	
			System.debug('theCampaign.Id: ' + theCampaign.Id);
			List<CampaignMember> existingCMs = [select ContactId from CampaignMember where CampaignId = :theCampaign.Id];
			Set<Id> existingCMIds = new Set<Id>();
			for (CampaignMember cmem : existingCMs) {
				existingCMIds.add(cmem.ContactId);
			}
			System.debug('existingCMIds: ' + existingCMIds);
			List<CampaignMember> CampaignMembersToInsert = new List<CampaignMember>();
			numContactsAlreadyThere = 0;
			for (Contact theContact : ctcs2) {
				System.debug('theContact.Id: ' + theContact.Id);
				System.debug('existingCMIds.contains(theContact.Id): ' + existingCMIds.contains(theContact.Id));
				if (existingCMIds.contains(theContact.Id)) {
					numContactsAlreadyThere += 1;
				} else {
					CampaignMembersToInsert.add(new CampaignMember(ContactId=theContact.Id, CampaignId=theCampaign.Id));
				}
			}
			try {
				insert CampaignMembersToInsert;
			} catch (Exception e) {
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getMessage()));
				return null;
			}			
			numContactsAdded = CampaignMembersToInsert.size();		
			confMsg = 'Done.  Hot Damn.';
			return step3();
		}
    }
    

}