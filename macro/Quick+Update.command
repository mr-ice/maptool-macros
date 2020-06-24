[h: charId = getProperty ("Character ID")]
<!-- This script must deal with the raw Basic Toon, avoid dndb_getBasicToon -->
[h: basicToon = getProperty ("dndb_BasicToon")]

[h, if (charId == "" || encode (basicToon) == ""), code: {
	[h: message = "Token needs to be initialized with DNDBeyond first"]
	[h: abort( input( " junkVar | | " + message + " | LABEL | TEXT=false"))]
	[h: return (0, message)]
}]

[h: toon = dndb_getCharJSON (charId)]

<!--HP -->
[h: hitPoints = dndb_getHitPoints (toon)]

<!-- Speed -->
[h: speeds = dndb_getSpeed (toon)]

<!-- AC -->
[h: ac = dndb_getAC (toon)]

<!-- Conditions -->
[h: conditions = dndb_getConditions (toon)]

<!-- Spell Slots -->
[h: spellSlots = dndb_getSpellSlots (toon)]

[h: basicToon = json.set (basicToon, 
				"speeds", speeds,
				"spellSlots", spellSlots,
				"hitPoints", hitPoints,
				"armorClass", ac,
				"conditions", conditions)]

[h: setProperty ("dndb_BasicToon", basicToon)]
[h, macro ("Reset Properties@this"): 1]
[r,s: json.get (basicToon, "name") + " has been updated!"]