[h: log.debug (getMacroName() + ": args = " + json.indent (macro.args))]
[h: spell = arg (0)]
[h: spellSlot = arg (1)]
[h, if (json.length (macro.args) > 2): advDisadvObj = arg (2); advDisadvObj = "{}"]
[h, if (json.length (macro.args) > 3): modRestriction = arg (3); modRestriction = ""]


[h: rollExpressions = "[]"]

<!-- if the spell is an attack, build an attack string -->
[h: requiresAttack = json.get (spell, "requiresAttackRoll")]
[h: spellName = json.get (spell, "name")]
[h: spellLevel = json.get (spell, "level")]
[h: spellDescription = json.get (spell, "description")]
[h, if (requiresAttack == "true"), code: {
	[if (json.get (advDisadvObj, "advantage") == "true" || json.get (advDisadvObj, "both") == "true"): hasAdvantage = 1; hasAdvantage = 0]
	[if (json.get (advDisadvObj, "disadvantage") == "true" || json.get (advDisadvObj, "both") == "true"): hasDisadvantage = 1; hasDisadvantage = 0]
	[if (json.get (advDisadvObj, "both") == "true"), code: {
		[hasAdvantage = 1]
		[hasDisadvantage = 1]
	}; {}]
	[h: attackBonus = json.get (spell, "attackBonus")]
	[attackExpression = dnd5e_RollExpression_Attack (spellName, attackBonus)]
	[attackExpression = dnd5e_RollExpression_setAdvantage (attackExpression, hasAdvantage)]
	[attackExpression = dnd5e_RollExpression_setDisadvantage (attackExpression, hasDisadvantage)]
}; {""}]

<!-- if the spell has a dice object, build that, whatever that is -->
[h: modifier = dndb_Util_selectSpellModifier (spell, modRestriction)]

[h: log.debug ("dndb_RollExpression_buildSpellRoll: modifier = " + modifier)]
[h: die = json.get (modifier, "die")]
[h: diceCount = 0]
[h: diceValue = 0]
[h: fixedValue = 0]
[h: totalRolls = 1]
[h: type = json.get (modifier, "friendlyTypeName")]
[h: subType = json.get (modifier, "friendlySubtypeName")]
[h: log.debug ("dndb_RollExpression_buildSpellRoll: die = " + die)]

[h, if (encode (die) != ""), code: {
	[h: diceCount = json.get (die, "diceCount")]
	[h: diceValue = json.get (die, "diceValue")]
	[h: fixedValue = json.get (die, "fixedValue")]
}; {""}]
[h: log.debug (getMacroName() + ": die = " + die)]
<!-- Magic Missle bug: is there a restriction of 'n Darts' -->
[h: restriction = json.get (modifier, "restriction")]
<!-- Cheat: just look for 3 Darts -->
[h, if (restriction == "3 Darts" || restriction == "3 Rays"): totalRolls = 3; ""]

<!-- Do we need to add the ability bonus -->
[h: usePrimaryStat = json.get (modifier, "usePrimaryStat")]
[h, if (usePrimaryStat == "true"): abilityBonus = json.get (spell, "abilityBonus"); 
								  abilityBonus = 0]

<!-- read "castAtHigherLevels": "true" first -->

[h: higherSpellDice = dndb_RollExpression_getHigherLevelDie (spell, spellSlot, modifier)]
[h: log.debug ("dndb_RollExpression_buildSpellRoll: higherSpellDice = " + higherSpellDice)]
[h, if (!json.isEmpty (higherSpellDice)), code: {
	[h: scaleType = json.get (higherSpellDice, "scaleType")]
	[h, if (scaleType == "characterlevel"), code: {
		[h: higherDiceCount = json.get (higherSpellDice, "diceCount")]
		[h: higherDiceValue = json.get (higherSpellDice, "diceValue")]
		[h: higherFixedValue = json.get (higherSpellDice, "fixedValue")]
		<!-- nested code limit reached. Do this the dumb way -->
		[h, if (number (higherDiceCount) > 0): diceCount = higherDiceCount; ""]
		[h, if (number (higherDiceCount) > 0): diceValue = higherDiceValue; ""]
		[h, if (number (higherDiceCount) > 0): fixedValue = higherFixedValue; ""]
	}; {""}]
	[h, if (scaleType == "spellscale"), code: {
		<!-- if the higherSpellDice diceCount is 0, then we need to increase our total
			rolls instead -->
		[h: higherDiceCount = json.get (higherSpellDice, "diceCount")]
		<!-- on second thought, only do this if its, uh, "darts" (cough magic missle) -->
		[h, if (higherDiceCount == 0 && (restriction == "3 Darts" || restriction == "3 Rays")): 
					higherTotalRolls = json.get (higherSpellDice, "totalRolls");
					higherTotalRolls = 0]
		[h: diceCount = diceCount + higherDiceCount]
		[h: totalRolls = totalRolls + higherTotalRolls]
	};{""}]
}]

[h, for ( i, 0, totalRolls), code: {
	[if (requiresAttack == "true"): rollExpressions = json.append (rollExpressions, attackExpression); ""]
	[h, if (!isNumber (diceCount)): diceCount = 0; ""]
	[h, if (diceCount > 0), code: {
		<!-- if the spell has a save, add it to the dice object expression description -->
		[h: rollExpression = json.set ("", "name", spellName,
											"diceSize", diceValue,
											"diceRolled", diceCount,
											"expressionTypes", type,
											"bonus", abilityBonus + fixedValue,

											"damageTypes", subType)]
		[h: rollExpressions = json.append (rollExpressions, rollExpression)]
	}; {""}]
}]
[h: log.debug (getMacroName() + ": rollExpressions = " + rollExpressions)]
[h: macro.return = rollExpressions]
