[h: customActions = arg(0)]
[h: customAttacks = "{}"]
<!-- If there isnt anything to do, just leave -->
[h: return (json.length (customActions) > 0, customAttacks)]
<!-- We need this to translate some things -->
[h: ruleData = dndb_getRuleData()]
[h, foreach (customAction, customActions), code: {
	[actionName = json.get (customAction, "name")]
	[actionLabel = replace (actionName, ",", " ")]
	[ability = json.get (customAction, "statId")]
	[isProficient = json.get (customAction, "isProficient")]
	[damageTypeId = json.get (customAction, "damageTypeId")]
	<!-- our attack expressions dont include damage only spell stuff, so
	    anything without a rangeId (melee, ranged) set will be ignored -->
	[rangeId = json.get (customAction, "rangeId")]
	[damageTypeId = json.get (customAction, "damageTypeId")]
	[dmgDice = json.get (customAction, "diceCount")]
	[if (!isNumber(dmgDice)): dmgDice = 1]
	[dmgDie = json.get (customAction, "diceType")]
	[if (!isNumber(dmgDie)): dmgDie = 1]
	[dmgBonus = json.get (customAction, "fixedValue")]
	[if (!isNumber(dmgBonus)): dmgBonus = 0]
	[log.debug ("name = " + actionName + "; rangeId = " + rangeId + "; ability = " + 
		ability + "; damageTypeId = " + damageTypeId)]
	[if (isNumber (rangeId) && isNumber (ability)), code: {
		[attackExpression = dnd5e_RollExpression_SpellAttack (actionName, ability - 1)]
		[if (isProficient == "true"):
			attackExpression = dnd5e_RollExpression_setProficiency (attackExpression, 1)]
		[if (isNumber (damageTypeId)):
			damageValue = json.path.read (ruleData, "data.damageTypes[*].[?(@.id == " +
				damageTypeId + ")]['name']");
			damageValue = ""]
		[log.debug ("damageValue = " + damageValue)]
		[damageExpression = dnd5e_RollExpression_Damage (actionName, dmgDice + "d" + dmgDie  +
			"+" + dmgBonus)]
		[damageExpression = dnd5e_RollExpression_setSpellcastingAbility (damageExpression, ability - 1)]
		[damageExpression = dnd5e_RollExpression_setDamageTypes (damageExpression, damageValue)]
		[rollExpression = json.append ("", attackExpression, damageExpression)]
		[customAttacks = json.set (customAttacks, actionLabel, rollExpression)]
	}]
}]


[h: macro.return = customAttacks]