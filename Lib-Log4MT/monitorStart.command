[h: macroName = json.get (macro.args, "name")]
[h: args = json.get (macro.args, "args")]
[h: prf_Constants()]
[h: log.info ("Entering " + macroName + ": (" + args + ")")]
[h: propertyName = prf_getMeterName (macroName)]

[h: callStack = getLibProperty (CALL_STACK, LIB_PROXY)]
[h: callStack = json.append (callStack, macroName)]
[h: setLibProperty (CALL_STACK, callStack, LIB_PROXY)]

[h: currentValue = getLibProperty (propertyName, LIB_PROXY)]

[h: clientTime = prf_getClientTime()]
[h: currentValue = json.set (currentValue, 
			"startTime", clientTime, "macroName", macroName)]
[h: setLibProperty (propertyName, currentValue, LIB_PROXY)]