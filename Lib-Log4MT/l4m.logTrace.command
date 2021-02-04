[h, if (argCount() > 1), code: {
	[category = arg(0)]
	[msg = arg(1)]
}; {
	[category = ""]
	[msg = arg(0)]
}]
[h: l4m.doLogEvent ("TRACE", category, msg)]