<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>College_Factual_Email</fullName>
        <description>College Factual Email</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>jmcwilliam@collegefactual.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GI_Bill_Emails/College_Factual_Email</template>
    </alerts>
    <rules>
        <fullName>College Factual Email</fullName>
        <actions>
            <name>College_Factual_Email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>NGIB_Query__c.Subscribe_to_College_Factual_Emails__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
