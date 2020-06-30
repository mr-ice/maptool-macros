[h: macros = getMacros()]
[h: log.debug ("macros: " + macros)]
[h: fullReport = "[]"]
[h, foreach (macroName, macros), code: {
	[h, if (lastIndexOf (macroName, "dndbt_Test_") > -1), code: {
		[h: log.warn ("Executing " + macroName)]
		[h: broadcast ("Executing " + macroName, "all")]
		[h: evalMacro ("[h: report = " + macroName + "()]")]
		[h: log.warn (report)]
		[h: fullReport = json.append (fullReport, report)]
	}]
}]
[h: log.warn (fullReport)]