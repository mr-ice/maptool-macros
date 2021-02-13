[h: level = arg (0)]
[h: category = arg (1)]
[h: msg = arg (2)]
[h, if (l4m.isLogLevelEnabled (level, category)), code: {
	[log.info (category + ": " + msg)]
}; {}]
