<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ProcessKnowledge_userIsActive_true</fullName>
        <description>toggle userIsActive based on the isActive field on user</description>
        <field>userIsActive__c</field>
        <literalValue>1</literalValue>
        <name>ProcessKnowledge_userIsActive_true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ProcessTracking_Fu_PopulateUserActiveFlagOnPKCreate</fullName>
        <actions>
            <name>ProcessKnowledge_userIsActive_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Toggle the userIsActive flag on Process Knowledge when a Process Knowledge record is created and linked to a User. A trigger will be used to handle update since the update takes place on the User object, not Process Knowledge.</description>
        <formula>User__r.IsActive</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
