[h: spellSlots = arg(0)]
[h: spell = arg(1)]

<!-- Get the spell level and run through the slots. if we find a slot that has a level the same
     or greater than the spells level, set qualified to 1 -->
[h: qualified = 0]
[h: spellLevel = json.get (spell, "level")]
[h, foreach (spellSlot, spellSlots), code: {
	[h: spellSlotLevel = json.get (spellSlot, "level")]
	[h, if (spellSlotLevel >= spellLevel): qualified = 1; qualified]
	<!-- set qualified if it doesnt require a spell slot -->
	[h: usesSpellSlot = json.get (spell, "usesSpellSlot")]
	[h, if (usesSpellSlot == "false"): qualified = 1; ""]
}]

[h: macro.return = qualified]