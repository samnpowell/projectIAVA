<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Media_Request_Approved</fullName>
        <description>Media Request Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Media_Request_Approved</template>
    </alerts>
    <alerts>
        <fullName>Notification_of_new_Media_Request</fullName>
        <description>Notification of new Media Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>Director_of_Communications</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>Press_Secretary</recipient>
            <type>role</type>
        </recipients>
        <recipients>
            <recipient>chris@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>johnr@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IAVA_Email_Templates/Notification_of_new_Media_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>Media_Approval_Withdrawal</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Not Submitted for Approval</literalValue>
        <name>Media Approval Withdrawal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Media_Request_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Media Request Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Media_Request_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Media Request Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Media_Request_Submitted</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Submitted for Approval</literalValue>
        <name>Media Request Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Notification of new Media Request</fullName>
        <actions>
            <name>Notification_of_new_Media_Request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Media_Request__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Deferred,Completed</value>
        </criteriaItems>
        <description>Notification of new Media Request</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
