/*
 * Get information about legislators, bills, and amendments using the RESTful JSON Sunlight Congress API
 * Sunlight Congress API documentation @ https://sunlightlabs.github.io/congress/index.html
 * 
 * getAmendment() gets a single amendment
 * https://congress.api.sunlightfoundation.com/amendments?apikey=[APIKEY]&amendment_id=[<prefix><amendment#>-<session#>]&fields=amendment_id,amends_bill_id,purpose,sponsor_id,last_action.text,last_action.type,introduced_on
 *
 * getAmendments() gets a list of amendments by amendment ids
 * https://congress.api.sunlightfoundation.com/amendments?apikey=[APIKEY]&amendment_id__in=[id1|id2]&fields=amendment_id,amends_bill_id,purpose,sponsor_id,last_action.text,last_action.type,introduced_on
 * 
 * getBill() gets a single bill
 * https://congress.api.sunlightfoundation.com/bills?apikey=[APIKEY]&bill_id=[<prefix><bill#>-<session#>]&fields=bill_id,official_title,short_title,sponsor_id,cosponsors_count,cosponsor_ids,last_action.text,last_action.type,summary,introduced_on
 *
 * getBills() gets a list of bills by bill ids
 * https://congress.api.sunlightfoundation.com/bills?apikey=[APIKEY]&bill_id__in=[id1|id2]&fields=bill_id,official_title,short_title,sponsor_id,cosponsors_count,cosponsor_ids,last_action.text,last_action.type,summary,introduced_on
 *
 * WH, Exponent Partners, 2011, 2015
 */
public class RealTimeCongressAPI {
	
	private final String Endpoint;
	private final String APIKey;
	
	private static final String PageSize = '200';
	private static final String AmendmentSectionFilter = 'amendment_id,amends_bill_id,purpose,sponsor_id,last_action.text,last_action.type,introduced_on';
	
	// Include 'summary' in the API callout when a more efficient native JSON parser is available for use
	// In the meantime, bills (e.g. hr3590-111) with long summary can cause this JSON parser to exceed Apex script statement limit
	//private static final String BillSectionFilter = 'bill_id,official_title,short_title,sponsor_id,cosponsors_count,cosponsor_ids,last_action.text,last_action.type,summary,introduced_on';
	private static final String BillSectionFilter = 'bill_id,official_title,short_title,sponsor_id,cosponsors_count,cosponsor_ids,last_action.text,last_action.type,introduced_on';
	
	private enum APIMethod {BILL, AMMENDMENT}
	
	// Info retrieved for each legislation (amendment, bill)
	// Total number of amendments or bills returned in this API call
	public Integer recordCount;
	// Set of bioguide ids of all legislators who are sponsors or copsonsors of the bills fetched in this API call
	public Set<String> legislators;
	// Map from amendment_id or bill_id to LegInfo containing details of each amendment or bill
	public Map<String, LegInfo> legDetailMap;
	
	public class LegInfo {
		public String amendmentId { get; private set; }		// amendment only
		public String billId { get; private set; }
		public String summary { get; private set; }			// bill only
		public String introducedOn { get; private set; }
		public String sponsorId { get; private set; }
		public Set<String> cosponsorIds { get; set; }		// bill only
		
		private String status;
		private String officialTitle;						// bill only
		private String shortTitle;							// bill only
		private String purpose;								// amendment only
		private String lastAction;
		
		public LegInfo() {
			this.amendmentId = null;
			this.billId = null;
			this.status = null;
			this.officialTitle = null;
			this.shortTitle = null;
			this.purpose = null;
			this.lastAction = null;
			this.summary = null;
			this.introducedOn = null;
			this.sponsorId = null;
			this.cosponsorIds = new Set<String>();
		}
		
		// This is for use in amendment unit tests
		public LegInfo(String amendmentId, String billId, String status, String purpose, String lastAction, String introducedOn, String sponsorId) {
			this.amendmentId = amendmentId;
			this.billId = billId;
			this.status = status;
			this.purpose = purpose;
			this.lastAction = lastAction;
			this.introducedOn = introducedOn;
			this.sponsorId = sponsorId;
		}
		
