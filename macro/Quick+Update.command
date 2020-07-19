[h: tokenId = getSelected()]
[h: log.debug ("tokenId: " + tokenId)]
[h, token (tokenId): charId = getProperty ("Character ID")]
<!-- This script must deal with the raw Basic Toon, avoid dndb_getBasicToon -->
[h, token (tokenId): basicToon = dndb_getBasicToon ()]
[h, token (tokenId): dndb_migrateAttackJSON ()]

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

[h, token (tokenId): setProperty ("dndb_BasicToon", basicToon)]
[h, macro ("Reset Properties@this"): 1]

[r,s, token (tokenId): json.get (basicToon, "name") + " has been updated!"]