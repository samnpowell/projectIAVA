<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Ea_postEventNextSteps_allRegisteredAttendees</fullName>
        <description>Ea_postEventNextSteps_allRegisteredAttendees</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/EventFollowUpEmail_AllAttendees</template>
    </alerts>
    <alerts>
        <fullName>Events_Reminder_1_day_prior_to_Event_for_Yes_Replies</fullName>
        <description>Events Reminder - 1 day prior to Event for Yes Replies</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/EventReminder_RSVPYes_VF</template>
    </alerts>
    <alerts>
        <fullName>Events_Response_Confirmation_Yes</fullName>
        <description>Events - Response Confirmation - Yes</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/EventResponseConfirmation_RSVPYes_VF</template>
    </alerts>
    <alerts>
        <fullName>Events_VetTogether_Response_Confirmation</fullName>
        <description>Events - VetTogether Response Confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Event_templates/Events_VetTogether_Response_Confirmation</template>
    </alerts>
    <alerts>
        <fullName>Events_VetTogether_Response_Confirmation_No</fullName>
        <description>Events - VetTogether Response Confirmation - No</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/Events_Response_Confirmation_No</template>
    </alerts>
    <alerts>
        <fullName>Events_alert_attendee_of_canceled_event</fullName>
        <description>Events - alert attendee of canceled event</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/Event_Canceled_notification</template>
    </alerts>
    <alerts>
        <fullName>Events_alert_attendee_of_changed_event</fullName>
        <description>Events - alert attendee of changed event</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>COV_Templates/EventAlert_EventChangedNotification</template>
    </alerts>
    <alerts>
        <fullName>Events_notify_attendee_of_event_invitation</fullName>
        <description>Events - notify attendee of event invitation</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Event_templates/Event_Invite_notification_with_IF_logic</template>
    </alerts>
    <alerts>
        <fullName>Events_notify_attendee_of_event_invitation_from_membership_for_yahoo_senders</fullName>
        <description>Events - notify attendee of event invitation from membership for yahoo senders</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/Event_Invite_notification_with_IF_logic</template>
    </alerts>
    <alerts>
        <fullName>Post_Event_Attendee_Survey</fullName>
        <description>Post Event Attendee Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAVA_Email_Templates/Event_NO_GETFEEDBACK_Post_Event_Survey</template>
    </alerts>
    <alerts>
        <fullName>Resend_Attendee_Survey</fullName>
        <description>Resend Attendee Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/T2T_2015</template>
    </alerts>
    <fieldUpdates>
        <fullName>Clear_Resend_Attendee_Survey_on_Attendee</fullName>
        <field>Resend_Attendee_Survey__c</field>
        <literalValue>0</literalValue>
        <name>Clear Resend Attendee Survey on Attendee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Resend_Attendee_Survey_on_Event</fullName>
        <field>Resend_Attendee_Survey__c</field>
        <literalValue>0</literalValue>
        <name>Clear Resend Attendee Survey on Event</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Event__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Event_Attnd_Uncheck_Notify_attendee</fullName>
        <description>Unchecks the &quot;Notify_attendee_of_changed_event__c&quot; box</description>
        <field>Notify_attendee_of_changed_event__c</field>
        <literalValue>0</literalValue>
        <name>Event Attnd - Uncheck Notify attendee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Event_Attnd_Uncheck_notify_of_invite</fullName>
        <description>Uncheck &quot;Notify attendee of invitation&quot; checkbox</description>
        <field>Notify_attendee_of_invitation__c</field>
        <literalValue>0</literalValue>
        <name>Event Attnd - Uncheck notify of invite</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Event_Attnd_Update_Inviter_History</fullName>
        <description>Update the Inviter History field</description>
        <field>Inviter_History__c</field>
        <formula>Inviter_History__c 
