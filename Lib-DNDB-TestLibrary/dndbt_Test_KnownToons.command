[h: toonNames = "BhelduhrBallrotterThrahak,Blurrier,Bob,BodeMikbodephace," + 
				"GeeWiz,KazRedrum,KetdelleDankil,Nibbles,RexRedrum,Zairali"]

[h: report = "dndbt_Test_KnownToons Report:"]
[h, foreach (toonName, json.fromList (toonNames)), code: {
	[h: functionName = "[h: builtToon = dndb_buildBasicToon ('dndbt_" + toonName + "')]"]
	[h: macroIdx = getMacroIndexes ("data_BasicToon_" + toonName)]
	[h: evalMacro (functionName)]
	[h: macroCoded = getMacroCommand (macroIdx)]
	[h: builtCoded = base64.encode (builtToon)]
	[h, if (macroCoded != builtCoded), code: {
		[h: report = report + decode ("%0A") + toonName + ": Differences found in Toon!"]
	}]
}]
<pre>[r: report]</pre>