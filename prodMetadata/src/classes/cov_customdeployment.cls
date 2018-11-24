public with sharing class cov_customdeployment {


	public String city {get; set;}
	public String country {get; set;}
	public Date enddate {get; set;}
	public String notes {get; set;}
	public String operation {get; set;}
	public Date startdate {get; set;}
	public Boolean stoploss {get; set;}
	public String dpId {get; set;}
	public Boolean ineditmode {get; set;}
	
	public String startdatenice {get; set;}
	public String enddatenice {get; set;}

	public cov_customdeployment() {}
	
	public static List<cov_customdeployment> createCDs(List<Detailed_Deployment_Information__c> DDIs) {
		
		List<cov_customdeployment> cds = new List<cov_customdeployment>();
		for (Detailed_Deployment_Information__c ddi : DDIs) {
			cov_customdeployment cd = new cov_customdeployment();
			cd.city = ddi.City__c;
			cd.country = ddi.Country__c;
			cd.enddate = ddi.End_Date__c;
			cd.notes = ddi.Notes__c;
			cd.operation = ddi.OEF_OIF__c;
			cd.startdate = ddi.Start_Date__c;
			cd.stoploss = ddi.Stop_Loss__c;
			cd.dpId = ddi.Id;
			
			if (cd.startdate != null) {
				cd.startdatenice = cov_utilities.niceDateSlashes(cd.startdate);
			}
			if (cd.enddate != null) {
				cd.enddatenice = cov_utilities.niceDateSlashes(cd.enddate);
			}
						
			cds.add(cd);
		}
		
		return cds;
		
	}


}