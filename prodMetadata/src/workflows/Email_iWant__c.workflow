<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>eWant Notification</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Email_iWant__c.Status__c</field>
            <operation>equals</operation>
            <value>Request Submitted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
