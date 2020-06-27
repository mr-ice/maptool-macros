[h: SKIP_PROMPT = 1]

[h: charId = getProperty ("Character ID")]

[h, if (charId == ""): abort (input ("ignored | Character URL or ID | Input either the full URL to the DNDBeyond character or just the character ID | Label | SPAN=TRUE",
	"charId | | Character URL or ID | TEXT | SPAN=TRUE"))]

[h, if (!SKIP_PROMPT): abort ( input ("ignored | WARNING! This will take an extended amount of time (30 - 60 seconds, or more) and reset any custom values. | All properties will be overwritten! | Label | SPAN=TRUE",
	"confirm | No, Yes | Are you sure you want to do this? | LIST | SELECT=0"));""]
[h, if (!SKIP_PROMPT): abort (confirm); ""]
[h: setProperty ("Character ID", charId)]

[h: basicToon = dndb_buildBasicToon (charId)]

[h: setProperty ("dndb_BasicToon", basicToon)]

[h, macro ("Reset Properties@this"): "1"]
[h: msg = json.get (basicToon, "name") + " has been initialized!"]
[h: log.info (msg)]
[r,s: msg]