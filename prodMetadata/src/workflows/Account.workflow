<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Change_Owner_to_Membership</fullName>
        <description>When a record is created by DIA integration make the owner someone from Membership</description>
        <field>OwnerId</field>
        <lookupValue>backgroundadmin@iava.org</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Owner to Membership</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CnP_Account_Individual_Set</fullName>
        <description>Test</description>
        <field>npe01__SYSTEMIsIndividual__c</field>
        <literalValue>1</literalValue>
        <name>CnP Account Individual Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CnP_Account_Type_Set</fullName>
        <description>Sets account type to One-to-One Individual prior to insert.</description>
        <field>npe01__SYSTEM_AccountType__c</field>
        <formula>&quot;One-to-One Individual&quot;</formula>
        <name>CnP Account Type Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MALatitudec_Purge</fullName>
        <description>Purge the MA_Latitude__c field on the Account if selected address fields change; created by the Metadata API</description>
        <field>MA_Latitude__c</field>
        <name>MA MA_Latitude__c Purge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MALongitudec_Purge</fullName>
        <description>Purge the MA_Longitude__c field on the Account if selected address fields change; created by the Metadata API</description>
        <field>MA_Longitude__c</field>
        <name>MA MA_Longitude__c Purge</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MA_ClearAccountLatitude</fullName>
        <field>MA_Latitude__c</field>
        <name>Clear Account Latitude</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MA_ClearAccountLongitude</fullName>
        <field>MA_Longitude__c</field>
        <name>Clear Account Longitude</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Owner_to_Background_Admin</fullName>
        <description>Sets the Account Owner to Background Admin Robot</description>
        <field>OwnerId</field>
        <lookupValue>backgroundadmin@iava.org</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Account Owner to Background Admin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Press_Outlet_box</fullName>
        <description>Set Press Outlet checkbox when account type is Press Outlet</description>
        <field>Press_Outlet__c</field>
        <literalValue>1</literalValue>
        <name>Set Press Outlet box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Caucus_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Caucus_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Caucus Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Caucus_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Caucus</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Caucus RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Committee_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Committee_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Committee Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Committee_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Account_Committee</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Committee RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Member_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Legislative_Member_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Member Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Member_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Account_Member</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Member RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Office_Former_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Account_Officer_Former</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Office Former RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>kw__Set_KW_Office_RType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>kw__KW_Account_Officer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set KW Office RType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account_BillingCity_Field_Changed</fullName>
        <actions>
            <name>MALatitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MALongitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the Account if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(BillingCity)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account_BillingCountry_Field_Changed</fullName>
        <actions>
            <name>MALatitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MALongitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the Account if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(BillingCountry)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account_BillingPostalCode_Field_Changed</fullName>
        <actions>
            <name>MALatitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MALongitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the Account if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(BillingPostalCode)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account_BillingState_Field_Changed</fullName>
        <actions>
            <name>MALatitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MALongitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the Account if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(BillingState)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account_BillingStreet_Field_Changed</fullName>
        <actions>
            <name>MALatitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MALongitudec_Purge</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Purge the MapAnything Lat/Long fields on the Account if this field changes; created by the Metadata API</description>
        <formula>ISCHANGED(BillingStreet)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Clear Latitude and Longitude %28Billing%29</fullName>
        <actions>
            <name>MA_ClearAccountLatitude</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>MA_ClearAccountLongitude</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow rule clears the latitude and longitude when the address field is updated.  This will cause this location to be geocoded again</description>
        <formula>OR( ISCHANGED(BillingStreet), ISCHANGED(BillingCity), ISCHANGED(BillingState),  ISCHANGED(BillingPostalCode), ISCHANGED(BillingCountry))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reassign Site Guest User Account Owner to Background Admin</fullName>
        <actions>
            <name>Set_Account_Owner_to_Background_Admin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>contains</operation>
            <value>Site Guest User</value>
        </criteriaItems>
        <description>Changes the Account Owner from a Site Guest User to Background Admin Robot (since portal user provisioning doesn&apos;t work for site guest user owners)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Press Outlet box</fullName>
        <actions>
            <name>Set_Press_Outlet_box</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Press Outlet</value>
        </criteriaItems>
        <description>Set Press Outlet checkbox when Press Outlet is the org type</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Account Owner to Membership</fullName>
        <actions>
            <name>Change_Owner_to_Membership</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Mike Dannenfeldt</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.OwnerId</field>
            <operation>equals</operation>
            <value>Integration Site Guest User</value>
        </criteriaItems>
        <description>When a record is created by an integration, update the owner to someone from Membership</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Caucus Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Caucus_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountCaucusFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Caucus RType</fullName>
        <actions>
            <name>kw__Set_KW_Caucus_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountCaucus</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Committee Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Committee_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountCommitteeFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Committee RType</fullName>
        <actions>
            <name>kw__Set_KW_Committee_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountCommittee</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountFormer</value>
        </criteriaItems>
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
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountMemberFormer</value>
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
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountMember</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Office Former RType</fullName>
        <actions>
            <name>kw__Set_KW_Office_Former_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountOfficerFormer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>kw__Set KW Office RType</fullName>
        <actions>
            <name>kw__Set_KW_Office_RType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.kw__KW_Template__c</field>
            <operation>equals</operation>
            <value>AccountOfficer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
