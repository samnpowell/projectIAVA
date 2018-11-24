<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Auction_Donation_c3_Thank_You_Note</fullName>
        <description>Auction Donation c3 Thank-You Note</description>
        <protected>false</protected>
        <recipients>
            <field>npsp__Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Development_Templates/Auction_Donation_c3_Thank_You_Note</template>
    </alerts>
    <alerts>
        <fullName>Development_Notify_Dev_of_online_donation</fullName>
        <description>Development - Notify Dev of online donation</description>
        <protected>false</protected>
        <recipients>
            <recipient>backgroundadmin@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Development_Templates/Online_Donation_Received</template>
    </alerts>
    <alerts>
        <fullName>DonationThanks_STH2012_c3</fullName>
        <description>DonationThanks STH2012 c3</description>
        <protected>false</protected>
        <recipients>
            <field>CnP_PaaS__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Development_Templates/Donation_STH_c3_Thank_You_Note</template>
    </alerts>
    <alerts>
        <fullName>DonationThanks_c3_Gala_2013</fullName>
        <ccEmails>chris@iava.org</ccEmails>
        <description>DonationThanks c3 Gala 2013</description>
        <protected>false</protected>
        <recipients>
            <field>CnP_PaaS__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Membership_Templates/Donation_c3_Thank_You_Note_Gala2013</template>
    </alerts>
    <alerts>
        <fullName>DonationThanksc3</fullName>
        <description>DonationThanks c3</description>
        <protected>false</protected>
        <recipients>
            <field>CnP_PaaS__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Development_Templates/donationC3Thanks_LogoConditionalAddress</template>
    </alerts>
    <alerts>
        <fullName>DonationThanksc4</fullName>
        <description>DonationThanks c4</description>
        <protected>false</protected>
        <recipients>
            <field>CnP_PaaS__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Development_Templates/Donation_c4_Thank_You_Note</template>
    </alerts>
    <alerts>
        <fullName>Email_sent_to_Dev_Ass_with_Next_Steps_listed_for_a_Cash_Check_Donation</fullName>
        <description>Email sent to Development Associate with Next Steps listed for a Cash/Check Donation</description>
        <protected>false</protected>
        <recipients>
            <recipient>DevelopmentAssociate</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Cash_or_Check_Donation_Follow_Up</template>
    </alerts>
    <alerts>
        <fullName>Email_to_Development_Associate</fullName>
        <description>Email to Development Associate</description>
        <protected>false</protected>
        <recipients>
            <recipient>Dev_Notifications</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Development_Templates/X500_Donation_Received</template>
    </alerts>
    <alerts>
        <fullName>Gala_2015_Journal_Ad_Purchase_Thank_You</fullName>
        <description>Gala 2015 Journal Ad Purchase - Thank You</description>
        <protected>false</protected>
        <recipients>
            <field>CnP_PaaS__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Development_Templates/Gala_2015_Journal_Ad_Purchase_Thank_You</template>
    </alerts>
    <alerts>
        <fullName>Gala_Donation_Thank_You_Note</fullName>
        <description>Gala Donation Thank-You Note</description>
        <protected>false</protected>
        <recipients>
            <field>CnP_PaaS__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Development_Templates/Gala_Donation_Thank_You_Note</template>
    </alerts>
    <alerts>
        <fullName>Incomplete_donation_record_perhaps</fullName>
        <description>Incomplete donation record perhaps</description>
        <protected>false</protected>
        <recipients>
            <recipient>chris@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <field>LastModifiedById</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Development_Templates/Incomplete_donation_record</template>
    </alerts>
    <alerts>
        <fullName>Notification_of_Event_ticket_purchased</fullName>
        <description>Notification of Event ticket purchased</description>
        <protected>false</protected>
        <recipients>
            <recipient>chris@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kristin@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Development_Templates/Notification_of_Event_ticket_purchased</template>
    </alerts>
    <alerts>
        <fullName>Notify_Development_of_1K_Donation</fullName>
        <description>Notify Development of 1K Donation</description>
        <protected>false</protected>
        <recipients>
            <recipient>Development</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Development_Templates/X1K_Donation_Received</template>
    </alerts>
    <alerts>
        <fullName>Notify_ED_of_5K_Donation</fullName>
        <description>Notify ED of $5K+ Donation</description>
        <protected>false</protected>
        <recipients>
            <recipient>backgroundadmin@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Development_Templates/X5K_Donation_Received</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Ea_c3DonationResendThanks_AllSystems</fullName>
        <description>Opportunity_Ea_c3DonationResendThanks_AllSystems</description>
        <protected>false</protected>
        <recipients>
            <field>npsp__Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Development_Templates/donationC3Thanks_LogoConditionalAddress</template>
    </alerts>
    <alerts>
        <fullName>Opportunity_Ea_c3DonationThankYouEmail_CnP</fullName>
        <description>Opportunity_Ea_c3DonationThankYouEmail_CnP</description>
        <protected>false</protected>
        <recipients>
            <field>CnP_PaaS__Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Development_Templates/donationC3Thanks_LogoConditionalAddress</template>
    </alerts>
    <alerts>
        <fullName>STAMP_Notification_Gala_2015_Ad_Journal_Purchase</fullName>
        <ccEmails>IAVA@stampeventco.com, jason@stampeventco.com</ccEmails>
        <description>STAMP Notification: Gala 2015 Ad Journal Purchase</description>
        <protected>false</protected>
        <recipients>
            <recipient>emily@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kristin@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donate@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Development_Templates/STAMP_Notification_Gala_2015_Ad_Journal_Purchase</template>
    </alerts>
    <alerts>
        <fullName>npsp__Opportunity_Email_Acknowledgment</fullName>
        <description>Opportunity Email Acknowledgment</description>
        <protected>false</protected>
        <recipients>
            <field>npsp__Primary_Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>npsp__NPSP_Email_Templates/npsp__NPSP_Opportunity_Acknowledgment</template>
    </alerts>
    <fieldUpdates>
        <fullName>Campaign_Category_Field_Update</fullName>
        <description>Updates the Campaign Category to Events - Cultivation when the Source Category is a Cultivation Event</description>
        <field>Campaign_Category__c</field>
        <literalValue>Events - Cultivation</literalValue>
        <name>Campaign Category Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CnP_Update_Donation_Name</fullName>
        <description>Updates a donation name after it comes in from CnP</description>
        <field>Name</field>
        <formula>TEXT(YEAR(CloseDate)) &amp; &quot; &quot; &amp; Account.Name &amp; &quot; Donation&quot;</formula>
        <name>CnP Update Donation Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deposit_Date_Default_Set</fullName>
        <description>Updates Deposit Date with Close Date info, only if Deposit Date is currently blank.</description>
        <field>Deposit_Date__c</field>
        <formula>CloseDate</formula>
        <name>Deposit Date Default Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Donation_set_Actual_Goal_to_Test</fullName>
        <description>Set the Actual/Goal field to &quot;Test&quot;</description>
        <field>Actual_Goal__c</field>
        <literalValue>Test</literalValue>
        <name>Donation - set Actual/Goal to Test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_CampaignCategory_EventsCultivation</fullName>
        <description>Updates the Campaign Category to Events - Cultivation when the Source Category is a Cultivation Event</description>
        <field>Campaign_Category__c</field>
        <literalValue>Events - Cultivation</literalValue>
        <name>Opp_CampaignCategory_EventsCultivation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_CampaignCategory_Registration</fullName>
        <description>set the campaign category to registration</description>
        <field>Campaign_Category__c</field>
        <literalValue>Registration</literalValue>
        <name>Opp_CampaignCategory_Registration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationBody_InHonorGiftDetails</fullName>
        <description>Mirror the value from in honor of/gift details to dedication body</description>
        <field>stayclassy__Dedication_Email_Body__c</field>
        <formula>In_Honor_Of_Gift_Details__c</formula>
        <name>Opp_DedicationBody_InHonorGiftDetails</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationConAddress_InHonorAddress</fullName>
        <description>mirror the in honor address to the dedication contact address field</description>
        <field>stayclassy__dedication_contact_address__c</field>
        <formula>In_Honor_Address__c</formula>
        <name>Opp_DedicationConAddress_InHonorAddress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationConAddress_OnBehalfAddress</fullName>
        <description>Mirror the value in on behalf full address to the dedication contact address field</description>
        <field>stayclassy__dedication_contact_address__c</field>
        <formula>On_Behalf_Full_Address__c</formula>
        <name>Opp_DedicationConAddress_OnBehalfAddress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationContactEmail_InHonorEmail</fullName>
        <description>Set the dedication contact email to mirror the in honor email</description>
        <field>stayclassy__dedication_contact_email__c</field>
        <formula>In_Honor_Email__c</formula>
        <name>Opp_DedicationContactEmail_InHonorEmail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationContactEmail_OnBehalfEmail</fullName>
        <description>Mirror the value in on behalf email to the dedication contact email field</description>
        <field>stayclassy__dedication_contact_email__c</field>
        <formula>On_Behalf_Email__c</formula>
        <name>Opp_DedicationContactEmail_OnBehalfEmail</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationContactName_InHonorName</fullName>
        <description>Mirror the in honor name to the dedication contact name field</description>
        <field>stayclassy__dedication_contact_name__c</field>
        <formula>In_Honor_Name__c</formula>
        <name>Opp_DedicationContactName_InHonorName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationContactName_OnBehalfName</fullName>
        <description>Mirror the on behalf of name to the dedication contact name field</description>
        <field>stayclassy__dedication_contact_name__c</field>
        <formula>On_Behalf_of_Name__c</formula>
        <name>Opp_DedicationContactName_OnBehalfName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationName_InHonorName</fullName>
        <description>Set the opportunity dedication name to mirror the in honor name</description>
        <field>stayclassy__dedication_name__c</field>
        <formula>In_Honor_Name__c</formula>
        <name>Opp_DedicationName_InHonorName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationName_InMemoryName</fullName>
        <description>Mirror the in memory name to the dedication name field</description>
        <field>stayclassy__dedication_name__c</field>
        <formula>In_Memory_Name__c</formula>
        <name>Opp_DedicationName_InMemoryName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationName_OnBehalfName</fullName>
        <description>Mirror the on behalf of name to the dedication name field</description>
        <field>stayclassy__dedication_name__c</field>
        <formula>On_Behalf_of_Name__c</formula>
        <name>Opp_DedicationName_OnBehalfName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationType_honor</fullName>
        <description>opportunity dedication type is honor (donation was made in honor of...)</description>
        <field>stayclassy__dedication_type__c</field>
        <formula>&quot;honor&quot;</formula>
        <name>Opp_DedicationType_honor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationType_memory</fullName>
        <description>Set dedication type to memory</description>
        <field>stayclassy__dedication_type__c</field>
        <formula>&quot;memory&quot;</formula>
        <name>Opp_DedicationType_memory</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_DedicationType_onBehalf</fullName>
        <description>Set the dedication type to on behalf</description>
        <field>stayclassy__dedication_type__c</field>
        <formula>&quot;on behalf&quot;</formula>
        <name>Opp_DedicationType_onBehalf</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Holiday_Donation_Rename</fullName>
        <description>Renames the donation according to standard naming convention.</description>
        <field>Name</field>
        <formula>&quot;Holiday 2011 -&quot; + &quot; &quot; + Account.Name + &quot; - &quot; + TEXT(CloseDate)</formula>
        <name>Opp Holiday Donation Rename</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Name_AdhereToNamingConvention</fullName>
        <description>Updates a donation name after it comes in from CnP or Classy</description>
        <field>Name</field>
        <formula>TEXT(YEAR(CloseDate)) &amp; &quot; &quot; &amp; Account.Name &amp; &quot; Donation&quot;</formula>
        <name>Opp_Name_AdhereToNamingConvention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Set_Payment_Method_to_CC</fullName>
        <description>Sets payment method to CC.</description>
        <field>Payment_Method__c</field>
        <literalValue>Credit Card</literalValue>
        <name>Opp Set Payment Method to CC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Set_StartsRecurringSeries_to_True</fullName>
        <description>Set Starts Recurring Series to True</description>
        <field>Starts_a_Recurring_Series__c</field>
        <literalValue>1</literalValue>
        <name>Opp - Set StartsRecurringSeries to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Set_Type_to_Individual_Donation</fullName>
        <description>Changes donation type field to &quot;Individual Update&quot;</description>
        <field>Type</field>
        <literalValue>Individual Donation</literalValue>
        <name>Opp Set Type to Individual Donation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_Set_c3c4_to_c3</fullName>
        <description>Changes the c3/c4 field to c3.</description>
        <field>c3_c4__c</field>
        <literalValue>c3</literalValue>
        <name>Opp Set c3c4 to c3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_reinstate_equals_in_Source_Details</fullName>
        <description>Replace &quot;__equals__&quot; with &quot;=&quot; and &quot;__amp__&quot; with &quot;&amp;&quot; in Source Details. C&amp;P donate pages use custom questions to set Opportunity fields, but equals signs break it. So the = and &amp; get replaced in the page, and then are restored here.</description>
        <field>Source_Details__c</field>
        <formula>SUBSTITUTE(SUBSTITUTE( Source_Details__c, &quot;__equals__&quot;, &quot;=&quot;), &quot;__amp__&quot;,&quot;&amp;&quot;)</formula>
        <name>Opp - reinstate equals in Source Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_set_From_Recurring_Series_to_True</fullName>
        <description>Checks the From Recurring Series checkbox</description>
        <field>From_Recurring_Series__c</field>
        <literalValue>1</literalValue>
        <name>Opp - set From Recurring Series to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_set_Medium_to_Online</fullName>
        <field>Medium__c</field>
        <literalValue>Online</literalValue>
        <name>Opp set Medium to Online</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_set_Source_Details_to_ophomecoming</fullName>
        <field>Source_Details__c</field>
        <formula>&quot;iava.org/ophomecoming&quot;</formula>
        <name>Opp set Source Details to ophomecoming</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_set_Source_Year_End_Fundraising</fullName>
        <description>Updates source category to year-end fundraising.</description>
        <field>Source_Category__c</field>
        <literalValue>Year-End Fundraising</literalValue>
        <name>Opp set Source Year-End Fundraising</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opp_update_Actual_Goal_to_Actual</fullName>
        <description>Update the &quot;Actual/Goal&quot; field to Actual</description>
        <field>Actual_Goal__c</field>
        <literalValue>Actual</literalValue>
        <name>Opp - update Actual/Goal to Actual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_AcknolwedgementDate_Today</fullName>
        <field>npsp__Acknowledgment_Date__c</field>
        <formula>TODAY()</formula>
        <name>Opportunity_AcknolwedgementDate_Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_CampaignCategory_EventsGala</fullName>
        <field>Campaign_Category__c</field>
        <literalValue>Events - Gala</literalValue>
        <name>Opportunity_CampaignCategory_EventsGala</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_CampaignCategory_Grassroots</fullName>
        <description>Set Campaign Category to Grassroots Direct Response</description>
        <field>Campaign_Category__c</field>
        <literalValue>Grassroots Direct Response</literalValue>
        <name>Opportunity_CampaignCategory_Grassroots</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_CampaignCategory_MajorGifts</fullName>
        <description>Set Campaign Category to Major Gifts</description>
        <field>Campaign_Category__c</field>
        <literalValue>Major Gifts</literalValue>
        <name>Opportunity_CampaignCategory_MajorGifts</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_CampaignCategory_Valor</fullName>
        <description>Set Campaign Category to Grassroots Direct Response</description>
        <field>Campaign_Category__c</field>
        <literalValue>Circle of Valor Direct Response</literalValue>
        <name>Opportunity_CampaignCategory_Valor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_CodingApprovalDate_Today</fullName>
        <field>Coding_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Opportunity_CodingApprovalDate_Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_FromRecurringSeries_True</fullName>
        <description>Checks the From Recurring Series checkbox</description>
        <field>From_Recurring_Series__c</field>
        <literalValue>1</literalValue>
        <name>Opportunity_FromRecurringSeries_True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_GivingSegment_Individual</fullName>
        <field>Type</field>
        <literalValue>Individual</literalValue>
        <name>Opportunity_GivingSegment_Individual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Medium_Online</fullName>
        <description>Set medium on CnP or Classy donation to online</description>
        <field>Medium__c</field>
        <literalValue>Online</literalValue>
        <name>Opportunity_Medium_Online</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_PaymentMethod_CreditCard</fullName>
        <description>Set Payment Method to Credit Card for CnP and Classy donations</description>
        <field>Payment_Method__c</field>
        <literalValue>Credit Card</literalValue>
        <name>Opportunity_PaymentMethod_CreditCard</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_SourceDetails_ReplaceSymbols</fullName>
        <description>Replace &quot;__equals__&quot; with &quot;=&quot; and &quot;__amp__&quot; with &quot;&amp;&quot; in Source Details. C&amp;P donate pages use custom questions to set Opportunity fields, but equals signs break it. So the = and &amp; get replaced in the page, and then are restored here.</description>
        <field>Source_Details__c</field>
        <formula>SUBSTITUTE(SUBSTITUTE( Source_Details__c, &quot;__equals__&quot;, &quot;=&quot;), &quot;__amp__&quot;,&quot;&amp;&quot;)</formula>
        <name>Opportunity_SourceDetails_ReplaceSymbols</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_StartsRecurringSeries_True</fullName>
        <description>Set Starts Recurring Series to True</description>
        <field>Starts_a_Recurring_Series__c</field>
        <literalValue>1</literalValue>
        <name>Opportunity_StartsRecurringSeries_True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_System_Classy</fullName>
        <description>sets the System field to Classy</description>
        <field>System__c</field>
        <literalValue>Classy</literalValue>
        <name>Opportunity_System_Classy</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_System_ClickAndPledge</fullName>
        <description>Set System to Click and Pledge for all CnP donations</description>
        <field>System__c</field>
        <literalValue>Click and Pledge</literalValue>
        <name>Opportunity_System_ClickAndPledge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Type_Individual</fullName>
        <description>When CnP or Classy creates a donation, set type to Individual</description>
        <field>Type</field>
        <literalValue>Individual</literalValue>
        <name>Opportunity_Type_Individual</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_c3c4_c3</fullName>
        <description>Set c3c4 to c3</description>
        <field>c3_c4__c</field>
        <literalValue>c3</literalValue>
        <name>Opportunity_c3c4_c3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Medium_on_CnP_records2</fullName>
        <description>Set medium on CnP donation to online</description>
        <field>Medium__c</field>
        <literalValue>Online</literalValue>
        <name>Set Medium on CnP records2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Payment_Method_to_Credit_Card</fullName>
        <description>Set Payment Method to Credit Card</description>
        <field>Payment_Method__c</field>
        <literalValue>Credit Card</literalValue>
        <name>Set Payment Method to Credit Card</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_System_to_Click_and_Pledge</fullName>
        <description>Set System to Click and Pledge</description>
        <field>System__c</field>
        <literalValue>Click and Pledge</literalValue>
        <name>Set System to Click and Pledge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_c3c4_to_c3</fullName>
        <description>Set c3c4 to c3</description>
        <field>c3_c4__c</field>
        <literalValue>c3</literalValue>
        <name>Set c3c4 to c3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_type_on_CnP_records</fullName>
        <description>When CnP RObot creates a donation, set type to Individual</description>
        <field>Type</field>
        <literalValue>Individual</literalValue>
        <name>Set type on CnP records</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Fiscale_Year</fullName>
        <field>Fiscal_Year__c</field>
        <formula>TEXT(YEAR( CloseDate ))</formula>
        <name>Update Fiscale Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npsp__Opportunity_AcknowledgmentStatus_Update</fullName>
        <description>Sets the Acknowledgment Status to &quot;Acknowledged&quot;</description>
        <field>npsp__Acknowledgment_Status__c</field>
        <literalValue>Acknowledged</literalValue>
        <name>Opportunity Acknowledgment Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npsp__Opportunity_Acknowledgment_Date_Update</fullName>
        <description>sets the Acknowledgment Date to Today.</description>
        <field>npsp__Acknowledgment_Date__c</field>
        <formula>Today()</formula>
        <name>Opportunity Acknowledgment Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>npsp__Opportunity_Copy_FMV_to_Amount</fullName>
        <description>Copy the Opportunities Fair Market Value field to the Amount field.</description>
        <field>Amount</field>
        <formula>npsp__Fair_Market_Value__c</formula>
        <name>Opportunity Copy FMV to Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>updatedonationname</fullName>
        <field>Name</field>
        <formula>Account.Name &amp; &quot;- Donation &quot; &amp;  TEXT(MONTH( CloseDate )) &amp; &quot;/&quot; &amp; TEXT(DAY( CloseDate )) &amp; &quot;/&quot; &amp; TEXT(YEAR( CloseDate ))</formula>
        <name>Update Donation Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Auction Donation c3 Thank-You Note</fullName>
        <actions>
            <name>Auction_Donation_c3_Thank_You_Note</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_AcknolwedgementDate_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Auction_Donation_Thank_You_Note_sent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Send email for c3 Auction donation record</description>
        <formula>AND(OR(IsWon, Resend_Thanks__c), NOT(Suppress_Thank_You_Email__c), Auction_Donation__c, OR( 
ISCHANGED(Amount), ISCHANGED(StageName), ISCHANGED(Resend_Thanks__c), ISCHANGED(Auction_Donation__c), ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Campaign Category Field Update</fullName>
        <actions>
            <name>Campaign_Category_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Source_Category__c</field>
            <operation>equals</operation>
            <value>Cultivation Event</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Cash%2FCheck Donation Follow-Up</fullName>
        <actions>
            <name>Email_sent_to_Dev_Ass_with_Next_Steps_listed_for_a_Cash_Check_Donation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Payment_Method__c</field>
            <operation>equals</operation>
            <value>Check,Cash,Credit Card (One-Time),Money Order,Credit Card (Recurring),Wire Transfer</value>
        </criteriaItems>
        <description>Review the Donor record and decide whether anything other than a &quot;Thank You&quot; card should be sent</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CnP Gala 2013 Donation Thank You email</fullName>
        <actions>
            <name>DonationThanks_c3_Gala_2013</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_AcknolwedgementDate_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Send email for c3 Gala 2013 CnP donation record</description>
        <formula>and(NOT(ISBLANK(CnP_PaaS__CnP_OrderNumber__c)), IsWon, not(ispickval(c3_c4__c,&quot;c4&quot;)),left( Name,9 )=&quot;Gala 2013&quot; , NOT(Suppress_Thank_You_Email__c) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CnP c3 Donation Thank You email</fullName>
        <actions>
            <name>DonationThanksc3</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_AcknolwedgementDate_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Send email for c3 CnP donation record</description>
        <formula>AND(NOT(ISBLANK(CnP_PaaS__CnP_OrderNumber__c)), 
ISPICKVAL(Actual_Goal__c, &quot;Actual&quot;),
OR(IsWon,Resend_Thanks__c),
NOT(ISPICKVAL(c3_c4__c,&quot;c4&quot;)),
NOT(Suppress_Thank_You_Email__c),
NOT(Campaign.Name=&quot;Gala 2015 Journal Ad Purchase&quot;),
CloseDate &gt; (TODAY()-10),
CnP_PaaS__C_P_Recurring__c != &apos;a2XC0000007aIwj&apos;,
NOT(Auction_Donation__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CnP c3 STH Donation Thank You email</fullName>
        <actions>
            <name>DonationThanks_STH2012_c3</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_AcknolwedgementDate_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Send email for c3 STH donation record</description>
        <formula>and(NOT(ISBLANK(CnP_PaaS__CnP_OrderNumber__c)), IsWon, not(ispickval(c3_c4__c,&quot;c4&quot;)),left(  Name ,7 )=&quot;STH2012&quot;, NOT(Suppress_Thank_You_Email__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CnP c4 Donation Thank You email</fullName>
        <actions>
            <name>DonationThanksc4</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_AcknolwedgementDate_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Send email for c4 donation record</description>
        <formula>AND(NOT(ISBLANK(CnP_PaaS__CnP_OrderNumber__c)),
OR(IsWon,Resend_Thanks__c),
ISPICKVAL(c3_c4__c,&quot;c4&quot;),
NOT(Suppress_Thank_You_Email__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Deposit Date Default Set</fullName>
        <actions>
            <name>Deposit_Date_Default_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the Deposit Date is blank, this rule will update it with the current close date.</description>
        <formula>AND(ISBLANK(  Deposit_Date__c  ),NOT( ISPICKVAL(StageName, &quot;Posted&quot;)))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Development - Notify Dev if Someone buys a ticket to an Event</fullName>
        <actions>
            <name>Notification_of_Event_ticket_purchased</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends an email alert to Dev if someone buys a ticket to an Event. Works if Event is in the name of the campaign</description>
        <formula>AND(Campaign.Name = &apos;IAVA Special Event- Heroes Celebration 2013&apos;,
OR(IsWon,Resend_Thanks__c),
ISPICKVAL(Actual_Goal__c,&apos;Actual&apos;), 
CloseDate &gt; (TODAY()-10))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Development - Notify Dev of online donation</fullName>
        <actions>
            <name>Development_Notify_Dev_of_online_donation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends an email alert to Development if an online donation is received unless it is part of a recurring payment.</description>
        <formula>AND(ISPICKVAL(Medium__c,&apos;Online&apos;),
NOT(From_Recurring_Series__c),
OR(IsWon,Resend_Thanks__c),
RecordType.Name != &apos;Goal&apos;,
ISPICKVAL(Actual_Goal__c,&apos;Actual&apos;), 
CloseDate &gt; (TODAY()-10))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Development - Notify Development Group of %3E%241%2C000 donation</fullName>
        <actions>
            <name>Notify_Development_of_1K_Donation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends an email alert to the Development Group if a donation meets or exceeds $1,000.</description>
        <formula>AND(Amount&gt;=1000,
OR(IsWon,Resend_Thanks__c),
RecordType.Name != &apos;Goal&apos;,
ISPICKVAL(Actual_Goal__c,&apos;Actual&apos;), 
CloseDate &gt; (TODAY()-10))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Development - Notify ED of %3E%245%2C000 donation</fullName>
        <actions>
            <name>Notify_ED_of_5K_Donation</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Sends an email alert to the ED if a donation meets or exceeds $5,000.</description>
        <formula>AND(Amount&gt;=5000, OR(IsWon,Resend_Thanks__c), RecordType.Name != &apos;Goal&apos;, ISPICKVAL(Actual_Goal__c,&apos;Actual&apos;), OR(ISCHANGED(Amount), ISCHANGED(StageName), ISCHANGED(Resend_Thanks__c), ISCHANGED(Actual_Goal__c), ISCHANGED(CloseDate), ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Donation - Update Actual%2FGoal to Actual if blank</fullName>
        <actions>
            <name>Opp_update_Actual_Goal_to_Actual</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Actual_Goal__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Donation</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Donation - mark Test donation in Actual%2FGoal field</fullName>
        <actions>
            <name>Donation_set_Actual_Goal_to_Test</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Marks a Test CnP donation as Test in the Actual/Goal field</description>
        <formula>ispickval( CnP_PaaS__CnP_OrderNumber__r.CnP_PaaS__Transaction_Type__c , &quot;Test&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Donation - replace %5F%5Fequals%5F%5F with equals sign and _amp_ with ampersand</fullName>
        <actions>
            <name>Opp_reinstate_equals_in_Source_Details</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Replace __equals__ with = and _amp_ with &amp; in Source Details. C&amp;P donate pages use custom questions to set Opportunity fields, but equals signs break it. So the = gets replaced by __equals__ in the page, and then the = is restored using this field update.</description>
        <formula>and(
 not(isblank( Source_Details__c ))
 , or(
    ischanged(Source_Details__c),
    isnew()
   )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Donation - set From Recurring Series for CnP recurring donation</fullName>
        <actions>
            <name>Opp_set_From_Recurring_Series_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.From_CnP_Recurring_Series__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>When a CnP recurred donation comes in, check the From Recurring Series checkbox.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Donation_Fu_ChangeIndividualDonationToIndividual</fullName>
        <actions>
            <name>Opportunity_GivingSegment_Individual</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
            <value>Individual Donation</value>
        </criteriaItems>
        <description>when a record is inserted with or updated to have a giving segment of &quot;Individual Donation&quot; change it to &quot;Individual&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ED Review Donation Over %241%2C000</fullName>
        <actions>
            <name>Review_Large_Donation</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>1000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
            <value>Individual Donation,Foundation Donation,Corporate Donation</value>
        </criteriaItems>
        <description>Assigns a task to Paul to review any donation record that is $1,000 or greater.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fiscal Year Update</fullName>
        <actions>
            <name>Update_Fiscale_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>or(
  ISBLANK( Fiscal_Year__c ),
  ISCHANGED( CloseDate )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Gala 2015 Journal Ad Purchase - Thank You</fullName>
        <actions>
            <name>Gala_2015_Journal_Ad_Purchase_Thank_You</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_AcknolwedgementDate_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Gala_2015_Journal_Ad_Purchase_Thank_You_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Thank you email that&apos;s sent when an Gala 2015 Journal Ad Purchase is made.</description>
        <formula>AND(Campaign.Name = &apos;Gala 2015 Journal Ad Purchase&apos;,
OR(IsWon,Resend_Thanks__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Gala Donation Thank-You Note</fullName>
        <actions>
            <name>Gala_Donation_Thank_You_Note</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_AcknolwedgementDate_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Gala_Donation_Thank_You_Note_sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Thank you email that&apos;s sent when a Gala ticket is purchased</description>
        <formula>AND(Campaign.Name = &apos;2017 HG Ticket Purchase&apos;,
OR(IsWon,Resend_Thanks__c),
NOT(Suppress_Thank_You_Email__c),
NOT(Auction_Donation__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GalaDonation_Fu_UpdateGivingSegmentAndCampaignCategory</fullName>
        <actions>
            <name>Opportunity_CampaignCategory_EventsGala</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_GivingSegment_Individual</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Campaign.Name = &apos;2017 HG Ticket Purchase&apos; &amp;&amp;
IsWon &amp;&amp; NOT(ISPICKVAL(Type, &apos;Individual&apos;)) &amp;&amp; NOT(ISPICKVAL(Campaign_Category__c, &apos;Events - Gala&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Set Name for data migration records that have no name</fullName>
        <actions>
            <name>updatedonationname</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Name</field>
            <operation>equals</operation>
            <value>DIA Data Migration</value>
        </criteriaItems>
        <description>Sets the naming convention for the records migrated via data migration that have no name.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityCoding_Fu_CodingApprovalDate</fullName>
        <actions>
            <name>Opportunity_CodingApprovalDate_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Coding_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Ea_NotifyDevTeamOf500PlusDonation</fullName>
        <actions>
            <name>Email_to_Development_Associate</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends an email alert to Dev if a donation is greater than $499</description>
        <formula>AND(
       OR(
            ISNEW(),
            ISCHANGED(StageName)
        ),
        Amount&gt;=500,
        IsWon,
        RecordType.Name != &apos;Goal&apos;,
        ISPICKVAL(Actual_Goal__c,&apos;Actual&apos;), 
        CloseDate &gt; (TODAY()-10)
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Ea_c3DonationResendThanks_AllSystems</fullName>
        <actions>
            <name>Opportunity_Ea_c3DonationResendThanks_AllSystems</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Thank_you_email_resent</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>resend thank you email for all c3 donation records (manual entry, paypal, classy, cnp, other)</description>
        <formula>ISCHANGED(Resend_Thanks__c) &amp;&amp; Resend_Thanks__c &amp;&amp; NOT(Suppress_Thank_You_Email__c) &amp;&amp; NOT(Auction_Donation__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Ea_c3DonationThankYouEmail_CnP</fullName>
        <actions>
            <name>Opportunity_Ea_c3DonationThankYouEmail_CnP</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Opportunity_AcknolwedgementDate_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Send email for c3 CnP donation record (only for initial thank you. does not handle resend thanks; that&apos;s handled in a separate email)</description>
        <formula>AND(NOT(ISBLANK(CnP_PaaS__CnP_OrderNumber__c)),  ISPICKVAL(Actual_Goal__c, &quot;Actual&quot;), IsWon, NOT(ISPICKVAL(c3_c4__c,&quot;c4&quot;)), NOT(Suppress_Thank_You_Email__c), NOT(Campaign.Name=&quot;Gala 2015 Journal Ad Purchase&quot;), CloseDate &gt; (TODAY()-10), CnP_PaaS__C_P_Recurring__c != &apos;a2XC0000007aIwj&apos;, NOT(Auction_Donation__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_AcknowledementDateForClassyGifts</fullName>
        <actions>
            <name>Opportunity_AcknolwedgementDate_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Add the date acknowledged for Classy donations</description>
        <formula>AND(NOT(ISBLANK(stayclassy__sc_order_id__c)),  ISPICKVAL(Actual_Goal__c, &quot;Actual&quot;), OR(IsWon,Resend_Thanks__c), NOT(ISPICKVAL(c3_c4__c,&quot;c4&quot;)), NOT(Suppress_Thank_You_Email__c), CloseDate &gt; (TODAY()-10))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_CampaignCategoryIsCultivationEvent</fullName>
        <actions>
            <name>Opp_CampaignCategory_EventsCultivation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Source_Category__c</field>
            <operation>equals</operation>
            <value>Cultivation Event</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_ClassyCampaignCategory0</fullName>
        <actions>
            <name>Opp_CampaignCategory_Registration</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>After required fields are set on Classy donations, set the campaign category for donations of $0.00 to Registration.</description>
        <formula>stayclassy__sc_order_id__c != null &amp;&amp;
NOT(ISPICKVAL(Type,&apos;&apos;)) &amp;&amp;
NOT(ISPICKVAL(Campaign_Category__c, &apos;Events - Gala&apos;)) &amp;&amp;
Amount == 0 &amp;&amp;
NOT(ISPICKVAL(Source_Category__c, &apos;Cultivation Event&apos;)) &amp;&amp;
NOT(CONTAINS(Campaign.Name, &apos;HG&apos;)) &amp;&amp;
NOT(CONTAINS(Campaign.Name, &apos;Heroes Gala&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_CnPCampaignCategory0-999</fullName>
        <actions>
            <name>Opportunity_CampaignCategory_Grassroots</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CnP_Checkout_Page__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Campaign_Category__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>lessThan</operation>
            <value>1000</value>
        </criteriaItems>
        <description>After required fields are set on C&amp;P donations, set the campaign category for donations of $0.01-$999.99 to Grassroots Direct Response.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_CnPCampaignCategory1000-9999</fullName>
        <actions>
            <name>Opportunity_CampaignCategory_Valor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CnP_Checkout_Page__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Campaign_Category__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>1000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>lessThan</operation>
            <value>10000</value>
        </criteriaItems>
        <description>After required fields are set on C&amp;P donations, set the campaign category for donations of $1000.00-$9999.99 to Circle of Valor Direct Response.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_CnPCampaignCategory10000Plus</fullName>
        <actions>
            <name>Opportunity_CampaignCategory_MajorGifts</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CnP_Checkout_Page__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Campaign_Category__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterOrEqual</operation>
            <value>10000</value>
        </criteriaItems>
        <description>After required fields are set on C&amp;P donations, set the campaign category for donations of $10000.00 or more to Major Gifts.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_EnsureNameAdheresToConventions</fullName>
        <actions>
            <name>Opp_Name_AdhereToNamingConvention</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Rename donation record to fit in with current naming conventions</description>
        <formula>AND(OR(NOT(ISBLANK(CnP_PaaS__CnP_OrderNumber__c)),NOT(ISBLANK(stayclassy__sc_order_id__c ))),IsWon)</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_FromRecurringSeries</fullName>
        <actions>
            <name>Opportunity_FromRecurringSeries_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.From_CnP_Recurring_Series__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.stayclassy__Classy_Pay_Recurring_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When a CnP or Classy recurred donation comes in, check the From Recurring Series checkbox.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_InHonorOfDetailsToClassyDedicationFields</fullName>
        <actions>
            <name>Opp_DedicationBody_InHonorGiftDetails</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DedicationConAddress_InHonorAddress</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DedicationContactEmail_InHonorEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DedicationContactName_InHonorName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DedicationName_InHonorName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DedicationType_honor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>Opportunity.In_Honor_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.In_Honor_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.In_Honor_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.In_Honor_Of_Gift_Details__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If a non-Classy donation comes in with in honor of details, mirror that information into the classy dedication fields because it&apos;s a better setup</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_InMemoryOfDetailsToClassyDedicationFields</fullName>
        <actions>
            <name>Opp_DedicationName_InMemoryName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DedicationType_memory</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.In_Memory_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If a non-Classy donation comes in with in memory of details, mirror that information into the classy dedication fields because it&apos;s a better setup</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_OnBehalfOfDetailsToClassyDedicationFields</fullName>
        <actions>
            <name>Opp_DedicationConAddress_OnBehalfAddress</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DedicationContactEmail_OnBehalfEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DedicationContactName_OnBehalfName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DedicationName_OnBehalfName</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opp_DedicationType_onBehalf</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.On_Behalf_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.On_Behalf_Full_Address__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.On_Behalf_of_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>If a non-Classy donation comes in with on behalf of details, mirror that information into the classy dedication fields because it&apos;s a better setup</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_OnlineCampaignCategory%2E01-999</fullName>
        <actions>
            <name>Opportunity_CampaignCategory_Grassroots</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>After required fields are set on C&amp;P or Classy donations, set the campaign category for donations of $0.01-$999.99 to Grassroots Direct Response.</description>
        <formula>(CnP_Checkout_Page__c != null ||
 stayclassy__sc_order_id__c != null) &amp;&amp;
NOT(ISPICKVAL(Type, &apos;&apos;)) &amp;&amp;
NOT(ISPICKVAL(Campaign_Category__c, &apos;Events - Gala&apos;)) &amp;&amp;
Amount &gt; 0 &amp;&amp;
Amount &lt; 1000 &amp;&amp;
NOT(ISPICKVAL(Source_Category__c, &apos;Cultivation Event&apos;)) &amp;&amp;
NOT(CONTAINS(Campaign.Name, &apos;HG&apos;)) &amp;&amp;
NOT(CONTAINS(Campaign.Name, &apos;Heroes Gala&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_OnlineCampaignCategory1000-9999</fullName>
        <actions>
            <name>Opportunity_CampaignCategory_Valor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>After required fields are set on C&amp;P or Classy donations, set the campaign category for donations of $1000.00-$9999.99 to Circle of Valor Direct Response.</description>
        <formula>(CnP_Checkout_Page__c != null ||
 stayclassy__sc_order_id__c != null) &amp;&amp;
NOT(ISPICKVAL(Type, &apos;&apos;)) &amp;&amp;
NOT(ISPICKVAL(Campaign_Category__c, &apos;Events - Gala&apos;)) &amp;&amp;
Amount &gt;= 1000 &amp;&amp;
Amount &lt; 10000 &amp;&amp;
NOT(ISPICKVAL(Source_Category__c, &apos;Cultivation Event&apos;)) &amp;&amp;
NOT(CONTAINS(Campaign.Name, &apos;HG&apos;)) &amp;&amp;
NOT(CONTAINS(Campaign.Name, &apos;Heroes Gala&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_OnlineCampaignCategory10000Plus</fullName>
        <actions>
            <name>Opportunity_CampaignCategory_MajorGifts</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>After required fields are set on C&amp;P or Classy donations, set the campaign category for donations of $10000.00 or more to Major Gifts.</description>
        <formula>(CnP_Checkout_Page__c != null ||
 stayclassy__sc_order_id__c != null) &amp;&amp;
NOT(ISPICKVAL(Type, &apos;&apos;)) &amp;&amp;
NOT(ISPICKVAL(Campaign_Category__c, &apos;Events - Gala&apos;)) &amp;&amp;
Amount &gt;= 10000 &amp;&amp;
NOT(ISPICKVAL(Source_Category__c, &apos;Cultivation Event&apos;)) &amp;&amp;
NOT(CONTAINS(Campaign.Name, &apos;HG&apos;)) &amp;&amp;
NOT(CONTAINS(Campaign.Name, &apos;Heroes Gala&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_ReplaceSymbolsInSourceDetails</fullName>
        <actions>
            <name>Opportunity_SourceDetails_ReplaceSymbols</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Replace __equals__ with = and _amp_ with &amp; in Source Details. C&amp;P donate pages use custom questions to set Opportunity fields, but equals signs break it. So the = gets replaced by __equals__ in the page, and then the = is restored using this field update.</description>
        <formula>and(  or(    contains(Source_Details__c, &apos;__equals__&apos;),    contains(Source_Details__c, &apos;__amp__&apos;)  )  , or(     ischanged(Source_Details__c),     isnew()    ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_SetStartsRecurringSeries</fullName>
        <actions>
            <name>Opportunity_StartsRecurringSeries_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If this is the first donation in a recurring series (Recurring First Installment Date is same as Transaction Date) then check Starts Recurring Series</description>
        <formula>and(    not(Starts_a_Recurring_Series__c),   or(     and(       not(isblank( CnP_PaaS__CnP_OrderNumber__r.CnP_PaaS__C_P_Recurring__c )),       CnP_PaaS__CnP_OrderNumber__r.CnP_PaaS__C_P_Recurring__r.CnP_PaaS__FirstChargeDate__c        ==        datevalue(CnP_PaaS__CnP_OrderNumber__r.CnP_PaaS__TransactionDate__c)     ),     and(       not(isblank(stayclassy__sf_recurring_id__c)),       datevalue(stayclassy__sf_recurring_id__r.stayclassy__start_date__c) == CloseDate     )   ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_SetTypeMediumSystemPaymentMethodc3c4_Classy</fullName>
        <actions>
            <name>Opportunity_Medium_Online</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_PaymentMethod_CreditCard</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_System_Classy</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Type_Individual</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_c3c4_c3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4 OR 5 OR 6)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.stayclassy__sc_order_id__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.c3_c4__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Payment_Method__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.System__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Medium__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Set Type, Medium, System, Payment Method, and c3/c4 field values on Classy donations</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Opportunity_Fu_SetTypeMediumSystemPaymentMethodc3c4_CnP</fullName>
        <actions>
            <name>Opportunity_Medium_Online</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_PaymentMethod_CreditCard</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_System_ClickAndPledge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Type_Individual</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_c3c4_c3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.CnP_Checkout_Page__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.c3_c4__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Payment_Method__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When donation owner is CnP Robot, set required fields - Updated 11/14/13 to find records where CnP Checkout Page is blank, rather than created by CnPRobot, because dedupe procedure makes staff the creator of the records.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Possible incomplete donation record</fullName>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR (3 AND 4) OR 5) and 6 and 7 and 8</booleanFilter>
        <criteriaItems>
            <field>Opportunity.c3_c4__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Medium__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.System__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Medium__c</field>
            <operation>notEqual</operation>
            <value>Offline</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Payment_Method__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.From_Recurring_Series__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Goal,Reimbursement,In-Kind Donation</value>
        </criteriaItems>
        <description>Alert sysadmin if there&apos;s a possible incomplete donation record so it can be investigated.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Incomplete_donation_record_perhaps</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Reminder%3A Grant Report due in 6 weeks</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Report_Due_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When a Grant Report due date is in 6 weeks, Development and Program groups are sent a reminder</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <offsetFromField>Opportunity.Report_Due_Date__c</offsetFromField>
            <timeLength>-42</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Rename CnP Donation</fullName>
        <actions>
            <name>CnP_Update_Donation_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Rename donation record</description>
        <formula>AND(NOT(ISBLANK(CnP_PaaS__CnP_OrderNumber__c)),IsWon)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>STAMP Notification%3A Gala 2015 Ad Journal Purchase</fullName>
        <actions>
            <name>STAMP_Notification_Gala_2015_Ad_Journal_Purchase</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>STAMP_Notification_Gala_2015_Ad_Journal_Purchase_Sent</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.CampaignId</field>
            <operation>equals</operation>
            <value>Gala 2015 Journal Ad Purchase</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Posted</value>
        </criteriaItems>
        <description>Sends STAMP a notification when an Event Ad Journal purchase is made.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Send Gala 2013 details to Ticket Buyers</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.c3_c4__c</field>
            <operation>notEqual</operation>
            <value>c4</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.CampaignId</field>
            <operation>equals</operation>
            <value>701C0000000RL2R</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Suppress_Thank_You_Email__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>When someone has a donation to the Gala, they should get a special message with details to the Gala</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Starts Recurring if first recurring donation</fullName>
        <actions>
            <name>Opp_Set_StartsRecurringSeries_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If this is the first donation in a recurring series (Recurring First Installment Date is same as Transaction Date) then check Starts Recurring Series</description>
        <formula>and( 
 not(Starts_a_Recurring_Series__c)
,
 not(isblank( CnP_PaaS__CnP_OrderNumber__r.CnP_PaaS__C_P_Recurring__c ))
,
 CnP_PaaS__CnP_OrderNumber__r.CnP_PaaS__C_P_Recurring__r.CnP_PaaS__FirstChargeDate__c 
    == 
 datevalue(CnP_PaaS__CnP_OrderNumber__r.CnP_PaaS__TransactionDate__c)
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set required fields on CnP records</fullName>
        <actions>
            <name>Set_Medium_on_CnP_records2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Payment_Method_to_Credit_Card</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_System_to_Click_and_Pledge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_c3c4_to_c3</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_type_on_CnP_records</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.CnP_Checkout_Page__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Type</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.c3_c4__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Payment_Method__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When donation owner is CnP Robot, set required fields - Updated 11/14/13 to find records where CnP Checkout Page is blank, rather than created by CnPRobot, because dedupe procedure makes staff the creator of the records.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Top Donor or IAVA Board Member Donation</fullName>
        <actions>
            <name>Engage_Donation_Record</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.IAVA_Board_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Donor_Level__c</field>
            <operation>equals</operation>
            <value>Top</value>
        </criteriaItems>
        <description>Assigns a task toPaul to review any donation record relating to a Top Donor or IAVA Board Member</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>npsp__Opportunity Copy FMV to Amount</fullName>
        <actions>
            <name>npsp__Opportunity_Copy_FMV_to_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.npsp__Fair_Market_Value__c</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>Enable this rule to copy the Fair Market Value to the Amount field, when the Amount is zero or blank.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>npsp__Opportunity Email Acknowledgment</fullName>
        <actions>
            <name>npsp__Opportunity_Email_Acknowledgment</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>npsp__Opportunity_AcknowledgmentStatus_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>npsp__Opportunity_Acknowledgment_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Emails an acknowledgement to the Primary Contact for an Opportunity when the Acknowledgement Status is set to Email Acknowledgement Now.</description>
        <formula>TEXT(npsp__Acknowledgment_Status__c) = $Label.npsp__sendAcknowledgmentFireStatus &amp;&amp;  npsp__Primary_Contact__r.Email &lt;&gt; NULL &amp;&amp;  npsp__Primary_Contact__r.npsp__Do_Not_Contact__c &lt;&gt; True &amp;&amp;  npsp__Primary_Contact__r.HasOptedOutOfEmail &lt;&gt; True &amp;&amp;  npsp__Primary_Contact__r.npsp__Deceased__c &lt;&gt; True</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Auction_Donation_Thank_You_Note_sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Auction Donation Thank You Note - sent</subject>
    </tasks>
    <tasks>
        <fullName>Engage_Donation_Record</fullName>
        <assignedTo>paul@iava.org</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Engage Donation Record</subject>
    </tasks>
    <tasks>
        <fullName>Gala_2015_Journal_Ad_Purchase_Thank_You_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Gala 2015 Journal Ad Purchase - Thank You - Sent</subject>
    </tasks>
    <tasks>
        <fullName>Gala_Donation_Thank_You_Note_sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Gala Donation Thank-You Note - sent</subject>
    </tasks>
    <tasks>
        <fullName>Review_Large_Donation</fullName>
        <assignedTo>ExecutiveDirector</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Review Large Donation</subject>
    </tasks>
    <tasks>
        <fullName>STAMP_Notification_Gala_2015_Ad_Journal_Purchase_Sent</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>STAMP Notification: Gala 2015 Ad Journal Purchase - Sent</subject>
    </tasks>
    <tasks>
        <fullName>Thank_you_email_resent</fullName>
        <assignedToType>owner</assignedToType>
        <description>Dear [contact name],

Thank you very much for your donation of [amount] to Iraq and Afghanistan Veterans of America (IAVA). [snip...see email template here: https://na8.salesforce.com/00XC00000028Bv7]</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>Thank you email resent</subject>
    </tasks>
    <tasks>
        <fullName>cashcheckdonationfollowup</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Cash/Check Donation Follow-Up</subject>
    </tasks>
    <tasks>
        <fullName>reviewdonationover1k</fullName>
        <assignedTo>ExecutiveDirector</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Review Donation Over 1K</subject>
    </tasks>
</Workflow>
