[h: actionName = arg (0)]
[h: actionObj = arg (1)]
[h, if (json.length (macro.args) > 2): advDisadv = arg (2); advDisadv = "none"]
[h: o5e_Constants (getMacroName())]
[h: monsterToonVersion = getProperty (PROP_MONSTER_TOON_VERSION)]
<!-- Prior to 0.16, we calculated the bonus field differently. Now we need to ignore that value -->
[h: ignoreAttackBonus = !dnd5e_Util_checkVersion (monsterToonVersion, "0.16")]
[h: log.debug (CATEGORY + "## ignoreAttackBonus = " + ignoreAttackBonus)]
[h: attackType = json.get (actionObj, "attackType")]
[h, if (attackType == "Melee"): weaponType = 0; weaponType = 1]

[h: attackBonus = json.get (actionObj, "attackBonus")]
<!-- Need to suss out any actual attack bonus by setting the weapon type to melee, 
	finesse, or ranged. Most of the time, well be able to assign an attack as
	Melee, Ranged, or Finesse and the ablity bonuses just roll in naturally. The
	edge case is the thrown weapon (Stone Giants - Rock atk). This comes in as a
	ranged attack but we have no notion of a thrown attack. And trying to decipher
	a dexy throw and a strengthy throw is just stooopid.

	So were just gonna cheat:
		- Deduce the proficiency from the attackBonus
		- If the attack is Melee, use the match* between attack.bonus.melee and finesse
		- If the attack is Ranged, use the match* between attack.bonus.ranged and finsesse
		- If the matching bonus is less than the attackBonus, the difference is the acutal
				bonus

	* wtf is a "match"? In priority order, the property that:
	    - Is equal to attackBonus
	    - Is the largest ability that is less than the attackBonus

	If there is a remaining bonus, it will be set as the bonus on the primary damage.
-->
[h: profValue = getProperty ("Proficiency")]
[h: attackBonus = attackBonus - profValue]
[h: finesseAttackBonus = getProperty ("bonus.attack.finesse")]
[h: selectedProperty = "bonus.attack.finesse"]
[h, if (weaponType == 1), code: {
	<!-- Ranged attack -->
	[rangedAttackBonus = getProperty ("bonus.attack.ranged")]
	[if (attackBonus == rangedAttackBonus), code: {
		[selectedProperty = "bonus.attack.ranged"]
	}]
	[if (selectedProperty == "bonus.attack.finesse" && attackBonus != finesseAttackBonus), code: {
		<!-- we assume one of the two properties must be less than attackBonus. So just check one -->
		[if (finesseAttackBonus > attackBonus): selectedProperty = "bonus.attack.ranged"]
	}; {}]
}; {
	<!-- Melee attack -->
	[meleeAttackBonus = getProperty ("bonus.attack.melee")]
	[if (attackBonus == meleeAttackBonus), code: {
		[selectedProperty = "bonus.attack.melee"]
	}]
	[if (selectedProperty == "bonus.attack.finesse" && attackBonus != finesseAttackBonus), code: {
		<!-- we assume one of the two properties must be less than attackBonus. So just check one -->
		[if (finesseAttackBonus > attackBonus): selectedProperty = "bonus.attack.melee"]
	}; {}]
}]
<!-- adjust weaponType, if required -->
[h, switch (selectedProperty):
	case "bonus.attack.melee": weaponType = 0;
	case "bonus.attack.ranged": weaponType = 1;
	case "bonus.attack.finesse": weaponType = 2;
	default: "wut?";
]

[h: attackBonus = attackBonus - getProperty (selectedProperty)]

<!-- Prior to 0.16, we deducted the ability bonus from the attack bonus during parse. 
	So now that value is too low. If those toons are still around and using this macro, 
	all that noise we just did is invalid. Go back to the very first thing we did and 
	use either melee or ranged. Finesse was never considered in the olden days -->
[h, if (ignoreAttackBonus), code: {
	[if (attackType == "Melee"): weaponType = 0; weaponType = 1]
	[attackBonus = 0]
}]

[h: log.debug (CATEGORY + "## attackBonus = " + attackBonus + "; weaponType = " + weaponType)]
[h: attackExpression = dnd5e_RollExpression_WeaponAttack (actionName, 1, attackBonus, weaponType)]
[h: attackExpression = dnd5e_RollExpression_setAdvantageDisadvantage (attackExpression, advDisadv)]
[h: rollExpressions = json.append ("", attackExpression)]
[h: damageExpressions = o5e_RollExpression_forDamageAction (actionObj, attackExpression)]
[h: rollExpressions = json.merge (rollExpressions, damageExpressions)]

[h: extraObjs = json.get (actionObj, "extraDamage")]
[h, foreach (extraObj, extraObjs), code: {
	[extDamageExpressions = o5e_RollExpression_forDamageAction (extraObj)]
	[rollExpressions = json.merge (rollExpressions, extDamageExpressions)]
}]

[h: macro.return = rollExpressions]