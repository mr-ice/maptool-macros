<!-- Prompt for source library -->
[h: l4m.Constants()]
[h: CATEGORY = getMacroName() + "." + LIB_LOG4MT]
[h: clientInfo = getInfo ("client")]
[h: libTokensObj = json.get (clientInfo, "library tokens")]
[h: libTokenFields = json.fields (libTokensObj, "json")]
<!-- Remove this token and the proxy tokens -->

[h: toRemove = json.append ("[]", LIB_LOG4MT)]
[h, foreach (libTokenField, libTokenFields), code: {
	[if (matches (libTokenField, PROXY_LIB_PATTERN)): 
		toRemove = json.append (toRemove, libTokenField)]
}]

[h: libTokenFields = json.removeAll (libTokenFields, toRemove)]

[h: inputStr = "junk | Input Source Library to profile and target proxy | | Label | span=true"]
[h: inputStr = inputStr + "## libTokenName | " + libTokenFields + " | Token Library | LIST | DELIMITER=JSON VALUE=STRING "]

<!-- Prompt for target Proxy Library -->
[h: l4m.debug (CATEGORY, "inputStr = " + inputStr)]

[h: validSelection = 0]
[h, while (!validSelection), code: {
	[abort (input (inputStr))]
	[proxyTokenName = l4m.getProxyTokenName (libTokenName)]
	<!-- Confirm selections -->
	[validSelection = input ("junk | <html>Please confirm your choices before continuing. WARNING: all macros on <b>" + 
		proxyTokenName + "</b> will be <font color='red'><b>DELETED</b></font></html>| | LABEL | span=true",
		"junk | " + libTokenName + " | Source Library To Profile | LABEL")]
}]

<!-- Initialize the proxy token -->
[h: proxyTokenId = l4m.initProxyLibrary (libTokenName)]

<!-- Build/Update the Configuration object -->
[h: currentConfig = l4m.getWrapperConfig (proxyTokenName)]
[h: existingUdfCfg = json.fields (currentConfig)]

[h: l4m.debug (CATEGORY, "libTokenName = " + libTokenName)]
[h, token (libTokenName), code: {
	[libMacros = getMacros ()]
	[libTokenId = currentToken()]
}]

<!-- Interrogate Client for user defined functions, locating all those defined for source token -->
[h: libUdfNames = "[]"]
[h: clientInfo = getInfo ("client")]
[h: clientUdfs = json.get (clientInfo, "user defined functions")]

[h, foreach (clientUdfName, json.fields (clientUdfs)), code: {
	<!-- will be KVP of UDF - Macro-location -->
	[udfMacro = json.get (clientUdfs, clientUdfName)]
	[udfLocation = listGet (udfMacro, 1, "@")]
	[if (udfLocation == libTokenName): libUdfNames = json.append (libUdfNames, clientUdfName), ""]
}]

[h: l4m.info (CATEGORY, "Configuring UDFs in proxy token - " + json.indent (libUdfNames))]

[h: defaultConfigParams = json.set ("", "newScope", 1, "ignoreOutput", 0)]
[h, foreach (udfMacro, libUdfNames), code: {
	[if (!json.contains (existingUdfCfg, udfMacro)), code: {
		[currentConfig = json.set (currentConfig, udfMacro, defaultConfigParams)]
	}; {}]
}]

<!-- Store the configuration on the token -->
[h: l4m.setWrapperConfig (proxyTokenName, currentConfig)]

<!-- Launch the Config Wrapper macro -->
[h, macro ("Configure Wrappers@this"): json.append ("", proxyTokenName)]
[h: l4m.buildWrapperMacros (proxyTokenName)]