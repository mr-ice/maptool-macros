[h: rollExpression = arg (0)]
[h: advDisadv = arg (1)]
[h: log.debug ("advDisadv: " + advDisadv)]
[h, switch (advDisadv), code:
    case "advantage": {[rollExpression = dnd5e_RollExpression_setAdvantage (rollExpression, 1)]};
	case "Advantage": {[rollExpression = dnd5e_RollExpression_setAdvantage (rollExpression, 1)]};
	case "disadvantage": {[rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]};
	case "Disadvantage": {[rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]};
	case "both": {
			[rollExpression = dnd5e_RollExpression_setAdvantage (rollExpression, 1)]
			[rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
	};
	case "Both": {
			[rollExpression = dnd5e_RollExpression_setAdvantage (rollExpression, 1)]
			[rollExpression = dnd5e_RollExpression_setDisadvantage (rollExpression, 1)]
	};
	default: {""}
]
[h: macro.return = rollExpression]