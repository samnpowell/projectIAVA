/*
 * Parse DataXML on CP Data for values to update fields on related Opportunity and Contact
 *
 * WH, Exponent Partners, 2011
 */
public class CPDonationUpdate {
	
	private static Map<String, Schema.SObjectField> contFieldMap = Schema.SObjectType.Contact.fields.getMap();
	private static Map<String, Schema.SObjectField> oppFieldMap = Schema.SObjectType.Opportunity.fields.getMap();
	
	public static void updateOpportunityAndContact(CnP_PaaS__CnPData__c cpData) {
		try {
			// look up related Opportunity and Contact through the related CP Transaction
			CnP_PaaS__CnP_Transaction__c cpTrans = [select CnP_PaaS__Contact__c from CnP_PaaS__CnP_Transaction__c where Name = :cpData.CnP_PaaS__OrderNumber__c];
			Opportunity opp = [select Id from Opportunity where CnP_PaaS__CnP_OrderNumber__c = :cpTrans.Id];
			Contact cont = [select Id from Contact where Id = :cpTrans.CnP_PaaS__Contact__c];
			
			// parse DataXML in CP Data
			XmlStreamReader xsr = new XmlStreamReader(cpData.CnP_PaaS__DataXML__c);
			Map<String, String> resultMap = parsekeys(xsr, new Set<String> {'FieldName', 'FieldValue'});
			
			// update opportunity and contact
			if (!resultMap.isEmpty()) {
				updateSObjects(cont, opp, resultMap);
			}
			
		} catch (Exception e) {
			System.debug('>>>>>>>>>> CPDataAfterInsert: failed to lookup related records: ' + e.getMessage());
		}
	}
	
	// update fields on Contact and Opportunity as given in fieldValueMap
	private static void updateSObjects(Contact c, Opportunity o, Map<String, String> fieldValueMap) {
		// array of object fields to update
		String[] fieldNames = fieldValueMap.get('FieldName').split(',', 0);
		// array of field values to use in update
		String[] fieldValues = fieldValueMap.get('FieldValue').split(',', 0);
		
		string[] sObjFieldName;
		String sObjName, fieldName;
		Integer i = 0;
		for (String fname : fieldNames) {
			// expect fieldNames in format Object.Field_API_Name
			sObjFieldName = fname.split('\\.', 0);
			if (sObjFieldName.size() == 2) {
				sObjName = sObjFieldName[0];
				fieldName = sObjFieldName[1];
				
				if (sObjName == 'Contact') {
					setSObjectField(c, contFieldMap, fieldName, fieldValues[i]);
				} else if (sObjName == 'Opportunity') {
					setSObjectField(o, oppFieldMap, fieldName, fieldValues[i]);
				} // else do nothing since it is not an expected sObject or Field
			} // else do nothing since sObjFieldName is not in correct format
			i++;
		}
		
		update c;
		update o;
	}
	
