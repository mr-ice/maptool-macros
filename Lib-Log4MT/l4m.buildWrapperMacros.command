[h: proxyTokenName = arg(0)]
[h, token (proxyTokenName): proxyTokenId = currentToken()]
[h: l4m.Constants()]
[h: CATEGORY = LIB_LOG4MT + "." + getMacroName()]

[h: findId = strfind (proxyTokenName, PROXY_LIB_PATTERN)]
[h: findCount = getFindCount (findId)]
[h: assert (findCount > 0, "Could not identify Library Token from proxy: " + proxyTokenName, 0)]
[h: libTokenName = getGroup (findId, 1, 1)]
[h: l4m.debug (CATEGORY, "libTokenName = " + libTokenName)]

<!-- Get the wrapper config for the proxy token -->
[h: wrapperConfig = l4m.getWrapperConfig (proxyTokenName)]

<!-- For each config, build a wrapper macro -->
[h: props = json.set ("", "group", "UDF Overrides")]

[h, foreach (wrapperUdf, json.fields (wrapperConfig, "json")), code: {
		[proxyMacroCmd = decode (l4m.buildWrapperSrcMacro (wrapperUdf, libTokenName, 6))]
		[props = json.set (props, "label", wrapperUdf, "command", proxyMacroCmd)]
		[createMacro (wrapperUdf, proxyMacroCmd, props, "json", proxyTokenid)]
}]
[h: l4m.warn (CATEGORY, "Wrappers Installed")]