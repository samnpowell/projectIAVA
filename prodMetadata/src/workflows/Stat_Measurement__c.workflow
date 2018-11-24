<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Policy_send_Stat_Measurement_notification</fullName>
        <description>Policy - send Stat Measurement notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>bill@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>chris@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>samdorman@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Policy_templates/Policy_Stat_Measurement_notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Policy_Stat_Measurement_uncheck_Send</fullName>
        <description>Uncheck the &quot;Send notification when saved&quot; box</description>
        <field>Send_notification_when_saved__c</field>
        <literalValue>0</literalValue>
        <name>Policy - Stat Measurement uncheck Send</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Policy - Stat Measurement notification</fullName>
        <actions>
            <name>Policy_send_Stat_Measurement_notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Policy_Stat_Measurement_uncheck_Send</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Stat_Measurement__c.Send_notification_when_saved__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sends notification about the Stat Measurement to the designated team and then unchecks the notification box so it can be used again.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
