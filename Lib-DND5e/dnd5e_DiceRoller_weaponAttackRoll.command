[h: rollExpression = arg (0)]
<!-- If this is an attack, ask the RolExpression for the property modifier. If this is damage, 
	find the last attack and ask it -->
[h: weaponExpression = rollExpression]
[h, if (!dnd5e_RollExpression_hasType (rollExpression, "Attack")), code: {
	[candidates = json.get (rollExpression, "rolledExpressions")]
	[weaponExpression = dnd5e_RollExpression_findExpressionByType (candidates, "Attack")]
}]
[h: log.debug (getMacroName() + ": weaponExpression = " + weaponExpression)]
[h: weaponType = dnd5e_RollExpression_getWeaponType(weaponExpression)]
[h: propertyModifier = ""]
[h, switch (weaponType):
	case 0: propertyModifier = "bonus.attack.melee";
	case 1: propertyModifier = "bonus.attack.ranged";
	case 2: propertyModifier = "bonus.attack.finesse";
	default: log.error (getMacroName() + ": Invalid weapon attack type: " + weaponType)
]
[h: propertyModifiers = json.get (rollExpression, "propertyModifiers")]
[h, if (propertyModifier != ""): 
		propertyModifiers = json.append (propertyModifiers, propertyModifier); ""]
[h: macro.return = json.set (rollExpression, "propertyModifiers", propertyModifiers)]