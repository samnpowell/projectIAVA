@isTest
private class cov_event_marker_feed_controller_TESTS
{

	@isTest
	static void test_event_marker_feed()
	{

		IAVAEvent__c e1 = new IAVAEvent__c(
			Name='Test VT 1'
			, Type__c='VetTogether'
			, Status__c = 'Published'
			, Dont_create_Chatter_Group__c = false
			, Organizer_Type__c = 'Distributed'
			, Event_Public_Details__c ='These are the public details for e1'
			, Event_Date__c = System.today().addDays(3)
			);
		insert e1;
		System.debug('e1: ' + e1);

		IAVAEvent__c e2 = new IAVAEvent__c(
			Name='Test Social 2'
			, Type__c='Social'
			, Status__c = 'Unpublished'
			, Organizer_Type__c = 'Distributed'
			, Event_Public_Details__c ='These are the public details for e2'
			, Event_Date__c = System.today().addDays(2)
			);
		insert e2;
		System.debug('e2: ' + e2);

		IAVAEvent__c e3 = new IAVAEvent__c(
			Name='Test Support 3'
			, Type__c='Support'
			, Status__c = 'Published'
			, Organizer_Type__c = 'Distributed'
			, Event_Public_Details__c ='These are the public details for e3'
			, Event_Date__c = System.today().addDays(-38)
			);
		insert e3;
		System.debug('e3: ' + e3);


    	// now test that Give events get included on dashboard
        Partnership_Request__c p = new Partnership_Request__c(Name='Test Partnership', Public_Partner_Name__c='Test Public Name');
		insert p;
		Give__c g1 = new Give__c(Name='Test Give', National_Give__c = true, Partnership_Request__c = p.Id, Category__c='Events', Status__c='Open');
		//insert g1;
		Give__c g2 = new Give__c(Name='Test Give 2', National_Give__c = true, Partnership_Request__c = p.Id, Category__c = 'Giveaways');
		//insert g2;
		Give__c g3 = new Give__c(Name='Test Give 3', Status__c='Waitlist', Category__c = 'Events', Latitude__c=37.778687100000000, Longitude__c=-122.421242399999980, Zip_Code_s__c='94102', National_Give__c = false, Partnership_Request__c = p.Id);
		//insert g3;
		Give__c g4 = new Give__c(Name='Test Give 4', Status__c='Closed Invisible', National_Give__c = true, Partnership_Request__c = p.Id, Category__c = 'Events');
		//insert g4;
		insert new List<Give__c>{ g1, g2, g3, g4 };
		//system.debug('g4 v1: ' + [select Id, Status__c, Best_Status__c, (select Status__c from Give_Instances__r) from Give__c where Id = :g4.Id]);

		Give_Instance__c g1i1 = new Give_Instance__c(Give__c = g1.Id, Number_of_Units__c=5, Status__c='Open', Start_Date__c=System.today().addDays(-10));
		Give_Instance__c g1i2 = new Give_Instance__c(Give__c = g1.Id, Number_of_Units__c=5, Status__c='Open', Start_Date__c=System.today().addDays(10));
		Give_Instance__c g1i3 = new Give_Instance__c(Give__c = g1.Id, Number_of_Units__c=5, Status__c='Open', Start_Date__c=System.today().addDays(2));

		Give_Instance__c g2i1 = new Give_Instance__c(Give__c = g2.Id, Number_of_Units__c=3, Status__c='Open', Start_Date__c=System.today().addDays(-35));

		Give_Instance__c g3i1 = new Give_Instance__c(Give__c = g3.Id, Number_of_Units__c=3, Status__c='Open', Start_Date__c=System.today().addDays(45));

		Give_Instance__c g4i1 = new Give_Instance__c(Give__c = g4.Id, Number_of_Units__c=0, Status__c='Closed', Start_Date__c=System.today().addDays(5));

		insert new List<Give_Instance__c>{ g1i1, g1i2, g1i3, g2i1, g3i1, g4i1 };

		//Give__c queryGive = [select Id, Status__c, Best_Status__c, (select Status__c from Give_Instances__r) from Give__c where Id = :g4.Id];
		//system.debug('g4 v2: ' + queryGive);
		//system.debug('g4 instances size: ' + queryGive.Give_Instances__r.size());
		//system.debug('queryGive.Give_Instances__r[0]: ' + queryGive.Give_Instances__r[0]);



		User guestUser = cov_user_TEST_utility.getGuestUser();

		System.runAs(guestUser) {
			cov_event_marker_feed_controller controller = new cov_event_marker_feed_controller();

			// event e1 should show up but not e2 (unpublished) or c3 (too old)
			// give g1 should show up but not g2 (too old) or g3 (too far in advance) or g4 (closed)
			system.debug('controller.markers: ' + controller.markers);
			system.assertEquals(2, controller.markers.size());

			Map<Id, cov_event_marker_feed_controller.marker> markerMap = loadMap(controller.markers);
			system.assertEquals(true, compareEventAndMarker(e1, markerMap.get(e1.Id)));
			system.assertEquals(true, compareGiveAndMarker(g1, markerMap.get(g1.Id)));


			PageReference pageRef = Page.cov_event_marker_feed;
	        Test.setCurrentPage(pageRef);
	        ApexPages.CurrentPage().getParameters().put('startdate', String.valueOf(g2i1.Start_Date__c));
			
			controller = new cov_event_marker_feed_controller();

			// g2 should now show up since startdate goes back far enough
			system.debug('controller.markers: ' + controller.markers);
			system.assertEquals(3, controller.markers.size());
			markerMap = loadMap(controller.markers);
			system.assertEquals(true, compareEventAndMarker(e1, markerMap.get(e1.Id)));
			system.assertEquals(null, markerMap.get(e2.Id));
			system.assertEquals(null, markerMap.get(e3.Id));
			system.assertEquals(true, compareGiveAndMarker(g1, markerMap.get(g1.Id)));
			system.assertEquals(true, compareGiveAndMarker(g2, markerMap.get(g2.Id)));
			system.assertEquals(null, markerMap.get(g3.Id));
			system.assertEquals(null, markerMap.get(g4.Id));


			ApexPages.CurrentPage().getParameters().put('startdate', String.valueOf(e3.Event_Date__c));
			ApexPages.CurrentPage().getParameters().put('enddate', String.valueOf(System.today()));
			
			controller = new cov_event_marker_feed_controller();

			// e3 should now show up since startdate goes back far enough
			// but e1 should not since enddate is before it starts
			system.debug('controller.markers: ' + controller.markers);
			system.assertEquals(3, controller.markers.size());
			markerMap = loadMap(controller.markers);
			system.assertEquals(null, markerMap.get(e1.Id));
			system.assertEquals(null, markerMap.get(e2.Id));
			system.assertEquals(true, compareEventAndMarker(e3, markerMap.get(e3.Id)));
			system.assertEquals(true, compareGiveAndMarker(g1, markerMap.get(g1.Id)));
			system.assertEquals(true, compareGiveAndMarker(g2, markerMap.get(g2.Id)));
			system.assertEquals(null, markerMap.get(g3.Id));
			system.assertEquals(null, markerMap.get(g4.Id));

		}
	
		e2.Status__c = 'Published';
		update e2;
		g4i1.Status__c = 'Open';
		update g4i1; // show open g4 via workflow

		System.runAs(guestUser) {

			PageReference pageRef = Page.cov_event_marker_feed;
	        Test.setCurrentPage(pageRef);

			ApexPages.CurrentPage().getParameters().put('startdate', String.valueOf(System.today()));
			ApexPages.CurrentPage().getParameters().put('enddate', String.valueOf(System.today().addDays(50)));
			
			cov_event_marker_feed_controller controller = new cov_event_marker_feed_controller();

			// e1 should show up
			// e2 show show up now since published
			// e3 no since too old
			// g1 should show up
			// g2 no (too old)
			// g3 should show up now since end date is after
			// g4 should show up since now open
			system.debug('controller.markers: ' + controller.markers);
			system.assertEquals(5, controller.markers.size());
			Map<Id, cov_event_marker_feed_controller.marker> markerMap = loadMap(controller.markers);
			system.assertEquals(true, compareEventAndMarker(e1, markerMap.get(e1.Id)));
			system.assertEquals(true, compareEventAndMarker(e2, markerMap.get(e2.Id)));
			system.assertEquals(null, markerMap.get(e3.Id));
			system.assertEquals(true, compareGiveAndMarker(g1, markerMap.get(g1.Id)));
			system.assertEquals(null, markerMap.get(g2.Id));
			system.assertEquals(true, compareGiveAndMarker(g3, markerMap.get(g3.Id)));
			system.assertEquals(true, compareGiveAndMarker(g4, markerMap.get(g4.Id)));


			// test for invalid parameters
			ApexPages.CurrentPage().getParameters().put('startdate', 'ham');
			ApexPages.CurrentPage().getParameters().put('enddate', 'sandwich');

			controller = new cov_event_marker_feed_controller();

			// should go back to default start/end dates
			// e1 and e2 yes, e3 no (too old)
			// g1, g4 yes, g2 no (too old), g3 no (too far in advance)
			system.debug('controller.markers: ' + controller.markers);
			system.assertEquals(4, controller.markers.size());
			markerMap = loadMap(controller.markers);
			system.assertEquals(true, compareEventAndMarker(e1, markerMap.get(e1.Id)));
			system.assertEquals(true, compareEventAndMarker(e2, markerMap.get(e2.Id)));
			system.assertEquals(null, markerMap.get(e3.Id));
			system.assertEquals(true, compareGiveAndMarker(g1, markerMap.get(g1.Id)));
			system.assertEquals(null, markerMap.get(g2.Id));
			system.assertEquals(null, markerMap.get(g3.Id));
			system.assertEquals(true, compareGiveAndMarker(g4, markerMap.get(g4.Id)));


		}


	}

