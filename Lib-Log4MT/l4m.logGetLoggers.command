[h: l4m.Constants()]
[h: libProperties = getMatchingLibProperties ("logger\\..*", LIB_LOG4MT, "json")]
[h: loggers = "{}"]
[h, foreach (libProperty, libProperties), code: {
	[logLevel = getLibProperty (libProperty, LIB_LOG4MT)]
	[if (logLevel != ""): loggers = json.set (loggers, libProperty, logLevel)]
}]
[h: macro.return = loggers]
