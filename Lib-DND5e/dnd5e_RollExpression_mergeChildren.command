<!-- The children should have been rolled totalRolls * parent.totalRolls. To merge, we iterate the parents
	totals array and for each element, add each childs allTotal to each element. Then append the childs
	rollString to the end of the parents rollString -->
[h: rollExpression = arg (0)]
[h: log.debug ("dnd5e_RollExpression_mergeChildren: rollExpression = " + json.indent (rollExpression))]
<!-- iterate the children expressions -->
[h: children = dnd5e_RollExpression_getExpressions (rollExpression)]

[h: parentRolls = dnd5e_RollExpression_getRolls (rollExpression)]
[h: parentBonus = dnd5e_RollExpression_getBonus (rollExpression)]
[h: newTotals = "[]"]

<!-- cheater var -->
<!-- Rebuild the totals array from scratch -->
[h, foreach (parentRoll, parentRolls), code: {
	[newTotals = json.append (newTotals, parentRoll + parentBonus)]
}]
<!-- same goes for total -->
[h: newTotal = dnd5e_RollExpression_getRoll (rollExpression) + parentBonus]
[h: tooltipRoll = dnd5e_RollExpression_getTypedDescriptor(rollExpression, "tooltipRoll")]
[h: tooltipDetail = dnd5e_RollExpression_getTypedDescriptor(rollExpression, "tooltipDetail")]
[h, foreach (child, children), code: {
	[childTotals = dnd5e_RollExpression_getAllTotal (child)]

	[newerTotals = "[]"]
	<!-- add to totals the child allTotals -->
	[foreach (toTotal, newTotals), code: {
		[newerTotals = json.append (newerTotals, toTotal + childTotals)]
	}]
	[newTotal = newTotal + childTotals]
	[newTotals = newerTotals]
	[description = dnd5e_RollExpression_getExpressionType (child) + " (+" + dnd5e_RollExpression_getRoll (child) + ")"]
	[rollExpression = dnd5e_RollExpression_addDescription (rollExpression, description)]
	[childTip = dnd5e_RollExpression_getTypedDescriptor(child, "tooltipRoll")]
	[rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "tooltipRoll", tooltipRoll + " + " + childTip)] 
	[childTip = dnd5e_RollExpression_getTypedDescriptor(child, "tooltipDetail")]
	[name = dnd5e_RollExpression_getName(child)]
	[if (name != ""): childTip = name + childTip; ""]
	[rollExpression = dnd5e_RollExpression_addTypedDescriptor(rollExpression, "tooltipDetail", tooltipDetail + " + " + childTip)]
<!-- end child foreach -->
}]
[h: allTotal = 0]

[h: rollExpression = json.set (rollExpression,	"total", newTotal, "totals", newTotals)]
[h: macro.return = rollExpression]
