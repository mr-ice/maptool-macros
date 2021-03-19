<!-- Zero the stack -->
[h: re = arg(0)]
[h: rollers = dnd5e_RollExpression_getDiceRollers(re)]
[h: re = json.set (re, "rolledRollers", rollers)]
[h: macro.return = re]