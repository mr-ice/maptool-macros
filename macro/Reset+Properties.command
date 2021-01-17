[h: log.warn ("Entering Reset Properties")]
[h: tokenIds = getSelected()]
[h: log.debug ("tokenId: " + tokenIds)]
[h, foreach (tokenId, tokenIds), code: {
[h: switchToken (tokenId)]

[h: SKIP_PROMPT = dnd5e_Preferences_getPreference ("suppressInitPrompt")]
[h, if (SKIP_PROMPT == ""): SKIP_PROMPT = 0; ""]
[h: basicToon = dndb_getBasicToon ()]

[h, if (json.length (macro.args) > 0): noConfirm = arg(0); noConfirm = 0]
[h: confirm = 1]
[h: noConfirm = noConfirm + SKIP_PROMPT]
[h, if (!noConfirm): input ("ignored | WARNING! This will reset any custom values. | All properties will be overwritten! | Label | SPAN=TRUE",
	"confirm | No, Yes | Are you sure you want to do this? | LIST | SELECT=0");""]
[h: abort (confirm)]

<!-- do these first! -->
[h: dnd5e_Property_resetCalculatedProperties()]
[h: dndb_applyConditions (basicToon)]

[h: setProperty ("Age", json.get (basicToon, "age"))]
[h: setProperty ("Faith", json.get (basicToon, "faith"))]
[h: setProperty ("Hair", json.get (basicToon, "hair"))]
[h: setProperty ("Eyes", json.get (basicToon, "eyes"))]
[h: setProperty ("Skin", json.get (basicToon, "skin"))]
[h: setProperty ("Height", json.get (basicToon, "height"))]
[h: setProperty ("Weight", json.get (basicToon, "weight"))]
[h: setProperty ("XP", json.get (basicToon, "xp"))]
[h: setProperty ("Gender", json.get (basicToon, "gender"))]
[h: setProperty ("Alignment", json.get (basicToon, "alignment"))]
[h: setProperty ("AvatarUrl", json.get (basicToon, "avatarUrl"))]
[h: setProperty ("Initiative", json.get (basicToon, "init"))]

[h: abilities = json.get (basicToon, "abilities")]
[h: setProperty ("Strength", json.get (abilities, "str"))]
[h: setProperty ("Dexterity", json.get (abilities, "dex"))]
[h: setProperty ("Constitution", json.get (abilities, "con"))]
[h: setProperty ("Intelligence", json.get (abilities, "int"))]
[h: setProperty ("Wisdom", json.get (abilities, "wis"))]
[h: setProperty ("Charisma", json.get (abilities, "cha"))]

[h: setProperty ("Proficiency", json.get (basicToon, "proficiencyBonus"))]

[h: setProperty ("Resistances", json.toList (json.get (basicToon, "resistances")))]
[h: setProperty ("Immunities", json.toList (json.get (basicToon, "immunities")))]

<!-- Senses -->
[h: dndb_applyVision (basicToon)]

<!-- Languages -->
[h: setProperty ("Languages", json.toList (json.get (basicToon, "language")))]

<!-- Health -->
[h: dndb_applyHealth ()]

[h: armorClass = json.get (basicToon, "armorClass")]
[h: setProperty ("AC", json.get (armorClass, "total"))]
[h: setProperty ("AC Dexterity", json.get (armorClass, "Dexterity"))]
[h: setProperty ("AC Armor", json.get (armorClass, "Armor"))]
[h: setProperty ("AC Shield", json.get (armorClass, "Shield"))]

<!-- Speeds -->
[h: dndb_applySpeed ()]

[h: saves = json.get (basicToon, "savingThrows")]
[h, foreach (save, saves), code: {
	[log.debug (getMacroName() + ": save = " + save)]
	[saveProperty = json.get (save, "property")]
	[setProperty ("proficiency." + saveProperty, json.get (save, "proficient"))]
	<!-- get the calculated bonuses from items, etc -->
	[bonus = json.get (save, "bonus")]
	<!-- get the bonus array from user tinkering -->
	[bonuses = json.get (save, "bonuses")]
	[magicBonus = json.get (save, "MagicBonus")]
	[miscBonus = json.get (save, "MiscBonus")]
	<!-- math it up -->
	[if (!json.isEmpty(magicBonus)): bonus = bonus + json.get (magicBonus, "value"); ""]
	[if (!json.isEmpty(miscBonus)): bonus = bonus + json.get (miscBonus, "value"); ""]
	[setProperty ("bonus." + saveProperty, bonus)]

	<!-- Finally, the user can just ... DECIDE ... to do whatever they want -->
	[override = json.get (bonuses, "Override")]
	[if (!json.isEmpty(override)): setProperty (json.get (save, "name") + "Save", json.get (override, "value")); ""]
}]

[h: skills = json.get (basicToon, "skills")]
[h, foreach (skill, skills), code: {
	[log.debug (getMacroName() + ": skill = " + skill)]
	[lowerSkillName = lower (json.get (skill, "name"))]
	[setProperty ("proficiency." + lowerSkillName, json.get (skill, "proficient"))]
	[setProperty ("ability." + lowerSkillName, json.get (skill, "ability"))]
	
	[bonus = json.get (skill, "bonus")]
	<!-- in the Bonuses object, MagicBonus and MiscBonus are culmative with bonus -->
	[bonuses = json.get (skill, "bonuses")]
	[log.debug (getMacroName() + ": bonuses = " + bonuses)]
	[magicBonus = json.get (bonuses, "MagicBonus")]
	[if (!json.isEmpty(magicBonus)): bonus = bonus + json.get (magicBonus, "value")]
	[miscBonus = json.get (bonuses, "MiscBonus")]
	[if (!json.isEmpty(miscBonus)): bonus = bonus + json.get (miscBonus, "value")]
	[setProperty ("bonus." + lowerSkillName, bonus)]

	[override = json.get (bonuses, "Override")]
	<!-- and then just set the property directly if theres an override -->
	[if (!json.isEmpty (override)): setProperty (json.get (skill, "name"), json.get (override, "value"))]
}]

[h: alignment = json.get (basicToon, "alignment")]
[h: setProperty ("Alignment", alignment)]

[h: setProperty ("Race", json.get (basicToon, "race"))]
[h: setProperty ("Classes", dndb_BasicToon_getClasses ())]

[h: dndb_mergeAttackJson ()]
[h: dndb_createPlayerMacros()]
}]