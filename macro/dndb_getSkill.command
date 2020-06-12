[h: toon = arg(0)]
[h, if (json.length (macro.args) > 1): skillName = arg(1); skillName = "_all"]
<!-- Constants -->
<!-- If we have to revisit skill searching, we may be able to convert the search from -->
<!-- change entityId to valueId to match up with the pattern in saving throw -->
<!-- entityId to typeId == 23 -->
[h: SKILL_ENTITY_TYPE_ID = "1958004211"]

<!-- oddly enough, toon has no base information for skills, only bonuses. So we have -->
<!-- to build it from scratch -->
<!-- oh fuck, the only thing in the toon to point to individual skills are jackass valueIds -->
<!-- So Ima need to map those, also -->
[h: preSkills = json.append ("",
		json.set ("", "name", "Acrobatics", "ability", "dex", "entityId", "3"),
		json.set ("", "name", "Animal Handling", "ability", "wis", "entityId", "11"),
		json.set ("", "name", "Arcana", "ability", "int", "entityId", "6"),
		json.set ("", "name", "Athletics", "ability", "str", "entityId", "2"),
		json.set ("", "name", "Deception", "ability", "cha", "entityId", "16"),
		json.set ("", "name", "History", "ability", "int", "entityId", "7"),
		json.set ("", "name", "Insight", "ability", "wis", "entityId", "12"),
		json.set ("", "name", "Intimidation", "ability", "cha", "entityId", "17"),
		json.set ("", "name", "Investigation", "ability", "int", "entityId", "8"),
		json.set ("", "name", "Medicine", "ability", "wis", "entityId", "13"),
		json.set ("", "name", "Nature", "ability", "int", "entityId", "9"),
		json.set ("", "name", "Perception", "ability", "wis", "entityId", "14"),
		json.set ("", "name", "Performance", "ability", "cha", "entityId", "18"),
		json.set ("", "name", "Persuasion", "ability", "cha", "entityId", "19"),
		json.set ("", "name", "Religion", "ability", "int", "entityId", "10"),
		json.set ("", "name", "Sleight of Hand", "ability", "dex", "entityId", "4"),
		json.set ("", "name", "Stealth", "ability", "dex", "entityId", "5"),
		json.set ("", "name", "Survival", "ability", "wis", "entityId", "15")
)]

[h: skills = "[]"]
[h, foreach (skill, preSkills), code: {
	[h, if (skillName == "_all" || skillName == json.get (skill, "name")): skills = json.append (skills, skill)] 
}]

<!-- Lets call this the Rex Redrum bug: features that grant all ability checks some level of proficiency have -->
<!-- to be accounted for, but they wont be found tied to any particular skill -->
[h: abilitySearchArgs = json.set ("", "object", toon, 
						"subType", "ability-checks",
						"type", "expertise")]
<!-- what fucking DM allowed this? -->
[h: abilityExpertise = dndb_searchGrantedModifiers (abilitySearchArgs)]

[h: abilitySearchArgs = json.set (abilitySearchArgs, "type", "proficiency")]
[h: abilityProficiency = dndb_searchGrantedModifiers (abilitySearchArgs)]

[h: abilitySearchArgs = json.set (abilitySearchArgs, "type", "half-proficiency")]
[h: abilityHalfProficiency = dndb_searchGrantedModifiers (abilitySearchArgs)]

[h: abilityValue = 0]
[h, if (json.length (abilityHalfProficiency) > 0): abilityValue = 1]
[h, if (json.length (abilityProficiency) > 0): abilityValue = 2]
[h, if (json.length (abilityExpertise) > 0): abilityValue = 3]

<!-- Since we cant modify existing skill objects, well build new ones instead. Stuff them into this array -->
[h: afterSkillList = "[]"]

[h, foreach (skill, skills), code: {
    [h: log.debug ("skill: " + skill)]
	[h: entityId = json.get (skill, "entityId")]
	[h: name = json.get (skill, "name")]

	<!-- Start with proficiencies -->
	<!-- Looks for the proficiencies granted by background, class, race, etc -->
	[h: searchArgs = json.set ("", "object", toon,
							"entityTypeId", SKILL_ENTITY_TYPE_ID,
							"type", "expertise",
							"entityId", entityId)]
	[h: expertise = dndb_searchGrantedModifiers (searchArgs)]
	[h: log.debug ("Expertise: " + json.indent (expertise))]

	[h: searchArgs = json.set (searchArgs, "type", "proficiency")]
	[h: proficiencies = dndb_searchGrantedModifiers (searchArgs)]
	[h: log.debug ("Proficiencies: " + json.indent (proficiencies))]

	[h: searchArgs = json.set (searchArgs, "type", "half-proficiency")]
	[h: halfProfs = dndb_searchGrantedModifiers (searchArgs)]
	[h: log.debug ("Half Profs: " + json.indent (halfProfs))]

	<!-- go from least to best -->
	[h: proficientValue = 0]
	[h, if (json.length (halfProfs) > 0): proficientValue = 1]
	[h, if (json.length (proficiencies) > 0): proficientValue = 2]
	[h, if (json.length (expertise) > 0): proficientValue = 3]

	[h: actualValue = round (math.max (abilityValue, proficientValue))]
	[h, switch (actualValue):
		case 0: proficientStr = "";
		case 1: proficientStr = "half";
		case 2: proficientStr = "proficient";
		case 3: proficientStr = "expert"
	]
	
	[h: skill = json.set (skill, "proficient", proficientStr)]

	 <!-- now look for the other ridiculousness -->
	[h: searchArgs = json.set ("", "object", toon,
					"valueTypeId", SKILL_ENTITY_TYPE_ID, 
					"valueId", entityId)]
	[h: characterValues = dndb_searchGrantedModifiers (searchArgs)]
	[h: log.debug ("characterValues: " + characterValues)]
	
	[h: bonuses = "[]"]
	<!-- for each choice, inspect the typeId -->
	[h, foreach (characterValue, characterValues), code: {
		<!-- Im at my MapTool nested code limit and I need to go deeper. There are ways around it, but lets try and play by the rules -->
		<!-- Just capture the machine friendly values and transform them out of this loop -->
		[h: typeId = json.get (characterValue, "typeId")]
		[h, switch (typeId):
			case 23: typeLabel = "Override";
			case 24: typeLabel = "Misc. Bonus";
			case 25: typeLabel = "Magic Bonus";
			case 26: typeLabel = "Proficiency";
			case 27: typeLabel = "Stat Override";
			default: typeLabel = typeId;
		]
		[h: value = json.get (characterValue, "value")]
		[h: bonuses = json.append (bonuses, json.set ("", 
									"typeId", typeId,
									"typeLabel", typeLabel, 
									"value", value))]
	}]
	[h: skill = json.set (skill, "bonuses", bonuses)]
	<!-- Weve discovered all the details, but transforming will require another more nesting -->
	<!-- Delegate it. -->

	[h: skill = dndb_transformSkill (toon, skill)]
	[h: afterSkillList = json.append (afterSkillList, skill)]
	
}]

<!-- all done -->
<!-- not quite! Bonus arry needs non-choice bonus also. And give the refactoring one more go -->
<!-- see saves as a new template -->
[h: macro.return = afterSkillList]

