[h: macroGroup = "D&D Beyond"]

[h: basicCfg = json.set ("", "group", macroGroup,
					"color", "default",
					"fontColor", "default",
					"autoExecute", 1,
					"applyToSelected", 1,
					"playerEditable", 1,
					"fontSize", "1.05em")]

[h: macroCfgs = json.append ("", 

					
			json.set (basicCfg, "name", "Spend Hit Dice",
					"color", "purple",
					"fontColor", "white",
					"sortBy", "30",
					"command", "[macro('Spend Hit Dice@Lib:DnDBeyond'): '']"),

			json.set (basicCfg, "name", "Quick Update",
					"color", "orange",
					"fontColor", "blaick",
					"sortBy", "120",
					"command", "[macro('Quick Update@CAMPAIGN'): '']"),

			json.set (basicCfg, "name", "Cast Spells",
					"color", "teal",
					"fontColor", "white",
					"sortBy", "2",
					"command", "[macro('Cast Spells@Lib:DnDBeyond'): '']"),

			json.set (basicCfg, "name", "Configure Preferences",
					"color", "green",
					"fontColor", "black",
					"sortBy", "150",
					"command", "[macro('Configure Preferences@Lib:DnDBeyond'): '']")
)]
					
[h, foreach (macroCfg, macroCfgs), code: {
	[h: macroName = json.get (macroCfg, "name")]
	[h: currentIndexes = getMacroIndexes(macroName)]
	[h, if (currentIndexes == ""), code: {
		[h: createMacro (macroName, json.get (macroCfg, "command"), macroCfg)]
	}; {}]
}]

[h: dnd5e_Macro_createPlayerMacros (1)]