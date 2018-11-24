<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Request_to_Post_Social_Media_Language</fullName>
        <description>Email Request to Post Social Media Language</description>
        <protected>false</protected>
        <recipients>
            <recipient>backgroundadmin@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/Email_Request_to_Post_Social_Media_Language</template>
    </alerts>
    <alerts>
        <fullName>Notification_of_Event_Creation_Region_1</fullName>
        <description>Notification of Event Creation - Region 1</description>
        <protected>false</protected>
        <recipients>
            <recipient>MembershipAssociate</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/Notification_of_Event_Creation_Region_1</template>
    </alerts>
    <alerts>
        <fullName>Notification_of_Event_Creation_Region_2</fullName>
        <description>Notification of Event Creation - Region 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>MembershipAssociate</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/Notification_of_Event_Creation_Region_1</template>
    </alerts>
    <alerts>
        <fullName>Notification_of_Event_Creation_Region_3</fullName>
        <description>Notification of Event Creation - Region 3</description>
        <protected>false</protected>
        <recipients>
            <recipient>MembershipAssociate</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/Notification_of_Event_Creation_Region_1</template>
    </alerts>
    <alerts>
        <fullName>Notification_of_Event_Creation_Region_4</fullName>
        <description>Notification of Event Creation - Region 4</description>
        <protected>false</protected>
        <recipients>
            <recipient>MembershipAssociate</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/Notification_of_Event_Creation_Region_1</template>
    </alerts>
    <alerts>
        <fullName>Notification_of_Event_Creation_Region_5</fullName>
        <description>Notification of Event Creation - Region 5</description>
        <protected>false</protected>
        <recipients>
            <recipient>laura@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>steven@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/Notification_of_Event_Creation_Region_1</template>
    </alerts>
    <alerts>
        <fullName>Notification_of_Event_Creation_Region_6</fullName>
        <description>Notification of Event Creation - Region 6</description>
        <protected>false</protected>
        <recipients>
            <recipient>MembershipAssociate</recipient>
            <type>role</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/Notification_of_Event_Creation_Region_1</template>
    </alerts>
    <alerts>
        <fullName>Notification_of_Event_Creation_Region_7</fullName>
        <description>Notification of Event Creation - Region 7</description>
        <protected>false</protected>
        <recipients>
            <recipient>steven@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>tracey@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Event_templates/Notification_of_Event_Creation_Region_1</template>
    </alerts>
    <fieldUpdates>
        <fullName>Events_Update_Social_Media_Status_Field</fullName>
        <description>Update the Social Media Status field for Tier 1 and Tier 2 events so, the Post Request email can be triggered for the Communications team.</description>
        <field>Social_Media_Status__c</field>
        <literalValue>Post Requested</literalValue>
        <name>Events- Update Social Media Status Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Latitudec_Purge</fullName>
        <description>Purge the Latitude__c field on the IAVAEvent__c if selected address fields change; created by the Metadata API</description>
        <field>Latitude__c</field>
        <name>MA Latitude__c Purge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Longitudec_Purge</fullName>
        <description>Purge the Longitude__c field on the IAVAEvent__c if selected address fields change; created by the Metadata API</description>
        <field>Longitude__c</field>
        <name>MA Longitude__c Purge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Email Max Event Host Survey</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent__c.Name</field>
            <operation>contains</operation>
            <value>MAX</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Email Request to Post Social Media Language for Tier 1 %26 Tier 2 Events - 3 Day Email</fullName>
        <active>true</active>
        <description>Sends email to Communication team to post social media language for upcoming events.</description>
        <formula>Event_Date__c &gt;= DATEVALUE(CreatedDate) &amp;&amp; ISPICKVAL(Social_Media_Status__c,&quot;Post Requested&quot;) &amp;&amp; OR((ISPICKVAL(Tier__c,&quot;1&quot;)),(ISPICKVAL(Tier__c ,&quot;2&quot;))) &amp;&amp;  ISPICKVAL(Status__c,&quot;Published&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Request_to_Post_Social_Media_Language</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IAVAEvent__c.Event_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email Request to Post Social Media Language for Tier 1 %26 Tier 2 Events - 7 Day Email</fullName>
        <active>true</active>
        <description>Sends email to Communication team to post social media language for upcoming events.</description>
        <formula>Event_Date__c&gt;=(TODAY()+4) &amp;&amp; ISPICKVAL(Social_Media_Status__c,&quot;Post Requested&quot;) &amp;&amp; OR((ISPICKVAL(Tier__c,&quot;1&quot;)),(ISPICKVAL(Tier__c ,&quot;2&quot;))) &amp;&amp;  ISPICKVAL(Status__c,&quot;Published&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Request_to_Post_Social_Media_Language</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IAVAEvent__c.Event_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Email Request to Post Social Media Language for Tier 3 %26 Tier 4 Events - 4 Day Email</fullName>
        <active>true</active>
        <description>Sends email to Communication team to post social media language for upcoming events.</description>
        <formula>Event_Date__c &gt;= DATEVALUE(CreatedDate) &amp;&amp; ISPICKVAL(Social_Media_Status__c,&quot;Post Requested&quot;) &amp;&amp; OR((ISPICKVAL(Tier__c,&quot;3&quot;)),(ISPICKVAL(Tier__c ,&quot;4&quot;))) &amp;&amp; ISPICKVAL(Status__c,&quot;Published&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Request_to_Post_Social_Media_Language</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>IAVAEvent__c.Event_Date__c</offsetFromField>
            <timeLength>-4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Events- Update Social Media Status Field</fullName>
        <active>true</active>
        <description>Edit the Social Media Status field for Tier 1 and Tier 2 events so, the Post Request email can be triggered for the Communications team.</description>
        <formula>Event_Date__c&gt;=(TODAY()+3) &amp;&amp; ISPICKVAL(Social_Media_Status__c,&quot;Post Published&quot;) &amp;&amp; OR((ISPICKVAL(Tier__c,&quot;1&quot;)),(ISPICKVAL(Tier__c ,&quot;2&quot;))) &amp;&amp;  ISPICKVAL(Status__c,&quot;Published&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Events_Update_Social_Media_Status_Field</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>IAVAEvent__c.Event_Date__c</offsetFromField>
            <timeLength>-3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>IAVAEventc_LocationCityc_Field_Changed</fullName>
        <actions>
            <name>Latitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Longitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the IAVAEvent__c if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(Location_City__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IAVAEventc_LocationStatec_Field_Changed</fullName>
        <actions>
            <name>Latitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Longitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the IAVAEvent__c if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(Location_State__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IAVAEventc_LocationStreetAddressc_Field_Changed</fullName>
        <actions>
            <name>Latitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Longitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the IAVAEvent__c if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(Location_Street_Address__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>IAVAEventc_LocationZipCodec_Field_Changed</fullName>
        <actions>
            <name>Latitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Longitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the IAVAEvent__c if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(Location_Zip_Code__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notification of Event Creation - Region 1</fullName>
        <actions>
            <name>Notification_of_Event_Creation_Region_1</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent__c.Status__c</field>
            <operation>equals</operation>
            <value>Published,Unpublished</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Region__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <description>notifies region 1 owner of a new event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification of Event Creation - Region 2</fullName>
        <actions>
            <name>Notification_of_Event_Creation_Region_2</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent__c.Status__c</field>
            <operation>equals</operation>
            <value>Published,Unpublished</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Region__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <description>notifies region 2 owner of a new event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification of Event Creation - Region 3</fullName>
        <actions>
            <name>Notification_of_Event_Creation_Region_3</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent__c.Status__c</field>
            <operation>equals</operation>
            <value>Published,Unpublished</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Region__c</field>
            <operation>equals</operation>
            <value>3</value>
        </criteriaItems>
        <description>notifies region 3 owner of a new event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification of Event Creation - Region 4</fullName>
        <actions>
            <name>Notification_of_Event_Creation_Region_4</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent__c.Status__c</field>
            <operation>equals</operation>
            <value>Published,Unpublished</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Region__c</field>
            <operation>equals</operation>
            <value>4</value>
        </criteriaItems>
        <description>notifies region 4 owner of a new event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification of Event Creation - Region 5</fullName>
        <actions>
            <name>Notification_of_Event_Creation_Region_5</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IAVAEvent__c.Status__c</field>
            <operation>equals</operation>
            <value>Published,Unpublished</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Region__c</field>
            <operation>equals</operation>
            <value>5</value>
        </criteriaItems>
        <description>notifies region 5 owner of a new event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification of Event Creation - Region 6</fullName>
        <actions>
            <name>Notification_of_Event_Creation_Region_6</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent__c.Status__c</field>
            <operation>equals</operation>
            <value>Published,Unpublished</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Region__c</field>
            <operation>equals</operation>
            <value>6</value>
        </criteriaItems>
        <description>notifies region 6 owner of a new event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification of Event Creation - Region 7</fullName>
        <actions>
            <name>Notification_of_Event_Creation_Region_7</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>IAVAEvent__c.Status__c</field>
            <operation>equals</operation>
            <value>Published,Unpublished</value>
        </criteriaItems>
        <criteriaItems>
            <field>IAVAEvent__c.Region__c</field>
            <operation>equals</operation>
            <value>7</value>
        </criteriaItems>
        <description>notifies region 7 owner of a new event</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send the Host a GetFeedback Survey</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent__c.Event_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>The day after a VetTogether event (Anything using the IAVA Event Object), send the event host (Event Owner) an email with a link to the GetFeedback survey, customized to write data back to the correct event.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>IAVAEvent__c.Event_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set Event Attendee Survey checkbox</fullName>
        <active>false</active>
        <criteriaItems>
            <field>IAVAEvent__c.Resend_Attendee_Survey__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
