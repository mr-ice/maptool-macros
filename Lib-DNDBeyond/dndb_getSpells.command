[h: toon = arg (0)]

<!-- inspect data.classSpells array, for each object, read characterClassId. Find the class with that id and 
     determine the related spell ability. If there are overlaps, I dunno, dupes? -->

[h: allSpells = "{}"]
[h: abilities = dndb_getAbilities (toon)]
[h: classSpellsArry = json.path.read (toon, "data.classSpells")]
<!-- Some dumb classes, like Monk, add spells dumbly, like Monk, and are dumb, like Monk -->
<!-- Create a bonus class spells array thats included in each iteration of spellcasting classes because 
	dumb monks are dumb -->
[h: bonusClassSpells = json.path.read (toon, "data.spells.class")]
[h: featSpells = json.path.read (toon, "data.spells.feat")]
[h, if (json.length (featSpells) > 0): bonusClassSpells = json.merge (bonusClassSpells, featSpells); ""]
[h: log.debug ("dndb_getSpells: classSpellsArry = " + classSpellsArry)]
[h: classes = json.path.read (toon, "data.classes")]
<!-- Merge the spell casting sub-class with the class, only when sub-class is spell casting -->
[h: mergedClasses = "[]"]
[h, foreach (class, classes), code: {
	<!-- The expected result is a subClass will add the ability to cast spells to the parent class, but never the other way around.
		So only when the subClass has canCastSpells as true will we override the parents definition. But only for a few key
		attributes! For some reason, a subclass wont have spellRules when it does enable spell casting...-->
	[h: subClass = json.get (class, "subclassDefinition")]
	[h, if (json.isEmpty (subClass)), code: {
		[h: subCanCastSpells = "false"]
		[h: subClass = "{}"]
	}; {
		[h: subCanCastSpells = json.get (subClass, "canCastSpells")]
	}]
	<!-- edge case - Monk Way of the Shadow has both class and subClass as cant cast spells, but sub has a
		spellCastingAbilityId. Use that as a backup flag -->
	[h: subSpellCastingAbilityId = json.get (subClass, "spellCastingAbilityId")]
	[h, if (subCanCastSpells == "true" || isNumber (subSpellCastingAbilityId)), code: {
		[h: log.debug ("Overriding with subclass")]
		[h: spellCastingAbilityId = json.get (subClass, "spellCastingAbilityId")]
		[h: spellPrepareType = json.get (subClass, "spellParepareType")]
		[h: isRitualSpellCaster = json.get (subClass, "isRitualSpellCaster")]
		[h: spellContainerName = json.get (subClass, "spellContainerName")]
		[h: classDefinition = json.get (class, "definition")]
		[h: classDefinition = json.set (classDefinition, "canCastSpells", "true",
											"spellCastingAbilityId", spellCastingAbilityId,
											"spellPrepareType", spellPrepareType,
											"isRitualSpellCaster", isRitualSpellCaster,
											"spellContainerName", spellContainerName)]
		[h: class = json.set (class, "definition", classDefinition)]
	}]
	[h: canCastSpells = json.path.read (class, "definition.canCastSpells")]
	<!-- only add to mergedClasses if canCastSpells is true -->
	[h, if (canCastSpells == "true"): mergedClasses = json.append (mergedClasses, class); ""]
}]
[h: searchArg = json.set ("", "object", toon,
							"subType", "spell-attacks")]
[h: spellAttackModifiers = dndb_searchGrantedModifiers (searchArg)]
[h: log.debug (getMacroName() + ": spellAttackModifiers = " + spellAttackModifiers)]
[h: proficiency = dndb_getProficiencyBonus (toon)]
[h, foreach (class, mergedClasses), code: {
	<!-- find the classSpells object for the class -->
	[h: classSpellsSearchArg = json.set ("", "object", classSpellsArry,
									"characterClassId", json.get (class, "id"))]
	[h: classSpells = json.get (dndb_searchJsonObject (classSpellsSearchArg), 0)]
	[h: spellCastingAbilityId = json.path.read (class, "definition.spellCastingAbilityId")]
	[h: classRequiresPreparation = json.path.read (class, "definition.spellPrepareType", "SUPPRESS_EXCEPTIONS")]
	[h, if (classRequiresPreparation == "null"): classRequiresPreparation = 0]
	[h: isRitualCaster = json.path.read (class, "definition.spellRules.isRitualSpellCaster", "SUPPRESS_EXCEPTIONS")]
	[h, if (isRitualCaster == "null"): isRitualCaster = 0]
	[h: spellContainer = json.path.read (class, "definition.spellContainerName", "SUPPRESS_EXCEPTIONS")]
	[h: log.debug ("dndb_getSpells: isRitualCaster = " + isRitualCaster + "; spellContainer = " + spellContainer)]
	[h: casterLevel = json.get (class, "level")]
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
					the class is a ritual caster AND
					the class does not prepare OR the class does prepare AND
													the spell is prepared OR the spell is in a Spellbook -->
		<!-- Im out of nested levels; Fake it -->
		[h, if (isRitual != "true" || isRitualCaster != "true"): spellIsRitual = 0; spellIsRitual = 1]
		[h: log.debug ("spellIsRitual after isRitualCaster: " + spellIsRitual)]
		[h, if (classRequiresPreparation && (spellPrepared != "true" && spellContainer != "Spellbook")): spellIsRitual = 0; ""]
		[h: log.debug ("spellIsRitual after requires prep: " + spellIsRitual)]
		<!-- if it is a ritual and class does not require preparation, its already a 1; were g2g -->
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