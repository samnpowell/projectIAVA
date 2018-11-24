<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Membership_Rejects_Ticket_Give_Request</fullName>
        <ccEmails>partner@iava.org</ccEmails>
        <description>Membership Rejects Ticket Give Request</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>samanthap@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Membership_Rejects_Ticket_Give_Request</template>
    </alerts>
    <alerts>
        <fullName>Partnerships_New_Partnership_confirmation_email</fullName>
        <description>Partnerships - New Partnership confirmation email</description>
        <protected>false</protected>
        <recipients>
            <field>Related_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/New_Partnership_confirmation_email</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_new_partnership_request</fullName>
        <ccEmails>partner@iava.org</ccEmails>
        <description>Rucksack - new partnership request</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>samanthap@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_New_Partnership_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>Field_Update_Accepted_by_Membership</fullName>
        <field>Ticket_Give_Stage__c</field>
        <literalValue>Accepted by Membership &amp; Sent to Online</literalValue>
        <name>Field Update Accepted by Membership</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_TGS</fullName>
        <field>Ticket_Give_Stage__c</field>
        <literalValue>Accepted by SP &amp; Sent to Membership</literalValue>
        <name>Field Update TGS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_Ticket_Give_Stage</fullName>
        <field>Ticket_Give_Stage__c</field>
        <literalValue>Accepted by SP &amp; Sent to Membership</literalValue>
        <name>Field Update Ticket Give Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_to_Rejected</fullName>
        <field>Ticket_Give_Stage__c</field>
        <literalValue>Rejected by Membership</literalValue>
        <name>Field Update to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Follow Up to Collect Pictures of Event</fullName>
        <actions>
            <name>Collect_Pictures_Stories_of_Event</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Assigns a task to collect pictures, stories, etc... of all partnership events the day after the event.</description>
        <formula>Event_Date__c  &lt; TODAY ()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack - Partnership request created</fullName>
        <actions>
            <name>Partnerships_New_Partnership_confirmation_email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Rucksack_new_partnership_request</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Partnership_Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Submitted by Partner</value>
        </criteriaItems>
        <description>Alerts Partnerships dept when new request is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Names Back to Partner</fullName>
        <actions>
            <name>Send_Names_Back_to_Partner</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Partnership_Request__c.Ticket_Give_Stage__c</field>
            <operation>equals</operation>
            <value>Ticket Winners Confirmed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Collect_Pictures_Stories_of_Event</fullName>
        <assignedTo>MembershipAssociate</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Collect Pictures &amp; Stories of Event</subject>
    </tasks>
    <tasks>
        <fullName>Send_Names_Back_to_Partner</fullName>
        <assignedTo>ChiefProgramOfficer</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Names Back to Partner</subject>
    </tasks>
</Workflow>
