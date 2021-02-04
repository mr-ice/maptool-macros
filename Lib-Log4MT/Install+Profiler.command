<!-- Prompt for source library -->
[h: l4m.Constants()]

[h: inputStr = "junk | Input Source Library to profile and target proxy | | Label | span=true"]
[h: libInputSelect = "libTokenName | Lib:TokeName | Token Library | TEXT"]

[h: inputStr = inputStr + "##" + libInputSelect]

[h: proxyChoices = ""]
<!-- Assume there might already be an existing Lib:ProfilerProxy -->
[h: mapTokens = json.append (getTokenNames("json"), LIB_PROXY)]
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

<!-- Rename the target token -->
[h, token (proxyTokenName), code: {
	[setName (LIB_PROXY)]
	[setOwner ("")]
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
		    "[h, macro ('" + PROFILER_START_MACRO + "'): json.set ('', 'name', getMacroName(), 'args', macro.args)]" + decode ("%0A") +
			"[r, macro ('" + actualMacroName + "@" + libTokenName + "'): macro.args]" + decode ("%0A") +
			"[h: data = macro.return]" + decode ("%0A") +
			"[h, macro ('" + PROFILER_STOP_MACRO + "'): json.set ('', 'name', getMacroName(), 'return', data)]" + decode ("%0A") +
			"[h: macro.return = data]"]
		
		[createMacro (libUdfName, proxyMacroCmd, props)]
		[defineMacroCmd = defineMacroCmd + decode ("%0A") + 
			"[h: defineFunction ('" + libUdfName + "', '" + libUdfName + "@this')]"]
	}]
	[props = json.set ("", "playerEditable", 0, "group", "Init")]
	[createMacro ("Overload UDFs", defineMacroCmd, props)]
	[macro ("Overload UDFs@" + LIB_PROXY): ""]
}]

[h: log.warn (getMacroname() + ": Ready to profile")]
