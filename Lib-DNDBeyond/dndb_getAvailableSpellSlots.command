[h: basicToon = dndb_getBasicToon()]

[h: spellSlots = json.get (basicToon, "spellSlots")]
[h: availableSpellSlots = "[]"]
[h, foreach (spellSlot, spellSlots), code : {
	[h: available = json.get (spellSlot, "available")]
	[h: used = json.get (spellSlot, "used")]
	[h: level = json.get (spellSlot, "level")]
	[h: remaining = available - used]
	[h, if (remaining > 0 && available > 0), code: {

		[h: availableSpellSlots = json.append (availableSpellSlots, spellSlot)]
	}]
}]
[h: macro.return = availableSpellSlots]