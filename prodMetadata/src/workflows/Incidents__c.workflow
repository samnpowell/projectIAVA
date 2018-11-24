<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Incident_Followup_Email</fullName>
        <description>Incident Followup Email</description>
        <protected>false</protected>
        <recipients>
            <field>Follow_up_Assignee__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IAVA_Email_Templates/Incident_Followup</template>
    </alerts>
    <alerts>
        <fullName>Incident_Notification_Email</fullName>
        <description>Incident Notification Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>hannah@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IAVA_Email_Templates/Incident_Notification</template>
    </alerts>
    <rules>
        <fullName>Incident Followup</fullName>
        <actions>
            <name>Incident_Followup_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Incidents__c.Follow_up_Assignee__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Incidents__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Closed,Resolved</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Incident Notification</fullName>
        <actions>
            <name>Incident_Notification_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Incidents__c.Status__c</field>
            <operation>equals</operation>
            <value>Open,Resolved,In progress,Ongoing,Closed</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
