<!-- Im sure theres a reason I wrote it using the classical macro style, but I forget why -->
[h, macro ("dnd5e_RollExpression_Damage@this"): macro.args]
[h: rollExpression = dnd5e_RollExpression_addType (macro.return, dnd5e_Type_Weapon())]
[h: macro.return = rollExpression]