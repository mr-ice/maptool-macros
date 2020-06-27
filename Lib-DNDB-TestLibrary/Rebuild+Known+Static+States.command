[h: toonNames = "BhelduhrBallrotterThrahak,Blurrier,Bob,BodeMikbodephace," + 
				"GeeWiz,KazRedrum,KetdelleDankil,Nibbles,RexRedrum,Zairali"]
[h, foreach (toonName, toonNames), code: {
	[h: functionName = "[h: builtToon = dndb_buildBasicToon ('dndbt_" + toonName + "')]"]
	[h: evalMacro (functionName)]
	[h: dndbt_CreateDataMacro (builtToon, toonName)]
}]
[h: log.info ("Build Known States, done")]