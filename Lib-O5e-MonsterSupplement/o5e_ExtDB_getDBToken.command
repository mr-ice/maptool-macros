[h, if (argCount() > 0): dbName = arg(0); dbName = ""]
[h: o5e_ExtDB_Constants(getMacroName())]
[h, if (dbName == ""): dbName = PROXY_TOKEN_NAME]
[h: mapNames = getAllMapNames("json")]
[h: dbTokenObj = "{}"]
[h, foreach (mapName, mapNames), code: {
	[foundId = findToken (dbName, mapName)]
	[if (foundId != ""), code: {
		[dbTokenObj = json.set (dbTokenObj, "tokenId", foundId, "mapName", mapName)]
	}]
}]
[h: macro.return = dbTokenObj]