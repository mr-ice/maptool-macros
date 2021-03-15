[h: libTokenName = arg(0)]
[h: proxyTokenName = arg(1)]
[h: defaultConfig = json.set ("", "ignoreOutput", 0, "newScope", 1)]

<!-- Build/Update the Configuration object -->
[h: currentConfig = l4m.getWrapperConfig (proxyTokenName)]
[h: existingUdfCfg = json.fields (currentConfig, "json")]

<!-- Interrogate Client for user defined functions, locating all those defined for source token -->
[h: libUdfNames = "[]"]
[h: clientInfo = getInfo ("client")]
[h: clientUdfs = json.get (clientInfo, "user defined functions")]
[h: clientUdfNames = json.fields (clientUdfs, "json")]

[h, foreach (clientUdfName, clientUdfNames), code: {
	<!-- will be KVP of UDF - Macro-location -->
	[udfMacro = json.get (clientUdfs, clientUdfName)]
	[udfLocation = listGet (udfMacro, 1, "@")]
	[if (udfLocation == libTokenName): libUdfNames = json.append (libUdfNames, clientUdfName), ""]
}]
[h, foreach (udfMacro, libUdfNames), code: {
	[if (!json.contains (existingUdfCfg, udfMacro)), code: {
		[currentConfig = json.set (currentConfig, udfMacro, defaultConfig)]
	}; {}]
}]

<!-- remove configued macros that no longer exist -->
[h: prunedConfig = "{}"]
[h, foreach (cfgField, json.fields (currentConfig, "json")), code: {
	[if (json.contains (libUdfNames, cfgField)): 
		prunedConfig = json.set (prunedConfig, cfgField, json.get (currentConfig, cfgField))]
}]
[h: macro.return = prunedConfig]