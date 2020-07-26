[h: actionString = arg (0)]
[h: log.debug (getMacroName() + ": actionString = " + actionString)]
<!-- parse the base details out first, the remainder is damage description that needs a lighter touch -->
<!-- If the base regex doesnt match, then return a SaveEffect expression of the full text -->
[h: baseRegEx = 
"(Melee|Ranged) *Weapon Attack: *([+-]\\d+) *to hit, *(range|reach) *(\\d+\\/?\\d*) ft\\.?,? *\\S* *\\S*\\. *Hit: *(\\d+) *\\((\\d+d\\d+\\s*\\+\\s*\\d*)\\) *(.*)"]
[h: baseFindId = strfind (actionString, baseRegEx)]
[h: findMatches = getFindCount (baseFindId)]
[h, if (findMatches == 0), code: {
	[log.debug (getMacroName() + ": No match, returning original")]
	[return (0, actionString)]
}]
<!-- there are 7 capture groups, with 7th being the tail -->
[h: attackType = getGroup (baseFindId, 1, 1)]
[h: attackBonus = getGroup (baseFindId, 1, 2)]
[h: reachRange = getGroup (baseFindId, 1, 3)]
[h: attackRange = getGroup (baseFindId, 1, 4)]
[h: dmgAvg = getGroup (baseFindId, 1, 5)]

[h, if (attackType == "Melee"): ability = "Strength"; ability = "Dexterity"]
[h: abilityBonus = eval (ability + "Bonus")]

[h: dmgRollString = getGroup (baseFindId, 1, 6)]
[h: dmgRollObj = o5e_Parser_parseRollString (dmgRollString)]
[h: dmgBonus = json.get (dmgRollObj, "bonus")]
[h: dmgRollObj = json.set (dmgRollObj, "bonus", dmgBonus - abilityBonus)]
[h: attackObj = json.set ("", "attackType", attackType,
                         "attackBonus", attackBonus - abilityBonus,
                         "reachRange", reachRange,
                         "attackRange", attackRange,
                         "damageAverage", dmgAvg - abilityBonus,
                         "damageRollObj", dmgRollObj,
                         "damageRollString", dmgRollString)]
[h: damageDescription = getGroup (baseFindId, 1, 7)]
[h: log.debug (getMacroName() + ": damageDescription = " + damageDescription)]

<!-- damageType string  -->
[h: damageTypeObj = o5e_Parser_parseDamageType (damageDescription)]
[h: damageType = json.get (damageTypeObj, "damageType")]
[h: attackObj = json.set (attackObj, "damageType", damageType)]

[h: extraDamageArry = "[]"]
[h: extraDamageStr = json.get (damageTypeObj, "tail")]
[h, while (encode (extraDamageStr) != ""), code: {
	       <!-- ex plus 7 (2d6) fire damage -->
	[extDmgReg = "^plus\\s?(\\d+)\\s?\\((\\d+d\\d+)\\)\\s(\\S+)\\sdamage[\\s.]?(.*)"]
	[extDmgFindId = strfind (extraDamageStr, extDmgReg)]
	[findMatches = getFindCount (extDmgFindId)]
	[if (findMatches > 0), code: {
		[extAvgDmg = getGroup (extDmgFindId, 1, 1)]
		[extAvgDmg = extAvgDmg - abilityBonus]
		[extDmgString = getGroup (extDmgFindId, 1, 2)]
		[extDmgType = getGroup (extDmgFindId, 1, 3)]
		[extDmgRollObj = o5e_Parser_parseRollString (extDmgString)]
		[dmgBonus = json.get (extDmgRollObj, "bonus")]
		[extDmgRollObj = json.set (extDmgRollObj, "bonus", dmgBonus - abilityBonus)]
		
		[extraDmgObj = json.set ("", "averageDamage", extAvgDmg,
								    "damageRollObj", extDmgRollObj,
									"damageRollStr", extDmgString,
									"damageType", extDmgType)]
		[extraDamageArry = json.append (extraDamageArry, extraDmgObj)]
		[extraDamageStr = getGroup (extDmgFindId, 1, 4)]
	}; {
		[extraDamageArry = json.append (extraDamageArry, json.set ("", "saveEffect", extraDamageStr))]
		[extraDamageStr = ""]
	}]
	[log.debug (getMacroName () + ": extraDamageStr = " + extraDamageStr)]
}]
[h: retObj = json.set (attackObj, "extraDamage", extraDamageArry)]
[h: log.debug (getMacroName() + ": retObj = " + retObj)]
[h: macro.return = retObj]