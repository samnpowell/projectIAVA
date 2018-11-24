<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GI_Bill_Calculator_less_than_3_months_follow_up</fullName>
        <description>GI Bill Calculator - less than 3 months follow up</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>support@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>GI_Bill_Emails/GI_Bill_Calculator_less_than_3_months_followup</template>
    </alerts>
    <alerts>
        <fullName>Max_Screening_Hosts_June_2015</fullName>
        <description>Max Screening Hosts - June 2015</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/MAX_Host_Day_of_Morning_EMAIL</template>
    </alerts>
    <alerts>
        <fullName>POC_Email_Alert</fullName>
        <description>POC Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>POC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>mail@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAVA_Email_Templates/Pats_Run_POC</template>
    </alerts>
    <alerts>
        <fullName>Pats_Run_POC_Email_Alert</fullName>
        <description>Pats Run POC Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IAVA_Email_Templates/Pats_Run_POC</template>
    </alerts>
    <alerts>
        <fullName>Pats_Run_POC_Email_Alert2</fullName>
        <description>Pats Run POC Email Alert2</description>
        <protected>false</protected>
        <recipients>
            <field>POC_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>mail@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAVA_Email_Templates/Pats_Run_POC</template>
    </alerts>
    <alerts>
        <fullName>Pats_Run_Registrant_Email_Alert</fullName>
        <description>Pats Run Registrant Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>mail@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAVA_Email_Templates/Pats_Run_Registrant</template>
    </alerts>
    <alerts>
        <fullName>Promo_Request_Email_Alert</fullName>
        <ccEmails>membership@iava.org</ccEmails>
        <description>Promo Request Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>ed@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>garrett@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>IAVA_Email_Templates/Promo_Request</template>
    </alerts>
    <alerts>
        <fullName>Thanks_for_signing_Trump_Petition</fullName>
        <description>Thanks for signing Trump Petition</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Thanks_for_standing_with_IAVA</template>
    </alerts>
    <alerts>
        <fullName>sth_Ea_thankYouDeferral_deferredCampaignMember</fullName>
        <description>sth_Ea_thankYouDeferral_deferredCampaignMember</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAVA_Email_Templates/Storm_the_Hill_Deferred</template>
    </alerts>
    <alerts>
        <fullName>test_max_host_email_survey</fullName>
        <description>test max host email survey</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/TEST_MAX_HOST</template>
    </alerts>
    <fieldUpdates>
        <fullName>Campaign_Member_Field_Updates</fullName>
        <field>Archive__c</field>
        <formula>TEXT(TODAY()) &amp; BR() &amp;
PRIORVALUE(Notes__c) &amp; BR() &amp;
&quot;Guests: &quot; &amp; PRIORVALUE(Guest_s__c) &amp; BR() &amp;
&quot;Sponsorhip/Ticket Type: &quot; &amp; PRIORVALUE(Sponsorship_or_Ticket_Type__c) &amp; BR() &amp;
&quot;Number of Guests: &quot; &amp; TEXT(PRIORVALUE(Number_of_Guests__c)) &amp; BR() &amp;
&quot;Archive Field: &quot; &amp; PRIORVALUE(Archive__c) &amp; BR()</formula>
        <name>Campaign Member Field Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POC_Email_Filler</fullName>
        <field>POC_Email__c</field>
        <formula>Campaign.Local_POC__r.Email</formula>
        <name>POC Email Filler</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Campaign Member Update - Copy Previous Values to the Archive Field</fullName>
        <actions>
            <name>Campaign_Member_Field_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies previous values from the Notes and Guest(s) fields to the Archive field</description>
        <formula>Campaign.Name=&quot;2017 Heroes Gala&quot; &amp;&amp; (ISCHANGED(Notes__c) || ISCHANGED(Guest_s__c) || ISCHANGED(Sponsorship_or_Ticket_Type__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GI Bill Calculator - less than 3 months follow up</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>equals</operation>
            <value>Emails from NGIB Calc</value>
        </criteriaItems>
        <criteriaItems>
            <field>CampaignMember.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>GI_Bill_Calculator_less_than_3_months_follow_up</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>CampaignMember.LastModifiedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Pats Run POC</fullName>
        <actions>
            <name>Pats_Run_POC_Email_Alert2</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>equals</operation>
            <value>Shadow Run - Austin</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pats Run Registrant</fullName>
        <actions>
            <name>POC_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Pats_Run_Registrant_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>POC_Email_Filler</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>contains</operation>
            <value>Run</value>
        </criteriaItems>
        <criteriaItems>
            <field>CampaignMember.Status</field>
            <operation>equals</operation>
            <value>RSVP</value>
        </criteriaItems>
        <description>This workflow sends an email when someone registers for Pat&apos;s Run 2010</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Promo Request</fullName>
        <actions>
            <name>Promo_Request_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>equals</operation>
            <value>Promotional Materials</value>
        </criteriaItems>
        <criteriaItems>
            <field>CampaignMember.Status</field>
            <operation>equals</operation>
            <value>Requested</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Test Max Email Host</fullName>
        <actions>
            <name>Max_Screening_Hosts_June_2015</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>equals</operation>
            <value>MAX Screening Hosts - June 2015</value>
        </criteriaItems>
        <criteriaItems>
            <field>CampaignMember.Status</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <criteriaItems>
            <field>CampaignMember.Notes__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Thanks for signing Trump Petition</fullName>
        <actions>
            <name>Thanks_for_signing_Trump_Petition</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>equals</operation>
            <value>Trump Petition 2015</value>
        </criteriaItems>
        <description>Send a message to anyone who signs up on the Trump petition</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>sth_Ea_thankYouDeferral_deferredCampaignMember</fullName>
        <actions>
            <name>sth_Ea_thankYouDeferral_deferredCampaignMember</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>sends an email to campaign members with a status of deferred on a sth campaign</description>
        <formula>(ISNEW() || ISCHANGED(Status)) &amp;&amp;
ISPICKVAL(Status, &apos;Deferred&apos;) &amp;&amp;
(CONTAINS(Campaign.Name, &apos;STH&apos;) || CONTAINS(Campaign.Parent.Name, &apos;STH&apos;)) &amp;&amp;
CONTAINS(Campaign.Name, &apos;App&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
