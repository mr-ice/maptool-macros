[h, if (argCount() > 0): category = arg (0); category = ""]
[h, if (argCount() > 1): suffix = arg (1); suffix = ""]
[h: l4m.Constants()]
[h, if (category == ""): category = ROOT_LOGGER_CATEGORY; ""]

[h: propertyKey = l4m.getLoggerKey (category, suffix)]
<!-- Get the cateogry level -->
[h: categoryLevel = getLibProperty (propertyKey)]
[h: macro.return = upper(categoryLevel)]
