[h: macros = getMacros()]
[h: fullReport = "{}"]
[h: macroList = "[]"]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "o5et_Test_") > -1): macroList = json.append (macroList, macroName); ""]
}]
[h: log.debug (getMacroName() + "##test macros: " + macroList)]
[h, macro ("Override Run Tests@this"): ""]
[h: overrideObj = macro.return]
[h, if (json.type (overrideObj) == "OBJECT"), code: {
	[doOverride = json.get (overrideObj, "doOverride")]
	[overrideMacros = json.get (overrideObj, "macros")]
	[if (doOverride): macroList = overrideMacros; ""]
}]
[h, foreach (macroName, macroList),	code: {
		[h: log.warn (getMacroName() + "##Executing " + macroName)]
		[h: broadcast ("Executing " + macroName, "all")]
		[h: evalMacro ("[h: report = " + macroName + "()]")]
		[h: fullReport = json.merge (fullReport, report)]
}]

[h: log.warn (getMacroName() + "##" + fullReport)]