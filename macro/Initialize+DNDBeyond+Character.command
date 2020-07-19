[h: tokenId = getSelected()]
[h: log.debug ("tokenId: " + tokenId)]
[h, token (tokenId): SKIP_PROMPT = dnd5e_Preferences_getPreference ("suppressInitPrompt")]
[h, if (SKIP_PROMPT == ""): SKIP_PROMPT = 0; ""]
[h, token (tokenId): charId = getProperty ("Character ID")]
[h: updatePref = 0]
[h, if (charId == ""): abort (input ("ignored | Character URL or ID | Input either the full URL to the DNDBeyond character or just the character ID | Label | SPAN=TRUE",
	"charId | | Character URL or ID | TEXT | SPAN=TRUE")); ""]

[h, if (!SKIP_PROMPT): abort ( input ("ignored | WARNING! This will take an extended amount of time (30 - 60 seconds, or more) and reset any custom values. | All properties will be overwritten! | Label | SPAN=TRUE",
	"confirm | No, Yes | Are you sure you want to do this? | LIST | SELECT=0",
	"updatePref | 0 | Don't prompt again? | CHECK"));""]
[h, if (!SKIP_PROMPT): abort (confirm); ""]
[h, token (tokenId), if (updatePref): dnd5e_Preferences_setPreference ("suppressInitPrompt", 1); ""]

[h, token (tokenId): dndb_migrateAttackJSON ()]

[h, token (tokenId): setProperty ("Character ID", charId)]

[h: basicToon = dndb_buildBasicToon (charId)]

[h, token (tokenId): setProperty ("dndb_BasicToon", basicToon)]
[h, token (tokenId): setName (json.get(basicToon, "name"))]
[h, token (tokenId): setPC ()]

[h, macro ("Reset Properties@this"): "1"]
[h: msg = json.get (basicToon, "name") + " has been initialized!"]
[h: log.info (msg)]
[r,s: msg]