		// This is for use in bill unit tests
		public LegInfo(String billId, String status, String officialTitle, String shortTitle, String lastAction, String summary, String introducedOn, String sponsorId, Set<String> cosponsorIds) {
			this.billId = billId;
			this.status = status;
			this.officialTitle = officialTitle;
			this.shortTitle = shortTitle;
			this.lastAction = lastAction;
			this.summary = summary;
			this.introducedOn = introducedOn;
			this.sponsorId = sponsorId;
			this.cosponsorIds = (cosponsorIds != null) ? cosponsorIds : new Set<String>();
		}
		
		// These getters return strings that can be manipulated by the caller, e.g. truncated to fit field sizes on sObjects
		public String getOfficialTitle() { return this.officialTitle; }
		public String getShortTitle() { return this.shortTitle; }
		public String getStatus() { return this.status; }
		public String getPurpose() { return this.purpose; }
		public String getLastAction() { return this.lastAction; }
	}
	
	public RealTimeCongressAPI() {
		Sunlight_Congress_Settings__c ss = Sunlight_Congress_Settings__c.getInstance('IAVA');
		if (ss != null) {
			Endpoint = ss.Endpoint__c;
			APIKey = ss.APIKey__c;
		} else {
			// defaults
			//	use http instead of recommended https because of handshake_failure; apparently Sunlight does not support TLS 1.0 or higher
			Endpoint = 'http://congress.api.sunlightfoundation.com';
			APIKey = 'e875910d16c32457b55036aeaa2194f1';
		}
		
		recordCount = 0;
		legislators = new Set<String>();
		legDetailMap = new Map<String, LegInfo>();
	}
	
	// Get info for a single amendment
	// Returns true if successful, false otherwise
	public Boolean getAmendment(String amendmentPrefix, String amendmentNumber, String session) {
		
		Http h = new Http();
		HttpResponse res = new HttpResponse();
		
		List<String> keys = new List<String>{'amendment_id', 'fields'};
		List<String> vals = new List<String>{amendmentPrefix + amendmentNumber + '-' + session, AmendmentSectionFilter};
		HttpRequest req = buildRequest('amendments', keys, vals);
		
		if (!Test.isRunningTest()) {
			res = invokeWebService(h, req);
			System.debug('>>>>>>>>>> Result: ' + res.getBody());
		}
		
		return handleResponse(res, APIMethod.AMMENDMENT);
		
	}
	
	// Get info for amendments specified by a list of amendment Ids in format: <prefix><amendment#>-<session#>
	// Returns true if successful, false otherwise
	public Boolean getAmendments(List<String> amendmentIdList) {
		
		Http h = new Http();
		HttpResponse res = new HttpResponse();
		
		// Format amendment ids
		String amendmentIds = '';
		for (String b : amendmentIdList) {
			amendmentIds += b + '|';
		}
		amendmentIds = amendmentIds.substring(0, amendmentIds.length()-1);
		
		List<String> keys = new List<String>{'amendment_id__in', 'per_page', 'fields'};
		List<String> vals = new List<String>{amendmentIds, PageSize, AmendmentSectionFilter};
		HttpRequest req = buildRequest('amendments', keys, vals);
		
		if (!Test.isRunningTest()) {
			res = invokeWebService(h, req);
			System.debug('>>>>>>>>>> Result: ' + res.getBody());
		}
		
		return handleResponse(res, APIMethod.AMMENDMENT);
		
	}
	
	// Get info for a single legislation (bill)
	// Returns true if successful, false otherwise
	public Boolean getBill(String billPrefix, String billNumber, String session) {
		
		Http h = new Http();
		HttpResponse res = new HttpResponse();
		
		List<String> keys = new List<String>{'bill_id', 'fields'};
		List<String> vals = new List<String>{billPrefix + billNumber + '-' + session, BillSectionFilter};
		HttpRequest req = buildRequest('bills', keys, vals);
		
		if (!Test.isRunningTest()) {
			res = invokeWebService(h, req);
			System.debug('>>>>>>>>>> Result: ' + res.getBody());
		}
		
		return handleResponse(res, APIMethod.BILL);
		
	}
	
