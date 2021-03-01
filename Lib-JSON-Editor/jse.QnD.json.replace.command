[h: log.debug (getMacroName() + ": macro.args = " + macro.args)]
[h: encodedPath = arg (0)]
[h: jsonVal = arg (1)]
[h: key = arg (2)]
[h: isArray = arg (3)]

[h, if (isArray): apos = ""; apos = "'"]

[h, if (encodedPath == ""), code: {
	<!-- root -->
	[oldVal = json.get (jsonVal, key)]
	[inputMsg = strformat( "newVal | %s | %s", oldVal, "New value of parameter" ) +
		"##" + strformat( "deleteChecked | 0 | %s | CHECK", "Delete parameter?" )]
	[abort (input(inputMsg))]
	[if (deleteChecked): jsonVal = json.remove (jsonVal, key);
		jsonVal = json.set (jsonVal, key, newVal)] 
}; {
	<!-- inner -->
	[path = decode (encodedPath)]
	[fullPath = path + "[" + apos + key + apos + "]"]
	[oldVal = json.path.read (jsonVal, fullPath)]
	[inputMsg = strformat( "newVal | %s | %s", oldVal, "New value of parameter" ) +
		"##" + strformat( "deleteChecked | 0 | %s | CHECK", "Delete parameter?" )]
	[abort (input(inputMsg))]
	[if( deleteChecked ), code: {
		[jsonVal = json.path.delete (jsonVal, fullPath)] 
	}; {
		[if (isArray): jsonVal = json.path.set (jsonVal, fullPath, newVal);
					   jsonVal = json.path.put (jsonVal, path, key, newVal)]
	}]
}]

[h: macro.return = jsonVal]