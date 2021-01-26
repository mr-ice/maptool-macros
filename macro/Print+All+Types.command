

[h, token("Lib:DnD5e"), code: {
	[macroList = getMacros()]
	[libTokenId = currentToken()]
}]
[h: types = "[]"]
[h: macroNames = "[]"]
[h, foreach (macroName, macroList), code: {
	[if (startsWith (macroName, "dnd5e_Type_")), code: {
		[log.debug ("macroName = ::" + macroName + "::")]
		[indexes = getMacroIndexes (macroName, "json", libTokenId)]
		[log.debug ("indexes = " + indexes)]
		[index = json.get (indexes, 0)]
		[macroProps = getMacroProps (index, "json", libTokenId)]
		[panelName = json.get (macroProps, "group")]
		[if (panelName == "RollExpression - Prototypes"): macroNames = json.append (macroNames, macroName); ""]
	}; {}]
}]

[h, foreach (macroName, macroNames), code: {
		[macro (macroName + "@Lib:DnD5e"): ""]
		[type = macro.return]
		[types = json.append (types, type)]
}]
<pre>[r: json.indent (types)]</pre>
[h: rollers = dnd5e_RollExpression_getDiceRollers (json.set ("", "types", types))]
<pre>[r: json.indent (rollers)]</pre>