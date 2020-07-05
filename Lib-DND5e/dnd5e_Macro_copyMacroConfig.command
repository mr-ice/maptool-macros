[h: macroName = arg (0)]
[h: macroIndexes = getMacroIndexes (macroName, "json")]
[h: log.debug ("dnd5e_Macro_copyMacroConfig: macroIndexes = " + macroIndexes)]
[h: macroConfig = "{}"]
[h, if (json.length (macroIndexes) > 0), code: {
	[h: index = json.get (macroIndexes, 0)]
	[h: macroConfig = getMacroProps (index, "json")]
}]

[h: log.debug ("dnd5e_Macro_copyMacroConfig: macroConfig = " + json.indent (macroConfig))]
[h: macro.return = macroConfig]