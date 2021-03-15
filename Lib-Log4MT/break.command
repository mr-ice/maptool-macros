[h: v_l4m.category = arg (0)]
[h: v_l4m.msg = arg (1)]
[h: v_l4m.condition = arg (2)]
[h: v_l4m.argArry = macro.args]
[h: l4m.Constants()]
[h: currentLineParser = l4m.getCurrentLoggerLevel (LINE_PARSER)]
[h: log.setLevel (LINE_PARSER, "WARN")]

[h: isEnabled = l4m.isLogLevelEnabled ("DEBUG", v_l4m.category, ".break")]
[h: l4m.debug (v_l4m.category, "Break level enabled: " + isEnabled + "; break v_l4m.condition: " + v_l4m.condition)]
[h, if (isEnabled && !v_l4m.condition), code: {
	<!-- were doing this -->
	[if (json.length (v_l4m.argArry) > 3):
		params = json.get (v_l4m.argArry, 3, json.length (v_l4m.argArry) - 1);
		params = "[]"]
	[evalParams = "{}"]
	[foreach (param, params): evalParams = json.set (evalParams, param, evalMacro ("[r: " + param + "]"))]
	[v_l4m.message = json.append ("", json.set ("", "category", v_l4m.category), json.set ("", "msg", v_l4m.msg))]
	[v_l4m.message = json.append (v_l4m.message, json.set ("", "params", evalParams))]
	[callStack = getLibProperty (CALL_STACK, LIB_LOG4MT)]
	[v_l4m.message = json.append (v_l4m.message, json.set ("", "currentCallStack", callStack))]
	[v_l4m.message = json.indent (v_l4m.message)]
	[abort (input ("jayEatsBoogers | <html><pre>" + json.indent (v_l4m.message) + "</pre></html> | | label | span=true", "evenOtherPeoplesBoogers | <html><b> Hit OK to continue and Cancel to break</b></html> | | label | span=true",
	"updateJson | {  } | | Text | span=true width=80",
	"nastyJay | To update any variables, define them within a JSON object and paste it above || label | span=true"))]
	[l4m.debug (v_l4m.category, "updateJson = " + updateJson)]
	[json.toVars (updateJson)]
	[if (l4m.isDebugEnabled (v_l4m.category)), code: {
		[v_l4m.jsonReport = "{}"]
		[foreach (update, json.fields (updateJson, "json")): 
			v_l4m.jsonReport = json.set (v_l4m.jsonReport, update, evalMacro ("[r: " + update + "]"))]
		[l4m.debug (v_l4m.category, "update report: " + v_l4m.jsonReport)]
	}]
}]
[h: log.setLevel (LINE_PARSER, currentLineParser)]