<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>COV_Email_team_about_COV_Error_User_Message</fullName>
        <description>COV: Email team about COV Error User Message</description>
        <protected>false</protected>
        <recipients>
            <recipient>COV_Front_Line</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>admin-sf@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>COV_Templates/COV_Error_user_message_notification</template>
    </alerts>
    <alerts>
        <fullName>Email_COV_devs_about_COV_Error_logged</fullName>
        <description>COV: Email COV devs about COV Error logged</description>
        <protected>false</protected>
        <recipients>
            <recipient>COV_Front_Line</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>community@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>COV_Templates/COV_Error_notification</template>
    </alerts>
    <rules>
        <fullName>COV%3A Email devs about COV Error</fullName>
        <actions>
            <name>Email_COV_devs_about_COV_Error_logged</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>COV_Error__c.Error_Date_Time__c</field>
            <operation>notEqual</operation>
            <value>1/1/2013 3:00 AM</value>
        </criteriaItems>
        <criteriaItems>
            <field>COV_Error__c.User__c</field>
            <operation>notEqual</operation>
            <value>Sam Dorman</value>
        </criteriaItems>
        <criteriaItems>
            <field>COV_Error__c.User__c</field>
            <operation>notEqual</operation>
            <value>Test DeveloperUser</value>
        </criteriaItems>
        <description>Sends email to developer contacts about error logged inside of COV</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>COV%3A Email devs re COV Error User Message</fullName>
        <actions>
            <name>COV_Email_team_about_COV_Error_User_Message</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>COV_Error__c.User_Message__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When user gives feedback about when an error happened, send email to myIAVA team</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
