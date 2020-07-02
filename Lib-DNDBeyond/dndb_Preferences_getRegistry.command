[h, if (json.length (macro.args) > 0): fullReg = arg (0); fullReg = 0]
[h: DATA_MACRO = "Data_Preference_Registry"]
[h, macro (DATA_MACRO + "@Lib:DnDBeyond"): ""]
[h: regObj = macro.return]
[h, if (regObj == ""): registry = "{}"; registry = decode (regObj)]
[h, if (fullReg), code: {
	[h: dndReg = dnd5e_Preferences_getRegistry ()]
	<!-- merge the dnd Beyond into the 5e version -->
	[h: registry = json.merge (dndReg, registry)]
}; {""}]

[h: macro.return = registry]