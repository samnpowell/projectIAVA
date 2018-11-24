<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Policy_Retire_Date_today</fullName>
        <description>Updates Retire Date with today&apos;s date</description>
        <field>Retire_Date__c</field>
        <formula>Today()</formula>
        <name>Policy_Retire_Date_today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Policy_Rec_to_Leg_introduced</fullName>
        <description>Sets the Policy Recommendation&apos;s Status field to Legislation Introduced.</description>
        <field>Status__c</field>
        <literalValue>Legislation introduced</literalValue>
        <name>Set Policy Rec to Leg introduced</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Policy - set PRec status to Leg Introduced</fullName>
        <actions>
            <name>Set_Policy_Rec_to_Leg_introduced</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Policy_Rec__c.Num_Legislation__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Policy_Rec__c.Status__c</field>
            <operation>equals</operation>
            <value>Nothing,Interest</value>
        </criteriaItems>
        <criteriaItems>
            <field>Policy_Rec__c.Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When a Leg record gets connected to a Policy Rec, set the Policy Rec status to Leg Introduced</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Policy_Add_retire_date_if_not_added</fullName>
        <actions>
            <name>Policy_Retire_Date_today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Policy_Rec__c.Retire_Reason__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Policy_Rec__c.Retire_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If a policy priority is retired but a retire date is not selected, make today the retire date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
