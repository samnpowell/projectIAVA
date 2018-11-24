trigger fillInCaseRequestor on Case (before insert) {

    for(Case thecase : trigger.new){
        if (thecase.Requestor__c == null) {
            thecase.Requestor__c = UserInfo.GetUserId();
        }
    } 
    
}