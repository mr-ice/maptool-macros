[h: proxyToken = arg (0)]
[h: l4m.Constants ()]
[h, token (proxyToken): proxyTokenId = currentToken ()]
[h: l4m.debug (getMacroName() + "." + LIB_LOG4MT, "proxyToken = " + proxyToken + 
			"; proxyTokenId = " + proxyTokenId)]
[h: macroIndexes = getMacroIndexes (WRAPPER_CONFIG_MACRO, "json", proxyTokenId)]
[h: config = encode ("{}")]
[h, if (!json.isEmpty (macroIndexes)), code: {
	[retObj = getMacroCommand (json.get (macroIndexes, 0), proxyTokenId)]
	[if (retObj != ""): config = retObj; ""]
}; {}]
[h: macro.return = decode (config)]