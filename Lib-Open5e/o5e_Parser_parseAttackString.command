[h: actionString = arg (0)]
[h: o5e_Constants (getMacroName())]
[h: REG_MELEE_RANGE = "(.*)"]
[h: REG_WEAPON_SPELL = "(Weapon|Spell)"]
[h: REG_ATK_TO_HIT = "Attack[:.] *([+-]\\s*\\d+) *to hit,"]
[h: REG_RANGE_REACH = "(range|reach)"]
[h: REG_RANGE_DIST = "(\\d+\\/?\\d*) ft\\.?,?"]
[h: REG_JUNK_TARGET = ".*\\s\\S*\\.?"]
[h: REG_HIT_AVG_DMG = "Hit: *(\\d+)"]
[h: REG_DMG_ROLL_STRING = "\\((\\d+d\\d+\\s*[+-]?\\s*\\d*)\\)"]

[h: attackRegEx = REG_MELEE_RANGE + " *" + REG_WEAPON_SPELL + " ?" + REG_ATK_TO_HIT + " *" + REG_RANGE_REACH + " *" + 
                REG_RANGE_DIST + "\\s+" + REG_JUNK_TARGET + "\\s+(.*Hit:.*)" ]
                
[h: dmgRegEx =  "\\s?" + REG_HIT_AVG_DMG + " *" + REG_DMG_ROLL_STRING + " *(.*)"]

[h: log.debug (CATEGORY + "## attackRegEx = " + attackRegEx)]
[h: attackFindId = strfind (actionString, attackRegEx)]
[h: findMatches = getFindCount (attackFindId)]
[h, if (findMatches == 0), code: {
	[log.debug (CATEGORY + "## No match, returning original")]
	[return (0, actionString)]
}]

[h, for (grp, 1, getGroupCount (attackFindId, 1) + 1), code: {
	[log.trace (CATEGORY + "## group " + grp + ": " + getGroup (attackFindId, 1, grp))]
}]

<!-- there are 6 capture groups, with 6th being the tail -->
[h: attackType = getGroup (attackFindId, 1, 1)]
[h: attackClass = getGroup (attackFindId, 1, 2)]
[h: attackBonus = getGroup (attackFindId, 1, 3)]
<!-- Ancient Black dragon has weird spaces -->
[h: attackBonus = replace (attackBonus, " ", "")]
[h: reachRange = getGroup (attackFindId, 1, 4)]
[h: attackRange = getGroup (attackFindId, 1, 5)]

<!-- Some attacks dont have a type; assume melee -->
[h: profValue = getProperty ("Proficiency")]
[h, if (attackType == ""): attackType = "Melee"; ""]
<!-- Some melee attacks use finesse, some ranged attacks use strength.
	Instead of trying to determine the weapon type (finesse, thrown), just
	find the appropriate property for that attack. E.g.
	- A melee attack is either melee or finesse
	- A ranged attack is either ranged or melee

	Were simplifying the ranged since a thrown dagger is technically
	finesse. Perhaps one day we can come back to this and make it smart enough
	to suss out that edge case.
	
	Weapon types:
	0 - melee
	1 - ranged
	2 - finesse -->
[h: weaponType = "0"]
[h: finesseBonus = bonus.attack.finesse]
[h: meleeBonus = bonus.attack.melee]
[h: rangedBonus = bonus.attack.ranged]
[h: spellcastingAbility = "Charisma"]
[h: log.debug (CATEGORY + "## finesseBonus = " + finesseBonus + "; meleeBonus = " + 
		meleeBonus + "; rangedBonus = " + rangedBonus + "; profValue = " + profValue)]
