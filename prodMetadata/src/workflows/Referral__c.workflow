<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Referral_Survey_Email</fullName>
        <description>Referral - Survey Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>transition@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_templates/Referral_Survey_Email</template>
    </alerts>
    <rules>
        <fullName>Referral - Survey Email</fullName>
        <actions>
            <name>Referral_Survey_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Referral__c.CreatedDate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Program__c.Suppress_Emails_for_Program_Merge__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Survey link is sent when a Referral is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Referral Focus Area default to Program Focus Area</fullName>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Referral__c.Focus_Area_of_Program__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If Focus Area for Referral is blank, populate it with the Focus Area of Program</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
