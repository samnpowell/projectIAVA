public without sharing class cov_groups_controller {

	//public static String conId {get; set;}
	public static User u {get; set;}


   // public User getU() {
   //     if (u == null) {
			//u = cov_user_utility.self.getU();
   //     }
   //     return u;
   // }


	public cov_groups_controller() {}

	public List<groupMemberMap> getGroups() {
        
        Id theNetworkId = cov_user_utility.self.getNetworkId();

        List<CollaborationGroup> theGroups = [select id, Name, Owner.Name, Owner.Id, CollaborationType, MemberCount, 
                                              SmallPhotoUrl, Description, LastFeedModifiedDate 
                                            from CollaborationGroup 
                                            where NetworkId = :theNetworkId
                                            order by LastFeedModifiedDate desc
                                            limit 4];
        
        u = cov_user_utility.self.getU();
        System.debug('User u: ' + u);
        Id uID;
        if (u != null) {
            uID = u.Id;
        } else {
            uID = UserInfo.getUserId();
        }
        System.debug('UserId uID: ' + uID);
        
        List<CollaborationGroupMember> groupMemberships = [select CollaborationGroupId, MemberId
                                          from CollaborationGroupMember 
                                          where MemberId = :uID];
                                          
        set<Id> IDset = new set<Id>(); 
        For(CollaborationGroupMember cgm : groupMemberships){ 
            IDset.add(cgm.CollaborationGroupId); 
        }  

        List<groupMemberMap> groupMap = new List<groupMemberMap>();
        for(CollaborationGroup g : theGroups) {
            groupMemberMap gmm = new groupMemberMap(g, false, false);
            if(IDset.contains(g.Id)) {
                gmm.isMember = true;
            } 
            if(g.Owner.Id == uID) {
                gmm.isOwner = true;
            }
            groupMap.add(gmm);
        }   
        return groupMap;                              
        
    }
    
    public class groupMemberMap {
        
        public CollaborationGroup cg {get; set;}
        public Boolean isMember {get; set;}
        public Boolean isOwner {get; set;}
        public Boolean isPrivate {get; set;}
        
        public groupMemberMap(CollaborationGroup cgIn, Boolean isMemberIn, Boolean isOwnerIn) {
            cg = cgIn;
            isMember = isMemberIn;
            isOwner = isOwnerIn;
            isPrivate = cg.CollaborationType=='Private' || cg.CollaborationType=='Unlisted';
        }
        
        
    }

    public static void addToGroup(User uu, Id groupId) {
        addToGroups(uu, new List<Id>{groupId});
    }

    public static void addToGroups(User uu, List<Id> groupIds) {

        // first make sure there are no dupes in ID list
        Set<Id> groupIdSetNoDupes = new Set<Id>(groupIds);
        List<Id> groupIdListNoDupes = new List<Id>(groupIdSetNoDupes);

        List<CollaborationGroupMember> groupMemberships = [select CollaborationGroupId, MemberId
                                          from CollaborationGroupMember 
                                          where MemberId = :uu.Id
                                          and CollaborationGroupId in :groupIdListNoDupes
                                          ];
                                          
        set<Id> cgmIdSet = new set<Id>(); 
        For(CollaborationGroupMember cgm : groupMemberships){ 
            cgmIdSet.add(cgm.CollaborationGroupId); 
        }  

        List<CollaborationGroupMember> cgmembersToInsert = new List<CollaborationGroupMember>();
        for (Id cgId : groupIdListNoDupes) {
            if (!cgmIdSet.contains(cgId)) {
                cgmembersToInsert.add(new CollaborationGroupMember(MemberId=uu.Id, CollaborationGroupId=cgId, CollaborationRole='Standard', NotificationFrequency='D'));
            }
        }
        system.debug('cgmembersToInsert: ' + cgmembersToInsert);
        if (cgmembersToInsert.size() > 0) {
            try {
                insert cgmembersToInsert;
            } catch (Exception e) {
                cov_log_error.logError(e, 'error inserting CollaborationGroupMember records for user ' + uu.Id);
            }
        }
    }

    public static void addToGroups(User uu, List<CollaborationGroup> groupsIn) {
        List<Id> groupIds = new List<Id>();
        for (CollaborationGroup cg : groupsIn) {
            groupIds.add(cg.Id);
        }
        addToGroups(uu, groupIds);
    }

    public static void validateGroupMirrors(List<Chatter_Group_Mirror__c> cgmList) {

        /*
            This is written to handle multiple groups of the same name although it appears
            that is not actually possible
        */


        Set<String> cgmNames = new Set<String>();
        Set<String> cgmIds = new Set<String>();

        for (Chatter_Group_Mirror__c cgm : cgmList) {
            System.debug('About to validate Chatter_Group_Mirror__c: ' + cgm);
            cgmNames.add(cgm.Name);
            if (cgm.Group_ID__c != null && cgm.Group_ID__c.trim() != '' && cov_user_utility.IDisvalid(cgm.Group_ID__c)) {
                cgmIds.add(cgm.Group_ID__c);
            }
        }

        List<Chatter_Group_Mirror__c> existingCgms = [select Id, Name, Group_ID__c from Chatter_Group_Mirror__c
                                                        where 
                                                        (Name in :cgmNames or Group_ID__c in :cgmIds)
                                                        ];
                                                        //Network__c = 'COV' and
        system.debug('existingCgms: ' + existingCgms);
        Set<String> existingCgmIdSet = new Set<String>();
        Map<String, Chatter_Group_Mirror__c> existingCgmGroupIDtoCGMmap = new Map<String, Chatter_Group_Mirror__c>();
        for (Chatter_Group_Mirror__c cgm : existingCgms) {
            existingCgmIdSet.add(cgm.Group_ID__c);
            existingCgmGroupIDtoCGMmap.put(cgm.Group_ID__c, cgm);
        }

        List<CollaborationGroup> existingGroups = [select Id, Name from CollaborationGroup where Name in :cgmNames or Id in :cgmIds];
        system.debug('existingGroups: ' + existingGroups);
        system.debug('cgmNames: ' + cgmNames);
        system.debug('cgmIds: ' + cgmIds);
        //Set<Id> groupsById = (new Map<Id,SObject>(results)).keySet();
        Map<Id, String> groupNamesById = new Map<Id, String>();
        Map<String, List<CollaborationGroup>> existingCgsByName = new Map<String, List<CollaborationGroup>>();
        for (CollaborationGroup cg : existingGroups) {
            groupNamesById.put(cg.Id, cg.Name);
            if(!existingCgsByName.containsKey(cg.Name)) {
                existingCgsByName.put(cg.Name, new List<CollaborationGroup>());
            }
            existingCgsByName.get(cg.Name).add(cg);
        }

        //List<CollaborationGroup> groupsByName = [select Id, Name from CollaborationGroup where Name in :cgmNames order by Name];

        for (Chatter_Group_Mirror__c cgm : cgmList) {

            if (cgm.Group_ID__c != null && cgm.Group_ID__c.trim() != '') {
                if (!cov_user_utility.IDisvalid(cgm.Group_ID__c)) {
                    cgm.Group_ID__c.addError('This is not a valid ID.');
                } else if (!groupNamesById.containsKey(cgm.Group_ID__c)) {
                    cgm.Group_ID__c.addError('This ID does not correspond to a Chatter group.');
                } else if (groupNamesById.get(cgm.Group_ID__c) != cgm.Name) {
                        cgm.Group_ID__c.addError('This ID does not match the Group name.');
                } else if (existingCgmIdSet.contains(cgm.Group_ID__c) 
                    && existingCgmGroupIDtoCGMmap.get(cgm.Group_ID__c).Id != cgm.Id) {
                        cgm.Group_ID__c.addError('There is already a Chatter Group Mirror for this group ID.');
                }
            } else {
                if (!existingCgsByName.containsKey(cgm.Name)) {
                    cgm.Name.addError('No group found with that name.');
                } else {
                    List<CollaborationGroup> cgList = existingCgsByName.get(cgm.Name);
                    if (cgList.size() == 0){ // this shouldnt happen
                        cgm.Name.addError('No group found with that name.');
                    } else if (cgList.size() > 1) {
                        cgm.Group_ID__c.addError('Multiple groups found with that name. Please include the ID of the group as well.');
                    } else {
                        if (existingCgmIdSet.contains(cgList[0].Id)) {
                            cgm.Name.addError('There is already a Chatter Group Mirror for this group.');
                        } else {
                            cgm.Group_ID__c = cgList[0].Id;
                        }
                    }
                }
            }
        }

    }

    public static Chatter_Group_Mirror__c findGroupMirrorByGroupId(Id idIn) {
        //System.debug('idIn: ' + idIn);
        List<Chatter_Group_Mirror__c> cgmList = findGroupMirrorsByGroupIds(new List<Id> {idIn});
        //System.debug('cgmList: ' + cgmList);
        if (cgmList.size() > 0) {
            return cgmList[0];
        } else {
            return null;
        }
    }

    public static List<Chatter_Group_Mirror__c> findGroupMirrorsByGroupIds(List<Id> idsIn) {
        //System.debug('idsIn: ' + idsIn);
        return [select Id, Name, Group_ID__c from Chatter_Group_Mirror__c where Group_Id__c in :idsIn];
    }

    public static Chatter_Group_Mirror__c findGroupMirrorByGroup(CollaborationGroup cg) {
        //System.debug('cg: ' + cg);
        return findGroupMirrorByGroupId(cg.Id);        
    }

    public static List<Chatter_Group_Mirror__c> findGroupMirrorsByGroups(List<CollaborationGroup> groupsIn) {
        List<Id> groupIds = new List<Id>();
        for (CollaborationGroup cg : groupsIn) {
            groupIds.add(cg.Id);
        }
        return findGroupMirrorsByGroupIds(groupIds);
    }



    public static CollaborationGroup findGroupByMirrorId(Id idIn) {
        system.debug('findGroupByMirrorId with Mirror Id: ' + idIn);
        List<CollaborationGroup> cgList = findGroupsByMirrorIds(new List<Id> {idIn});
        system.debug('cgList found: ' + cgList);
        if (cgList.size() > 0) {
            return cgList[0];
        } else {
            return null;
        }
    }

    public static List<CollaborationGroup> findGroupsByMirrorIds(List<Id> idsIn) {
        //System.debug('idsIn: ' + idsIn);
        List<Chatter_Group_Mirror__c> cgms = [select Group_Id__c from Chatter_Group_Mirror__c where Id in :idsIn];
        // Group_Id__c is a string rather than an Id field so cant do a join query
        List<Id> idList = new List<Id>();
        for (Chatter_Group_Mirror__c cgm : cgms) {
            try {
                idList.add((Id)cgm.Group_ID__c);
            } catch (Exception e) { cov_log_error.logError(e); }
        }
        return [select Id, Name, InformationBody, CollaborationType from CollaborationGroup where Id in :idList];
    }

    public static CollaborationGroup findGroupByMirror(Chatter_Group_Mirror__c cg) {
        List<CollaborationGroup> cgList = findGroupsByMirrors(new List<Chatter_Group_Mirror__c>{cg}); 
        if (cgList.size() > 0) {
            return cgList[0];
        } else {
            return null;
        }               
    }

    public static List<CollaborationGroup> findGroupsByMirrors(List<Chatter_Group_Mirror__c> cgListIn) {
        List<Id> idList = new List<Id>();
        for (Chatter_Group_Mirror__c cg : cgListIn) {
            idList.add(cg.Group_ID__c);
        }
        return [select Id, Name, InformationBody, CollaborationType from CollaborationGroup where Id in :idList];
    }


    //public static List<CollaborationGroup> findGroupsByMirrorGroups(List<Chatter_Group_Mirror__c> mirrorsIn) {
    //    List<Id> groupIds = new List<Id>();
    //    for (Chatter_Group_Mirror__c cg : mirrorsIn) {
    //        groupIds.add(cg.Group_Id__c);
    //    }
    //    return findGroupsByMirrorIds(groupIds);
    //}

    public static Chatter_Group_Mirror__c createMirrorFromGroup(CollaborationGroup cgIn) {
        return createMirrorFromGroup(cgIn, null);
    }

    public static Chatter_Group_Mirror__c createMirrorFromGroup(CollaborationGroup cgIn, String cgmType) {

        List<Chatter_Group_Mirror__c> existingCgms = [select Id
                                                        , Group_ID__c
                                                        , Network__c
                                                        , Type__c
                                                        , Add_everyone_to_group__c
                                                        from Chatter_Group_Mirror__c
                                                        where Group_ID__c = :cgIn.Id
                                                        ];
        if (existingCgms.size() > 0) {
            return existingCgms[0];
        } else {
            Chatter_Group_Mirror__c newCgm = new Chatter_Group_Mirror__c(
                Group_Id__c = cgIn.Id
                , Name = cgIn.Name
                , Type__c = cgmType
                , Network__c = cov_user_utility.self.getNetworkId()
            );
            try {
                insert newCgm;
                return newCgm;
            } catch (Exception e) { 
                cov_log_error.logError(e); 
                return null;
            }

        }
    }

    public static String createUniqueGroupName(String incomingGroupName, String namePrefix) {
        namePrefix = namePrefix == null ? '' : namePrefix;
        String groupName = namePrefix + incomingGroupName.left(40 - namePrefix.length());

        //List<CollaborationGroup> dupeNameGroups = [select Id, Name from CollaborationGroup 
        //                                          where Name = :groupName
        //                                          ];
        String searchString = groupName.length() <= 36 ? groupName + '%' : groupName.left(36) + '%';
        List<CollaborationGroup> dupeNameGroups = [select Id, Name from CollaborationGroup 
                                                    where Name Like :groupName
                                                    order by Name
                                                    ];
        Set<String> nameSet = new Set<String>();
        for (CollaborationGroup g : dupeNameGroups) {
            nameSet.add(g.Name);
        }

        // if there's already a group of this name, then tack on number suffix until get a non-dupe name
        if (nameSet.contains(groupName)) {
            Boolean foundOpenName = false;
            for (Integer i = 1; !foundOpenName && i < 1000; i++) {
                system.debug('i='+i + ' and foundOpenName: ' + foundOpenName);
                String iString = String.valueOf(i);
                String partialName = groupName.length() <= 40 - iString.length() - 1
                                    ? groupName + '-' + iString
                                    : groupName.left(groupName.length() - iString.length() - 1) + '-' + iString;
                if (!nameSet.contains(partialName)) {
                    system.debug('nameSet did not contain partialName: ' + partialName);
                    groupName = partialName;
                    foundOpenName = true;
                }
            }
        }
        return groupName;
    }

    public static String getMemberCatsSetFromMemberCatsField(String memberCatsField) {
        system.debug('memberCatsField: ' + memberCatsField);
        String memberCatsToSearch = '';
        if (String.isNotBlank(memberCatsField)) {
            List<String> catsSplit = memberCatsField.split(';');
            Integer catsAdded = 0;
            for (String s : catsSplit) {
                s = s.trim();
                if (String.isNotBlank(s)) {
                    s = s == 'OtherEra' ? 'Other Era' : s;
                    String stringToAdd = catsAdded > 0 ? ',' : '';
                    stringToAdd += '\'' + s + '\'';
                    memberCatsToSearch += stringToAdd;
                    catsAdded++;
                    //if (s.containsWhitespace()) {
                    //    memberCatsToSearch += stringToAdd.deleteWhitespace();
                    //}
                }
            }
        }
        system.debug('memberCatsToSearch: ' + memberCatsToSearch);
        return memberCatsToSearch;
    }

    // didnt need this after all since SOQL includes will search for entire multi-select picklist values
    //public static List<Chatter_Group_Mirror__c> checkForFalseMirrorMatches(String memberCatsField, List<Chatter_Group_Mirror__c> mirrorsIn, String fieldNameToCheck) {
    //    // since the word 'Confirmed' is contained in the word 'Unconfirmed'
    //    // remove any mirrors that were falsely pulled up in the query
    //    // because Confirmed matched when the value was actually Unconfirmed

    //    if (String.isNotBlank(memberCatsField)) {
    //        if (memberCatsField.containsNone('Unconfirmed') && memberCatsField.replace('Unconfirmed', '').contains('Confirmed')) {
    //            system.debug('The member is Confirmed and not Unconfirmed');
    //            for (Integer i = 0; i < mirrorsIn.size(); i++) {
    //                String catsFromMirror = (String)(mirrorsIn[i].get(fieldNameToCheck));
    //                if (String.isNotBlank(catsFromMirror)) {
    //                    catsFromMirror = ';' + catsFromMirror + ';'; // ensure all values have surrounding semicolons
    //                    List<String> catsFromMember = memberCatsField.split(';');
    //                    Boolean groupCatMatchesMemberCat = false;
    //                    Integer j = 0;
    //                    while (!groupCatMatchesMemberCat && j < catsFromMember.size()) {
    //                        if (catsFromMirror.contains(';' + catsFromMember[j] + ';')) {
    //                            groupCatMatchesMemberCat = true;
    //                        }
    //                        j++;
    //                    }
    //                    if (!groupCatMatchesMemberCat) {
    //                        system.debug('member categories (' + memberCatsField + ') not found in group mirror field ' + fieldNameToCheck + ': ' + catsFromMirror);
    //                        mirrorsIn.remove(i);
    //                        i--;
    //                    } 
    //                }
    //            }
    //        }
    //    }
    //    system.debug('mirrors being returned: ' + mirrorsIn);
    //    return mirrorsIn;
    //}

}