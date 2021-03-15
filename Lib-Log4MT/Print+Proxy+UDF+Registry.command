[h, if (argCount() > 0): selectedLibToken = arg (0); selectedLibToken = ""]
[h: l4m.Constants()]
[h: CATEGORY = getMacroName() + "." + LIB_LOG4MT]
[h: l4m.debug (CATEGORY, "selectedLibToken = " + selectedLibToken)]
<!-- For which Proxy token -->
[h: clientInfo = getInfo ("client")]
[h: libTokensObj = json.get (clientInfo, "library tokens")]
[h: libTokenFields = json.fields (libTokensObj, "json")]
[h: proxyLibraries = "[]"]

[h, foreach (libTokenField, libTokenFields), code: {
	[if (matches (libTokenField, PROXY_LIB_PATTERN)): 
		proxyLibraries = json.append (proxyLibraries, libTokenField)]
}]
[h, if (selectedLibToken == ""), code: {
	[if (json.isEmpty (proxyLibraries)): assert (0, "<font color='red'><b>Wrappers must be installed on a proxy token, first!</b></font>", 0)]
	[abort (input ("selectedLibToken | " + proxyLibraries + " | Select proxy library | LIST | DELIMITER=JSON VALUE=STRING"))]
}; {}]

[h: l4m.debug (CATEGORY, "selectedLibToken = " + selectedLibToken)]
[h: l4m.printUDFRegistry (selectedLibToken)]