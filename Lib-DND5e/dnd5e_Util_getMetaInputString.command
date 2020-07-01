[h, if (json.length (macro.args) > 0): prefEntry = arg (0); 
		prefEntry = json.set ("", "key", "variableName",
								"value", "value",
								"prompt", "prompt",
								"type", "TEXT",
								"opts", "")]

[h: variableName = json.get (prefEntry, "key")]
[h: value = json.get (prefEntry, "value")]
[h: prompt = json.get (prefEntry, "prompt")]
[h: typeList = "TEXT,LIST,CHECK"]
[h: typeIndex = listFind (typeList, json.get (prefEntry, "type"))]
[h: opts = json.get (prefEntry, "opts")]

[h: inputString = " inputVar | " + variableName + " | Variable Name | Text"]
[h: inputString = inputString + "## inputValue | " + value + " | Default Value or List values | Text"]
[h: inputString = inputString + "## inputPrompt | " + prompt + " | Prompt Text | Text"]
[h: inputString = inputString + "## inputType | " + typeList + " | Type | List | value=string select=" + typeIndex]
[h: inputString = inputString + "## inputOpts | " + opts + " | Options | Text "]

[h: macro.return = inputString]