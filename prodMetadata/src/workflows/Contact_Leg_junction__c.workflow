<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Policy_Notify_of_new_co_sponsor_on_existing_bill_record</fullName>
        <description>Policy - Notify of new co-sponsor on existing bill record</description>
        <protected>false</protected>
        <recipients>
            <recipient>bill@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>chris@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>samdorman@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Policy_templates/Policy_Notify_of_co_sponsor</template>
    </alerts>
    <rules>
        <fullName>Policy - Notify of new co-sponsor</fullName>
        <actions>
            <name>Policy_Notify_of_new_co_sponsor_on_existing_bill_record</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact_Leg_junction__c.Role__c</field>
            <operation>equals</operation>
            <value>Co-sponsor</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legislation__c.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legislation__c.CreatedDate</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Alias</field>
            <operation>equals</operation>
            <value>exp</value>
        </criteriaItems>
        <description>Notify point people when new co-sponsor record is created automatically by Leg integration (only on update, not on first creation of bill record).</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
