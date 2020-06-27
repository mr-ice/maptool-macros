[h: toonNames = "BhelduhrBallrotterThrahak,Blurrier,Bob,BodeMikbodephace," + 
				"GeeWiz,KazRedrum,KetdelleDankil,Nibbles,RexRedrum,Zairali"]

[h, foreach (toonName, toonNames), code: {
	[h: functionName = "[h: builtToon = dndb_buildBasicToon ('dndbt_" + toonName + "')]"]
	[h: evalMacro (functionName)]
	[h: commandValue = base64.encode (builtToon)]
	[h: macroName = "data_BasicToon_" + toonName]
	[h: createMacro (macroName, commandValue, json.set ("", "group", "Data"))]
}]
[h: log.info ("Build Known States, done")]