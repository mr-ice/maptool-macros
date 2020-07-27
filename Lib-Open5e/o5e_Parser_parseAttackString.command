[h: actionString = arg (0)]
[h: REG_MELEE_RANGE = "(Melee|Ranged)"]
[h: REG_WEAPON_SPELL = "(Weapon|Spell)"]
[h: REG_ATK_TO_HIT = "Attack: *([+-]\\s*\\d+) *to hit,"]
[h: REG_RANGE_REACH = "(range|reach)"]
[h: REG_RANGE_DIST = "(\\d+\\/?\\d*) ft\\.?,?"]
[h: REG_HIT_AVG_DMG = "Hit: *(\\d+)"]
[h: REG_DMG_ROLL_STRING = "\\((\\d+d\\d+\\s*[+-]?\\s*\\d*)\\)"]
[h: attackRegEx = REG_MELEE_RANGE + " *" + REG_WEAPON_SPELL + " ?" + REG_ATK_TO_HIT + " *" + REG_RANGE_REACH + " *" + 
                REG_RANGE_DIST + " *\\S* *\\S*\\. *" + REG_HIT_AVG_DMG + " *" + REG_DMG_ROLL_STRING + " *(.*)"]
[h: log.debug (getMacroName() + ": attackRegEx = " + attackRegEx)]
[h: attackFindId = strfind (actionString, attackRegEx)]
[h: findMatches = getFindCount (attackFindId)]
[h, if (findMatches == 0), code: {
	[log.debug (getMacroName() + ": No match, returning original")]
	[return (0, actionString)]
}]
<!-- there are 7 capture groups, with 7th being the tail -->
[h: attackType = getGroup (attackFindId, 1, 1)]
[h: attackBonus = getGroup (attackFindId, 1, 3)]
<!-- Ancient Black dragon has weird spaces -->
[h: attackBonus = replace (attackBonus, " ", "")]
[h: reachRange = getGroup (attackFindId, 1, 4)]
[h: attackRange = getGroup (attackFindId, 1, 5)]
[h: dmgAvg = getGroup (attackFindId, 1, 6)]

[h, if (attackType == "Melee"): ability = "Strength"; ability = "Dexterity"]
[h: abilityBonus = eval (ability + "Bonus")]

[h: dmgRollString = getGroup (attackFindId, 1, 7)]
[h: dmgRollObj = o5e_Parser_parseRollString (dmgRollString)]
[h: dmgBonus = json.get (dmgRollObj, "bonus")]
[h, if (!isNumber (dmgBonus)): dmgBonus = 0; ""]
[h: dmgRollObj = json.set (dmgRollObj, "bonus", dmgBonus - abilityBonus)]
[h: damageDescription = getGroup (attackFindId, 1, 8)]
<!-- damageType string  -->
[h: damageTypeObj = o5e_Parser_parseDamageType (damageDescription)]
[h: tail = json.get (damageTypeObj, "tail")]
[h: damageType = json.get (damageTypeObj, "damageType")]
[h: attackObj = json.set ("", "attackType", attackType,
                         "attackBonus", attackBonus - abilityBonus,
                         "reachRange", reachRange,
                         "attackRange", attackRange,
                         "damageAverage", dmgAvg - abilityBonus,
                         "damageRollObj", dmgRollObj,
                         "damageRollString", dmgRollString,
                         "damageType", damageType,
                         "tail", tail
                         )]
[h: log.debug (getMacroName() + ": attackObj = " + attackObj)]
[h: macro.return = attackObj]