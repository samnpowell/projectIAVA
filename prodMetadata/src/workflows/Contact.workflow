<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approved_Email</fullName>
        <ccEmails>workflow@iava.org</ccEmails>
        <description>Approved Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Membership_Templates/Member_Veteran_Invitation</template>
    </alerts>
    <alerts>
        <fullName>JoinFlow_Ea_Welcome_AllPost911Veterans</fullName>
        <description>JoinFlow_Ea_Welcome_AllPost911Veterans</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>mail@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Apgar_Test_E_mails/WelcomeEmail_AllPost911Veterans</template>
    </alerts>
    <alerts>
        <fullName>JoinFlow_Ea_Welcome_AllVeteransFamilyMembersAndSupporters</fullName>
        <description>JoinFlow_Ea_Welcome_AllVeteransFamilyMembersAndSupporters</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>mail@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Laura_s_Updated_Paperwork_Templates/UPDATEDWelcomeVetsFamilySupportersSurvey</template>
    </alerts>
    <alerts>
        <fullName>JoinFlow_Ea_Welcome_Pre911</fullName>
        <description>JoinFlow_Ea_Welcome_Pre911</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>mail@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Apgar_Test_E_mails/WelcomeEmail_NewPre911</template>
    </alerts>
    <alerts>
        <fullName>JoinFlow_Ea_Welcome_Supporter</fullName>
        <description>JoinFlow_Ea_Welcome_Supporter</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Apgar_Test_E_mails/WelcomeEmail_NewSupporter</template>
    </alerts>
    <alerts>
        <fullName>JoinFlow_Ea_Welcome_VeteranFamilyMember</fullName>
        <description>JoinFlow_Ea_Welcome_VeteranFamilyMember</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Apgar_Test_E_mails/WelcomeEmail_NewVeteranFamilyMember</template>
    </alerts>
    <alerts>
        <fullName>JoinFlow_Email_Welcome_LazyMember</fullName>
        <description>JoinFlow_Email_Welcome_LazyMember</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>prieckhoff@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Laura_s_Updated_Paperwork_Templates/UPDATED_WelcomeEmail_LazyMember</template>
    </alerts>
    <alerts>
        <fullName>Lifetime_1K_Notifier</fullName>
        <description>Lifetime 1K+ Notifier</description>
        <protected>false</protected>
        <recipients>
            <recipient>jeremy@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Development_Templates/Lifetime_1k_Notifier</template>
    </alerts>
    <alerts>
        <fullName>NVLSP_Not_Qualified</fullName>
        <description>NVLSP Not Qualified Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAVA_Email_Templates/NVSLP_CRSC_Not_Qualified_Vet</template>
    </alerts>
    <alerts>
        <fullName>NVLSP_Qualified_and_Consented_Vet_info_to_be_sent_to_NVLSP</fullName>
        <ccEmails>LawyersServing@nvlsp.org</ccEmails>
        <description>NVLSP Qualified and Consented Vet info to be sent to NVLSP</description>
        <protected>false</protected>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAVA_Email_Templates/NVSLP_CRSC_to_NVLSP</template>
    </alerts>
    <alerts>
        <fullName>NVSLP_Email_to_Qualified_vet_with_consent_givenq</fullName>
        <description>NVSLP Email to Qualified vet with consent givenq</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>IAVA_Email_Templates/NVSLP_CRSC_Qualified_Vet</template>
    </alerts>
    <alerts>
        <fullName>Paperwork_Approved_Post_9_11_Veteran</fullName>
        <description>Paperwork Approved – Post 9/11 Veteran</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Laura_s_Updated_Paperwork_Templates/UPDATED_Paperwork_Approved_Post_9_11_Veteran</template>
    </alerts>
    <alerts>
        <fullName>Paperwork_Approved_Veteran_of_Other_Era</fullName>
        <description>Paperwork Approved – Veteran of Other Era</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Laura_s_Updated_Paperwork_Templates/UPDATED_Paperwork_Approved_Veteran_of_Other_Era</template>
    </alerts>
    <alerts>
        <fullName>Paperwork_Final_Reminder</fullName>
        <description>Paperwork FINAL Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Paperwork_Approval/Paperwork_Request_Final</template>
    </alerts>
    <alerts>
        <fullName>Paperwork_Invitation_Email</fullName>
        <description>Paperwork Accepted Invitation Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Laura_s_Updated_Paperwork_Templates/UPDATED_Welcome_to_New_COV_OIF_OEF_OND_Veteran_with_Invite_your_peers_link</template>
    </alerts>
    <alerts>
        <fullName>Paperwork_Question_Issue_Email_Trigger</fullName>
        <description>Paperwork Question/Issue Email Trigger</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Laura_s_Updated_Paperwork_Templates/UPDATED_Paperwork_Issue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Paperwork_Reminder</fullName>
        <description>Paperwork Reminder</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Paperwork_Approval/Paperwork_Request</template>
    </alerts>
    <alerts>
        <fullName>Paperwork_Resubmitted_Email</fullName>
        <description>Paperwork Resubmitted Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Laura_s_Updated_Paperwork_Templates/UPDATED_Paperwork_Resubmitted_for_Confirmed_Member</template>
    </alerts>
    <alerts>
        <fullName>Paperwork_received_email</fullName>
        <description>Paperwork received email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Laura_s_Updated_Paperwork_Templates/UPDATED_Paperwork_Received</template>
    </alerts>
    <alerts>
        <fullName>Paperwork_request</fullName>
        <description>Paperwork request</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Paperwork_Approval/Paperwork_Request</template>
    </alerts>
    <alerts>
        <fullName>Peer_Welcome_Peer_Validated_Member</fullName>
        <description>Peer - Welcome Peer Validated Member</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Membership_Templates/Peer_Welcome_Peer_Validated_Member_HTML</template>
    </alerts>
    <alerts>
        <fullName>RRRP_Services_Information_sent_to_Civilians</fullName>
        <description>RRRP Services Information sent to Civilians</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>transition@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Laura_s_Updated_Paperwork_Templates/UPDATED_RRRP_Services_Information_sent_to_Civilians</template>
    </alerts>
    <alerts>
        <fullName>RRRP_Services_for_Vet_or_Family_Member</fullName>
        <description>RRRP Services for Vet or Family Member</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>transition@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Laura_s_Updated_Paperwork_Templates/UPDATED_RRRP_Services_for_Vet_or_Family_Member</template>
    </alerts>
    <alerts>
        <fullName>STHSuperbowlThankYouEmail</fullName>
        <description>STHSuperbowlThankYouEmail</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>community@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Membership_Templates/STHSuperbowl</template>
    </alerts>
    <alerts>
        <fullName>Send_Contact_and_email_to_admin</fullName>
        <description>Send Contact &apos;and&apos; email to admin</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sysadmins</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>System_Templates/Contact_has_and_in_the_Name</template>
    </alerts>
    <alerts>
        <fullName>Send_Follow_Up_Email_to_Prospective_Veteran_Member_Question_Issue</fullName>
        <description>Send Follow Up Email to Prospective Veteran Member Question/Issue</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Paperwork_Approval/Paperwork_Issue_Notification</template>
    </alerts>
    <alerts>
        <fullName>Welcome_to_New_COV_OIF_OEF_OND_Veteran_with_Invite_your_peers_link</fullName>
        <description>Welcome to New COV – OIF/OEF/OND Veteran with Invite your peers link</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>membership@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Laura_s_Updated_Paperwork_Templates/UPDATED_Welcome_to_New_COV_OIF_OEF_OND_Veteran_with_Invite_your_peers_link</template>
    </alerts>
    <fieldUpdates>
        <fullName>Check_Veteran_Member</fullName>
        <field>Veteran_Member__c</field>
        <literalValue>1</literalValue>
        <name>Check Veteran Member</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Confidential_Info_Box_Uncheck</fullName>
        <field>Has_Private_Contact_Info__c</field>
        <literalValue>0</literalValue>
        <name>Confidential Info Box Uncheck</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_CreatePortalUser_True</fullName>
        <description>Set Create Portal User checkbox to true</description>
        <field>Create_Portal_User__c</field>
        <literalValue>1</literalValue>
        <name>Contact_CreatePortalUser_True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Post911VeteranSetter_False</fullName>
        <field>Post_9_11_Veteran_Setter__c</field>
        <literalValue>0</literalValue>
        <name>Contact_Post911VeteranSetter_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Post911Veteran_True_REEVAL</fullName>
        <description>Check the Veteran Member checkbox then re-evaluate workflow rules</description>
        <field>Post_9_11_Veteran__c</field>
        <literalValue>1</literalValue>
        <name>Contact_Post911Veteran_True_REEVAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_PreferredEmail_sd</fullName>
        <description>Same as nonprofit starter pack version but doesn&apos;t set Email to a preferred field that is blank if other email fields aren&apos;t blank.</description>
        <field>Email</field>
        <formula>CASE(
npe01__Preferred_Email__c ,

&quot;Work&quot;,
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c,
 if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c,
   npe01__AlternateEmail__c)),

