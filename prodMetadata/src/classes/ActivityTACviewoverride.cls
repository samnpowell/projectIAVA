/*
 *
 * Overrides the Activity view when "This is really a Track a Call"
 * is checked, redirects to the Track a Call record instead.
 *
 * SD 2012
 */



public with sharing class  ActivityTACviewoverride {

    private final Task activity;

    public ActivityTACViewOverride (ApexPages.StandardController controller)
    {
        //get the account with the one2oneContact__c field for use in the rederict if necessary
        List <Task> activities = [select id, Really_TAC__c, WhatId from Task where id = :ApexPages.currentPage().getParameters().get('id') AND IsDeleted = false ALL ROWS];
        if (activities.size() > 0)
        {
            activity = activities[0];
            System.debug('activity: ' + activity);
        }
        else
        {
            activity = null;
            System.debug('it was null');
        }
    }

    public Task getActivity()
    {
        return activity;
    }
    

}