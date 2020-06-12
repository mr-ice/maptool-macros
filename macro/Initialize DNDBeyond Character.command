[h: charId = getProperty ("Character ID")]

[h, if (charId == ""): abort (input ("ignored | Character URL or ID | Input either the full URL to the DNDBeyond character or just the character ID | Label | SPAN=TRUE",
	"charId | | Character URL or ID | TEXT | SPAN=TRUE"))]

[h: abort ( input ("ignored | WARNING! This will take an extended amount of time (30 - 60 seconds, or more) and reset any custom values. | All properties will be overwritten! | Label | SPAN=TRUE",
	"confirm | No, Yes | Are you sure you want to do this? | LIST | SELECT=0"))]
[h: abort (confirm)]
[h: setProperty ("Character ID", charId)]

[h: toon = dndb_getCharJSON (charId)]
[h: name = json.path.read (toon, "data.name")]

[h: log.info ("Building basic character")]
[h: basicToon = dndb_getBasic (toon)]

[h: log.info ("Building Armor Class")]
[h: basicToon = json.set (basicToon, "armorClass", dndb_getAC (toon))]

[h: log.info ("Building Saving Throws")]
[h: basicToon = json.set (basicToon, "savingThrows", dndb_getSavingThrow (toon))]

[h: log.info ("Building Skills")]
[h: basicToon = json.set (basicToon, "skills", dndb_getSkill (toon))]

[h: log.info ("Building Attacks")]
[h: basicToon = json.set (basicToon, "attacks", dndb_getAttackJSON (toon))]

[h: setProperty ("dndb_BasicToon", basicToon)]

[h, macro ("Reset Properties@this"): "1"]
[r,s: json.get (basicToon, "name") + " has been initialized!"]