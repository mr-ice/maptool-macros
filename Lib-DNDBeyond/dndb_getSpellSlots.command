[h: toon = arg (0)]

[h: data = json.get (toon, "data")]
[h: dataRetains = json.append ("", "modifiers", "inventory", "classes", "stats", "bonusStats", "overrideStats", "spellSlots", "spells", "classSpells")]
[h: skinnyData = dndb_getSkinnyObject (data, dataRetains)]
<!-- Skinnify the toon -->
[h: fatToon = toon]
[h: toon = json.set (toon, "data", skinnyData)]

<!-- This is Spell Slots -->

<!-- IF we have a single spell-casting class, the work is done: just grab
	classes.definition.spellRules.levelSpellSlots and Jerrys your uncle.
	BUT, if we have multiple spell classes, forget the noise and read 
	classes.definition.spellRules.multiClassSpellSlotDivisor and divide
	it with classes.definition.level. Add those together and confer with
	the multiclass spell table, which well define as a constant map. -->

<!-- Build it like its represented in toon json -->
[h: MULTI_CLASS_SPELL_SLOT_TABLE = "[[0,0,0,0,0,0,0,0,0],[2,0,0,0,0,0,0,0,0],[3,0,0,0,0,0,0,0,0],[4,2,0,0,0,0,0,0,0],[4,3,0,0,0,0,0,0,0],[4,3,2,0,0,0,0,0,0],[4,3,3,0,0,0,0,0,0],[4,3,3,1,0,0,0,0,0],[4,3,3,2,0,0,0,0,0],[4,3,3,3,1,0,0,0,0],[4,3,3,3,2,0,0,0,0],[4,3,3,3,2,1,0,0,0],[4,3,3,3,2,1,0,0,0],[4,3,3,3,2,1,1,0,0],[4,3,3,3,2,1,1,0,0],[4,3,3,3,2,1,1,1,0],[4,3,3,3,2,1,1,1,0],[4,3,3,3,2,1,1,1,1],[4,3,3,3,3,1,1,1,1],[4,3,3,3,3,2,1,1,1],[4,3,3,3,3,2,2,1,1]]"]

[h: classes = json.path.read (toon, "data.classes")]
[h, if (json.length (classes) > 1): multiClass = 1; multiClass = 0]
[h: totalLevel = 0]

[h, foreach (class, classes), code: {
	[h: classDefinition = json.get (class, "definition")]
	[h: level = number (json.get (class, "level"))]
	[h: canCastSpells = json.get (classDefinition, "canCastSpells")]
	[h: log.debug ("Class level: " + level + "; canCastSpells: " + canCastSpells)]
	[h, if (canCastSpells != "true"): canCastSpells = json.path.read (class, "subclassDefinition.canCastSpells", "SUPPRESS_EXCEPTIONS"); ""]
	<!-- fucking monk check -->
	[h: spellCastingAbilityId = json.path.read (class, "subclassDefinition.spellCastingAbilityId", "SUPPRESS_EXCEPTIONS")]
	[h, if (canCastSpells != "true" && isNumber (spellCastingAbilityId)): canCastSpells = "true"; ""]
	[h: log.debug ("dndb_getSpellSlots: canCastSpells = " + canCastSpells)]
	[h: deMultiplier = number (json.path.read (classDefinition, "spellRules.multiClassSpellSlotDivisor"))]
	[h: spellSlotTables = json.path.read (classDefinition, "spellRules.levelSpellSlots")]

	[h, if (multiClass > 0), code: {
		[h: level = round (math.floor (level / deMultiplier))]
		[h: spellSlotTables = MULTI_CLASS_SPELL_SLOT_TABLE]
	}; {""}]
	
	[h, if (canCastSpells == "true"): totalLevel = totalLevel + level; ""]
}]
<!-- set the spell slot data based on the appropriate level --->
[h: spellSlotData = json.get (spellSlotTables, totalLevel)]
<!-- that was to get our total spell slots. Now to read whats been used -->
[h: spellSlots = json.path.read (toon, "data.spellSlots")]

[h: retSpellSlots = "[]"]
[h: idx = 0]
[h, foreach (spellSlot, spellSlots), code: {
	[h: available = json.get (spellSlotData, idx)]
	[h: spellSlot = json.set (spellSlot, "available", available)]
	[h: retSpellSlots = json.append (retSpellSlots, spellSlot)]
	[h: idx = idx + 1]
}]

<!-- give the toon cantrips via 0-level spellSlot -->
[h: cantrips = json.append ("", json.set ("", "available", 99, "level", 0, "used", 0))]
[h: retSpellSlots = json.merge (cantrips, retSpellSlots)]
[h: log.debug ("dndb_getSpellSlots: selected spell slots = " + retSpellSlots)]
<!-- done -->
[h: macro.return = retSpellSlots]