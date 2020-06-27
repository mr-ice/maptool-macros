[h: basicToon = arg (0)]
[h: toonName = arg (1)]

[h: macroName = "data_BasicToon_" + toonName]
[h: macroIndexes = getMacroIndexes (macroName)]
[h, foreach (macroIndex, macroIndexes): removeMacro (macroIndex)]
[h: commandValue = base64.encode (basicToon)]
[h: createMacro (macroName, commandValue, json.set ("", "group", "Data"))]
