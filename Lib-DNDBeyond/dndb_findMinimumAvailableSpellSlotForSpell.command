[h: spell = arg (0)]
[h: basicToon = dndb_getBasicToon ()]

[h: availableSpellSlots = dndb_getAvailableSpellSlots() ]
<!-- cant rely on the order. So just hold a candidate until one with a lower
	valid level comes along -->
[h: candidateSpellSlot = "{}"]
[h: candidateSlotLevel = 99]
[h: spellLevel = json.get (spell, "level")]
[h, foreach (availableSpellSlot, availableSpellSlots), code: {
	[h: level = json.get (availableSpellSlot, "level")]
	[h, if (level < candidateSlotLevel && level >= spellLevel), code: {
		[h: candidateSpellSlot = availableSpellSlot]
		[h: candidateSlotLevel = level]
	}]
}]
[h: macro.return = candidateSpellSlot]