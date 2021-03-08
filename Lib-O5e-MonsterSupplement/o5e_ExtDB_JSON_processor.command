[h: data = arg(0)]
[h: o5e_ExtDB_Constants (getMacroName())]
[h: log.debug (CATEGORY + "data = " + data)]
[h: action = json.get (data, "action")]
[h, if (action == "save"), code: {
	[h: monsterDb = json.get (data, "object")]
	[h: objType = json.type (monsterDb)]
	[h, if (objType != "OBJECT"), code: {
		<!-- JSON Editor returns an encoded object -->
		[monsterDb = decode (monsterDb)]
		[objType = json.type (monsterDb)]
	}]
	[h: assert (objType == "OBJECT", "Monster Data is not valid a JSON object!")]
	[h: o5e_ExtDB_setDB (monsterDb)]
}]