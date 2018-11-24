public with sharing class dc_ctrl_ext_GiveInstanceMassRequests {

    public final Give_Instance__c instance      {get;set;}
    public String selectedStage                 {get;set;}
    public String selectedStartStage            {get;set;}
    public String selectedEndStage              {get;set;}
    
    public List<SelectOption> stageOptions{
        get{
            if(stageOptions==null){
                stageOptions = new List<SelectOption>();
                stageOptions.add(new SelectOption('null','--Select One--'));
                for(Schema.Picklistentry entry : Schema.sObjectType.Give_Request__c.fields.Stage__c.getPicklistValues()){
                    stageOptions.add(new SelectOption(entry.getValue(),entry.getLabel()));
                }
            }
            return stageOptions;
        }
        set;
    }
  
 	public Give_Request__c[] requests { 
 		get { 
 			return (List<Give_Request__c>)pgr.getRecords(); 
 		} 
 		set; 
 	}
 	
 	public List<RequestSelect> requestSelects{
        get{
            if(requestSelects==null && !requests.isEmpty()){
                requestSelects = new List<RequestSelect>();
                for(Give_Request__c gr:requests){
                    requestSelects.add(new RequestSelect(gr));
                }
            }
            return requestSelects;
        }
        set;
    }
	
	public ID instanceId {
		get{
			try{
				instanceId = ApexPages.currentPage().getParameters().get('instanceId');
			} catch(Exception e){
				System.debug('******** Invalid InstanceId: '+ApexPages.currentPage().getParameters().get('instanceId'));
				ApexPages.addMessages(e);
			}
			return instanceId;
		}
		set;
	}
	
	public ApexPages.StandardSetController pgr {
	    get {
	      if (pgr == null) pgr = initPager();
	      return pgr;
	      }
	    set;
    }
	
	
	
    /***************************************** Action Methods ******************************************/
    
    public ApexPages.StandardSetController initPager() {
		ApexPages.StandardSetController ret = new ApexPages.StandardSetController(Database.getQueryLocator(
													[Select g.Zip_Code__c, g.Units_Requested__c, g.State__c, g.Stage__c, g.Special_Response__c, g.Secondary_Phone__c, 
							                                g.Primary_Phone__c, g.Notes__c, g.Name, g.Make_Email_Primary__c, g.Make_Address_Primary__c, g.Id, 
							                                g.Give_Name__c, g.Give_Instance__c, g.Give_Instance_Start_Date__c, g.Give_Instance__r.Give__r.Fulfillment_Instructions_for_Winner__c, 
							                                g.Email_Address__c, g.Contact_ID_plus_Give_ID__c, g.Confirmed_21__c, g.City__c, g.Availability__c, 
							                                g.Applicant__c, g.Address__c, g.CreatedDate, g.Num_Confirmed_Give_Requests__c
							                        From Give_Request__c g
							                        WHERE g.Give_Instance__c=:instanceId
							                        ORDER BY Stage__c,CreatedDate]
							                        ));
		ret.setPageSize(250);
		return ret;	
	}
    
    
    public PageReference nextPage() { requestSelects=null; pgr.next(); return null;     }
  	public PageReference prevPage() { requestSelects=null; pgr.previous(); return null; }
    
    public PageReference updateSelectedStage(){
        if(selectedStage!=null && selectedStage!='' && selectedStage!='null' && requestSelects!=null){
            List<Give_Request__c> reqUpdates = new List<Give_Request__c>();
            for(RequestSelect req : requestSelects){
                if(req.checked){
                    req.record.Stage__c=selectedStage;
                    reqUpdates.add(req.record);
                }
            }

            try{
                if(!reqUpdates.isEmpty()) { System.debug('reqUpdates='+reqUpdates); update reqUpdates; }
            } catch(Exception e){
                System.debug(e);            
                ApexPages.addMessages(e);
            } finally {
                requestSelects=null;
            }
        }
        return null;
    }
    
    public PageReference massUpdateStage(){
        if(selectedStartStage!=null && selectedStartStage!='null' && selectedEndStage!=null && selectedEndStage!='null'){
            
        	List<Give_Request__c> updates = new List<Give_Request__c>();
            for(SObject req : pgr.getRecords()){
            	Give_Request__c gr = (Give_Request__c) req;
                if(gr.stage__c==selectedStartStage){
                    gr.stage__c = selectedEndStage;
                    updates.add(gr);
                }
            }
            try{
                if(!updates.isEmpty()) update updates;
            } catch(Exception e){
                System.debug(e);            
                ApexPages.addMessages(e);
            } finally {
            	requestSelects = null;
            }
            
        }
        return null;
    }
    
    
    /***************************************** Helper Class ******************************************/
    public class RequestSelect{
        public Give_Request__c record {get;set;}
        public Boolean checked {get;set;}
        
        public RequestSelect(Give_Request__c obj){
            record = obj;
            checked = false;
        }
    }
}