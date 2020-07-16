<!-- Callers must pass in the character json themselves. No getter methods should shoulder the getCharJSON -->
[h: character = arg(0)]

[h: abilityMap = json.set ("", "strength", 0, "dexterity", 1, "constitution", 2, "intelligence", 3, "wisdom", 4, "charisma", 5)]

[h: abilityScoreMap = "{}"]
[h: modifiers = json.path.read (character, "data.modifiers")]
[h, foreach (ability, json.fields (abilityMap)), code: {
	[index = json.get (abilityMap, ability)]
	[base = json.path.read (character, "data.stats[" + index + "].value")]
	[bonus = replace (json.path.read (character, "data.bonusStats[" + index + "].value"), "null", 0)]
	[base = base + bonus]
	
	[h: searchObj = json.set ("", "object", modifiers, "property", "value", 
											"subType", ability + "-score",
											"type", "bonus")]
	[h: bonuses = dndb_searchJsonObject (searchObj)]
	[h, foreach (bonus, bonuses): base = base + bonus]

	[h: searchObj = json.set (searchobj, "type", "set")]									
	[h: override = dndb_Array_max(dndb_searchJsonObject (searchObj))]
	[h, if (isNumber (override)): base = override; ""]

	[h: override = json.path.read (character, "data.overrideStats[" + index + "].value")]
	[h, if (isNumber (override)): base = override; ""]
	[h: abilityScoreMap = json.set (abilityScoreMap, ability, base)]
}]

[h: baseStr = json.get (abilityScoreMap, "strength")]
[h: baseDex = json.get (abilityScoreMap, "dexterity")]
[h: baseCon = json.get (abilityScoreMap, "constitution")]
[h: baseInt = json.get (abilityScoreMap, "intelligence")]
[h: baseWis = json.get (abilityScoreMap, "wisdom")]
[h: baseCha = json.get (abilityScoreMap, "charisma")]

[h: attributes = json.set("", "str", baseStr,
							"strBonus", round (math.floor ((baseStr - 10) / 2)),
							"dex", baseDex,
							"dexBonus", round (math.floor ((baseDex - 10) / 2)),
							"con", baseCon,
							"conBonus", round (math.floor ((baseCon - 10) / 2)),
							"int", baseInt,
							"intBonus", round (math.floor ((baseInt - 10) / 2)),
							"wis", baseWis,
							"wisBonus", round (math.floor ((baseWis - 10) / 2)),
							"cha", baseCha,
							"chaBonus", round (math.floor ((baseCha - 10) / 2))
							)]
							
[h: log.debug ("dndb_getAbilities: " + attributes)]
[h: macro.return = attributes]