&quot;Personal&quot;,
if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c,
 if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c,
   npe01__AlternateEmail__c)),

&quot;Home&quot;,
if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c,
 if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c,
   npe01__AlternateEmail__c)),

&quot;Alternate&quot;,
if(len(npe01__AlternateEmail__c)&gt;0, npe01__AlternateEmail__c,
 if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c,
   npe01__HomeEmail__c)),

If(LEN(npe01__WorkEmail__c)&gt;0 , npe01__WorkEmail__c ,
if(LEN( npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c,
npe01__AlternateEmail__c
)))</formula>
        <name>Contact.PreferredEmail.sd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_SourceDetails_JoinFlow</fullName>
        <field>Source_Details__c</field>
        <formula>&quot;Join Flow&quot;</formula>
        <name>Contact_SourceDetails_JoinFlow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Source_Iava_org</fullName>
        <field>Source__c</field>
        <literalValue>iava.org</literalValue>
        <name>Contact_Source_Iava.org</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_VADisabilityRating_NULL</fullName>
        <description>Sets the VA Disability Rating field value to null</description>
        <field>VA_Disability_Rating__c</field>
        <name>Contact_VADisabilityRating_NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_WelcomeEmailSent_Today</fullName>
        <field>Welcome_Email_Sent__c</field>
        <formula>TODAY()</formula>
        <name>Contact_WelcomeEmailSent_Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_SourceDetailsRelay_to_SourceDetails</fullName>
        <field>Source_Details__c</field>
        <formula>Source_Details_relay__c</formula>
        <name>Copy SourceDetailsRelay to SourceDetails</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deceased_Text_Opt_Out</fullName>
        <description>Checks on text opt out field</description>
        <field>Text_Opt_Out__c</field>
        <literalValue>1</literalValue>
        <name>Deceased - Text Opt Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deceased_Update_Should_Not_Receive</fullName>
        <field>No_Email_Blasts__c</field>
        <literalValue>1</literalValue>
        <name>Deceased - Update Should Not Receive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deceased_Update_opt_out</fullName>
        <field>HasOptedOutOfEmail</field>
        <literalValue>1</literalValue>
        <name>Deceased - Update Email opt out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Direct_Mail_Opt_Out</fullName>
        <description>check on direct mail opt out</description>
        <field>Direct_Mail_OptOut__c</field>
        <literalValue>1</literalValue>
        <name>Direct Mail Opt Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Donor_Checkbox_Update</fullName>
        <field>Donor__c</field>
        <literalValue>1</literalValue>
        <name>Donor Checkbox Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Field_Update_to_Question_Issue</fullName>
        <field>Paperwork_Confirmation__c</field>
        <literalValue>Paperwork Question/Issue</literalValue>
        <name>Field Update to Question/Issue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MALatitudec_Purge</fullName>
        <description>Purge the MA_Latitude__c field on the Contact if selected address fields change; created by the Metadata API</description>
        <field>MA_Latitude__c</field>
        <name>MA MA_Latitude__c Purge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MALongitudec_Purge</fullName>
        <description>Purge the MA_Longitude__c field on the Contact if selected address fields change; created by the Metadata API</description>
        <field>MA_Longitude__c</field>
        <name>MA MA_Longitude__c Purge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NVLSP_Update</fullName>
        <field>Qualified_for_NVLSP__c</field>
        <literalValue>1</literalValue>
        <name>NVLSP Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OEF_Veteran_False</fullName>
        <description>Sets OEF to false.</description>
        <field>Veteran_of_OEF__c</field>
        <literalValue>0</literalValue>
        <name>OEF Veteran False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OIF_Veteran_False</fullName>
        <description>Sets Veteran of OIF to false.</description>
        <field>Veteran_of_OIF__c</field>
        <literalValue>0</literalValue>
        <name>OIF Veteran False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OND_Veteran_False</fullName>
        <description>Set Veteran of OND to False</description>
        <field>Veteran_of_OND__c</field>
        <literalValue>0</literalValue>
        <name>OND Veteran False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Paperwork_Approval_Date_Today</fullName>
        <field>Approved_Date__c</field>
        <formula>Today()</formula>
        <name>Paperwork Approval Date Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Paperwork_Confirmation_Accepted</fullName>
        <field>Paperwork_Confirmation__c</field>
        <literalValue>Paperwork Accepted</literalValue>
        <name>Paperwork Confirmation Accepted - DUPE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Paperwork_Docs_Date_Today</fullName>
        <description>Set the Paperwork Documents Date to Today</description>
        <field>Documents_Date__c</field>
        <formula>Today()</formula>
        <name>Paperwork Docs Date Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Paperwork_Status_Accepted</fullName>
        <description>Set Paperwork Status Field to Paperwork Accepted</description>
        <field>Paperwork_Confirmation__c</field>
        <literalValue>Paperwork Accepted</literalValue>
        <name>Paperwork Status Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Paperwork_Status_Requested</fullName>
        <description>Updates the Paperwork Confirmation picklist to Paperwork Requested</description>
        <field>Paperwork_Confirmation__c</field>
        <literalValue>Paperwork Requested</literalValue>
        <name>Paperwork Status Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Referral_Confidential_Contact_Should_N</fullName>
        <description>Referral Confidential Contact - Should Not Receive Emails</description>
        <field>No_Email_Blasts__c</field>
        <literalValue>1</literalValue>
        <name>Referral Confidential Contact - Should N</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_COV_Date</fullName>
        <field>COV_Date__c</field>
        <formula>Today()</formula>
        <name>Set COV Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contact_Title_to_KW_Title</fullName>
        <field>Title</field>
        <formula>kw__Title__c</formula>
        <name>Set Contact Title to KW Title</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Create_Portal_User_checkbox</fullName>
        <field>Create_Portal_User__c</field>
        <literalValue>1</literalValue>
        <name>Set Create Portal User checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Did_Not_Deploy_to_False</fullName>
        <description>Un-check Did Not Deploy checkbox</description>
        <field>Did_Not_Deploy__c</field>
        <literalValue>0</literalValue>
        <name>Set Did Not Deploy to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Direct_Mail_Opt_Out</fullName>
        <field>Direct_Mail_OptOut__c</field>
        <literalValue>1</literalValue>
        <name>Set Direct Mail Opt-Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Family_Member_Setter_to_False</fullName>
        <field>Family_Member_Setter__c</field>
        <literalValue>0</literalValue>
        <name>Set_Family_Member_Setter_to_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Not_Veteran_Setter_to_False</fullName>
        <field>Not_Veteran_Setter__c</field>
        <literalValue>0</literalValue>
        <name>Set_Not_Veteran_Setter_to_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Not_a_Veteran_to_True_REEVAL</fullName>
        <description>Check the Not a Veteran checkbox then re-evaluate workflow rules</description>
        <field>Not_a_Veteran__c</field>
        <literalValue>1</literalValue>
        <name>Set_Not_a_Veteran_to_True_REEVAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_OEF_Setter_to_False</fullName>
        <field>OEF_Setter__c</field>
        <literalValue>0</literalValue>
        <name>Set_OEF_Setter_to_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_OIF_Setter_to_False</fullName>
        <field>OIF_Setter__c</field>
        <literalValue>0</literalValue>
        <name>Set_OIF_Setter_to_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_OND_Setter_to_False</fullName>
        <field>OND_Setter__c</field>
        <literalValue>0</literalValue>
        <name>Set_OND_Setter_to_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Other_Era_Setter_to_False</fullName>
        <field>Other_Era_Setter__c</field>
        <literalValue>0</literalValue>
        <name>Set_Other_Era_Setter_to_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Peer_Validated_Checkbox</fullName>
        <field>Peer_Validated__c</field>
        <literalValue>1</literalValue>
        <name>Set Peer Validated Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Veteran_Family_Member_to_True_REEVAL</fullName>
        <description>Check the Veteran Family Member checkbox then re-evaluate workflow rules</description>
        <field>Veteran_Family_Member__c</field>
        <literalValue>1</literalValue>
        <name>Set_Veteran_Family_Member_to_True_REEVAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Veteran_Member_Setter_to_False</fullName>
        <field>Veteran_Member_Setter__c</field>
        <literalValue>0</literalValue>
        <name>Set_Veteran_Member_Setter_to_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Veteran_Member_to_True_REEVAL</fullName>
        <description>Check the Veteran Member checkbox then re-evaluate workflow rules</description>
        <field>Veteran_Member__c</field>
        <literalValue>1</literalValue>
        <name>Set_Veteran_Member_to_True_REEVAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Veteran_Other_Era_to_True_REEVAL</fullName>
        <description>Check the Veteran of Other Era checkbox then re-evaluate workflow rules</description>
        <field>Veteran_of_Other_Era__c</field>
        <literalValue>1</literalValue>
        <name>Set_Veteran_Other_Era_to_True_REEVAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Veteran_of_OEF_to_True_REEVAL</fullName>
        <description>Check the Veteran of OEF checkbox then re-evaluate workflow rules</description>
        <field>Veteran_of_OEF__c</field>
        <literalValue>1</literalValue>
        <name>Set_Veteran_of_OEF_to_True_REEVAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Veteran_of_OIF_to_True_REEVAL</fullName>
        <description>Check the Veteran of OIF checkbox then re-evaluate workflow rules</description>
        <field>Veteran_of_OIF__c</field>
        <literalValue>1</literalValue>
        <name>Set_Veteran_of_OIF_to_True_REEVAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Veteran_of_OND_to_True_REEVAL</fullName>
        <description>Check the Veteran of OND checkbox then re-evaluate workflow rules</description>
        <field>Veteran_of_OND__c</field>
        <literalValue>1</literalValue>
        <name>Set_Veteran_of_OND_to_True_REEVAL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Signup_Date_Today_IF_BLANK</fullName>
        <description>Sets the Signup Date to Today unless it is already populated.</description>
        <field>Signup_Date__c</field>
        <formula>IF(ISBLANK( Signup_Date__c ), Today(),  Signup_Date__c )</formula>
        <name>Signup Date Today IF BLANK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_VetMember</fullName>
        <description>Sets Veteran Member to False.</description>
        <field>Veteran_Member__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck VetMember</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Confidential_Info_Box</fullName>
        <field>Has_Private_Contact_Info__c</field>
        <literalValue>1</literalValue>
        <name>Update Confidential Info Box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Donor_Status</fullName>
        <description>Checks the &quot;Donor&quot; checkbox on the Contact object if their Yearly Max is greater than 0.</description>
        <field>Donor__c</field>
        <literalValue>1</literalValue>
        <name>Update Donor Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_to_Membership</fullName>
        <field>OwnerId</field>
        <lookupValue>backgroundadmin@iava.org</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Owner to Membership</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Veteran_Member_check</fullName>
        <description>Checks the Veteran Member field</description>
        <field>Veteran_Member__c</field>
        <literalValue>1</literalValue>
        <name>Veteran Member check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Veteran_of_OEF_Field_Checked</fullName>
        <field>Veteran_of_OEF__c</field>
        <literalValue>1</literalValue>
        <name>Veteran of OEF Field Checked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Veteran_of_OIF_Field_Checked</fullName>
        <field>Veteran_of_OIF__c</field>
        <literalValue>1</literalValue>
        <name>Veteran of OIF Field Checked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Member_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Member_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Member Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Member_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Member_Record</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Member RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Office_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Officer_Record</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Office RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Officer_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Officer_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Officer Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Staffer_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Staffer_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Staffer Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Staffer_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Staffer_Record</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Staffer RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactAlternateEmailUpdate</fullName>
        <field>npe01__AlternateEmail__c</field>
        <formula>Email</formula>
        <name>Contact.AlternateEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactHomePhoneUpdate</fullName>
        <field>HomePhone</field>
        <formula>Phone</formula>
        <name>Contact.HomePhone.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactMobilePhoneUpdate</fullName>
        <field>MobilePhone</field>
        <formula>Phone</formula>
        <name>Contact.MobilePhone.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactOtherEmailUpdate</fullName>
        <field>OtherPhone</field>
        <formula>Phone</formula>
        <name>Contact.OtherEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactPersonalEmailUpdate</fullName>
        <field>npe01__HomeEmail__c</field>
        <formula>Email</formula>
        <name>Contact.PersonalEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactPreferredEmail</fullName>
        <field>Email</field>
        <formula>CASE( 
npe01__Preferred_Email__c , 

&quot;Work&quot;, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
npe01__AlternateEmail__c)), 

