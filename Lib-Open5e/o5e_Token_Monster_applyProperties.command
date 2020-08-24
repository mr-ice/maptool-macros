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


<!-- now the interesting bits -->
<!-- first up, saves -->
[h: abilityList = json.append ("", "strength", "dexterity", "constitution",
							"intelligence", "wisdom", "charisma")]

[h: strSave = json.get (monsterJson, "strength_save")]
[h, if (!isNumber (strSave)): strSave = StrengthBonus; ""]
[h: prof = strSave - StrengthBonus]
[h: setProperty ("StrengthSave", "{" + prof + " + StrengthBonus}")]

[h, foreach (ability, abilityList), code: {
	[abilitySave = json.get (monsterJson, ability + "_save")]
	[h, if (!isNumber (abilitySave)): abilitySave = eval (ability + "Bonus"); ""]
	[h: prof = abilitySave - eval (ability + "Bonus")]
	[h: setProperty (ability + "Save", "{" + prof + " + " + ability + "Bonus}")]
}]

<!-- Skillz -->
[h: bonusSkillsMap = json.set ("", "acrobatics", "DexterityBonus",
"animal handling", "WisdomBonus",
"arcana", "IntelligenceBonus",
"athletics", "StrengthBonus",
"deception", "CharismaBonus",
"history", "IntelligenceBonus",
"insight", "WisdomBonus",
"intimidation", "CharismaBonus",
"investigation", "IntelligenceBonus",
"medicine", "WisdomBonus",
"nature", "IntelligenceBonus",
"perception", "WisdomBonus",
"performance", "CharismaBonus",
"persuasion", "CharismaBonus",
"religion", "IntelligenceBonus",
"sleight of hand", "DexterityBonus",
"stealth", "DexterityBonus",
"survival", "WisdomBonus")]

<!-- Havent yet seen an example of a monster w/ proficiency in Animal Handling.
    So going to assume the spaces are replaced with underscores -->
[h: monsterSkills = json.get (monsterJson, "skills")]
[h: log.debug ("monsterSkills: " + monsterSkills)]
[h, foreach (key, json.fields (bonusSkillsMap)), code: {
	[abilityBonusName = json.get (bonusSkillsMap, key)]
	[abilityBonus = eval (abilityBonusName)]
	[monsterSkillKey = replace (key, " ", "_")]
	[monsterSkill = json.get (monsterSkills, monsterSkillKey)]
	[log.debug ("monsterSkillKey: " + monsterSkillKey + "; monsterSkill = " + monsterSkill)]
	[if (monsterSkill == ""): monsterSkill = abilityBonus; ""]
	[prof = monsterSkill - abilityBonus]
	[setProperty (key, "{" + prof + " + " + abilityBonusName + "}")]
}]
