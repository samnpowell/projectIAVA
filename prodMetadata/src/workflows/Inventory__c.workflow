<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>InventoryTracking_Ea_SendLowInventoryAlert_Ops</fullName>
        <description>InventoryTracking_Ea_SendLowInventoryAlert_Ops</description>
        <protected>false</protected>
        <recipients>
            <recipient>millie@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>samanthap@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inventory_Notifications/Low_Stock_Notification</template>
    </alerts>
    <alerts>
        <fullName>InventoryTracking_Ea_SendNoInventoryAlert_Ops</fullName>
        <description>InventoryTracking_Ea_SendNoInventoryAlert_Ops</description>
        <protected>false</protected>
        <recipients>
            <recipient>millie@iava.org</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>samanthap@iava.org</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>support@iava.org</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Inventory_Notifications/No_Stock_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Inventory_isLowStock_Calculated</fullName>
        <field>isLowStock__c</field>
        <formula>IF(AND(RecordType.Name = &apos;Other Merch&apos;,
           ((Stocked_Inventory__c - Fulfilled_Requests__c)/Stocked_Inventory__c) &lt;= 0.2), 1,
    IF(AND(RecordType.Name = &apos;Apparel&apos;,
               ((Starting_Amount__c - Fulfilled_Requests__c)/Starting_Amount__c) &lt;= 0.2), 1, 0))</formula>
        <name>Inventory_isLowStock_Calculated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>InventoryTracking_Ea_SendLowInventoryAlert_Ops</fullName>
        <actions>
            <name>InventoryTracking_Ea_SendLowInventoryAlert_Ops</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>when inventory is low, send an alert to ops</description>
        <formula>isLowStock__c = 1</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>InventoryTracking_Ea_SendNoInventoryAlert_Ops</fullName>
        <actions>
            <name>InventoryTracking_Ea_SendNoInventoryAlert_Ops</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>when we are out of inventory, send an alert to ops</description>
        <formula>OR(AND(RecordType.Name = &apos;Other Merch&apos;,
             Stocked_Inventory__c - Fulfilled_Requests__c = 0,
             OR(ISCHANGED(Stocked_Inventory__c),ISCHANGED(Fulfilled_Requests__c))),
             AND(RecordType.Name = &apos;Apparel&apos;,
             (X_Small_Stocked__c + Small_stocked__c + Medium_stocked__c + Large_stocked__c + X_Large_stocked__c + XX_Large_stocked__c + XXX_Large_Stocked__c) - Fulfilled_Requests__c = 0,
             OR(ISCHANGED(X_Small_Stocked__c),ISCHANGED(Small_stocked__c),ISCHANGED(Medium_stocked__c),ISCHANGED(Large_stocked__c),ISCHANGED(X_Large_stocked__c),ISCHANGED(XX_Large_stocked__c),ISCHANGED(XXX_Large_Stocked__c),ISCHANGED(Fulfilled_Requests__c))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>InventoryTracking_Fu_SetLowInventoryFlag</fullName>
        <actions>
            <name>Inventory_isLowStock_Calculated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>when stock roll-ups change, check to see if inventory is low and toggle the low inventory flag</description>
        <formula>OR(AND(RecordType.Name = &apos;Other Merch&apos;,
             OR(ISCHANGED(Stocked_Inventory__c), ISCHANGED(Fulfilled_Requests__c))),
                   AND(RecordType.Name = &apos;Apparel&apos;,
             OR(ISCHANGED(X_Small_Stocked__c), ISCHANGED(Small_stocked__c), 
                  ISCHANGED(Medium_stocked__c), ISCHANGED(Large_stocked__c),
                  ISCHANGED(X_Large_stocked__c), ISCHANGED(XX_Large_stocked__c),
                  ISCHANGED(XXX_Large_Stocked__c), ISCHANGED(Fulfilled_Requests__c))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
