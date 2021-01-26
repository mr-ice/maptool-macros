[h: registry = arg (0)]
[h: regKeys = json.fields (registry, "json")]
[h: regKeys = json.merge ("['--- New Key ---']", regKeys)] 
[h: inputMsg = " junk | Select key to delete | | LABEL | span=true##" +
	" keyPos | " + json.toList (regKeys) + " | Key Name | LIST "]
[h: abort (input (inputMsg))]
[h: keyName = json.get (regKeys, keyPos)]
[h: udfList = json.toList (json.get (registry, keyName))]
[h: width = max (32, length (udfList) + 6)]

[h, if (keyPos == 0), code: {
	[innerItem = " keyName | keyName | New Key Name | Text ##"]
	[span = "false"]
	[action = "Create"]
}; {
	[innerItem = ""]
	[span = "true"]
	[action = "Modify " + keyName]
}]
[h: updateMsg = " junk | " + action + " new value | | LABEL | span=true ##" + innerItem]
[h: updateMsg = updateMsg + 
	" udfNewList | " + udfList + " | New Value | TEXT | span=" + span + " width=" + width]
[h: abort (input (updateMsg))]
[h: registry = json.set (registry, keyName, json.fromList (udfNewList))]
[h: macro.return = registry]