	// Get info for legislations (bills) specified by a list of bill Ids in format: <prefix><bill#>-<session#>
	// Returns true if successful, false otherwise
	public Boolean getBills(List<String> billIdList) {
		
		Http h = new Http();
		HttpResponse res = new HttpResponse();
		
		// Format bill ids
		String billIds = '';
		for (String b : billIdList) {
			billIds += b + '|';
		}
		billIds = billIds.substring(0, billIds.length()-1);
		
		List<String> keys = new List<String>{'bill_id__in', 'per_page', 'fields'};
		List<String> vals = new List<String>{billIds, PageSize, BillSectionFilter};
		HttpRequest req = buildRequest('bills', keys, vals);
		
		if (!Test.isRunningTest()) {
			res = invokeWebService(h, req);
			System.debug('>>>>>>>>>> Result: ' + res.getBody());
		}
		
		return handleResponse(res, APIMethod.BILL);
		
	}
	
	// Build the Web Service request, packing a list of key-value pairs in query string
	private HttpRequest buildRequest(String method, List<String> keys, List<String> values) {
		
		// Build query string parameters
		Integer i = 0;
		String params = '';
		for (String k : keys) {
			params = params + '&' + k + '=' + EncodingUtil.urlEncode(values.get(i), 'UTF-8');
			i++;
		}
		
		// Compose the URL
		String url = Endpoint + '/' + method + '?apikey=' + APIKey + params;
		
		// Instantiate a new HTTP request, GET method, set endpoint
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setMethod('GET');
		
		return req;
	}
	
	// Invoke the Web Service
	private HttpResponse invokeWebService(Http h, HttpRequest req) {
		HttpResponse res = new HttpResponse();
		try {
			res = h.send(req);
		} catch(System.CalloutException e) {
			System.debug('>>>>>>>>>> Callout error: '+ e);
			System.debug('>>>>>>>>>> ' + res.toString());
		}
		return res;
	}
	
	// Process the Web Service response
	private Boolean handleResponse(HttpResponse res, APIMethod aMethod) {
		String resBody = res.getBody();
		
		If (res.getStatusCode() != 200 || resBody == null || resBody == '') {
			System.debug('>>>>>>>>>> HTTP Status Code: ' + res.getStatusCode());
			return false;
		}
		
		// JSON parser does not handle line breaks well
		resBody = resBody.replace('\n', '');
		
		return parseResult(resBody, aMethod);
	}
	
