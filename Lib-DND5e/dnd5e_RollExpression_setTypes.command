[h: rollExpression = arg (0)]
[h: inputTypes = arg (1)]
[h, if (json.type (inputTypes) == "ARRAY"): types = inputTypes; types = json.fromList (inputTypes)]
[h: macro.return = json.set (rollExpression, "types", types)]