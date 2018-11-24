<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AIR_Needs_to_be_Completed</fullName>
        <description>AIR Needs to be Completed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AIR_Needs_to_be_Completed</template>
    </alerts>
    <alerts>
        <fullName>Send_Dir_of_Strat_P_Notification_of_AIR_completion</fullName>
        <description>Send Dir of Strat P Notification of AIR completion</description>
        <protected>false</protected>
        <recipients>
            <recipient>david@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>matt@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Policy_templates/AIR_Completion_Notify_Dir_of_Strat_P</template>
    </alerts>
    <alerts>
        <fullName>Send_E_D_Draft_Language</fullName>
        <description>Send E.D. Draft Language</description>
        <protected>false</protected>
        <recipients>
            <recipient>chris@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>meghanl@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AIR_Draft_Language_to_EO</template>
    </alerts>
    <alerts>
        <fullName>Send_E_D_Notification_of_AIR_completion</fullName>
        <description>Send E.D. Notification of AIR completion</description>
        <protected>false</protected>
        <recipients>
            <recipient>Directors_and_Chiefs</recipient>
            <type>group</type>
        </recipients>
        <recipients>
            <recipient>chris@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>danield@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>paul@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AIR_Completion_Notify_E_O</template>
    </alerts>
    <rules>
        <fullName>AIR Needs to be Completed</fullName>
        <active>true</active>
        <criteriaItems>
            <field>AIR__c.Completed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIR__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sends a reminder email to complete AIR.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>AIR_Needs_to_be_Completed</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIR__c.CreatedDate</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>AIR_Needs_to_be_Completed</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>AIR__c.CreatedDate</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send Dir of Strat P Notification of AIR completion</fullName>
        <actions>
            <name>Send_Dir_of_Strat_P_Notification_of_AIR_completion</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIR__c.Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>AIR__c.OwnerId</field>
            <operation>equals</operation>
            <value>Mike Drake,Matt Colvin</value>
        </criteriaItems>
        <description>When an Development AIR report is marked &quot;completed&quot; and saved by a member of the team, a notification with a link to the AIR is emailed to their Director.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send E%2ED%2E Draft Language</fullName>
        <actions>
            <name>Send_E_D_Draft_Language</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIR__c.Draft_Language_for_ED__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>AIR__c.Send_Follow_up_to_EO__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When a post-event report is created, if draft language for E.D. is populated and send to EO is checked, the draft language is emailed to the EO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send E%2ED%2E Notification of AIR completion</fullName>
        <actions>
            <name>Send_E_D_Notification_of_AIR_completion</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AIR__c.Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When an AIR report is marked &quot;completed&quot;, a notification with a link to the AIR is emailed to the EO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Manager Notification of AIR completion</fullName>
        <active>false</active>
        <criteriaItems>
            <field>AIR__c.Completed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When an AIR report is marked &quot;completed&quot; and saved by a member of a team, a notification with a link to the AIR is emailed to their manager.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
