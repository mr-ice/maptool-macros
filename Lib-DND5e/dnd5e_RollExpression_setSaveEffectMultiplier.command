[h: rollExpression = arg (0)]
[h: multiplier = arg (1)]
[h: rollExpression = json.set (rollExpression, "saveEffectMultiplier", multiplier)]
[h, switch (string (multiplier)):
	case "0": rollExpression = dnd5e_RollExpression_setSaveEffect (rollExpression, "none");
	case "0.5": rollExpression = dnd5e_RollExpression_setSaveEffect (rollExpression, "half");
	default: rollExpression = dnd5e_RollExpression_setSaveEffect (rollExpression, "saved")
]
[h: macro.return = rollExpression]