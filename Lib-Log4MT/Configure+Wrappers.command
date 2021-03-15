[h, if (argCount() > 0): selectedLibToken = arg (0); selectedLibToken = ""]
[h, if (argCount() > 1): useBulkImport = arg (1); useBulkImport = 0]
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
	[abort (input ("selectedLibToken | " + proxyLibraries + " | Select proxy library | LIST | DELIMITER=JSON VALUE=STRING",
	"useBulkImport | | Use bulk configuration | CHECK"))]
}; {}]

[h: l4m.debug (CATEGORY, "selectedLibToken = " + selectedLibToken)]
[h, if (useBulkImport), code: {
	[l4m.bulkConfigureWrappers (selectedLibToken)]
	[return (0)]
}]

<!-- Get the cofig json from that token -->
[h: configuration = l4m.getWrapperConfig (selectedLibToken)]

<!-- Display an awesome Input of that config -->
[h: funcVarMap = "{}"]
[h: funcIndex = 0]
[h: inputString = " overwriteFunctions | 0 | Immediately Overwrite Original Functions | CHECK"] 
[h: inputString = inputString + "## junk | Definition Properties | User Defined Functions for " + selectedLibToken + " | LABEL "]
[h: functionNames = json.sort (json.fields (configuration, "json"))]
[h: l4m.trace (getMacroName(), "functionNames = " + functionNames)]
[h, foreach (functionName, functionNames), code: {
	[funcInputVar = "funcVar" + funcIndex]
	[funcVarMap = json.set (funcVarMap, functionName, funcInputVar)]
	[functionCfg = json.get (configuration, functionName)]
	[inputString = inputString + " ## " + funcInputVar + " | " + functionCfg + " | " + functionName + " | PROPS | TYPE=JSON"]
	[funcIndex = funcIndex + 1]
}]

[h: l4m.trace (CATEGORY, "inputString = " + inputString + "; funcVarMap = " + funcVarMap)]
[h: abort (input (inputString))]
[h: l4m.debug (CATEGORY, "overwriteFunctions = " + overwriteFunctions)]

<!-- Save the configuration -->
[h: newConfig = "{}"]
[h, foreach (functionName, functionNames), code: {
	[funcVar = json.get (funcVarMap, functionName)]
	[evalMacro ("[functionCfg = " + funcVar + "]")]
	[newConfig = json.set (newConfig, functionName, functionCfg)]
}]
[h: l4m.trace (CATEGORY, "newConfig = " + newConfig)]
[h: l4m.configureWrappers (newConfig, selectedLibToken, overwriteFunctions)]