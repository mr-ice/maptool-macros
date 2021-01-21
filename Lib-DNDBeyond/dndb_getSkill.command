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
[h: skills = json.append ("",
		json.set ("", "name", "Acrobatics", "ability", "Dexterity", "entityId", "3", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Animal Handling", "ability", "Wisdom", "entityId", "11", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Arcana", "ability", "Intelligence", "entityId", "6", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Athletics", "ability", "Strength", "entityId", "2", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Deception", "ability", "Charisma", "entityId", "16", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "History", "ability", "Intelligence", "entityId", "7", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Insight", "ability", "Wisdom", "entityId", "12", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Intimidation", "ability", "Charisma", "entityId", "17", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Investigation", "ability", "Intelligence", "entityId", "8", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Medicine", "ability", "Wisdom", "entityId", "13", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Nature", "ability", "Intelligence", "entityId", "9", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Perception", "ability", "Wisdom", "entityId", "14", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Performance", "ability", "Charisma", "entityId", "18", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Persuasion", "ability", "Charisma", "entityId", "19", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Religion", "ability", "Intelligence", "entityId", "10", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Sleight of Hand", "ability", "Dexterity", "entityId", "4", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Stealth", "ability", "Dexterity", "entityId", "5", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "Survival", "ability", "Wisdom", "entityId", "15", "bonuses", "{}", "bonus", 0)
)]
[h: abilitiesArry = json.append ("",
		json.set ("", "name", "strAbility", "ability", "Strength", "entityId", "dummyId", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "dexAbility", "ability", "Dexterity", "entityId", "dummyId", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "conAbility", "ability", "Constitution", "entityId", "dummyId", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "intAbility", "ability", "Intelligence", "entityId", "dummyId", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "wisAbility", "ability", "Wisdom", "entityId", "dummyId", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "chaAbility", "ability", "Charisma", "entityId", "dummyId", "bonuses", "{}", "bonus", 0),
		json.set ("", "name", "allAbility", "ability", "None", "entityId", "dummyId", "bonuses", "{}", "bonus", 0)
)]

[h: data = json.get (toon, "data")]
[h: dataRetains = json.append ("", "modifiers", "inventory", "classes", "stats", "bonusStats", "overrideStats")]
[h: skinnyData = dndb_getSkinnyObject (data, dataRetains)]
<!-- Skinnify the toon -->
[h: fatToon = toon]
[h: toon = json.set (toon, "data", skinnyData)]

<!-- TODO: Ability proficiencies are no longer included within the skill obj. Now need -->
<!-- to set them separately and let the token handle calculation -->
<!-- For bardly 'everybody gets half', we will just set the allAbility proficiency to half-->

<!-- The most frustrating part about any DTO is trying to sniff out the weird places for user override -->
<!-- values. And its an edge case anyways! So lets fetch all the relevant character values outside of -->
<!-- of the skill loop and just cobble up a dumb map of relevant values -->
[h: characterValues = json.path.read (fatToon, "data.characterValues")]
[h: characterValuesSearchObj = json.set ("", "object", characterValues,
					"valueTypeId", SKILL_ENTITY_TYPE_ID)]
[h: skillValues = dndb_searchJsonObject (characterValuesSearchObj)]
[h: log.debug (getMacroName() + ": skillValues = " + skillValues)]

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
	[h, if (json.length (halfProfs) > 0): proficientValue = 0.5]
	[h, if (json.length (proficiencies) > 0): proficientValue = 1]
	[h, if (json.length (expertise) > 0): proficientValue = 2]

	[h: skill = json.set (skill, "proficient", proficientValue)]
	

	 <!-- now look for the other ridiculousness -->
	[h: searchArgs = json.set ("", "object", skillValues,
					"valueId", entityId)]
	[h: characterValues = dndb_searchJsonObject (searchArgs)]
	
	[h: bonuses = "{}"]
	<!-- for each choice, inspect the typeId -->
	[h, foreach (characterValue, characterValues), code: {
		<!-- Im at my MapTool nested code limit and I need to go deeper. There are ways around it, but lets try and play by the rules -->
		<!-- Just capture the machine friendly values and transform them out of this loop -->
		[h: typeId = json.get (characterValue, "typeId")]
		[h, switch (typeId):
			case 23: typeLabel = "Override";
			case 24: typeLabel = "MiscBonus";
			case 25: typeLabel = "MagicBonus";
			case 26: typeLabel = "Proficiency";
			case 27: typeLabel = "StatOverride";
			default: typeLabel = typeId;
		]
		[h: value = json.get (characterValue, "value")]
		[h: bonus = json.set ("{}", "typeId", typeId, "value", value)]
		[h: bonuses = json.set (bonuses, typeLabel, bonus)]
	}]
	[h: skill = json.set (skill, "bonuses", bonuses)]
	<!-- Weve discovered all the details, but transforming will require another more nesting -->
	<!-- Delegate it. -->

	[h: skill = dndb_transformSkill (toon, skill, skillMods)]
	[h: afterSkillList = json.append (afterSkillList, skill)]
	
}]

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
		case "expertise": tempAbilityValue = 2;
		case "proficiency": tempAbilityValue = 1;
		case "half-proficiency": tempAbilityValue = 0.5;
		default: tempAbilityValue = 0]
	[h: abilityValue = math.max (abilityValue, tempAbilityValue)]
}]
<!-- Wonder when I should care about per-ability proficiencies and bonuses? -->
[h, foreach (ability, abilitiesArry), code: {
	[abilityName = json.get (ability, "name")]
	[if (abilityName == "allAbility"): 
		ability = json.set (ability, "proficient", abilityValue); 
		ability = json.set (ability, "proficient", 0)
	]
	[afterSkillList = json.append (afterSkillList, ability)]
}]

<!-- all done -->
<!-- not quite! Bonus arry needs non-choice bonus also. And give the refactoring one more go -->
<!-- see saves as a new template -->
[h: macro.return = afterSkillList]

