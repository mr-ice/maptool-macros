<!-- Reads the registry and pulls out only the keys that would be prompted. -->
<!-- Cheat: ask for the input string and if we get null, omit that key from the
     return list -->
[h: registry = arg (0)]
[h, if (json.length (macro.args) > 1): prefObj = arg (1); prefObj = "{}"]
[h, if (json.length (macro.args) > 2): gmOnly = arg (2); gmOnly = 0]

[h: retList = "[]"]
[h, foreach (field, json.fields (registry)), code: {
	[h: regEntry = json.get (registry, field)]
	[h: entryInput = dnd5e_Preferences_convertPrefEntryToInput(regEntry, prefObj, gmOnly)]
	[h: log.debug (getMacroName() + ": entryInput = " + entryInput)]
	[h, if (encode (entryInput) != ""): retList = json.append (retList, field); ""]
}]

[h: log.debug (getMacroName() + ": retList =  " + retList)]
[h: macro.return = retList]