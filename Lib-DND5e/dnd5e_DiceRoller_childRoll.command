[h: rollExpression = arg(0)]
[h: children = dnd5e_RollExpression_getExpressions (rollExpression)]
[h, if (!json.isEmpty (children)), code: {
	<!-- We have to roll the children in multiples of the parents totalRolls -->
	[children = dnd5e_DiceRoller_roll (children)]
	[rollExpression = dnd5e_RollExpression_setExpressions (rollExpression, children)]
}; {""}]