<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ProcessTracking_Ea_NoAdoptedUsers_Admins</fullName>
        <description>ProcessTracking_Ea_NoAdoptedUsers_Admins</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sysadmins</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ProcessTracking_NoAdoptedUsers_Admins</template>
    </alerts>
    <alerts>
        <fullName>ProcessTracking_Ea_NoAssignedUsers_Admins</fullName>
        <description>ProcessTracking_Ea_NoAssignedUsers_Admins</description>
        <protected>false</protected>
        <recipients>
            <recipient>Sysadmins</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ProcessTracking_NoAssignedUsers_Admins</template>
    </alerts>
    <rules>
        <fullName>ProcessTracking_Ea_NotifyAdminsNoAdoptedUsers</fullName>
        <actions>
            <name>ProcessTracking_Ea_NoAdoptedUsers_Admins</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify admins when there are no adopted users for a process</description>
        <formula>NOT(ISNEW()) &amp;&amp;
ISCHANGED(Adopted__c) &amp;&amp;
Adopted__c = 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ProcessTracking_Ea_NotifyAdminsNoAssignedUsers</fullName>
        <actions>
            <name>ProcessTracking_Ea_NoAssignedUsers_Admins</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify admins when there are no assigned users for a process</description>
        <formula>NOT(ISNEW()) &amp;&amp;
ISCHANGED(Users__c) &amp;&amp;
Users__c = 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
