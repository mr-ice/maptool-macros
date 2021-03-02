[h: log.debug (getMacroName() + ": args = " + json.indent (macro.args))]
[h: actionButton = json.get (macro.args, "actionButton")]
[h: spellSlot = json.get (macro.args, "spell-slot")]
[h, if (spellSlot == ""): spellSlot = 0; ""]
[h: castSpellAdvantage = json.get (macro.args, "castSpell-advantage")]
[h: castSpellDisadvantage = json.get (macro.args, "castSpell-disadvatage")]
[h: castSpellBoth = json.get (macro.args, "castSpell-both")]
[h: encodedSpellName = json.get (macro.args, "spellName")]
[h: spellRestriction = json.get (macro.args, "spell-restriction")]
[h: noShowSpellDescription = json.get (macro.args, "noShowSpellDescription")]
[h, if (noShowSpellDescription == ""): noShowSpellDescription = 0]

[h, if (actionButton == "Cancel"): abort (0); ""]

[h, if (castSpellAdvantage == "on"): castSpellAdvantage = "true"; castSpellAdvantage = "false"]
[h, if (castSpellDisadvantage == "on"): castSpellDisadvantage = "true"; castSpellDisadvantage = "false"]
[h, if (castSpellBoth == "on"): castSpellBoth = "true"; castSpellBoth = "false"]
[h: advDisadvObj = json.set ("", "advantage", castSpellAdvantage,
                             "disadvantage", castSpellDisadvantage,
                             "both", castSpellBoth)]

[h: spells = dndb_getCastableSpells()]
[h: selectedSpell = json.get (spells, encodedSpellName)]
[h: spellLevel = json.get (selectedSpell, "level")]
[h, if (spellLevel > spellSlot): spellSlot = spellLevel; ""]

[h: castSpellMsg = "Casting " + json.get (selectedSpell, "name") + " at spell level " + spellSlot]
[h: log.info (getMacroName() + ": " + castSpellMsg)]
[r: castSpellMsg]
[h: spellDescription = json.get (selectedSpell, "description")]

<!-- Get Save DC, if any -->
[h: saveDescription = ""]
[h: saveDCAbilityId = json.get (selectedSpell, "saveDCAbilityId")]
[h, if (isNumber (saveDCAbilityId)), code: {
	[h: saveDC = json.get (selectedSpell, "saveDC")]
	[h, switch (saveDCAbilityId):
		case 1: saveAbility = "Strength";
		case 2: saveAbility = "Dexterity";
		case 3: saveAbility = "Constitution";
		case 4: saveAbility	= "Intelligence";
		case 5: saveAbility = "Wisdom";
		case 6: saveAbility = "Charisma"]
	[h: saveDescription = saveAbility + " save DC " + saveDC]
}]

[h: expressions = dndb_RollExpression_buildSpellRoll (selectedSpell, spellSlot, advDisadvObj, spellRestriction)]
[h: log.debug (getMacroName() + ": expressions = " + json.indent (expressions))]
[h: results = dnd5e_DiceRoller_roll (expressions)]
[r, if (!noShowSpellDescription): spellDescription]
[r, if (saveDescription == ""): ""; "<br><br><b>" + saveDescription + "</b>"]
[h: output = ""]
[h, if (!json.isEmpty (results)), code: {
	[dnd5e_SavedAttacks_push (results)]
	[output = dnd5e_RollExpression_getFormattedOutput (results)]
}; {}]
[r: output]