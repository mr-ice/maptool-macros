<!-- Callers must pass in the character json themselves. No getter methods should shoulder the -->
<!-- responsibility of calling dndb_getCharJSON -->
[h: toon = arg(0)]

<!-- AttackJSON constants -->
[h: ATTACK_JSON = "attackJSON"]
[h: JSON_NAME = "name"]
[h: ATK_BONUS = "atkBonus"]
[h: DMG_BONUS = "dmgBonus"]
[h: DMG_DIE = "dmgDie"]
[h: DMG_DICE = "dmgDice"]

<!-- Crit bonus dice is gonna be dodgey... Use Bode to see if theres a common json path-->
[h: CRIT_BONUS_DICE = "critBonusDice"]
[h: DMG_TYPE = "dmgType"]
[h: DMG_BONUS_EXPR = "dmgBonusExpr"]

[h: attributes = dndb_getAbilities (toon)]
[h: proficiencyBonus = dndb_getProficiencyBonus (toon)]
[h: weapons = dndb_getWeapon (toon)]

<!-- restrict to those that are equipped -->
[h: weapons = json.path.read (weapons, ".[?(@.equipped == 'true')]")]

[h: weapons = json.append (weapons, dndb_getUnarmedStrike (toon))]
<!-- default to getting equipped weapons. Maybe we'll add an option later for full list.
<!-- Fuck that, make getWeapons do it
<!-- Defer attack and damage calculations to other macros. They need the work -->

<!-- get Rage feature -->
[h: rageBonus = 0]
[h: ragefeatures = json.path.read (toon, "data.classes..[?(@.definition.name == 'Rage')]['levelScale']")]
[h, if (json.length (rageFeatures) > 0): rageBonus = json.get (json.get (rageFeatures, 0), "fixedValue")]

[h: attackJson = ""]
[h, foreach (weapon, weapons), code: {
	<!-- does not include normal critical dice -->
	[h: critBonusDice = dndb_getCriticalBonusDice (toon, weapon)]
	[h: weaponDmgBonus = dndb_getDamageModifierForWeapon (toon, weapon)]
	[h: weaponAtkBonus = dndb_getAttackModifierForWeapon (toon, weapon)]
	[h: critBonus = dndb_getCriticalBonusDice (toon, weapon)]
	[h: name = json.get (weapon, "name")]
	[h: attackJsonObj = json.set ("", JSON_NAME, name,
			ATK_BONUS, weaponAtkBonus,
			DMG_BONUS, weaponDmgBonus,
			DMG_DIE, json.get (weapon, "dmgDie"),
			DMG_DICE, json.get (weapon, "dmgDice"),
			CRIT_BONUS_DICE, critBonus,
			DMG_TYPE, json.get (weapon, "dmgType"))]
	[h: attackJson = json.append (attackJson, attackJsonObj)]
	<!-- Ragable? Make a rage version -->
	[h, if (rageBonus > 0 && json.get (weapon, "attackType") == "Melee"), code: {
		[h: attackJsonObj = json.set (attackJsonObj, 
			JSON_NAME, name + " - Raging",
			DMG_BONUS, weaponDmgBonus + rageBonus)]
		[h: attackJson = json.append (attackJson, attackJsonObj)]
	}]
}]

[h: macro.return = attackJson]