	static Boolean compareEventAndMarker(IAVAEvent__c evt, cov_event_marker_feed_controller.marker marker) {

		// requery to get all fields
		IAVAEvent__c evnt = [select Id, Name, Event_Date__c, Event_Relative_URL__c, Type__c, Thumbnail_image_URL__c
							, Location_Venue__c, Location_Street_Address__c, Location_City__c, Location_Zip_Code__c
							, Latitude__c, Longitude__c
							from IAVAEvent__c where Id = :evt.Id limit 1];

		system.debug('comparing Event and marker');
		system.debug('evnt: ' + evnt);
		system.debug('marker: ' + marker);
		if (evnt.Id != marker.recordId) return false;
		if (evnt.Name != marker.Name) return false;
		if (evnt.Event_Date__c.format() != marker.theDate) return false;
		if (Site.getBaseUrl() + '/' + evnt.Event_Relative_URL__c != marker.link) return false;
		if (evnt.Type__c != marker.type) return false;
		if (evnt.Thumbnail_image_URL__c != marker.imageURL) return false;
		if (evnt.Location_Venue__c != marker.venue) return false;
		if (evnt.Location_Street_Address__c != marker.street) return false;
		if (evnt.Location_City__c != marker.city) return false;
		if (evnt.Location_Zip_Code__c != marker.postalcode) return false;
		if (evnt.Latitude__c != marker.lat) return false;
		if (evnt.Longitude__c != marker.lon) return false;

		return true;
	}

