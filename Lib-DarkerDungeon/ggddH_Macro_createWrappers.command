[h: basicCfg = json.set ("{}", "group", "Darker Dungeons",
					"color", "green",
					"fontColor", "white",
					"autoExecute", 1,
					"applyToSelected", 1,
					"playerEditable", 1,
					"fontSize", "1.05em",
					"sortBy", "1",
					"minWidth", 170)]
[h: healingButtons = json.append ("", "Lesser", "Greater", "Superior", "Supreme")]
[h: usableButtons = json.append ("", "<html><b>Manage Usables</b></html>")]
[h: macroMap = json.set ("", "Healing", healingButtons, "Usage", usableButtons)]
[h, foreach (fieldName, json.fields (macroMap, "json")), code: {
	[group = json.get (basicCfg, "group") + " - " + fieldName]
	[macroCfg = json.set (basicCfg, "group", group)]
	[buttons = json.get (macroMap, fieldName)]
	[foreach (button, buttons), code: {
		[command = "[r, macro ('" + button + "@Campaign'):'']"]
		[existingIndexes = getMacroIndexes (button, "json")]
		[log.debug (getMacroName() + "## " + fieldName + "::" + button + ":: existingIndexes = " + existingIndexes)]
		[if (json.length (existingIndexes) == 0):
			createMacro (button, command, macroCfg)]
	}]
}]