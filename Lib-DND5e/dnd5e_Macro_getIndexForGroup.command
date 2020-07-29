[h: groupLabel = arg (0)]
[h: retIndexes = "[]"]
[h: labels = getMacros ()]
[h, foreach (macroLabel, labels), code: {
	[log.debug (getMacroName() + ": macroLabel = " + macroLabel)]
	[h: indexes = getMacroIndexes (macroLabel)]
	[h, foreach (index, indexes), code: {
		[log.debug (getMacroName() + ": index = " + index)]
		[macroProps = getMacroProps (index, "json")]
		[macroGroup = json.get (macroProps, "group")]
		[if (macroGroup == groupLabel): retIndexes = json.append (retIndexes, index)]
	}]
}]
[h: macro.return = retIndexes]