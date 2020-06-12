[h: toon = arg (0)]
[h: skill = arg (1)]

<!-- constants -->
[h: OVERRIDE = 23]
[h: MISC_BONUS = 24]
[h: MAGIC_BONUS = 25]
[h: PROF_LEVEL = 26]
[h: ABILITY_OVERRIDE = 27]

[h: NOT_PROFICIENT = "not"]
[h: HALF_PROFICIENT = "half"]
[h: FULL_PROFICIENT = "proficient"]
[h: EXPERT_PROFICIENT = "expert"]

<!-- given a skill, calculate its bonus. The Skill obj weve been given should already -->
<!-- be adorned with the relevant data to calculate, so very little lookup should be required-->
[h: abilities = dndb_getAbilities (toon)]

<!-- start with base skill -->
[h: log.debug (json.indent (skill))]
[h: abilityOverride = json.path.read (skill, "bonuses[*].[?(@.typeId == " + ABILITY_OVERRIDE + ")]")]
[h: log.debug ("abilityOverride: " + abilityOverride)]
[h, if (json.isEmpty (abilityOverride)), code: {
	[h: skillAbility = json.get (skill, "ability")]
}; {
	<!-- the value of this bonus corresponds to the ability position -->
	[h: abilityPos = json.path.read (abilityOverride, "[0].value")]
	[h, switch (abilityPos):
		case 0: skillAbility = "str";
		case 1: skillAbility = "dex";
		case 2: skillAbility = "con";
		case 3: skillAbility = "int";
		case 4: skillAbility = "wis";
		case 5: skillAbility = "cha"
	]
}]
[h: log.debug ("skillAbility: " + skillAbility)]
[h: abilityBonusName = skillAbility + "Bonus"]
[h: skillBonus = json.path.read (abilities, abilityBonusName)]
[h: log.debug ("skill bonus: " + skillBonus)]

<!-- Now determine proficiency -->
<!-- If background or class provided proficiency, its set in the skill already -->
[h: proficient = json.get (skill, "proficient")]
[h: log.debug ("current proficient: " + proficient)]
[h, if (proficient == ""): proficient = NOT_PROFICIENT]


<!-- bonuses may override this -->
[h: profOverride = json.path.read (skill, "bonuses[*].[?(@.typeId == " + PROF_LEVEL + ")]")]
[h, if (!json.isEmpty (profOverride)), code: {
	[h: profValue = json.path.read (profOverride, "[0].value")]
	[h, switch (profValue):
		case 1: proficient = NOT_PROFICIENT;
		case 2: proficient = HALF_PROFICIENT;
		case 3: proficient = FULL_PROFICIENT;
		case 4: proficient = EXPERT_PROFICIENT
	]
}]

<!-- determine the actual bonus -->
[h: proficiencyBonus = dndb_getProficiencyBonus (toon)]
[h: log.debug ("proficient after bonus: " + proficient + "; bonus: " + proficiencyBonus)]

<!-- So we made constants for reasons, but maptool hates freedom -->
[h, switch (proficient):
	case "not": proficiencyBonus = 0;
	case "half": proficiencyBonus = round (math.floor (proficiencyBonus / 2));
	case "proficient": proficiencyBonus;
	case "expert": proficiencyBonus = proficiencyBonus * 2
]
[h: log.debug ("Proficiency: " + proficient + " :: " + proficiencyBonus)]

<!-- Next, sniff out bonus values -->
[h: miscBonusArry = json.path.read (skill, "bonuses[*].[?(@.typeId == " + MISC_BONUS + ")]['value']")]
[h, if (!json.isEmpty (miscBonusArry)): miscBonus = json.get (miscBonusArry, 0); miscBonus = 0]
[h: magicBonusArry = json.path.read (skill, "bonuses[*].[?(@.typeId == " + MAGIC_BONUS + ")]['value']")]
[h, if (!json.isEmpty (magicBonusArry)): magicBonus = json.get (magicBonusArry, 0); magicBonus = 0]

<!-- and finally, the arbitrary override value -->
[h: overrideBonusArry = json.path.read (skill, "bonuses[*].[?(@.typeId == " + OVERRIDE + ")]['value']")]

[h, if (!json.isEmpty (overrideBonusArry)): override = json.get (overrideBonusArry, 0); override = ""]
[h: log.debug ("overrideBonusArry :" + overrideBonusArry + " :: override = " + override)]
<!-- enough lookin, get to doin -->
[h, if (override == ""): totalBonus = skillBonus + proficiencyBonus + miscBonus + magicBonus; totalBonus = override]
<!-- rewrite the bonus arry -->
[h: bonusArry = json.append ("",
				json.set ("", "type", "Magic", "value", magicBonus),
				json.set ("", "type", "Misc", "value", miscBonus),
				json.set ("", "type", "Proficiency", "value", proficiencyBonus),
				json.set ("", "type", "Ability", "value", skillBonus),
				json.set ("", "type", "Override", "value", override))]
[h, if (proficient == "not"): proficient = ""]
[h: skill = json.set (skill, "proficient", proficient, "bonuses", bonusArry, "totalBonus", totalBonus)]
[h: log.debug (json.indent(skill))]
[h: macro.return = skill]

