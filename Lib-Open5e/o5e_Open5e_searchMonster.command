[h: searchTerm = arg (0)]
[h: o5e_Constants (getMacroName())]
[h, if (startsWith (searchTerm, "o5et_Data")), code: {
	[record = o5e_Open5e_get (searchTerm)]
	<!-- If it doesnt exist, it errors out. So assume a result of 1 -->
	[results = json.set ("", "count", 1, "results", json.append ("[]", record))]
}; {
	[encoded = encode (searchTerm)]
	[log.debug (CATEGORY + "## encoded = " + encoded)]
	[results = o5e_Open5e_get ("monsters?search=" + encoded)]
}]
[h: macro.return = results]
