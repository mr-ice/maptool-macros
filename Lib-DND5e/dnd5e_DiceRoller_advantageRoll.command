[h: rollExpression = arg (0)]
[h: log.debug (getMacroName() + ": rolling " + rollExpression)]
[h: advantage = dnd5e_RollExpression_hasAdvantage (rollExpression)]
[h: disadvantage = dnd5e_RollExpression_hasDisadvantage (rollExpression)]
<!-- we need to roll again if needsRoll equals exactly 1 -->
[h: needsRoll = advantage + disadvantage]
[h: advantageRolls = json.get (rollExpression, "advantageRolls")]
[h, if (!isNumber(advantageRolls)): advantageRolls = 0; ""]
[h: log.debug (getMacroName() + ": advantageRolls = " + advantageRolls)]
[h: rolled2 = rollExpression]
[h, if (needsRoll == 1 && advantageRolls > 0), code: {
	<!-- Technically, its better if I get the type off of the RollExpression instead of
		using a new instance in case some jackass tweaks the priority. Maybe next time... -->
	[maxPriority = dnd5e_Type_getPriority (dnd5e_Type_Advantagable(), getMacroName())]
	[advantageRolls = advantageRolls - 1]
	<!-- Prevent additional re-rolls from advantage -->
	[rollExpression = json.set (rollExpression, "advantageRolls", advantageRolls)]
	[rolledArry = dnd5e_DiceRoller_roll (dnd5e_RollExpression_setMaxPriority (rollExpression, maxPriority))]
	[rolled2 = json.get (rolledArry, 0)]	
}; {
	<!-- if neither is set, just get out of here -->
	[return (needsRoll, rollExpression)]
}]

[h: roll1Val = json.get (rollExpression, "roll")]
[h: roll2Val = json.get (rolled2, "roll")]
[h: log.debug ("roll1Val = " + roll1Val + "; roll2Val = " + roll2Val)]
[h: rolls = json.get (rolled2, "rolls")]
[h: description = ""]
[h: descriptor = ""]
<!-- Default value is roll1Value -->
[h: roll = roll1Val]

[h, if (advantage && !disadvantage), code: {
	[h, if (roll1Val > roll2Val):total = dnd5e_RollExpression_getTotal (rollExpression); total = dnd5e_RollExpression_getTotal (rolled2)]
	[h: roll = round (math.max (roll1Val, roll2Val))]
	[h: description = "<b>Advantage:</b> " + rolls + ", Actual: " + roll]

	[h: rollExpression = json.set (rollExpression, "rolls", rolls, "total", total)]
	[h: descriptor = "Advantage"]
}]
[h, if (!advantage && disadvantage), code: {
	[h, if (roll1Val < roll2Val):total = dnd5e_RollExpression_getTotal (rollExpression); total = dnd5e_RollExpression_getTotal (rolled2)]
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
<!-- TK - Finalizer will get the bonus, this will stick with advantage deets -->
[h, if((advantage && !disadvantage) || (!advantage && disadvantage)):
	rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "tooltipDetail", 
			descriptor + "(" + json.toList(rolls) + ")", 0), ""]
[h, if (descriptor != ""): rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "advantageable", "&nbsp;with " + lower(descriptor), 0)]

<!-- roll is set correctly, but total may not overwrite it -->
[h: roll = dnd5e_RollExpression_getRoll (rollExpression)]
[h: individualRolls = json.append ("", roll)]
[h: rollExpression = json.set (rollExpression, "roll", roll, "individualRolls", individualRolls)]
[h: macro.return = rollExpression]