<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DC_Popularity_Index_Notifcation_Email_Alert</fullName>
        <ccEmails>jonathan@iava.org</ccEmails>
        <description>DC Popularity Index Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Assigned_Staffer__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IAVA_Email_Templates/DC_Popularity_Index_Notification</template>
    </alerts>
    <rules>
        <fullName>DC Popularity Index Notification</fullName>
        <actions>
            <name>DC_Popularity_Index_Notifcation_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event__c.Assigned_Staffer__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
