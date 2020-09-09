[h: log.debug (getMacroName() + ": args = " + macro.args)]
[h: macroName = arg (0)]
[h: command = arg (1)]
[h: cmdArg = arg (2)]
[h: macroConfig = arg (3)]
[h: noAdvDisadvMacros = if(argCount() > 4, arg(4), 0)]
[h: createdMacros = "[]"]
[h: sortByBase = json.get (macroConfig, "sortBy")]

[h: cmd = "[macro ('" + command + "'): '" + cmdArg + "']"]
[h: createMacro (macroName, cmd, macroConfig)]
[h: return(!noAdvDisadvMacros, 0)]
[h: macroConfig = json.set (macroConfig, 
						"sortBy", sortByBase + "-1",
                        "tooltip", "Make the " + macroName + " roll with advantage",
						"minWidth", 12)]
[h: cmdArg = json.set (cmdArg, "advDisadv", "advantage")]
[h: cmd = "[macro ('" + command + "'): '" + cmdArg + "']"]
[h: label = dnd5e_Macro_getModLabel ("advantage")]
[h: createMacro (label, cmd, macroConfig)]
[h: macroConfig = json.set (macroConfig, "sortBy", sortByBase + "-2",
                            "tooltip", "Make the " + macroName + " roll with disadvantage")]
[h: cmdArg = json.set (cmdArg, "advDisadv", "Disadvantage")]
[h: cmd = "[macro ('" + command + "'): '" + cmdArg + "']"]
[h: label = dnd5e_Macro_getModLabel ("disadvantage")]
[h: createMacro (label, cmd, macroConfig)]
[h: macroConfig = json.set (macroConfig, "sortBy", sortByBase + "-3", "minWidth", 28,
                            "tooltip", "Make the " + macroName + " roll with both advantage and disadvantage")]
[h: cmdArg = json.set (cmdArg, "advDisadv", "Both")]
[h: cmd = "[macro ('" + command + "'): '" + cmdArg + "']"]
[h: label = dnd5e_Macro_getModLabel ("both")]
[h: createdMacros = json.append (createdMacros, encode (label))]
[h: macro.return = 3]