[h, if (indexOf (attackClass, "Weapon") >= 0), code: {
	<!-- Weapon attack; determine weapon property -->
	[if (indexOf (attackType, "Melee") >= 0), code: {
		<!-- Melee attack -->
		<!-- use finesse only if finesse is a match and not equal to melee -->
		[if (finesseBonus != meleeBonus && finesseBonus + profValue == attackBonus):
			weaponType = "2"]
	}; {
		<!-- Ranged attack -->
		<!-- use ranged if ranged is a match -->
		[if (rangedBonus + profValue == attackBonus):
			weaponType = "1"]
	}]
	[switch (weaponType):
		case 0: attackBonus = attackBonus - profValue - meleeBonus;
		case 1: attackBonus = attackBonus - profValue - finesseBonus;
		case 2: attackBonus = attackBonus - profValue - rangedBonus;
		default: log.debug (CATEGORY + "## Wut? " + weaponType);
	]
}; {
	<!-- Spell attack; determine ability property -->
	<!-- pull from the spellCasterObj to determine the spell attacks -->
	<!-- PROP_MONSTER_TOON_SPELLCASTING_OBJ -->
	[fullSpellCastingObj = getProperty (PROP_MONSTER_TOON_SPELLCASTING_OBJ)]
	[if (json.contains (fullSpellCastingObj, "Innate Spellcasting")):
		spellCastingObj = json.get (fullSpellcastingObj, "Innate Spellcasting");
		spellCastingObj = json.get (fullSpellcastingObj, "Spellcasting")]
	[if (encode(spellCastingObj) != ""): 
		spellcastingAbility = json.get (spellCastingObj, "ability")]
	[abilityBonus = getProperty ("abilityBonus." + spellcastingAbility)]
	[log.debug (CATEGORY + "## spellcastingAbility = " + spellcastingAbility 
			+ "; abilityBonus = " + abilityBonus)]
	[attackBonus = attackBonus - profValue - abilityBonus]
}]

[h: attackObj = json.set ("", "weaponType", weaponType,
						 "spellcastingAbility", spellcastingAbility,
					     "attackType", attackType,
                         "attackClass", attackClass,
                         "attackBonus", attackBonus,
                         "reachRange", reachRange,
                         "attackRange", attackRange)]

[h: damageActionString = getGroup (attackFindId, 1, 6)]
[h: damageFindId = strfind (damageActionString, dmgRegEx)]
[h: findMatches = getFindCount (damageFindId)]
[h: log.debug (CATEGORY + "## dmgRegEx = " + dmgRegEx)]
[h, for (grp, 1, getGroupCount (damageFindId, 1) + 1), code: {
	[log.trace (CATEGORY + "## group " + grp + ": " + getGroup (damageFindId, 1, grp))]
}]

[h, if (findMatches > 0), code: {
	[dmgAvg = getGroup (damageFindId, 1, 1)]
	[dmgrollString = getGroup (damageFindId, 1, 2)]
	
	[dmgRollObj = o5e_Parser_parseRollString (dmgRollString)]
	[dmgBonus = json.get (dmgRollObj, "bonus")]

	[if (!isNumber (dmgBonus)): dmgBonus = 0; ""]
	<!-- For weapon attacks, deduct the ability bonus; For spell attacks, as-is -->
	[if (attackClass == "Weapon"), switch (weaponType):
		case 0: dmgBonus = dmgBonus - meleeBonus;
		case 1: dmgBonus = dmgBonus - rangedBonus;
		case 2: dmgBonus = dmgBonus - finesseBonus;
		default: log.debug (CATEGORY + "## Aw, geeze - weaponType = " + 
			weaponType + "; attackClass = " + attackClass);
	]
	[dmgRollObj = json.set (dmgRollObj, "bonus", dmgBonus)]

	[damageActionString = getGroup (damageFindId, 1, 3)]
	<!-- damageType string  -->
	[damageTypeObj = o5e_Parser_parseDamageType (damageActionString)]
	[damageType = json.get (damageTypeObj, "damageType")]
	[damageActionString = json.get (damageTypeObj, "tail")]

	[attackObj = json.set (attackObj,
                         "damageAverage", dmgAvg,
                         "damageRollObj", dmgRollObj,
                         "damageRollString", dmgRollString,
                         "damageType", damageType)]

}]

[h: attackObj = json.set (attackObj, "tail", damageActionString)]

[h: macro.return = attackObj]