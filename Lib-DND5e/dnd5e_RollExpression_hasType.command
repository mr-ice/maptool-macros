[h: expression = arg(0)]
[h: findType = arg(1)]
[h: IMPLIED_TYPES = json.set ("", 
					"Damage", json.append ("", "critable"),
					"Attack", json.append ("", "advantagable"),
					"Save", json.append ("", "advantagable"),
					"Ability", json.append ("", "advantagable"))]
[h: log.debug ("dnd5e_DiceRoller_hasType: expression = " + expression + "; findType = " + findType)]
[h: types = dnd5e_RollExpression_getExpressionType (expression)]
<!-- add implied types -->
[h, foreach (type, types), code: {
	[h: impliedList = json.get (IMPLIED_TYPES, type)]
	[h: types = json.merge (types, impliedList)]
}]

[h: hasType = 0]
[h, foreach (type, types), code: {
	[h, if (type == findType): hasType = 1; ""]
}]
[h: log.debug ("dnd5e_RollExpression_hasType: hasType = " + hasType)]
[h: macro.return = hasType]