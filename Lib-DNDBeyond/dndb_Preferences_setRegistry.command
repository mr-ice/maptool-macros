[h: registry = arg (0)]
[h: DATA_MACRO = "Data_Preference_Registry"]

<!-- TODO: write a unit test to ensure only one of these exists on the library token -->
[h: macroIndex = json.get (getMacroIndexes (DATA_MACRO, "json"), 0)]
[h: command = "[h: macro.return = '" + encode (registry) + "']"]
[h: setMacroCommand (macroIndex, command)]