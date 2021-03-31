[h: saveString  = arg (0)]
[h: o5e_Constants (getMacroName())]
<!-- Captures the roll string for damage; ex 1d6+8 -->
[h: REG_DMG_ROLL_STRING = "\\((\\d+d\\d+\\s*[+-]?\\s*\\d*)\\)"]
<!-- seraches for the pattern DC 14 Constitution saving throw -->
[h: REG_SAVING_THROW = "DC\\s*(\\d+)\\s*(\\S+)\\s+saving throw"]
<!-- takes 7 (2d6+1) punching damage -->
<!-- so far, we have to anticipate takes and taking. we also have to find the second roll in:
     takes 7 (2d6+1) punching damage and 10 (2d10+3) nagging damage -->
<!-- Issue #110 - sometimes we 'deal' damage -->
[h: REG_TAKE_DAMAGE = "(take[s]?|taking|deals|and)\\s*(\\d+)\\s*" + REG_DMG_ROLL_STRING + "\\s+((\\w+\\s*)+)\\s+(damage)"]
<!-- Issue #110 - sometimes we dont specify the damage type immediately -->
[h: REG_TAKE_UNTYPED_DAMAGE = "(take[s]?|taking|deals|and)\\s*(\\d+)\\s*" + REG_DMG_ROLL_STRING + 
	"(\\s+)(damage)"]
<!-- or be(come) fucked -->
[h: REG_TAKE_EFFECT = "(or\\s+be\\S*)\\s+.*"]

<!-- Search to see if it has a saving throw in the string -->
[h: saveFindId = strfind (saveString, REG_SAVING_THROW)]
[h: findCount = getFindCount (saveFindId)]
<!-- for non-save strings, return the original -->
[h, if (findCount == 0): return (0, saveString); ""]
<!-- build table of contents styled objects that mark capture group indexes -->
[h: matchTOC = "{}"]
[h: find1Start = 0]
[h: log.trace (CATEGORY + "## findCount = " + findCount)]
[h, for (findIdx, 1, findCount + 1), code: {
	[findStart = getGroupStart (saveFindId, findIdx, 0)]
	[if (findIdx == 1): find1Start = findStart, ""]
	[findEnd = getGroupEnd (saveFindId, findIdx, 0)]
	[if (findIdx < findCount): subStrEnd = getGroupStart (saveFindId, findIdx + 1, 0); 
			subStrEnd = length (saveString)]
	[strToken = substring (saveString, findEnd, subStrEnd)]
	[log.debug (CATEGORY + "## strToken = " + strToken)]
	<!-- ensure the first token starts from the beginning of the saveString -->
	[if (findIdx == 1): strToken = substring (saveString, 0, subStrEnd)]
	[saveDC = getGroup (saveFindId, findIdx, 1)]
	[saveAbility = getGroup (saveFindId, findIdx, 2)]
	[matchTOC = json.set (matchTOC, findIdx, json.set ("", "start", findStart, "end", 
			findEnd, "token", strToken, "saveDC", saveDC, "saveAbility", saveAbility))]
}]

[h: log.debug (CATEGORY + "## matchTOC = " + matchTOC)]
[h: matchObjs = "[]"]
<!-- for each entry in the TOC, find the effect in the token -->
<!-- the effect may either just be damage or the "or be fucked in this specific way" text -->
[h, foreach (field, json.fields (matchTOC)), code: {
	[subMatchObjs = "[]"]
	[baseMatchObj = json.get (matchTOC, field)]
	[saveToken = json.get (baseMatchObj, "token")]

	<!-- search for damage string -->
	[damageFindId = strfind (saveToken, REG_TAKE_DAMAGE)]
	[damageFindCount = getFindCount (damageFindId)]
	[if (damageFindCount == 0), code: {
		[log.debug (CATEGORY + "## Trying untyped damage")]
		[damageFindId = strfind (saveToken, REG_TAKE_UNTYPED_DAMAGE)]
		[damageFindCount = getFindCount (damageFindId)]
	}; {}]
	[log.debug (CATEGORY + "## damageFindCount = " + damageFindCount)]	
	[damageLastGroupPos = 0]
	[damageFirstGroupPos = 0]

	<!-- for each damage captured, build an array of objects with damage details -->
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

	<!-- also search for take effect string. There may be some magic juju to do if
	     both damage and effect strings are found-->
	[effectFindId = strfind (saveToken, REG_TAKE_EFFECT)]
	[effectFindCount = getFindCount (effectFindId)]
	[adornSubMatchObjs = 0]
	
	[if (effectFindCount > 0), code: {
		[firstPos = getGroupStart (effectFindId, 1, 0)]
		<!-- the effect is before the damage "or become fucked and later take damage" -->
		<!-- ditch the match objs we made and dump everything as the effect -->
		[if (firstPos < damageFirstGroupPos): subMatchObjs = json.append (baseMatchObj, json.set ("", "saveEffect", saveToken)); adornSubMatchObjs = 1]
	}; {
		""
	}]

	[newSubMatchObjs = "[]"]
	[foreach (subMatchObj, subMatchObjs), code: {
		<!-- if effect was after the damage - adorn the damage with the effect -->
		<!-- nesting limit flag it, do it outside this code block -->

		[if (adornSubMatchObjs): subMatchObj = json.set (subMatchObj, "saveEffect", saveToken); ""]
		[newSubMatchObjs = json.append (newSubMatchObjs, subMatchObj)]
	}]
	[log.debug (CATEGORY + "## newSubMatchObjs = " + newSubMatchObjs)]
	
	<!-- if were here and newSubMatchObjs is empty, we failed to parse damage or effect for something that
	     we know has a save. So accept were not smart enough and build a simple object from what we know -->
	[if (json.length (newSubMatchObjs) == 0), code: {
		[log.debug (CATEGORY + "## Building basic object")]
		[saveEffect = json.get (baseMatchObj, "token")]
		[baseMatchObj = json.set (baseMatchObj, "saveEffect", saveEffect)]
		[newSubMatchObjs = json.append ("", baseMatchObj)]
	}]
	<!-- Slapem all together -->
	<!-- I feel dirty... -->
	[matchObjs = json.merge (matchObjs, newSubMatchObjs)]
}]

[h: macro.return = matchObjs]