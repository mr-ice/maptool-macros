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

[h: spellSlotInput = "Minimum Allowed" + spellSlotInput]
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

[h: validChoice = 0]
[h, while (!validChoice), code: {
	<!-- start as valid and invalidate as we go -->
	[h: validChoice = 1]
	[h: abort (input ("concentrationSpell | "  + concentrationSpellsInput + 
		"| Concentration Spells | List | value=string",
		"ritualSpell | " + ritualSpellsInput + " | Ritual Spells | List | value=string",
		"otherSpell | " + otherSpellsInput + " | Spells | List | value=string",
		"spellSlot | " + spellSlotInput + " | Spend Spell Slot | List | value=string"))]

	<!-- A valid choice is:
		- One spell selected
		- and either a default minimum or eligible spell slot selected -->
	[h: selectedSpell = ""]
	[h, if (concentrationSpell != "None" && ritualSpell == "None" && otherSpell == "None"): 
			selectedSpell = json.get (concentrationSpells, concentrationSpell); ""]
	[h, if (concentrationSpell == "None" && ritualSpell != "None" && otherSpell == "None"): 
			selectedSpell = json.get (ritualSpells, ritualSpell); ""]
	[h, if (concentrationSpell == "None" && ritualSpell == "None" && otherSpell != "None"): 
			selectedSpell = json.get (otherSpells, otherSpell); ""]

	[h, if (encode (selectedSpell) == ""), code: {
		[h: input ("junk | Exactly one spell must be selected. |  | Label | span=true")]
		<!-- Use a stub spell for the next part -->
		[h: selectedSpell = json.set ("", "level", 0)]
		[h: validChoice = 0]
	}; {""}]

	[h: spellLevel = json.get (selectedSpell, "level")]
	[h: selectedSpellSlot = ""]
	[h, if (isNumber (spellSlot)): spellSlotNum = number (spellSlot); spellSlotNum = -1]
	[h, foreach (candidateSlot, spellSlots), code: {
		[h: slotLevel = json.get (candidateSlot, "level")]
		[h, if (spellSlot == "Minimum Allowed"): minimumSelected = 1; minimumSelected = 0]
		[h, if (slotLevel >= spellLevel || spellSlotNum >= spelllevel): slotLevelIsValid = 1; slotLevelIsValid = 0]
		[h: log.debug ("spellSlot: " + spellSlot + "; slotLevel: " + slotLevel + "; spellLevel: " + spellLevel + "; selectedSpellSlot: " + selectedSpellSlot +
			"; minimumSelected: " + minimumSelected + "; slotLevelIsValid: " + slotLevelIsValid)]
		[h, if (minimumSelected && slotLevelIsValid && encode (selectedSpellSlot) == ""): selectedSpellSlot = candidateSlot; ""]
		[h, if (!minimumSelected && slotLevelIsValid && encode (selectedSpellSlot) == ""): selectedSpellSlot = candidateSlot; ""]
	}]

	[h, if (validChoice == 1 && encode (selectedSpellSlot) == ""), code: {
		[h: validChoice = 0]
		[h: input ("junk | Invalid spell slot selected | | Label | span=true")]
	};{""}]

	[h: log.debug ("Selected Spell: " + selectedSpell)]
	[h: log.debug ("Selected Slot: " + selectedSpellSlot)]
}]