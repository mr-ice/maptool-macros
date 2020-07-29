[h: saveString  = arg (0)]

[h: REG_DMG_ROLL_STRING = "\\((\\d+d\\d+\\s*[+-]?\\s*\\d*)\\)"]
[h: REG_SAVING_THROW = "DC\\s*(\\d+)\\s*(\\S+)\\s+saving throw"]
[h: REG_TAKE_DAMAGE = "(take[s]?|taking|and)\\s*(\\d+)\\s*" + REG_DMG_ROLL_STRING + "\\s+((\\w+\\s*)+)\\s+(damage)"]
[h: REG_TAKE_EFFECT = "(or\\s+be\\S*)\\s+.*"]

[h: saveFindId = strfind (saveString, REG_SAVING_THROW)]
[h: findCount = getFindCount (saveFindId)]
<!-- for non-save strings, return the original -->
[h, if (findCount == 0): return (0, saveString); ""]
[h: matchTOC = "{}"]
[h: find1Start = 0]
[h, for (findIdx, 1, findCount + 1), code: {
	[findStart = getGroupStart (saveFindId, findIdx, 0)]
	[if (findIdx == 1): find1Start = findStart, ""]
	[findEnd = getGroupEnd (saveFindId, findIdx, 0)]
	[if (findIdx < findCount): subStrEnd = getGroupStart (saveFindId, findIdx + 1, 0); subStrEnd = length (saveString)]
	[strToken = substring (saveString, findEnd, subStrEnd)]
	[if (findIdx == 1): strToken = substring (saveString, 0, subStrEnd)]
	[saveDC = getGroup (saveFindId, findIdx, 1)]
	[saveAbility = getGroup (saveFindId, findIdx, 2)]
	[matchTOC = json.set (matchTOC, findIdx, json.set ("", "start", findStart, "end", findEnd, "token", strToken,
												"saveDC", saveDC, "saveAbility", saveAbility))]
}]


[h: log.debug ("matchTOC: " + matchTOC)]
[h: matchObjs = "[]"]
<!-- for each entry in the TOC, find the effect in the token -->
[h, foreach (field, json.fields (matchTOC)), code: {
	[subMatchObjs = "[]"]
	[baseMatchObj = json.get (matchTOC, field)]
	[saveToken = json.get (baseMatchObj, "token")]

	<!-- search for damage string -->
	[damageFindId = strfind (saveToken, REG_TAKE_DAMAGE)]
	[damageFindCount = getFindCount (damageFindId)]
	
	[damageLastGroupPos = 0]
	[damageFirstGroupPos = 0]

	[for (findIdx, 1, damageFindCount + 1), code: {

		[firstPos = getGroupStart (damageFindId, findIdx, 0)]
		[if (findIdx == 1): damageFirstGroupPos = firstPos; ""]
		[avgDamage = getGroup (damageFindId, findIdx, 2)]
		[damageRollString = getGroup (damageFindId, findIdx, 3)]
		[damageRollObj = o5e_Parser_parseRollString (damageRollString)]
		[damageType = getGroup (damageFindId, findIdx, 4)]
		[matchObj = json.set (baseMatchObj, "averageDamage", avgDamage, "damageRollObj", damageRollObj,
							"damageType", damageType, "damageRollString", damageRollString)]
		[damageLastGroupPos = getGroupEnd (damageFindId, findIdx, getGroupCount (damageFindId))]
		[subMatchObjs = json.append (subMatchObjs, matchObj)]
	}]

	[log.debug (getMacroName() + ": subMatchObjs = " + subMatchObjs)]

			<!-- also search for save string -->
	[effectFindId = strfind (saveToken, REG_TAKE_EFFECT)]
	[effectFindCount = getFindCount (effectFindId)]
	[adornSubMatchObjs = 0]

	<!-- the effect is before the damage "or become fucked and later take damage" -->
	<!-- ditch the match objs we made and dump everything as the effect -->
	<!-- effect was after the damage - adorn the damage with the effect -->
	<!-- if an effect was found, well get the effect string starting from "or shit happens" -->
	<!-- nesting limit flag it, do it outside this code block -->
	
	[if (effectFindCount > 0), code: {
		[firstPos = getGroupStart (effectFindId, 1, 0)]
		[if (firstPos < damageFirstGroupPos): subMatchObjs = json.append (baseMatchObj, json.set ("", "saveEffect", saveToken)); adornSubMatchObjs = 1]
	}; {
		""
	}]

	[newSubMatchObjs = "[]"]
	[foreach (subMatchObj, subMatchObjs), code: {

		[if (adornSubMatchObjs): subMatchObj = json.set (subMatchObj, "saveEffect", saveToken); ""]
		[newSubMatchObjs = json.append (newSubMatchObjs, subMatchObj)]
	}]

	<!-- if were here and newSubMatchObjs is empty, we failed to parse damage or effect for something that
	     we know has a save. So accept were not smart enough and build a simple object from what we know -->
	[if (json.length (newSubMatchObjs) == 0), code: {
		[saveEffect = json.get (baseMatchObj, "token")]
		[baseMatchObj = json.set (baseMatchObj, "saveEffect", saveEffect)]
		[newSubMatchObjs = json.append ("", baseMatchObj)]
	}]
	<!-- Slapem all together -->
	<!-- I feel dirty... -->
	[matchObjs = json.merge (matchObjs, newSubMatchObjs)]


}]

[h: macro.return = matchObjs]