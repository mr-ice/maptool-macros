[h: macroName = json.get (macro.args, "name")]
[h: tokenName = json.get (macro.args, "token")]
[h: args = json.get (macro.args, "args")]
[h: l4m.Constants()]
[h: category = tokenName + "." + macroName]
[h: logLevel = l4m.getEffectiveLogLevel (category)]

[h, if (l4m.isLogLevelEnabled (ENTRY_EXIT_LOG_LEVEL, category, ".entryExit")), code: {
	[enteringMsg = "Entering " + macroName + ": (" + args + ")"]
	[log.setLevel ("macro-logger", "INFO")]		
	[log.info (enteringMsg)]
}]

[h: log.setLevel ("macro-logger", logLevel)]
[h: propertyName = l4m.getMeterName (macroName)]

[h: callStack = getLibProperty (CALL_STACK, LIB_PROXY)]
[h: callStack = json.append (callStack, macroName)]
[h: setLibProperty (CALL_STACK, callStack, LIB_PROXY)]

[h: currentValue = getLibProperty (propertyName, LIB_PROXY)]

[h: clientTime = l4m.getClientTime()]
[h: currentValue = json.set (currentValue, 
			"startTime", clientTime, "macroName", macroName)]
[h: setLibProperty (propertyName, currentValue, LIB_PROXY)]