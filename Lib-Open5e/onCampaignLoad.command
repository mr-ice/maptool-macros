[h: setProperty ("libversion", "0.1")]

<!-- sigh, instead of explicitly defining each one, just inspect the relevant groups and iterate them -->
[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "o5e_") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h: defineFunction (macroName, macroName + "@this")]
	}]
}]

[h:log.info ("Lib:Open5e loaded")]