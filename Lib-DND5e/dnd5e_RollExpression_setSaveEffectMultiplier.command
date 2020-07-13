[h: rollExpression = arg (0)]
[h: multiplier = arg (1)]
[h: rollExpression = json.set (rollExpression, "saveEffectMultiplier", multiplier)]
[h, switch (string (multiplier)):
	case "0": rollExpression = dnd5e_RollExpression_setSaveEffect (rollExpression, "No Damage");
	case "0.5": rollExpression = dnd5e_RollExpression_setSaveEffect (rollExpression, "Half Damage");
	default: rollExpression = dnd5e_RollExpression_setSaveEffect (rollExpression, "Saved from effect")
]
[h: macro.return = rollExpression]