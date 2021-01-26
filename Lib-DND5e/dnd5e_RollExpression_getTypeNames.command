[h: rollExpression = arg (0)]
[h: types = dnd5e_RollExpression_getTypes (rollExpression)]
[h: typeNames = "[]"]
[h, if (!json.isEmpty (types)), code: {
	[foreach (type, types): typeNames = json.append (typeNames, json.get (type, "type"))]
}; {}]
[h: macro.return = typeNames]