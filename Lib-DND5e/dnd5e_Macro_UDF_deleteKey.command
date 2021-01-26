[h: registry = arg (0)]
[h: regKeys = json.fields (registry, "json")]
[h: inputMsg = " junk | Select key to modify | | LABEL | span=true##" +
	" keyName | " + json.toList (regKeys) + " | Key Name | LIST | value=string"]
[h: abort (input (inputMsg))]
[h: registry = json.remove (registry, keyName)]
[h: macro.return = registry]