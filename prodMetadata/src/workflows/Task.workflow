<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Member Number Reminder</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>equals</operation>
            <value>Member Number Reminder</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send EO Language from Task</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Task.Follow_up_Note_for_ED__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Send_Follow_up_to_PR__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When Follow up Note for ED is populated and Send Followup to PR is selected, the details are sent to the EO.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
