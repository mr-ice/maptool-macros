[h: rollExpression = arg (0)]
[h: rawTypes = arg (1)]
[h, if (json.type (rawTypes) == "ARRAY"): types = rawTypes; types = json.fromList (rawTypes)]
[h: macro.return = json.set (rollExpression, "damageTypes", types)]