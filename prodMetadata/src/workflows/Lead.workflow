<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>MA_ClearLeadLatitude</fullName>
        <field>MA_Latitude__c</field>
        <name>Clear Lead Latitude</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MA_ClearLeadLongitude</fullName>
        <field>MA_Longitude__c</field>
        <name>Clear Lead Longitude</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Clear Latitude and Longitude</fullName>
        <actions>
            <name>MA_ClearLeadLatitude</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MA_ClearLeadLongitude</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow rule clears the latitude and longitude when the address field is updated. This will cause this location to be geocoded again</description>
        <formula>OR( ISCHANGED(Street), ISCHANGED(City), ISCHANGED(State), ISCHANGED(PostalCode), ISCHANGED(Country))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
