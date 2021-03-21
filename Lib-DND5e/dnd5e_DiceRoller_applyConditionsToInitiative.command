[h: rollExpression = arg(0)]
[h: description = ""]

<!-- Does it have advantage? -->
[h, if (getState ("Advantage on Initiative")), code: {
	[description = description + "Applying Advantage due to condition: " +
		"<span style='color:blue; font-weight: bold;'>Advantage on Initiative</span>"]
	[rollExpression = dnd5e_RollExpression_setAdvantage (rollExpression, 1)]
}]

<!-- Does it have disadvantage? -->
[h, if (getState ("Disadvantage on Initiative")), code: {
	[description = description + "Applying Disadavantage due to condition: " +
		"<span style='color: red; font-weight: bold;'>Disadvantage on Initiative</span>"]
	[rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
}]

<!-- Save the descriptions -->
[h: rollExpression = dnd5e_RollExpression_addTypedDescriptor (rollExpression, "condition", description)]
[h: macro.return = rollExpression]