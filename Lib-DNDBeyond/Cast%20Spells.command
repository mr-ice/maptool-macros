[h, if (json.length (macro.args) > 0): inputObj = arg (0); inputObj = ""]
[h: basicToon = getProperty ("dndb_BasicToon")]
[h, if (encode (basicToon) == ""), code: {
	[h: error = "You must initialize with DNDBeyond first"]
	[h: abort (input ( " junk | | " + error + " | LABEL | TEXT=false"))]
	[h: return (0, error)]
}]

<!-- Display a list of spells to chose -->

[h: concentrationSpells = "{}"]
[h: concentrationSpellsInput = ""]
[h: ritualSpells = "{}"]
[h: ritualSpellsInput = ""]
[h: otherSpells = "{}"]
[h: otherSpellsInput = ""]

[h: spellSlots = json.get (basicToon, "spellSlots")]
[h: spellSlotInput = ""]
[h: availableSpellSlots = "[]"]
[h, foreach (spellSlot, spellSlots), code : {
	[h: available = json.get (spellSlot, "available")]
	[h: used = json.get (spellSlot, "used")]
	[h: level = json.get (spellSlot, "level")]
	[h: remaining = available - used]
	[h, if (remaining > 0 && available > 0), code: {
		[h: spellSlotInput = spellSlotInput + "," + level]
		[h: availableSpellSlots = json.append (availableSpellSlots, spellSlot)]
	}]
}]

[h: spellSlotInput = "Minimum allowed" + spellSlotInput]
[h: castableRitualSpells = dndb_getCastableSpells(1)]
[h: spells = dndb_getCastableSpells()]
[h, foreach (spell, castableRitualSpells), code: {
	[h: name = json.get (spell, "name")]
	[h: ritualSpells = json.set (ritualSpells, name, spell)]
}]

[h, foreach (spell, spells), code: {
	[h: isConcentration = json.get (spell, "concentration")]
	[h: name = json.get (spell, "name")]
	[h, if (isConcentration == "true"): concentrationSpells = json.set (
										concentrationSpells, name, spell);
										otherSpells = json.set ( otherSpells, name, spell)]
}]
[h: sorted = json.sort (json.fromList (json.fields (concentrationSpells)))]
[h, foreach (spellName, sorted), code: {
	[h: concentrationSpellsInput = concentrationSpellsInput + "," + spellName]
}]
[h: concentrationSpellsInput = "None" + concentrationSpellsInput]

[h: sorted = json.sort (json.fromList (json.fields (ritualSpells)))]
[h, foreach (spellName, sorted), code: {
	[h: ritualSpellsInput = ritualSpellsInput + "," + spellName]
}]
[h: ritualSpellsInput = "None" + ritualSpellsInput]

[h: sorted = json.sort (json.fromList (json.fields (otherSpells)))]
[h, foreach (spellName, sorted), code: {
	[h: otherSpellsInput = otherSpellsInput + "," + spellName]
}]
[h: otherSpellsInput = "None" + otherSpellsInput]

[h: abort (input ("concentrationSpell | "  + concentrationSpellsInput + "| Concentration Spells | List | value=string",
	"ritualSpell | " + ritualSpellsInput + " | Ritual Spells | List | value=string",
	"otherSpell | " + otherSpellsInput + " | Spells | List | value=string",
	"spellSlot | " + spellSlotInput + " | Spend Spell Slot | List"))]