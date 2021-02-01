[h: rollExpression = arg (0)]
[h: inputTypes = arg (1)]
[h: rollExpression = json.remove (rollExpression, "types")]
<!-- legacy code here allows Strings. We still begrudgingly will take strings -->
[h, if (json.type (inputTypes) == "ARRAY"): types = inputTypes; types = json.fromList (inputTypes)]
<!-- addType has some extra work to do, so no just setting the field -->
[h, foreach (type, inputTypes): rollExpression = dnd5e_RollExpression_addType (rollExpression, type)]
[h: macro.return = rollExpression]