&quot;Personal&quot;, 
if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
npe01__AlternateEmail__c)), 

&quot;Home&quot;, 
if(len(npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
npe01__AlternateEmail__c)), 

&quot;Alternate&quot;, 
if(len(npe01__AlternateEmail__c)&gt;0, npe01__AlternateEmail__c, 
if(len(npe01__WorkEmail__c)&gt;0, npe01__WorkEmail__c, 
npe01__HomeEmail__c)), 

If(LEN(npe01__WorkEmail__c)&gt;0 , npe01__WorkEmail__c , 
if(LEN( npe01__HomeEmail__c)&gt;0, npe01__HomeEmail__c, 
npe01__AlternateEmail__c 
)))</formula>
        <name>Contact.PreferredEmail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactPreferredPhone</fullName>
        <description>Populates the standard Phone field displayed on activities based on the Preferred Phone field value.</description>
        <field>Phone</field>
        <formula>CASE(
  npe01__PreferredPhone__c ,
&quot;Work&quot;,
  npe01__WorkPhone__c  ,
&quot;Home&quot;,
 HomePhone,
&quot;Mobile&quot;,
 MobilePhone,
&quot;Other&quot;,
 OtherPhone,
If(LEN( npe01__WorkPhone__c )&gt;0 , npe01__WorkPhone__c  ,
if(LEN(  HomePhone)&gt;0,  HomePhone,
if(LEN( MobilePhone)&gt;0, MobilePhone,
OtherPhone
))))</formula>
        <name>Contact.PreferredPhone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactWorkEmailUpdate</fullName>
        <field>npe01__WorkEmail__c</field>
        <formula>Email</formula>
        <name>Contact.WorkEmail.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__ContactWorkPhoneUpdate</fullName>
        <field>npe01__WorkPhone__c</field>
        <formula>Phone</formula>
        <name>Contact.WorkPhone.Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__PreferredPhonetoWork</fullName>
        <field>npe01__PreferredPhone__c</field>
        <literalValue>Work</literalValue>
        <name>Preferred Phone to Work</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__SetPrefEmailtoWork</fullName>
        <field>npe01__Preferred_Email__c</field>
        <literalValue>Work</literalValue>
        <name>Set Pref Email to Work</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__SetWorkEmailtoEmail</fullName>
        <field>npe01__WorkEmail__c</field>
        <formula>Email</formula>
        <name>Set Work Email to Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npe01__WorkPhonetoPhone</fullName>
        <field>npe01__WorkPhone__c</field>
        <formula>Phone</formula>
        <name>Work Phone to Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npo02__ContactPreferredPhone_WithHousehold</fullName>
        <description>FOR USE WITH HOUSEHOLDS. Populates the standard Phone field displayed on activities based on the Preferred Phone field value.</description>
        <field>Phone</field>
        <formula>CASE( 
npe01__PreferredPhone__c , 
&quot;Work&quot;, 
npe01__WorkPhone__c , 
&quot;Household&quot;,
 npo02__Formula_HouseholdPhone__c ,
&quot;Home&quot;, 
HomePhone, 
&quot;Personal&quot;,
HomePhone,
&quot;Mobile&quot;, 
MobilePhone, 
&quot;Other&quot;, 
OtherPhone, 
If(LEN( npe01__WorkPhone__c )&gt;0 , npe01__WorkPhone__c , 
if(LEN( HomePhone)&gt;0, HomePhone, 
if(LEN( MobilePhone)&gt;0, MobilePhone, 
OtherPhone 
))))</formula>
        <name>Contact.PreferredPhone_WithHousehold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Check VetMember Box</fullName>
        <actions>
            <name>Check_Veteran_Member</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Contact.Veteran_of_OEF__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_OIF__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_OND__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When OEF, OIF, or OND is checked, make sure Veteran Member box is checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check Veteran of OEF Checkbox</fullName>
        <actions>
            <name>Veteran_of_OEF_Field_Checked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.OEF_Deployment__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>KW - Member Record,KW - Staffer Record,KW - Member Former,KW - Staffer Former,KW - Officer Record,KW - Officer Former</value>
        </criteriaItems>
        <description>Whenever a Detailed Deployment record is saved that is an OEF mission related to a contact, the Veteran of OEF checkbox will automatically be checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check Veteran of OIF Checkbox</fullName>
        <actions>
            <name>Veteran_of_OIF_Field_Checked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.OIF_Deployment__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>KW - Member Record,KW - Staffer Record,KW - Member Former,KW - Staffer Former,KW - Officer Record,KW - Officer Former</value>
        </criteriaItems>
        <description>Whenever a Detailed Deployment record is saved that is an OIF mission related to a contact, the Veteran of OIF checkbox will automatically be checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Confidential Info Box Check</fullName>
        <actions>
            <name>Update_Confidential_Info_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Contact.Confidential_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Confidential_Phone__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Confidential_Street_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When there is anything in any confidential contact information field, the checkbox &quot;Has Private Contact Info&quot; will be checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Confidential Info Box Uncheck</fullName>
        <actions>
            <name>Confidential_Info_Box_Uncheck</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Confidential_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Confidential_Phone__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Confidential_Street_Address__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When all confidential contact information fields are blank, the checkbox &quot;Has Private Contact Info&quot; will be unchecked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Contact - Change DIA Integration Contacts  Owner to Membership</fullName>
        <actions>
            <name>Update_Owner_to_Membership</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Contact.CreatedById</field>
            <operation>equals</operation>
            <value>Mike Dannenfeldt</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.CreatedById</field>
            <operation>equals</operation>
            <value>Integration Site Guest User</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>KW - Member Record,KW - Staffer Record,KW - Member Former,KW - Staffer Former,KW - Officer Record,KW - Officer Former</value>
        </criteriaItems>
        <description>Change the Owner of the contact to someone from Membership when the record is created by the DIA Integration</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contact%2EPreferred_Email_sd%5F%5Fc</fullName>
        <actions>
            <name>Contact_PreferredEmail_sd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow OVERWRITES the existing value in the standard Email field based on the Preferred Email field value.  This rule needs to be turned on manually after an Upgrade to this package.</description>
        <formula>OR( LEN(Email)=0, ISCHANGED(npe01__Preferred_Email__c) , ISCHANGED(npe01__WorkEmail__c) , ISCHANGED(npe01__HomeEmail__c) , ISCHANGED(npe01__AlternateEmail__c)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact_MailingCity_Field_Changed</fullName>
        <actions>
            <name>MALatitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MALongitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the Contact if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(MailingCity)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact_MailingCountry_Field_Changed</fullName>
        <actions>
            <name>MALatitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MALongitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the Contact if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(MailingCountry)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact_MailingPostalCode_Field_Changed</fullName>
        <actions>
            <name>MALatitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MALongitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the Contact if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(MailingPostalCode)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact_MailingState_Field_Changed</fullName>
        <actions>
            <name>MALatitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MALongitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the Contact if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(MailingState)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact_MailingStreet_Field_Changed</fullName>
        <actions>
            <name>MALatitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MALongitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the Contact if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(MailingStreet)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deceased - Update opt outs</fullName>
        <actions>
            <name>Deceased_Text_Opt_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Deceased_Update_Should_Not_Receive</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Deceased_Update_opt_out</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Direct_Mail_Opt_Out</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates Opt Out and Should Not Recieve Email Blasts for contacts marked deceased.</description>
        <formula>npsp__Deceased__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deployment - uncheck Did Not Deploy if deployment record added</fullName>
        <actions>
            <name>Set_Did_Not_Deploy_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Num_Deployment_Records__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Did_Not_Deploy__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>If a Detailed Deployment Record is added for OEF/OIF/OND, un-check the Contact&apos;s Did Not Deploy field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Development - Lifetime %241K%2B</fullName>
        <actions>
            <name>Lifetime_1K_Notifier</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.npe01__Lifetime_Giving_History_Amount__c</field>
            <operation>greaterOrEqual</operation>
            <value>1000</value>
        </criteriaItems>
        <description>Notifies Miranda by email when any donor&apos;s lifetime donation total meets $1,000.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Development - Update Donor Checkbox</fullName>
        <actions>
            <name>Update_Donor_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the Donor__c checkbox once a contact has given money.</description>
        <formula>npe01__Lifetime_Giving_History_Amount__c   &gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EventHost_Ea_Welcome_LazyEventHost</fullName>
        <actions>
            <name>JoinFlow_Email_Welcome_LazyMember</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9</booleanFilter>
        <criteriaItems>
            <field>Contact.Source__c</field>
            <operation>equals</operation>
            <value>Event</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.No_Email_Blasts__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Not_a_Veteran__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Family_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_Other_Era__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Post_9_11_Veteran__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Welcome_Email_Sent__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Send a welcome email to any lazy member who comes in through an event. Must not self-identify as a veteran, veteran family member, or supporter.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FamilyMemberSetter</fullName>
        <actions>
            <name>Set_Family_Member_Setter_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Veteran_Family_Member_to_True_REEVAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Family_Member_Setter__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Family_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When the Family Member Setter field is checked by FormAssembly, update the Veteran Family Member field on the Contact. This will prevent FormAssembly from overwriting the value in the Veteran Family Member checkbox during step 3 of the join form.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JoinFlow_EaFu_WelcomeAndPortalUser_AllPost911Veterans</fullName>
        <actions>
            <name>JoinFlow_Ea_Welcome_AllPost911Veterans</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Contact_CreatePortalUser_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4) AND 5 AND (6 OR (7 AND 8)) AND 9</booleanFilter>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Member_Status__c</field>
            <operation>notEqual</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Not Requested Yet,Paperwork Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Peer_Confirmation_Acceptance_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Vouch_tally_rollup__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Vouch_tally_rollup__c</field>
            <operation>lessThan</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.No_Email_Blasts__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Sends a welcome email and creates a new portal user for any Post 9/11 veteran that signs up using the Join Flow.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JoinFlow_EaFu_WelcomeAndPortalUser_AllVeteransFamilyMembersAndSupporters</fullName>
        <actions>
            <name>JoinFlow_Ea_Welcome_AllVeteransFamilyMembersAndSupporters</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Contact_CreatePortalUser_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_WelcomeEmailSent_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4 AND (5 OR 6 OR ((7 OR 8 OR 9) AND 10)) AND 11 AND 12</booleanFilter>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Source__c</field>
            <operation>equals</operation>
            <value>iava.org</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Source__c</field>
            <operation>equals</operation>
            <value>Event</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.No_Email_Blasts__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Not_a_Veteran__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Family_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_Other_Era__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Post_9_11_Veteran__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Member_Status__c</field>
            <operation>notEqual</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Welcome_Email_Sent__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Source_Details__c</field>
            <operation>notEqual</operation>
            <value>RRRP Web Intake Form</value>
        </criteriaItems>
        <description>Send a welcome email to and create a portal user for any post 9/11 veteran (OEF, OIF, OND, or non-combat), pre 9/11 veteran, veteran family member, or supporter who comes in through the join form or an event. Must self-identify as one of the above.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JoinFlow_EaFu_WelcomeAndPortalUser_Pre911</fullName>
        <actions>
            <name>JoinFlow_Ea_Welcome_Pre911</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Contact_CreatePortalUser_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4) AND 5 AND (6 OR (7 AND 8)) AND 9</booleanFilter>
        <criteriaItems>
            <field>Contact.Veteran_of_Other_Era__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Member_Status__c</field>
            <operation>notEqual</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Not Requested Yet,Paperwork Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Peer_Confirmation_Acceptance_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Vouch_tally_rollup__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Vouch_tally_rollup__c</field>
            <operation>lessThan</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.No_Email_Blasts__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When someone checks Pre-9/11 on the join form, we would like to send them a welcome email and create a new portal user for them.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JoinFlow_EaFu_WelcomeAndPortalUser_SpecialCampaign</fullName>
        <actions>
            <name>JoinFlow_Ea_Welcome_AllVeteransFamilyMembersAndSupporters</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Contact_CreatePortalUser_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_WelcomeEmailSent_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Source__c</field>
            <operation>equals</operation>
            <value>Specific IAVA Campaign</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Source_Details__c</field>
            <operation>equals</operation>
            <value>Commander-in-Chief Forum Question Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Welcome_Email_Sent__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Portal_User__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Send a welcome email to and create a portal user for any individual who comes in through a special campaign form (such as the CIC forum question form) where we do not ask them to self-identify.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JoinFlow_EaFu_WelcomeAndPortalUser_Supporter</fullName>
        <actions>
            <name>JoinFlow_Ea_Welcome_Supporter</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Contact_CreatePortalUser_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Family_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.No_Email_Blasts__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Not_a_Veteran__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When someone checks Not a Veteran on the join form (and has not identified as a veteran family member), we would like to send them a welcome email and create a new portal user for them.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JoinFlow_EaFu_WelcomeAndPortalUser_VeteranFamilyMember</fullName>
        <actions>
            <name>JoinFlow_Ea_Welcome_VeteranFamilyMember</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Contact_CreatePortalUser_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Family_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.No_Email_Blasts__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When someone checks Veteran Family Member on the join form (and has not identified as a veteran), we would like to send them a welcome email and create a new portal user for them.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JoinFlow_Ea_PaperworkIssue_AllVeterans</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sends an email to contacts with a 
 paperwork (i.e. unreadable, wrong document, etc.) that doesn&apos;t require a custom response.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JoinFlow_Ea_Welcome_LazyMember</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Family_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Post_9_11_Veteran__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Peer_Confirmation_Acceptance_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Vouch_tally_rollup__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_Other_Era__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Not_a_Veteran__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When someone submits only the first step of the form (does not self-identify veteran/family member/supporter status), we would like to send them a welcome email asking for more information.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>JoinFlow_Email_Welcome_LazyMember</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>JoinFlow_Fu_SetSignupDate_NewMember</fullName>
        <actions>
            <name>Signup_Date_Today_IF_BLANK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Signup_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When a member signs up on the main member signup form, set the signup date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>JoinFlow_Fu_UpdateSourceDetails_Everyone</fullName>
        <actions>
            <name>Contact_SourceDetails_JoinFlow</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_Source_Iava_org</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Membership - set signup date</fullName>
        <actions>
            <name>Signup_Date_Today_IF_BLANK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Signup_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When a member signs up on the main member signup form, set the signup date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NVLSP - Send Emails for Qualified Contacts</fullName>
        <actions>
            <name>NVLSP_Qualified_and_Consented_Vet_info_to_be_sent_to_NVLSP</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NVSLP_Email_to_Qualified_vet_with_consent_givenq</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.NVLSP_Consent_Given__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.CRSC_Qualified__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When contact is qualified for NVLSP and has given consent, an email will be sent to the contact and another will be sent to NVLSP.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NVLSP Rejection</fullName>
        <actions>
            <name>NVLSP_Not_Qualified</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.NVLSP_Consent_Given__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.CRSC_Qualified__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When someone has inquired about NVLSP but is not qualified, we will email them an explanation.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NVLSP Update</fullName>
        <actions>
            <name>NVLSP_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Medical_Retirement__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.VA_Disability__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Combat_Related_Disability__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When a contact meets the criteria, Meets NVLSP Criteria will be automatically checked</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Not a Veteran unchecks Veteran info</fullName>
        <actions>
            <name>OEF_Veteran_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>OIF_Veteran_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>OND_Veteran_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_VetMember</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Contact.Not_a_Veteran__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_OEF__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_OIF__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_OND__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When &quot;Not a Veteran&quot; checkbox is checked, uncheck various Veteran-specific info, without undo-ing anything too valuable.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NotVeteranSetter</fullName>
        <actions>
            <name>Set_Not_Veteran_Setter_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Not_a_Veteran_to_True_REEVAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Not_Veteran_Setter__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Not_a_Veteran__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When the Not Veteran Setter field is checked by FormAssembly, update the Not a Veteran field on the Contact. This will prevent FormAssembly from overwriting the value in the Not a Veteran checkbox during step 3 of the join form.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify admin when Contact Name has %27and%27 in it</fullName>
        <actions>
            <name>Send_Contact_and_email_to_admin</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Send email to admin when donation given for couple - should be separated into two records</description>
        <formula>OR(
CONTAINS(FirstName, &quot; and &quot;),
CONTAINS(FirstName, &quot;&amp;&quot;),
CONTAINS(LastName, &quot; and &quot;),
CONTAINS(LastName, &quot;&amp;&quot;)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OEFSetter</fullName>
        <actions>
            <name>Set_OEF_Setter_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Veteran_of_OEF_to_True_REEVAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.OEF_Setter__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_OEF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When the OEF Setter field is checked by FormAssembly, update the Veteran of OEF field on the Contact. This will prevent FormAssembly from overwriting the value in the Veteran of OEF checkbox during step 3 of the join form.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OIFSetter</fullName>
        <actions>
            <name>Set_OIF_Setter_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Veteran_of_OIF_to_True_REEVAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.OIF_Setter__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_OIF__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When the OIF Setter field is checked by FormAssembly, update the Veteran of OIF field on the Contact. This will prevent FormAssembly from overwriting the value in the Veteran of OIF checkbox during step 3 of the join form.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ONDSetter</fullName>
        <actions>
            <name>Set_OND_Setter_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Veteran_of_OND_to_True_REEVAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.OND_Setter__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_OND__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When the OND Setter field is checked by FormAssembly, update the Veteran of OND field on the Contact. This will prevent FormAssembly from overwriting the value in the Veteran of OND checkbox during step 3 of the join form.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OtherEraSetter</fullName>
        <actions>
            <name>Set_Other_Era_Setter_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Veteran_Other_Era_to_True_REEVAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Other_Era_Setter__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_Other_Era__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When the Other Era Setter field is checked by FormAssembly, update the Veteran of Other Era field on the Contact. This will prevent FormAssembly from overwriting the value in the Veteran of Other Era checkbox during step 3 of the join form.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Paperwork Accepted</fullName>
        <actions>
            <name>Paperwork_Invitation_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Paperwork_Approval_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Create_Portal_User_checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Paperwork_Accepted_Invitation_Email_sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation_Type__c</field>
            <operation>equals</operation>
            <value>Deployed OEF/OIF/OND</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.BillingState</field>
            <operation>notContain</operation>
            <value>NY,New York,TX,Texas</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Approved_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Sends welcome and membership info email once Paperwork Confirmation field is updated to &quot;Paperwork Accepted&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Paperwork Accepted - New COV Welcome</fullName>
        <actions>
            <name>Welcome_to_New_COV_OIF_OEF_OND_Veteran_with_Invite_your_peers_link</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Paperwork_Approval_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Create_Portal_User_checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation_Type__c</field>
            <operation>equals</operation>
            <value>Deployed OEF/OIF/OND</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Approved_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If contact is in one of the states invited to the beta of COV, sends New COV invitation email once Paperwork Confirmation field is updated to &quot;Paperwork Accepted&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Paperwork Approved %E2%80%93 Post 9%2F11 Veteran</fullName>
        <actions>
            <name>Paperwork_Approved_Post_9_11_Veteran</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Paperwork_Approval_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Approved_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation_Type__c</field>
            <operation>equals</operation>
            <value>Deployed Elsewhere post 9/11,Not Deployed post 9/11</value>
        </criteriaItems>
        <description>Sends welcome email once Paperwork Confirmation field is updated to &quot;Paperwork Accepted.&quot; Currently, veterans who did not deploy to Iraq or Afghanistan cannot access Rucksack.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Paperwork Approved %E2%80%93 Veteran of Other Era</fullName>
        <actions>
            <name>Paperwork_Approved_Veteran_of_Other_Era</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Paperwork_Approval_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Accepted</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Approved_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation_Type__c</field>
            <operation>equals</operation>
            <value>Pre-9/11</value>
        </criteriaItems>
        <description>Sends welcome email once Paperwork Confirmation field is updated to &quot;Paperwork Accepted.&quot; Currently, veterans of other Eras cannot access Rucksack.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Paperwork Rejected</fullName>
        <actions>
            <name>OEF_Veteran_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>OIF_Veteran_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>OND_Veteran_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Uncheck_VetMember</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Rejected</value>
        </criteriaItems>
        <description>Unchecks Veteran Member if their paperwork is rejected since they are not an eligible veteran member.  Doesnt send email because contact is made by voice or personal email.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Paperwork Request %5Bnot used anymore%5D</fullName>
        <actions>
            <name>Signup_Date_Today_IF_BLANK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 and (2 or 3) and (4 or 5 or 6) and 7</booleanFilter>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Signup_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Signup_Date__c</field>
            <operation>greaterThan</operation>
            <value>7/27/2010</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Not Requested Yet</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Vouch_tally_rollup__c</field>
            <operation>lessThan</operation>
            <value>2</value>
        </criteriaItems>
        <description>Queues email reminders to Vets for PW (1hr, bi-weekly, monthly for 6 mos, final email after 1 yr). Emails deleted when PW is recvd (eval criteria changes). Started 7/27, only for new signups (Signup Date null); older recs would get multiple emails.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>90</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>365</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>56</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Paperwork_Reminder</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Paperwork_Status_Requested</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>180</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>120</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>28</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>42</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>150</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Paperwork Request - rebuilt</fullName>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4) AND 5 AND (6 OR (7 AND 8)) AND 9</booleanFilter>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Member_Status__c</field>
            <operation>notEqual</operation>
            <value>Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Not Requested Yet,Paperwork Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Peer_Confirmation_Acceptance_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Vouch_tally_rollup__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Vouch_tally_rollup__c</field>
            <operation>lessThan</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.No_Email_Blasts__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updated Paperwork Request workflow rule as of Sep 2013.  Should go to people who sign up themselves but not to people who are peer vouched.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Paperwork_Reminder</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Paperwork_Status_Requested</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Paperwork Standard Question%2FIssue</fullName>
        <actions>
            <name>Paperwork_Question_Issue_Email_Trigger</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Standard Question/Issue</value>
        </criteriaItems>
        <description>Sends a standard email to contacts with a non-specific question/issue with paperwork (i.e. unreadable, wrong document, etc.) that doesn&apos;t require a custom response.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Paperwork approval checks Vet Member</fullName>
        <actions>
            <name>Veteran_Member_check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When paperwork is approved, make sure Veteran Member checkbox gets checked.</description>
        <formula>AND( 
     Veteran_Member__c == False
     , ISPICKVAL( Paperwork_Confirmation__c , &quot;Paperwork Accepted&quot;)
     , NOT(ISPICKVAL( PRIORVALUE(Paperwork_Confirmation__c), &quot;Paperwork Accepted&quot;))
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Paperwork received</fullName>
        <actions>
            <name>Paperwork_received_email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Paperwork_Docs_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Documents_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Received</value>
        </criteriaItems>
        <description>Sends member a paperwork received email and notifies Membership to review their record.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Paperwork resubmitted for confirmed member</fullName>
        <actions>
            <name>Paperwork_Resubmitted_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Paperwork_Status_Accepted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Approved_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Paperwork_Confirmation__c</field>
            <operation>equals</operation>
            <value>Paperwork Received</value>
        </criteriaItems>
        <description>For when someone has previously submitted paperwork, been approved (approved date is set) but FormAssembly has reverted them to status Paperwork Received because they resubmitted paperwork. This will resend the invite email and reset status to approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Peer - Welcome Peer Validated Member</fullName>
        <actions>
            <name>Set_Create_Portal_User_checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Peer_Validated_Checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Vouch_tally_rollup__c</field>
            <operation>greaterOrEqual</operation>
            <value>2</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Peer_Confirmation_Acceptance_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When Vouch Tally is &gt;= 2 and Peer Validation Acceptance date is not blank, Check Peer Validated checkbox, Check Create Portal User, and send Member Veteran Invitation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Post911VeteranSetter</fullName>
        <actions>
            <name>Contact_Post911VeteranSetter_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_Post911Veteran_True_REEVAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Post_9_11_Veteran_Setter__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Post_9_11_Veteran__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When the Post 9/11 Veteran Setter field is checked by FormAssembly, update the Post 9/11 Veteran field on the Contact. This will prevent FormAssembly from overwriting the value in the Post 9/11 Veteran checkbox during step 3 of the join form.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Provision license after form1 for users who initiated login</fullName>
        <actions>
            <name>Set_Create_Portal_User_checkbox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 3 AND (2 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Contact.Create_Portal_User__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Submitted_Application__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.User_Initiated_Login__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Submitted_Supporter_Form__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>If a contact has &quot;User Initiated Login&quot; meaning they wanted to log in, and has a Signup Date meaning they filled out Form 1, set Create Portal User to provision a portal license.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RRRP Services Information sent to Civilians</fullName>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Family_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_Other_Era__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingState</field>
            <operation>equals</operation>
            <value>NY,New York,CA,California</value>
        </criteriaItems>
        <description>Email informing Civilians about RRRP services</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RRRP_Services_Information_sent_to_Civilians</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contact.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RRRP Services for Vet or Family Member</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 4) AND 3</booleanFilter>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Family_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MailingState</field>
            <operation>equals</operation>
            <value>NY,New York,CA,California</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_of_Other_Era__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Informs new vets or veteran family members in NY/CA about RRRP services</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>RRRP_Services_for_Vet_or_Family_Member</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contact.CreatedDate</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>RRRPIntake_Fu_RemoveVARatingIfNone</fullName>
        <actions>
            <name>Contact_VADisabilityRating_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The RRRP Intake form sets the VA Disability Rating field. If someone completes the form again and identifies as no longer having a VA Disability Rating, the value in this field is not cleared as expected. Wipe it out via workflow rule instead.</description>
        <formula>AND(NOT(ISBLANK(VA_Disability_Rating__c)),ISPICKVAL(VA_Disability__c,&quot;No&quot;),ISCHANGED(VA_Disability__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Referral Confidential Contact - Should Not Receive Emails</fullName>
        <actions>
            <name>Referral_Confidential_Contact_Should_N</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Referral Confidential</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Relay Source Details</fullName>
        <actions>
            <name>Copy_SourceDetailsRelay_to_SourceDetails</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Source_Details__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Source_Details_relay__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If Source Details Relay gets filled in and Source Details is blank, relay the relay value into the field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Remove from Street Team</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Contact.npsp__Deceased__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set COV Date</fullName>
        <actions>
            <name>Set_COV_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.COV_Link__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>KW - Member Record,KW - Staffer Record,KW - Member Former,KW - Staffer Former,KW - Officer Record,KW - Officer Former</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Contact Title to KW Title</fullName>
        <actions>
            <name>Set_Contact_Title_to_KW_Title</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.kw__Title__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Title</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>IF KW Title is populated, pull it onto Title so it shows up on Campaign Member records</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VeteranMemberSetter</fullName>
        <actions>
            <name>Set_Veteran_Member_Setter_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Veteran_Member_to_True_REEVAL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Veteran_Member_Setter__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Veteran_Member__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When the Veteran Member Setter field is checked by FormAssembly, update the Veteran Member field on the Contact. This will prevent FormAssembly from overwriting the value in the Veteran Member checkbox during step 3 of the join form.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Member Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Member_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>ContactMemberFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Member RType</fullName>
        <actions>
            <name>kw__Set_KW_Member_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>ContactMember</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Officer Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Officer_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>ContactOfficerFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Officer RType</fullName>
        <actions>
            <name>kw__Set_KW_Office_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>ContactOfficer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Staffer Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Staffer_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>ContactStaffFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Staffer RType</fullName>
        <actions>
            <name>kw__Set_KW_Staffer_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>ContactStaff</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EEmailChanged_Alternate</fullName>
        <actions>
            <name>npe01__ContactAlternateEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__Preferred_Email__c ,&quot;Alternate&quot;),      OR(           AND(                ISNEW(),                LEN(Email)&gt;0           ),           ISCHANGED( Email )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EEmailChanged_Personal</fullName>
        <actions>
            <name>npe01__ContactPersonalEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(     OR( ISPICKVAL( npe01__Preferred_Email__c ,&quot;Personal&quot;),ISPICKVAL( npe01__Preferred_Email__c ,&quot;Home&quot;)),      OR(           AND(                ISNEW(),                LEN(Email)&gt;0           ),           ISCHANGED( Email )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EEmailChanged_Work</fullName>
        <actions>
            <name>npe01__ContactWorkEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__Preferred_Email__c ,&quot;Work&quot;),      OR(           AND(                ISNEW(),                LEN(Email)&gt;0           ),           ISCHANGED( Email )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Home</fullName>
        <actions>
            <name>npe01__ContactHomePhoneUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Home&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Mobile</fullName>
        <actions>
            <name>npe01__ContactMobilePhoneUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Mobile&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Other</fullName>
        <actions>
            <name>npe01__ContactOtherEmailUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Other&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPhoneChanged_Work</fullName>
        <actions>
            <name>npe01__ContactWorkPhoneUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(      ISPICKVAL( npe01__PreferredPhone__c ,&quot;Work&quot;),      OR(           AND(                ISNEW(),                LEN(Phone)&gt;0           ),           ISCHANGED( Phone )      ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPreferred_Email%5F%5Fc</fullName>
        <actions>
            <name>npe01__ContactPreferredEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow OVERWRITES the existing value in the standard Email field based on the Preferred Email field value.  This rule needs to be turned on manually after an Upgrade to this package.</description>
        <formula>OR( LEN(Email)=0, ISCHANGED(npe01__Preferred_Email__c) , ISCHANGED(npe01__WorkEmail__c) , ISCHANGED(npe01__HomeEmail__c) , ISCHANGED(npe01__AlternateEmail__c)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Contact%2EPreferred_Phone%5F%5Fc</fullName>
        <actions>
            <name>npe01__ContactPreferredPhone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow OVERWRITES the existing value in the standard Phone field based on the Preferred Phone field value.  This rule needs to be turned on manually after an Upgrade to this package.</description>
        <formula>OR(  LEN(Phone)=0, ISCHANGED(npe01__PreferredPhone__c) ,  ISCHANGED(npe01__WorkPhone__c) ,  ISCHANGED(HomePhone) ,  ISCHANGED(MobilePhone) , ISCHANGED(OtherPhone)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Email only%3A Paste to Work</fullName>
        <actions>
            <name>npe01__SetPrefEmailtoWork</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>npe01__SetWorkEmailtoEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__Preferred_Email__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__HomeEmail__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__AlternateEmail__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__WorkEmail__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>If there is a value in Email but no values in any email fields or Preferred Email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>npe01__Phone only%3A Paste to Work</fullName>
        <actions>
            <name>npe01__PreferredPhonetoWork</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>npe01__WorkPhonetoPhone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Contact.Phone</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__PreferredPhone__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.npe01__WorkPhone__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.MobilePhone</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.HomePhone</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.OtherPhone</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>A new phone value is added to the Phone field and there is no preferred Phone</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>npo02__Contact%2EPreferred_Phone%5F%5Fc WithHousehold</fullName>
        <active>false</active>
        <description>DEPRICATED: This workflow does not do anything yet.</description>
        <formula>1=2</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Custom_Paperwork_Question_Issue</fullName>
        <assignedTo>cinthya@iava.org</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Send a custom email for this prospective member veteran regarding the paperwork they submitted.</description>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Custom Paperwork Question/Issue</subject>
    </tasks>
    <tasks>
        <fullName>Paperwork_Accepted_Invitation_Email_sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Paperwork Accepted Invitation Email - sent</subject>
    </tasks>
    <tasks>
        <fullName>Review_member_paperwork</fullName>
        <assignedTo>cinthya@iava.org</assignedTo>
        <assignedToType>user</assignedToType>
        <description>Paperwork was received for this member. Review and approve or move forward as necessary</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Review member paperwork</subject>
    </tasks>
</Workflow>
