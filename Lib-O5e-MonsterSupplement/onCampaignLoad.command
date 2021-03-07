[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "o5e_ExtDB") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h, if (macroName == "o5e_ExtDB_Constants"): newScope = 0; newScope = 1]
		[h: defineFunction (macroName, macroName + "@this", 0, newScope)]
	}]
}]
