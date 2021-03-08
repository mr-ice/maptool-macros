[h: constKey = arg (0)]
[h: constants = json.set ("",
	"PREF_OVERWRITE_NAME", "o5e.preference.overwriteTokenName",
	"PREF_USE_GM_NAME", "o5e.preference.useGMNameField"
)]
[h: macro.return = json.get (constants, constKey)]