	// Parse JSON response from the Web Service and store info in legDetailMap
	private Boolean parseResult(String result, APIMethod aMethod) {
		
		// Reset data
		recordCount = 0;
		legislators = new Set<String>();
		legDetailMap = new Map<String, LegInfo>();
		
		try {
			// Parse the JSON result
			JSONObject json = new JSONObject(result);
			
			// Get number of amendments or bills in current page
			JSONObject page;
			if (json != null && json.getValue('page') != null) {
				page = json.getValue('page').obj;
				recordCount = (page.getValue('count') != null) ? page.getValue('count').num : 0;
				
				if (recordCount > 0 && json.getValue('results') != null) {
					
					// Handle amendments
					if (aMethod == APIMethod.AMMENDMENT) {
						
						//{"results":[
						//		{"amendment_id":"<amendmentId>","amends_bill_id":"<billId>","introduced_on":"<introducedOn>",
						//		"last_action":{"text":"<lastAction>","type":"<status>"},
						//		"purpose":"<purpose>","sponsor_id":"<sponsorId>"},...
						//	],
						//	"count":2,
						//	"page":{"count":2,"per_page":20,"page":1}}
						
						// Get each amendment in the array
						JSONObject amendment;
						LegInfo amendmentDetail;
						Integer actions_count;
						
						for (Integer i = 0; i < recordCount; i++) {
							if (json.getValue('results').values[i] != null) {
								amendment = json.getValue('results').values[i].obj;
								amendmentDetail = new LegInfo();
								
								amendmentDetail.amendmentId = (amendment.getValue('amendment_id') != null) ? amendment.getValue('amendment_id').str : null;
								
								amendmentDetail.billId = (amendment.getValue('amends_bill_id') != null) ? amendment.getValue('amends_bill_id').str : null;
															
								amendmentDetail.purpose = (amendment.getValue('purpose') != null) ? amendment.getValue('purpose').str : null;
								
								amendmentDetail.introducedOn = (amendment.getValue('introduced_on') != null) ? amendment.getValue('introduced_on').str : null;
								
								amendmentDetail.sponsorId = (amendment.getValue('sponsor_id') != null) ? amendment.getValue('sponsor_id').str : null;
								if (amendmentDetail.sponsorId != null) { legislators.add(amendmentDetail.sponsorId); }
								
								//actions_count = (amendment.getValue('actions') != null) ? amendment.getValue('actions').values.size() : 0;
								// Get last (latest) action text
								//if (actions_count > 0 && amendment.getValue('actions') != null) {
									//JSONObject last_action = (amendment.getValue('actions').values[actions_count-1] != null) ? amendment.getValue('actions').values[actions_count-1].obj : null;
									//amendmentDetail.lastAction = (last_action != null && last_action.getValue('text') != null) ? last_action.getValue('text').str : null;
								//}
								
								JSONObject last_action = (amendment.getValue('last_action') != null) ? amendment.getValue('last_action').obj : null;
								amendmentDetail.lastAction = (last_action != null && last_action.getValue('text') != null) ? last_action.getValue('text').str : null;
								amendmentDetail.status = (last_action != null && last_action.getValue('type') != null) ? last_action.getValue('type').str : null;
								
								legDetailMap.put(amendmentDetail.amendmentId, amendmentDetail);
							}
						}
						
					// Handle bills
					} else if (aMethod == APIMethod.BILL) {
						
						//{"results":[
						//		{"bill_id":"<billId>","cosponsor_ids":["C001077",...],"cosponsors_count":2,"introduced_on":"<introducedOn>",
						//			"last_action":{"text":"<lastAction>","type":"<status>"},
						//			"official_title":"<officialTitle>","short_title":"<shortTitle>","sponsor_id":"<sponsorId>","summary":"<summary>"},...
						//	],
						//	"count":2,
						//	"page":{"count":2,"per_page":50,"page":1}}
						
						// Get each bill in the array
						JSONObject bill;
						LegInfo billDetail;
						Integer cosponsors_count;
						
						for (Integer i = 0; i < recordCount; i++) {
							if (json.getValue('results').values[i] != null) {
								bill = json.getValue('results').values[i].obj;
								billDetail = new LegInfo();
								
								billDetail.billId = (bill.getValue('bill_id') != null) ? bill.getValue('bill_id').str : null;
								
								billDetail.officialTitle = (bill.getValue('official_title') != null) ? bill.getValue('official_title').str : null;
								
								billDetail.shortTitle = (bill.getValue('short_title') != null) ? bill.getValue('short_title').str : null;
								
								billDetail.summary = (bill.getValue('summary') != null) ? bill.getValue('summary').str : null;
								
								billDetail.introducedOn = (bill.getValue('introduced_on') != null) ? bill.getValue('introduced_on').str : null;
								
								billDetail.sponsorId = (bill.getValue('sponsor_id') != null) ? bill.getValue('sponsor_id').str : null;
								if (billDetail.sponsorId != null) { legislators.add(billDetail.sponsorId); }
								
								cosponsors_count = (bill.getValue('cosponsors_count') != null) ? bill.getValue('cosponsors_count').num : 0;
								if (cosponsors_count > 0 && bill.getValue('cosponsor_ids') != null) {
									for (Integer j = 0; j < cosponsors_count; j++)
										billDetail.cosponsorIds.add(bill.getValue('cosponsor_ids').values[j].str);
								}
								legislators.addAll(billDetail.cosponsorIds);
								
								JSONObject last_action = (bill.getValue('last_action') != null) ? bill.getValue('last_action').obj : null;
								billDetail.lastAction = (last_action != null && last_action.getValue('text') != null) ? last_action.getValue('text').str : null;
								billDetail.status = (last_action != null && last_action.getValue('type') != null) ? last_action.getValue('type').str : null;
								
								legDetailMap.put(billDetail.billId, billDetail);
							}
						}
						
					} // no else since enum has only 2 values
					
					return true;
				
				} else {
					System.debug('>>>>>>>>>> No amendment or bill information returned: ' + result);
					return false;
				}
				
			} else {
				System.debug('>>>>>>>>>> No pagination information returned: ' + result);
				return false;
			}
			
		} catch (JSONObject.JSONException e) {
			System.debug('>>>>>>>>>> Error parsing JSON response from Sunlight Congress API: ' + e);
			return false;
		}
	}
	
