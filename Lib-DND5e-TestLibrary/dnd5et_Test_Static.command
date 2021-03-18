
[h: re = dnd5e_RollExpression_setStaticRoll (dnd5e_RollExpression_Attack(), 20)]
[h: rolled = json.get (dnd5e_DiceRoller_roll (re), 0)]
[h: total = dnd5e_RollExpression_getTotal (rolled)]
[h: reportResults = dnd5et_Util_assertEqual (total, 20, "Static Roll")]
[h: macro.return = reportResults]