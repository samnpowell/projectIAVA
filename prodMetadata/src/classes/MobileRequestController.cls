/*
Copyright (c) 2010 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Nick Koopman, nkoopman@etherios.com
*/
public class MobileRequestController {

	public String JSONr1 {get; set;}	// JSON String for request1 - Member Validation 
	public String JSONr2 {get; set;}	// JSON String for request2 - Request Give List
	public String JSONr3 {get; set;}	// JSON String for request3 - Request Give Details
	public String JSONr4 {get; set;}	// JSON String for request4 - Request Reward
	public String JSONr5 {get; set;}	// JSON String for request5 - Device Registration

	public void buildMemberValidationResponse(Map<String, String> request)
	{
		String MemberID = request.get('MemberID');
		String eMail = request.get('eMail');
		String DeviceToken = request.get('DeviceToken');
		String status = 'Invalid MemberID / eMail combination.';
		Contact c = ContactUtilities.ConfirmedContactInfo(MemberID, eMail, DeviceToken);
		if (c != null)
			status = 'Valid Member';
		JSONr1 = '';
		JSONr1 += '{ "MemberValidation": {\n\r';
		JSONr1 += '       "status": "' + status + '",\n\r';
		JSONr1 += '       "member": {\n\r';
		JSONr1 += '            "field": [\n\r';
		JSONr1 += '                    ' + JSON.SoutputField('MemberID', MemberID) + ',\n\r';
        JSONr1 += '                    ' + JSON.SoutputField('eMail', eMail) + ',\n\r';
        if (c != null)
        {
        	JSONr1 += '                    ' + JSON.SoutputField('Name', c.Name) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('PrimaryEmail', c.Email) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('HomeEmail', c.npe01__HomeEmail__c) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('AlternateEmail', c.npe01__AlternateEmail__c) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('PrimaryPhone', c.Phone) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('HomePhone', c.HomePhone) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('MobilePhone', c.MobilePhone) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('WorkPhone', c.npe01__WorkPhone__c) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('MailingStreet', c.MailingStreet) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('MailingCity', c.MailingCity) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('MailingState', c.MailingState) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('MailingPostalCode', c.MailingPostalCode) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('DriversLicense', c.Drivers_License__c) + ',\n\r';
        	JSONr1 += '                    ' + JSON.SoutputField('ShirtSize', c.Shirt_size__c) + '\n\r';
        }
		JSONr1 += '             ]\n\r';
		JSONr1 += '}      }      }';
		System.Debug(JSONr1);
	}
	
