[h: DATA_MACRO = arg(0)]
[h: registry = arg (1)]

[h: macroIndex = json.get (getMacroIndexes (DATA_MACRO, "json"), 0)]
[h: command = "[h: macro.return = '" + encode (registry) + "']"]
[h: setMacroCommand (macroIndex, command)]