[h: expression = arg(0)]
[h: findType = arg(1)]
[h: IMPLIED_TYPES = json.set ("", 
					"Damage", json.append ("", "critable", "damageable"),
					"Attack", json.append ("", "advantagable"),
					"Save", json.append ("", "advantagable"),
					"Save Damage", json.append ("", "saveable", "damageable"),
					"Save Effect", json.append ("", "saveable"),
					"Condition", json.append ("", "unrollable"),
					"DnDBeyond Spell", json.append ("", "unrollable"),
					"DnDBeyond Attack", json.append ("", "unrollable"),
					"Target Check", json.append ("", "unrollable"),
					"Drain", json.append ("", "damageable"),
					"Save Drain", json.append ("", "damageable", "saveable"),
					"Ability", json.append ("", "advantagable")
)]

[h: types = json.merge (json.append ("", dnd5e_RollExpression_getExpressionType (expression)),
						dnd5e_RollExpression_getTypes (expression))]

<!-- add implied types -->
[h, foreach (type, types), code: {
	[h: impliedList = json.get (IMPLIED_TYPES, type)]
	[h: types = json.merge (types, impliedList)]
}]

[h: hasType = 0]
[h, foreach (type, types), code: {
	[h, if (type == findType): hasType = 1; ""]
}]

[h: macro.return = hasType]