	public void buildGiveListResponse(Map<String, String> request)
	{
		System.Debug('Building JSON response for: ' + request);
		String status = 'No data returned.';
		List<RewardUtilities.Reward> Rewards = RewardUtilities.sampleRewards(request);
		RewardUtilities.updateRegisteredDevice(request);
		if ((Rewards != null) && (Rewards.size() > 0))
			status = Rewards.size() + ' Reward(s) returned.';	
		JSONr2 = '';
		JSONr2 += '{ "RequestGiveList": {\n\r';
		JSONr2 += '      "ZipCode": "' + request.get('ZipCode') + '",\n\r';
		JSONr2 += '     "Latitude": "' + request.get('Latitude') + '",\n\r';
		JSONr2 += '    "Longitude": "' + request.get('Longitude') + '",\n\r';
		JSONr2 += '     "Distance": "' + request.get('Distance') + '",\n\r';
		JSONr2 += '  "DeviceToken": "' + request.get('DeviceToken') + '",\n\r';
		JSONr2 += '       "status": "' + status + '"';
		if ((Rewards != null) && (Rewards.size() > 0))
		{
			Integer i = 0;
			for (RewardUtilities.Reward Give : Rewards)
			{
				if (i++ == 0) JSONr2 += ',\n\r    "Reward": [\n\r'; else JSONr2 += ',\n\r';
				JSONr2 += '            {"field": [\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('GiveInstanceID', Give.GiveInstanceID) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('DateFrom', Give.DateFrom) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('DateTo', Give.DateTo) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('EndDate', Give.EndDate) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('EndTime', Give.EndTime) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('NumInstances', Give.NumInstances) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('NumRemaining', Give.NumRemaining) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('NumUnits', Give.NumUnits) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('StartDate', Give.StartDate) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('StartTime', Give.StartTime) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('InstanceStatus', Give.InstanceStatus) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('YearEndDate', Give.YearEndDate) + ',\n\r';
				//JSONr2 += '                    ' + JSON.SoutputField('YearStartDate', Give.YearStartDate) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('GiveID', Give.GiveID) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('Title', Give.Title) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('Available', Give.Available) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('Category', Give.Category) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('Deadline', Give.Deadline) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('Disclaimer', Give.Disclaimer) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('Eligibility', Give.Eligibility) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('Fulfillment', Give.Fulfillment) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('Highlight', Give.Highlight) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('LocationByStreet', Give.LocationByStreet) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('LocationByState', Give.LocationByState) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('LocationByZip', Give.LocationByZip) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('LocationFormula', Give.LocationFormula) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('LocationDescription', Give.LocationDescription) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('CityST', Give.CityST) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('MaximumUnits', Give.MaximumUnits) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('QtyNonSelect', Give.QtyNonSelect) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('MoreInfoLink', Give.MoreInfoLink) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('MustBe21', Give.MustBe21) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('NationalGive', Give.NationalGive) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('SpecialResponse', Give.SpecialResponse) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('ShortDescription', Give.ShortDescription) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('SpecialInstructions', Give.SpecialInstructions) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('GiveStatus', Give.GiveStatus) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('SubCategory', Give.SubCategory) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('RewardType', Give.RewardType) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('GiveDateDisplay', Give.GiveDateDisplay) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('FeaturedPartner', Give.FeaturedPartner) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('PartnerOnHome', Give.PartnerOnHome) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('PartnerOnSite', Give.PartnerOnSite) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('BriefDescription', Give.BriefDescription) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('DetailDescription', Give.DetailDescription) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('PublicName', Give.PublicName) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('LogoBlockSortOrder', Give.LogoBlockSortOrder) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('PartnerSortOrder', Give.PartnerSortOrder) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('Stage', Give.Stage) + ',\n\r';
				JSONr2 += '                    ' + JSON.SoutputField('PartnerImage', Give.PartnerImage) + ',\n\r';
			 	JSONr2 += '                    ' + JSON.SoutputField('Image', Give.Image) + '\n\r';
			 	JSONr2 += '                    ' + JSON.SoutputField('Latitude', Give.Latitude) + '\n\r';
			 	JSONr2 += '                    ' + JSON.SoutputField('Longitude', Give.Longitude) + '\n\r';
			 	JSONr2 += '                    ' + JSON.SoutputField('Distance', Give.Distance) + '\n\r';
				JSONr2 += '                       ]\n\r';
				JSONr2 += '            }';
			}
			JSONr2 += '\n\r          ]';
		}
		JSONr2 += '\n\r}   }';
		System.Debug(JSONr2);
	}

