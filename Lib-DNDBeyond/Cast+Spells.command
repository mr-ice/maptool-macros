[h, if (json.length (macro.args) > 0): inputObj = arg (0); inputObj = "{}"]

<!-- Constants -->
[h: MINIMUM_ALLOWED = "Minimum Allowed"]
[h: SELECTED_SPELL_SLOT = "selectedSpellSlotLevel"]
[h: SELECTED_SPELL = "selectedSpellName"]

<!-- The user may have given us an inputObj with a spell and a spell slot to use. Those values will
	have to be validated to ensure the spell and slot are still available -->
[h: passedSpellName = json.get (inputObj, SELECTED_SPELL)]
[h: passedSpellSlotLevel = json.get (inputObj, SELECTED_SPELL_SLOT)]
[h: saveAsMacro = 0]
[h: spellInputValid = 0]

<!-- Build and display a list of spells to chose -->
<!-- Create three separate lists: concentration spells, ritual spells, and not-concentration spells. 
	 While concentration and not-concentration are mutually exclusive, ritual spells can be duped in
	 one of the other two lists. Currently, this macro does not cast as rituals -->
[h: spellMap = "{}"]
[h: concentrationSpellsInput = ""]
[h: ritualSpellsInput = ""]
[h: otherSpellsInput = ""]

[h: concentrationList = "[]"]
[h: ritualList = "[]"]
[h: otherList = "[]"]
<!-- Get spells now and divide between concentration and non-concentration -->

[h: spells = dndb_getCastableSpells()]
[h: passedSpell = "{}"]
[h, foreach (spell, spells), code: {
	[h: isConcentration = json.get (spell, "concentration")]
	[h: name = json.get (spell, "name")]
	[h, if (isConcentration == "true"): concentrationList = json.append (concentrationList, name);
								otherList = json.append (otherList, name)]
	[h, if (name == passedSpellName), code: {
		[h: spellInputValid = 1]
		[h: passedSpell = spell]
	}; {""}]
	[h: spellMap = json.set (spellMap, name, spell)]
}]

<!-- fetch castable spells in two lists - rituals and everything -->
[h: castableRitualSpells = dndb_getCastableSpells(1)]
[h, foreach (spell, castableRitualSpells), code: {
	[h: name = json.get (spell, "name")]
	[h: ritualList = json.append (ritualList, name)]
	[h, if (passedSpellName == name): spellInputValid = 1; ""]
	[h: spellMap = json.set (spellMap, name, spell)]
}]

<!-- Build the inputs -->
[h: concentrationList = json.sort (json.unique (concentrationList))]
[h: otherList = json.sort (json.unique (otherList))]
[h: ritualList = json.sort (json.unique (ritualList))]


[h: concentrationSpellsInput = "None," + json.toList (concentrationList)]
[h: ritualSpellsInput = "None," + json.toList (ritualList)]
[h: otherSpellsInput = "None," + json.toList (otherList)]

[h, if (!isNumber (passedSpellSlotLevel) && passedSpellSlotLevel == MINIMUM_ALLOWED), code: {
	[h: minimumSpellSlot = dndb_findMinimumAvailableSpellSlotForSpell (passedSpell)]
		<!-- if no minimum spell slot was found for the spell, set the level to -1 to 
		garuantee invalidation and a prompt -->
	[h, if (json.isEmpty (minimumSpellSlot)): 
				passedSpellSlotLevel = -1; 
				passedSpellSlotLevel = json.get (minimumSpellSlot, "level")]
}; {""}]


[h: basicToon = dndb_getBasicToon ()]

<!-- build a list of avaialable spell slots -->
[h: spellSlots = json.get (basicToon, "spellSlots")]
[h: spellSlotInput = ""]
[h: availableSpellSlots = dndb_getAvailableSpellSlots ()]

<!-- input validator; Start as false and toggle when spell slot is in the available list -->
[h: slotInputValid = 0]
[h, foreach (availableSpellSlot, availableSpellSlots), code: {
	[h: level = json.get (availableSpellSlot, "level")]
	[h, if (level == passedSpellSlotLevel): slotInputValid = 1; ""]
	<!-- build the spell slot input string while were doing this -->
	[h: spellSlotInput = spellSlotInput + "," + level]
}]
[h: spellSlotInput = substring (spellSlotInput, 1)]

<!-- validate the input spell by name -->
[h: spellSlotInput = MINIMUM_ALLOWED + "," + spellSlotInput]



