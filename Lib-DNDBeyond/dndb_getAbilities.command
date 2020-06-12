<!-- Callers must pass in the character json themselves. No getter methods should shoulder the getCharJSON -->
[h: character = arg(0)]

<!-- Base stats -->
[h: baseStr = json.path.read (character, "data.stats[0].value")]
[h: baseDex = json.path.read (character, "data.stats[1].value")]
[h: baseCon = json.path.read (character, "data.stats[2].value")]
[h: baseInt = json.path.read (character, "data.stats[3].value")]
[h: baseWis = json.path.read (character, "data.stats[4].value")]
[h: baseCha = json.path.read (character, "data.stats[5].value")]

<!-- Bonus stats -->
[h: bonusStr = replace (json.path.read (character, "data.bonusStats[0].value"), "null", 0)]
[h: bonusDex = replace (json.path.read (character, "data.bonusStats[1].value"), "null", 0)]
[h: bonusCon = replace (json.path.read (character, "data.bonusStats[2].value"), "null", 0)]
[h: bonusInt = replace (json.path.read (character, "data.bonusStats[3].value"), "null", 0)]
[h: bonusWis = replace (json.path.read (character, "data.bonusStats[4].value"), "null", 0)]
[h: bonusCha = replace (json.path.read (character, "data.bonusStats[5].value"), "null", 0)]

[h: baseStr = baseStr + bonusStr]
[h: baseDex = baseDex + bonusDex]
[h: baseCon = baseCon + bonusCon]
[h: baseInt = baseInt + bonusInt]
[h: baseWis = baseWis + bonusWis]
[h: baseCha = baseCha + bonusCha]

<!-- Ability improvements -->
[h: strBonuses = json.path.read (character, ".[?(@.subType == 'strength-score')]['fixedValue']")]
[h: dexBonuses = json.path.read (character, ".[?(@.subType == 'dexterity-score')]['fixedValue']")]
[h: conBonuses = json.path.read (character, ".[?(@.subType == 'constitution-score')]['fixedValue']")]
[h: intBonuses = json.path.read (character, ".[?(@.subType == 'intelligence-score')]['fixedValue']")]
[h: wisBonuses = json.path.read (character, ".[?(@.subType == 'wisdom-score')]['fixedValue']")]
[h: chaBonuses = json.path.read (character, ".[?(@.subType == 'charisma-score')]['fixedValue']")]

[h, foreach (strBonus, strBonuses): baseStr = baseStr + strBonus]
[h, foreach (dexBonus, dexBonuses): baseDex = baseDex + dexBonus]
[h, foreach (conBonus, conBonuses): baseCon = baseCon + conBonus]
[h, foreach (intBonus, intBonuses): baseInt = baseInt + intBonus]
[h, foreach (wisBonus, wisBonuses): baseWis = baseWis + wisBonus]
[h, foreach (chaBonus, chaBonuses): baseCha = baseCha + chaBonus]

<!-- Get Override stats and replace base w/ those. Apply only non-zero values -->
[h: overrideStr = json.path.read (character, "data.overrideStats[0].value")]
[h: overrideDex = json.path.read (character, "data.overrideStats[1].value")]
[h: overrideCon = json.path.read (character, "data.overrideStats[2].value")]
[h: overrideInt = json.path.read (character, "data.overrideStats[3].value")]
[h: overrideWis = json.path.read (character, "data.overrideStats[4].value")]
[h: overrideCha = json.path.read (character, "data.overrideStats[5].value")]

[h, if (isNumber (overrideStr)): baseStr = overrideStr]
[h, if (isNumber (overrideDex)): baseDex = overrideDex]
[h, if (isNumber (overrideCon)): baseCon = overrideCon]
[h, if (isNumber (overrideInt)): baseInt = overrideInt]
[h, if (isNumber (overrideWis)): baseWis = overrideWis]
[h, if (isNumber (overrideCha)): baseCha = overrideCha]

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
							
[h: log.debug (attributes)]
[h: macro.return = attributes]