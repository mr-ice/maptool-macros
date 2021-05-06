[h: name = arg(0)]
[h: die = arg(1)]
[h: id = arg(2)]
[h, if (argCount() > 3): doCampaignWrappers = arg(3); doCampaignWrappers = 0]

[h: searchName = "<html><b>" + name + " @ "]
[h: macros = getMacroGroup("Darker Dungeons - Useables", "json", id)]
[h: editIndex = -1]
[h, foreach(i, macros), code: {
	[h: macroProps = getMacroProps(i, "json", id)]
	[h: macroName = json.get(macroProps, "label")]
	[h, if (startsWith(macroName, searchName)): editIndex = i]
}]
[h, if (editIndex == -1), code: {
	[h: basicCfg = json.set ("{}", "group", "Darker Dungeons - Useables",
					"color", "white",
					"fontColor", "green",
					"autoExecute", 1,
					"applyToSelected", 1,
					"playerEditable", 1,
					"fontSize", "1.05em",
					"sortBy", "1",
					"minWidth", 170)]
	[h: dieText = if (die == 0, " Empty", " d" + die)]
	[h: createMacro(searchName + dieText + "</b></html>", "[r: ggddH_Usage_use('" + name + "')]", basicCfg, "json", id)]
}; {
	[h: macroProps = getMacroProps(editIndex, "json", id)]
	[h: dieText = if (die == 0, " <span color=red>Empty</span>", " d" + die)]
	[h: macroProps = json.set(macroProps, "label", searchName + dieText + "</b></html>")]
	[h: setMacroProps(editIndex, macroProps, "json", id)]
}]

[h, if (doCampaignWrappers), code: {
	[ggddH_Macro_createWrappers()]
}]
