[h: rollExpression = arg(0)]
[h: weaponType = arg(1)]
[h: rollExpression = json.set (rollExpression, "weaponType", weaponType)]
[h: macro.return = rollExpression]