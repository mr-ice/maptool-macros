[h: monsterJson = arg (0)]
[h: o5e_Constants (getMacroName())]
[h: overwriteName = dnd5e_Preferences_getPreference (PREF_OVERWRITE_NAME)]
[h: useGmName = dnd5e_Preferences_getPreference (PREF_USE_GM_NAME)]
[h: dnd5e_Property_resetCalculatedProperties()]
[h: monsterName = json.get (monsterJson, "name")]
[h: setProperty ("Character ID", monsterName)]
[h, if (overwriteName), code: {
	[if (useGmName): setGMName (monsterName); setName (monsterName)]
}; {}]
[h: setSize (json.get (monsterJson, "size"))]
[h: race = json.get (monsterJson, "type")]
[h: class = json.get (monsterJson, "subtype")]
[h: alignment = json.get (monsterJson, "alignment")]
[h: AC = json.get (monsterJson, "armor_class")]
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
[h: hpTypeIdx = dnd5e_Preferences_getPreference (PREF_HIT_DICE_ROLL)]
[h: hpType = json.get (VALUES_HIT_DICE_ROLL, hpTypeIdx)]
[h: log.debug (CATEGORY + "## hpType = " + hpType)]
[h: hdString = json.get (monsterJson, "hit_dice")]
[h: hdObj = dnd5e_Util_parseRollString (hdString)]
[h: HitDice = json.get (hdObj, "diceRolled") + "d" + json.get (hdObj, "diceSize")]
<!-- 10d10+50 -->
[h, if (hpType == VALUE_HIT_DICE_AVG), code: {
	[HP = json.get (monsterJson, "hit_points")]
};{
	[HP = evalMacro ("[r: " + HitDice + " + " + BonusHP + "]")]
}]
[h: MaxHP = HP]
[h: CRString = json.get (monsterJson, "challenge_rating")]
[h, if (CRString == ""): CRString = "0"]
[h: evalMacro ("[h: CR = " + CRString + "]")]
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
[h: dnd5e_Util_Token_setDrawOrder (currentToken())]
[h: setProperty (PROP_MONSTER_TOON_JSON, monsterJson)]
[h: setProperty (PROP_MONSTER_TOON_VERSION, MONSTER_TOON_VERSION)]