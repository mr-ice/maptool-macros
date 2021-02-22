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
[h: defineMacroCmd = "[h: overwriteMacros = '[]']" + NEW_LINE]
<!-- Save the configuration -->
[h: newConfig = "{}"]
[h, foreach (functionName, functionNames), code: {
	[funcVar = json.get (funcVarMap, functionName)]
	[evalMacro ("[functionCfg = " + funcVar + "]")]
	[newConfig = json.set (newConfig, functionName, functionCfg)]
	[defineMacroCmd = defineMacroCmd + 
			"[h: overwriteMacros = json.append (overwriteMacros, '" + functionName + "')]" + NEW_LINE]
}]
[h: l4m.trace (CATEGORY, "newConfig = " + newConfig)]
[h: l4m.setWrapperConfig (selectedLibToken, newConfig)]
<!-- Build the Define Overwrite macros -->
[h, token (selectedLibToken), code: {
	[macroIndexes = getMacroIndexes (MACRO_OVERWRITE_UDF_NAME)]
	[foreach (macroIndex, macroIndexes): removeMacro (macroIndex)]
	[defineMacroCmd = defineMacroCmd + 
		"[h: src = json.get (getMacroContext(), 'source')]" + NEW_LINE +
		"[h: wrapperCfgs = l4m.getWrapperConfig (src)]" + NEW_LINE +
		"[h, foreach (wrapperName, json.fields (wrapperCfgs, 'json')), code: {" + NEW_LINE +
		"	[cfg = json.get (wrapperCfgs, wrapperName)]" + NEW_LINE +
		"	[ignoreOutput = json.get (cfg, '" + CFG_IGNORE_OUTPUT  + "')]" + NEW_LINE +
		"	[newScope = json.get (cfg, '" + CFG_NEW_SCOPE + "')]" + NEW_LINE +
		"	[defineFunction (wrapperName, wrapperName + '@this', " +
				"ignoreOutput, newScope)]" + NEW_LINE +
		"}]"]
	[props = json.set ("", "playerEditable", 0, "group", "Init")]
	[createMacro (MACRO_OVERWRITE_UDF_NAME, defineMacroCmd, props)]
}]
[h: l4m.debug (CATEGORY, "overwriteFunctions = " + overwriteFunctions)]
[h, if (overwriteFunctions), code: {
	[macro (MACRO_OVERWRITE_UDF_NAME + "@" + selectedLibToken): ""]
}; {}]