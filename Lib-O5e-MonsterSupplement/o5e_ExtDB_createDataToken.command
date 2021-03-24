[h: o5e_ExtDB_Constants(getMacroName())]

<!-- Unlike the usual approach, do a brute force search right off the bat -->
[h: maps = getAllMapNames("json")]
[h: currentLib = ""]
[h: libCp = ""]
[h: mapName = ""]
[h, foreach (map, maps), code: {
	[foundLibToken = findToken (LIB_TOKEN_NAME, map)]
	[if (foundLibToken != ""), code: {
		[currentLib = foundLibToken]
		[mapName = map]
	}]
	[foundCpToken = findToken (PROXY_TOKEN_NAME, map)]
	[if(foundCpToken != ""): libCp = foundCpToken]
}]

<!-- find it? -->
[h, if (libCp != ""): return (0, libCp)]

<!-- Nope, create it -->
[h: setCurrentMap (mapName)]
[h: updates = json.set ("{}", "name", PROXY_TOKEN_NAME,
			"x", -2, "delta", 1)]
[h: libCp = copyToken (currentLib, 1, "", updates)]
[h: macroNames = getMacros ("json", PROXY_TOKEN_NAME)]

[h, foreach (macroName, macroNames), code: {
	[macroIndexes = getMacroIndexes (macroName, "json", libCp)]
	[if (!startsWith (macroName, DATA_MACRO)), 
		foreach (macroIndex, macroIndexes): removeMacro (macroIndex, libCp)]
}]
[h: return (0, libCp)]