[h: rollExpression = arg (0)]
[h: description = ""]

[h, if (getState ("Dead")), code: {
	[h: description = description + "<br><br>You're <font color='red'><b>DEAD</b></font>!"]
	[h: rollExpression = dnd5e_RollExpression_setStaticRoll (rollExpression, 1)]
	[h: rollExpression = dnd5e_RollExpression_addDescription (rollExpression, description)]
	[h: return (0, rollExpression)]
}]

[h: saveName = dnd5e_RollExpression_getName (rollExpression)]

[h: currentStates = getTokenStates ("json", "*", currentToken())]

[h: disadvantageConditions = "[]"]
[h: advantageConditions = "[]"]
[h: fuckedStates = "[]"]

[h: description = "[]"]

[h, foreach (currentState, currentStates), code: {
	[switch (currentState), code: 
		case "Advantage on All Saving Throws": {
			[advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "Disadvantage on All Saving Throws": {
			[disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Advantage on Strength Saving Throws": {
			[if (saveName == "Strength"): 
				advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "Advantage on Dexterity Saving Throws": {
			[if (saveName == "Dexterity"): 
				advantageConditions = json.append (advantageConditions, currentState)]
		};		
		case "Advantage on Constitution Saving Throws": {
			[if (saveName == "Constitution"): 
				advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "Advantage on Intelligence Saving Throws": {
			[if (saveName == "Intelligence"): 
				advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "Advantage on Wisdom Saving Throws": {
			[if (saveName == "Wisdom"): 
				advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "Advantage on Charisma Saving Throws": {
			[if (saveName == "Charisma"): 
				advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "Advantage on Death Saving Throws": {
			[if (saveName == "Death"): 
				advantageConditions = json.append (advantageConditions, currentState)]
		};
		case "Disadvantage on Strength Saving Throws": {
			[if (saveName == "Strength"): 
				disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Disadvantage on Dexterity Saving Throws": {
			[if (saveName == "Dexterity"): 
				disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};		
		case "Disadvantage on Constitution Saving Throws": {
			[if (saveName == "Constitution"): 
				disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Disadvantage on Intelligence Saving Throws": {
			[if (saveName == "Intelligence"): 
				disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Disadvantage on Wisdom Saving Throws": {
			[if (saveName == "Wisdom"): 
				disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Disadvantage on Charisma Saving Throws": {
			[if (saveName == "Charisma"): 
				disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Disadvantage on Death Saving Saving Throws": {
			[if (saveName == "Death"): 
				disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Paralyzed": {
			[if (saveName == "Strength" || saveName == "Dexterity"):
				fuckedStates = json.append (fuckedStates, currentState)]
		};
		case "Petrified": {
			[if (saveName == "Strength" || saveName == "Dexterity"):
				fuckedStates = json.append (fuckedStates, currentState)]
		};
		case "Stunned": {
			[if (saveName == "Strength" || saveName == "Dexterity"):
				fuckedStates = json.append (fuckedStates, currentState)]
		};
		case "Unconscious": {
			[if (saveName == "Strength" || saveName == "Dexterity"):
				fuckedStates = json.append (fuckedStates, currentState)]
		};
		case "Restrained": {
			[if (saveName == "Dexterity"):
				disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Exhaustion 3": {
			[disadvantageConditions = json.append (disadvantageConditions, currentState)]
		};
		case "Blessed": {
			[h: blessed = dnd5e_RollExpression_BuildBless ()]
			[h: rollExpression = dnd5e_RollExpression_addExpression (rollExpression, blessed)]
			[h: description = json.append(description, "You're <font color='blue'><b>Blessed</b></font>! Adding 1d4 to your roll.")]
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

[h, if (json.length (disadvantageConditions) > 0), code: {
	[description = json.append (description, "Applying Disadvantage due to the condition" +
		if (json.length (disadvantageConditions) > 1, "s: ", ": ") +
		"<span style='color: red; font-weight: bold;'>" + json.toList (disadvantageConditions, ", ") + "</span>")]
	[rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
}]

[h, if (json.length (fuckedStates) > 0), code: {
	[description = json.append (description, "You're <span style='color: red; font-weight: bold;'>" + 
		json.toList (fuckedStates, ", ") + "</span><br><b>You automatically <font color='red'><i>FAIL</i></font>!!</b> ")]
	[rollExpression = dnd5e_RollExpression_setStaticRoll (rollExpression, 1)]
}]

[h, foreach(desc, description): rollExpression = dnd5e_RollExpression_addDescription (rollExpression, desc)]
[h: macro.return = rollExpression]
