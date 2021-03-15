[h: v_l4m.category = arg (0)]
[h: v_l4m.msg = arg (1)]
[h: v_l4m.condition = arg (2)]
[h: v_l4m.argArry = macro.args]
[h: l4m.Constants()]

[h: isEnabled = l4m.isLogLevelEnabled ("DEBUG", v_l4m.category, ".break")]
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
	[l4m.error (v_l4m.category, v_l4m.message)]
	[abort (input (v_l4m.category + " details | <html><pre>" + json.indent (v_l4m.message) + "</pre></html> | | label | span=true", v_l4m.category + " details | <html><b> Hit OK to continue and Cancel to break</b></html> | | label | span=true",
	"updateJSON | {  } | | Text | span=true width=80",
	"updateJSON | To update any variables, define them within a JSON object and paste it above || label | span=true"))]
	[l4m.debug (v_l4m.category, "updateJson = " + updateJson)]
	[json.toVars (updateJson)]
	[if (l4m.isDebugEnabled (v_l4m.category)), code: {
		[v_l4m.jsonReport = "{}"]
		[foreach (update, json.fields (updateJson, "json")): 
			v_l4m.jsonReport = json.set (v_l4m.jsonReport, update, evalMacro ("[r: " + update + "]"))]
		[l4m.debug (v_l4m.category, "update report: " + v_l4m.jsonReport)]
	}]
}]