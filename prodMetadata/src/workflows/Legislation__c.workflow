<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Policy_Notify_bill_owner_of_leg_status</fullName>
        <description>Policy_Notify bill owner of leg status</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Policy_templates/Policy_Notify_of_bill_status</template>
    </alerts>
    <fieldUpdates>
        <fullName>Legislation_name_fix</fullName>
        <description>Fixes Bill ID field to contain unique Govtrack Bill ID</description>
        <field>Name</field>
        <formula>text(Bill_Prefix__c) + text( Bill_Number__c ) + &quot;-&quot; +  text(Congressional_Session__c)</formula>
        <name>Legislation name fix</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Policy_Mark_Bill_Inactive</fullName>
        <description>Unchecks the Active checkbox</description>
        <field>Active__c</field>
        <literalValue>0</literalValue>
        <name>Policy_Mark Bill Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Policy_set_unique_Bill_ID</fullName>
        <description>Sets the Uniqueness Test field to the Bill ID to ensure no duplicate records for a single bill</description>
        <field>Uniqueness_Test__c</field>
        <formula>text(Bill_Prefix__c) + text( Bill_Number__c ) + &quot;-&quot; + text(Congressional_Session__c)</formula>
        <name>Policy - set unique Bill ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Policy_update_Leg_AKA_from_bill_title</fullName>
        <description>Update the Leg AKA field using the bill title</description>
        <field>AKA__c</field>
        <formula>LEFT(Bill_Title__c,45)</formula>
        <name>Policy - update Leg AKA from bill title</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Leg_Body_to_House</fullName>
        <description>Update the Legislative Body field to value House</description>
        <field>Legislative_Body__c</field>
        <literalValue>House</literalValue>
        <name>Update Leg Body to House</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Leg_Body_to_Senate</fullName>
        <description>Update the Legislative Body field to value Senate</description>
        <field>Legislative_Body__c</field>
        <literalValue>Senate</literalValue>
        <name>Update Leg Body to Senate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Policy - Legislation - update Bill ID</fullName>
        <actions>
            <name>Legislation_name_fix</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Policy_set_unique_Bill_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Standardizes Bill ID when a record is created.</description>
        <formula>or(isnew(),ischanged( Bill_Prefix__c ),ischanged( Bill_Number__c ), ischanged( Congressional_Session__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Policy - fill in Leg AKA if blank</fullName>
        <actions>
            <name>Policy_update_Leg_AKA_from_bill_title</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legislation__c.Bill_Title__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Legislation__c.AKA__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Legislation__c.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>If an active legislation record is saved without an AKA name, fill it in using the bill title</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Policy - select leg body House if not selected</fullName>
        <actions>
            <name>Update_Leg_Body_to_House</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legislation__c.Legislative_Body__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Legislation__c.Bill_Prefix__c</field>
            <operation>equals</operation>
            <value>HR,HCRES,HJRES,HRES,HAMDT</value>
        </criteriaItems>
        <description>When a Leg record is created, select House depending on bill prefix</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Policy - select leg body Senate if not selected</fullName>
        <actions>
            <name>Update_Leg_Body_to_Senate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legislation__c.Legislative_Body__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Legislation__c.Bill_Prefix__c</field>
            <operation>equals</operation>
            <value>SRES,SAMDT,SJRES,SCRES,S</value>
        </criteriaItems>
        <description>When a Leg record is created, select Senate depending on bill prefix</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Policy_mark Enacted Bill as Inactive</fullName>
        <actions>
            <name>Policy_Notify_bill_owner_of_leg_status</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Policy_Mark_Bill_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Legislation__c.Status__c</field>
            <operation>equals</operation>
            <value>ENACTED:SIGNED</value>
        </criteriaItems>
        <criteriaItems>
            <field>Legislation__c.Active__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Automatically mark a bill as inactive when it passes</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
