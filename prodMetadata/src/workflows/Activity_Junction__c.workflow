<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Track_a_Call_Call_Notes_to_Manager</fullName>
        <description>Send Track a Call Call Notes to Manager</description>
        <protected>false</protected>
        <recipients>
            <recipient>backgroundadmin@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Policy_templates/Send_Track_a_Call_Call_Notes_to_Manager</template>
    </alerts>
    <alerts>
        <fullName>Track_a_Call_Creation_Notify_EO</fullName>
        <description>Track a Call Creation - Notify EO</description>
        <protected>false</protected>
        <recipients>
            <recipient>DC_Users</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>brendan@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>haley@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>paul@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>samanthap@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Track_a_Call_Creation_Notify_E_O</template>
    </alerts>
    <rules>
        <fullName>Send Track a Call Call Notes to Manager</fullName>
        <actions>
            <name>Send_Track_a_Call_Call_Notes_to_Manager</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Activity_Junction__c.Send_Call_Notes_to_Manager__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Send Track a Call Call Notes to Manager when &quot;Send Call Notes to Manager is checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Track a Call Creation - Notify EO</fullName>
        <actions>
            <name>Track_a_Call_Creation_Notify_EO</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Activity_Junction__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <description>Notifies EO when a Track a Call is Created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
