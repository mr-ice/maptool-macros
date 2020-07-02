[h: registry = arg (0)]

<!-- Edit -->
[h: prefEntriesKeys = json.toList (json.fields (registry))]
[h: abort (input ( "prefEntryKey | " + prefEntriesKeys + " | Select registry entry | LIST | value=string"))]
[h: prefEntry = json.get (registry, prefEntryKey)]

[h: editInputString = dnd5e_Util_getMetaInputString (prefEntry)]
[h: abort (input ( editInputString))]
[h, if (inputOpts != "0"): prefOpts = inputOpts; prefOpts = ""]
[h: regObj = json.set ("", "key", inputVar,
						"value", inputValue,
						"prompt", inputPrompt,
						"type", inputType,
						"opts", prefOpts)]
[h: registry = json.set (registry, inputVar, regObj)]
[h: macro.return = registry]