global class PendingNotificationBatchProcessor implements Database.Batchable<sObject>, Database.AllowsCallouts{
	
	final String batchQuery;
	
   	global PendingNotificationBatchProcessor(){
   		try{
			batchQuery='Select Zip_Code__c, State__c, Processed__c, OwnerId, National__c, Name, Message_Text__c, Give__c, Give__r.Geo_Location__c, Distance__c, Campaign__c	From Pending_Notification__c Where Processed__c = false';
			System.debug('batchQuery='+batchQuery);
		}catch(Exception e){
			System.debug(e.getMessage());
		}
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(batchQuery);
	}
	
	global void execute(Database.BatchableContext BC, List<sObject> scope){
      
		try{
			List<String> geoLocationIds = new List<String>();
			for(sObject s: scope){
				Pending_Notification__c p = (Pending_Notification__c) s;
				if(p.Give__c != null && p.Give__r.Geo_Location__c != null){
					geoLocationIds.add(p.Give__r.Geo_Location__c);
				}
			}
			
			Double defaultDistance = double.valueOf(Rucksack_Mobile_Services__c.getAll().get('Default Search Radius').Value__c);
			Map<String, Geo_Location__c> mapGeoLocations= new Map<String, Geo_Location__c>([Select Id, lat__c, lon__c From Geo_Location__c Where Id IN :geoLocationIds]);
			List<Registered_Device__c> devices = [Select Receive_Messages__c, New_Rewards__c, Device_Owner__c, Device_Owner__r.MailingState, Device_Owner__r.OtherState, Device_Owner__r.Latitude__c, Device_Owner__r.Longitude__c From Registered_Device__c Where Active__c = true];
			
			List<String> owners = new List<String>();
			for(Registered_Device__c d: devices){
				if(d.Device_Owner__c != null){
					owners.add(d.Device_Owner__c);
				}
			}
			
			List<CampaignMember> campaignMembers = new List<CampaignMember>();
			if(owners.size() > 0){
				campaignMembers = [Select ContactId, CampaignId From CampaignMember Where Id IN :owners];
			}
			
			List<Notification_Message__c> notifications = new List<Notification_Message__c>();
			for(sObject s: scope){
				Pending_Notification__c p = (Pending_Notification__c) s;
				Double distance = defaultDistance;
				if(p.Distance__c != null){
					distance = p.Distance__c;
				}
				if(p.Give__c != null || p.Campaign__c != null){
					for(Registered_Device__c d: devices){
						if(p.Give__c != null){
							d.New_Rewards__c = d.New_Rewards__c+1;
							Boolean hasState = false;
							if( d.Device_Owner__c != null){
								if(d.Device_Owner__r.OtherState != null){
									hasState = p.State__c.contains(d.Device_Owner__r.OtherState);	
								}else if(d.Device_Owner__r.MailingState != null){
									hasState = p.State__c.contains(d.Device_Owner__r.MailingState);
								}
							}
							
							Boolean isDeviceInDistance = false;
							if(p.Give__c != null){
								if(mapGeoLocations.get(p.Give__c) != null){
									if(mapGeoLocations.get(p.Give__c).lat__c != null){
										if(mapGeoLocations.get(p.Give__c).lon__c != null){
											if(d.Device_Owner__c != null){
												if(d.Device_Owner__r.Latitude__c != null){
													if(d.Device_Owner__r.Longitude__c != null){
														isDeviceInDistance = (distance >= GoogleMapUtils.DistanceBetween(double.valueOf(mapGeoLocations.get(p.Give__c).lat__c), double.valueOf(mapGeoLocations.get(p.Give__c).lon__c), double.valueOf(d.Device_Owner__r.Latitude__c), double.valueOf(d.Device_Owner__r.Longitude__c)));
													}
												}
											}
										}
									}
								}
							}										
							
							if(	d.Device_Owner__c == null || 
								p.National__c || 
								hasState ||
								(	p.Give__r.Geo_Location__c != null && 
									d.Device_Owner__r.Latitude__c != null && 
									d.Device_Owner__r.Longitude__c != null && 
									isDeviceInDistance)){
								Notification_Message__c n = new Notification_Message__c();
								n.Registered_Device__c = d.Id;
								n.Message_Text__c = p.Message_Text__c;
								n.Delivered__c = false;
								notifications.add(n);
							}
						}else {
							if(p.Campaign__c != null){
								Boolean isValidCampaignContact = false;
								for(CampaignMember c: campaignMembers){
									if(c.ContactId == d.Device_Owner__c && c.CampaignId == p.Campaign__c){
										isValidCampaignContact = true;
										break;
									}
								}
								if(isValidCampaignContact){
									Notification_Message__c n = new Notification_Message__c();
									n.Registered_Device__c = d.Id;
									n.Message_Text__c = p.Message_Text__c;
									n.Delivered__c = false;
									notifications.add(n);
								}
							} 
						}
					}
					
				}else continue;
				p.Processed__c = true;
			}	
			System.debug(notifications);
			System.debug(scope);
			insert notifications;
			update scope;	
		}catch(QueryException e){
			System.debug(e.getMessage());
	    }catch(DmlException e){
			System.debug(e.getMessage());
		}catch(NullPointerException e){
			System.debug(e.getMessage());
		}
	}
   

	global void finish(Database.BatchableContext BC){}
}