	// check that a given field exists on an sObject and is of an expected type before setting the field to that value
	//	sObj - sObject for which field is to be set
	//	sObjFieldMap - fieldMap for a given sObject
	//	fieldName - field API name
	//	fieldValue - value to set the field
	private static void setSObjectField(sObject sObj, Map<String, Schema.SObjectField> sObjFieldMap, String fieldName, String fieldValue) {
		if (sObjFieldMap.containsKey(fieldName)) {
			// check field type
			Schema.DisplayType fieldType = sObjFieldMap.get(fieldName).getDescribe().getType();
			if (fieldType == Schema.DisplayType.BOOLEAN) {
				sObj.put(sObjFieldMap.get(fieldName), fieldValue == 'True' ? true : false);
			} else if (fieldType == Schema.DisplayType.PICKLIST || fieldType == Schema.DisplayType.STRING || fieldType == Schema.DisplayType.TEXTAREA ||
						fieldType == Schema.DisplayType.EMAIL || fieldType == Schema.DisplayType.MULTIPICKLIST || fieldType == Schema.DisplayType.PHONE ||
						fieldType == Schema.DisplayType.URL) {
				sObj.put(sObjFieldMap.get(fieldName), fieldValue);
			} else if (fieldType == Schema.DisplayType.Reference || fieldType == Schema.DisplayType.ID) {
				sObj.put(sObjFieldMap.get(fieldName), (ID)fieldValue);
			} else if (fieldType == Schema.DisplayType.CURRENCY || fieldType == Schema.DisplayType.DOUBLE || fieldType == Schema.DisplayType.PERCENT) {
				sObj.put(sObjFieldMap.get(fieldName), Decimal.valueOf(fieldValue));
			//} else if (fieldType == Schema.DisplayType.INTEGER) {
				//sObj.put(sObjFieldMap.get(fieldName), Integer.valueOf(fieldValue));
			} else if (fieldType == Schema.DisplayType.DATE) {
				sObj.put(sObjFieldMap.get(fieldName), Date.valueOf(fieldValue));
			//} else if (fieldType == Schema.DisplayType.DATETIME) {
				//sObj.put(sObjFieldMap.get(fieldName), Datetime.valueOf(fieldValue));
			} // else do nothing since it is not a supported field type
		} // else do nothing since it is not an expected sObject or Field
	}
	
	// parse XML for given set of keys
	// return a map of {key => comma-separated values}
	private static Map<String, String> parsekeys(XmlStreamReader reader, Set<String> keys) {
		String key;
		Map<String, String> resultMap = new Map<String, String>();
		while (reader.hasNext()) {
			if (reader.getEventType() == XmlTag.START_ELEMENT) {
				key = reader.getLocalName();
				if (keys.contains(key)) {
					while (reader.hasNext()) {
						if (reader.getEventType() == XmlTag.END_ELEMENT) {
							break;
						} else if (reader.getEventType() == XmlTag.CHARACTERS) {
							resultMap.put(key, (resultMap.get(key)==null ? '' : (resultMap.get(key) + ',')) + reader.getText());
						}
						reader.next();
					}
				}
			}
			reader.next();
		}
		return resultMap;
	}
	
	////////// Tests //////////
	
