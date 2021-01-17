[h: toon = arg(0)]
<!-- todo: some day were gonna get a json package that isnt in english. That -->
<!-- might affect how this (and many other) macros work -->
<!-- Note - the Death saving throw is its own beast -->
[h: savesMap = json.append ("",
		json.set ("", "property", "strSave", "name", "Strength", "valueId", "1", "bonuses", "{}", "bonus", 0, "proficient", 0),
		json.set ("", "property", "dexSave", "name", "Dexterity", "valueId", "2", "bonuses", "{}", "bonus", 0, "proficient", 0),
		json.set ("", "property", "conSave", "name", "Constitution", "valueId", "3", "bonuses", "{}", "bonus", 0, "proficient", 0),
		json.set ("", "property", "intSave", "name", "Intelligence", "valueId", "4", "bonuses", "{}", "bonus", 0, "proficient", 0),
		json.set ("", "property", "wisSave", "name", "Wisdom", "valueId", "5", "bonuses", "{}", "bonus", 0, "proficient", 0),
		json.set ("", "property", "chaSave", "name", "Charisma", "valueId", "6", "bonuses", "{}", "bonus", 0, "proficient", 0)
	)
]

[h: SAVE_ENTITY_TYPE_ID = "1472902489"]
[h: deathSave = json.set ("", "property", "deathSave", "name", "Death", "valueId", "-1", "bonuses", "{}", "bonus", 0, "proficient", 0)]
[h: allSave = json.set ("", "property", "allSave", "name", "AllSave", "valueId", "-1", "bonuses", "{}", "bonus", 0, "proficient", 0)]

<!-- Saving throws are about as stupid as skills, but here we go -->
<!-- Slim down the toon -->
[h: data = json.get (toon, "data")]
[h: dataRetains = json.append ("", "modifiers", "inventory", "classes", "stats", "bonusStats", "overrideStats")]

[h: skinnyData = dndb_getSkinnyObject (data, dataRetains)]
<!-- Skinnify the toon -->
[h: fatToon = toon]
[h: skinnyToon = json.set (toon, "data", skinnyData)]

[h: searchArgs = json.set ("", "object", toon,
							"subType", "saving-throws")]
[h: saveMods = dndb_searchGrantedModifiers (searchArgs)]

[h: allProfValue = 0]
[h: allBonus = 0]
<!-- I'm not digging for override, magic, or other bonuses like I do with the standard saves. -->
<!-- Wonder when that will come back to bite me in the ass -->
[h, foreach (saveMod, saveMods), code: {
	[h: log.debug ("allSaves - saveMod: " + json.indent(saveMod))]
	[h: modLabel = json.get (saveMod, "type")]
	[h, switch (modLabel):
		case "expertise": allProfValue = 2;
		case "proficiency": allProfValue = math.max (allProfValue, 1);
		case "half-proficiency": allProfValue = math.max (allProfValue, 0.5);
		case "bonus": allBonus = allBonus + json.get(saveMod, "value");
		default: "Someday we'll care about you, but not today"]
}]
[h: log.debug (getMacroName() + ": allBonus = " + allBonus + "; allProf = " + allProfValue)]
[h: allSave = json.set (allSave, "proficient", allProfValue, "bonus", allBonus)]
[h: finalSaves = "[]"]

<!-- Get the data block for characterValues relating to Saves -->
<!-- Since we know these bits are in data.characterValues, read that out first -->
<!-- and just search that object -->
[h: characterValues = json.path.read (toon, "data.characterValues")]
[h: characterValuesSearchObj = json.set ("", "object", characterValues,
					"valueTypeId", SAVE_ENTITY_TYPE_ID)]
[h: saveValues = dndb_searchJsonObject (characterValuesSearchObj)]
[h: log.debug (getMacroName() + ": saveValues = " + saveValues)]
[h, foreach (savingThrow, savesMap), code: {
	[h: saveName = json.get (savingThrow, "name")]
	[h: valueId = json.get (savingThrow, "valueId"))]
	[h: searchSaveName = lower (saveName + "-saving-throws")]
	[h: log.debug ("searchSaveName: " + searchSaveName)]
	<!-- first proficiencies -->
	[h: profValue = 0]
	[h: searchArgs = json.set ("", "object", skinnyToon,
							"subType", searchSaveName)]
							
	[h: saveMods = dndb_searchGrantedModifiers (searchArgs)]
	[h: bonus = 0]
	[h, foreach (saveMod, saveMods), code: {
		[h: modLabel = json.get (saveMod, "type")]
		[h, switch (modLabel):
			case "expertise": profValue = 2;
			case "proficiency": profValue = math.max (profValue, 1);
			case "half-proficiency": profValue = math.max (profValue, 0.5);
			case "bonus": bonus = bonus + json.get(saveMod, "value");
			default: "Someday we'll care about you, but not today"]
	}]

	<!-- character choices for the Save-->
	[h: valueId = json.get (savingThrow, "valueId")]
	[h: searchArgs = json.set ("", "object", saveValues, "valueId", valueId)]
	[h: saveChoices = dndb_searchJsonObject (searchArgs)]
	[h: bonuses = "{}"]

	[h, foreach (saveChoice, saveChoices), code: {
		[h: typeId = json.get (saveChoice, "typeId")]
		[h, switch (typeId):
			case 38: typeLabel = "Override";
			case 39: typeLabel = "MiscBonus";
			case 40: typeLabel = "MagicBonus";
			case 41: typeLabel = "ProficiencyOverride";
			default: typeLabel = typeId;
		]
		[h: value = json.get (saveChoice, "value")]
		[h: bonusObj = json.set ("{}", "typeId", typeId, "value", value)]
		[h: bonuses = json.set (bonuses, typeLabel, bonusObj)]
	}]

	[h: profOverride = json.get (bonuses, "ProficiencyOverride")]
	[h, if (!json.isEmpty (profOverride)), code: {
		[h: value = json.get (profOverride, "value")]
		[h, switch (value):
			case 4: profValue = 2;
			case 3: profValue = 1;
			case 2: profValue = 0.5;
			case 1: profValue = 0;
			default: log.warn (getMacroName() + " ...wut? " + value)]
	}; {}]

	[h: savingThrow = json.set (savingThrow, "bonuses", bonuses,
								"bonus", bonus,
								"proficient", profValue)]	

	[h: finalSaves = json.append (finalSaves, savingThrow)]							
}]
<!-- add our two special saves -->
[h: finalSaves = json.append (finalSaves, allSave, deathSave)]
[h: macro.return = finalSaves]


