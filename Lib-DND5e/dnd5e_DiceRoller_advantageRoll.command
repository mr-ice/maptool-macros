[h: rollExpression = arg (0)]
[h: advantage = dnd5e_RollExpression_hasAdvantage (rollExpression)]
[h: disadvantage = dnd5e_RollExpression_hasDisadvantage (rollExpression)]
<!-- we need to roll again if needsRoll equals exactly 1 -->
[h: needsRoll = advantage + disadvantage]

<!-- for things like Lucky or other rollers that might need to handle the second roll, send the second roll
	through the DiceRoller. This means the advantagble type has to go -->
[h: advantagableType = dnd5e_Type_Advantagable()]
[h: roll2 = dnd5e_RollExpression_removeType (rollExpression, advantagableType)]
[h: maxPriority = dnd5e_Type_getPriority (advantagableType, getMacroName())]
[h: roll2 = dnd5e_RollExpression_setMaxPriority (roll2, maxPriority)]
[h, if (needsRoll == 1), code: {
	[rolled2 = dnd5e_DiceRoller_roll (roll2)]
	[roll2 = json.get (rolled2, 0)]	
}; {}]

[h: roll1Val = json.get (rollExpression, "roll")]
[h: roll2Val = json.get (roll2, "roll")]
[h: rolls = json.get (roll2, "rolls")]
[h: description = ""]
[h: descriptor = ""]
<!-- Default value is roll1Value -->
[h: roll = json.get (rollExpression, "roll")]

[h, if (advantage && !disadvantage), code: {
	[h, if (roll1Val > roll2Val):total = dnd5e_RollExpression_getTotal (rollExpression); total = dnd5e_RollExpression_getTotal (roll2)]
	[h: roll = round (math.max (roll1Val, roll2Val))]
	[h: description = "<b>Advantage:</b> " + rolls + ", Actual: " + roll]

	[h: rollExpression = json.set (rollExpression, "rolls", rolls, "total", total)]
	[h: descriptor = "Advantage"]
}]
[h, if (!advantage && disadvantage), code: {
	[h, if (roll1Val < roll2Val):total = dnd5e_RollExpression_getTotal (rollExpression); total = dnd5e_RollExpression_getTotal (roll2)]
	[h: roll = round (math.min (roll1Val, roll2Val))]
	[h: description = "<b>Disadvantage:</b> " + rolls + ", Actual: " + roll]

	[h: rollExpression = json.set (rollExpression, "rolls", rolls, "total", total)]
	[h: descriptor = "Disadvantage"]
}]
<!-- roll1 has no extra roll attached in rolls, so return it representing no second roll -->
[h, if (advantage && disadvantage), code: {
	[h: description = "Advantage and Disadvantage cancel"]
	[h: descriptor = "advantage and disadvantage cancelling"]
}]

[h, if (description != ""): rollExpression = dnd5e_RollExpression_addDescription (rollExpression, description); ""]
[h: rollExpression = json.set (rollExpression, "roll", roll)]

<!-- Update the tool tip detail if needed -->
[h, if((advantage && !disadvantage) || (!advantage && disadvantage)), code: {
	[h: bonus = dnd5e_RollExpression_getBonus (rollExpression)]
	[h, if (!isNumber(bonus)): bonus = 0; ""]
	[h, if(bonus != 0): bonusOutput = if(bonus > 0, " + " + bonus, " - " + (bonus * -1)); bonusOutput = ""]
	[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "tooltipDetail", 
			descriptor + "(" + json.toList(rolls) + ") " + bonusOutput)]
}; {""}]
[h, if (descriptor != ""): rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "advantageable", "with " + lower(descriptor))]

<!-- roll is set correctly, but total may not overwrite it -->
[h: roll = dnd5e_RollExpression_getRoll (rollExpression)]
[h: bonus = dnd5e_RollExpression_getBonus (rollExpression)]
[h: rollExpression = json.set (rollExpression, "total", roll + bonus)]
[h: log.debug ("dnd5e_DiceRoller_advantageRoll: return = " + rollExpression)]
[h: macro.return = rollExpression]