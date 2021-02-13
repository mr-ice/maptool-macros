[h: rollExpression = arg (0)]
[h: weaponType = json.get (rollExpression, "weaponType")]
[h, if (weaponType != 1 && weaponType != 2): weaponType = 0; ""]
[h: macro.return = weaponType]