	public void buildGiveDetailResponse(Map<String, String> request)
	{
		String GiveID = request.get('GiveID');
		List<RewardUtilities.Reward> Rewards = null;
		if (GiveID != null) Rewards = RewardUtilities.RewardDetails(GiveID);
		String status = 'Invalid GiveID.';
		if ((Rewards != null) && (Rewards.size() > 0))
			status = Rewards.size() + ' Instance(s) returned.';	
		JSONr3 = '';
		JSONr3 += '{ "RequestGiveInstances":\n\r';
		JSONr3 += '    { "status": "' + status + '",\n\r';
		JSONr3 += '      "GiveID": "' + GiveID + '"';
		if ((Rewards != null) && (Rewards.size() > 0))
		{
			Integer i = 0;
			for (RewardUtilities.Reward Give : Rewards)
			{
				if (i++ == 0) JSONr3 += ',\n\r    "Instance": [\n\r'; else JSONr3 += ',\n\r';
				JSONr3 += '            { "field": [\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('GiveInstanceID', Give.GiveInstanceID) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('DateFrom', Give.DateFrom) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('DateTo', Give.DateTo) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('EndDate', Give.EndDate) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('EndTime', Give.EndTime) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('NumInstances', Give.NumInstances) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('NumRemaining', Give.NumRemaining) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('NumUnits', Give.NumUnits) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('StartDate', Give.StartDate) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('StartTime', Give.StartTime) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('InstanceStatus', Give.InstanceStatus) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('YearEndDate', Give.YearEndDate) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('YearStartDate', Give.YearStartDate) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('CollectGuestDLNum', Give.CollectGuestDLNum) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('CollectGuestDOB', Give.CollectGuestDOB) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('CollectGuestName', Give.CollectGuestName) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('CollectGuestShirtSize', Give.CollectGuestShirtSize) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('CollectMemberDLNum', Give.CollectMemberDLNum) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('CollectMemberDOB', Give.CollectMemberDOB) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('CollectMemberShirtSize', Give.CollectMemberShirtSize) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('CollectSpecialResponse2', Give.CollectSpecialResponse2) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('CollectSpecialResponse3', Give.CollectSpecialResponse3) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('CollectSpecialResponse4', Give.CollectSpecialResponse4) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('CollectSpecialResponse5', Give.CollectSpecialResponse5) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('MustBe21ForGuest', Give.MustBe21ForGuest) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('SpecialInstructions2', Give.SpecialInstructions2) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('SpecialInstructions3', Give.SpecialInstructions3) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('SpecialInstructions4', Give.SpecialInstructions4) + ',\n\r';
				JSONr3 += '                    ' + JSON.SoutputField('SpecialInstructions5', Give.SpecialInstructions5) + '\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('GiveID', Give.GiveID) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('Title', Give.Title) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('Available', Give.Available) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('Category', Give.Category) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('Deadline', Give.Deadline) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('Disclaimer', Give.Disclaimer) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('Eligibility', Give.Eligibility) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('Fulfillment', Give.Fulfillment) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('Highlight', Give.Highlight) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('LocationByStreet', Give.LocationByStreet) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('LocationByState', Give.LocationByState) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('LocationByZip', Give.LocationByZip) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('LocationFormula', Give.LocationFormula) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('LocationDescription', Give.LocationDescription) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('MaximumUnits', Give.MaximumUnits) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('QtyNonSelect', Give.QtyNonSelect) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('MoreInfoLink', Give.MoreInfoLink) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('MustBe21', Give.MustBe21) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('NationalGive', Give.NationalGive) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('SpecialResponse', Give.SpecialResponse) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('ShortDescription', Give.ShortDescription) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('SpecialInstructions', Give.SpecialInstructions) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('GiveStatus', Give.GiveStatus) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('SubCategory', Give.SubCategory) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('RewardType', Give.RewardType) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('GiveDateDisplay', Give.GiveDateDisplay) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('FeaturedPartner', Give.FeaturedPartner) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('PartnerOnHome', Give.PartnerOnHome) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('PartnerOnSite', Give.PartnerOnSite) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('BriefDescription', Give.BriefDescription) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('DetailDescription', Give.DetailDescription) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('PublicName', Give.PublicName) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('LogoBlockSortOrder', Give.LogoBlockSortOrder) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('PartnerSortOrder', Give.PartnerSortOrder) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('Stage', Give.Stage) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('PartnerImage', Give.PartnerImage) + ',\n\r';
				//JSONr3 += '                    ' + JSON.SoutputField('Image', Give.Image) + '\n\r';
				JSONr3 += '                       ]\n\r';
				JSONr3 += '            }';
			}
			JSONr3 += '\n\r          ]';
		}
		JSONr3 += '\n\r}   }';
		System.Debug(JSONr3);
	}
	
	public void buildRewardResponse(Map<String, String> request)
	{
		Map<String, String> response = RewardUtilities.RequestReward(request);
		JSONr4 = '';
		JSONr4 += '{ "RequestReward":\n\r';
		JSONr4 += JSON.outputFlatMap(response);
		JSONr4 += '\n\r}';
		System.Debug(JSONr4);
	}
	
