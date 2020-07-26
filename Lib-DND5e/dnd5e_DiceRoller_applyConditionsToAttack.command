[h: rollExpression = arg (0)]
[h: description = ""]

<!-- Does the attacker have an action? -->
[h: descriptionList = ""]
[h: noActionStates = json.append ("", "Dead", "Dying", "Unconscious", "Stable", "Incapacitated", "Exhaustion 6")]
[h, foreach (state, noActionStates): descriptionList = if(getState(state), listAppend(descriptionList, state), descriptionList)]
[h, if (descriptionList != ""), code: {
	[h: description = json.append(description, "You're unable to take actions due to the condition" 
		+ if(listCount(descriptionList) == 1, ": ", "s: ")
		+ "<span style='color: red; font-weight: bold;'>" + descriptionList + "</span>")]
	[h: rollExpression = dnd5e_RollExpression_setStaticRoll (rollExpression, 1)]
}; {""}]

<!-- Does the attacker have disadvantage? -->
[h: descriptionList = ""]
[h: disadvantageStates = json.append ("", "Blinded", "Poisoned", "Prone", "Restrained", "Exhaustion 3")]
[h, foreach (state, disadvantageStates): descriptionList = if(getState(state), listAppend(descriptionList, state), descriptionList)]
[h, if (descriptionList != ""), code: {
	[h: description = json.append(description, "Applying Disadvantage due to the condition"
		+ if(listCount(descriptionList) == 1, ": ", "s: ")
		+ "<span style='color: red; font-weight: bold;'>" + descriptionList + "</span>")]
	[h: rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
}; {""}]

<!-- Any other states that can be applied? -->
[h, if (getState ("Charmed")): description = json.append(description, "You're <font color='red'><b>Charmed</b></font>! You cannot attack or target the charmer with harmful effects."); ""]
[h, if (getState ("Frightened")): description = json.append(description, "You're <font color='red'><b>Frightened</b></font>! You have disadvantage while the source is within line of sight."); ""]

<!-- Does the attacker have advantage? -->
[h, if (getState ("Invisible")), code: {
	[h: description = json.append(description, "You're <font color='blue'><b>Invisible</b></font>! Applying Advantage.")]
	[h: rollExpression = dnd5e_RollExpression_setAdvantage (rollExpression, 1)]
}; {""}]

<!-- Does the attacker have bless? -->
[h, if (getState ("Blessed")), code: {
	[h: description = json.append(description, "You're <font color='blue'><b>Blessed</b></font>! Adding 1d4 to your roll.")]
	[h: blessed = dnd5e_RollExpression_BuildBless ()]
	[h: rollExpression = dnd5e_RollExpression_addExpression (rollExpression, blessed)]
}]

<!-- Save the descriptions and the condition descriptors -->
[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "condition", description)]
[h, foreach(desc, description): rollExpression = dnd5e_RollExpression_addDescription (rollExpression, desc)]
[h: macro.return = rollExpression]