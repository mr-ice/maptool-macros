[h, if (argCount() > 0): slug = arg(0); slug = ""]
[h: o5e_ExtDB_Constants (getMacroName())]
[h: log.debug (CATEGORY + "slug = " + slug)]
[h: monsterDb = o5e_ExtDB_getDB()]
[h: log.debug (CATEGORY + "monsterDb = " + monsterDb)]
[h: blankMonster = o5e_ExtDB_getBlankMonster()]
[h, if (slug != ""): monsterObj = json.get (monsterDb, slug); monsterObj = "{}"]
[h, if (encode (monsterObj) == ""): monsterObj = "{}"]
[h: monsterObj = json.merge (blankMonster, monsterObj)]
[h: log.debug (CATEGORY + "monsterObj = " + monsterObj)]
[h: json.toVars (monsterObj, "o5e.ext.")]
[h: UNSPECIFIED = "N/A"]
[h: basicInputVars = json.get (monsterObj, "name", "challenge_rating", "strength", 
		"dexterity", "constitution", "intelligence", "wisdom", "charisma")]
[h: basicDefaults = json.set ("", "name", "Name", "strength", 10, "dexterity", 10,
		"constitution", 10, "intelligence", 10, "wisdom", 10, "charisma", 10)]
[h: inputStr = "junkTab | Info || TAB ## " +
		"junkVar | Fill out monster properties as desired. Actions will come later |Info| LABEL | span=true ##"]
[h: inputStr = inputStr +
		"junkVar | For skills and saves, use " + UNSPECIFIED + " to indicate 'Unspecified' " + 
		"and the Token Setup macro will calculate the correct values |Info| LABEL | span=true ##"]
[h: inputStrX = inputStr +
		"junk | Proficiency Values: Valid choices are " + 
		"0 = No proficiency; 0.5 = Half; 1 = Proficient; 2 = Expert |Info| LABEL | span=true ##"]
[h: basicInputStr = o5e_ExtDB_getInputFromJson (basicInputVars, basicDefaults)]
[h: inputStr = inputStr + "basicTab | Basic | | TAB | select=true##" + basicInputStr]

[h: combatInputVars = json.get (monsterObj, "size", "type","armor_class", "hit_points", "hit_dice",
		"damage_vulnerabilities", "damage_resistances", "damage_immunities", "condition_immunities",
		"senses")]
[h: combatDefaults = json.set ("", "size", "Medium", "type", "Humanoid", "armor_class", 10,
		"hit_points", 10, "hit_dice", "1d10+5", "damage_vulnerabilities", UNSPECIFIED, "damage_resistances", UNSPECIFIED, + 
		"damage_immunities", UNSPECIFIED, "condition_immunities", UNSPECIFIED, "senses", UNSPECIFIED)]
[h: combatInputStr = o5e_ExtDB_getInputFromJson (combatInputVars, combatDefaults)]
[h: inputStr = inputStr + "## combatTab | Combat || TAB ##" + combatInputStr)]

[h: saveInputVars = json.get (monsterObj, "strength_save", "dexterity_save", "constitution_save",
		"intelligence_save", "wisdom_save", "charisma_save")]
[h: saveDefaults = "{}"]
[h, foreach (field, json.fields (saveInputVars, "json")): saveDefaults = json.set (saveDefaults, field, UNSPECIFIED)]
[h: saveInputStr = o5e_ExtDB_getInputFromJson (saveInputVars, saveDefaults)]
[h: inputStr = inputStr + "## saveTab | Saves || TAB ##" + saveInputStr]

[h: monsterSkills = json.get (monsterObj, "skills")]
[h: skillInputVars = json.get (monsterSkills, "acrobatics", "animal_handling", "arcana", 
		"athletics", "deception", "history", "insight", "intimidation", "investigation", 
		"medicine", "nature", "perception", "persuasion", "sleight_of_hand", "stealth", "survival")]
[h: skillDefaults = "{}"]
[h, foreach (field, json.fields (skillInputVars, "json")): 
		skillDefaults = json.set (skillDefaults, field, UNSPECIFIED)]
[h: skillInputStr = o5e_ExtDB_getInputFromJson (skillInputVars, skillDefaults)]
[h: inputStr = inputStr + "## skillTab | Skills || TAB ##" + skillInputStr]

[h: monsterSpeed = json.get (monsterObj, "speed")]
[h: speedInputVars = json.get (monsterSpeed, "walk", "fly", "swim", "burrow", "climb")]
[h: speedDefaults = json.set ("", "walk", 30, "fly", UNSPECIFIED, "swim", UNSPECIFIED, 
			"burrow", UNSPECIFIED, "climb", UNSPECIFIED)]
[h: speedInputStr = o5e_ExtDB_getInputFromJson (speedInputVars, speedDefaults)]
[h: inputStr = inputStr + "## speedTab | Speeds | | TAB ## " + speedInputStr]

[h: abort (input (inputStr))]

[h: newMonster = monsterObj]
[h: varsFromStrProp (basicTab, "##")]
[h, foreach (field, basicInputVars, "json"): evalMacro ("[h: newMonster = json.set (newMonster, field, " + field + ")]")]
[h: varsFromStrProp (combatTab, "##")]
[h, foreach (field, combatInputVars, "json"): evalMacro ("[h: newMonster = json.set (newMonster, field, " + field + ")]")]
[h: varsFromStrProp (saveTab, "##")]
[h, foreach (field, saveInputVars, "json"): evalMacro ("[h: newMonster = json.set (newMonster, field, " + field + ")]")]
[h: skillObj = "{}"]
[h: varsFromStrProp (skillTab, "##")]
[h, foreach (field, skillInputVars, "json"): evalMacro ("[h: skillObj = json.set (skillObj, field, " + field + ")]")]
[h: newMonster = json.set (newMonster, "skills", skillObj)]
[h: varsFromStrProp (speedTab, "##")]
[h: speedObj = "{}"]
[h, foreach (field, speedInputVars, "json"): evalMacro ("[h: speedObj = json.set (speedObj, field, " + field + ")]")]
[h: newMonster = json.set (newMonster, "speed", speedObj)]
[h: newMonster = o5e_ExtDB_stripUnspecified (newMonster, UNSPECIFIED)]
<!-- Adorn a few key properties -->
[h: slug = replace (name, "[ ,]", "-")]
<!-- always lower case the slug -->
[h: newMonster = json.set (newMonster, "slug", lower (slug), "monsterDBName", name)]
[h: doActions = 0]
[h: input ("doActions | Yes,No | Edit actions? | LIST | select=0")]
<!-- Reverse physchology for the purposes of making Yes come before No: ! means do it -->
[h, if (!doActions): newMonster = o5e_ExtDB_EditActions (newMonster)]
[h: monsterDB = json.set (monsterDB, slug, newMonster)]
[h: macro.return = monsterDB]