	////////// Unit Tests //////////
	
	static testMethod void testBuildRequest() {
		RealTimeCongressAPI api = new RealTimeCongressAPI();
		
		List<String> keys = new List<String>{'key1', 'key2'};
		List<String> vals = new List<String>{'value1', 'value2'};
		HttpRequest req = api.buildRequest('method', keys, vals);
		
		System.assertNotEquals(null, req);
		System.assertEquals(api.Endpoint + '/method?apikey=' + api.APIKey + '&key1=value1&key2=value2', req.getEndpoint());
		System.assertEquals('GET', req.getMethod());
		//System.assertEquals(null, req.getBody());
	}
	
	static testMethod void testHandleResponse() {
		RealTimeCongressAPI api = new RealTimeCongressAPI();
		System.assertEquals(false, api.handleResponse(new HttpResponse(), APIMethod.AMMENDMENT));
	}
	
	static testMethod void testParseAmendmentResult() {
		RealTimeCongressAPI api = new RealTimeCongressAPI();
		
		// Results contain everything we are looking for in an amendment
		String result = '{"results":[{"amendment_id":"samdt4126-113","amends_bill_id":"sres226-113","introduced_on":"2014-12-16","last_action":{"text":"Amendment SA 4126 agreed to in Senate by Unanimous Consent.","type":"vote"},"purpose":"To amend the preamble.","sponsor_id":"B000944"}],"count":1,"page":{"count":1,"per_page":20,"page":1}}';
		System.assertEquals(true, api.parseResult(result, APIMethod.AMMENDMENT));
		System.assertEquals(1, api.recordCount);
		System.assertEquals('samdt4126-113', api.legDetailMap.get('samdt4126-113').amendmentId);
		System.assertEquals('sres226-113', api.legDetailMap.get('samdt4126-113').billId);
		System.assertEquals('vote', api.legDetailMap.get('samdt4126-113').getStatus());
		System.assertEquals('To amend the preamble.', api.legDetailMap.get('samdt4126-113').getPurpose());
		System.assertEquals('Amendment SA 4126 agreed to in Senate by Unanimous Consent.', api.legDetailMap.get('samdt4126-113').getLastAction());
		System.assertEquals('2014-12-16', api.legDetailMap.get('samdt4126-113').introducedOn);
		System.assertEquals('B000944', api.legDetailMap.get('samdt4126-113').sponsorId);
		System.assertEquals(1, api.legislators.size());
		System.assertEquals(true, api.legislators.contains('B000944'));
		
		// Results contain partial information for an amendment
		result = '{"results":[{"amendment_id":"samdt4126-113","amends_bill_id":"sres226-113","introduced_on":"2014-12-16","last_action":{"type":"vote"},"sponsor_id":"B000944"}],"count":1,"page":{"count":1,"per_page":20,"page":1}}';
		System.assertEquals(true, api.parseResult(result, APIMethod.AMMENDMENT));
		System.assertEquals(1, api.recordCount);
		System.assertEquals('samdt4126-113', api.legDetailMap.get('samdt4126-113').amendmentId);
		System.assertEquals('sres226-113', api.legDetailMap.get('samdt4126-113').billId);
		System.assertEquals('vote', api.legDetailMap.get('samdt4126-113').getStatus());
		System.assertEquals(null, api.legDetailMap.get('samdt4126-113').getPurpose());
		System.assertEquals(null, api.legDetailMap.get('samdt4126-113').getLastAction());
		System.assertEquals('2014-12-16', api.legDetailMap.get('samdt4126-113').introducedOn);
		System.assertEquals('B000944', api.legDetailMap.get('samdt4126-113').sponsorId);
		System.assertEquals(1, api.legislators.size());
		System.assertEquals(true, api.legislators.contains('B000944'));
		
		// No information for amendment
		result = '{"page":{"per_page":20,"page":1,"count":1},"count":1,"funny":{"pretty":"much"}}';
		System.assertEquals(false, api.parseResult(result, APIMethod.AMMENDMENT));
		System.assertEquals(1, api.recordCount);
		System.assertEquals(0, api.legDetailMap.size());
		
		// No pagination information
		result = '{"funny":{"pretty":"much"}}';
		System.assertEquals(false, api.parseResult(result, APIMethod.AMMENDMENT));
		System.assertEquals(0, api.recordCount);
		System.assertEquals(0, api.legDetailMap.size());
		
		// Bad JSON result
		result = 'Bad JSON';
		System.assertEquals(false, api.parseResult(result, APIMethod.AMMENDMENT));
		System.assertEquals(0, api.recordCount);
		System.assertEquals(0, api.legDetailMap.size());
	}
	
