[h: charId = getProperty ("Character ID")]
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

[h: basicToon = json.set (basicToon, 
				"speeds", speeds,
				"hitPoints", hitPoints,
				"armorClass", ac)]

[h: setProperty ("dndb_BasicToon", basicToon)]
[h, macro ("Reset Properties@this"): 1]
[r,s: json.get (basicToon, "name") + " has been updated!"]