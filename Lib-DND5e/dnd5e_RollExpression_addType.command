[h: rollExpression = arg (0)]
[h: types = json.get (rollExpression, "types")]
[h: types = json.append (types, arg (1))]
[h: macro.return = json.set (rollExpression, "types", types)]