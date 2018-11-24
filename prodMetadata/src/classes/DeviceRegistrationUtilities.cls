public with sharing class DeviceRegistrationUtilities {
	public static Map<String, String> DeviceRegistration(Map<String, String> request){
		Map<String, String> response = new Map<String, String>();
		
		Boolean isValidCall = true;
		
		String DeviceId = '';
		String DeviceModel = '';
		String DeviceOS = '';
		String DeviceToken = '';
		String AppVersion = '';
		String Action = '';
		String Messages = '';
		Boolean Active = false;
		
		try{
			// Is user has not permissions
			if(	!Schema.sObjectType.Registered_Device__c.isAccessible() || 
				!Schema.sObjectType.Registered_Device__c.isCreateable() ||
				!Schema.sObjectType.Registered_Device__c.isUpdateable()){
				throw new RegisteredDevicePermissionsException('Insufficient permissions');
			}
			
			// Load the parameters from the URL
			if(DeviceRegistrationUtilities.isEmptyValue(request.get('DeviceId'))){
				throw new DeviceRegistrationException('The DeviceId is required.');
			}else if(request.get('DeviceId').length() != 40 ){
				throw new DeviceRegistrationException('The DeviceId has to be 40 characters long.');
			}else {
				DeviceId = request.get('DeviceId');
			}
			
			if(DeviceRegistrationUtilities.isEmptyValue(request.get('DeviceModel'))){
				throw new DeviceRegistrationException('The DeviceModel is required.');
			}else {
				DeviceModel = request.get('DeviceModel');
			}
			
			if(DeviceRegistrationUtilities.isEmptyValue(request.get('DeviceOS'))){
				throw new DeviceRegistrationException('The DeviceOS is required.');
			}else {
				DeviceOS = request.get('DeviceOS');
			}
			
			Pattern hexPattern = Pattern.compile('[0-9a-fA-F]{64}');
			if(!DeviceRegistrationUtilities.isEmptyValue(request.get('DeviceToken'))){
				if(hexPattern.matcher(request.get('DeviceToken')).matches()) {
					DeviceToken = request.get('DeviceToken');
				}else {
					throw new DeviceRegistrationException('The DeviceToken must be an hexadecimal number of 64 characters.');
				}	
			}else {
				DeviceToken = '';
			}
			
			if(DeviceRegistrationUtilities.isEmptyValue(request.get('AppVersion'))){
				throw new DeviceRegistrationException('The AppVersion is required.');
			}else {
				AppVersion = request.get('AppVersion');
			}
			
			if(DeviceRegistrationUtilities.isEmptyValue(request.get('Action'))){
				throw new DeviceRegistrationException('The Action is required.');
			}else if(request.get('Action') == 'Register' || request.get('Action') == 'UnRegister') {
				Action = request.get('Action');
				if(request.get('Action') == 'Register'){
					Active = true;
				}else {
					Active = false;
				}
			}else {
				throw new DeviceRegistrationException('The Action is invalid. (Only Register or UnRegister)');
			}
			
			if(request.get('Messages') == 'true' || request.get('Messages') == 'false'){
				Messages = request.get('Messages');
			}else if(request.get('Messages') == null) {
				Messages = 'true';
			}else {
				throw new DeviceRegistrationException('The Messages is invalid. (Only true or false, default true)');
			}
			
			// If no exception thrown, validate the call
			isValidCall = true;
		}catch(RegisteredDevicePermissionsException e){
			isValidCall = false;
			response.put('status','Error');
			response.put('message',e.getMessage());
			System.debug(e.getMessage());
		}catch(DeviceRegistrationException e){
			// If the call is invalid, put the error and message in the response json.
			isValidCall = false;
			response.put('status','Error');
			response.put('message',e.getMessage());
			System.debug(e.getMessage());
		}
		
		if(isValidCall){
			// If the call is valid, try to update/insert the device
			// The device object
			Registered_Device__c device;
			String DeviceName = DeviceRegistrationUtilities.getDeviceName(DeviceModel, DeviceToken);
			try{
				// Try to load the device from the database
				device = [	SELECT 	Name, 
									Active__c, 
									App_Version__c,
									Device_Model__c,
									Device_OS__c,
									Device_Token__c,
									Device_Id__c,
									New_Rewards__c, 
									Receive_Messages__c,
									Registration_Timestamp__c 
							FROM	Registered_Device__c
							WHERE	Device_Id__c =: DeviceId
							limit	1];
			}catch(QueryException e){
				// If not exists, create a new one
				System.debug('Registered Device not found. '+e.getMessage());
				System.debug('Create new Registered Device');
				device = new Registered_Device__c();
			}
			
			// Set the new data to the existing/new device
			device.Name = DeviceName;
			device.Active__c = Active;
			device.App_Version__c = AppVersion;
			device.Device_Model__c = DeviceModel;
			device.Device_OS__c = DeviceOS;
			device.Device_Token__c = DeviceToken;
			device.Device_Id__c = DeviceId;
			if(Messages == 'true'){
				device.Receive_Messages__c = true;
			}else {
				device.Receive_Messages__c = false;
			}		
			device.Registration_Timestamp__c = Datetime.now();
			if(!device.Active__c){
				// If its not active, reset the new rewards field
				device.New_Rewards__c = 0;
			}
			
			try{
				// Update/Insert the device
				upsert device;
				// Set the success action into the response (Register/UnRegister)
				response.put('status',DeviceRegistrationUtilities.getStatus(Action));
			}catch(DmlException e){
				// If an error occurs, set the error status and the message to the response
				System.debug(e.getMessage());
				response.put('status','Error');
				response.put('message','There was an error when trying to register your device. Please try again.');
			}
		}
		
		return response;
	}
	
	/* (Autogenerated) The device name. 
	* The first 39 characters of the DeviceModel parameter plus a single space character,
	* plus the first 40 characters of the DeviceToken parameter
	*
	* @return String The autogenerated device name.
	*/
	private static String getDeviceName(String DeviceModel, String DeviceId){
		Integer modelLimit = 39;
		Integer idLimit = 40;
		if(DeviceModel.length() < 39){
			modelLimit = DeviceModel.length();
		}
		if(DeviceId.length() < 40){
			idLimit = DeviceId.length();
		}
		String subDeviceModel = DeviceModel.substring(0,modelLimit);
		String subDeviceId = DeviceId.substring(0,idLimit);
		
		return subDeviceModel + ' ' + subDeviceId;
	}
	
	/*
	* Checks if the value is null or empty
	*
	* @param String value
	* @return Boolean True if the value is null or empty
	*/
	private static Boolean isEmptyValue(String value){
		return (value == null || value == '');
	}
	
	private static String getStatus(String Action){
		if(Action.equals('Register')){
			return 'Registered';
		}else if(Action.equals('UnRegister')){
			return 'UnRegistered';
		}else {
			return 'Error';
		}
	}
	
	////////////////////////////////////////
	// Custom Exception                  //
	////////////////////////////////////////
	
	private class DeviceRegistrationException extends Exception{}
	
	private class RegisteredDevicePermissionsException extends Exception{}
}