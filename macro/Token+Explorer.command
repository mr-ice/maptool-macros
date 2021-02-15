[h: propNames = getPropertyNames ("json")]
[h: propObj = "{}"]
[h, foreach (propName, propNames), code: {
	[value = getProperty(propName)]
	[propObj = json.set (propObj, propName, value)]
}]
[frame (getName() + " Properties"): {
	[h: propObj = replace (propObj, "<", "&lt;")]
	[h: propObj = replace (propObj, "\\\\n", "<br>&nbsp;&nbsp;&nbsp;")]
	<pre>[r: json.indent (propObj)]</pre>
}]
