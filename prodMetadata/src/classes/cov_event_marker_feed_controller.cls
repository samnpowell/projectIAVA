public without sharing class cov_event_marker_feed_controller {

	Public List<marker> markers {get; set;}

	public cov_event_marker_feed_controller() {
		markers = new List<marker>();
		loadEvents();
	}


	public class marker implements Comparable {
		public Id recordId {get; set;}
		public String Name {get; set;}
		public String theDate {get; set;}
		public String link {get; set;}
		public String type {get; set;}
        // lines 17-18 added 2016-10-27 by SP for IAVA Endorsed Event flags
        public Boolean isEndorsed {get; set;}
		//public Boolean hasImage {get; set;}
		public String imageURL {get; set;}
		public String venue {get; set;}
		public String street {get; set;}
		public String city {get; set;}
		public String postalcode {get; set;}
		public Double lat {get; set;}
		public Double lon {get; set;}


		public marker(IAVAEvent__c evnt) {
			recordId = evnt.Id;
			Name = evnt.Name;
			theDate = evnt.Event_Date__c == null ? null : evnt.Event_Date__c.format();
			type = evnt.Type__c;
            // lines 34-35 added 2016-10-27 by SP for IAVA Endorsed Event flags
            isEndorsed = evnt.isIAVAEndorsed__c;
			venue = evnt.Location_Venue__c;
			street = evnt.Location_Street_Address__c;
			city = evnt.Location_City__c;
			postalcode = evnt.Location_Zip_Code__c;
			lat = evnt.Latitude__c;
			lon = evnt.Longitude__c;
			link = Site.getBaseUrl() + '/' + evnt.Event_Relative_URL__c;
			imageURL = evnt.Thumbnail_image_URL__c;

			//hasImage = false;
			//String fullImageId;

			//system.debug('evnt.Attachments: ' + evnt.Attachments);
			//while (i < evnt.Attachments.size() && !hasImage) {
			//	if (!hasImage && evnt.Attachments[i].Name == 'image-thumb') {
			//		system.debug('we have a thumbnail');
			//		imageURL = 'servlet/servlet.FileDownload?file=' + evnt.Attachments[i].Id;
			//		hasImage = true;
			//	} else if (!hasImage && fullImageId == null && evnt.Attachments[i].Name == 'image-full') {
			//		system.debug('full image');
			//		fullImageId = evnt.Attachments[i].Id;
			//	}
			//}
			//if (!hasImage && fullImageId == null) {
			//	imageURL = 'servlet/servlet.FileDownload?file=' + fullImageId;
			//	hasImage = true;
			//}
		}

		public marker(Give__c g) {
			recordId = g.Id;
			Name = g.Name;
			theDate = null;
			if (g.Earliest_Start_Date__c != null) {
				if (g.Earliest_Start_Date__c < System.today() && g.Latest_End_Date__c > System.today()) {
					// this might be strange if today is in between start/end dates of different instances, but close enough for now
					theDate = System.today().format();
				} else {
					theDate = g.Earliest_Start_Date__c.format();
				}
			}

			type = g.Subcategory__c != null ? g.Subcategory__c : g.Category__c;
			venue = g.Location_Description__c;
			street = g.Location_Street_Address__c;
			city = g.City_Formula__c;
			postalcode = g.Zip_Code__c;
			lat = g.Latitude__c;
			lon = g.Longitude__c;
			//link = Site.getBaseUrl() + '/' + g.Event_Relative_URL__c;
			link = 'https://my.iava.org/cov_reward?giveid=' + g.Id;
			imageURL = g.Attachments.size() == 0 ? null : 'http://my.iava.org/servlet/servlet.FileDownload?file=' + g.Attachments[0].Id;
		}

		public Integer compareTo(Object compareTo) {
			marker compareToMarker = (marker)compareTo;
	        if (theDate == compareToMarker.theDate) return 0;
	        if (theDate > compareToMarker.theDate) return 1;
	        return -1;  
		}

	}


	public void loadEvents() {

		String startdateString = ApexPages.CurrentPage().getParameters().get('startdate');
		String enddateString = ApexPages.CurrentPage().getParameters().get('enddate');

		Date startdate;
		if (startdateString != null && startdateString != '') {
			try {
				startdate = Date.valueOf(startdateString);
			} catch (Exception e) {
				system.debug('startdate parameter was invalid: ' + startdateString);
			}
		}
		startdateString = startdate == null ? String.valueOf(Date.today()) : startdateString;

		Date enddate;
		if (enddateString != null && enddateString != '') {
			try {
				enddate = Date.valueOf(enddateString);
			} catch (Exception e) {
				system.debug('enddate parameter was invalid: ' + enddateString);
			}
		}
		enddateString = enddate == null ? String.valueOf(Date.today().addDays(31)) : enddateString;


		String theQuery = 'select Id' 
						+ ', Name, Location_Venue__c, Location_Street_Address__c, Location_City__c, Location_Zip_Code__c'
						+ ', Event_Date__c, Type__c'
                        // lines 129-130 added 2016-10-27 by SP for IAVA Endorsed Event flags
            			+ ', isIAVAEndorsed__c'
						+ ', Latitude__c, Longitude__c'
						+ ', Thumbnail_image_URL__c'
						+ ', Event_Relative_URL__c'
						+ ', (select Id, Name from Attachments where name like \'%image%\' order by CreatedDate DESC)'
						+ ' from IAVAEvent__c'
						+ ' where Status__c = \'Published\''
						+ ' and Do_not_show_in_public_event_marker_feed__c = false'
						;

		theQuery += ' and Event_Date__c >= ' + startdateString
				+ ' and Event_Date__c <= ' + enddateString;

		system.debug('theQuery: ' + theQuery);

		List<IAVAEvent__c> theEvents = Database.query(theQuery);

		for (IAVAEvent__c ev : theEvents) {
			markers.add(new marker(ev));
		}


		String giveQuery = 'select Id' 
						+ ', Name, Earliest_Start_Date__c, Latest_End_Date__c, Category__c, Subcategory__c'
						+ ', Location_Description__c, Location_Street_Address__c, City_Formula__c, Zip_Code__c'
						+ ', Type__c'
						+ ', Latitude__c, Longitude__c'
						+ ', (select Id, Name from Attachments where name like \'%logo%\' order by CreatedDate DESC)'
						+ ' from Give__c'
						+ ' where (Status__c = \'Open\' or Status__c = \'Waitlist\')'
						//+ ' and Do_not_show_in_public_event_marker_feed__c = false'
						;

		giveQuery += ' and ('
				+ '(Earliest_Start_Date__c >= ' + startdateString
				+ ' and Earliest_Start_Date__c <= ' + enddateString + ')'
				+ ' or (Latest_Start_Date__c >= ' + startdateString
				+ ' and Latest_Start_Date__c <= ' + enddateString + ')'
				+ ' or (Latest_End_Date__c >= ' + startdateString
				+ ' and Latest_End_Date__c <= ' + enddateString + ')'
				+ ')';

		system.debug('giveQuery: ' + giveQuery);

		List<Give__c> theGives = Database.query(giveQuery);

		system.debug('theGives: ' + theGives);

		for (Give__c gv : theGives) {
			markers.add(new marker(gv));
		}

		markers.sort();


	}
}