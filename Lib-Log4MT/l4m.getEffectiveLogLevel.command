
[h, if (argCount() > 0): category = arg (0); category = ""]
[h, if (argCount() > 1): compile = arg (1); compile = 0]
[h, if (argCount() > 2): suffix = arg (2); suffix = ".level"]
[h, if (suffix == ""): suffix = ".level")]
[h: l4m.Constants()]
[h: compiledLoggerLevel = COMPILED_LOGGER_PREFIX + category + suffix]
<!-- try compiled version first -->
[h: compiledLevel = getLibProperty (compiledLoggerLevel)]
[h, if (compiledLevel != ""): return (0, compiledLevel); ""]

<!-- split up cat list on periods -->
[h: catList = stringToList (category, "\\.")]

<!-- split up last category on package delims -->
[h: lastCat = listGet (catList, listCount (catList) - 1)]
[h, if (lastCat != ""): catList = listDelete (catList, listCount (catList) - 1)]
[h: packageList = stringToList (lastCat, PACKAGE_DELIMS)]
[h: finalCatList = ROOT_LOGGER_CATEGORY]
[h, if (catList != ""): finalCatList = finalCatList  + "," + catList]
[h, if (packageList != ""): finalCatList = finalCatList + "," + packageList]
[h, if (lastCat != ""): finalCatList = finalCatList + "," + lastCat]

<!-- Starts at 1, or ERROR -->
[h: effectiveLevelVal = 1]
<!-- The logger categories are least specific to most specific. So
     we override the effective level as we find specific levels configured -->
[h, foreach (catEl, json.fromList (finalCatList)), code: {
	[level = l4m.getLogLevel (catEl, suffix)]
	[if (level == LOGGER_LEVEL_ENABLED): level = "TRACE"]
	[if (level == LOGGER_LEVEL_DISABLED): level = "ERROR"]
	[if (level != ""): effectiveLevelVal = json.get (LOGGER_LEVEL_MAP, level)]
}]
[h: effectiveLevel = json.get (LOGGER_LEVEL_ARRAY, effectiveLevelVal)]

[h: setLibProperty (compiledLoggerLevel, effectiveLevel)]
[h: macro.return = effectiveLevel]