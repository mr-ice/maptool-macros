[h: damageString = arg(0)]
[h: damageTypeRegEx = "^(\\S+)\\sdamage[. ]?(.*)"]

[h: findId = strfind (damageString, damageTypeRegEx)]
[h: findCount = getFindCount (findId)]
[h: log.debug (getMacroName() + ": findCount = " + findCount)]
[h: retMap = "{}"]
[h, if (findCount > 0), code: {
	[dmgType = getGroup (findId, 1, 1)]
	[tail = getGroup (findId, 1, 2)]
	[retMap = json.set (retMap, "damageType", dmgType, "tail", tail)]
}; {
	[retMap = json.set (retMap, "tail", damageString)]
}]
[h: log.debug (getMacroName() + ": ret = " + retMap)]
[h: macro.return = retMap]