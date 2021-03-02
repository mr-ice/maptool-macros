[h: jsonVars = macro.args]
[h: log.debug (getMacroName() + ": macro.args = " + macro.args)]
[h: objIsArray = json.get (jsonVars, "objIsArray")]
[h, if (objIsArray == ""): objIsArray = 0]
[h: field = json.get (jsonVars, "field")]
[h: json = json.get (jsonVars, "json")]
[h: keyIsArray = json.get (jsonVars, "keyIsArray")]
[h: encodedPath = json.get (jsonVars, "encodedPath")]
[h: pathPiece = json.get (jsonVars, "pathPiece")]
[h: operation = json.get (jsonVars, "operation")]
[h: params = json.get (jsonVars, "params")]

[h, if (objIsArray), code: {
	[apos = ""]
}; {
	[apos = "'"]
}]
[h: pathPiece = encodedPath + encode ("[" + apos + field + apos + "]")]
[h, switch (operation), code: 
	case "remove": {
		[json = jse.QnD.json.remove (encodedPath, json, field, objIsArray)]
	};
	case "append": {
		[json = jse.QnD.json.append (pathPiece, json, keyIsArray)]
	};
	case "reOrderUp": {
		[json = jse.QnD.json.reOrder (json, field, encodedPath, 1)]
	};
	case "reOrderDown": {
		[json = jse.QnD.json.reOrder (json, field, encodedPath, 0)]
	};
	case "replace": {
		[json = jse.QnD.json.replace (encodedPath, json, field, objIsArray)]
	};
	case "rootAdd": {
		[json = jse.QnD.json.rootAdd (json)]
	};
	
	default: {
		[assert (0, "Invalid operation: " + operation)]		
	}
]
[h: params = json.set (params, "object", json)]
[ macro( "jse.mainDialog.editJSON@this" ): json.set ("['']", 0, params)]