	static testMethod void testUpdateOpportunityAndContact() {
		Account a = new Account(Name = 'Unit Test Org');
		insert a;
		
		Contact c = new Contact(AccountId = a.Id, FirstName = 'Unit', LastName = 'Test Contact', Email = 'unitTestContact@test.org');
		insert c;
		
		CnP_PaaS__CnP_Transaction__c cpTrans = new CnP_PaaS__CnP_Transaction__c(
										Name='T123456789',
										CnP_PaaS__Account__c = a.Id,
										CnP_PaaS__Contact__c = c.Id,
										CnP_PaaS__Email__c = 'unitTestContact@test.org',
										CnP_PaaS__TotalDue__c = 100,
										CnP_PaaS__TransactionDate__c = System.today(),
										CnP_PaaS__TransactionTimeZone__c = System.now()
									);
		insert cpTrans;
		
		// Amount is needed in an Opp after insert trigger written by Etherios
		Opportunity o = new Opportunity(AccountId = a.Id, CnP_PaaS__CnP_OrderNumber__c = cpTrans.Id, Name = 'Unit Test Opp', StageName = 'Posted', CloseDate = System.today(), Amount = 0);
		insert o;
		
		CnP_PaaS__CnPData__c cpData = new CnP_PaaS__CnPData__c(
										CnP_PaaS__OrderNumber__c = cpTrans.Name,
										CnP_PaaS__DataXML__c = '<?xml version="1.0" encoding="UTF-8"?>' +
																'<CnPTransactionData><Version>40</Version>' +
																//'<Application><ID>CnP_FaaS</ID>' +
																//'<Name>CnP_FaaS</Name>' +
																//'<Version>FaaS.20131015.001.035.001.001.035</Version>' +
																//'</Application>' +
																//'<Patron>' +
																//'<BillingInformation>' +
																//'<BillingFirstName>Test</BillingFirstName>' +
																//'<BillingLastName>Howard</BillingLastName>' +
																//'<BillingEmail>testemail@test.net</BillingEmail>' +
																//'</BillingInformation>' +
																//'<BillingAddress><BillingAddress1>1 1st St</BillingAddress1>' +
																//'<BillingCity>New York</BillingCity>' +
																//'<BillingStateProvince>NY</BillingStateProvince>' +
																//'<BillingPostalCode>10012</BillingPostalCode>' +
																//'<BillingCountryName>United States of America</BillingCountryName>' +
																//'</BillingAddress>' +			
																//'</Patron>' +
																//'<TransactionDetail>' +
																//'<OrderNumber>' + cpTrans.Name + '</OrderNumber>' +
																//'<TransactionID>2105963</TransactionID>' +
																//'<OrderMode>Live</OrderMode>' +
																//'<Tracker>MainPage</Tracker>' +
																//'<Campaign></Campaign>' +
																//'<TransactionType>Live</TransactionType>' +
																//'<OrganizationID>19484</OrganizationID>' +
																//'<OrganizationName>Iraq and Afghanistan Veterans of America</OrganizationName>' +
																//'<CurrencyCode>840</CurrencyCode>' +
																//'<AuthorizationCode>247451</AuthorizationCode>' +
																//'<WindowName>Donate to IAVA</WindowName>' +
																//'<WindowId>47465</WindowId>' +
																//'<GatewayTransactionNumber>523455881</GatewayTransactionNumber>' +
																//'<TotalCharge>100.00</TotalCharge>' +
																//'<UrlReferrer>https://secure.iava.org/donate-now</UrlReferrer>' +
																//'<VaultGUID>84587b8b-98b1-4204-a303-1524beaf5231</VaultGUID>' +
																//'<TransactionResult>Authorized</TransactionResult>' +
																//'<PaymentMethod>' +
																//'<PaymentType>Credit Card</PaymentType>' +
																//'</PaymentMethod>' +
																//'</TransactionDetail>' +
																'<CustomFieldList>' +
																'<CustomField>' +
																'<FieldName>Opportunity.Payment_Method__c</FieldName>' +
																'<FieldValue>Credit Card (One-Time)</FieldValue>' +
																'</CustomField>' +
																'<CustomField>' +
																'<FieldName>Contact.Veteran_Member__c</FieldName>' +
																'<FieldValue>True</FieldValue>' +
																'</CustomField>' +
																'</CustomFieldList>' +
																'<OrderItemList>' +
																'<OrderItem>' +
																'<ItemID>1</ItemID>' +
																//'<ItemName>Main Donation Page</ItemName>' +
																//'<Quantity>1</Quantity>' +
																//'<UnitPriceCharge>100</UnitPriceCharge>' +
																//'<UnitPriceDue>100</UnitPriceDue>' +
																//'<UnitDeductibleCharge>100</UnitDeductibleCharge>' +
																//'<UnitDeductibleDue>100</UnitDeductibleDue>' +
																//'<TaxAmountCharge>0</TaxAmountCharge>' +
																//'<TaxAmountDue>0</TaxAmountDue>' +
																//'<DiscountCharge>0</DiscountCharge>' +
																//'<DiscountDue>0</DiscountDue>' +
																//'<SKU></SKU>' +
																//'<CampaignName>Main Donation Page</CampaignName>' +
																'</OrderItem>' +
																'</OrderItemList>' +
																'</CnPTransactionData>' +
																''
									);
		insert cpData;
		
		// opportunity and contact updated by CP Data after insert trigger
		System.assertEquals('Credit Card (One-Time)', [select Payment_Method__c from Opportunity where Id = :o.Id].Payment_Method__c);
		System.assertEquals(true, [select Veteran_Member__c from Contact where Id = :c.Id].Veteran_Member__c);
	}
	
