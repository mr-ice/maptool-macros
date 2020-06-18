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
		json.set ("", "name", "Survival", "ability", "wis", "entityId", "15"),
		json.set ("", "name", "Strength Ability", "ability", "str", "entityId", "dummyId"),
		json.set ("", "name", "Dexterity Ability", "ability", "dex", "entityId", "dummyId"),
		json.set ("", "name", "Constitution Ability", "ability", "con", "entityId", "dummyId"),
		json.set ("", "name", "Intelligence Ability", "ability", "int", "entityId", "dummyId"),
		json.set ("", "name", "Wisdom Ability", "ability", "wis", "entityId", "dummyId"),
		json.set ("", "name", "Charisma Ability", "ability", "cha", "entityId", "dummyId")
)]

[h: skills = "[]"]
[h, foreach (skill, preSkills), code: {
	[h, if (skillName == "_all" || skillName == json.get (skill, "name")): skills = json.append (skills, skill)] 
}]

[h: data = json.get (toon, "data")]
[h: dataRetains = json.append ("", "modifiers", "inventory", "classes", "stats", "bonusStats", "overrideStats")]
[h: skinnyData = dndb_getSkinnyObject (data, dataRetains)]
<!-- Skinnify the toon -->
[h: fatToon = toon]
[h: toon = json.set (toon, "data", skinnyData)]

<!-- Lets call this the Rex Redrum bug: features that grant all ability checks some level of proficiency have -->
<!-- to be accounted for, but they wont be found tied to any particular skill -->
<!-- Find ALL modifiers related to ability-checks -->
[h: abilitySearchArgs = json.set ("", "object", toon, 
						"subType", "ability-checks")]
[h: abilityMods = dndb_searchGrantedModifiers (abilitySearchArgs)]

<!-- Now tease out the interesting bits -->
<!-- No need to keep searching for stuff. This arry shouldnt be very big -->
[h: abilityValue = 0]
[h, foreach (abilityMod, abilityMods), code: {
	[h: value = json.get (abilityMod, "type")]
	[h, switch (value):
		case "expertise": tempAbilityValue = 3;
		case "proficiency": tempAbilityValue = 2;
		case "half-proficiency": tempAbilityValue = 1;
		default: tempAbilityValue = 0]
	[h: abilityValue = math.max (abilityValue, tempAbilityValue)]
}]

<!-- The most frustrating part about any DTO is trying to sniff out the weird places for user override -->
<!-- values. And its an edge case anyways! So lets fetch all the relevant character values outside of -->
<!-- of the skill loop and just cobble up a dumb map of relevant values -->
[h: characterValues = json.path.read (fatToon, "data.characterValues")]
[h: characterValuesSearchObj = json.set ("", "object", characterValues,
					"valueTypeId", SKILL_ENTITY_TYPE_ID)]
[h: skillValues = dndb_searchJsonObject (characterValuesSearchObj)]


<!-- Since we cant modify existing skill objects, well build new ones instead. Stuff them into this array -->
[h: afterSkillList = "[]"]

[h: toon = json.set (toon, "data", skinnyData)]
[h: skillSearchArgs = json.set ("", "object", toon,
							"entityTypeId", SKILL_ENTITY_TYPE_ID)]
[h: skillMods = dndb_searchGrantedModifiers (skillSearchArgs)]


<!-- Too many uncertainties here, so just go through the skill list -->
<!-- Fall back to the generic search instead of more granted modifiers search -->
[h, foreach (skill, skills), code: {
    [h: log.debug ("skill: " + skill)]
	[h: entityId = json.get (skill, "entityId")]
	[h: name = json.get (skill, "name")]

	<!-- Start with proficiencies -->
	<!-- Looks for the proficiencies granted by background, class, race, etc -->
	[h: searchArgs = json.set ("", "object", skillMods,
							"type", "expertise",
							"entityId", entityId)]
	[h: expertise = dndb_searchJsonObject (searchArgs)]

	[h: searchArgs = json.set (searchArgs, "type", "proficiency")]
	[h: proficiencies = dndb_searchJsonObject (searchArgs)]

	[h: searchArgs = json.set (searchArgs, "type", "half-proficiency")]
	[h: halfProfs = dndb_searchJsonObject (searchArgs)]

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
	[h: searchArgs = json.set ("", "object", skillValues,
					"valueId", entityId)]
	[h: characterValues = dndb_searchJsonObject (searchArgs)]
	
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

