[h: charId = arg (0)]

[h, if (startsWith (charId, "dndbt_")), code: {
	<!-- the char ID is a test id that is the target method that returns the char json -->
	[h: log.warn ("Fetching test toon: " + charId)]
	[h: macroString = "[r: " + charId + "()]"]
	[h: toon = evalMacro (macroString)]
}; {
	[h: toon = dndb_getCharJSON (charId)]	
}]

[h: name = json.path.read (toon, "data.name")]

[h: log.info ("Building basic character")]
[h: basicToon = dndb_getBasic (toon)]

<!-- slim down -->
[h: data = json.get (toon, "data")]
[h: dataRetains = json.append ("", "race", "modifiers", "inventory", "classes", "stats", "bonusStats", "overrideStats", "characterValues")]
[h: skinnyData = dndb_getSkinnyObject (data, dataRetains)]
<!-- Skinnify the toon -->
[h: fatToon = toon]
[h: btoon = json.set (toon, "data", skinnyData)]


[h: log.info ("dndb_getBasic: Initiative")]
[h: initiative = dndb_getInitiative (toon)]
[h: basicToon = json.set (basicToon, "init", initiative)]

[h: log.info ("dndb_getBasic: Language")]
[h: languageArray = dndb_getLanguage (toon)]
[h: basicToon = json.set (basicToon, "language", languageArray)]

[h: log.info ("Building Armor Class")]
[h: basicToon = json.set (basicToon, "armorClass", dndb_getAC (toon))]

[h: log.info ("Building Saving Throws")]
[h: basicToon = json.set (basicToon, "savingThrows", dndb_getSavingThrow (toon))]

[h: log.info ("Building Skills")]
[h: basicToon = json.set (basicToon, "skills", dndb_getSkill (toon))]

[h: log.info ("Building Attacks")]
[h: basicToon = json.set (basicToon, "attacks", dndb_getAttack (toon))]

[h: log.info ("Building Conditions")]
[h: basicToon = json.set (basicToon, "conditions", dndb_getConditions (toon))]

[h: log.info ("Building Spells")]
[h: basicToon = json.set (basicToon, "spellSlots", dndb_getSpellSlots (toon))]
[h: basicToon = json.set (basicToon, "spells", dndb_getSpells (toon))]

[h: basicToon = json.set (basicToon, "basicToonVersion", getLibProperty ("dndb.basicToonVersion"))]
[h: macro.return = basicToon]