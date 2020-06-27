[h: builtToon = dndb_buildBasicToon ("dndbt_Bob")]
[h: macroIdx = getMacroIndexes ("data_BasicToon_Bob")]
[h: dataMacro = getMacroCommand (macroIdx)]
[h: diffs = json.difference (builtToon, dataMacro)]
[h, if (!json.isEmpty (diffs)), code: {
	[h: input ("Differences found in Toon!")]
	[h: log.error ("dndbt_Bob: " + diffs)]
}]
[h: log.error ("dndbt_Bob: " + diffs)]