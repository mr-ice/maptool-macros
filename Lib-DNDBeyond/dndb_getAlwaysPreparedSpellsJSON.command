[h: toon = arg(0)]
[h, if (encode(toon) == ''), code: {
	[h: broadcast ("A toon object must be passed", "self")]
	[h: abort (0)]
}; {}]
[h: BASE_AP_URL = "https://character-service.dndbeyond.com/character/v4/game-data/always-prepared-spells"]
[h: classArry = json.path.read (toon, "data.classes")]
[h: apSpellListArry = "[]"]
[h: classIdLevelMap = "{}"]
[h, foreach (classEl, classArry), code: {
	[classId = json.path.read (classEl, "definition.id")]
	[classLvl = json.get (classEl, "level")]
	[classIdLevelMap = json.set (classIdLevelMap, classId, classLvl)]
	[subClassDefinition = json.get (classEl, "subclassDefinition")]
	[if (encode (subClassDefinition) != ''), code: {
		[subClassId = json.get (subClassDefinition, "id")]
		[classIdLevelMap = json.set (classIdLevelMap, subClassId, classLvl)]
	}; {}]
}]
[h, foreach (classId, json.fields (classIdLevelMap)), code: {
	[classLevel = json.get (classIdLevelMap, classId)]
	[url = BASE_AP_URL + "?classId=" + classId + "&classLevel=" + classLevel]
	[log.info (getMacroName() + ": url = " + url)]
	[retData = REST.get(url)]
	[data = json.get (retData, "data")]
	<!-- I wonder how well json.union works w arrays of objects... -->
	[apSpellListArry = json.union (apSpellListArry, data)]
}]
[h: macro.return = apSpellListArry]
