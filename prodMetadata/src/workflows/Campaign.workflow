<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Notified_when_an_AIR_is_required_on_a_Campaign</fullName>
        <description>Notified when an AIR is required on a Campaign</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>prieckhoff@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/AIR_Needs_to_be_Completed</template>
    </alerts>
    <rules>
        <fullName>Notified when an AIR is required on a Campaign</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.AIR_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Campaign.AIR_Completed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Notified_when_an_AIR_is_required_on_a_Campaign</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Campaign.CreatedDate</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Notified_when_an_AIR_is_required_on_a_Campaign</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Campaign.CreatedDate</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
