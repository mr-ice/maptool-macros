[h: setProperty ("libversion", "0.1")]

<!-- sigh, instead of explicitly defining each one, just inspect the relevant groups and iterate them -->
[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "dnd5e_") > -1), code: {
		[h: log.debug ("Registering " + macroName)]
		[h: defineFunction (macroName, macroName + "@this")]
	}]
}]

[h, if (!isGM ()), code: {
	[landingMapName = dnd5e_Preferences_getPreference("landingMapName")]
	[mapNames = getAllMapNames ("json")]
	[if (json.contains (mapNames, landingMapName)): setCurrentMap (landingMapName); ""]
}; {}]
[h: log.debug (json.indent (getInfo ("client"), 3))]