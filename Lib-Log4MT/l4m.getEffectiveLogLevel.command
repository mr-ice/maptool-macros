
[h, if (argCount() > 0): category = arg (0); category = ""]
[h, if (argCount() > 1): compile = arg (1); compile = 0]
[h, if (argCount() > 2): suffix = arg (2); suffix = ".level"]
[h: l4m.Constants()]
[h: compiledLoggerLevel = COMPILED_LOGGER_PREFIX + category + suffix]
<!-- try compiled version first -->
[h: compiledLevel = getLibProperty (compiledLoggerLevel)]
[h, if (compiledLevel != ""): return (0, compiledLevel); ""]
[h, if (category == ""): 
	category = ROOT_LOGGER_CATEGORY; 
	category = ROOT_LOGGER_CATEGORY + "." + category]
<!-- Split the category on periods -->
[h: catList = stringToList (category, "\\.")]
[h: effectiveLevelVal = 0]
[h, foreach (catEl, json.fromList (catList)), code: {
	[level = l4m.getLogLevel (catEl, suffix)]
	[levelVal = json.get (LOGGER_LEVEL_MAP, level)]
	[effectiveLevelVal = max (effectiveLevelVal, levelVal)]
}]
[h: effectiveLevel = json.get (LOGGER_LEVEL_ARRAY, effectiveLevelVal)]
[h: setLibProperty (compiledLoggerLevel, effectiveLevel)]
[h: macro.return = effectiveLevel]