<!-- Callers must pass in the character json themselves. No getter methods should shoulder the -->
<!-- responsibility of calling dndb_getCharJSON -->
[h: toon = arg(0)]

<!-- attackObj constants -->
[h: ATTACK_JSON = "attackObj"]
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
[h: weapons = json.merge (weapons, dndb_getNaturalWeapon (toon))]

<!-- search for character values w/ valueTypeId = 1439493548. Creates
     a smaller set of objects to search from when the time comes -->
[h: characterValueSearchObj = json.set ("", 
							"object", json.path.read (toon, "data.characterValues"),
							"valueTypeId", "1439493548")]
[h: characterValues = dndb_searchJsonObject (characterValueSearchObj)]	
				

[h: attackObj = "{}"]
[h, foreach (weapon, weapons), code: {
	<!-- does not include normal critical dice -->
	[h: critBonusDice = dndb_getCriticalBonusDice (toon, weapon)]
	[h: weaponDmgBonus = dndb_getDamageModifierForWeapon (toon, weapon, characterValues)]
	[h: weaponAtkBonus = dndb_getAttackModifierForWeapon (toon, weapon, characterValues)]
	[h: critBonus = dndb_getCriticalBonusDice (toon, weapon)]
	[h: name = json.get (weapon, "name")]
	<!-- commas are scary -->
	[h: name = replace (name, ",", " ")]
	[h: attackExpression = dnd5e_RollExpression_Attack (name)]
	[h: attackExpression = dnd5e_RollExpression_setBonus (attackExpression, weaponAtkBonus)]
	[h: dmgExpression = dnd5e_RollExpression_Damage ()]
	[h: dmgExpression = dnd5e_RollExpression_setDiceRolled (dmgExpression, json.get (weapon, "dmgDice"))]
	[h: dmgExpression = dnd5e_RollExpression_setDiceSize (dmgExpression, json.get (weapon, "dmgDie"))]
	[h: dmgExpression = dnd5e_RollExpression_setBonus (dmgExpression, weaponDmgBonus)]
	[h: dmgExpression = dnd5e_RollExpression_setOnCritAdd (dmgExpression, critBonus)]
	[h: dmgExpression = dnd5e_RollExpression_setDamageTypes (dmgExpression, json.get (weapon, "dmgType"))]
	[h: rollExpressions = json.append ("", attackExpression, dmgExpression)]
	[h: grantedModifiers = json.get (weapon, "grantedModifiers")]
	[h, foreach (grantedModifier, grantedModifiers), code: {
		[h: type = json.get (grantedModifier, "type")]
		<!-- perform the time-honored, avoid the code nesting limit dance -->
		[h, if (type == "damage"): 
				extraDmg = dndb_RollExpression_getExpressionFromModifier (grantedModifier); extraDmg = ""]
		[h, if (type == "damage"): 
				rollExpressions = json.append (rollExpressions, extraDmg)]
	}]

	[h: attackObj = json.set (attackObj, name, rollExpressions)]
}]

[h: macro.return = attackObj]