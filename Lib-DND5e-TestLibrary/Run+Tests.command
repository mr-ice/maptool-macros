[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h: fullReport = "{}"]
[h: macroList = "[]"]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "dnd5et_Test_") > -1): macroList = json.append (macroList, macroName); ""]
}]
[h, macro ("Override Run Tests@this"): ""]
[h: overrideObj = macro.return]
[h, if (json.type (overrideObj) == "OBJECT"), code: {
	[doOverride = json.get (overrideObj, "doOverride")]
	[overrideMacros = json.get (overrideObj, "macros")]
	[if (doOverride): macroList = overrideMacros; ""]
}]
[h, foreach (macroName, macroList),	code: {
		[h: log.warn ("Executing " + macroName)]
		[h: broadcast ("Executing " + macroName, "all")]
		[h: evalMacro ("[h: report = " + macroName + "()]")]
		[h: log.warn (report)]
		[h: fullReport = json.merge (fullReport, report)]
}]

[h: log.warn (fullReport)]