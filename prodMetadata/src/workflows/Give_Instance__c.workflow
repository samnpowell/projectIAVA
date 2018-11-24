<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>RuckSack_give_instance_ending_notification</fullName>
        <ccEmails>partner@iava.org</ccEmails>
        <description>RuckSack - give instance ending notification</description>
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
        <template>Rucksack_templates/RuckSack_GiveInstance_end_or_deadline_notification</template>
    </alerts>
    <alerts>
        <fullName>RuckSack_give_instance_full_notification</fullName>
        <ccEmails>partner@iava.org</ccEmails>
        <description>RuckSack - give instance full notification</description>
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
        <template>Rucksack_templates/RuckSack_GiveInstance_full_notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Rucksack_GiveInstance_Status_Closed</fullName>
        <description>Sets GiveInstance Status field to Closed.</description>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Rucksack - GiveInstance Status Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rucksack_GiveInstance_status_Open</fullName>
        <description>Sets GiveInstance Status field to Open.</description>
        <field>Status__c</field>
        <literalValue>Open</literalValue>
        <name>Rucksack - GiveInstance status Open</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rucksack_GiveInstance_status_Waitlist</fullName>
        <description>Sets GiveInstance Status field to Waitlist.</description>
        <field>Status__c</field>
        <literalValue>Waitlist</literalValue>
        <name>Rucksack - GiveInstance status Waitlist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>RuckSack - GiveInstance schedule close after App Deadline</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Give__c.Ignore_Dates_and_Availability__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Instance__c.Application_Deadline__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Closes Give Instance after App Deadline unless Ignore Dates is checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RuckSack_give_instance_ending_notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Rucksack_GiveInstance_Status_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Give_Instance__c.Application_Deadline__c</offsetFromField>
            <timeLength>27</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RuckSack - GiveInstance schedule close after End Date if no App Deadline</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Give__c.Ignore_Dates_and_Availability__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Instance__c.Application_Deadline__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Instance__c.End_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If there is no App Deadline, schedule Give to close after End Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RuckSack_give_instance_ending_notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Rucksack_GiveInstance_Status_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Give_Instance__c.End_Date__c</offsetFromField>
            <timeLength>27</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RuckSack - GiveInstance schedule close after Start Date if no App Deadline or End Date</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Give__c.Ignore_Dates_and_Availability__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Instance__c.Application_Deadline__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Instance__c.End_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Instance__c.Start_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Give__c.Category__c</field>
            <operation>equals</operation>
            <value>Events</value>
        </criteriaItems>
        <description>For Gives of category &quot;Events&quot;, if there is no App Deadline or End Date, schedule close after Start Date since the event has started.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RuckSack_give_instance_ending_notification</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Rucksack_GiveInstance_Status_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Give_Instance__c.Start_Date__c</offsetFromField>
            <timeLength>27</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RuckSack - GiveInstance set status Closed if full and no waitlist</fullName>
        <actions>
            <name>RuckSack_give_instance_full_notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Rucksack_GiveInstance_Status_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Give__c.Type__c</field>
            <operation>equals</operation>
            <value>First Come First Served</value>
        </criteriaItems>
        <criteriaItems>
            <field>Give__c.Waitlist__c</field>
            <operation>equals</operation>
            <value>No Waitlist</value>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Instance__c.Tentative_Number_Remaining__c</field>
            <operation>lessOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Instance__c.Number_of_Units__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>If a Give Instance fills up and it&apos;s not a Give with waitlist, set instance Status to Closed and notify staff.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveInstance set status Open if not full</fullName>
        <actions>
            <name>Rucksack_GiveInstance_status_Open</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If instance dates havent passed and num remaining &gt; 0, set Status to Open.</description>
        <formula>and( or(Application_Deadline__c &gt;= TODAY(),isnull(Application_Deadline__c)),  or(End_Date__c &gt;= TODAY(),isnull(End_Date__c)), Number_Remaining__c &gt; 0)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveInstance set status Waitlist if full and waitlist-give</fullName>
        <actions>
            <name>RuckSack_give_instance_full_notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Rucksack_GiveInstance_status_Waitlist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Give__c.Type__c</field>
            <operation>equals</operation>
            <value>First Come First Served</value>
        </criteriaItems>
        <criteriaItems>
            <field>Give__c.Waitlist__c</field>
            <operation>notEqual</operation>
            <value>No Waitlist</value>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Instance__c.Tentative_Number_Remaining__c</field>
            <operation>lessOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Instance__c.Number_of_Units__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Set give instance to Waitlist status if it&apos;s a waitlist Give with no confirmation room left and notify staff.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
