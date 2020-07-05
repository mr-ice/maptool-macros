[h: rollExpression = arg (0)]
[h: onCritAdd = json.get (rollExpression, "onCritAdd")]
[h, if (onCritAdd == ""): onCritAdd = json.get (rollExpression, "diceRolled"); ""]
[h: macro.return = onCritAdd]