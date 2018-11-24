<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notification_of_new_Press_Hit</fullName>
        <ccEmails>press@iava.org</ccEmails>
        <description>Notification of new Press Hit</description>
        <protected>false</protected>
        <recipients>
            <recipient>Director_of_Communications</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Press_Secretary</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Notification_of_new_Press_Hit</template>
    </alerts>
    <rules>
        <fullName>Notification of new Press Hit</fullName>
        <actions>
            <name>Notification_of_new_Press_Hit</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Press_Hit__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Notification of new Press Hit</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
