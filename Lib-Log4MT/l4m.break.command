[h: category = arg (0)]
[h: msg = arg (1)]
[h: condition = arg (2)]
[h: argArry = macro.args]
[h: l4m.Constants()]

[h: isEnabled = l4m.isLogLevelEnabled ("DEBUG", category, ".break")]
[h: log.debug (category, "Break level enabled: " + isEnabled + "; break condition: " + condition)]
[h, if (isEnabled && !condition), code: {
	<!-- were doing this -->
	[if (json.length (argArry) > 3):
		params = json.get (argArry, 3, json.length (argArry) - 1);
		params = "[]"]
	[message = json.append ("", json.set ("", "category", category), json.set ("", "msg", msg))]
	[message = json.append (message, json.set ("", "params", params))]
	[callStack = getLibProperty (CALL_STACK, LIB_LOG4MT)]
	[message = json.append (message, json.set ("", "currentCallStack", callStack))]
	[message = json.indent (message)]
	[abort (input ("jayEatsBoogers | <html><pre>" + json.indent (message) + "</pre></html> | | label | span=true", "evenOtherPeoplesBoogers | <html><b> Hit OK to continue and Cancel to break</b></html> | | label | span=true"))]
}]
