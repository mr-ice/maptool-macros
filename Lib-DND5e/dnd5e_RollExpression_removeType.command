[h: re = arg(0)]
[h: type = arg(1)]
[h, if (json.type (type) == "OBJECT"): typeName = json.get (type, "type"); typeName = type]
[h: newTypes = "[]"]
[h, foreach (type, dnd5e_RollExpression_getTypes (re), ""), code: {
	[existingTypeName = json.get (type, "type")]
	[if (existingTypeName != typeName): newTypes = json.append (newTypes, type); ""]
}]

[h: re = dnd5e_RollExpression_setTypes (re, newTypes)]
[h: macro.return = re]