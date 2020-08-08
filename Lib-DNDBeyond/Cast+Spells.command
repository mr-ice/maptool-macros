
<!-- Build an input with selects for each spell level. The spell name will have markers to indicate
     concentration. Ritual casting is ignored -->

[h: spells = dndb_getCastableSpells()]


[h: sampleInput = " level1Spell | spell1,spell2,spell3,spell4 | Pick it | LIST "]


[h: spellInputMap = "{}"]
[h: spellFields = json.fields (spells)]
[h, foreach (spellField, spellFields), code: {
	[spell = json.get (spells, spellField)]
	[spellLevel = json.get (spell, "level")]
	[spellName = json.get (spell, "name")]
	[spellIsConcentration = json.get (spell, "concentration")]
	[spellLevelList = json.get (spellInputMap, spellLevel)]
	[if (json.length (spellLevelList) == 0): spellLevelList = "[]"; ""]
	[if (spellIsConcentration == "true"): concentrationMarker = "  (C)"; concentrationMarker = "    "]
	[spellNameMap = json.set ("", "name", spellField, "displayName", spellName + concentrationMarker)]
	[spellLevelList = json.append (spellLevelList, spellNameMap)]
	[spellInputMap = json.set (spellInputMap, spellLevel, spellLevelList)]
}]

[h: validChoice = 0]
[h, while (!validChoice), code: {
[h: allSpellInputString = ""]
	[spellLevels = json.fields (spellInputMap)]
	[foreach (spellLevel, spellLevels), code: {
		[prompt = "Sell Level " + spellLevel]
		[spellNameCSV = ""]
		[spellNameMaps = json.get (spellInputMap, spellLevel)]
		[foreach (spellNameMap, spellNameMaps): spellNameCSV = spellNameCSV + "," + json.get (spellNameMap, "displayName")]
		[spellNameCSV = substring (spellNameCSV, 1)]
		[spellNameCSV = listSort (spellNameCSV, "A")]
		[spellNameCSV = "Select spell," + spellNameCSV]
		[allSpellInputString = allSpellInputString + "## level" + spellLevel + " | " + 
			spellNameCSV + " | Level " + spellLevel + " | LIST | value=string"]
	}]
	[allSpellInputString = allSpellInputString + "##spellSlot | " + json.toList (spellLevels) + "| Spell slot | LIST"]
	[allSpellInputString = "junk | Select one spell and the spell slot | | LABEL | span=true" + allSpellInputString + "## junk | The selected spell slot will be increased to the minimum spell level | | LABEL | span=true" +
	"## saveAsMacro | | Save as personal macro | check "]
	[abort (input ( allSpellInputString))]

	[selectionsMade = 0]
	[foreach (spellLevel, spellLevels), code: {
		[evalMacro ("[inputChoice = level" + spellLevel + "]")]
		[if (inputChoice != "Select spell"): selectionsMade = selectionsMade + 1; ""]
		[if (inputChoice != "Select spell"): selectedSpell = inputChoice; ""]
		[if (inputChoice != "Select spell"): selectedSpellLevel = spellLevel; ""]
	}]
	[if (selectionsMade == 1): validChoice = 1; input ("junk | Make one selection ||LABEL|span=true")]
}]

[h: log.debug ("selectedSpell: " + selectedSpell)]
[h: log.debug ("selectedSpellLevel: " + selectedSpellLevel)]
[h: log.info ("spellSlot: " + spellSlot)]

[h: inputMaps = json.get (spellInputMap, selectedSpellLevel)]
[h: selectedSpellName = ""]
[h, foreach (inputMap, inputMaps), code: {
	[displayName = json.get (inputMap, "displayName")]
	[if (displayName == selectedSpell): selectedSpellName = json.get (inputMap, "name")]
}]


[h: log.debug ("selectedSpell: " + selectedSpell)]
[h: inputObj = json.set ("", "spellName", selectedSpellName, "spellSlot", spellSlot)]
[r: dndb_Macro_rollSpell (inputObj)]


<!-- Ye old save as macro bullshit -->
[h, if (saveAsMacro > 0), code: {
	[h: macroConfig = dnd5e_Macro_copyMacroConfig ("Cast Spells")]

	[h: macroName = "Cast " + selectedSpell]
	[h: macroName = macroName + " (" + spellSlot + ")"]
	[h: currentMacros = getMacros()]
	[h: cmd = "[macro ('dndb_Macro_rollSpell@Lib:DnDBeyond'): '" + inputObj + "']"]
	<!-- dont create duplicates -->
	[h, foreach (currentMacro, currentMacros), if (currentMacro == macroName): saveAsMacro = 0]
	[h: macroConfig = json.set ("", "applyToSelected", 1,
								"autoExecute", 1,
								"color", json.get (macroConfig, "color"),
								"fontSize", json.get (macroConfig, "fontSize"),
								"fontColor", json.get (macroConfig, "fontColor"),
								"group", "D&D Beyond - Spells",
								"playerEditable", 1)]
	[h, if (saveAsMacro > 0): createMacro (macroName, cmd, macroConfig)]
}]