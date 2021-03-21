[h: rollExpression = arg (0)]
[h: description = "[]"]
<!-- assume DR_applyConditions has already confirmed we are running against a token -->
[h: currentStates = getTokenStates ("json", "*", currentToken())]

[h: noActionConditions = "[]"]
[h: disadvantageConditions = "[]"]
[h: advantageConditions = "[]"]
[h, foreach (currentState, currentStates), code: {
	[switch (currentState), code:
		case "Dead": {
			[noActionConditions = json.append (noActionConditions, currentState)]
		};
		case "Dying": {
			[noActionConditions = json.append (noActionConditions, currentState)]
		};
		case "Unconscious": {
			[noActionConditions = json.append (noActionConditions, currentState)]
		};
		case "Stable": {
			[noActionConditions = json.append (noActionConditions, currentState)]
		};
		case "Incapacitated": {
			[noActionConditions = json.append (noActionConditions, currentState)]
		};
		case "Exhaustion 6": {
			[noActionConditions = json.append (noActionConditions, currentState)]
		};
		case "Blinded": {
			[disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Poisoned": {
			[disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Restrained": {
			[disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Exhaustion 3": {
			[disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Prone": {
			[disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Charmed": {
			[description = json.append(description, "You're <font color='red'><b>Charmed</b></font>! You cannot attack or target the charmer with harmful effects.")]
		};
		case "Frightened": {
			[description = json.append(description, "You're <font color='red'><b>Frightened</b></font>! You have disadvantage while the source is within line of sight.")]
		};
		case "Invisible": {
			[advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "Blessed": {
			[description = json.append(description, "You're <font color='blue'><b>Blessed</b></font>! Adding 1d4 to your roll.")]
			[blessed = dnd5e_RollExpression_BuildBless ()]
			[rollExpression = dnd5e_RollExpression_addExpression (rollExpression, blessed)]
		};
		case "Advantage on All Attacks": {
			[advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "Advantage on Melee Attacks": {
			[weaponType = dnd5e_RollExpression_getWeaponType (rollExpression)]
			[isWeapon = dnd5e_RollExpression_hasType (rollExpression, dnd5e_Type_Weapon())]
			[if (weaponType != 1 && isWeapon):
				advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "Advantage on Ranged Attacks": {
			[weaponType = dnd5e_RollExpression_getWeaponType (rollExpression)]
			[isWeapon = dnd5e_RollExpression_hasType (rollExpression, dnd5e_Type_Weapon())]
			[if (weaponType == 1 && isWeapon):
				advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "Disadvantage on All Attacks": {
			[disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Disadvantage on Melee Attacks": {
			[weaponType = dnd5e_RollExpression_getWeaponType (rollExpression)]
			[isWeapon = dnd5e_RollExpression_hasType (rollExpression, dnd5e_Type_Weapon())]
			[if (weaponType != 1 && isWeapon):
				disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Disadvantage on Ranged Attacks": {
			[weaponType = dnd5e_RollExpression_getWeaponType (rollExpression)]
			[isWeapon = dnd5e_RollExpression_hasType (rollExpression, dnd5e_Type_Weapon())]
			[if (weaponType == 1 && isWeapon):
				disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		default: {""};
	]
}]

[h, if (json.length (advantageConditions) > 0), code: {
	[description = json.append (description, "Applying Advantage due to the condition" +
		if (json.length (advantageConditions) > 1, "s: ", ": ") +
		"<span style='color: blue; font-weight: bold;'>" + json.toList (advantageConditions, ", ") + "</span>")]
	[rollExpression = dnd5e_RollExpression_setAdvantage (rollExpression, 1)]	
}]

[h, if (json.length (noActionConditions) > 0), code: {
	[description = json.append (description, "You're unable to take actions due to the condition" +
		if (json.length (noActionConditions) > 1, "s: ", ": ") +
		"<span style='color: red; font-weight: bold;'>" + json.toList (noActionConditions, ", ") + "</span>")]
	[rollExpression = dnd5e_RollExpression_setStaticRoll (rollExpression, 1)]
}]

[h, if (json.length (disadvantageConditions) > 0), code: {
	[description = json.append (description, "Applying Disadvantage due to the condition" +
		if (json.length (disadvantageConditions) > 1, "s: ", ": ") +
		"<span style='color: red; font-weight: bold;'>" + json.toList (disadvantageConditions, ", ") + "</span>")]
	[rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
}]

<!-- Save the descriptions and the condition descriptors -->
[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "condition", description)]
[h, foreach(desc, description): rollExpression = dnd5e_RollExpression_addDescription (rollExpression, desc)]
[h: macro.return = rollExpression]