[h: obj = arg (0)]
[h, if (argCount() > 1): unspecifiedValue = arg (1); unspecifiedValue = "-1"]
[h, if (argCount() > 2): protectedKeys = arg (2); protectedKeys = "[]"]
[h: o5e_ExtDB_Constants (getMacroName())]
[h: unspecArray = json.append ("[]", "", unspecifiedValue)]
[h: log.debug (CATEGORY + "unspecArray = " + unspecArray)]
[h: objType = json.type (obj)]
[h, if (objType == "OBJECT"), code: {
	[fields = json.fields (obj, "json")]
	[fields = json.removeAll (fields, protectedKeys)]
	[foreach (field, fields), code: {
		[value = json.get (obj, field)]
		[if (json.type (value) == "UNKNOWN"): 
				encodedValue = value;
				encodedValue = encode (value)]
		[if (json.contains (unspecArray, encodedValue)): unspecified = 1; unspecified = 0]
		[log.debug (CATEGORY + "encodedValue = " + encodedValue + "; unspecified = " + unspecified)]
		<!-- Ye old Too Much Nesting dance -->
		[if (unspecified): obj = json.remove (obj, field)]
		[if (!unspecified): 
				value = o5e_ExtDB_stripUnspecified (value, unspecifiedValue, protectedKeys)]
		[if (!unspecified):
				obj = json.set (obj, field, value)]
	}]
}; {}]

[h: macro.return = obj]