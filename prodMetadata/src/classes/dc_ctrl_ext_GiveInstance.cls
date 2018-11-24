public with sharing class dc_ctrl_ext_GiveInstance {


    /***************************************** Properties ******************************************/
    public final Give_Instance__c instance      {get;set;}
    //public ApexPages.Standardcontroller con     {get;set;}
    public String selectedStage                 {get;set;}
    public String selectedStartStage            {get;set;}
    public String selectedEndStage              {get;set;}
	
	public ApexPages.StandardSetController setCon { get; private set; }
	public Boolean isFirstPage { get {return setCon != null && setCon.getPageNumber() == 1;} }
	public Boolean hasNextRequests { get {return setCon != null && setCon.getHasNext();} }
	public Boolean hasPrevRequests { get {return setCon != null && setCon.getHasPrevious();} }
	public Boolean isLastPage { get {return setCon != null && setCon.getPageNumber() == totalPageNum;} }
	public Integer thisPageNum  { get {return (setCon != null && setCon.getResultSize() > 0) ? setCon.getPageNumber() : 0;} } // getPageNumber() returns 1 even for empty page
	public Integer totalPageNum { get {return (setCon != null) ? Math.ceil(Double.valueOf(setCon.getResultSize()) / Double.valueOf(setCon.getPageSize())).intValue() : 0;} }
	
	public String updateMessage { get; private set; }
	
	private static final integer PAGESIZE;
	
	static {
		Give_Settings__c gs = Give_Settings__c.getInstance('IAVA');
        if (gs != null && gs.Give_Request_Page_Size__c != null) {
        	PAGESIZE = gs.Give_Request_Page_Size__c.intValue();
        } else {
        	PAGESIZE = 100;
        }
	}
    
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
    
    public List<Give_Request__c> requests {
        get{
            if(instance.id!=null && requests==null){
                requests = [Select g.Zip_Code__c, g.Units_Requested__c, g.State__c, g.Stage__c, g.Special_Response__c, g.Secondary_Phone__c, 
                                g.Primary_Phone__c, g.Notes__c, g.Name, g.Make_Email_Primary__c, g.Make_Address_Primary__c, g.Id, 
                                g.Give_Name__c, g.Give_Instance__c, g.Give_Instance_Start_Date__c, g.Give_Fulfillment_Instructions__c, 
                                g.Email_Address__c, g.Contact_ID_plus_Give_ID__c, g.Confirmed_21__c, g.City__c, g.Availability__c, 
                                g.Applicant__c, g.Address__c, g.CreatedDate, g.Num_Confirmed_Give_Requests__c, g.Re_confirm_Status__c
                            From Give_Request__c g
                            WHERE Give_Instance__c=:instance.id 
                            ORDER BY Stage__c,CreatedDate
                            limit :Limits.getLimitQueryRows()];
				setCon = new ApexPages.StandardSetController(requests);
				setCon.setPageSize(PAGESIZE);
            }
            return requests;
        }
        set;
    }
    
    public List<RequestSelect> requestSelects {
        get{
            if(requestSelects==null && !requests.isEmpty()){
                requestSelects = new List<RequestSelect>();
                for (Give_Request__c gr: (List<Give_Request__c>) setCon.getRecords()) {
                    requestSelects.add(new RequestSelect(gr));
                }
            }
            return requestSelects;
        }
        set;
    }
	
	public PageReference toFirst() {
		updateMessage = null;
		if (setCon == null) return null;
		setCon.first();
		requestSelects = null;
		return null;
	}
	
	public PageReference toPrevious() {
		updateMessage = null;
		if (setCon == null) return null;
		setCon.previous();
		requestSelects = null;
		return null;
	}
	
	public PageReference toNext() {
		updateMessage = null;
		if (setCon == null) return null;
		setCon.next();
		requestSelects = null;
		return null;
	}
	
	public PageReference toLast() {
		updateMessage = null;
		if (setCon == null) return null;
		setCon.last();
		requestSelects = null;
		return null;
	}
    
    /***************************************** Constructors ******************************************/
    public dc_ctrl_ext_GiveInstance(ApexPages.standardController sc) {
        //con = sc;
        instance = (Give_Instance__c)sc.getRecord();
        if (requests != null && requests.isEmpty()) { /* force initialization of requests and setCon for reference in page components */ }
    }
    
    public dc_ctrl_ext_GiveInstance(Give_Instance__c instance){
        this.instance = instance;
    }
    
    /***************************************** Action Methods ******************************************/
    public PageReference updateSelectedStage(){
    	updateMessage = null;
        if(selectedStage!=null && selectedStage!='' && selectedStage!='null' && requestSelects!=null){
            List<Give_Request__c> reqUpdates = new List<Give_Request__c>();
            for(RequestSelect req : requestSelects){
                if(req.checked){
                    req.record.Stage__c=selectedStage;
                    reqUpdates.add(req.record);
                }
            }
            try{
                if(!reqUpdates.isEmpty()) update reqUpdates;
                updateMessage = reqUpdates.size() + ' Give Request ' + (reqUpdates.size() > 1 ? 'records' : 'record') + ' updated.';
            } catch(Exception e){
                System.debug(e);            
                ApexPages.addMessages(e);
            } finally {
                requestSelects=null;
                requests=null;
            }
        }
        return null;
    }
    
    public PageReference massUpdateStage(){
    	updateMessage = null;
        if(selectedStartStage!=null && selectedStartStage!='null' && selectedEndStage!=null && selectedEndStage!='null'){
            // Select first 50k Requests in the StartStage
            for(List<Give_Request__c> reqs : [select id,stage__c from Give_Request__c where give_instance__c=:instance.id and stage__c=:selectedStartStage limit :Limits.getLimitQueryRows()]){
                List<Give_Request__c> updates = new List<Give_Request__c>();
                for(Give_Request__c req : reqs){
                    req.stage__c = selectedEndStage;
                    updates.add(req);
                }
                try{
                    if(!updates.isEmpty()) update updates;
                    updateMessage = updates.size() + ' Give Request ' + (updates.size() > 1 ? 'records' : 'record') + ' updated.';
                } catch(Exception e){
                    System.debug(e);            
                    ApexPages.addMessages(e);
                } finally {
                    requestSelects=null;
                    requests=null;
                }
            }
        }
        return null;
    }
    
    
    /***************************************** Helper/Utility Methods ******************************************/
    
    
    
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