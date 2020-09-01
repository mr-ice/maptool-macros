
[h: macroGroup = "D&D 5e"]

[h: basicCfg = json.set ("", "group", macroGroup,
					"color", "default",
					"fontColor", "default",
					"autoExecute", 1,
					"applyToSelected", 1,
					"playerEditable", 1,
					"fontSize", "1.05em")]

[h: macroCfgs = json.append ("", 
			json.set (basicCfg, "name", "Attack Editor",
					"color", "red",
					"fontColor", "white",
					"minWidth", 170,
					"group", macroGroup + " - Attacks",
					"sortBy", "-1",
					"command", "[macro('Attack Editor@Lib:DnD5e'): '']"),
					
			json.set (basicCfg, "name", "Saving Throw",
					"color", "black",
					"fontColor", "yellow",
					"sortBy", "-1",
					"minWidth", 170,
					"group", macroGroup + " - Saves",
					"command", "[macro('Saving Throw@Lib:DnD5e'): '']"),

			json.set (basicCfg, "name", "Skill Check",
					"color", "blue",
					"fontColor", "white",
					"sortBy", "-1",
					"minWidth", 170,
					"group",  macroGroup + " - Skills",
					"command", "[macro('Skill Check@Lib:DnD5e'): '']"),
					
			json.set (basicCfg, "name", "<html><b><u><i>I'm Done</i></u></b></html>",
					"group", "",
					"color", "red",
					"fontColor", "white",
					"sortBy", "1",
					"group",  macroGroup + " - Initiative",
					"fontSize", "1.50em",
					"command", "[h, macro('dnd5e_done@Lib:DnD5e'): '']"),
					
			json.set (basicCfg, "name", "Damage",
					"group",  macroGroup + " - Health",
					"color", "red",
					"fontColor", "white",
					"sortBy", "1",
					"command", "[h, macro('dnd5e_takeDamage@Lib:DnD5e'): '']"),	
									
			json.set (basicCfg, "name", "Heal",
					"group",  macroGroup + " - Health",
					"color", "red",
					"fontColor", "white",
					"sortBy", "2",
					"command", "[h, macro('dnd5e_takeHealing@Lib:DnD5e'): '']"),
					
			json.set (basicCfg, "name", "Conditions",
					"group",  macroGroup + " - Health",
					"color", "yellow",
					"fontColor", "black",
					"sortBy", "4",
					"command", "[h, macro('dnd5e_Conditions@Lib:DnD5e'): '']"),
					
			json.set (basicCfg, "name", "Death Save",
					"group",  macroGroup + " - Health",
					"color", "black",
					"fontColor", "red",
					"sortBy", "5",
					"command", "[h, macro('dnd5e_deathSaves@Lib:DnD5e'): '']"),
					
			json.set (basicCfg, "name", "Temp HP",
					"group",  macroGroup + " - Health",
					"color", "red",
					"fontColor", "white",
					"sortBy", "3",
					"command", "[h, macro('dnd5e_takeTemp@Lib:DnD5e'): '']"),

			json.set (basicCfg, "name", "Action Editor",
					"group",  macroGroup + " - Actions",
					"color", "white",
					"fontColor", "navy",
					"sortBy", "0",
					"command", "[h, macro('dnd5e_AE2_attackEditor@Lib:DnD5e'): '']"),

			json.set (basicCfg, "name", "Configure Preferences",
					"color", "green",
					"fontColor", "black",
					"sortBy", "150",
					"command", "[macro('Configure Preferences@Lib:DnD5e'): '']")
)]
					
[h, foreach (macroCfg, macroCfgs), code: {
	[h: macroName = json.get (macroCfg, "name")]
	[h: currentIndexes = getMacroIndexes(macroName)]
	[h, if (currentIndexes == ""), code: {
		[h: createMacro (macroName, json.get (macroCfg, "command"), macroCfg)]
	}; {}]
}]