	static testMethod void testUpdateSObjects() {
		Account a = new Account(Name = 'Unit Test Org');
		insert a;
		
		Contact c = new Contact(AccountId = a.Id, FirstName = 'Unit', LastName = 'Test Contact');
		insert c;
		
		// Amount is needed in an Opp after insert trigger written by Etherios
		Opportunity o = new Opportunity(AccountId = a.Id, Name = 'Unit Test Opp', StageName = 'Posted', CloseDate = System.today(), Amount = 0);
		insert o;
		
		// fields of supported types that exist on the objects are updated correctly
		Campaign cam = new Campaign(Name = 'Test Campaign');
		insert cam;
		Id campaignId = cam.Id;
		
		Map<String, String> fieldValueMap = new Map<String, String> {
					'FieldName' => 'Opportunity.Amount,Opportunity.CampaignId,Opportunity.Check_Date__c,Opportunity.Payment_Method__c,Contact.Veteran_Member__c', 
					'FieldValue' => '100.00,' + campaignId + ',' + String.valueOf(System.today()) + ',Credit Card (One-Time),True'
		};
		
		updateSObjects(c, o, fieldValueMap);
		
		Opportunity updatedOpp = [select Amount, CampaignId, Check_Date__c, Payment_Method__c from Opportunity where Id = :o.Id];
		
		System.assertEquals(100, updatedOpp.Amount);
		System.assertEquals(campaignId, updatedOpp.CampaignId);
		System.assertEquals(System.today(), updatedOpp.Check_Date__c);
		System.assertEquals('Credit Card (One-Time)', updatedOpp.Payment_Method__c);
		System.assertEquals(true, [select Veteran_Member__c from Contact where Id = :c.Id].Veteran_Member__c);
		
		// fields that do not exist in sObject cause no harm
		fieldValueMap = new Map<String, String> {
					'FieldName' => 'Opportunity.Bogus Field,Contact.Field_that_does_not_exist__c', 
					'FieldValue' => 'Credit Card (One-Time),True'
		};
		
		try {
			updateSObjects(c, o, fieldValueMap);
		} catch (Exception e) {
			System.assert(false, 'fields that do not exist on Contact or Opportunity are not handled correctly');
		}
		
		// fields that are of unsupported types cause no harm
		fieldValueMap = new Map<String, String> {
					'FieldName' => 'Contact.LastCURequestDate,Contact.Veteran_of_Other_Era__c', 
					'FieldValue' => 'now,True'
		};
		
		try {
			updateSObjects(c, o, fieldValueMap);
			System.assertEquals(null, [select LastCURequestDate from Contact where Id = :c.Id].LastCURequestDate);
			System.assertEquals(true, [select Veteran_of_Other_Era__c from Contact where Id = :c.Id].Veteran_of_Other_Era__c);
		} catch (Exception e) {
			System.assert(false, 'fields that do not exist on Contact or Opportunity are not handled correctly');
		}
		
		// fields that are in wrong format cause no harm
		fieldValueMap = new Map<String, String> {
					'FieldName' => 'Opportunity.Bogus.Field,Field_that_does_not_exist__c', 
					'FieldValue' => 'Credit Card (One-Time),True'
		};
		
		try {
			updateSObjects(c, o, fieldValueMap);
		} catch (Exception e) {
			System.assert(false, 'fields in wrong format are not handled correctly');
		}
		
	}
	
