<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Research_Stat_will_expire_in_3_days</fullName>
        <description>Research - Stat will expire in 3 days</description>
        <protected>false</protected>
        <recipients>
            <recipient>Research</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Policy_templates/Policy_notify_research_staff_3_days_before_stat_expires</template>
    </alerts>
    <rules>
        <fullName>Policy - notify research staff 3 days before stat expires</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Stat__c.Latest_Measurement_Expiration_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Stat__c.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Notify Research Staff 3 days before latest stat measurement expires.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Research_Stat_will_expire_in_3_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Stat__c.Latest_Measurement_Expiration_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
