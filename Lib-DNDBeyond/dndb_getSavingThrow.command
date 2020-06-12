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
[h: allProfValue = 1]
[h: searchArgs = json.set ("", "object", toon,
							"property", "type",
							"subType", "saving-throws",
							"type", "half-proficiency")]
[h: halfArry = dndb_searchGrantedModifiers (searchArgs)]
[h, if ( json.length (halfArry) > 0): allProfValue = 2]

[h: searchArgs = json.set (searchArgs, "type", "proficiency")]
[h: fullArry = dndb_searchGrantedModifiers (searchArgs)]
[h, if (json.length (fullArry) > 0): allProfValue = 3]

[h: searchArgs = json.set (searchArgs, "type", "expertise")]
[h: expertArry = dndb_searchGrantedModifiers (searchArgs)]
[h, if (json.length (expertArry) > 0): allProfValue = 4]

<!-- all Saves bonus -->
[h: searchArgs = json.set (searchArgs, 
							"property", "fixedValue",
							"subType", "saving-throws",
							"type", "bonus")]

[h: allSaveBonusArry = dndb_searchGrantedModifiers (searchArgs)]
[h: log.debug ("allSaveBonusArry: " + json.indent (allSaveBonusArry))]
[h: finalSaves = "[]"]

[h, foreach (saveName, saveNames), code: {
	[h: valueIdArry = dndb_searchJsonObject (json.set ("",
						"object", savesMap,
						"name", saveName,
						"property", "valueId"))]
	[h: valueId = json.get (valueIdArry, 0))]
	[h: searchSaveName = lower (saveName + "-saving-throws")]
	[h: log.debug ("searchSaveName: " + searchSaveName)]

	<!-- first proficiencies -->
	[h: profValue = 1]
	[h: searchArgs = json.set ("", "object", toon,
							"subType", searchSaveName,
							"type", "half-proficiency",
							"property", "type")]
	[h: halfArry = dndb_searchGrantedModifiers (searchArgs)]
	[h: log.debug ("halfArry: " + json.indent (halfArry))]
	[h, if (json.length (halfArry) > 0): profValue = 2]

	[h: searchArgs = json.set (searchArgs, "type", "proficiency")]
	[h: fullArry = dndb_searchGrantedModifiers (searchArgs)]
	[h: log.debug ("fullArry: " + json.indent (fullArry))]
	[h, if (json.length (fullArry) > 0): profValue = 3]

	[h: searchArgs = json.set (searchArgs, "type", "expertise")]
	[h: expertArry = dndb_searchGrantedModifiers (searchArgs)]
	[h: log.debug ("expertArry: " + json.indent (expertArry))]
	[h, if (json.length (expertArry) > 0): profValue = 4]

	[h: bonusArry = "[]"]
	<!-- bonuses array -->
	[h: searchArgs = json.set (searchArgs, "subType", searchSaveName,
							"property", "value",
							"type", "bonus")]
	[h: saveBonusArry = dndb_searchGrantedModifiers (searchArgs)]
	[h: log.debug ("saveBonusArry: " + json.indent (saveBonusArry))]
	
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
	[h: log.debug ("magicArry: " + json.indent (magicArry))]

	<!-- Misc Bonus -->
	[h: searchArgs = json.set (searchArgs, "typeId", "39")]
	[h: miscArry = dndb_searchJsonObject (searchArgs)]
	[h: log.debug ("miscArry: " + json.indent (miscArry))]

	<!-- Proficiency (character choice overrides) -->
	[h: searchArgs = json.set (searchArgs, "typeId", "41")]
	[h: profArry = dndb_searchJsonObject (searchArgs)]
	[h: log.debug ("profArry: " + json.indent (profArry))]
	
	[h: choiceProfValue = 0]
	[h, if (json.length(profArry) > 0): choiceProfValue = json.get (profArry, 0)]


	<!-- build the save -->
	[h: abilities = dndb_getAbilities (toon)]
	[h: bonusArry = ""]
	[h: totalBonus = 0]

	<!-- determine ability bonus -->
	[h: abilitySearchResult = dndb_searchJsonObject (json.set ("",
									"object", savesMap,
									"name", saveName,
									"property", "abilityBonus"))]
	[h: log.debug ("abilitySearchResult: " + abilitySearchResult)]
	[h: abilityBonusName = json.get (abilitySearchResult, 0)]
	[h: abilityBonus = json.get (abilities, abilityBonusName)]
	[h: bonusArry = json.append (bonusArry, json.set ("", "type", "Ability", "value", abilityBonus))]
	[h: totalBonus = totalBonus + abilityBonus]

	<!-- determine proficiency value -->
	[h, if (choiceProfValue > 0): actualProfValue = choiceProfValue;
								actualProfValue = round (math.max (profValue, allProfValue))]

	[h, switch (actualProfValue), code:
		case 1: {
			[h: profBonus = 0]
			[h: proficient = ""]
		};
		case 2: {
			[h: profBonus = round (math.floor (profBonus / 2))]
			[h: proficient = "half"]
		};
		case 3: {
			[h: profBonus = dndb_getProficiencyBonus (toon)]
			[h: proficient = "proficient"]
		};
		case 4: {
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
	[h: bonus = 0]
	[h, foreach (saveBonus, saveBonusArry): bonus = bonus + saveBonus]
	[h, foreach (allSaveBonus, allSaveBonusArry): bonus = bonus + allSaveBonus]
	[h: bonusArry = json.append (bonusArry, json.set ("", "type", "Bonus", "value", bonus))]
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

	[h: savingThrow = json.set (savingThrow, "totalBonus", totalBonus,
									"bonuses", bonusArry)]
	[h: finalSaves = json.append (finalSaves, savingThrow)]							
}]

[h: macro.return = finalSaves]