	static Boolean compareGiveAndMarker(Give__c giv, cov_event_marker_feed_controller.marker marker) {

		Give__c g = [select Id, Name, Subcategory__c, Category__c, Earliest_Start_Date__c, Latest_End_Date__c
					, Location_Description__c, Location_Street_Address__c, City_Formula__c, Zip_Code__c, Latitude__c, Longitude__c
					, (select Id from Attachments)
					from Give__c where Id = :giv.Id limit 1];

		system.debug('comparing Give and marker');
		system.debug('g: ' + g);
		system.debug('marker: ' + marker);

		if (g.Id != marker.recordId) return false;
		if (g.Name != marker.Name) return false;
		if ('https://my.iava.org/cov_reward?giveid=' + g.Id != marker.link) return false;
		String typeValue = g.Subcategory__c != null ? g.Subcategory__c : g.Category__c;
		if (typeValue != marker.type) return false;
		String imageValue = g.Attachments.size() == 0 ? null : 'http://my.iava.org/servlet/servlet.FileDownload?file=' + g.Attachments[0].Id;
		if (imageValue != marker.imageURL) return false;
		if (g.Location_Description__c != marker.venue) return false;
		if (g.Location_Street_Address__c != marker.street) return false;
		if (g.City_Formula__c != marker.city) return false;
		if (g.Zip_Code__c != marker.postalcode) return false;
		if (g.Latitude__c != marker.lat) return false;
		if (g.Longitude__c != marker.lon) return false;

		String theDate;
		if (g.Earliest_Start_Date__c != null) {
			if (g.Earliest_Start_Date__c < System.today() && g.Latest_End_Date__c > System.today()) {
				// this might be strange if today is in between start/end dates of different instances, but close enough for now
				theDate = System.today().format();
			} else {
				theDate = g.Earliest_Start_Date__c.format();
			}
		}
		if (theDate != marker.theDate) return false;

		return true;
	}	

	// helper method to load the markers result into a map that allows each marker's result to be pulled by its key
	static Map<Id, cov_event_marker_feed_controller.marker> loadMap(List<cov_event_marker_feed_controller.marker> markerArg) {
		Map<Id, cov_event_marker_feed_controller.marker> returnMap = new Map<Id, cov_event_marker_feed_controller.marker>();
		for (cov_event_marker_feed_controller.marker mrk : markerArg) {
			returnMap.put(mrk.recordId, mrk);
		}
		return returnMap;
	}


}