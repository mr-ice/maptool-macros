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
[h: l4m.Constants()]
[h, if (category == NATIVE_CATEGORY), code: {
	[oldFunction (msg)]
}; {
	[l4m.doLogEvent ("INFO", category, msg, suffix)]	
}]
[h: log.setLevel ("net.rptools.maptool.client.MapToolLineParser", currentLineParser)]