	public void buildDeviceRegistrationResponse(Map<String, String> request)
	{
		Map<String, String> response = DeviceRegistrationUtilities.DeviceRegistration(request);
		JSONr5 = '';
		JSONr5 += '{ "DeviceRegistration":\n\r';
		JSONr5 += JSON.outputFlatMap(response);
		JSONr5 += '\n\r}';
		System.Debug(JSONr5);
	}

	private static Map<String, String> ParameterMap(List<String> ParameterList)
	{
		Map<String, String> IncomingMap = new Map<String, String>();
        for (String parm : ParameterList)
        {
        	String input = ApexPages.currentPage().getParameters().get(parm);
        	System.debug('MobileRequestController: ' + parm + ': ' + input);
        	IncomingMap.put(parm,input);
        }
        return IncomingMap;
	}
	
	public PageReference handleMemberValidationRequest()
	{
        System.debug('MobileRequestController: MemberValidation');
        System.debug('MobileRequestController: ' + ApexPages.currentPage().getParameters());
		List<String> ParameterList = new List<String>();
		ParameterList.add('MemberID');
		ParameterList.add('eMail');
		ParameterList.add('DeviceToken');
		buildMemberValidationResponse(ParameterMap(ParameterList));
		return null;
	}

	public PageReference handleGiveListRequest()
	{
        System.debug('MobileRequestController: RequestGiveList');
        System.debug('MobileRequestController: ' + ApexPages.currentPage().getParameters());
		List<String> ParameterList = new List<String>();
		ParameterList.add('ZipCode');
		ParameterList.add('Latitude');
		ParameterList.add('Longitude');
		ParameterList.add('Distance');
		ParameterList.add('DeviceToken');
		buildGiveListResponse(ParameterMap(ParameterList));
		return null;
	}
	
	public PageReference handleGiveDetailRequest()
	{
        System.debug('MobileRequestController: RequestGiveDetail');
        System.debug('MobileRequestController: ' + ApexPages.currentPage().getParameters());
		List<String> ParameterList = new List<String>();
		ParameterList.add('GiveID');
		buildGiveDetailResponse(ParameterMap(ParameterList));
		return null;
	}
	
	public PageReference handleGiveInstanceRequest()
	{
        System.debug('MobileRequestController: RequestGiveInstances');
        System.debug('MobileRequestController: ' + ApexPages.currentPage().getParameters());
		List<String> ParameterList = new List<String>();
		ParameterList.add('GiveID');
		buildGiveDetailResponse(ParameterMap(ParameterList));
		return null;
	}
	
	public PageReference handleRewardRequest()
	{
        System.debug('MobileRequestController: RequestReward');
        System.debug('MobileRequestController: ' + ApexPages.currentPage().getParameters());
		List<String> ParameterList = new List<String>();
		ParameterList.add('MemberID');
		ParameterList.add('eMail');
		ParameterList.add('GiveInstanceID');
		ParameterList.add('SpecialResponse');
		ParameterList.add('TicketValue');
		ParameterList.add('AddressLine1');
		ParameterList.add('AddressLine2');
		ParameterList.add('City');
		ParameterList.add('State');
		ParameterList.add('Zip');
		ParameterList.add('Phone');
		ParameterList.add('NewEmailAddress');
		ParameterList.add('MakeAddressPrimary');
		ParameterList.add('MakeEmailPrimary');
		ParameterList.add('MakePhonePrimary');
		ParameterList.add('Confirmed21');
		ParameterList.add('DeviceType');
		ParameterList.add('DeviceModel');
		ParameterList.add('DeviceOS');
		ParameterList.add('AppVersion');
		buildRewardResponse(ParameterMap(ParameterList));
		return null;
	}
	
	public PageReference handleDeviceRegistration()
	{
        System.debug('MobileRequestController: DeviceRegistration');
        System.debug('MobileRequestController: ' + ApexPages.currentPage().getParameters());
		List<String> ParameterList = new List<String>();
		ParameterList.add('DeviceId');
		ParameterList.add('DeviceModel');
		ParameterList.add('DeviceOS');
		ParameterList.add('DeviceToken');
		ParameterList.add('AppVersion');
		ParameterList.add('Action');
		ParameterList.add('Messages');
		buildDeviceRegistrationResponse(ParameterMap(ParameterList));
		return null;
	}

}