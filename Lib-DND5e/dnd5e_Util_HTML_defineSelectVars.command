[h: options = arg(0)]
[h: selectedOption = arg(1)]
[h: identifier = arg(2)]

[h: selectedVarname = "None"]
[h, foreach (option, options), code: {
	[varName = identifier + "." + option + ".selected"]
	[selectedVal = ""]
	[if (option == selectedOption), code: {
		[selectedVal = "selected"]
		[selectedVarname = varName]
	};{}]
	[macroExpression = "[h: " + varName + " = '" + selectedVal + "']"]
	[log.debug (getMacroName() + ": macroExpression = " + macroExpression)]
	[evalMacro (macroExpression)]
}]

[h: macro.return = selectedVarname]
