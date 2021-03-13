[h: macroName = json.get (macro.args, "name")]
[h: tokenName = json.get (macro.args, "token")]
[h: args = json.get (macro.args, "args")]
[h: l4m.Constants()]

[h: category = tokenName + "." + macroName]
[h, if (l4m.isLogLevelEnabled (ENTRY_EXIT_LOG_LEVEL, category, ".entryExit")), code: {
	[enteringMsg = "Entering " + macroName + ": (" + args + ")"]
	[log.info (category, enteringMsg, ".entryExit")]
}]

[h: logLevel = l4m.getEffectiveLogLevel (category)]
[h, if (logLevel == ""): logLevel = ROOT_LOGGER_WRAPPER_DEFAULT_LEVEL]
[h: setLibProperty (LOGGER_PREFIX + ROOT_LOGGER_CATEGORY + ".level", logLevel, LIB_LOG4MT)]
[h: setLibProperty (COMPILED_LOGGER_PREFIX + ROOT_LOGGER_CATEGORY + ".value", "", LIB_LOG4MT)]
[h: setLibProperty (COMPILED_LOGGER_PREFIX + ROOT_LOGGER_CATEGORY + ".level", "", LIB_LOG4MT)]
[h: setLibProperty (COMPILED_LOGGER_PREFIX + ".value", "", LIB_LOG4MT)]
[h: setLibProperty (COMPILED_LOGGER_PREFIX + ".level", "", LIB_LOG4MT)]

[h: propertyName = l4m.getMeterName (macroName)]

[h: callStack = getLibProperty (CALL_STACK, LIB_LOG4MT)]
[h: callStack = json.append (callStack, macroName)]
[h: setLibProperty (CALL_STACK, callStack, LIB_LOG4MT)]

[h: currentValue = getLibProperty (propertyName, LIB_LOG4MT)]

[h: clientTime = l4m.getClientTime()]
[h: currentValue = json.set (currentValue, 
			"startTime", clientTime, "macroName", macroName)]
[h: setLibProperty (propertyName, currentValue, LIB_LOG4MT)]