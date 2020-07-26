[h: log.debug (getMacroName() + ": args = " + macro.args)]
[h: macroName = arg (0)]
[h: command = arg (1)]
[h: cmdArg = arg (2)]
[h: macroConfig = arg (3)]

[h: sortByBase = json.get (macroConfig, "sortBy")]

[cmd = "[macro ('" + command + "'): '" + cmdArg + "']"]
[createMacro (macroName, cmd, macroConfig)]

[macroConfig = json.set (macroConfig, 
						"sortBy", sortByBase + "-1",
						"minWidth", 12)]
						
[cmdArg = json.set (cmdArg, "advDisadv", "advantage")]
[cmd = "[macro ('" + command + "'): '" + cmdArg + "']"]
[label = dnd5e_Macro_getModLabel ("advantage")]
[createMacro (label, cmd, macroConfig)]
[macroConfig = json.set (macroConfig, "sortBy", sortByBase + "-2")]
[cmdArg = json.set (cmdArg, "advDisadv", "Disadvantage")]
[cmd = "[macro ('" + command + "'): '" + cmdArg + "']"]
[label = dnd5e_Macro_getModLabel ("disadvantage")]
[createMacro (label, cmd, macroConfig)]
[macroConfig = json.set (macroConfig, "sortBy", sortByBase + "-3", "minWidth", 28)]
[cmdArg = json.set (cmdArg, "advDisadv", "Both")]
[cmd = "[macro ('" + command + "'): '" + cmdArg + "']"]
[label = dnd5e_Macro_getModLabel ("both")]
[createMacro (label, cmd, macroConfig)]
