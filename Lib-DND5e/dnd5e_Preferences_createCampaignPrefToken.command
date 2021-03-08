[h: LIB_CP = "Lib:CampaignPreferences"]

<!-- Unlike the usual approach, do a brute force search right off the bat -->
[h: maps = getAllMapNames("json")]
[h: currentLib = ""]
[h: libCp = ""]
[h: mapName = ""]
[h, foreach (map, maps), code: {
	[foundLibToken = findToken ("Lib:DnD5e", map)]
	[if (foundLibToken != ""), code: {
		[currentLib = foundLibToken]
		[mapName = map]
	}]
	[foundCpToken = findToken (LIB_CP, map)]
	[if(foundCpToken != ""): libCp = foundCpToken]
}]

<!-- find it? -->
[h, if (libCp != ""): return (0, libCp)]

<!-- Nope, create it -->
[h: setCurrentMap (mapName)]
[h: updates = json.set ("", "name", "Lib:CampaignPreferences", "x", -2, "delta", 1)]
[h: libCp = copyToken (currentLib, 1, "", updates)]
[h: macroNames = getMacros ("json", LIB_CP)]
[h, foreach (macroName, macroNames), code: {
	[if (macroName != "getCampaignPreferences" && macroName != "setCampaignPreferences"), code: {
		[macroIndexes = getMacroIndexes (macroName, "json", libCp)]
		[foreach (macroIndex, macroIndexes): removeMacro (macroIndex, libCp)]
	}]
}]
[h: return (0, libCp)]