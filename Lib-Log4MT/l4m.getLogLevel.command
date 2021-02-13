[h, if (argCount() > 0): category = arg (0); category = ""]
[h, if (argCount() > 1): suffix = arg (1); suffix = ""]
[h: l4m.Constants()]
[h, if (category == ""): category = ROOT_LOGGER_CATEGORY; ""]

[h: propertyKey = l4m.getLoggerKey (category, suffix)]
<!-- First get the cateogry level -->
[h: categoryLevel = getLibProperty (propertyKey)]

<!-- Then get the root level -->
[h, if (category == ROOT_LOGGER_CATEGORY), code: {
	[rootLevel = categoryLevel]
}; {
	[rootKey = l4m.getLoggerKey (ROOT_LOGGER_CATEGORY)]
	[rootLevel = getLibProperty (rootKey)]
}]

[h: currentLevel = categoryLevel]
[h, if (currentLevel == ""): currentLevel = rootLevel; ""]

<!-- If either root or category are defined, return the effective level between them -->
<!-- If neither root or category are defined, return the current level of macro-logger -->

<!-- If no value for root, get value for macro-logger -->
[h, if (currentLevel == ""), code: {
	[h: currentLevel = l4m.getCurrentMacroLogger()]
};{}]

[h: macro.return = upper(currentLevel)]
