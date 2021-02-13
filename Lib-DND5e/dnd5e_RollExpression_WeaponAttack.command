[h, if (argCount() > 0): name = arg(0); name = "Weapon Attack"]
[h, if (argCount() > 1): proficient = arg(1); proficient = 0]
[h, if (argCount() > 2): weaponBonus = arg(2); weaponBonus = 0]
[h, if (argCount() > 3): weaponType = arg(3); weaponType = 0]
<!-- a WeaponAttack expression uses the Attack ExpressionType. We dont do object inheritance so well.. -->
[h: rollExpression = dnd5e_RollExpression_Attack(name, weaponBonus)]
<!-- Will take care of adding the proficient type -->
[h: rollExpression = dnd5e_RollExpression_setProficiency (rollExpression, proficient)]
[h: rollExpression = dnd5e_RollExpression_setWeaponType (rollExpression, weaponType)]
[h: macro.return = rollExpression]