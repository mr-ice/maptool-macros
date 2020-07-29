[h: actionString = arg (0)]
[h: log.debug (getMacroName() + ": actionString = " + actionString)]
<!-- parse the base details out first, the remainder is damage description that needs a lighter touch -->
<!-- If the base regex doesnt match, then return a SaveEffect expression of the full text -->

[h: attackObj = o5e_Parser_parseAttackString (actionString)]
[h, if (json.type (attackObj) == "OBJECT"), code: {
	[extraDamageStr = json.get (attackObj, "tail")]
}; {
	[extraDamageStr = actionString]
	[attackObj = "{}"]
}]
											
[h: extraDamageArry = "[]"]

[h, while (encode (extraDamageStr) != ""), code: {
	[saveDmgArray = o5e_Parser_parseSaveString (extraDamageStr)]
	[if (json.type (saveDmgArray) == "ARRAY"): extraDamageArry = json.merge (extraDamageArry, saveDmgArray); ""]
	       <!-- ex plus 7 (2d6) fire damage -->
	[extDmgReg = "^plus\\s?(\\d+)\\s?\\((\\d+d\\d+)\\)\\s((\\w+\\s*)+)\\s+(damage)[\\s.]?(.*)"]
	[extDmgFindId = strfind (extraDamageStr, extDmgReg)]
	[findMatches = getFindCount (extDmgFindId)]
	[if (findMatches > 0), code: {
		[extAvgDmg = getGroup (extDmgFindId, 1, 1)]
		[extDmgString = getGroup (extDmgFindId, 1, 2)]
		[extDmgType = getGroup (extDmgFindId, 1, 3)]
		[extDmgRollObj = o5e_Parser_parseRollString (extDmgString)]
		[dmgBonus = json.get (extDmgRollObj, "bonus")]
		[if (!isNumber (dmgBonus)): dmgBonus = 0; ""]
		[extDmgRollObj = json.set (extDmgRollObj, "bonus", dmgBonus)]
		
		[extraDmgObj = json.set ("", "averageDamage", extAvgDmg,
								    "damageRollObj", extDmgRollObj,
									"damageRollStr", extDmgString,
									"damageType", extDmgType)]
		[extraDamageArry = json.append (extraDamageArry, extraDmgObj)]
		[extraDamageStr = getGroup (extDmgFindId, 1, 4)]
	}; {
		<!-- only set extraDamageStr to the leftovers if we never found anything else -->
		<!-- otherwise, it should already be included -->
		[h, if (json.length (extraDamageArry) == 0): unused_extraDamageArry = json.append (extraDamageArry, json.set ("", "saveEffect", extraDamageStr)); ""]
		[extraDamageStr = ""]
	}]
	[log.debug (getMacroName () + ": extraDamageStr = " + extraDamageStr)]
}]
[h: retObj = json.set (attackObj, "extraDamage", extraDamageArry)]
[h: log.debug (getMacroName() + ": retObj = " + retObj)]
[h: macro.return = retObj]