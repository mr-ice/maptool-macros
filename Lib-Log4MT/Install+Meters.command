<!-- Prompt for source library -->
[h: l4m.Constants()]

[h: clientInfo = getInfo ("client")]
[h: libTokensObj = json.get (clientInfo, "library tokens")]
[h: libTokenFields = json.fields (libTokensObj, "json")]
<!-- Remove this token and the proxy token, if its in there -->
[h: proxyExists = 0]
[h: toRemove = json.append ("[]", LIB_LOG4MT)]
[h, if (json.contains (libTokenFields, LIB_PROXY)), code: {
	[proxyExists = 1]
	[toRemove = json.append (toRemove, LIB_PROXY)]
}; {}]
[h: libTokenFields = json.removeAll (libTokenFields, toRemove)]
[h: libTokenStrList = json.toList (libTokenFields)]

[h: inputStr = "junk | Input Source Library to profile and target proxy | | Label | span=true"]
[h: libInputSelect = "libTokenName | " + libTokenStrList + " | Token Library | LIST | value=string"]

[h: inputStr = inputStr + "##" + libInputSelect]

[h: proxyChoices = ""]

[h: mapTokens = getTokenNames("json")]
[h, if (proxyExists): mapTokens = json.append (mapTokens, LIB_PROXY); ""]

[h, foreach (mapToken, mapTokens, ""): proxyChoices = json.append (proxyChoices, mapToken)]
[h: proxyInputStr = "proxyTokenSelect | " + json.toList (proxyChoices) + " | Target Proxy Token | LIST"]
[h: inputStr = inputStr + "##" + proxyInputStr]
<!-- Prompt for target Proxy Library -->
[h: log.debug (getMacroName() + ": inputStr = " + inputStr)]

[h: validSelection = 0]
[h, while (!validSelection), code: {
	[abort (input (inputStr))]
	[proxyTokenName = json.get (mapTokens, proxyTokenSelect)]
	<!-- Confirm selections -->
	[validSelection = input ("junk | Please confirm your choices before continuing. WARNING: all macros on " + 
		proxyTokenName + " will be DELETED | | LABEL | span=true",
		"junk | " + libTokenName + " | Source Library To Profile | LABEL",
		"junk | " + proxyTokenName + " | Target Proxy Library | LABEL")]
	[token (proxyTokenName): proxyId = currentToken()]
	<!-- On an invalid selection, Lib:Profiler is the selected token, and thats super bad -->
	[if (currentToken() == proxyId): validSelection = 0; ""]
}]
[h: log.debug (getMacroName() + ": libTokenName = " + libTokenName)]
[h, token (libTokenName): libMacros = getMacros ()]

<!-- Interrogate Client for user defined functions, locating all those defined for source token -->
[h: libUdfNames = "[]"]
[h: clientInfo = getInfo ("client")]
[h: clientUdfs = json.get (clientInfo, "user defined functions")]

[h, foreach (clientUdfName, json.fields (clientUdfs)), code: {
	<!-- will be KVP of UDF - Macro-location -->
	[udfMacro = json.get (clientUdfs, clientUdfName)]
	[udfLocation = listGet (udfMacro, 1, "@")]
	<!-- get the actual macro name, not the UDF value ... which could very well be the same anyways -->
	[if (udfLocation == libTokenName): libUdfNames = json.append (libUdfNames, clientUdfName), ""]
}]

[h: log.info (getMacroName() + ": Overriding UDFs in proxy token - " + json.indent (libUdfNames))]

<!-- Our constants share the same name as the properties of our target token which will be blank.
		So put them under a different name for this next part -->
[h: libProxy = LIB_PROXY]
[h: macroStart = PROFILER_START_MACRO]
[h: macroStop = PROFILER_STOP_MACRO]
<!-- Rename the target token -->
[h, token (proxyTokenName), code: {

	[setName (libProxy)]
	[setOwner ("")]
	[setPropertyType ("Log4MT")]
	[setNPC()]
	[macroNames = getMacros()]
	[foreach (macroName, macroNames), code: {
		[macroIndexes = getMacroIndexes(macroName)]
		[foreach (macroIndex, macroIndexes): removeMacro (macroIndex)]
	}]

	[defineMacroCmd = ""]
	[props = json.set ("", "group", "UDF Overrides")]
	[foreach (libUdfName, libUdfNames), code: {
		[fullMacroName = json.get (clientUdfs, libUdfName)]
		[actualMacroName = listGet (fullMacroName, 0, "@")]
		[proxyMacroCmd = 
			"[h: currentLevel = l4m.getCurrentMacroLogger()]"+ decode ("%0A") +
		    "[h, macro ('" + macroStart + "'): json.set ('', 'name', getMacroName(), 'args', macro.args, 'token', '"+ libTokenName + "')]" + decode ("%0A") +
			"[r, macro ('" + actualMacroName + "@" + libTokenName + "'): macro.args]" + decode ("%0A") +
			"[h: data = macro.return]" + decode ("%0A") +
			"[h, macro ('" + macroStop + "'): json.set ('', 'name', getMacroName(), 'token', '" + libTokenName + "', 'return', data, 'macro-logger', currentLevel)]" + decode ("%0A") +
			"[h: macro.return = data]"]
		
		[createMacro (libUdfName, proxyMacroCmd, props)]
		[defineMacroCmd = defineMacroCmd + decode ("%0A") + 
			"[h: defineFunction ('" + libUdfName + "', '" + libUdfName + "@this')]"]
	}]
	[props = json.set ("", "playerEditable", 0, "group", "Init")]
	[createMacro ("Overwrite UDFs", defineMacroCmd, props)]
	[macro ("Overwrite UDFs@" + libProxy): ""]
}]
[h: msg = getMacroname() + ": Meters Installed"]
[h: log.warn (msg)]
