[h: args = macro.args]
[h: clientTime = l4m.getClientTime()]
[h: l4m.Constants()]
[h: macroName = json.get (args, "name")]
[h: retVal = json.get (args, "return")]
[h: tokenName = json.get (args, "token")]
[h: macroLogger = json.get (args, "macro-logger")]
[h: category = tokenName + "." + macroName]
[h, if (l4m.isLogLevelEnabled (ENTRY_EXIT_LOG_LEVEL, category, ".entryExit")), code: {
	[exitingMsg = "Exiting " + macroName + ": " + retVal]
	[log.setLevel ("macro-logger", "INFO")]
	[log.info (exitingMsg)]
}]

<!-- sets to the previous value -->
[h: log.setLevel ("macro-logger", macroLogger)]
[h: propertyName = l4m.getMeterName(macroName)]
[h: currentValue = getLibProperty (propertyName, LIB_PROXY)]
[h: startTime = json.get (currentValue, "startTime")]
[h: totalTime = clientTime - startTime]
[h: meters = json.get (currentValue, "meters")]
[h: meters = json.append (meters, totalTime)]
[h: currentValue = json.set (currentValue, "meters", meters)]

[h: setLibProperty (propertyName, currentValue, LIB_PROXY)]

[h: callStack = getLibProperty (CALL_STACK, LIB_PROXY)]
[h: callStack = json.remove (callStack, json.length (callStack) - 1)]
[h: setLibProperty (CALL_STACK, callStack, LIB_PROXY)]