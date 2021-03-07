[h: log.warn (getMacroName() + " has been deprecated")]
[h: log.debug(getMacroName() + ": args=" + json.indent(macro.args))]
[h: ability = arg(0)]
[h: amount = arg(1)]
[h, if (argCount() > 2): id = arg(2); id = currentToken()]
[h, if (json.isEmpty(id) || lower(id) == "currentToken"): id = currentToken()]
[h: dnd5e_AE2_getConstants()]

<!-- Check the ability -->
[h, if (!json.contains(CHAR_ABILITIES, ability)), code: {
	[h: broadcast("Apply Ability Change: Unknown ability name '" + ability + "'", "self")]
	[h: return(0, "")]
}]

<!-- Amount passed not 0? -->
[h, if (!isNumber(amount) || amount == 0), code: {
	[h: broadcast("Apply Ability Change: Amount is zero or is invalid: '" + amount + "'", "self")]
	[h: return(0, "")]
}]

<!-- Make the change, handle 0 -->
[h: value = getProperty(ability, id)]
[h: oldBonus = number(getProperty(ability + "Bonus", id))]
[h: value = value + amount]
[h, if (value < 0): value = 0]
[h: setProperty(ability, value, id)]
[h: newBonus = number(getProperty(ability + "Bonus", id))]
[h: bonusMod = newBonus - oldBonus]
[h: return(bonusMod, "")]

<!-- Modify saves and skills -->
[h: abilityMap = json.set("{}", "Strength",     json.append("[]", "StrengthSave", "Athletics"),
								"Dexterity",    json.append("[]", "DexteritySave", "Acrobatics", "Sleight of Hand", "Stealth"),
								"Constitution", json.append("[]", "ConstitutionSave"),
								"Intelligence", json.append("[]", "IntelligenceSave", "Arcana", "History", "Investigation", "Nature", "Religion"),
								"Wisdom",       json.append("[]", "WisdomSave", "Animal Handling", "Insight", "Medicine", "Perception", "Survival"),
								"Charisma",     json.append("[]", "CharismaSave", "Deception", "Intimidation", "Performance", "Persuasion"))]
[h: propertyList = json.get(abilityMap, ability)]
[h, foreach(property, propertyList), code: {
	[h: value = getProperty(property, id)]
	[h, if (!isNumber(value)): value = 0]
	[h: newValue = value + bonusMod]
	[h: setProperty(property, newValue, id)]
}]