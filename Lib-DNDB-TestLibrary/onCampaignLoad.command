
[h: setProperty ("libversion", "0.15")]

<!-- sigh, instead of explicitly defining each one, just inspect the relevant groups and iterate them -->
[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "dndbt_") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h: defineFunction (macroName, macroName + "@this")]
	}]
}]
[h: defineFunction ("dndbt_CleanToken", "Clean Token@this")]
[h: defineFunction ("dndbt_ResetProperties", "Reset Properties@Campaign")]