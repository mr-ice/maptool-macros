[h: newConfig = arg(0)]
[h: selectedLibToken = arg(1)]
[h: applyOvewrite = arg(2)]
[h: l4m.Constants()]
[h: CATEGORY = getMacroName() + "." + LIB_LOG4MT]

[h: defineMacroCmd = "[h: overwriteMacros = '[]']" + NEW_LINE]
[h, foreach (functionName, json.fields (newConfig, "json")), code: {
	[defineMacroCmd = defineMacroCmd + 
			"[h: overwriteMacros = json.append (overwriteMacros, '" + functionName + "')]" + NEW_LINE]
}]

[h: l4m.setWrapperConfig (selectedLibToken, newConfig)]
<!-- Build the Define Overwrite macros -->
[h, token (selectedLibToken), code: {
	[macroIndexes = getMacroIndexes (MACRO_OVERWRITE_UDF_NAME)]
	[foreach (macroIndex, macroIndexes): removeMacro (macroIndex)]
	[defineMacroCmd = defineMacroCmd + 
		"[h: src = json.get (getMacroContext(), 'source')]" + NEW_LINE +
		"[h: wrapperCfgs = l4m.getWrapperConfig (src)]" + NEW_LINE +
		"[h, foreach (wrapperName, json.fields (wrapperCfgs, 'json')), code: {" + NEW_LINE +
		"	[cfg = json.get (wrapperCfgs, wrapperName)]" + NEW_LINE +
		"	[ignoreOutput = json.get (cfg, '" + CFG_IGNORE_OUTPUT  + "')]" + NEW_LINE +
		"	[newScope = json.get (cfg, '" + CFG_NEW_SCOPE + "')]" + NEW_LINE +
		"	[defineFunction (wrapperName, wrapperName + '@this', " +
				"ignoreOutput, newScope)]" + NEW_LINE +
		"}]"]
	[props = json.set ("", "playerEditable", 0, "group", "Init")]
	[createMacro (MACRO_OVERWRITE_UDF_NAME, defineMacroCmd, props)]
}]
[h: l4m.debug (CATEGORY, "applyOvewrite = " + applyOvewrite)]
[h, if (applyOvewrite), code: {
	[macro (MACRO_OVERWRITE_UDF_NAME + "@" + selectedLibToken): ""]
}; {}]