<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EventBudgetApproved</fullName>
        <description>EventBudgetApproved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>anthony@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>laura@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Event_templates/Event_Budget_Approved</template>
    </alerts>
    <alerts>
        <fullName>EventBudgetRejected</fullName>
        <description>EventBudgetRejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>anthony@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>laura@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Event_templates/Event_Budget_Rejected</template>
    </alerts>
    <alerts>
        <fullName>EventBudgetRequested</fullName>
        <description>EventBudgetRequested</description>
        <protected>false</protected>
        <recipients>
            <recipient>anthony@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>laura@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Event_templates/Event_Budget_Requested</template>
    </alerts>
    <fieldUpdates>
        <fullName>UpdateBudgetReqStatus_ApprovedNewAmount</fullName>
        <field>Status__c</field>
        <literalValue>Approved with New Amount</literalValue>
        <name>UpdateBudgetReqStatus_ApprovedNewAmount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateBudgetReqStatus_ApprovedReqAmount</fullName>
        <description>Set Budget Request Status to &apos;Approved for Requested Amount&apos;</description>
        <field>Status__c</field>
        <literalValue>Approved for Requested Amount</literalValue>
        <name>UpdateBudgetReqStatus_ApprovedReqAmount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateBudgetReqStatus_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>UpdateBudgetReqStatus_Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>EventBudgetApproved</fullName>
        <actions>
            <name>EventBudgetApproved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>Requested_Budget__c &gt; 0 &amp;&amp; CONTAINS(TEXT(Status__c), &apos;Approved&apos;) &amp;&amp; NOT(ISBLANK(Approved_Budget__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EventBudgetRejected</fullName>
        <actions>
            <name>EventBudgetRejected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>Requested_Budget__c &gt; 0 &amp;&amp;
ISPICKVAL(Status__c, &apos;Rejected&apos;) &amp;&amp;
(ISBLANK(Approved_Budget__c) ||
 Approved_Budget__c = 0)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EventBudgetRequested</fullName>
        <actions>
            <name>EventBudgetRequested</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>Requested_Budget__c &gt; 0 &amp;&amp; ISPICKVAL(Status__c, &apos;Requested&apos;) &amp;&amp; ISBLANK(Approved_Budget__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateBudgetRequestStatus_ApprovedOtherAmount</fullName>
        <actions>
            <name>UpdateBudgetReqStatus_ApprovedNewAmount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If budget request approved amount is greater than 0, but not equal to the requested amount, set status to &apos;Approved with New Amount&apos; if it has not been set already.</description>
        <formula>(Approved_Budget__c &gt; 0) &amp;&amp;
(Approved_Budget__c != Requested_Budget__c) &amp;&amp;
NOT(ISPICKVAL(Status__c, &apos;Approved with New Amount&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateBudgetRequestStatus_ApprovedRequestedAmount</fullName>
        <actions>
            <name>UpdateBudgetReqStatus_ApprovedReqAmount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If budget request approved amount is equal to the requested amount, set status to &apos;Approved for Requested Amount&apos; if it has not been set already.</description>
        <formula>(Approved_Budget__c = Requested_Budget__c) &amp;&amp;
(Requested_Budget__c &gt; 0) &amp;&amp;
NOT(ISPICKVAL(Status__c, &apos;Approved for Requested Amount&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateBudgetRequestStatus_Rejected</fullName>
        <actions>
            <name>UpdateBudgetReqStatus_Rejected</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If budget request approved amount is set to 0, set status to &apos;Rejected&apos; if it has not been set already.</description>
        <formula>(Approved_Budget__c = 0) &amp;&amp;
NOT(ISBLANK(Approved_Budget__c)) &amp;&amp;
NOT(ISBLANK(Requested_Budget__c)) &amp;&amp;
NOT(ISPICKVAL(Status__c, &apos;Rejected&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
