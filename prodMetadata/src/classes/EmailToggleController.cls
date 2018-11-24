/**
 * Created by tarren.anderson on 8/23/17.
 */

public with sharing class EmailToggleController {

	@AuraEnabled
	public static ToggleResponse getEmailState(){
		ToggleResponse resp = new ToggleResponse();
		try{
			NetworkMember nm = queryNetworkMember();
			if(nm != null){
				resp.emailValue = nm.PreferencesDisableAllFeedsEmail;
				resp.success = true;
			}
		}catch(Exception e){
			resp.success=false;
			resp.errorMessage = e.getMessage();
		}
		return resp;
	}

	@AuraEnabled
	public static ToggleResponse toggleEmail(){
		ToggleResponse resp = new ToggleResponse();
		try{
			NetworkMember nm = queryNetworkMember();
			if(nm != null){
                
                Boolean updatePrefVal = !nm.PreferencesDisableAllFeedsEmail;
				nm.PreferencesDisableAllFeedsEmail = updatePrefVal;
				resp.emailValue = nm.PreferencesDisableAllFeedsEmail;
				update nm;
                
                User u = new User();
                u.Id = UserInfo.getUserId();
                u.UserPreferencesDisableAllFeedsEmail = updatePrefVal;
                update u;
                
                resp.success = true;
			}
		}catch(Exception e){
			resp.success=false;
			resp.errorMessage = e.getMessage();
		}
		return resp;
	}


	private static NetworkMember queryNetworkMember(){
		try{
			List<NetworkMember> nmList = [SELECT PreferencesDisableAllFeedsEmail
			FROM NetworkMember
			WHERE MemberId =: UserInfo.getUserId()
			AND NetworkId = : Network.getNetworkId()
			LIMIT 1];
			if(!nmList.isEmpty()){
				return nmList[0];
			} else {
				//TODO : Improve test handling
				if(Test.isRunningTest()){
					NetworkMember testMember = new NetworkMember();
					return testMember;
				}
			}
		}catch(Exception e){
			return null;
		}
		return null;
	}

	@TestVisible
	private class ToggleResponse{
		@AuraEnabled public Boolean success;
		@AuraEnabled public Boolean emailValue;
		@AuraEnabled public String errorMessage;
	}
}