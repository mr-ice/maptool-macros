[h: libTokenName = arg(0)]
[h: l4m.Constants()]
[h: CATEGORY = getMacroName() + "." + LIB_LOG4MT]

[h: proxyTokenName = l4m.getProxyTokenName (libTokenName)]
[h: l4m.debug (CATEGORY, "proxyTokenName = " + proxyTokenName)]
[h, token (proxyTokenName): proxyLibTokenId = currentToken()]
[h, token (libTokenName): libTokenId = currentToken()]

<!-- See if the target proxy exists; if not, copy target library -->
[h, if (proxyLibTokenId == currentToken()), code: {
	<!-- If the proxy id is the same as this id, it doesnt exist -->
	[updates = json.set ("{}", "name", proxyTokenName,
						"x", 2,
						"delta", 1)]
	[proxyLibTokenId = copyToken (libTokenId, 1, "", updates)]
	<!-- In a previous version, we also set owner, propType (Log4MT). Push that for now -->
}; {}]

<!-- get existing macros -->
[h: proxyLibMacros = getMacros ("json", proxyLibTokenId)]

<!-- Remove existing macros -->
[h, foreach (proxyLibMacro, proxyLibMacros), code: {
	[if (proxyLibMacro != WRAPPER_CONFIG_MACRO), code: {
		[macroIndexes = getMacroIndexes(proxyLibMacro, "json", proxyLibTokenId)]
		[foreach (macroIndex, macroIndexes): removeMacro (macroIndex, proxyLibTokenId)]
	}; {}]
}]

<!-- done -->
[h: macro.return = proxyLibTokenId]