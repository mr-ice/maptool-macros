[h: monsterToon = arg(0)]
[h: o5e_Constants (getMacroName())]

[h: SPELLCASTING_PATTERN = ".*\\sspellcasting ability is (\\w+)\\s\\(spell save DC (\\d+).*\\).*It .* the following(.*)spells[^:]*:(.*)"]

[h: spellcastingSpecialAbilities = json.append ("", "Spellcasting", "Innate Spellcasting")]
[h: fullSpellcastingObj = "{}"]
[h, foreach (spellcastingSpecialAbility, spellcastingSpecialAbilities), code: {
	[log.debug (CATEGORY + "## spellcastingSpecialAbility = " + spellcastingSpecialAbility)]
	[descArry = json.path.read (monsterToon, "special_abilities.[?(@.name == '" + spellcastingSpecialAbility +
		"')]['desc']", "SUPPRESS_EXCEPTIONS")]
	<!-- getting more than one is weird, so just assume 0 or 1 -->
	[desc = ""]
	[if (json.length (descArry) > 0): desc = json.get (descArry, 0)]
	[descx = replace (desc, "\\n", "")]
	[log.debug (CATEGORY + "## desc = " + desc)]
	[findId = strfind (desc, SPELLCASTING_PATTERN)]
	[log.debug (CATEGORY + "## groups = " + getGroupCount(findId))]
	[if (getFindCount(findId) > 0), code: {
		<!-- group 1: spellcasting ability -->
		[spellCastingAbility = getGroup (findId, 1, 1)]
		<!-- group 2: Spellsave DC -->
		[spellSaveDC = getGroup (findId, 1, 2)]
		<!-- group 3: (optional) class -->
		[spellList = trim (getGroup (findId, 1, 3))]
		<!-- group 4: Tail - spells -->
		<!-- Tail has newlines, so just substr for the rest -->
		[tailStart = getGroupStart (findId, 1, 4)]
		[tail = substring (desc, tailStart)]
		[log.debug (CATEGORY + "## spellCastingAbility = " + spellCastingAbility + "; spellSaveDC = " + spellSaveDC +
			"; spellList = " + spellList + "; tail = " + tail)]
		<!-- the tail is a new-line elimited list of spell groups -->
		[spellsObj = o5e_Parser_parseSpells (tail)]
		[spellcastingObj = json.set ("",
			"ability", spellCastingAbility,
			"saveDC", spellSaveDC,
			"spellList", spellList,
			"spells", spellsObj)]
		[fullSpellcastingObj = json.set (fullSpellcastingObj, spellcastingSpecialAbility, spellcastingObj)]
	}; {
		[log.debug (CATEGORY + "## No match")]
	}]
}]
[h: macro.return = fullSpellcastingObj]