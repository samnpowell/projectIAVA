public with sharing class cov_protectedareas_controller {

	public Boolean isConfirmed {get; set;}
	public Boolean isUnconfirmed {get; set;}
	private User u;
	private Contact c;
	public Id contactId {get; set;}
	public Id groupIdSelected {get; set;}
	public List<groupMemberMap> restrictedGroups {get; set;}

	public cov_protectedareas_controller() {
	
        u = cov_user_utility.self.getU();
        c = cov_user_utility.self.getC(new List<String>{'Paperwork_Confirmation__c', 'Paperwork_Issue__c', 'Approval_Related_Comments__c'});
        contactId = c == null ? null : c.Id;

		isConfirmed = c != null && cov_user_utility.self.getIsMemberVeteran() && cov_user_utility.self.getIsConfirmed();
		isUnconfirmed = c != null && cov_user_utility.self.getIsMemberVeteran() && !cov_user_utility.self.getIsConfirmed();

		restrictedGroups = loadRestrictedGroups();

	}


	public List<groupMemberMap> loadRestrictedGroups() {

		if (c == null) {
			return null;
		}
        
        Id theNetworkId = cov_user_utility.self.getNetworkId();


		List<Chatter_Group_Mirror__c> groupMirrors = [select Id, Group_ID__c, Expose_Joining_To__c
														From Chatter_Group_Mirror__c
														where Group_ID__c != null
														and Expose_Joining_To__c includes ('Confirmed', 'Unconfirmed')
													];
		if (groupMirrors != null && groupMirrors.size() > 0) {

			Set<Id> groupIds = new Set<Id>();
			Map<Id, Chatter_Group_Mirror__c> groupIdToMirrorMap = new Map<Id, Chatter_Group_Mirror__c>();
			for (Chatter_Group_Mirror__c mir : groupMirrors) {
				groupIds.add(mir.Group_ID__c);
				groupIdToMirrorMap.put(mir.Group_ID__c, mir);
			}
			system.debug('groupIds: ' + groupIds);

			//List<CollaborationGroup> theGroups = [select id, Name, Owner.Id, CollaborationType, 
			//								    	SmallPhotoUrl, Description
			//								    	from CollaborationGroup 
			//								    	where Id in :groupIds
			//								    	and CollaborationType = 'Unlisted'
			//								    	and NetworkId = :theNetworkId
			//								    	];
			String groupQuery = 'select id, Name, Owner.Id, CollaborationType'
								+ ', SmallPhotoUrl, Description'
								+ ' from CollaborationGroup'
								+ ' where Id in (';
			Integer counter = 0;
			for (Id idee : groupIds) {
				if (counter > 0) {
					groupQuery += ', ';
				}
				groupQuery += '\'' + idee + '\'';
				counter++;
			}
			groupQuery += ')'
								+ ' and CollaborationType = \'Unlisted\''
								+ ' and NetworkId = \'' + theNetworkId + '\'';
			system.debug('groupQuery: ' + groupQuery);

	 		List<CollaborationGroup> theGroups = (List<CollaborationGroup>)cov_nosharing_utilities.runListQuery(groupQuery);

			system.debug('groups found: ' + theGroups);


	        //List<CollaborationGroup> theGroups = [select id, Name, Owner.Name, Owner.Id, CollaborationType, MemberCount, 
	        //                                      SmallPhotoUrl, Description, LastFeedModifiedDate 
	        //                                    from CollaborationGroup 
	        //                                    where NetworkId = :theNetworkId
	        //                                    ];
	                                            //order by LastFeedModifiedDate desc
	                                            //limit 4

	        
	        // cant seem to use a child query above to pull group memberships
	        List<CollaborationGroupMember> groupMemberships = [select CollaborationGroupId, MemberId
	                                          from CollaborationGroupMember 
	                                          where CollaborationGroupId in :groupIds
	                                          and MemberId = :u.Id];

	        set<Id> groupMemberIDset = new set<Id>(); 
	        for (CollaborationGroupMember cgm : groupMemberships) { 
	            groupMemberIDset.add(cgm.CollaborationGroupId); 
	        } 

	        List<groupMemberMap> groupMap = new List<groupMemberMap>();
	        for(CollaborationGroup g : theGroups) {
	        	Chatter_Group_Mirror__c mir = groupIdToMirrorMap.get(g.Id);
	        	if (c != null && mir != null) {
	        		Boolean groupIsForConfirmeds = mir.Expose_Joining_To__c.replace('Unconfirmed', '').contains('Confirmed');
	        		Boolean groupIsForUnconfirmeds = mir.Expose_Joining_To__c.contains('Unconfirmed');
	        		Boolean userIsEligible = (groupIsForConfirmeds && isConfirmed) || (groupIsForUnconfirmeds && isUnconfirmed);
	        		if ( (isConfirmed || isUnconfirmed) && (groupIsForConfirmeds || groupIsForUnconfirmeds) ) {
			            groupMemberMap gmm = new groupMemberMap(g, false, false, userIsEligible, groupIsForConfirmeds, groupIsForUnconfirmeds);
			            if(groupMemberIDset.contains(g.Id)) {
			                gmm.isMember = true;
			            } 
			            if(g.Owner.Id == u.Id) {
			                gmm.isOwner = true;
			            }
			            groupMap.add(gmm);
			        }
		        }
	        }   
	        return groupMap;    
	    } else {
	    	return null;
	    }                       
        
    }
    
    public class groupMemberMap {
        
        public CollaborationGroup cg {get; set;}
        public Boolean isMember {get; set;}
        public Boolean isOwner {get; set;}
        public Boolean isEligible {get; set;}
        public Boolean isPrivate {get; set;}
        public Boolean forConfirmed {get; set;}
        public Boolean forUnconfirmed {get; set;}
        
        public groupMemberMap(CollaborationGroup cgIn, Boolean isMemberIn, Boolean isOwnerIn, Boolean isEligibleIn, Boolean forConfirmedIn, Boolean forUnconfirmedIn) {
            cg = cgIn;
            isMember = isMemberIn;
            isOwner = isOwnerIn;
            isEligible = isEligibleIn;
            forConfirmed = forConfirmedIn;
            forUnconfirmed = forUnconfirmedIn;
            isPrivate = cg.CollaborationType=='Private' || cg.CollaborationType=='Unlisted';
        }
        
        
    }

	public PageReference addToGroup() {
		system.debug('add user ' + u.Id + ' to group: ' + groupIdSelected);
		if (!String.isEmpty(groupIdSelected)) {
			cov_groups_controller.addToGroup(u, groupIdSelected);
			restrictedGroups = loadRestrictedGroups();
		}
		return null;
	}


}