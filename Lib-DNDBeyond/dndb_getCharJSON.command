
[h: BASE_URL = "https://character-service.dndbeyond.com/character/v4/character/"]
[h: charId = json.get( macro.args, 0 )]

[h, if (startsWith (charId, "dndbt_")), code: {
	<!-- the char ID is a test id that is the target method that returns the char json -->
	[h: log.warn ("Fetching test toon: " + charId)]
	[h: macroString = "[r: " + charId + "()]"]
	[h: character = evalMacro (macroString)]
}; {
	[h: charAt = lastIndexOf (charId, "/")]

	[h, if (charAt > -1): charId = substring (charId, charAt + 1)]

	[h: url = BASE_URL + charId]
	[h: log.info (getMacroName() + ": url = " + url)]
	[h: character = REST.get(url)]
	[h: alwaysPreparedSpells = dndb_getAlwaysPreparedSpellsJSON (character)]
	[h: character = json.path.put (character, "data", 
			"lib_dndb-AlwaysPreparedSpells", alwaysPreparedSpells)]
}]

[h: macro.return = character]