	static testMethod void testParsekeys() {
		String xmlString = '<?xml version="1.0" encoding="UTF-8"?>' +
							'<CnPTransactionData><Version>40</Version>' +
							'<Application><ID>CnP_FaaS</ID>' +
							'<Name>CnP_FaaS</Name>' +
							'<Version>FaaS.1.20111207.001.024.000.001.021</Version>' +
							'</Application>' +
							'<Patron>' +
							'<BillingInformation><BillingFirstName>Sam</BillingFirstName>' +
							'<BillingMI></BillingMI>' +
							'<BillingLastName>Dorman</BillingLastName>' +
							'<BillingEmail>samdorman@gmail.com</BillingEmail>' +
							'<BillingPhone>123-123-1234</BillingPhone>' +
							'</BillingInformation>' +
							'<BillingAddress><BillingAddress1>2803 Golden Gate Ave</BillingAddress1>' +
							'<BillingAddress2></BillingAddress2>' +
							'<BillingAddress3></BillingAddress3>' +
							'<BillingCity>San Francisco</BillingCity>' +
							'<BillingStateProvince>California</BillingStateProvince>' +
							'<BillingPostalCode>94118</BillingPostalCode>' +
							'<BillingCountryName>United States of America</BillingCountryName>' +
							'</BillingAddress>' +
							'</Patron>' +
							'<TransactionDetail>' +
							'<OrderNumber>1112161741584111</OrderNumber>' +
							'<TransactionID>971934</TransactionID>' +
							'<OrderMode>Test</OrderMode>' +
							'<Tracker>MainPage</Tracker>' +
							'<Campaign></Campaign>' +
							'<TransactionType>Test</TransactionType>' +
							'<OrganizationID>19606</OrganizationID>' +
							'<OrganizationName>Test: Iraq and Afghanistan Veterans of America</OrganizationName>' +
							'<CurrencyCode>840</CurrencyCode>' +
							'<AuthorizationCode>10b42d</AuthorizationCode>' +
							'<WindowName>Test: Iraq and Afghanistan Veterans of America</WindowName>' +
							'<WindowId>48486</WindowId>' +
							'<GatewayTransactionNumber>72a9b202-ebdf-4481-b638-e19d114046f5</GatewayTransactionNumber>' +
							'<TotalCharge>25.00</TotalCharge>' +
							'<TotalDue>25.00</TotalDue>' +
							'<DeductibleCharge>25.00</DeductibleCharge>' +
							'<DeductibleDue>25.00</DeductibleDue>' +
							'<DiscountDue>0.00</DiscountDue>' +
							'<DiscountCharge>0.00</DiscountCharge>' +
							'<TaxAmountDue>0.00</TaxAmountDue>' +
							'<TaxAmountCharge>0.00</TaxAmountCharge>' +
							'<SurCharge>0.00</SurCharge>' +
							'<ChargAmount>0.98</ChargAmount>' +
							'<CouponCode></CouponCode>' +
							'<TransactionDiscountDue>0.00</TransactionDiscountDue>' +
							'<TransactionDiscountCharge>0.00</TransactionDiscountCharge>' +
							'<TransactionTaxDue>0.00</TransactionTaxDue>' +
							'<TransactionTaxCharge>0.00</TransactionTaxCharge>' +
							'<TransactionDate>2011-12-16 17:04:00</TransactionDate>' +
							'<TransactionTimeZone>2011-12-16 17:04:00</TransactionTimeZone>' +
							'<UrlReferrer>https://secure.iava.org/dev2-sandbox-donate-page</UrlReferrer>' +
							'<VaultGUID>80152283-aedf-4ce2-b458-9f4b043408ca</VaultGUID>' +
							'<TransactionResult>Authorized</TransactionResult>' +
							'<PaymentMethod>' +
							'<PaymentType>Credit Card</PaymentType>' +
							'<CreditCard>' +
							'<NameOnCard>Sam Dorman</NameOnCard>' +
							'<CardNumber>41111111</CardNumber>' +
							'<CardName>VISA</CardName>' +
							'<ExpirationDate>1702 </ExpirationDate>' +
							'</CreditCard>' +
							'</PaymentMethod>' +
							'</TransactionDetail>' +
							'<CustomFieldList>' +
							'<CustomField>' +
							'<FieldName>Veteran Status</FieldName>' +
							'<FieldValue>Civilian Supporter</FieldValue>' +
							'</CustomField>' +
							'<CustomField>' +
							'<FieldName>Opportunity.Payment_Method__c</FieldName>' +
							'<FieldValue>Credit Card (one-time)</FieldValue>' +
							'</CustomField>' +
							'<CustomField>' +
							'<FieldName>Opportunity.Campaign</FieldName>' +
							'<FieldValue>701M0000000Dm5A</FieldValue>' +
							'</CustomField>' +
							'<CustomField>' +
							'<FieldName>Contact.Veteran_Member__c</FieldName>' +
							'<FieldValue>True</FieldValue>' +
							'</CustomField>' +
							'<CustomField>' +
							'<FieldName>Non-SFDC value</FieldName>' +
							'<FieldValue>something else</FieldValue>' +
							'</CustomField>' +
							'<CustomField>' +
							'<FieldName>Contact.Veteran_of_Other_Era__c</FieldName>' +
							'<FieldValue>False</FieldValue>' +
							'</CustomField>' +
							'<CustomField>' +
							'<FieldName>Opportunity.c3_c4__c</FieldName>' +
							'<FieldValue>c3</FieldValue>' +
							'</CustomField>' +
							'<CustomField>' +
							'<FieldName>Opportunity.Type</FieldName>' +
							'<FieldValue>Individual Donation</FieldValue>' +
							'</CustomField>' +
							'<CustomField>' +
							'<FieldName>In honor of</FieldName>' +
							'<FieldValue>Someone</FieldValue>' +
							'</CustomField>' +
							'</CustomFieldList>' +
							'<OrderItemList>' +
							'<OrderItem>' +
							'<ItemID>1</ItemID>' +
							'<ItemName>IAVA Donation</ItemName>' +
							'<Quantity>1</Quantity>' +
							'<UnitPriceCharge>25</UnitPriceCharge>' +
							'<UnitPriceDue>25</UnitPriceDue>' +
							'<UnitDeductibleCharge>25</UnitDeductibleCharge>' +
							'<UnitDeductibleDue>25</UnitDeductibleDue>' +
							'<TaxAmountCharge>0</TaxAmountCharge>' +
							'<TaxAmountDue>0</TaxAmountDue>' +
							'<DiscountCharge>0</DiscountCharge>' +
							'<DiscountDue>0</DiscountDue>' +
							'<SKU></SKU>' +
							'</OrderItem>' +
							'</OrderItemList>' +
							'</CnPTransactionData>';
		XmlStreamReader xsr = new XmlStreamReader(xmlString);
		
		Map<String, String> resultMap = parsekeys(xsr, new Set<String> {'FieldName', 'FieldValue'});
		
		System.assertNotEquals(null, resultMap.get('FieldName'));
		System.assertNotEquals(null, resultMap.get('FieldValue'));
		
		String[] fieldNames = resultMap.get('FieldName').split(',', 0);
		
		System.assertEquals(9, fieldNames.size());
		System.assertEquals('Veteran Status', fieldNames[0]);
		System.assertEquals('Opportunity.Payment_Method__c', fieldNames[1]);
		System.assertEquals('Opportunity.Campaign', fieldNames[2]);
		System.assertEquals('Contact.Veteran_Member__c', fieldNames[3]);
		System.assertEquals('Non-SFDC value', fieldNames[4]);
		System.assertEquals('Contact.Veteran_of_Other_Era__c', fieldNames[5]);
		System.assertEquals('Opportunity.c3_c4__c', fieldNames[6]);
		System.assertEquals('Opportunity.Type', fieldNames[7]);
		System.assertEquals('In honor of', fieldNames[8]);
		
		String[] fieldValues = resultMap.get('FieldValue').split(',', 0);
		
		System.assertEquals(9, fieldValues.size());
		System.assertEquals('Civilian Supporter', fieldValues[0]);
		System.assertEquals('Credit Card (one-time)', fieldValues[1]);
		System.assertEquals('701M0000000Dm5A', fieldValues[2]);
		System.assertEquals('True', fieldValues[3]);
		System.assertEquals('something else', fieldValues[4]);
		System.assertEquals('False', fieldValues[5]);
		System.assertEquals('c3', fieldValues[6]);
		System.assertEquals('Individual Donation', fieldValues[7]);
		System.assertEquals('Someone', fieldValues[8]);
	}
	
}