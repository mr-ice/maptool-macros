[h: re = arg(0)]
[h: types = dnd5e_RollExpression_getTypes (re)]
<!-- The types object is keyed by the type names -->
[h: typeNames = json.fields (types, "json")]
[h: macro.return = json.set (re, "typeNames", typeNames)]