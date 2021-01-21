<!-- Read the damage and the properties and make sure they are numbers --> 
[h: json.toVars(dnd5e_AE2_getConstants())]
[h: abort(input("ability|" + CHAR_ABILITIES + "|Select Ability:|LIST|VALUE=Strength DELIMITER=JSON",
				"dmg|0|Enter Restore(+) or Drain(-) Amount:|TEXT|WIDTH=4"))]
[h, if (!isNumber(dmg)): dmg = 0]
[h: abilityProperty = json.get(CHAR_ABILITIES, ability)]
[h: log.debug (getMacroName() + ": abilityProperty = " + abilityProperty)]
[h: tokenId = currentToken()]
[h: abilityValue = getProperty (abilityProperty)]
[h: abilityValue = abilityValue + dmg]
<!-- Minimum of 0 -->
[h: abilityValue = max (abilityValue, 0)]
[h: setProperty (abilityProperty, abilityValue, tokenId)]