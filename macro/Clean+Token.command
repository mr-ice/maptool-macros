[h: allProperties = getAllPropertyNames ("Basic", "json")]
[h, foreach (property, allProperties), code: {
	[h, if (property != "Character ID"), code: {
		[h: setProperty (property, getPropertyDefault(property))]
	};{""}]
}]
[h: setProperty ("dndb_BasicToon", "")]
[h: macroGroups = json.append ("[]", "D&D Beyond", "D&D 5e - Attacks", 
                "D&D 5e - Health", "D&D 5e - Actions",
				"D&D 5e - Initiative", "D&D 5e - Saves", "D&D 5e - Skills")]
[h, foreach (macroGroup, macroGroups, ""), code: {
	[macroIndexes = getMacroGroup (macroGroup)]
	[foreach (macroIndex, macroIndexes): removeMacro (macroIndex)]	
}]

[h, foreach(stateName, getTokenStates()): setState(stateName, 0)]
[h: bars = "[HP,Damage,ElevationPositive,ElevationNegative,DSPass,DSFail]"]
[h, foreach (bar, bars): setBarVisible (bar, 0)]