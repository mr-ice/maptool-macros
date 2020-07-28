[h: saveString  = arg (0)]

[h: REG_DMG_ROLL_STRING = "\\((\\d+d\\d+\\s*[+-]?\\s*\\d*)\\)"]
[h: REG_SAVING_THROW = "DC\\s*(\\d+)\\s*(\\S+)\\s+saving throw"]
[h: REG_TAKE_DAMAGE = "(takes|taking|and)\\s*(\\d+)\\s*" + REG_DMG_ROLL_STRING + "\\s*(\\S+)\\s*(damage)"]
[h: REG_TAKE_EFFECT = "or\\s+be.*"]

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
	[saveDC = getGroup (saveFindId, findIdx, 1)]
	[saveAbility = getGroup (saveFindId, findIdx, 2)]
	[matchTOC = json.set (matchTOC, findIdx, json.set ("", "start", findStart, "end", findEnd, "token", strToken,
												"saveDC", saveDC, "saveAbility", saveAbility))]
}]

[h: head = substring (saveString, 0, find1Start)]
[h: unusedMatchTOC = json.set (matchTOC, "head", json.set ("", "start", 0, "end", find1Start, "token", head))]
[h: log.debug ("matchTOC: " + matchTOC)]
[h: matchObjs = "[]"]
<!-- for each entry in the TOC, find the effect in the token -->
[h, foreach (field, json.fields (matchTOC)), code: {
	[baseMatchObj = json.get (matchTOC, field)]
	[saveToken = json.get (baseMatchObj, "token")]
	[damageFindId = strfind (saveToken, REG_TAKE_DAMAGE)]
	[damageFindCount = getFindCount (damageFindId)]
	[damageLastGroupPos = 0]
	[for (findIdx, 1, damageFindCount + 1), code: {

		[avgDamage = getGroup (damageFindId, findIdx, 2)]
		[damageRollString = getGroup (damageFindId, findIdx, 3)]
		[damageRollObj = o5e_Parser_parseRollString (damageRollString)]
		[damageType = getGroup (damageFindId, findIdx, 4)]
		[matchObj = json.set (baseMatchObj, "averageDamage", avgDamage, "damageRollObj", damageRollObj,
							"damageType", damageType, "damageRollString", damageRollString)]
		[damageLastGroupPos = getGroupEnd (damageFindId, findIdx, getGroupCount (damageFindId))]
		[matchObjs = json.append (matchObjs, matchObj)]
	}]
	[saveEffect = substring (saveToken, damageLastGroupPos)]
	[matchObj = json.set (baseMatchObj, "saveEffect", saveEffect)]
	[matchObjs = json.append (matchObjs, matchObj)]
}]

[h: macro.return = matchObjs]