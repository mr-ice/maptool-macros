[h, if (json.length (macro.args) > 0): prefObj = arg (0); prefObj = "{}"]
[h, if (json.length (macro.args) > 1): secondaryObj = arg (1); secondaryObj = "{}"]
<!-- get the input object -->
<!-- retrieve the command from the preferences registry macro -->
[h: registry = dnd5e_Preferences_getRegistry ()]
[h: registry = json.merge (registry, secondaryObj)]
[h: inputString = dnd5e_Preferences_getRegistryInput (registry, prefObj)]

<!-- Prompt the user -->
[h: abort (input (inputString))]

<!-- Because the input will apply values to local variables, we have to extract
	those values from this macro. So in that case, the prompt work should
	be encapsulated in another macro for the other config preferences macros -->
[h: retMap = "{}"]
[h, foreach (field, json.fields (registry)), code: {
	[h: retMap = json.set (retMap, field, eval (field))]
}]
[h: log.debug ("retMap: " + retMap)]
[h: macro.return = retMap]