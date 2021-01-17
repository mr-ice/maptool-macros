[h: toon = arg (0)]
[h: skill = arg (1)]
[h: skillMods = arg (2)]

<!-- constants -->
[h: OVERRIDE = 23]
[h: MISC_BONUS = 24]
[h: MAGIC_BONUS = 25]
[h: PROF_LEVEL = 26]
[h: ABILITY_OVERRIDE = 27]

<!-- given a skill, calculate its bonus. The Skill obj weve been given should already -->

<!-- start with base skill -->
[h: log.debug (json.indent (skill))]
[h: bonuses = json.get (skill, "bonuses")]
[h: abilityOverride = json.get (bonuses, "StatOverride")]
[h: log.debug ("abilityOverride: " + abilityOverride)]
[h, if (json.isEmpty (abilityOverride)), code: {
	[h: skillAbility = json.get (skill, "ability")]
}; {
	<!-- the value of this bonus corresponds to the ability position -->
	[h: abilityPos = json.get (abilityOverride, "value")]
	[h, switch (abilityPos):
		case 1: skillAbility = "Stength";
		case 2: skillAbility = "Dexterity";
		case 3: skillAbility = "Constitution";
		case 4: skillAbility = "Intelligence";
		case 5: skillAbility = "Wisdom";
		case 6: skillAbility = "Charisma"
	]
}]
[h: log.debug ("skillAbility: " + skillAbility)]
[h: skill = json.set (skill, "ability", skillAbility)]

<!-- Now determine proficiency -->
<!-- If background or class provided proficiency, its set in the skill already -->
[h: proficient = json.get (skill, "proficient")]
[h: log.debug ("current proficient: " + proficient)]
[h, if (proficient == ""): proficient = 0]

<!-- bonuses may override this -->
[h: profOverride = json.get (bonuses, "Proficiency")]
[h, if (!json.isEmpty (profOverride)), code: {
	[h: profValue = json.get (profOverride, "value")]
	[h, switch (profValue):
		case 1: proficient = 0;
		case 2: proficient = 0.5;
		case 3: proficient = 1;
		case 4: proficient = 2
	]
}]
[h: skill = json.set (skill, "proficient", proficient)]
<!-- and finally, sum up the bonuses in skillMods -->
[h: searchArg = json.set ("{}", "object", skillMods, 
					"type", "bonus",
					"property", "value", 
					"entityId", json.get (skill, "entityId"))]
[h: results = dndb_searchJsonObject (searchArg)]
[h: log.debug (getMacroName() + ": skill mods results = " + results)]
[h: bonusVal = 0]
[h, foreach (result, results): bonusVal = bonusVal + result]
[h: skill = json.set (skill, "bonus", bonusVal)]

[h: log.debug (json.indent(skill))]
[h: macro.return = skill]