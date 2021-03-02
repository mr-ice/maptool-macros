[h: toon = arg (0)]

<!-- inspect data.classSpells array, for each object, read characterClassId. Find the classObj with that id and 
     determine the related spell ability. If there are overlaps, I dunno, dupes? -->

[h: allSpells = "{}"]
[h: abilities = dndb_getAbilities (toon)]
[h: classSpellsArry = json.path.read (toon, "data.classSpells")]
[h: log.debug (getMacroName() + ": classSpellsArry = " + classSpellsArry)]
<!-- Some dumb classes, like Monk, add spells dumbly, like Monk, and are dumb, like Monk -->
<!-- Create a bonus classObj spells array thats included in each iteration of spellcasting classes because 
	dumb monks are dumb -->
[h: bonusClassSpells = json.path.read (toon, "data.spells.class")]
[h: log.debug (getMacroName() + ": bonusClassSpells = " + bonusClassSpells)]
[h: filteredBonusSpells = "[]"]
[h, if (!json.isEmpty(bonusClassSpells)), code: {
	<!-- look for the definition object. If he aint got one, fuck off -->
	[foreach (bonusSpell, bonusClassSpells, ""), code: {
		[if (json.contains (bonusSpell, "definition")): filteredBonusSpells = json.append (filteredBonusSpells, bonusSpell)]
	}]
}; {}]
[h: bonusClassSpells = filteredBonusSpells]
[h: log.debug (getMacroName() + ": bonusClassSpells (filtered) = " + bonusClassSpells)]
<!-- Racial spells -->
[h: racialSpells = json.path.read (toon, "data.spells.race")]
[h: log.debug (getMacroName() + ": racialSpells = " + racialSpells)]
[h: filteredBonusSpells = "[]"]
[h, if (!json.isEmpty(racialSpells)), code: {
	<!-- look for the definition object. If he aint got one, fuck off -->
	[foreach (bonusSpell, racialSpells, ""), code: {
		[if (json.contains (bonusSpell, "definition")): filteredBonusSpells = json.append (filteredBonusSpells, bonusSpell)]
	}]
}; {}]
[h: bonusClassSpells = json.merge (filteredBonusSpells, bonusClassSpells)]

[h: featSpells = json.path.read (toon, "data.spells.feat")]
[h: log.debug (getMacroName() + ": featSpells = " + featSpells)]
[h, if (json.length (featSpells) > 0): bonusClassSpells = json.merge (bonusClassSpells, featSpells); ""]
<!-- to the bonusClassSpells, append any always prepared spells -->
[h: alwaysPreparedSpells = json.path.read (toon, "data.lib_dndb-AlwaysPreparedSpells")]

[h, if (json.length (alwaysPreparedSpells) > 0): bonusClassSpells = json.merge (bonusClassSpells, alwaysPreparedSpells); ""]

[h: classesArry = json.path.read (toon, "data.classes")]
<!-- Merge the spell casting sub-classObj with the classObj only when sub-classObj is spell casting -->
[h: mergedClasses = "[]"]
[h, foreach (classObj, classesArry), code: {
	<!-- The expected result is a subclassObj will add the ability to cast spells to the parent classObj but never the other way around.
		So only when the subclassObj has canCastSpells as true will we override the parents definition. But only for a few key
		attributes! For some reason, a subclassObj wont have spellRules when it does enable spell casting...-->
	[h: subclassObj = json.get (classObj, "subclassDefinition")]
	[h, if (json.isEmpty (subClassObj)), code: {
		[h: subCanCastSpells = "false"]
		[h: subclassObj = "{}"]
	}; {
		[h: subCanCastSpells = json.get (subclassObj, "canCastSpells")]
	}]
	<!-- edge case - Monk Way of the Shadow has both classObj and subclassObj as cant cast spells, but sub has a
		spellCastingAbilityId. Use that as a backup flag -->
	[h: subSpellCastingAbilityId = json.get (subclassObj, "spellCastingAbilityId")]
	[h, if (subCanCastSpells == "true" || isNumber (subSpellCastingAbilityId)), code: {
		[h: log.debug ("Overriding with subclass")]
		[h: spellCastingAbilityId = json.get (subclassObj, "spellCastingAbilityId")]
		[h: spellPrepareType = json.get (subclassObj, "spellParepareType")]
		[h: isRitualSpellCaster = json.get (subclassObj, "isRitualSpellCaster")]
		[h: spellContainerName = json.get (subclassObj, "spellContainerName")]
		[h: classDefinition = json.get (classObj, "definition")]
		[h: classDefinition = json.set (classDefinition, "canCastSpells", "true",
											"spellCastingAbilityId", spellCastingAbilityId,
											"spellPrepareType", spellPrepareType,
											"isRitualSpellCaster", isRitualSpellCaster,
											"spellContainerName", spellContainerName)]
		[h: classObj = json.set (classObj, "definition", classDefinition)]
	}]
	[h: canCastSpells = json.path.read (classObj, "definition.canCastSpells")]
	<!-- only add to mergedClasses if canCastSpells is true -->
	[h, if (canCastSpells == "true"): mergedClasses = json.append (mergedClasses, classObj); ""]
}]
[h: searchArg = json.set ("", "object", toon,
							"subType", "spell-attacks")]
