/*
Copyright (c) 2009 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Mike Dannenfeldt, mike@etherios.com
*/
trigger DonationHistoryBeforeInsert on Donation_History__c (before insert) {
    //DonationHistoryByYear.createDonorYearKeys(trigger.new); 
}