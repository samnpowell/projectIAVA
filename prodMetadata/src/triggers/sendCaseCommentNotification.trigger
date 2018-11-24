trigger sendCaseCommentNotification on CaseComment (after insert) {

    CaseCommentNotification.sendCaseCommentNotification(Trigger.new[0]);

}