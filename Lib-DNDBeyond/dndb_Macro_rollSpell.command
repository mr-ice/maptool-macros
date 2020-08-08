[h: inputObj = arg (0)]
[h: spellName = json.get (inputObj, "spellName")]
[h: spellSlot = json.get (inputObj, "spellSlot")]

[h: spells = dndb_getCastableSpells()]
[h: selectedSpell = json.get (spells, spellName)]
[h: spellLevel = json.get (selectedSpell, "level")]
[h, if (spellLevel > spellSlot): spellSlot = spellLevel; ""]

[r: "Casting " + json.get (selectedSpell, "name") + " at spell level " + spellSlot]
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

[h: expressions = dndb_RollExpression_buildSpellRoll (selectedSpell, spellSlot)]
[h: results = dnd5e_DiceRoller_roll (expressions)]
[r: spellDescription]
[r, if (saveDescription == ""): ""; "<br><br><b>" + saveDescription + "</b>"]
[r: dnd5e_RollExpression_getCombinedOutput (results)]