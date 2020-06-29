[h: allProperties = getAllPropertyNames ("Basic", "json")]
[h, foreach (property, allProperties), code: {
	[h, if (property != "Character ID"), code: {
		[h: setProperty (property, getPropertyDefault(property))]
	};{""}]
}]
[h: setProperty ("dndb_BasicToon", "")]
[h: macroIndexes = getMacroGroup ("D&D Beyond")]
[h, foreach (macroIndex, macroIndexes): removeMacro (macroIndex)]
[h, foreach(stateName, getTokenStates()): setState(stateName, 0)]
[h: bars = "[HP,Damage,ElevationPositive,ElevationNegative,DSPass,DSFail]"]
[h, foreach (bar, bars): setBarVisible (bar, 0)]