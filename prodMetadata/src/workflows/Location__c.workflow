<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Latitudec_Purge</fullName>
        <description>Purge the Latitude__c field on the Location__c if selected address fields change; created by the Metadata API</description>
        <field>Latitude__c</field>
        <name>MA Latitude__c Purge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Longitudec_Purge</fullName>
        <description>Purge the Longitude__c field on the Location__c if selected address fields change; created by the Metadata API</description>
        <field>Longitude__c</field>
        <name>MA Longitude__c Purge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Locationc_ZipDisplayc_Field_Changed</fullName>
        <actions>
            <name>Latitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Longitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the Location__c if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(Zip_Display__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
