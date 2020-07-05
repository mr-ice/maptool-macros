[h: macroGroup = "D&D Beyond"]

[h: basicCfg = json.set ("", "group", macroGroup,
					"color", "default",
					"fontColor", "default",
					"autoExecute", 1,
					"applyToSelected", 1,
					"playerEditable", 0,
					"fontSize", "1.05em")]

[h: macroCfgs = json.append ("", 
			json.set (basicCfg, "name", "Make Attack",
					"color", "red",
					"fontColor", "black",
					"sortBy", "1",
					"command", "[macro('Make Attack@Lib:DnDBeyond'): '']"),

			json.set (basicCfg, "name", "Attack Config",
					"color", "green",
					"fontColor", "black",
					"sortBy", "2",
					"command", "[macro('Attack Config@Lib:DnDBeyond'): '']"),

			json.set (basicCfg, "name", "Saving Throw",
					"color", "black",
					"fontColor", "yellow",
					"sortBy", "10",
					"command", "[macro('Saving Throw@Lib:DnDBeyond'): '']"),

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
					"command", "[macro('Configure Preferences@Lib:DnDBeyond'): '']"),

			json.set (basicCfg, "name", "Skill Check",
					"color", "blue",
					"fontColor", "white",
					"sortBy", "20",
					"command", "[macro('Skill Check@Lib:DnDBeyond'): '']"),
					
			json.set (basicCfg, "name", "Damage",
					"group", "D&D 5e Health",
					"color", "red",
					"fontColor", "white",
					"sortBy", "1",
					"command", "[h, macro('dnd5e_takeDamage@Lib:DnD5e'): '']"),	
									
			json.set (basicCfg, "name", "Heal",
					"group", "D&D 5e Health",
					"color", "red",
					"fontColor", "white",
					"sortBy", "2",
					"command", "[h, macro('dnd5e_takeHealing@Lib:DnD5e'): '']"),
					
			json.set (basicCfg, "name", "Temp HP",
					"group", "D&D 5e Health",
					"color", "red",
					"fontColor", "white",
					"sortBy", "3",
					"command", "[h, macro('dnd5e_takeTemp@Lib:DnD5e'): '']")
)]
					
[h, foreach (macroCfg, macroCfgs), code: {
	[h: macroName = json.get (macroCfg, "name")]
	[h: currentIndexes = getMacroIndexes(macroName)]
	[h, if (currentIndexes == ""), code: {
		[h: createMacro (macroName, json.get (macroCfg, "command"), macroCfg)]
	}; {}]
}]