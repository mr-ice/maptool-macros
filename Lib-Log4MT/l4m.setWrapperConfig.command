[h: configJson = arg (1)]
[h: proxyToken = arg (0)]
[h, token (proxyToken): proxyTokenId = currentToken ()]
[h: thisTokenId = currentToken ()]
[h: assert (proxyTokenId != thisTokenId, "Cannot use " + getTokenName ())]
[h: l4m.Constants()]
[h: macroIndexes = getMacroIndexes (WRAPPER_CONFIG_MACRO, "json", proxyTokenId)]
[h: command = encode (configJson)]
[h, if (json.isEmpty (macroIndexes)), code: {
	[macroProps = json.set ("", "autoExecute", 1, 
					"group", "Wrapper Meta", 
					"label", WRAPPER_CONFIG_MACRO,
					"command", command,
					"playerEditable", 0)]
	[createMacro (macroProps, proxyToken)]
	[macroIndexes = getMacroIndexes (WRAPPER_CONFIG_MACRO, "json", proxyTokenId)]
}]
[h: macroIndex = json.get (macroIndexes, 0)]
[h: setMacroCommand (macroIndex, command, proxyTokenId)]