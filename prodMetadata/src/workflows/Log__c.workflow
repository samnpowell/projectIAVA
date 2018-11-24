<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notify_admin_of_Log_Error</fullName>
        <description>Notify admin of Log Error</description>
        <protected>false</protected>
        <recipients>
            <recipient>samanthap@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Templates/Error_log_created</template>
    </alerts>
    <rules>
        <fullName>Notify admin of Log Error</fullName>
        <actions>
            <name>Notify_admin_of_Log_Error</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Log__c.Message__c</field>
            <operation>contains</operation>
            <value>Error</value>
        </criteriaItems>
        <description>Notify admin of Log Error.  E.g. when system tries to save membership ID to a certain record and it doesn&apos;t work.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
