[h: category = arg (0)]
[h: msg = arg (1)]
[h: condition = arg (2)]
[h: argArry = macro.args]
[h: l4m.Constants()]

[h: isEnabled = l4m.isLogLevelEnabled ("DEBUG", category, ".break")]
[h: l4m.debug (category, "Break level enabled: " + isEnabled + "; break condition: " + condition)]
[h, if (isEnabled && !condition), code: {
	<!-- were doing this -->
	[if (json.length (argArry) > 3):
		params = json.get (argArry, 3, json.length (argArry) - 1);
		params = "[]"]
	[evalParams = "{}"]
	[foreach (param, params): evalParams = json.set (evalParams, param, evalMacro ("[r: " + param + "]"))]
	[message = json.append ("", json.set ("", "category", category), json.set ("", "msg", msg))]
	[message = json.append (message, json.set ("", "params", evalParams))]
	[callStack = getLibProperty (CALL_STACK, LIB_LOG4MT)]
	[message = json.append (message, json.set ("", "currentCallStack", callStack))]
	[message = json.indent (message)]
	[abort (input ("jayEatsBoogers | <html><pre>" + json.indent (message) + "</pre></html> | | label | span=true", "evenOtherPeoplesBoogers | <html><b> Hit OK to continue and Cancel to break</b></html> | | label | span=true",
	"updateJson | {  } | | Text | span=true width=80",
	"nastyJay | To update any variables, define them within a JSON object and paste it above || label | span=true"))]
	[l4m.debug (category, "updateJson = " + updateJson)]
	[json.toVars (updateJson)]
	[if (l4m.isDebugEnabled (category)), code: {
		[jsonReport = "{}"]
		[foreach (update, json.fields (updateJson, "json")): 
			jsonReport = json.set (jsonReport, update, evalMacro ("[r: " + update + "]"))]
		[l4m.debug (category, "update report: " + jsonReport)]
	}]
}]
