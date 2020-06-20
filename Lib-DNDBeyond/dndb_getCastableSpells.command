[h, if (json.length (macro.args) > 0): asRitual = arg (0); asRitual = 0]
[h: basicToon = getProperty ("dndb_BasicToon")]
[h, if (encode (basicToon) == ""), code: {
	[h: error = "You must initialize with DNDBeyond first"]
	[h: abort (input ( " junk | | " + error + " | LABEL | TEXT=false"))]
	[h: return (0, error)]
}]

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
	};{""}]
}]
[h: log.debug ("Available spell slots: " + availableSpellSlots)]
[h: castableSpells = "[]"]

[h: spells = json.get (basicToon, "spells")]

[h, foreach (spell, spells), code: {
	[h: log.debug (json.get (spell, "name"))]
	[h, if (asRitual), code: {
		[h: ritual = json.get (spell, "ritual")]
		<!-- Ritual is set to true only if the caster can cast it now as a ritual -->
		<!-- dndb_getSpells made this decision -->
		[h, if (ritual): castableSpells = json.append (castableSpells, spell);""]
	}; {
		[h: mayCastSpell = dndb_hasSpellSlotAvailable (availableSpellSlots, spell)]
		[h: log.debug ("mayCastSpell - from spellSlots: " + mayCastSpell)]
		[h: mustBePrepared = json.get (spell, "mustBePrepared")]
		[h, if (mustBePrepared == ""): mustBePrepared = 0; ""]
		[h: isPrepared = json.get (spell, "prepared")]
		[h, if (mustBePrepared > 0 && isPrepared != "true"): mayCastSpell = 0; ""]
		[h: log.debug ("mayCastSpell - from prepared: " + isPrepared)]
		<!-- Let the cantrips fly -->
		[h: spellLevel = json.get (spell, "level")]
		[h, if (spellLevel == 0): mayCastSpell = 1; ""]
		[h, if (mayCastSpell): castableSpells = json.append (castableSpells, spell); ""]
	}]
}]
[h: macro.return = castableSpells]