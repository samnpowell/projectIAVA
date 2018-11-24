/*
Copyright (c) 2010 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Nick Koopman, nkoopman@etherios.com
*/
public class JSON {

	// Utilies for working with JSON

	public static String str(String value)	// Need to escape backslashes, double quotes, and forward slashes ...
	{
		// System.Debug('JSON str input:\n' + value + '\n');
		if ((value == null) || (value == '')) return value;
		String out = value;
		// out = out.replace('\\', '\\\\');	// replace single \ with \\
		out = out.replace('"', '\\"');		// replace single " with \"
		// out = out.replace('/', '\\/');	// replace single / with \/
		// System.Debug('JSON str output:\n' + out + '\n');
		return out; 
	}

	static testMethod void strTest()
	{
		System.assertEquals(null, str(null));
		System.assertEquals('', str(''));
		System.assertEquals('\\" \\"\\"', str('" ""'));
		System.assertEquals('<a href=\\"www.starbucks.com\\">YUMMY</a>', str('<a href="www.starbucks.com">YUMMY</a>'));
	}

	public static String outputField(String fieldName, Boolean value)
	{
		String out = '{"fieldname": "' + fieldName + '", "value": ';
		if (value != null) out += value;
		out += '}';
		return out;
	}

	static testMethod void outputBooleanFieldTest()
	{
		System.assertEquals('{"fieldname": "myfield", "value": true}', outputField('myfield', true));
	}
	
	public static String SoutputField(String fieldName, Boolean value)	// As a String
	{
		String out = '{"fieldname": "' + fieldName + '", "value": "';
		if (value != null) out += value;
		out += '"}';
		return out;
	}
	
	static testMethod void SoutputBooleanFieldTest()
	{
		System.assertEquals('{"fieldname": "myfield", "value": "true"}', SoutputField('myfield', true));
	}
	
	public static String outputField(String fieldName, Date value)
	{
		String out = '{"fieldname": "' + fieldName + '", "value": ';
		if (value != null) out += value.format();
		out += '}';
		return out;
	}
	
	static testMethod void outputDateFieldTest()
	{
		System.assertEquals('{"fieldname": "myfield", "value": 12/21/2012}', outputField('myfield', date.parse('12/21/2012')));
	}

	public static String SoutputField(String fieldName, Date value)		// As a String
	{
		String out = '{"fieldname": "' + fieldName + '", "value": "';
		if (value != null) out += value.format();
		out += '"}';
		return out;
	}
	
	static testMethod void SoutputDateFieldTest()
	{
		System.assertEquals('{"fieldname": "myfield", "value": "12/21/2012"}', SoutputField('myfield', date.parse('12/21/2012')));
	}

	public static String outputField(String fieldName, Decimal value)
	{
		String out = '{"fieldname": "' + fieldName + '", "value": ';
		if (value != null) out += value;
		out += '}';
		return out;
	}
	
	static testMethod void outputDecimalFieldTest()
	{
		System.assertEquals('{"fieldname": "myfield", "value": 123.456}', outputField('myfield', 123.456));
	}

	public static String SoutputField(String fieldName, Decimal value)	// As a String
	{
		String out = '{"fieldname": "' + fieldName + '", "value": "';
		if (value != null) out += value;
		out += '"}';
		return out;
	}
	
	static testMethod void SoutputDecimalFieldTest()
	{
		System.assertEquals('{"fieldname": "myfield", "value": "123.456"}', SoutputField('myfield', 123.456));
	}

	public static String outputField(String fieldName, String value)	// Native String
	{
		return SoutputField(fieldName, value);
	}
	
	public static String SoutputField(String fieldName, String value)	// Native String (for Compatibility with previous ver)	
	{
		String out = '{"fieldname": "' + fieldName + '", "value": "';
		if (value != null) out += str(value);
		out += '"}';
		return out;
	}

	static testMethod void outputStringFieldTest()
	{
		System.assertEquals('{"fieldname": "myfield", "value": "myvalue"}', outputField('myfield', 'myvalue'));
	}
	
	public static String outputFlatMap(Map<String, String> fields)
	{
		String out = '';
		if (fields != null)
		{
			out += '{';
			for (String key : fields.keySet())
			{
				if (!out.endsWith('{')) out += ', ';
				String value = fields.get(key);
				if (value == null) value = '';
				out += '"' + key + '": "' + value + '"';
			}  
			out += '}';
		}
		return out;
	}
	
	static testMethod void outputFlatMapTest()
	{
		Map<String, String> testMap = new Map<String, String>();
		testMap.put('myfield1', 'value1');
		testMap.put('myfield2', null);
		String testString = outputFlatMap(testMap);
		Boolean test = (	// Can't guarantee the order that they're output ...
			(testString == '{"myfield1": "value1", "myfield2": ""}') ||
			(testString == '{"myfield2": "", "myfield1": "value1"}'));
		System.assertEquals(true, test);
	}
	
}