<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Deliverable_is_Due_Alert</fullName>
        <description>Deliverable is Due Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeremy@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>samanthap@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>Program_Staff_Responsible__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Development_Templates/Deliverable_is_Due_Alert</template>
    </alerts>
    <rules>
        <fullName>Deliverable is Due Alert</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Grant_Obligation__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Completed,Aborted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Deliverable_is_Due_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Grant_Obligation__c.Due_Date__c</offsetFromField>
            <timeLength>-10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Deliverable_is_Due_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Grant_Obligation__c.Due_Date__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Deliverable_is_Due_Alert</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Grant_Obligation__c.Due_Date__c</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
