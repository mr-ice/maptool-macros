<!-- Converts the registry object into an input string -->
<!-- The magic here is to incorporate the inputted preference object into the values
	entries for the input string -->
[h: registry = arg (0)]
[h, if (json.length (macro.args) > 1): prefObj = arg (1); prefObj = "{}"]
[h, if (json.length (macro.args) > 2): gmOnly = arg (2); gmOnly = 0]

[h: inputString = ""]
[h, foreach (field, json.fields (registry)), code: {
	[h: regEntry = json.get (registry, field)]
	[h: log.debug ("dnd5e_Preferences_getRegistryInput: regEntry = " + regEntry + "; prefOjb = " + prefObj)]
	[h: entryInput = dnd5e_Preferences_convertPrefEntryToInput(regEntry, prefObj, gmOnly)]
	[h: log.debug (getMacroName() + ": entryInput = " + entryInput)]
	[h, if (encode (entryInput) != ""): inputString = inputString + "##" + entryInput; ""]
}]
[h, if (startsWith (inputString, "##")): inputString = substring (inputString, 2); ""]
[h: log.debug ("dnd5e_Preferences_getRegistryInput: " + inputString)]
[h: macro.return = inputString]