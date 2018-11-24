/*
Copyright (c) 2010 Etherios LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are not permitted.

Author: Nick Koopman, nkoopman@etherios.com
*/
global class StringUtilities {

	public static Boolean ISnullORblank(String s)
	{
		return ((s == null) || (s == '') || (s.trim() == null) || (s.trim() == '')); 
	}

	static testMethod void ISnullORblankTest()
	{
		System.assertEquals(true, ISnullORblank(null));
		System.assertEquals(true, ISnullORblank(''));
		System.assertEquals(true, ISnullORblank(' '));
		System.assertEquals(false, ISnullORblank(' ['));
		System.assertEquals(false, ISnullORblank('NY'));
	}

	public static Boolean ValidZipCode5(String s)
	{
		if (ISnullORblank(s)) return false;
		if (s.length() != 5) return false;
		try
		{
			Integer i = Integer.valueOf(s);
			if ((i < 1) || ( i > 99999)) return false;
		}
		catch (exception ex)
		{
			return false;
		}
		return true;
	}

	static testMethod void ValidZipCode5Test()
	{
		System.assertEquals(true, ValidZipCode5('12345'));
		System.assertEquals(true, ValidZipCode5('00001'));
		System.assertEquals(true, ValidZipCode5('99999'));
		System.assertEquals(false, ValidZipCode5('123456'));
		System.assertEquals(false, ValidZipCode5('00000'));
		System.assertEquals(false, ValidZipCode5('-1234'));
		System.assertEquals(false, ValidZipCode5(null));
		System.assertEquals(false, ValidZipCode5('x y z'));
	}

	public static Boolean ValidInteger(String s)
	{
		try { Integer i = Integer.valueOf(s); } catch (exception e) { return false; }
		return true;
	}

	static testMethod void ValidIntegerTest()
	{
		System.assertEquals(true, ValidInteger('12345'));
		System.assertEquals(true, ValidInteger('00001'));
		System.assertEquals(true, ValidInteger('99999'));
		System.assertEquals(true, ValidInteger('123456'));
		System.assertEquals(true, ValidInteger('00000'));
		System.assertEquals(true, ValidInteger('-1234'));
		System.assertEquals(false, ValidInteger(null));
		System.assertEquals(false, ValidInteger('x y z'));
	}

	public static Boolean ValidDouble(String s)
	{
		try { Double d = Double.valueOf(s); } catch (exception e) { return false; }
		return true;
	}

	static testMethod void ValidDoubleTest()
	{
		System.assertEquals(true, ValidDouble('12345'));
		System.assertEquals(true, ValidDouble('0.001'));
		System.assertEquals(true, ValidDouble('99.99'));
		System.assertEquals(true, ValidDouble('12345.'));
		System.assertEquals(true, ValidDouble('00000'));
		System.assertEquals(true, ValidDouble('-1234'));
		System.assertEquals(false, ValidDouble(null));
		System.assertEquals(false, ValidDouble('x y z'));
	}

	public static Boolean ValidDecimal(String s)
	{
		try { Decimal d = Decimal.valueOf(s); } catch (exception e) { return false; }
		return true;
	}

	static testMethod void ValidDecimalTest()
	{
		System.assertEquals(true, ValidDecimal('12345'));
		System.assertEquals(true, ValidDecimal('0.001'));
		System.assertEquals(true, ValidDecimal('99.99'));
		System.assertEquals(true, ValidDecimal('12345.'));
		System.assertEquals(true, ValidDecimal('00000'));
		System.assertEquals(true, ValidDecimal('-1234'));
		System.assertEquals(false, ValidDecimal(null));
		System.assertEquals(false, ValidDecimal('x y z'));
	}
}