public with sharing class StatAction {
// Developed by Richard Saunders, Exponent Partners, for IAVA 2011

	// Function to set the most recent measurement Amount__c on the st record
	public static void SetMeasurementAmount(Id statId) {
		
		Stat__c st;
		Stat_Measurement__c sm;
		
		// Get the st record
		try {
			st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:statId limit 1];
		} catch (QueryException e) {
			system.debug('No st record found for id: '+statId);
			return;
		}
		
		system.debug('TESTING>>> stat: '+st);
		
		// get the related st measurements
		List<Stat_Measurement__c> smlist;
		try {
			smlist = [select id, Name, Measurement_Date__c, Start_Date__c, End_Date__c, Amount__c 
											from Stat_Measurement__c
											where Stat__c =: statId											
											and (Measurement_Date__c!=null or End_Date__c!=null or Start_Date__c!=null) 
											order by Measurement_Date__c desc, Name desc
											];
											//limit 1];
		} catch (QueryException e) {
			system.debug('No st measurement records found for st: '+st);
		}
		for (Stat_Measurement__c s : smlist)
			system.debug('TESTING>>> smlist item: '+s);
		if (smlist.size() > 0) sm = smlist[0];
		system.debug('TESTING>>> sm: ' + sm);
		
		// assign the most recent Amount__c and date
		if (sm == null) {
			st.Most_Recent_Amount__c = null;
			st.Measurement_Amount_Date__c = null;
			
		} else {
			st.Most_Recent_Amount__c = sm.Amount__c;
			st.Measurement_Amount_Date__c = (sm.Measurement_Date__c != null) ? sm.Measurement_Date__c : ((sm.End_Date__c != null) ? sm.End_Date__c : sm.Start_Date__c);
		} 
		
		// update the st record
		update st;
		
	}

// ******** Tests ***********
	static testMethod void testSetMeasurementAmount() {
		
		Stat__c st = new Stat__c();
		insert st;
		
		// first test
		Stat_Measurement__c sm1 = new Stat_Measurement__c(
			Stat__c = st.id,
			Amount__c = 1,
			//Measurement_Date__c = null, NOTE: Currently config sets TODAY() be default and has this as a required field
			Measurement_Date__c = system.today() - 1000 		
		);
		insert sm1;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm1.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm1.Measurement_Date__c, st.Measurement_Amount_Date__c);
		
		// second test
		Stat_Measurement__c sm2 = new Stat_Measurement__c(
			Stat__c = st.id,
			Amount__c = 2,
			Measurement_Date__c = system.today() - 1000,		
			Start_Date__c = system.today() - 20			
		);
		insert sm2;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm2.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm2.Measurement_Date__c, st.Measurement_Amount_Date__c);
		
		// third test
		Stat_Measurement__c sm3 = new Stat_Measurement__c(
			Stat__c = st.id,
			Amount__c = 3,
			Measurement_Date__c = system.today() - 1000,
			Start_Date__c = system.today() - 20			
		);
		insert sm3;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm3.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm3.Measurement_Date__c, st.Measurement_Amount_Date__c);
		
		// fourth test
		Stat_Measurement__c sm4 = new Stat_Measurement__c(
			Stat__c = st.id,
			Amount__c = 4,
			Measurement_Date__c = system.today() - 1000,
			End_Date__c = system.today() - 30			
		);
		insert sm4;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm4.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm4.Measurement_Date__c, st.Measurement_Amount_Date__c);
		
		// fifth test
		Stat_Measurement__c sm5 = new Stat_Measurement__c(
			Stat__c = st.id,
			Amount__c = 5,
			Measurement_Date__c = system.today() - 40			
		);
		insert sm5;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm5.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm5.Measurement_Date__c, st.Measurement_Amount_Date__c);
		
		// sixth test
		Stat_Measurement__c sm6 = new Stat_Measurement__c(
			Stat__c = st.id,
			Amount__c = 6,
			Measurement_Date__c = system.today() - 10,
			End_Date__c = system.today() - 8,	
			Start_Date__c = system.today() - 6			
		);
		insert sm6;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm6.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm6.Measurement_Date__c, st.Measurement_Amount_Date__c);
		
		// seventh test
		Stat_Measurement__c sm7 = new Stat_Measurement__c(
			Stat__c = st.id,
			Amount__c = 7,
			Measurement_Date__c = system.today() - 9
		);
		insert sm7;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm7.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm7.Measurement_Date__c, st.Measurement_Amount_Date__c);
		
		// eighth test
		Stat_Measurement__c sm8 = new Stat_Measurement__c(
			Stat__c = st.id,
			Amount__c = 8,
			Measurement_Date__c = system.today() - 9,
			End_Date__c = system.today() - 9
		);
		insert sm8;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm8.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm8.Measurement_Date__c, st.Measurement_Amount_Date__c);
		
		// nineth test
		Stat_Measurement__c sm9 = new Stat_Measurement__c(
			Stat__c = st.id,
			Amount__c = 9,
			Measurement_Date__c = system.today() - 1000
		);
		insert sm9;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm8.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm8.Measurement_Date__c, st.Measurement_Amount_Date__c);
		
		// tenth test
		sm9.Measurement_Date__c = system.today() - 8;
		sm9.End_Date__c = system.today() - 9;
		update sm9;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm9.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm9.Measurement_Date__c, st.Measurement_Amount_Date__c);
		
		// eleventh test
		delete sm9;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm8.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm8.Measurement_Date__c, st.Measurement_Amount_Date__c);
		
		// twelth test
		delete sm8;
		
		st = [select id, Measurement_Amount_Date__c, Most_Recent_Amount__c 
					from Stat__c 
					where id=:st.id limit 1];
		system.assertEquals(sm7.Amount__c, st.Most_Recent_Amount__c);
		system.assertEquals(sm7.Measurement_Date__c, st.Measurement_Amount_Date__c);
	}
}