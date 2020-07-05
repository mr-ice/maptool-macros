[h: rollExpression = arg (0)]
[h: argsLength = json.length (macro.args)]
[h: types = dnd5e_RollExpression_getDamageTypes (rollExpression)]
[h, for (typeIndex, 1, argsLength), code: {
	[h: types = json.append (types, json.get (macro.args, typeIndex))]
}]
[h: macro.return = json.set (rollExpression, "damageTypes", types)]