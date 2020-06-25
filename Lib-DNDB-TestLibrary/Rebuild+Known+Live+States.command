[h: toonNames = "30957877,30957978,30959709,30960137"]
[h, foreach (toonName, toonNames), code: {
	[h: builtToon = dndb_buildBasicToon (toonName)]
	[h: commandValue = base64.encode (builtToon)]
	[h: macroName = "data_BasicToon_" + toonName]
	[h: createMacro (macroName, commandValue, json.set ("", "group", "Data"))]
}]
[h: log.info ("Build Known States, done")]