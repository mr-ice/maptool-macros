[h: registry = arg (0)]
[h: regKeys = json.fields (registry, "json")]
[h: regKeys = json.merge ("['--- New Key ---']", regKeys)] 
[h: inputMsg = " junk | Select key to modify/create | | LABEL | span=true##" +
	" keyPos | " + json.toList (regKeys) + " | Key Name | LIST "]
[h: abort (input (inputMsg))]
[h: keyName = json.get (regKeys, keyPos)]

[h, if (keyPos == 0), code: {
	[innerItem = " keyName | keyName | New Key Name | Text ##"]
	[span = "false"]
	[action = "Create"]
	[propVars = "ignoreOutput=0; newScope=1"]
}; {
	[innerItem = ""]
	[span = "true"]
	[action = "Modify " + keyName]
	[propVars = json.get (registry, keyName)]
	[if  (propVars == ""): propVars = "ignoreOutput=0; newScope=1"; ""]
}]
[h: width = max (32, length (propVars) + 6)]
[h: updateMsg = " junk | " + action + " | | LABEL | span=true ##" + innerItem]
[h: updateMsg = updateMsg + 
	" propVars | " + propVars + " | UDF Properties | PROPS "]
[h: abort (input (updateMsg))]
[h: registry = json.set (registry, keyName, propVars)]
[h: macro.return = registry]