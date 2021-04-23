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
	[h: weaponAtkBonusObj = dndb_getAttackModifierForWeapon (toon, weapon, characterValues)]
	[h: weaponDmgBonusObj = dndb_getDamageModifierForWeapon (toon, weapon, characterValues)]
	
	[h: critBonus = dndb_getCriticalBonusDice (toon, weapon)]
	[h: name = json.get (weapon, "name")]
	<!-- commas are scary -->
	[h: name = replace (name, ",", " ")]
	[h: attackExpression = dnd5e_RollExpression_WeaponAttack (name)]

	[h: atkBonus = "" + json.get (weaponAtkBonusObj, "bonus")]
	[h: attackExpression = dnd5e_RollExpression_setBonus (attackExpression, atkBonus)]
	[h: proficient = json.get (weaponAtkBonusObj, "proficient")]
	[h: attackExpression = dnd5e_RollExpression_setProficiency (attackExpression, proficient)]
	[h: attackType = json.get (weaponAtkBonusObj, "attackType")]
		[h, switch (attackType): 
		case "melee": attackTypeIndex = 0;
		case "ranged": attackTypeIndex = 1;
		case "finesse": attackTypeIndex = 2;
		default: attackTypeIndex = 0;
	]

	[h: attackExpression = dnd5e_RollExpression_setWeaponType (attackExpression, attackTypeIndex)]

	[h: dmgExpression = dnd5e_RollExpression_WeaponDamage ()]
	[h: dmgExpression = dnd5e_RollExpression_setDiceRolled (dmgExpression, json.get (weapon, "dmgDice"))]
	[h: dmgExpression = dnd5e_RollExpression_setDiceSize (dmgExpression, json.get (weapon, "dmgDie"))]
	[h: dmdExpression = dnd5e_RollExpression_setWeaponType (dmgExpression, attackTypeIndex)]

	[h: dmgBonus = "" + json.get (weaponDmgBonusObj, "bonus")]
	[h: dmgExpression = dnd5e_RollExpression_setBonus (dmgExpression, dmgBonus)]
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
[h: attackObj = json.merge (attackObj, dndb_getCustomAttacks(json.path.read (toon, "data.customActions")))]
[h: macro.return = attackObj]