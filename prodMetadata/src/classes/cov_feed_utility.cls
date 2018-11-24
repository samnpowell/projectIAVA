public without sharing class cov_feed_utility {


	public static Boolean deleteFeedItem(String criterionString) {
		return deleteFeedItems(null, new List<String>{criterionString});
	}

	public static Boolean deleteFeedItem(String tableName, String criterionString) {
		return deleteFeedItems(tableName, new List<String>{criterionString});
	}

	public static Boolean deleteFeedItems(List<String> criteriaStrings) {
		return deleteFeedItems(null, criteriaStrings);
	}

	public static Boolean deleteFeedItems(String tableName, List<String> criteriaStrings) {

		if (tableName == null) {
			tableName = 'FeedItem';
		}

		String q = 'select Id, CreatedDate from ' + tableName + ' where';

		for (Integer i = 0; i < criteriaStrings.size(); i ++) {
			if (i > 0 ) {
				q+= ' or';
			}
			q+= ' (' + criteriaStrings[i] + ')';
		}

		system.debug('query for deleting feeditem(s): ' + q);

		List<sObject> fs;
		try {
			fs = Database.query(q);
		} catch(Exception e) { cov_log_error.logError(e); return false; }

		if (fs.size() > 0) {
			try {
				system.debug('about to delete feeditems: ' + fs);
    			delete fs;
    			system.debug('deleted.');
    			return true;
    		} catch (Exception e) { cov_log_error.logError(e); return false; }
		} else {
			return false;
		}	
	}



}