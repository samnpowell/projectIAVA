trigger sponsorshipTicketTrigger on Sponsorship_Ticket__c (before insert,before update,before delete,after insert,after update,after delete,after undelete)
{
    if(trigger.isAfter)
    {
        if(trigger.isInsert)
        {
            sponsorshipTicketClass.ticketInsertedUpdateMember(trigger.new);
        }
        
        if(trigger.isUpdate)
        {
            sponsorshipTicketClass.ticketUpdatedUpdateMember(trigger.new,trigger.oldMap);
        }
        
        if(trigger.isDelete)
        {
            sponsorshipTicketClass.ticketDeletedUpdateMember(trigger.old);
        }
    }
}