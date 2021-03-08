[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, macro ("o5e_ExtDB_UDF_getRegistry@this"): ""]
[h: registry = macro.return]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "o5e_ExtDB") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h: registered = json.get (registry, macroName)]
		[h: ignoreOutput = 0]
		[h: newScope = 1]
		[h, if (registered != ""): varsFromStrProp (registered); ""]
		[h: defineFunction (macroName, macroName + "@this", ignoreOutput, newScope)]
	}]
}]
