[h, if (json.length (macro.args) > 0): secondary = arg (0); secondary = "{}"]
[h: userPref = dnd5e_Preferences_getUserPreferences ()]
[h, if (encode (userPref) == ""): userPref = "{}"; ""]
[h: selectedValues = dnd5e_Preferences_promptMacroInput (userPref, secondary)]
[h: log.debug ("selectedvalues: " + json.indent (selectedValues))]
<!-- so the magic here is to take the variables specied by the inputString and apply
	them to the target preference object. That princess is in another castle -->

<!-- use the results to configure the preferences on the token preferences -->
<!-- no need to merge, the selectedValues is what was selected -->
[h: dnd5e_Preferences_setUserPreferences (selectedValues)]