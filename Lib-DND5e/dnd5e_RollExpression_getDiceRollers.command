[h: rollExpression = arg(0)]
[h: maxPriority = dnd5e_RollExpression_getMaxPriority (rollExpression)]
[h: types = dnd5e_RollExpression_getTypes (rollExpression)]
[h: priorityMap = "{}"]
[h: typeFields = json.fields (types)]
[h, foreach (typeKey, typeFields), code: {
	[type = json.get (types, typeKey)]
	[rollers = json.merge("[]", json.get (type, "roller"))]
	[foreach (roller, rollers), code: {
		[rollerMacro = listGet (roller, 0, ":")]
		[priority = listGet (roller, 1, ":")]
		[rollerList = json.unique (json.merge (
					"[]", 
					json.get (priorityMap, priority), 
					rollerMacro)
					)]
		[if (maxPriority < 0 || priority <= maxPriority):
			priorityMap = json.set (priorityMap, priority, rollerList);
			""]
	}]
}]
[h: orderedFieldList = json.sort (json.fields (priorityMap, "json"))]
[h: orderedRollerList = "[]"]
[h, foreach (priority, orderedFieldList), code: {
	[orderedRollerList = json.merge (orderedRollerList, json.get (priorityMap, priority))]
}]
[h: macro.return = orderedRollerList]