&amp; if(isblank(trim(Inviter_History__c )), &apos;&apos;, &apos;, &apos;)
&amp; Inviter__r.FirstName &amp; &apos; &apos; &amp; Inviter__r.LastName &amp; &apos; (&apos; &amp;  Inviter__c  &amp; &apos;)&apos;</formula>
        <name>Event Attnd - Update Inviter History</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Event_Attnd_Update_Searchable_Name</fullName>
        <description>Updates Searchable Name text field to value of Attendee_Name__c formula</description>
        <field>Searchable_Name__c</field>
        <formula>Attendee_Name__c</formula>
        <name>Event Attnd - Update Searchable Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Clear Resend Attendee Survey on Attendee</fullName>
        <actions>
            <name>Clear_Resend_Attendee_Survey_on_Attendee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Resend_Attendee_Survey__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Self_Reported_Attended__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Clear Resend Attendee Survey on Attendee</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Ea_postEventNextSteps_allRegisteredAttendees</fullName>
        <active>true</active>
        <criteriaItems>
            <field>IAVAEvent__c.Status__c</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Suppress_Attendee_Notifications__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>email sent to all attendees who registered for an event. does not look at RSVP or attendance status. email talks about other ways to get involved</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Ea_postEventNextSteps_allRegisteredAttendees</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IAVAEvent_Attendee__c.Event_Date__c</offsetFromField>
            <timeLength>28</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Event Attnd - Update Inviter History</fullName>
        <actions>
            <name>Event_Attnd_Update_Inviter_History</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a new Inviter is added to an Event Attendee record, add them to the Inviter History list (to keep track of multiple invites)</description>
        <formula>and(  not(isblank( Inviter__c )),   or (isnew(), ischanged(Inviter__c))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Events -  Response Confirmation - Yes</fullName>
        <actions>
            <name>Events_Response_Confirmation_Yes</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Reply_Status__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Event_Date__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Suppress_Attendee_Notifications__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Suppress_Attendee_Notifications__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Canceled,Flagged/Removed</value>
        </criteriaItems>
        <description>When someone responds to a VetTogether invite with a Yes, this email confirms their response.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Events_Reminder_1_day_prior_to_Event_for_Yes_Replies</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IAVAEvent_Attendee__c.Event_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Events - Alert Attendees when Event cancelled</fullName>
        <actions>
            <name>Events_alert_attendee_of_canceled_event</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Event_Attnd_Uncheck_Notify_attendee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When event status changes to canceled, trigger checks all attendee Notify checkboxes, then this workflow sends email to anyone with a Yes or Maybe attendee record</description>
        <formula>AND(  Notify_attendee_of_changed_event__c,   OR(Event_Status__c = &quot;Canceled&quot;, Event_Status__c = &quot;Flagged/Removed&quot;),  OR( ispickval(Reply_Status__c, &quot;Yes&quot;), ispickval(Reply_Status__c, &quot;Maybe&quot;)),  OR(NOT(Suppress_Attendee_Notifications__c),NOT(Event__r.Suppress_Attendee_Notifications__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Events - Alert Attendees when Event cancelled 2</fullName>
        <actions>
            <name>Events_alert_attendee_of_canceled_event</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Notify_attendee_of_changed_event__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Event_Status__c</field>
            <operation>equals</operation>
            <value>Canceled,Flagged/Removed</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Reply_Status__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Events - Alert Attendees when Event changed</fullName>
        <actions>
            <name>Events_alert_attendee_of_changed_event</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Event_Attnd_Uncheck_Notify_attendee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When event info changes (and event not canceled), trigger checks all attendee Notify checkboxes, then this workflow sends email to anyone with a Yes or Maybe attendee record</description>
        <formula>AND(  Notify_attendee_of_changed_event__c,   Event_Status__c != &quot;Canceled&quot;,   Event_Status__c != &quot;Flagged/Removed&quot;,  OR( ispickval(Reply_Status__c, &quot;Yes&quot;), ispickval(Reply_Status__c, &quot;Maybe&quot;), ispickval(Reply_Status__c, &quot;Invited&quot;)),  OR(NOT(Suppress_Attendee_Notifications__c),NOT(Event__r.Suppress_Attendee_Notifications__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Events - Notify Attendee of invitation</fullName>
        <actions>
            <name>Events_notify_attendee_of_event_invitation</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Event_Attnd_Uncheck_notify_of_invite</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When someone gets invited to an event, send them a notification and uncheck the box again for future use</description>
        <formula>AND(  Notify_attendee_of_invitation__c ,   Event_Status__c != &quot;Cancelled&quot;,   Event_Status__c != &quot;Flagged/Removed&quot;,  OR(NOT(Suppress_Attendee_Notifications__c),NOT(Event__r.Suppress_Attendee_Notifications__c)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Events - Notify Attendee of invitation - Yahoo Sender</fullName>
        <actions>
            <name>Events_notify_attendee_of_event_invitation_from_membership_for_yahoo_senders</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Event_Attnd_Uncheck_notify_of_invite</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Notify_attendee_of_invitation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Event_Status__c</field>
            <operation>notEqual</operation>
            <value>Cancelled,Flagged/Removed</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Email</field>
            <operation>contains</operation>
            <value>yahoo</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Suppress_Attendee_Notifications__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When someone gets invited to an event by someone with a yahoo account, send them a notification from membership@iava.org and uncheck the box again for future use,</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Events - Response Confirmation - No</fullName>
        <actions>
            <name>Events_VetTogether_Response_Confirmation_No</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Reply_Status__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Suppress_Attendee_Notifications__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Suppress_Attendee_Notifications__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When someone responds to a VetTogether invite with a No, this email confirms their response.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Events - VetTogether Response Confirmation</fullName>
        <actions>
            <name>Events_VetTogether_Response_Confirmation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent__c.Type__c</field>
            <operation>equals</operation>
            <value>VetTogether</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Reply_Status__c</field>
            <operation>equals</operation>
            <value>Yes,No</value>
        </criteriaItems>
        <description>When someone responds to a VetTogether invite, this email confirms their response.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Post Event Attendee Survey</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent__c.Status__c</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Suppress_Attendee_Notifications__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Post Event Attendee Survey</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Post_Event_Attendee_Survey</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IAVAEvent_Attendee__c.Event_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Post Event Attendee Survey Follow Up</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent__c.Status__c</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Self_Reported_Attended__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Suppress_Attendee_Notifications__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Post Event Attendee Survey</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Post_Event_Attendee_Survey</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IAVAEvent_Attendee__c.Event_Date__c</offsetFromField>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Post Event Survey - Sent 1 hour after Event End Time</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Attended__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Attendee_Name__c</field>
            <operation>contains</operation>
            <value>nazreen</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Resend Attendee Survey</fullName>
        <actions>
            <name>Resend_Attendee_Survey</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Clear_Resend_Attendee_Survey_on_Attendee</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_Resend_Attendee_Survey_on_Event</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Attendee_Survey_was_Resent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Resend_Attendee_Survey__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent_Attendee__c.Self_Reported_Attended__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Suppress_Attendee_Notifications__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Resend Attendee Survey</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Searchable Name</fullName>
        <actions>
            <name>Event_Attnd_Update_Searchable_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Searchable Name if out of sync with Attendee Name</description>
        <formula>Searchable_Name__c != Attendee_Name__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Attendee_Survey_was_Resent</fullName>
        <assignedTo>robot-gf@iava.org</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Attendee Survey was Resent</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Attendee Survey was Resent</subject>
    </tasks>
</Workflow>
