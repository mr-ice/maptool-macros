[h: rollExpressions = arg(0)]
[h: dnd5e_CharSheet_Constants (getMacroName())]

[h: remainingExpressions = "[]"]
[h: attackExpression = "{}"]
[h: damageExpression = "{}"]
[h, foreach (re, rollExpressions), code: {
	[isFound = 0]
	[if (dnd5e_RollExpression_hasType (re, "Attack") && json.isEmpty (attackExpression)), code: {
		[attackExpression = re]
		[isFound = 1]
	}]
	[if (dnd5e_RollExpression_hasType (re, "Damage") && json.isEmpty (damageExpression)), code: {
		[damageExpression = re]
		[isFound = 1]
	}]
	[if (!isFound): remainingExpressions = json.append (remainingExpressions, re)]
}]
[h: log.debug (CATEGORY + "## attackExpression = " + attackExpression + "; damageExpression = " + damageExpression)]
	<!-- theres got to be a better way to do this -->
	<!-- suss out which property to use as a modiier, if any -->
[h: weaponType = dnd5e_RollExpression_getWeaponType (attackExpression)]
[h: propertyModifier = ""]
[h: isWeapon = 1]
[h: isAbility = 1]
[h: log.debug (CATEGORY + "## weaponType = " + weaponType)]
[h, switch (weaponType):
		case 0: propertyModifier = "bonus.attack.melee";
		case 1: propertyModifier = "bonus.attack.ranged";
		case 2: propertyModifier = "bonus.attack.finesse";
		default: isWeapon = 0;
]
[h: abilityType = dnd5e_RollExpression_getSpellcastingAbility (attackExpression)]
[h, switch (abilityType): 
		case 0: propertyModifier = "StrengthBonus";
		case 1: propertyModifier = "DexterityBonus";
		case 2: propertyModifier = "ConstitutionBonus";
		case 3: propertyModifier = "IntelligenceBonus";
		case 4: propertyModifier = "WisdomBonus";
		case 5: propertyModifier = "CharismaBonus";
		default: isAbility = 0;
]
[h, if (isWeapon || isAbility): 
		attackExpression = dnd5e_RollExpression_addPropertyModifiers 
			(attackExpression, propertyModifier)]
[h, if (isWeapon):
		damageExpression = dnd5e_RollExpression_addPropertyModifiers
			(damageExpression, propertyModifier)]
	<!-- send through proficient DR to adorn proficiency bonus -->
[h: attackExpression = dnd5e_DiceRoller_proficientRoll (attackExpression)]
[h: retExpression = json.append ("", attackExpression, damageExpression)]
[h, if (!json.isEmpty (remainingExpressions)): 
	retExpression = json.merge (retExpression, remainingExpressions)]
[h: macro.return = retExpression]