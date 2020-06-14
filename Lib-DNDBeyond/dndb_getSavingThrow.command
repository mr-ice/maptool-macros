[h: toon = arg(0)]
<!-- todo: some day were gonna get a json package that isnt in english. That -->
<!-- might affect how this (and many other) macros work -->
[h: savesMap = json.append ("",
			json.set ("", "name", "Strength", "valueId", "1", "abilityBonus", "strBonus"),
			json.set ("", "name", "Dexterity", "valueId", "2", "abilityBonus", "dexBonus"),
			json.set ("", "name", "Constitution", "valueId", "3", "abilityBonus", "conBonus"),
			json.set ("", "name", "Intelligence", "valueId", "4", "abilityBonus", "intBonus"),
			json.set ("", "name", "Wisdom", "valueId", "5", "abilityBonus", "wisBonus"),
			json.set ("", "name", "Charisma", "valueId", "6", "abilityBonus", "chaBonus")
			)
]
[h, if (json.length (macro.args) > 1): 
	saveNames = json.append ("", arg(1));
	saveNames = json.append ("", "Strength", "Dexterity", "Constitution",
					"Intelligence", "Wisdom", "Charisma")
]

<!-- Saving throws are about as stupid as skills, but here we go -->
<!-- Slim down the toon -->
[h: data = json.get (toon, "data")]
[h: dataRetains = json.append ("", "modifiers", "inventory", "classes", "stats", "bonusStats", "overrideStats")]
<!-- need these later, but now is a good time to get them -->
[h: abilities = dndb_getAbilities (toon)]
[h: profBonus = dndb_getProficiencyBonus (toon)]

[h: skinnyData = dndb_getSkinnyObject (data, dataRetains)]
<!-- Skinnify the toon -->
[h: fatToon = toon]
[h: skinnyToon = json.set (toon, "data", skinnyData)]

[h: allProfValue = 1]
[h: searchArgs = json.set ("", "object", toon,
							"subType", "saving-throws")]
[h: saveMods = dndb_searchGrantedModifiers (searchArgs)]

[h: allProfValue = 0]
[h: allBonus = 0]
[h, foreach (saveMod, saveMods), code: {
	[h: log.debug ("allSaves - saveMod: " + json.indent(saveMod))]
	[h: modLabel = json.get (saveMod, "type")]
	[h, switch (modLabel):
		case "expertise": allProfValue = 3;
		case "proficiency": allProfValue = math.max (allProfValue, 2);
		case "half-proficiency": allProfValue = math.max (allProfValue, 1);
		case "bonus": allBonus = allBonus + json.get(saveMod, "value");
		default: "Someday we'll care about you, but not today"]
}]
[h: log.debug ("allBonus: " + allBonus)]
[h: finalSaves = "[]"]


