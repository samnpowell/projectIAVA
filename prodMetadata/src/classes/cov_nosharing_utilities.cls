public without sharing class cov_nosharing_utilities {
	// for methods that require "without sharing"


	public static sObject runSingleQuery(String s) {
		sObject objectReturn;
		try {
			system.debug('about to run a single Query using this query string: ' + s);
			objectReturn = Database.query(s);
		} catch (QueryException e) {
			system.debug('No results returned from runSingleQuery: ' + s);
		} catch (Exception e) { cov_log_error.logError(e); }
		return objectReturn;
	}

	public static List<sObject> runListQuery(String s) {
		List<sObject> listReturn;
		try {
			system.debug('about to run a list Query using this query string: ' + s);
			listReturn = Database.query(s);
			system.debug('query successful: ' + listReturn);
		} catch (Exception e) { 
			cov_log_error.logError(e, 'error in cov_nosharing_utilities running this list query: ' + s); 
			system.debug('query unsuccessful. e: ' + e); 
		}
		return listReturn;
	}


	public static Database.SaveResult runDatabaseUpdate(sObject recordToUpdate, Boolean opt_allOrNone) {
		return Database.update(recordToUpdate, opt_allOrNone);
	}

	public static List<Database.SaveResult> runDatabaseUpdate(List<sObject> recordsToUpdate, Boolean opt_allOrNone) {
		return Database.update(recordsToUpdate, opt_allOrNone);
	}

	public static Database.SaveResult runDatabaseInsert(sObject recordToInsert, Boolean opt_allOrNone) {
		return Database.insert(recordToInsert, opt_allOrNone);
	}

	public static List<Database.SaveResult> runDatabaseInsert(List<sObject> recordsToInsert, Boolean opt_allOrNone) {
		return Database.insert(recordsToInsert, opt_allOrNone);
	}


	public static List<Database.UpsertResult> runDatabaseUpsert(List<sObject> recordsToUpsert, Boolean opt_allOrNone) {
		//String objectName = recordsToUpsert[0].getSObjectType().getDescribe().getName();
		return Database.upsert(recordsToUpsert, opt_allOrNone);
	}

	// couldnt get these generic upserts to work
	//public static Database.UpsertResult runDatabaseUpsert(sObject recordToUpsert, String fieldName, Boolean opt_allOrNone) {
	//	String objectName = recordToUpsert.getSObjectType().getDescribe().getName();
	//	return Database.upsert(recordToUpsert, findFieldFromName(objectName, fieldName), opt_allOrNone);
	//}

	//public static List<Database.UpsertResult> runDatabaseUpsert(List<sObject> recordsToUpsert, String fieldName, Boolean opt_allOrNone) {
	//	String objectName = recordsToUpsert[0].getSObjectType().getDescribe().getName();
	//	return Database.upsert(recordsToUpsert, findFieldFromName(objectName, fieldName), opt_allOrNone);
	//}

	//public static Schema.SObjectField findFieldFromName(String sobjName, String s) {
	//	SObjectType objType = Schema.getGlobalDescribe().get(sobjName);
	//	Map<String,Schema.SObjectField> mfields = objType.getDescribe().fields.getMap();
	//	return mfields.get(s);
	//}


}