<!-- if our input spell and spell slot are both available choices, move on to casting -->
[h, if (slotInputValid && spellInputValid): inputValid = 1; inputValid = 0]
[h: validChoice = 0]
[h, while (!validChoice), code: {
	<!-- If prompting the user, validate they pick a a spell slot that can cast the spell -->
	<!-- start as valid and invalidate as we go -->
	[h: validChoice = 1]
	[h: spellSlot = -1]
	[h, if (!inputValid): abort (input ("selectedConcentration | "  + concentrationSpellsInput + 
		"| Concentration Spells | List | value=string",
		"selectedRitual | " + ritualSpellsInput + " | Ritual Spells | List | value=string",
		"selectedOther | " + otherSpellsInput + " | Spells | List | value=string",
		"spellSlot | " + spellSlotInput + " | Spend Spell Slot | List | value=string",
		" saveAsMacro | 0 | Save as Macro | check "));""]

	<!-- A valid choice is:
		- One spell selected
		- and either a default minimum or eligible spell slot selected -->
	[h: selectedSpell = ""]
	[h: selectedSpellName = "None"]
	[h, if (selectedConcentration != "None"): selectedSpellName = selectedConcentration; ""]
	[h, if (selectedRitual != "None"): selectedSpellName = selectedRitual; ""]
	[h, if (selectedOther != "None"): selectedSpellName = selectedOther; ""]
	[h, if (inputValid): selectedSpell = passedSpell; 
						selectedSpell = json.get (spellMap, selectedSpellName)]
	
	[h, if (encode (selectedSpell) == ""), code: {
		[h: input ("junk | Exactly one spell must be selected. |  | Label | span=true")]
		<!-- Use a stub spell for the next part so it auto-validates the spell level and
			doesnt give the user a second complaint -->
		[h: selectedSpell = json.set ("", "level", 0)]
		[h: validChoice = 0]
	}; {""}]

	[h: spellLevel = json.get (selectedSpell, "level")]

	[h: selectedSpellSlot = ""]
	[h: spellSlotNum = spellSlot]
	[h, if (inputValid): spellSlotNum = passedSpellSlotLevel; ""]
		
	<!-- Find the minimum candidate slot -->
	[h: minimumSpellSlot = ""]
	[h, foreach (candidateSlot, availableSpellSlots), code: {
		[h: slotLevel = json.get (candidateSlot, "level")]
		[h, if (slotLevel >= spellLevel): slotLevelIsValid = 1; slotLevelIsValid = 0]
		[h, if (encode (minimumSpellSlot) == "" && slotLevelIsValid): minimumSpellSlot = candidateSlot; ""]
	}]

	<!-- if minimum was selected, roll with it. If a number was chosen, validate its equal or bigger than the spell and use that -->
	[h, if (spellSlot == MINIMUM_ALLOWED): selectedSpellSlotLevel = json.get (minimumSpellSlot, "level"); selectedSpellSlotLevel = spellSlotNum]
	<!-- validate -->
	[h: validChoice = 1]
	[h, if (selectedSpellSlotLevel < spellLevel), code: {
		[h: abort (input ("junk | Invalid spell slot selected | | Label | span=true"))]
		[h: validChoice = 0]
	};{""}]

	[h: expressions = dndb_RollExpression_buildSpellRoll (selectedSpell, selectedSpellSlotLevel)]
}]
[r: "Casting " + json.get (selectedSpell, "name") + " at spell level " + selectedSpellSlotLevel]
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
[h: results = dndb_DiceRoller_roll (expressions)]
<pre>[r: json.indent (results)]</pre>
[r: spellDescription]
[r, if (saveDescription == ""): ""; "<br><br><b>" + saveDescription + "</b>"]

<!-- Ye old save as macro bullshit -->
[h, if (saveAsMacro > 0), code: {
	[h: macroConfig = dndb_Macro_copyMacroConfig ("Cast Spells")]

	[h: cmdArg = json.set ("", SELECTED_SPELL, json.get (selectedSpell, "name"), 
							SELECTED_SPELL_SLOT, spellSlot)]
	<!-- Do this in case minimum was selected but the spell was still up-cast -->
	[h, if (spellSlot == MINIMUM_ALLOWED): selectedSpellSlotLevel = spellLevel; ""]
	[h: spellName = json.get (selectedSpell, "name")]
	[h: macroName = "Cast " + spellName]
	[h, if (selectedSpellSlotLevel > spelllevel): macroName = macroName + " (" + selectedSpellSlotLevel + ")"; ""]
	[h: currentMacros = getMacros()]
	[h: cmd = "[macro ('Cast Spells@Lib:DnDBeyond'): '" + cmdArg + "']"]
	<!-- dont create duplicates -->
	[h, foreach (currentMacro, currentMacros), if (currentMacro == macroName): saveAsMacro = 0]
	[h: macroConfig = json.set ("", "applyToSelected", 1,
								"autoExecute", 1,
								"color", json.get (macroConfig, "color"),
								"fontSize", json.get (macroConfig, "fontSize"),
								"fontColor", json.get (macroConfig, "fontColor"),
								"group", "D&D Beyond - Spells",
								"playerEditable", 0)]
	[h, if (saveAsMacro > 0): createMacro (macroName, cmd, macroConfig)]
}]