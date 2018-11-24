<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Notify_of_New_Case</fullName>
        <description>Case: Notify of New Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>Overseer</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_templates/Cases_Notify_of_new_Case</template>
    </alerts>
    <alerts>
        <fullName>Case_Notify_transition_email_of_new_Referral_Case</fullName>
        <ccEmails>transition@iava.org</ccEmails>
        <description>Case: Notify transition email of new Referral Case</description>
        <protected>false</protected>
        <senderAddress>transition@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_templates/Cases_Notify_of_new_Case</template>
    </alerts>
    <alerts>
        <fullName>Case_Owner_Change</fullName>
        <description>Case: Owner Change</description>
        <protected>false</protected>
        <recipients>
            <recipient>Overseer</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_templates/Cases_Owner_Change</template>
    </alerts>
    <alerts>
        <fullName>Case_Owner_Change_for_Referral_Cases</fullName>
        <description>Case: Owner Change for Referral Cases</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_templates/Cases_Owner_Change</template>
    </alerts>
    <alerts>
        <fullName>Cases_Notify_of_Status_change</fullName>
        <description>Cases - Notify of Status change</description>
        <protected>false</protected>
        <recipients>
            <recipient>Overseer</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_templates/Cases_Notify_of_changed_Case_Status</template>
    </alerts>
    <alerts>
        <fullName>Cases_Notify_of_impending_closure</fullName>
        <description>Cases - Notify of impending closure</description>
        <protected>false</protected>
        <recipients>
            <recipient>Overseer</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Requestor__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_templates/Cases_Notify_of_impending_case_closure</template>
    </alerts>
    <alerts>
        <fullName>Ea_webIntakeSubmitted_notify</fullName>
        <ccEmails>Transition@iava.org</ccEmails>
        <description>Ea_webIntakeSubmitted_notify</description>
        <protected>false</protected>
        <recipients>
            <recipient>gregm@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_templates/Cases_Notify_of_new_Case</template>
    </alerts>
    <alerts>
        <fullName>RRRP_Intake_Ea_IntakeFormCompleted_VTM</fullName>
        <description>RRRP_Intake_Ea_IntakeFormCompleted_VTM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>transition@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/RRRP_Intake_Ea_IntakeFormCompleted_VTM</template>
    </alerts>
    <alerts>
        <fullName>RRRP_Program_Survey_Email</fullName>
        <description>RRRP Program - Survey Email</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>transition@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Case_templates/RRRPProgram_Survey_Email</template>
    </alerts>
    <alerts>
        <fullName>Research_Request_Approaching_Deadline</fullName>
        <description>Research Request Approaching Deadline</description>
        <protected>false</protected>
        <recipients>
            <recipient>stephanie@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_templates/Cases_Research_Due_Date</template>
    </alerts>
    <alerts>
        <fullName>Research_Request_Approval_Draft</fullName>
        <description>Research Request Approval Draft</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_templates/Cases_RR_Draft_Approval</template>
    </alerts>
    <alerts>
        <fullName>X24HourRule_Ea_TriageReminderToSFTeam</fullName>
        <description>24HourRule_Ea_TriageReminderToSFTeam</description>
        <protected>false</protected>
        <recipients>
            <recipient>Executer</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Overseer</recipient>
            <type>caseTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Case_templates/SalesforceSupportCaseNotTriaged24Hrs</template>
    </alerts>
    <fieldUpdates>
        <fullName>Cases_Research_Request_Update_Status_t</fullName>
        <field>Status</field>
        <literalValue>Under Review</literalValue>
        <name>Cases - Research Request Update Status t</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cases_update_Status_to_Deployed_Comple</fullName>
        <description>Update Status field to Deployed/Complete</description>
        <field>Status</field>
        <literalValue>Deployed / Complete</literalValue>
        <name>Cases - update Status to Deployed/Comple</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>24HourRule_Ea_TriageReminderToSFTeam</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Salesforce Support</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>send a reminder email to the salesforce team if a salesforce support case is not triaged within 24 hours</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>X24HourRule_Ea_TriageReminderToSFTeam</name>
                <type>Alert</type>
            </actions>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Cases - Notify of Owner change</fullName>
        <actions>
            <name>Case_Owner_Change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When a case goes to a new Owner, this workflow will send them an email to inform them.</description>
        <formula>and(ISCHANGED( OwnerId  ), RecordTypeId != &apos;012C0000000BrH8&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cases - Notify of Owner change for Referral Cases</fullName>
        <actions>
            <name>Case_Owner_Change_for_Referral_Cases</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When a Referral case goes to a new Owner, this workflow will send them an email to inform them.</description>
        <formula>and(ISCHANGED( OwnerId  ),  RecordTypeId == &apos;012C0000000BrH8&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cases - Notify of new Case</fullName>
        <actions>
            <name>Case_Notify_of_New_Case</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>When a case is created (status = new), notify requestor, support designee, and overseer.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Cases - Notify of status change</fullName>
        <actions>
            <name>Cases_Notify_of_Status_change</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When a case status changes, notify user.</description>
        <formula>and( ISCHANGED( Status ), RecordTypeId != &apos;012C0000000BrH8&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Cases - Notify transition email of new Referral Case</fullName>
        <actions>
            <name>Case_Notify_transition_email_of_new_Referral_Case</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Intake,New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Referral System</value>
        </criteriaItems>
        <description>When a case is created (status = new or awaiting intake) and case type is referral system, notify transition@iava.org</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Cases - RR Due in 24 Hours - from Due Date</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Research Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>More Info Needed,Canceled,Under Review,In Progress,New,Solution Drafted,On Hold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Estimated_Resolution_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Due_Date_Requested__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If there&apos;s no estimated resolution date but there is a Due Date Requested, set an email alert reminder for the day before the Due Date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Research_Request_Approaching_Deadline</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Due_Date_Requested__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Cases - RR Due in 24 Hours - from Est Date</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Research Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>More Info Needed,Canceled,Under Review,In Progress,New,Solution Drafted,On Hold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Estimated_Resolution_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Due_Date_Requested__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If there&apos;s an estimated resolution date, set an email alert reminder for the day before</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Research_Request_Approaching_Deadline</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Estimated_Resolution_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Cases - Research Request Draft Approval</fullName>
        <actions>
            <name>Research_Request_Approval_Draft</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Research Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Solution Drafted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Cases - notify of impending Case closure and close Ready for Testing case</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Completed - Ready for Testing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Referral System,Education</value>
        </criteriaItems>
        <description>A week after a case goes into Ready for Testing mode, notify the user that it will be closed in another week.  After 2 weeks, close case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Cases_Notify_of_impending_closure</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Cases_update_Status_to_Deployed_Comple</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>EaT_webIntakeSubmitted_notifyAndFollowUp</fullName>
        <actions>
            <name>Ea_webIntakeSubmitted_notify</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Follow_up_with_new_RRRP_client</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Referral System</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web Intake Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>VVH Intake Form</value>
        </criteriaItems>
        <description>when a referral case is submitted via the new web intake form, create a task assigned to the intake coordinator and send a notification email to transition</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RRRP Program - Survey Email</fullName>
        <actions>
            <name>RRRP_Program_Survey_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>RRRP_Program_Survey_Email_sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Name == &apos;Referral System&apos; &amp;&amp;
ISPICKVAL(Status, &apos;Closed&apos;) &amp;&amp;
ISCHANGED(Status)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RRRP_Intake_Ea_IntakeFormCompleted_VTM</fullName>
        <actions>
            <name>RRRP_Intake_Ea_IntakeFormCompleted_VTM</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Completed_Intake_Form_Email_Sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Referral System</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Intake_Form_Completed_Date__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Web Intake Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>VVH Intake Form</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Completed_Intake_Form_Email_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <description>This task will be logged as completed when the intake completed email is sent to the VTM. This will help track if the workflow rule triggered or not.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Completed Intake Form Email - Sent</subject>
    </tasks>
    <tasks>
        <fullName>Follow_up_with_new_RRRP_client</fullName>
        <assignedTo>gregm@iava.org</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Follow up with new RRRP client</subject>
    </tasks>
    <tasks>
        <fullName>RRRP_Program_Survey_Email_sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>RRRP Program - Survey Email - sent</subject>
    </tasks>
</Workflow>