[h: spellAttackModifiers = dndb_searchGrantedModifiers (searchArg)]
[h: log.debug (getMacroName() + ": spellAttackModifiers = " + spellAttackModifiers)]
[h: proficiency = dndb_getProficiencyBonus (toon)]
[h, foreach (classObj, mergedClasses), code: {
	<!-- find the classSpells object for the classObj -->
	[h: classSpellsSearchArg = json.set ("", "object", classSpellsArry,
									"characterClassId", json.get (classObj, "id"))]
	[h: classSpells = json.get (dndb_searchJsonObject (classSpellsSearchArg), 0)]
	[h: spellCastingAbilityId = json.path.read (classObj, "definition.spellCastingAbilityId")]
	[h: classRequiresPreparation = json.path.read (classObj, "definition.spellPrepareType", "SUPPRESS_EXCEPTIONS")]
	[h, if (classRequiresPreparation == "null"): classRequiresPreparation = 0]
	[h: isRitualCaster = json.path.read (classObj, "definition.spellRules.isRitualSpellCaster", "SUPPRESS_EXCEPTIONS")]
	[h, if (isRitualCaster == "null"): isRitualCaster = 0]
	[h: spellContainer = json.path.read (classObj, "definition.spellContainerName", "SUPPRESS_EXCEPTIONS")]
	[h: log.debug ("dndb_getSpells: isRitualCaster = " + isRitualCaster + "; spellContainer = " + spellContainer)]
	[h: casterLevel = json.get (classObj, "level")]
	[h: spells = json.get (classSpells, "spells")]
	[h: spells = json.merge (spells, bonusClassSpells)]
	[h: log.debug ("dndb_getSpells: spells = " + spells)]
	[h, foreach (spell, spells), code: {
		[h: basicSpell = dndb_convertSpell (toon, spell)]
		[h, switch (spellCastingAbilityId):
			case 1: abilityName = "str";
			case 2: abilityName - "dex";
			case 3: abilityName = "con";
			case 4: abilityName = "int";
			case 5: abilityName = "wis";
			case 6: abilityName = "cha"]
			
		[h: abilityBonus = json.get (abilities, abilityName + "Bonus")]
		[h: atkBonus = abilityBonus + proficiency]
		[h: spellRequiresAttackRoll = json.get (basicSpell, "requiresAttackRoll")]
		[h, if (spellRequiresAttackRoll == "true"): atkBonus = atkBonus + dndb_getAttackModiferBonusForSpell (toon, spell, spellAttackModifiers)]
		[h: saveDC = 8 + abilityBonus + proficiency]
		[h: isRitual = json.get (basicSpell, "ritualSpell")]
		[h: spellPrepared = json.get (basicSpell, "prepared")]
		<!-- set spellIsRitual to true when:
			isRitual is true AND
					the classObj is a ritual caster AND
					the classObj does not prepare OR the classObj does prepare AND
													the spell is prepared OR the spell is in a Spellbook -->
		<!-- Im out of nested levels; Fake it -->
		[h, if (isRitual != "true" || isRitualCaster != "true"): spellIsRitual = 0; spellIsRitual = 1]
		[h: log.debug ("spellIsRitual after isRitualCaster: " + spellIsRitual)]
		[h, if (classRequiresPreparation && (spellPrepared != "true" && spellContainer != "Spellbook")): spellIsRitual = 0; ""]
		[h: log.debug ("spellIsRitual after requires prep: " + spellIsRitual)]
		<!-- if it is a ritual and classObj does not require preparation, its already a 1; were g2g -->
		[h: basicSpell = json.set (basicSpell, "ritual", spellIsRitual,
									"abilityBonus", abilityBonus,
									"saveDC", saveDC,
									"casterLevel", casterLevel,
									"attackBonus", atkBonus,
									"spellCastingAbilityId", spellCastingAbilityId,
									"mustBePrepared", classRequiresPreparation)]
		[h: allSpells = json.set (allSpells, encode (json.get (basicSpell, "name")), basicSpell)]
	}]
}]
[h: macro.return = allSpells]

