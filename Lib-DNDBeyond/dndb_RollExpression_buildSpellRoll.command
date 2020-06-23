[h: spell = arg (0)]
[h: spellSlot = arg (1)]

[h: rollExpressions = "[]"]

<!-- if the spell is an attack, build an attack string -->
[h: requiresAttack = json.get (spell, "requiresAttackRoll")]
[h: spellName = json.get (spell, "name")]
[h: spellLevel = json.get (spell, "level")]
[h: spellDescription = json.get (spell, "description")]
[h, if (requiresAttack == "true"), code: {
	[h: attackBonus = json.get (spell, "attackBonus")]
	[h: rollExpression = json.set ("", "name", spellName + " Attack",
								"bonus", attackBonus,
								"diceSize", "20",
								"diceRolled", "1",
								"expressionTypes", "Attack")]
	[h: rollExpressions = json.append (rollExpressions, rollExpression)]
}; {""}]

<!-- if the spell has a dice object, build that, whatever that is -->
[h: modifier = json.get (json.get (spell, "modifiers"), 0)]
[h: log.debug ("dndb_buildSpellRoll: modifier = " + modifier)]
[h: die = json.get (modifier, "die")]
[h: diceCount = 0]
[h: diceValue = 0]
[h: fixedValue = 0]
[h: totalRolls = 1]
[h: type = json.get (modifier, "friendlyTypeName")]
[h: subType = json.get (modifier, "friendlySubtypeName")]
[h: log.debug ("dndb_buildSpellRoll: die = " + die)]

[h, if (encode (die) != ""), code: {
	[h: diceCount = json.get (die, "diceCount")]
	[h: diceValue = json.get (die, "diceValue")]
	[h: fixedValue = json.get (die, "fixedValue")]
}; {""}]

[h: higherSpellDice = dndb_RollExpression_getHigherLevelDie (spell, spellSlot)]
[h: log.debug ("dndb_buildSpellRoll: higherSpellDice = " + higherSpellDice)]
[h, if (encode (higherSpellDice) != ""), code: {
	[h: scaleType = json.get (higherSpellDice, "scaleType")]
	[h, if (scaleType == "characterlevel"), code: {
		[h: diceCount = json.get (higherSpellDice, "diceCount")]
		[h: diceValue = json.get (higherSpellDice, "diceValue")]
		[h: fixedValue = json.get (higherSpellDice, "fixedValue")]			
	}; {""}]
	[h, if (scaleType == "spellscale"), code: {
		[h: diceCount = diceCount + json.get (higherSpellDice, "diceCount")]
		[h: diceValue = json.get (higherSpellDice, "diceValue")]
		[h: fixedValue = json.get (higherSpellDice, "fixedValue")]	
	};{""}]
}]
[h: log.debug ("dndb_buildSpllRoll: after getHigherLevelDie: diceCount = " + diceCount + "; diceValue = " + diceValue + "; fixedValue = " + fixedValue)]
[h, if (diceCount > 0), code: {
	<!-- if the spell has a save, add it to the dice object expression description -->
	[h: rollExpression = json.set ("", "name", spellName + " " + type,
											"diceSize", diceValue,
											"diceRolled", diceCount,
											"expressionTypes", type,

											"totalRolls", totalRolls,
											"damageType", subType)]
	[h: rollExpressions = json.append (rollExpressions, rollExpression)]
}; {""}]

[h: macro.return = rollExpressions]