	static testMethod void testParseBillResult() {
		RealTimeCongressAPI api = new RealTimeCongressAPI();
		
		// Results contain everything we are looking for in a bill
		String result = '{"results":[{"bill_id":"hr3590-111","cosponsor_ids":["B000287","B001231"],"cosponsors_count":2,"introduced_on":"2009-09-17","last_action":{"text":"Became Public Law No: 111-148.","type":"enacted"},"official_title":"An act entitled The Patient Protection and Affordable Care Act.","short_title":"Patient Protection and Affordable Care Act","summary":"Affordable care for all.","sponsor_id":"R000053"}],"count":1,"page":{"count":1,"per_page":20,"page":1}}';
		System.assertEquals(true, api.parseResult(result, APIMethod.BILL));
		System.assertEquals(1, api.recordCount);
		System.assertEquals('hr3590-111', api.legDetailMap.get('hr3590-111').billId);
		System.assertEquals('enacted', api.legDetailMap.get('hr3590-111').getStatus());
		System.assertEquals('An act entitled The Patient Protection and Affordable Care Act.', api.legDetailMap.get('hr3590-111').getOfficialTitle());
		System.assertEquals('Patient Protection and Affordable Care Act', api.legDetailMap.get('hr3590-111').getShortTitle());
		System.assertEquals('Became Public Law No: 111-148.', api.legDetailMap.get('hr3590-111').getLastAction());
		System.assertEquals('Affordable care for all.', api.legDetailMap.get('hr3590-111').summary);
		System.assertEquals('2009-09-17', api.legDetailMap.get('hr3590-111').introducedOn);
		System.assertEquals('R000053', api.legDetailMap.get('hr3590-111').sponsorId);
		//System.assertEquals(new String[] {'B000287', 'B001231'}, api.legDetailMap.get('hr3590-111').cosponsorIds);
		System.assertEquals(2, api.legDetailMap.get('hr3590-111').cosponsorIds.size());
		System.assertEquals(true, api.legDetailMap.get('hr3590-111').cosponsorIds.contains('B000287'));
		System.assertEquals(true, api.legDetailMap.get('hr3590-111').cosponsorIds.contains('B001231'));
		System.assertEquals(3, api.legislators.size());
		System.assertEquals(true, api.legislators.contains('R000053'));
		System.assertEquals(true, api.legislators.contains('B000287'));
		System.assertEquals(true, api.legislators.contains('B001231'));
		
		// Results contain partial information for a bill
		result = '{"results":[{"bill_id":"hr3590-111","cosponsor_ids":["B000287","B001231"],"cosponsors_count":2}],"count":1,"page":{"count":1,"per_page":20,"page":1}}';
		System.assertEquals(true, api.parseResult(result, APIMethod.BILL));
		System.assertEquals(1, api.recordCount);
		System.assertEquals('hr3590-111', api.legDetailMap.get('hr3590-111').billId);
		System.assertEquals(null, api.legDetailMap.get('hr3590-111').getStatus());
		System.assertEquals(null, api.legDetailMap.get('hr3590-111').getOfficialTitle());
		System.assertEquals(null, api.legDetailMap.get('hr3590-111').getShortTitle());
		System.assertEquals(null, api.legDetailMap.get('hr3590-111').getLastAction());
		System.assertEquals(null, api.legDetailMap.get('hr3590-111').summary);
		System.assertEquals(null, api.legDetailMap.get('hr3590-111').introducedOn);
		System.assertEquals(null, api.legDetailMap.get('hr3590-111').sponsorId);
		//System.assertEquals(new String[] {'B000287', 'B001231'}, api.legDetailMap.get('hr3590-111').cosponsorIds);
		System.assertEquals(2, api.legDetailMap.get('hr3590-111').cosponsorIds.size());
		System.assertEquals(true, api.legDetailMap.get('hr3590-111').cosponsorIds.contains('B000287'));
		System.assertEquals(true, api.legDetailMap.get('hr3590-111').cosponsorIds.contains('B001231'));
		System.assertEquals(2, api.legislators.size());
		System.assertEquals(true, api.legislators.contains('B000287'));
		System.assertEquals(true, api.legislators.contains('B001231'));
		
		// No information for bill
		result = '{"page":{"per_page":20,"page":1,"count":1},"count":1,"funny":{"pretty":"much"}}';
		System.assertEquals(false, api.parseResult(result, APIMethod.BILL));
		System.assertEquals(1, api.recordCount);
		System.assertEquals(0, api.legDetailMap.size());
		
		// No pagination information
		result = '{"funny":{"pretty":"much"}}';
		System.assertEquals(false, api.parseResult(result, APIMethod.BILL));
		System.assertEquals(0, api.recordCount);
		System.assertEquals(0, api.legDetailMap.size());
		
		// Bad JSON result
		result = 'Bad JSON';
		System.assertEquals(false, api.parseResult(result, APIMethod.BILL));
		System.assertEquals(0, api.recordCount);
		System.assertEquals(0, api.legDetailMap.size());
	}
	
	static testMethod void testGetAmendment() {
		RealTimeCongressAPI api = new RealTimeCongressAPI();
		
		Boolean result = api.getAmendment('s', '555', '112');
		System.assertEquals(false, result);
	}
	
	static testMethod void testGetAmendments() {
		RealTimeCongressAPI api = new RealTimeCongressAPI();
		
		Boolean result = api.getAmendments(new List<String> { 'h123-112', 's567-111'});
		System.assertEquals(false, result);
	}
	
	static testMethod void testGetBill() {
		RealTimeCongressAPI api = new RealTimeCongressAPI();
		
		Boolean result = api.getBill('s', '888', '112');
		System.assertEquals(false, result);
	}
	
	static testMethod void testGetBills() {
		RealTimeCongressAPI api = new RealTimeCongressAPI();
		
		Boolean result = api.getBills(new List<String> { 'hr614-112', 's888-111'});
		System.assertEquals(false, result);
	}
	
}