[h: jsonObj = arg(0)]
[h, if (argCount() > 1): defaults = arg(1); defaults = "{}"]
[h: inputStr = ""]
[h, foreach (key, json.fields (jsonObj, "json")), code: {
	[currentVal = json.get (jsonObj, key)]
	[if (currentVal == ""): currentVal = json.get (defaults, key)]
	[inputStr = inputStr + " ## " + key + "|" + currentVal + " | " + key + " | TEXT"]
}]

[h: macro.return = inputStr]