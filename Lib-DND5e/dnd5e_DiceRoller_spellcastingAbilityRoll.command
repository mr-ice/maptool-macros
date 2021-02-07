[h: re = arg (0)]
[h: log.debug (getMacroName() + ": rolling " + re)]
[h: ability = dnd5e_RollExpression_getSpellcastingAbility (re)]
[h, if (ability < 0): return (0, re); ""]
[h, switch (ability):
	case 0: abilityProperty = "StrengthBonus";
	case 1: abilityProperty = "DexterityBonus";
	case 2: abilityProperty = "ConstitutionBonus";
	case 3: abilityProperty = "IntelligenceBonus";
	case 4: abilityProperty = "WisdomBonus";
	case 5: abilityProperty = "CharismaBonus";
	default: abilityProperty = "";
]
[h: propertyExpressions = json.get (re, "propertyModifiers")]
[h: propertyExpressions = json.append (propertyExpressions, abilityProperty)]
[h: macro.return = json.set (re, "propertyModifiers", propertyExpressions)]