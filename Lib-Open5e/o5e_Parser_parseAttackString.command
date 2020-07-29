[h: actionString = arg (0)]
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

[h: log.debug (getMacroName() + ": attackRegEx = " + attackRegEx)]
[h: attackFindId = strfind (actionString, attackRegEx)]
[h: findMatches = getFindCount (attackFindId)]
[h, if (findMatches == 0), code: {
	[log.debug (getMacroName() + ": No match, returning original")]
	[return (0, actionString)]
}]

[h, for (grp, 1, getGroupCount (attackFindId, 1) + 1), code: {
	[log.debug ("group " + grp + ": " + getGroup (attackFindId, 1, grp))]
}]

<!-- there are 7 capture groups, with 7th being the tail -->
[h: attackType = getGroup (attackFindId, 1, 1)]
[h: attackBonus = getGroup (attackFindId, 1, 3)]
<!-- Ancient Black dragon has weird spaces -->
[h: attackBonus = replace (attackBonus, " ", "")]
[h: reachRange = getGroup (attackFindId, 1, 4)]
[h: attackRange = getGroup (attackFindId, 1, 5)]

<!-- Some attacks dont have a type; assume melee -->
[h, if (attackType == ""): attackType = "Melee"; ""]
[h, if (attackType == "Melee"): ability = "Strength"; ability = "Dexterity"]
[h: abilityBonus = eval (ability + "Bonus")]

[h: attackObj = json.set ("", "attackType", attackType,
                         "attackBonus", attackBonus - abilityBonus,
                         "reachRange", reachRange,
                         "attackRange", attackRange)]

[h: damageActionString = getGroup (attackFindId, 1, 6)]
[h: damageFindId = strfind (damageActionString, dmgRegEx)]
[h: findMatches = getFindCount (damageFindId)]
[h, if (findMatches > 0), code: {
	[dmgAvg = getGroup (damageFindId, 1, 1)]
	[dmgrollString = getGroup (damageFindId, 1, 2)]
	
	[dmgRollObj = o5e_Parser_parseRollString (dmgRollString)]
	[dmgBonus = json.get (dmgRollObj, "bonus")]

	[if (!isNumber (dmgBonus)): dmgBonus = 0; ""]
	[dmgRollObj = json.set (dmgRollObj, "bonus", dmgBonus - abilityBonus)]

	[damageActionString = getGroup (damageFindId, 1, 3)]
	<!-- damageType string  -->
	[damageTypeObj = o5e_Parser_parseDamageType (damageActionString)]
	[damageType = json.get (damageTypeObj, "damageType")]
	[damageActionString = json.get (damageTypeObj, "tail")]

	[attackObj = json.set (attackObj,
                         "damageAverage", dmgAvg - abilityBonus,
                         "damageRollObj", dmgRollObj,
                         "damageRollString", dmgRollString,
                         "damageType", damageType)]

}]

[h: attackObj = json.set (attackObj, "tail", damageActionString)]

[h: log.debug (getMacroName() + ": attackObj = " + attackObj)]
[h: macro.return = attackObj]