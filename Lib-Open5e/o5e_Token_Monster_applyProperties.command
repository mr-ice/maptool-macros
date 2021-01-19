[h: monsterJson = arg (0)]
[h: setProperty ("Character ID", json.get (monsterJson, "slug"))]
[h: setName (json.get (monsterJson, "name"))]
[h: setSize (json.get (monsterJson, "size"))]
[h: race = json.get (monsterJson, "type")]
[h: class = json.get (monsterJson, "subtype")]
[h: alignment = json.get (monsterJson, "alignment")]
[h: AC = json.get (monsterJson, "armor_class")]
[h: HP = json.get (monsterJson, "hit_points")]
[h: MaxHP = HP]
[h: speedObj = json.get (monsterJson, "speed")]
[h: Walk = json.get (speedObj, "walk")]
[h: Swim = json.get (speedObj, "swim")]
[h: Burrow =  json.get (speedObj, "burrow")]
[h: Fly = json.get (speedObj, "fly")]
[h: Climb = json.get (speedObj, "climb")]
[h: Strength = json.get (monsterJson, "strength")]
[h: Dexterity = json.get (monsterJson, "dexterity")]
[h: Constitution = json.get (monsterJson, "constitution")]
[h: Intelligence = json.get (monsterJson, "intelligence")]
[h: Wisdom = json.get (monsterJson, "wisdom")]
[h: Charisma = json.get (monsterJson, "charisma")]
[h: Vulnerabilities = json.get (monsterJson, "damage_vulnerabilities")]
[h: Resistances = json.get (monsterJson, "damage_resistances")]
[h: Immunities = json.get (monsterJson, "damage_immunities")]
[h: ConditionImmunities = json.get (monsterJson, "condition_immunities")]
[h: o5e_Token_applySenses (json.get (monsterJson, "senses"))]
[h: Languages = json.get (monsterJson, "languages")]
[h: CR = json.get (monsterJson, "challenge_rating")]
[h: Proficiency = floor(math.max (0, CR - 1) / 4) + 2]
[h: log.debug (getMacroName() + ": Proficiency = " + Proficiency)]
<!-- now the interesting bits -->
<!-- first up, saves -->
[h: abilityList = json.append ("", "strength", "dexterity", "constitution",
							"intelligence", "wisdom", "charisma")]
[h: abilitySaveMap = json.set ("", "strength", "strSave",
						"dexterity", "dexSave",
						"constitution", "conSave",
						"intelligence", "intSave",
						"wisdom", "wisSave",
						"charisma", "chaSave")]
						
[h, foreach (ability, abilityList), code: {
	[abilitySave = json.get (monsterJson, ability + "_save")]
	[log.debug (getMacroName() + ": abilitySave = " + abilitySave)]
	[abilityBonus = eval (ability + "Bonus")]
	<!-- before I calculate, I need it to be some kind of number instead of 'null' -->
	[if (!isNumber (abilitySave)): abilitySave = abilityBonus; ""]
	[remainder = abilitySave - abilityBonus]
	<!-- We have to infer proficiency and bonus values -->
	[bonusObj = o5e_Util_inferProficiencyAndBonus (remainder, Proficiency)]
	[saveProperty = json.get (abilitySaveMap, ability)]
		[log.debug (getMacroName() + ": ability = " + ability + "; abilityBonus = " + 
			abilityBonus + "; bonusObj = " + bonusObj)]
	[setProperty ("proficiency." + saveProperty, json.get (bonusObj, "proficiency"))]
	[setProperty ("bonus." + saveProperty, json.get (bonusObj, "bonus"))]
}]

<!-- Skillz -->
<!-- Havent yet seen an example of a monster w/ proficiency in Animal Handling.
    So going to assume the spaces are replaced with underscores -->
[h: monsterSkills = json.get (monsterJson, "skills")]
[h: log.debug ("monsterSkills: " + monsterSkills)]
[h, foreach (monsterSkill, json.fields (monsterSkills)), code: {
	<!-- subtract the related ability bonus (as currently calculated) from the total value -->
	<!-- Infer bonus and proficiency from that value -->
	<!-- This is "Strength" or "Dexterity", etc -->
	[ability = getProperty ("ability." + monsterSkill)]
	[abilityBonus = getProperty ("abilityBonus." + ability)]
	[log.debug (getMacroName() + ": abilityBonus = " + abilityBonus)]
	[totalSkillBonus = number(json.get (monsterSkills, monsterSkill))]
	[log.debug (getMacroName() + ": totalSkillBonus = " + totalSkillBonus)]
	[remainingBonus = totalSkillBonus - abilityBonus]
	[bonusObj = o5e_Util_inferProficiencyAndBonus (remainingBonus, Proficiency)]
	[setProperty ("proficiency." + monsterSkill, json.get (bonusObj, "proficiency"))]
	[setProperty ("bonus." + monsterSkill, json.get (bonusObj, "bonus"))]
}]
