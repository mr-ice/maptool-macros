[h: rollExpression = arg (0)]
[h: dnd5e_AE2_getConstants()]
[h: diceSize = dnd5e_RollExpression_getDiceSize (rollExpression)]
[h: diceRolled = dnd5e_RollExpression_getDiceRolled (rollExpression)]
[h: fullBonus = dnd5e_RollExpression_getBonus (rollExpression)]
[h: workingBonus = 0]
[h: bonusOutput = ""]
[h: type = dnd5e_RollExpression_getExpressionType(rollExpression)]	
[h, if (type == ATTACK_STEP_TYPE || type == DAMAGE_STEP_TYPE), code: {

	<!-- Add a weapon bonus? -->
	[h: types = dnd5e_RollExpression_getTypeNames(rollExpression)]
	[h, if (json.contains(types, "Weapon")), code: {
		[h: workingBonus = workingBonus + getProperty(json.get(type, "bonus"))]
		[h: type = getProperty(dnd5e_RollExpression_getWeaponType())]
		[h: type = json.get(WEAPON_TYPES, type)]
		[h: bonusOutput = bonusOutput + strformat("%s(%+d)", json.get(type, "type"), totalBonus)]
	}]

	<!-- Add an ability bonus? -->
	[h, if (json.contains(types, "spellcastingAbility")), code: {
		[h, if (length(bonusOutput) > 0): format = " + %s(%+d)"; format = "%s(%+d)"]
		[h: ability = dnd5e_RollExpression_getSpellcastingAbility(rollExpression)]
		[h, if (ability < 0): ability = json.length(CHAR_ABILITIES)]
		[h, if (ability < json.length(CHAR_ABILITIES)): abilityName = json.get(CHAR_ABILITIES, ability)]
		[h, if (ability < json.length(CHAR_ABILITIES)): bonusOutput = bonusOutput + strformat(format, abilityName, getProperty(abilityName + "Bonus"))]
		[h, if (ability < json.length(CHAR_ABILITIES)): workingBonus = workingBonus + getProperty(abilityName + "Bonus")]
	}]
	
	<!-- Add a proficiency bonus? -->
	[h, if (json.contains(types, "proficient")), code: {
		[h: workingBonus = workingBonus + getProperty("Proficiency")]
		[h, if (length(bonusOutput) > 0): format = " + Proficency(%+d)"; format = "Proficency(%+d)"]
		[h: bonusOutput = bonusOutput + strformat(format, getProperty("Proficiency"))]
	}]
	
	<!-- Any left over is a user bonus? -->
	[h: bonus = fullBonus - workingBonus]
	[h, if(bonus != 0), code: {
		[h, if (length(bonusOutput) > 0): format = " + Bonus(%+d)"]
		[h: bonusOutput = bonusOutput + strformat(format, bonus)]
	}]
	[h, if (length(bonusOutput) > 0): bonusOutput = " + " + bonusOutput]
};{ 
	[h, if(fullBonus != 0):  bonusOutput = if(fullBonus > 0, " + " + fullBonus, " - " + (fullBonus * -1))]
}]
[h, if(fullBonus != 0):  fullBonusOutput = if(fullBonus > 0, " + " + fullBonus, " - " + (fullBonus * -1)); fullBonusOutput = ""]
[h: baseRoll = diceRolled + "d" + diceSize]
[h: tooltipRoll = baseRoll + bonusOutput]
[h: individualRolls = json.get (rollExpression, "individualRolls")]
[h, if (!json.isEmpty(individualRolls)):tooltipDetail = "(" + json.toList(individualRolls, "+") + ")"; tooltipDetail = ""]
[h: tooltipDetail = tooltipDetail + fullBonusOutput]
[h: rollString = dnd5e_RollExpression_getRollString (rollExpression)]

<!-- iterate the children to get their tooltips and sub-totals -->
[h: childTipDetails = ""]
[h: childTipRolls = ""]
[h: childTotals = 0]
[h, foreach (child, dnd5e_RollExpression_getExpressions(rollExpression), ""), code: {
	[childTotal = dnd5e_RollExpression_getTotal (child)]
	[childTotals = childTotals + childTotal]
	[tipDetail = dnd5e_RollExpression_getTypedDescriptor (child, "tooltipDetail")]
	[childTipDetails = childTipDetails + " + " + tipDetail]
	[tipRoll = dnd5e_RollExpression_getTypedDescriptor (child, "tooltipRoll")]
	[childTipRolls = childTipRolls + " + " + tipRoll]
}]

[h: rolls = dnd5e_RollExpression_getRolls (rollExpression)]
[h: log.debug (getMacroName() + ": rolls = " + rolls)]
[h: totals = "[]"]
[h, foreach (roll, rolls), code: {
	[total = roll + fullBonus + childTotals]
	[totals = json.append (totals, total)]
}]

[h: roll = dnd5e_RollExpression_getRoll (rollExpression)]
[h: total = fullBonus + roll + childTotals]
[h: log.debug (getMacroName() + ": rollExpression = " + rollExpression)]
[h: rollExpression = json.set (rollExpression, "total", total, "totals", totals)]
[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "tooltipRoll", tooltipRoll + childTipRolls, 0)]
[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "tooltipDetail", tooltipDetail + childTipDetails, 0)]
[h: macro.return = rollExpression]