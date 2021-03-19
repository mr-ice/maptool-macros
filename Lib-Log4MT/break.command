<!-- Whats with the cryptic variable names? We have to share the same scope as the caller.
	 So care must be taken that we dont declare a variable already present in the callers scope. -->
[h: v_l4m.category = arg (0)]
[h: v_l4m.msg = arg (1)]
[h: v_l4m.condition = arg (2)]
[h: v_l4m.argArry = macro.args]
<!-- When you write a logging framework to overlay the existing logging framework, it gets
	tricky if you have to debug your own logging framework. A condition of -1 is an internally
	used flag that means, "dont wait for the translation, just answer the question!", more or less. -->
[h, if (v_l4m.condition == -1), code: {
	[v_skipL4m = 1]
	[v_l4m.condition = 0]
}; {
	[v_skipL4m = 0]
}]
[h: l4m.Constants()]

[h, if (!v_skipL4m): isEnabled = l4m.isLogLevelEnabled ("DEBUG", v_l4m.category, ".break"); isEnabled = 1]
[h, if (isEnabled && !v_l4m.condition), code: {
	<!-- were doing this -->
	[if (json.length (v_l4m.argArry) > 3):
		v_l4m.params = json.get (v_l4m.argArry, 3, json.length (v_l4m.argArry) - 1);
		v_l4m.params = "[]"]
	[v_l4m.evalParams = "{}"]
	[foreach (v_l4m_param, v_l4m.params): v_l4m.evalParams = json.set (v_l4m.evalParams, v_l4m_param, evalMacro ("[r: " + v_l4m_param + "]"))]
	[v_l4m.message = json.append ("", json.set ("", "category", v_l4m.category), json.set ("", "msg", v_l4m.msg))]
	[v_l4m.callStack = getLibProperty (CALL_STACK, LIB_LOG4MT)]
	[v_l4m.message = json.append (v_l4m.message, json.set ("", "currentCallStack", v_l4m.callStack))]
	[v_l4m.template ="<b><font size='3'>Argument:</font> <font color=blue>%{v_l4m_paramField}</font> " 
			+ "----------------------------------------------------------------------------------------</b>" 
			+ "%{v_l4m.paramValue}"]
	[v_l4m.htmlMsg = ""]
	[foreach (v_l4m_paramField, json.fields (v_l4m.evalParams, "json")), code: {
		[v_l4m.paramValue = json.get (v_l4m.evalParams, v_l4m_paramField)]
		[if (json.type (v_l4m.paramValue) != "UNKNOWN"): 
			v_l4m.paramValue = "<pre>" + json.indent (v_l4m.paramValue) + "</pre>";
			v_l4m.paramValue = "<br>" + v_l4m.paramValue + "<br>"]
		[v_l4m.htmlMsg = v_l4m.htmlMsg + strformat (v_l4m.template) + "<br>"]
	}]
	<!-- when skipping L4M, we cant use l4m.* / log.* functions -->
	[dialog5 ("Breakpoint parameters: " + v_l4m.category, "width=600; height=600"): {
		<html>
		    [r: v_l4m.htmlMsg]
		</html>
	}]

	[if (!v_skipL4m): l4m.error (v_l4m.category, v_l4m.message)]
	[abort (input (v_l4m.category + " details | <html><pre>" + json.indent (v_l4m.message) + "</pre></html> | | label | span=true", v_l4m.category + " details | <html><b> Hit OK to continue and Cancel to break</b></html> | | label | span=true",
	"updateJSON | {  } | | Text | span=true width=80",
	"updateJSON | To update any variables, define them within a JSON object and paste it above || label | span=true"))]
	[if (!v_skipL4m): l4m.debug (v_l4m.category, "updateJson = " + updateJson)]
	[json.toVars (updateJson)]
	[v_l4m.jsonReport = "{}"]
	[foreach (update, json.fields (updateJson, "json")): 
		v_l4m.jsonReport = json.set (v_l4m.jsonReport, update, evalMacro ("[r: " + update + "]"))]
	[if (!v_skipL4m): l4m.debug (v_l4m.category, "update report: " + v_l4m.jsonReport)]

}]