<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GiveRequest_Email_Welcome_NewRegistrant</fullName>
        <description>GiveRequest_Email_Welcome_NewRegistrant</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>mail@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Apgar_Test_E_mails/WelcomeEmail_GiveRegistrant</template>
    </alerts>
    <alerts>
        <fullName>Gives_Ea_VetsDayFinalConfirmationUnlimitedGiveTextConfirmationGuestUser</fullName>
        <description>Gives_Ea_VetsDayFinalConfirmationUnlimitedGiveTextConfirmationGuestUser</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Apgar_Test_E_mails/Rucksack_UnlimitedGiveRequest_VetsDayCustomConfirmationSiteGuest</template>
    </alerts>
    <alerts>
        <fullName>RuckSack_address_change_notification</fullName>
        <ccEmails>addresschange@iavacommon.emailcenterpro.com</ccEmails>
        <description>RuckSack - address change notification</description>
        <protected>false</protected>
        <senderAddress>rucksack@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/RuckSack_address_change_requested</template>
    </alerts>
    <alerts>
        <fullName>RuckSack_send_cancellation_email</fullName>
        <description>RuckSack - send cancellation email</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/RuckSack_GiveRequest_cancelled</template>
    </alerts>
    <alerts>
        <fullName>RuckSack_send_confirmation_for_information_give</fullName>
        <description>RuckSack - send confirmation for information give</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/RuckSack_GiveRequest_Information_email</template>
    </alerts>
    <alerts>
        <fullName>RuckSack_send_confirmation_for_screened_give</fullName>
        <description>RuckSack - send confirmation for screened give</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>rucksack@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/RuckSack_GiveRequest_for_Screened_Give</template>
    </alerts>
    <alerts>
        <fullName>RuckSack_send_confirmation_for_unlimited_give</fullName>
        <description>RuckSack - send confirmation for unlimited give</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>rucksack@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/RuckSack_Unlimited_confirmation</template>
    </alerts>
    <alerts>
        <fullName>RuckSack_send_final_confirmation</fullName>
        <description>RuckSack - send final confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>rucksack@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/RuckSack_GiveRequest_Final_confirmation</template>
    </alerts>
    <alerts>
        <fullName>RuckSack_send_rejection_email</fullName>
        <description>RuckSack - send rejection email</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/RuckSack_GiveRequest_rejection</template>
    </alerts>
    <alerts>
        <fullName>RuckSack_send_tentative_confirmation</fullName>
        <description>RuckSack - send tentative confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>rucksack@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/RuckSack_GiveRequest_Tentative_confirmation</template>
    </alerts>
    <alerts>
        <fullName>RuckSack_send_waitlist_confirmation</fullName>
        <description>RuckSack - send waitlist confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/RuckSack_GiveRequest_waitlisted</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_Ea_FinalConfirmationGiveRequest_TextConfirmationFormyIAVASiteGuestUser</fullName>
        <description>Rucksack_Ea_FinalConfirmationGiveRequest_TextConfirmationFormyIAVASiteGuestUser</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_FinalConfirmationGiveRequest_TextConfirmationFormyIAVASiteGuest</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_Ea_GiveRequestedGiveRequest_TextConfirmationFormyIAVASiteGuestUser</fullName>
        <description>Rucksack_Ea_GiveRequestedGiveRequest_TextConfirmationFormyIAVASiteGuestUser</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_GiveRequestedGiveRequest_TextConfirmationFormyIAVASiteGuest</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_Ea_InformationGiveRequest_TextConfirmationFormyIAVASiteGuestUser</fullName>
        <description>Rucksack_Ea_InformationGiveRequest_TextConfirmationFormyIAVASiteGuestUser</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_InformationGiveRequest_TextConfirmationFormyIAVASiteGuest</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_Ea_TentativeConfirmationGiveRequest_TextConfirmationFormyIAVASiteGuestU</fullName>
        <description>Rucksack_Ea_TentativeConfirmationGiveRequest_TextConfirmationFormyIAVASiteGuestUser</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_TentativeConfirmationGiveRequest_TextConfirmationFormyIAVASiteGuest</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_Ea_UnlimitedGiveRequest_TextConfirmationFormyIAVASiteGuestUser</fullName>
        <description>Rucksack_Ea_UnlimitedGiveRequest_TextConfirmationFormyIAVASiteGuestUser</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_UnlimitedGiveRequest_TextConfirmationFormyIAVASiteGuest</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_Ea_WaitlistGiveRequest_TextConfirmationFormyIAVASiteGuestUser</fullName>
        <description>Rucksack_Ea_WaitlistGiveRequest_TextConfirmationFormyIAVASiteGuestUser</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_WaitlistedGiveRequest_TextConfirmationFormyIAVASiteGuest</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_new_request_for_notify_contact</fullName>
        <ccEmails>partner@iava.org</ccEmails>
        <description>Rucksack - new request for notify contact</description>
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
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/RuckSack_notify_staff_of_new_request_for_notify_contact</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_notify_internal_POC_of_canceled_give_request</fullName>
        <description>Rucksack - notify internal POC of canceled give request - argh doesnt work</description>
        <protected>false</protected>
        <recipients>
            <recipient>backgroundadmin@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>rucksack@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_notify_internal_POC_of_canceled_Give_Request</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_plain_text_email_confirmation</fullName>
        <description>Rucksack plain text email confirmation</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>info@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_GiveRequest_send_text_confirmation_email_myIAVA_Site_Guest</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_send_combined_confirmation_email</fullName>
        <description>Rucksack - send combined confirmation email</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/RuckSack_GiveRequest_delivery_combined</template>
    </alerts>
    <alerts>
        <fullName>Rucksack_send_reconfirm_email</fullName>
        <description>Rucksack - send reconfirm email</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>rucksack@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_Reconfirm_email</template>
    </alerts>
    <alerts>
        <fullName>SF_Fleet_Week_Job_Fair_Employment_Survey</fullName>
        <description>Rucksack - SF Fleet Week Job Fair Employment Survey</description>
        <protected>false</protected>
        <recipients>
            <field>Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>rucksack@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAVA_Email_Templates/Fleet_Week_Job_Fair_RS</template>
    </alerts>
    <alerts>
        <fullName>Send_a_Confirmation_Request_email_to_the_member2</fullName>
        <description>Send a Confirmation Request email to the member</description>
        <protected>false</protected>
        <recipients>
            <field>Applicant__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>rucksack@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_Reconfirm_email</template>
    </alerts>
    <alerts>
        <fullName>Send_an_information_request_e_mail_when_the_conditions_are_met_iphone_app_and_fi</fullName>
        <description>Send an information request e-mail when the conditions are met (iphone app and fields to be collected ‘at request’</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>rucksack@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Rucksack_templates/Rucksack_Information_request_email</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_status_to_reconfirm_sent</fullName>
        <description>When the record is saved and the Re-confirm Date on the Give is not null
Schedule a time dependant workflow for 8AM ET of the re-confirm date to change the Re-confirm Status to ‘Re-confirm Sent’</description>
        <field>Re_confirm_Status__c</field>
        <literalValue>Re-confirm sent</literalValue>
        <name>Rucksack Change status to reconfirm sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_SourceDetails_GiveName_PerGivReq</fullName>
        <field>Source_Details__c</field>
        <formula>Give_Name__c</formula>
        <name>Contact_SourceDetails_GiveName_PerGivReq</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Applicant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Source_Give_FromGiveRequest</fullName>
        <field>Source__c</field>
        <literalValue>Give</literalValue>
        <name>Contact_Source_Give_FromGiveRequest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Applicant__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>GiveRequest_GiveFulfillmentInstructions</fullName>
        <description>pull give fulfillment instructions rtf from the grandparent give</description>
        <field>Give_Fulfillment_Instructions_rtf__c</field>
        <formula>Give_Instance__r.Give__r.Fulfillment_Instructions_rtf__c</formula>
        <name>GiveRequest_GiveFulfillmentInstructions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Give_Request_Stage_Final_Confirmation</fullName>
        <description>Set Give Request stage to Final Confirmation</description>
        <field>Stage__c</field>
        <literalValue>Final confirmation</literalValue>
        <name>Give Request - Stage Final Confirmation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Give_Request_Stage_Give_Requested</fullName>
        <description>On Give Request record set stage to Give Requested</description>
        <field>Stage__c</field>
        <literalValue>Give requested</literalValue>
        <name>Give Request - Stage Give Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Give_Request_Stage_Information_sent</fullName>
        <description>Set Give Request stage to Information sent</description>
        <field>Stage__c</field>
        <literalValue>Information sent</literalValue>
        <name>Give Request - Stage Information sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Give_Request_Stage_Tentative_Conf</fullName>
        <description>Sets Give Request to Stage = Tentative confirmation</description>
        <field>Stage__c</field>
        <literalValue>Tentative confirmation</literalValue>
        <name>Give Request - Stage Tentative Conf</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Give_Request_Stage_Waitlist</fullName>
        <field>Stage__c</field>
        <literalValue>Wait-list</literalValue>
        <name>Give Request - Stage Waitlist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Increment_Re_confirm_Count</fullName>
        <description>Increment Re-confirm Count</description>
        <field>Re_confirm_Count__c</field>
        <formula>Re_confirm_Count__c  + 1</formula>
        <name>Rucksack - Increment Re-confirm Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RuckSack_GiveIDContactID_clear</fullName>
        <description>Clears value in Give ID plus Contact ID</description>
        <field>Contact_ID_plus_Give_ID__c</field>
        <name>RuckSack - GiveIDContactID clear</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RuckSack_GiveIDContactID_set</fullName>
        <description>Sets Give ID plus Contact ID</description>
        <field>Contact_ID_plus_Give_ID__c</field>
        <formula>Applicant__c 
+ if( or(ispickval(Give_Instance__r.Give__r.Type__c, &quot;Unlimited&quot;), ispickval(Give_Instance__r.Give__r.Type__c, &quot;Information&quot;)), Id, &quot;&quot;)
+ Give_Instance__r.Give__c</formula>
        <name>RuckSack - GiveIDContactID set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rucksack_Increment_Re_confirm_Count</fullName>
        <description>Increment Re-confirm Count</description>
        <field>Re_confirm_Count__c</field>
        <formula>Re_confirm_Count__c + 1</formula>
        <name>Rucksack - Increment Re-confirm Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rucksack_set_Date_First_Emailed_today</fullName>
        <description>If Give Request&apos;s Date First Emailed is blank set to today, otherwise keep previous value.</description>
        <field>Date_First_Emailed__c</field>
        <formula>if(isblank( Date_First_Emailed__c ),TODAY(), Date_First_Emailed__c )</formula>
        <name>Rucksack - set Date First Emailed today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rucksack_set_Date_Last_Emailed_today</fullName>
        <description>Sets Give Request Date Last Emailed to today</description>
        <field>Date_Last_Emailed__c</field>
        <formula>TODAY()</formula>
        <name>Rucksack - set Date Last Emailed today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rucksack_set_Date_Last_Emailed_today2</fullName>
        <description>Sets Give Request Date Last Emailed to today</description>
        <field>Date_Last_Emailed__c</field>
        <formula>TODAY()</formula>
        <name>Rucksack - set Date Last Emailed today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GiveRequest_EaFu_WelcomeApplicantAddSourceAndDetails</fullName>
        <actions>
            <name>GiveRequest_Email_Welcome_NewRegistrant</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Contact_SourceDetails_GiveName_PerGivReq</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_Source_Give_FromGiveRequest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If a new member requests a give (the applicant did not previously exist in salesforce), change the contact&apos;s source to give and the source details to the give name.</description>
        <formula>NOT(ISBLANK(Applicant__c)) &amp;&amp; (DATEVALUE(Applicant__r.CreatedDate) == DATEVALUE(CreatedDate)) &amp;&amp; DATEVALUE(CreatedDate) == TODAY() &amp;&amp; !Applicant__r.No_Email_Blasts__c &amp;&amp; !Applicant__r.Not_a_Veteran__c &amp;&amp; !Applicant__r.Veteran_Family_Member__c &amp;&amp; !Applicant__r.Veteran_of_Other_Era__c &amp;&amp; !Applicant__r.Veteran_Member__c &amp;&amp; !Applicant__r.Post_9_11_Veteran__c &amp;&amp; !Applicant__r.Submitted_Application__c &amp;&amp; ISPICKVAL(Applicant__r.Source__c,&apos;&apos;) &amp;&amp; ISBLANK(Applicant__r.Welcome_Email_Sent__c)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Gives_Ea_VetsDayFinalConfirmationUnlimitedGiveTextConfirmationGuestUser</fullName>
        <actions>
            <name>Gives_Ea_VetsDayFinalConfirmationUnlimitedGiveTextConfirmationGuestUser</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Plain text confirmation of unlimited give request email to be sent by the myIAVA Site Guest User who cannot use the combined visualforce template - used for Veterans Day give only because they just had to have a specific fucking email</description>
        <formula>(isNew() || isChanged(Stage__c)) &amp;&amp; $User.Alias = &apos;guest&apos; &amp;&amp; isPickVal(Stage__c, &apos;Final confirmation&apos;) &amp;&amp; isPickVal(Give_Instance__r.Give__r.Type__c, &apos;Unlimited Give&apos;) &amp;&amp; CONTAINS(Give_Instance__r.Give__r.Name, &apos;I March For&apos;) &amp;&amp; CONTAINS(Give_Instance__r.Give__r.Name, &apos;Veterans Day Virtual March&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest - send cancellation email</fullName>
        <actions>
            <name>RuckSack_send_cancellation_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Give_Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>When a Give Request is cancelled, send the appropriate email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest - send confirmation email for info give</fullName>
        <actions>
            <name>RuckSack_send_confirmation_for_information_give</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Send confirmation email for Information give</description>
        <formula>and(ispickval(Give_Instance__r.Give__r.Type__c, &quot;Information&quot;), ispickval(Stage__c, &quot;Information sent&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest - send confirmation email for unlimited give</fullName>
        <actions>
            <name>RuckSack_send_confirmation_for_unlimited_give</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Send confirmation of Give Request for unlimited give</description>
        <formula>and(ispickval(Give_Instance__r.Give__r.Type__c, &quot;Unlimited Give&quot;), ispickval(Stage__c, &quot;Final confirmation&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest - send confirmation email for waitlisted give request</fullName>
        <actions>
            <name>RuckSack_send_waitlist_confirmation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Give_Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Wait-list</value>
        </criteriaItems>
        <description>Send confirmation of waitlisted Give Request</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest - send confirmation of Screened Give request</fullName>
        <actions>
            <name>RuckSack_send_confirmation_for_screened_give</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Deactivated because already covered in other workflow.</description>
        <formula>and(ispickval(Give_Instance__r.Give__r.Type__c,&quot;Screened Give&quot;) , ispickval(Stage__c, &quot;Give requested&quot;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest - send final confirmation email</fullName>
        <actions>
            <name>RuckSack_send_final_confirmation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Send confirmation email for a Give Request with stage Final Confirmation on a non-unlimited non-info Give</description>
        <formula>and( not(ispickval(Give_Instance__r.Give__r.Type__c, &quot;Unlimited Give&quot;)),  not(ispickval(Give_Instance__r.Give__r.Type__c, &quot;Information&quot;)), ispickval(Stage__c, &quot;Final confirmation&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest - send rejection email</fullName>
        <actions>
            <name>RuckSack_send_rejection_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Give_Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Denied,Ineligible</value>
        </criteriaItems>
        <description>When a Give Request is rejected, send the appropriate email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest - send tenative confirmation email</fullName>
        <actions>
            <name>RuckSack_send_tentative_confirmation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Give_Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Tentative confirmation</value>
        </criteriaItems>
        <description>When a Give Request stage is Tentative Confirmation, send the appropriate email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest prevent dupe clear field for same Give and Applicant</fullName>
        <actions>
            <name>RuckSack_GiveIDContactID_clear</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If stage is Cancelled, clear the GiveID plus ContactID field so the member can make another request.</description>
        <formula>and( not(ISNEW()), ispickval(Stage__c, &quot;Cancelled&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest prevent dupe confirmed Request for same Give and Applicant</fullName>
        <actions>
            <name>RuckSack_GiveIDContactID_set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Give_Request__c.Stage__c</field>
            <operation>notEqual</operation>
            <value>Cancelled</value>
        </criteriaItems>
        <description>If stage is anything but Cancelled, enter the GiveID plus ContactID into a unique text field to prevent a duplicate request.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest stage set for FirstCome Tentative Confirmation</fullName>
        <actions>
            <name>Give_Request_Stage_Tentative_Conf</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When Give Request comes in for First-Come give with space, set request to Tentative Confirmation.</description>
        <formula>and(ispickval(Give_Instance__r.Give__r.Type__c, &quot;First Come First Served&quot;), Give_Instance__r.Number_Remaining__c &gt;  0 )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest stage set for FirstCome Waitlisted</fullName>
        <actions>
            <name>Give_Request_Stage_Waitlist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When new Give Request comes in for full First-Come give with waitlist, set give request Stage to Waitlist</description>
        <formula>and(ispickval( Give_Instance__r.Give__r.Type__c,&quot;First Come First Served&quot;), not(ispickval(Give_Instance__r.Give__r.Waitlist__c,&quot;No Waitlist&quot;)), Give_Instance__r.Number_Remaining__c &lt;= 0)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest stage set for Info Give</fullName>
        <actions>
            <name>Give_Request_Stage_Information_sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When Give Request comes in for Info give, set give request to Information sent.</description>
        <formula>ispickval(Give_Instance__r.Give__r.Type__c, &quot;Information&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest stage set for Screened Give</fullName>
        <actions>
            <name>Give_Request_Stage_Give_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When Give Request comes in for Screened give, set give request to Give Requested.</description>
        <formula>ispickval(Give_Instance__r.Give__r.Type__c, &quot;Screened Give&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - GiveRequest stage set for Unlimited Give</fullName>
        <actions>
            <name>Give_Request_Stage_Final_Confirmation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When Give Request comes in for Unlimited give, set give request to FInal Confirmation.</description>
        <formula>ispickval(Give_Instance__r.Give__r.Type__c, &quot;Unlimited Give&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - requested change in address or email</fullName>
        <actions>
            <name>RuckSack_address_change_notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Alerts Ed if there is a change in address info during a Give Request</description>
        <formula>or(
and(
Make_Address_Primary__c,
or( Address__c &lt;&gt; Applicant__r.MailingStreet,
       City__c &lt;&gt; Applicant__r.MailingCity,
       Zip_Code__c &lt;&gt; Applicant__r.MailingPostalCode
)
),

and(
Make_Email_Primary__c, 
Email_Address__c&lt;&gt; Applicant__r.Email, Email_Address__c&lt;&gt;Applicant__r.npe01__WorkEmail__c, Email_Address__c&lt;&gt;Applicant__r.npe01__HomeEmail__c, Email_Address__c&lt;&gt;Applicant__r.npe01__AlternateEmail__c
)
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RuckSack - requested change in address phone or email</fullName>
        <actions>
            <name>RuckSack_address_change_notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Alerts staff if there is a change in address info during a Give Request</description>
        <formula>or( and(Make_Address_Primary__c,  or( Address__c &lt;&gt; Applicant__r.MailingStreet,       City__c &lt;&gt; Applicant__r.MailingCity,       Zip_Code__c &lt;&gt; Applicant__r.MailingPostalCode   ) ), and(  Make_Email_Primary__c, Email_Address__c&lt;&gt; Applicant__r.Email, Email_Address__c&lt;&gt;Applicant__r.npe01__WorkEmail__c, Email_Address__c&lt;&gt;Applicant__r.npe01__HomeEmail__c, Email_Address__c&lt;&gt;Applicant__r.npe01__AlternateEmail__c),  and(  Make_Phone_Primary__c, Primary_Phone__c&lt;&gt;Applicant__r.Phone, Primary_Phone__c&lt;&gt;Applicant__r.npe01__WorkPhone__c , Primary_Phone__c&lt;&gt;Applicant__r.HomePhone, Primary_Phone__c&lt;&gt;Applicant__r.OtherPhone) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack - GiveRequest - send confirmation email %28combined%29</fullName>
        <actions>
            <name>Rucksack_send_combined_confirmation_email</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Combined confirmation of give request email (on vf template)</description>
        <formula>AND(
    OR(
       isNew(),
       isChanged(Stage__c)
    ),
    $User.Alias != &apos;guest&apos;,
    OR(
       isPickVal(Stage__c, &quot;Wait-list&quot;),
       isPickVal(Stage__c, &quot;Tentative confirmation&quot;),
       isPickVal(Stage__c, &quot;Final confirmation&quot;),
       isPickVal(Stage__c, &quot;Information sent&quot;),
       AND(
           isPickVal(Stage__c, &quot;Give requested&quot;),
           isPickVal(Give_Instance__r.Give__r.Type__c, &quot;Screened Give&quot;)
       )
    ),
    NOT(CONTAINS(Give_Instance__r.Give__r.Name, &apos;I March For&apos;)),
    NOT(CONTAINS(Give_Instance__r.Give__r.Name, &apos;Veterans Day Virtual March&apos;))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack - GiveRequest - send confirmation email %28combined%29 - myIAVA Site Guest User Only</fullName>
        <actions>
            <name>Rucksack_plain_text_email_confirmation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Plain text confirmation of give request email to be sent by the myIAVA Site Guest User who cannot use the combined visualforce template</description>
        <formula>AND(
    OR(
       isNew(),
       isChanged(Stage__c)
    ),
    $User.Alias = &apos;guest&apos;,
    OR(
       isPickVal(Stage__c, &quot;Wait-list&quot;),
       isPickVal(Stage__c, &quot;Tentative confirmation&quot;),
       isPickVal(Stage__c, &quot;Final confirmation&quot;),
       isPickVal(Stage__c, &quot;Information sent&quot;),
       AND(
           isPickVal(Stage__c, &quot;Give requested&quot;),
           isPickVal(Give_Instance__r.Give__r.Type__c, &quot;Screened Give&quot;)
           )
    ),
    NOT(CONTAINS(Give_Instance__r.Give__r.Name, &apos;I March For&apos;)),
    NOT(CONTAINS(Give_Instance__r.Give__r.Name, &apos;Veterans Day Virtual March&apos;))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack - GiveRequest notify staff of request for tagged contact</fullName>
        <actions>
            <name>Rucksack_new_request_for_notify_contact</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Rucksack_Status__c</field>
            <operation>equals</operation>
            <value>Notify Staff</value>
        </criteriaItems>
        <description>If request comes in for contact with Rucksack Status field set to notify staff, do so.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack - Reconfirm status changes to Re-confirm_Sent</fullName>
        <actions>
            <name>Rucksack_send_reconfirm_email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Increment_Re_confirm_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Rucksack_set_Date_First_Emailed_today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Rucksack_set_Date_Last_Emailed_today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the Re-Confirm Status changes to ‘Re-confirm Sent’ for the first time, send a Confirmation Request email to the member
Set Date Emailed to the current date
Increment Re-confirm Count</description>
        <formula>AND(ISNULL(Date_First_Emailed__c), AND(ISCHANGED(Re_confirm_Status__c),ISPICKVAL(Re_confirm_Status__c,&apos;Re-confirm Sent&apos;) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack - Reconfirm time dependent workflow</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Give_Instance__c.Reconfirm_date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Request__c.Stage__c</field>
            <operation>equals</operation>
            <value>Final confirmation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Give_Request__c.Re_confirm_Status__c</field>
            <operation>notEqual</operation>
            <value>Re-confirm sent,Re-confirmed</value>
        </criteriaItems>
        <description>When the record is saved and the Re-confirm Date on the Give is not null
Schedule a time dependant workflow for 8AM ET of the re-confirm date to change the Re-confirm Status to ‘Re-confirm Sent’</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Change_status_to_reconfirm_sent</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Give_Request__c.Give_Instance_Reconfirm_Date__c</offsetFromField>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Rucksack - SF Job Fair 2011</fullName>
        <actions>
            <name>SF_Fleet_Week_Job_Fair_Employment_Survey</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Give_Request__c.Give_Name__c</field>
            <operation>equals</operation>
            <value>First Annual Fleet Week Smart Job Fair</value>
        </criteriaItems>
        <description>To send an employment survey to members who sign up for the fleet week job fair.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack - Send_email_for_iphone_and_at_request</fullName>
        <actions>
            <name>Send_an_information_request_e_mail_when_the_conditions_are_met_iphone_app_and_fi</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>When the record is saved and there are fields that are to be collected ‘at request’ and the Platform = ‘iPhone app’
Send an Information Request email to the member</description>
        <formula>AND(  ISPICKVAL(Platform__c, &apos;iPhone app&apos;),  OR( ISPICKVAL(Give_Instance__r.Give__r.Collect_Guest_DL_Num__c, &apos;at request&apos;), ISPICKVAL(Give_Instance__r.Give__r.Collect_Guest_DOB__c, &apos;at request&apos;),  ISPICKVAL(Give_Instance__r.Give__r.Collect_Guest_Shirt_Size__c, &apos;at request&apos;),  ISPICKVAL(Give_Instance__r.Give__r.Collect_Member_DL_Num__c, &apos;at request&apos;),  ISPICKVAL(Give_Instance__r.Give__r.Collect_Member_DOB__c, &apos;at request&apos;),  ISPICKVAL(Give_Instance__r.Give__r.Collect_Member_Shirt_Size__c, &apos;at request&apos;),  ISPICKVAL(Give_Instance__r.Give__r.Collect_Special_Response_2__c, &apos;at request&apos;),  ISPICKVAL(Give_Instance__r.Give__r.Collect_Special_Response_3__c, &apos;at request&apos;),  ISPICKVAL(Give_Instance__r.Give__r.Collect_Special_Response_4__c, &apos;at request&apos;),  ISPICKVAL(Give_Instance__r.Give__r.Collect_Special_Response_5__c, &apos;at request&apos;)) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack - Subsequent Reconfirm status changes to Re-confirm_Sent</fullName>
        <actions>
            <name>Send_a_Confirmation_Request_email_to_the_member2</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Rucksack_Increment_Re_confirm_Count</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Rucksack_set_Date_Last_Emailed_today2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the Re-Confirm Status changes to ‘Re-confirm Sent’ AFTER the first time, send a Confirmation Request email to the member
Set Date Emailed to the current date
Increment Re-confirm Count</description>
        <formula>AND(NOT(ISNULL(Date_First_Emailed__c)), AND(ISCHANGED(Re_confirm_Status__c),ISPICKVAL(Re_confirm_Status__c,&apos;Re-confirm Sent&apos;) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack - VetsDayGiveRequest - send confirmation email %28combined%29</fullName>
        <actions>
            <name>Gives_Ea_VetsDayFinalConfirmationUnlimitedGiveTextConfirmationGuestUser</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Combined confirmation of give request email (on vf template) FOR VETS DAY PARADE ONLY TO PLACATE PAUL</description>
        <formula>(ISNEW() || ISCHANGED(Stage__c)) &amp;&amp; $User.Alias != &apos;guest&apos; &amp;&amp; (ISPICKVAL(Stage__c, &apos;Wait-list&apos;) || ISPICKVAL(Stage__c, &apos;Tentative confirmation&apos;) || ISPICKVAL(Stage__c, &apos;Final confirmation&apos;) || ISPICKVAL(Stage__c, &apos;Information sent&apos;) || (ISPICKVAL(Stage__c, &apos;Give requested&apos;) &amp;&amp; ISPICKVAL(Give_Instance__r.Give__r.Type__c, &apos;Screened Give&apos;))) &amp;&amp; CONTAINS(Give_Instance__r.Give__r.Name, &apos;I March For&apos;) &amp;&amp; CONTAINS(Give_Instance__r.Give__r.Name, &apos;Veterans Day Virtual March&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack - notify Give Internal POC if canceled request with waitlist</fullName>
        <actions>
            <name>Rucksack_notify_internal_POC_of_canceled_give_request</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>If a confirmed request is canceled, notify the Internal POC so they can move someone off the waitlist. - De-activated because the Email Alert on the Give Request can&apos;t be targeted at the related user from the Give.</description>
        <formula>and(
  ispickval(Stage__c, &quot;Cancelled&quot; ),
  or(
     ispickval(priorvalue(Stage__c), &quot;Final Confirmation&quot;),
     ispickval(priorvalue(Stage__c), &quot;Tentative Confirmation&quot;)
   ),
   Give_Instance__r.Number_of_Waitlist_Requests__c &gt; 0
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack_Ea_FinalConfirmationGiveRequest_TextConfirmationFormyIAVASiteGuestUser</fullName>
        <actions>
            <name>Rucksack_Ea_FinalConfirmationGiveRequest_TextConfirmationFormyIAVASiteGuestUser</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Plain text confirmation of final confirmation give request email to be sent by the myIAVA Site Guest User who cannot use the combined visualforce template</description>
        <formula>(isNew() || isChanged(Stage__c)) &amp;&amp; $User.Alias = &apos;guest&apos; &amp;&amp; isPickVal(Stage__c, &apos;Final confirmation&apos;) &amp;&amp; NOT(isPickVal(Give_Instance__r.Give__r.Type__c, &apos;Unlimited Give&apos;)) &amp;&amp; NOT(isPickVal(Give_Instance__r.Give__r.Type__c, &apos;Information&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack_Ea_GiveRequestedGiveRequest_TextConfirmationFormyIAVASiteGuestUser</fullName>
        <actions>
            <name>Rucksack_Ea_GiveRequestedGiveRequest_TextConfirmationFormyIAVASiteGuestUser</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Plain text confirmation of give requested give request email to be sent by the myIAVA Site Guest User who cannot use the combined visualforce template</description>
        <formula>(isNew() || isChanged(Stage__c)) &amp;&amp; $User.Alias = &apos;guest&apos; &amp;&amp; isPickVal(Stage__c, &apos;Give requested&apos;) &amp;&amp; isPickVal(Give_Instance__r.Give__r.Type__c, &apos;Screened Give&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack_Ea_InformationGiveRequest_TextConfirmationFormyIAVASiteGuestUser</fullName>
        <actions>
            <name>Rucksack_Ea_InformationGiveRequest_TextConfirmationFormyIAVASiteGuestUser</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Plain text confirmation of information give request email to be sent by the myIAVA Site Guest User who cannot use the combined visualforce template</description>
        <formula>(isNew() || isChanged(Stage__c)) &amp;&amp; $User.Alias = &apos;guest&apos; &amp;&amp; isPickVal(Stage__c, &apos;Information sent&apos;) &amp;&amp; isPickVal(Give_Instance__r.Give__r.Type__c, &apos;Information&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack_Ea_TentativeConfirmationGiveRequest_TextConfirmationFormyIAVASiteGuestUser</fullName>
        <actions>
            <name>Rucksack_Ea_TentativeConfirmationGiveRequest_TextConfirmationFormyIAVASiteGuestU</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Plain text confirmation of tentative confirmation give request email to be sent by the myIAVA Site Guest User who cannot use the combined visualforce template</description>
        <formula>(isNew() || isChanged(Stage__c)) &amp;&amp; $User.Alias = &apos;guest&apos; &amp;&amp; isPickVal(Stage__c, &apos;Tentative confirmation&apos;) &amp;&amp; NOT(isPickVal(Give_Instance__r.Give__r.Type__c, &apos;Unlimited Give&apos;)) &amp;&amp; NOT(isPickVal(Give_Instance__r.Give__r.Type__c, &apos;Information&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack_Ea_UnlimitedGiveRequest_TextConfirmationFormyIAVASiteGuestUser</fullName>
        <actions>
            <name>Rucksack_Ea_UnlimitedGiveRequest_TextConfirmationFormyIAVASiteGuestUser</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Plain text confirmation of unlimited give request email to be sent by the myIAVA Site Guest User who cannot use the combined visualforce template</description>
        <formula>(isNew() || isChanged(Stage__c)) &amp;&amp; $User.Alias = &apos;guest&apos; &amp;&amp; isPickVal(Stage__c, &apos;Final confirmation&apos;) &amp;&amp; isPickVal(Give_Instance__r.Give__r.Type__c, &apos;Unlimited Give&apos;) &amp;&amp; NOT(CONTAINS(Give_Instance__r.Give__r.Name, &apos;I March For&apos;)) &amp;&amp; NOT(CONTAINS(Give_Instance__r.Give__r.Name, &apos;Veterans Day Virtual March&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack_Ea_WaitlistGiveRequest_TextConfirmationFormyIAVASiteGuestUser</fullName>
        <actions>
            <name>Rucksack_Ea_WaitlistGiveRequest_TextConfirmationFormyIAVASiteGuestUser</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Plain text confirmation of waitlist give request email to be sent by the myIAVA Site Guest User who cannot use the combined visualforce template</description>
        <formula>(isNew() || isChanged(Stage__c)) &amp;&amp; $User.Alias = &apos;guest&apos; &amp;&amp; isPickVal(Stage__c, &apos;Wait-list&apos;) &amp;&amp; NOT(isPickVal(Give_Instance__r.Give__r.Type__c, &apos;Unlimited Give&apos;)) &amp;&amp; NOT(isPickVal(Give_Instance__r.Give__r.Type__c, &apos;Information&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Rucksack_Fu_PullGiveFulfillmentRTF</fullName>
        <actions>
            <name>GiveRequest_GiveFulfillmentInstructions</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Pull Fulfillment Instructions rtf from the Give to the Give Request on Give Request create.</description>
        <formula>LEN(Give_Instance__r.Give__r.Fulfillment_Instructions_rtf__c) &gt; 0</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
