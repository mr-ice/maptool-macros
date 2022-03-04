[h: atoon = arg (0)]
[h: spell = arg (1)]
[h: dndb_Constants (getMacroName())]
[h: log.debug (CATEGORY + "##spell = " + spell)]
<!-- to avoid wrastling with json.path.read, get the definition and use json.get -->
[h: definition = json.get (spell, "definition")]
[h: spellName = json.get (definition, "name")]
[h: log.debug ("spellName: " + spellName)]
[h: spellLevel = json.get (definition, "level")]
<!-- Modifiers will contain any effect dice definitions -->
[h: spellModifiers = json.get (definition, "modifiers")]
[h: spellDescription = json.get (definition, "description")]
[h: spellComponents = json.get (definition, "components")]
[h: spellRange = json.get (definition, "range")]
[h: spellSaveDCAbilityId = json.get (definition, "saveDcAbilityId")]
[h, if (isNumber(spellSaveDCAbilityId)): spellSaveDCAbilityId = spellSaveDCAbilityId - 1]
[h: spellRequiresAttackRoll = json.get (definition, "requiresAttackRoll")]
[h: spellRequiresSavingThrow = json.get (definition, "requiresSavingThrow")]
[h: spellPrepared = json.get (spell, "prepared")]
[h: alwaysPrepared = json.get (spell, "alwaysPrepared")]
[h: log.debug (spellName + " prepared: " + spellPrepared + "; alwaysPrepared: " + alwaysPrepared)]
[h, if (spellPrepared == "false"): spellPrepared = alwaysPrepared; ""]
[h: spellCastingAbilityId = json.get (spell, "spellCastingAbilityId")]
[h, if (isNumber(spellCastingAbilityId)): spellCastingAbilityId = spellCastingAbilityId - 1]
[h: spellUsesSpellSlot = json.get (spell, "usesSpellSlot")]
[h: spellUsesConcentration = json.get (definition, "concentration")]
[h: spellCanCastAtHigherLevel = json.get (definition, "canCastAtHigherLevel")]
[h: spellCastWithWeaponAttack = json.get (definition, "asPartOfWeaponAttack")]
[h: spellIsOnlyRitual = json.get (spell, "castOnlyAsRitual")]
[h: spellScaleType = json.get (definition, "scaleType")]
[h: isRitual = json.get (definition, "ritual")]
[h: toonSpell = json.set ("", "name", spellName,
								"level", spellLevel,
								"modifiers", spellModifiers,
								"description", spellDescription,
								"concentration", spellUsesConcentration,
								"onlyRitual", spellIsOnlyRitual,
								"castAtHigherLevels", spellCanCastAtHigherLevel,
								"components", spellComponents,
								"range", spellRange,
								"saveDCAbilityId", spellSaveDCAbilityId,
								"spellCastingAbilityId", spellCastingAbilityId,
								"requiresAttackRoll", spellRequiresAttackRoll,
								"requiresSavingThrow", spellRequiresSavingThrow,
								"prepared", spellPrepared,
								"usesSpellSlot", spellUsesSpellSlot,
								"ritualSpell", isRitual,
								"scaleType", spellScaleType,
								"abilityId", spellCastingAbilityId)]
[h: macro.return = toonSpell]