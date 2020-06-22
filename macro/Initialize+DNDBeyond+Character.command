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

<!-- slim down -->
[h: data = json.get (toon, "data")]
[h: dataRetains = json.append ("", "race", "modifiers", "inventory", "classes", "stats", "bonusStats", "overrideStats", "characterValues")]
[h: skinnyData = dndb_getSkinnyObject (data, dataRetains)]
<!-- Skinnify the toon -->
[h: fatToon = toon]
[h: btoon = json.set (toon, "data", skinnyData)]


[h: log.info ("dndb_getBasic: Initiative")]
[h: initiative = dndb_getInitiative (toon)]
[h: basicToon = json.set (basicToon, "init", initiative)]

[h: log.info ("Building Armor Class")]
[h: basicToon = json.set (basicToon, "armorClass", dndb_getAC (toon))]

[h: log.info ("Building Saving Throws")]
[h: basicToon = json.set (basicToon, "savingThrows", dndb_getSavingThrow (toon))]

[h: log.info ("Building Skills")]
[h: basicToon = json.set (basicToon, "skills", dndb_getSkill (toon))]

[h: log.info ("Building Attacks")]
[h: basicToon = json.set (basicToon, "attacks", dndb_getAttack (toon))]

[h: log.info ("Building Conditions")]
[h: basicToon = json.set (basicToon, "conditions", dndb_getConditions (toon))]

[h: setProperty ("dndb_BasicToon", basicToon)]

[h, macro ("Reset Properties@this"): "1"]
[h: msg = json.get (basicToon, "name") + " has been initialized!"]
[h: log.info (msg)]
[r,s: msg]