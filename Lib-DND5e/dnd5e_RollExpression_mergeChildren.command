<!-- The children should have been rolled totalRolls * parent.totalRolls. To merge, we iterate the parents
	totals array and for each element, add each childs allTotal to each element. Then append the childs
	rollString to the end of the parents rollString -->
[h: rollExpression = arg (0)]

<!-- iterate the children expressions -->
[h: children = dnd5e_RollExpression_getExpressions (rollExpression)]
[h, foreach (child, children), code: {
	[childTotals = dnd5e_RollExpression_getAllTotal (child)]
	<!-- get parents totals array, iterate -->
	[parentTotals = dnd5e_RollExpression_getTotals (rollExpression)]
	[newTotals = "[]"]
	[lastTotal = 0]
	[foreach (parentTotal, parentTotals), code: {
		<!-- for each totals element, add childs allTotal; update new totals array -->
		[lastTotal = parentTotal + childTotals]
		[newTotals = json.append (newTotals, lastTotal)]
		<!-- end totals foreach -->
	}]
	[childRollString = dnd5e_RollExpression_getRollString (child)]
	[parentRollString = dnd5e_RollExpression_getRollString (rollExpression)]
	[rollString = parentRollString + " + " + childRollString]
	[description = dnd5e_RollExpression_getExpressionType (child) + " (+" + dnd5e_RollExpression_getRoll (child) + ")"]
	[rollExpression = dnd5e_RollExpression_addDescription (rollExpression, description)]
	<!-- update parents rollString w child rollString -->
	<!-- replace totals array on parent -->
	<!-- and replace parent total with the last known new total -->
	[rollExpression = json.set (rollExpression, "rollString", rollString,
												"total", lastTotal,
												"totals", newTotals)]
<!-- end child foreach -->
}]
[h: macro.return = rollExpression]