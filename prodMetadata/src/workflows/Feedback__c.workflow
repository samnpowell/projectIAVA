<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>COV_Feedback_notification</fullName>
        <description>COV Feedback notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>COV_Front_Line</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>jjapgar@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>COV_Templates/myIAVA_Feedback_received</template>
    </alerts>
    <rules>
        <fullName>COV Feedback notification</fullName>
        <actions>
            <name>COV_Feedback_notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Feedback__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Notify appropriate people when new COV Feedback record created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
