[h: currentLineParser = l4m.getCurrentLoggerLevel ("net.rptools.maptool.client.MapToolLineParser")]
[h: log.setLevel ("net.rptools.maptool.client.MapToolLineParser", "WARN")]
[h, if (argCount() > 1), code: {
	[category = arg(0)]
	[msg = arg(1)]
	[if (argCount() > 2): suffix = arg (2); suffix = ""]
}; {
	[category = ""]
	[suffix = ""]
	[msg = arg(0)]
}]
[h: l4m.doLogEvent ("WARN", category, msg, suffix)]
[h: log.setLevel ("net.rptools.maptool.client.MapToolLineParser", currentLineParser)]