[h: re = dnd5e_RollExpression_setStaticRoll ("{}", 1)]
[h: re = dnd5e_RollExpression_setDiceRolled (re, 1)]
[h: re = dnd5e_RollExpression_setDiceSize (re, 20)]
[h: re = dnd5e_RollExpression_addType (re, dnd5e_Type_Lucky())]
[h: log.debug (getMacroName() + "## re = " + re)]
[h: rolled = json.get (dnd5e_DiceRoller_roll (re), 0)]
[h: log.debug (getMacroName() + "## rolled = " + rolled)]
[h: rolls = json.get (rolled, "rolls")]
[h: reportResults = dnd5et_Util_assertEqual (json.length (rolls), 2, "Lucky Roll Test")]
[h: log.info (getMacroName() + "##" + reportResults)]
[h: macro.return = reportResults]