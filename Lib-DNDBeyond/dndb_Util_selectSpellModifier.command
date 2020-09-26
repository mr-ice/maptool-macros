[h: spell = arg (0)]
[h: restriction = arg (1)]

[h: modifiers = json.get (spell, "modifiers")]
<!-- default is no modifier -->
[h: modifier = "{}"]


[h, if (restriction != "" && restriction != "None"), code: {
	<!-- We were given a restriction; Find the modifier that matches the restriction -->
	[restrictedModifier = json.path.read (spell, ".[?(@.restriction == '" + decode (restriction) + "')]")]
	[if (!json.isEmpty (restrictedModifier)): modifier = json.get (restrictedModifier, 0); ""]
}; {
	<!-- We were not given a restriction; pass the first modifier in the list -->	
	[if (json.type (modifiers) == "ARRAY" && json.length (modifiers) > 0): 
			modifier = json.get (modifiers, 0); ""]
}]

[h: log.debug (getMacroName() + ": selected modifier = " + modifier)]
[h: macro.return = modifier]