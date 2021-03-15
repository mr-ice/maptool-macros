[h, if (argCount() > 0): category = arg (0); category = ""]
[h, if (argCount() > 1): suffix = arg (1); suffix = ""]
[h: macro.return = l4m.isLogLevelEnabled ("DEBUG", category, suffix)]