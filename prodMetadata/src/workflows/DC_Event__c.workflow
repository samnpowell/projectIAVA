<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>DC_Event_Notifcation_Email_Alert</fullName>
        <ccEmails>jonathan@iava.org</ccEmails>
        <description>DC Event Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IAVA_Email_Templates/DC_Event_Notification</template>
    </alerts>
    <alerts>
        <fullName>Policy_Notify_staff_of_testimony_record</fullName>
        <description>Policy_Notify staff of testimony record</description>
        <protected>false</protected>
        <recipients>
            <recipient>stephanie@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Policy_templates/Policy_New_Testimony_record</template>
    </alerts>
    <rules>
        <fullName>DC Event Notification</fullName>
        <actions>
            <name>DC_Event_Notifcation_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>DC_Event__c.OwnerId</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Policy - notify staff of new testimony record</fullName>
        <actions>
            <name>Policy_Notify_staff_of_testimony_record</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>DC_Event__c.Type__c</field>
            <operation>equals</operation>
            <value>Congressional Testimony</value>
        </criteriaItems>
        <description>Notifies designated staff member when a testimony record is created.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