[h, foreach (saveName, saveNames), code: {
	[h: valueIdArry = dndb_searchJsonObject (json.set ("",
						"object", savesMap,
						"name", saveName,
						"property", "valueId"))]
	[h: valueId = json.get (valueIdArry, 0))]
	[h: searchSaveName = lower (saveName + "-saving-throws")]
	[h: log.debug ("searchSaveName: " + searchSaveName)]

							"type", "half-proficiency",
							"property", "type"
	<!-- first proficiencies -->
	[h: profValue = 1]
	[h: searchArgs = json.set ("", "object", skinnyToon,
							"subType", searchSaveName)]
							
	[h: saveMods = dndb_searchGrantedModifiers (searchArgs)]
	[h: profValue = 0]
	[h: bonus = allBonus]
	[h, foreach (saveMod, saveMods), code: {
		[h: modLabel = json.get (saveMod, "type")]
		[h, switch (modLabel):
			case "expertise": profValue = 3;
			case "proficiency": profValue = math.max (profValue, 2);
			case "half-proficiency": profValue = math.max (profValue, 1);
			case "bonus": bonus = bonus + json.get(saveMod, "value");
			default: "Someday we'll care about you, but not today"]
	}]


	<!-- character choices; These are not found under data.modifiers, so use the generic searchJsonObject -->
	<!-- override -->
	[h: searchArgs = json.set ("", "object", json.path.read (toon, "data.characterValues"),
							"typeId", "38",
							"property", "value",
							"valueId", valueId)]
	[h: overrideArry = dndb_searchJsonObject (searchArgs)]

	<!-- Magic Bonus -->
	[h: searchArgs = json.set (searchArgs, "typeId", "40")]
	[h: magicArry = dndb_searchJsonObject (searchArgs)]

	<!-- Misc Bonus -->
	[h: searchArgs = json.set (searchArgs, "typeId", "39")]
	[h: miscArry = dndb_searchJsonObject (searchArgs)]

	<!-- Proficiency (character choice overrides) -->
	[h: searchArgs = json.set (searchArgs, "typeId", "41")]
	[h: profArry = dndb_searchJsonObject (searchArgs)]
	
	[h: choiceProfValue = 0]
	[h, if (json.length(profArry) > 0): choiceProfValue = json.get (profArry, 0)]


	<!-- build the save -->

	[h: bonusArry = ""]
	[h: totalBonus = 0]

	<!-- determine ability bonus -->
	[h: abilitySearchResult = dndb_searchJsonObject (json.set ("",
									"object", savesMap,
									"name", saveName,
									"property", "abilityBonus"))]

	[h: abilityBonusName = json.get (abilitySearchResult, 0)]
	[h: abilityBonus = json.get (abilities, abilityBonusName)]
	[h: bonusArry = json.append (bonusArry, json.set ("", "type", "Ability", "value", abilityBonus))]
	[h: totalBonus = totalBonus + abilityBonus]

	<!-- determine proficiency value -->
	[h, if (choiceProfValue > 0): actualProfValue = choiceProfValue;
								actualProfValue = round (math.max (profValue, allProfValue))]

	[h, switch (actualProfValue), code:
		case 0: {
			[h: profBonus = 0]
			[h: proficient = ""]
		};
		case 1: {
			[h: profBonus = round (math.floor (profBonus / 2))]
			[h: proficient = "half"]
		};
		case 2: {
			[h: profBonus = dndb_getProficiencyBonus (toon)]
			[h: proficient = "proficient"]
		};
		case 3: {
			[h: profBonus = profBonus * 2]
			[h: proficient = "expert"]
		}
	]
	[h: totalBonus = totalBonus + profBonus]

	[h: savingThrow = json.set ("", "name", saveName,
								"proficient", proficient,
								"valueId", valueId)]
	[h: bonusArry = json.append (bonusArry, json.set ("", "type", "Proficiency", "value", profBonus))]
	
	<!-- class, background, item "bonus" bonuses -->
	[h: totalBonus = totalBonus + bonus]

	<!-- character choices bonuses (magic and misc) -->
	[h: totalMagicBonus = 0]
	[h, foreach (magicBonus, magicArry): totalMagicBonus = totalMagicBonus + magicBonus]
	[h: bonusArry = json.append (bonusArry, json.set ("", "type", "Magic", "value", totalMagicBonus))]
	[h: totalBonus = totalBonus + totalMagicBonus]

	[h: totalMiscBonus = 0]
	[h, foreach (miscBonus, miscArry): totalMiscBonus = totalMiscBonus + miscBonus]
	[h: bonusArry = json.append (bonusArry, json.set ("", "type", "Misc", "value", totalMiscBonus))]
	[h: totalBonus = totalBonus + totalMiscBonus]

	<!-- finally, the override -->
	[h: overrideValue = ""]
	[h, if (json.length (overrideArry) > 0), code: {
		<!-- should only be one value -->
		[h: overrideValue = json.get (overrideArry, 0)]
		[h: totalBonus = overrideValue]
	}]
	[h: bonusArry = json.append (bonusArry, json.set ("", "type", "Override", "value", overrideValue))]
	[h, if (allBonus > 0): bonusArry = json.append (bonusArry, json.set ("", "type", "All Bonus", "value", allBonus))]

	[h: savingThrow = json.set (savingThrow, "totalBonus", totalBonus,
									"bonuses", bonusArry)]
	[h: finalSaves = json.append (finalSaves, savingThrow)]							
}]

[h: macro.return = finalSaves]


