public class QueryCriteria {

	public String Criteria = '';
		
	// addToCriteria builds upon Query Criteria

	public String addTo(String newCriteria)
	{
		if ((newCriteria == null) || (newCriteria == '')) return Criteria; 
		if ((Criteria == null) || (Criteria == ''))
			Criteria += 'WHERE ' + newCriteria;
		else
			Criteria += ' AND ' + newCriteria;
		return Criteria; 
	}

	// listCriteria builds a Criteria like this ((field == 's1') OR (field == 's2')) etc.

	public static String listCriteria(String field, List<String> values)
	{
		if ((field == null) || (field == '') || (values == null) || (values.size() == 0)) return null;
		String built = '';
		if (values.size() > 1) built += '(';
		for (Integer i = 0; i < values.size(); i++)
		{
			if (i > 0) built += ' OR ';
			built += '(' + field + ' = ' + '\'' + values[i] + '\')';
		}
		if (values.size() > 1) built += ')';
		return built;
	}

	// likeCriteria builds a Criteria like this ((field LIKE 's1%') OR (field LIKE 's2%')) etc.
	/* unused
	public static String likeCriteria(String field, List<String> values)
	{
		if ((field == null) || (field == '') || (values == null) || (values.size() == 0)) return null;
		String built = '';
		if (values.size() > 1) built += '(';
		for (Integer i = 0; i < values.size(); i++)
		{
			if (i > 0) built += ' OR ';
			built += '(' + field + ' LIKE ' + '\'' + values[i] + '%\')';
		}
		if (values.size() > 1) built += ')';
		return built;
	}
	*/
	// multiPicklistCriteria builds a Criteria like this ((field includes ('s1')) OR (field includes ('s2')) etc.

	public static String multiPicklistCriteria(String field, List<String> values)
	{
		if ((field == null) || (field == '') || (values == null) || (values.size() == 0)) return null;
		String built = '';
		if (values.size() > 1) built += '(';
		for (Integer i = 0; i < values.size(); i++)
		{
			if (i > 0) built += ' OR ';
			built += '(' + field + ' includes ' + '(\'' + values[i] + '\'))';
		}
		if (values.size() > 1) built += ')';
		return built;
	}

	// setCriteria builds a Criteria like this ((field == 's1') OR (field == 's1')) etc.

	public static String setCriteria(String field, Set<String> values)
	{
		if ((field == null) || (field == '') || (values == null) || (values.size() == 0)) return null;
		List<String> stringList = new List<String>();
		for (String value : values) stringList.add(value);
		return listCriteria(field, stringList);
	}

	// likeSetCriteria builds a Criteria like this ((field LIKE 's1%') OR (field LIKE 's1%')) etc.
	/* unused
	public static String likeSetCriteria(String field, Set<String> values)
	{
		if ((field == null) || (field == '') || (values == null) || (values.size() == 0)) return null;
		List<String> stringList = new List<String>();
		for (String value : values) stringList.add(value);
		return likeCriteria(field, stringList);
	}
	*/
	// multiPicklistCriteria builds a Criteria like this ((field includes ('s1')) OR (field includes ('s2')) etc.

	public static String multiPicklistCriteria(String field, Set<String> values)
	{
		if ((field == null) || (field == '') || (values == null) || (values.size() == 0)) return null;
		List<String> stringList = new List<String>();
		for (String value : values) stringList.add(value);
		return multiPicklistCriteria(field, stringList);
	}
	
}