<!-- copy the 5e macros, first -->
[h: dnd5e_Macro_clearTokenMacros()]
[h: dnd5e_Macro_createPlayerMacros ()]
[h: abilityList = "[Strength,Dexterity,Constitution,Intelligence,Wisdom,Charisma]"]

[h: saveConfig = dnd5e_Macro_copyMacroConfig ("Saving Throw")]
[h: saveConfig = json.remove (saveConfig, "label")]
[h: saveConfig = json.remove (saveConfig, "command")]
[h: macroGroup = "D&D 5e - Saves"]
[h: cmd = "Saving Throw@Lib:DnD5e"]
[h, foreach (ability, abilityList), code: {
	[macroName = ability + " Save"]

	[sortBy = json.indexOf (abilityList, ability)]
	[cmdArg = json.set ("", "savingThrowAbility", ability, 
							"advDisadv", "None")]
	[saveConfig = json.set (saveConfig, "sortBy", sortBy)]
	[dnd5e_Macro_createAdvDisadvMacroFamily (macroName, cmd, cmdArg, saveConfig)]
}]

<!-- Create Ability checks, perception, and then general Skills -->
[h: abilityConfig = dnd5e_Macro_copyMacroConfig ("Skill Check")]
[h: abilityConfig = json.remove (abilityConfig, "label")]
[h: abilityConfig = json.remove (abilityConfig, "command")]
[h: macroGroup = "D&D 5e - Skills"]
[h: cmd = "Skill Check@Lib:DnD5e"]
<!-- perception check is sort 11 -->
<!-- str ability check is sort 18 -->
[h: abilitySortMap = json.set ("", "Perception", 11, "Strength", 18, "Dexterity", 19,
							"Constitution", 20, "Intelligence", 21, "Wisdom", 22, "Charisma", 23)]
[h, foreach (field, json.fields (abilitySortMap)), code: {
	[macroName = field]

	[sortBy = json.get (abilitySortMap, field)]
	[cmdArg = json.set ("", "skillCheckName", field, 
							"advDisadv", "none")]
	[abilityConfig = json.set (abilityConfig, "sortBy", sortBy)]
	[dnd5e_Macro_createAdvDisadvMacroFamily (macroName, cmd, cmdArg, abilityConfig)]
}]

<!-- Action macros -- oh boy -->
[h: actions = o5e_Token_getMonsterActions()]
[h: attackConfig = dnd5e_Macro_copyMacroConfig ("Attack Editor")]
[h: attackConfig = json.remove (attackConfig, "label")]
[h: attackConfig = json.remove (attackConfig, "command")]
[h: macroGroup = "Open 5e - Actions"]
[h: cmd = "o5e_Token_rollAction@Lib:Open5e"]
[h: fields = json.fields (actions, "json")]
[h: log.info ("fields = " + fields)]
[h: fields = json.removeAll (fields, json.append ("", "Multiattack"))]
[h, foreach (actionName, fields), code: {
	<!-- Create the macros that call the really cool macro. So make the really cool macro, first -->
	[sortBy = json.indexOf (fields, actionName)]

	[cmdArg = json.set ("", "actionName", actionName, "advDisadv", "none")]
	[attackConfig = json.set (attackConfig, "sortBy", sortBy)]
	[dnd5e_Macro_createAdvDisadvMacroFamily (actionName, cmd, cmdArg, attackConfig)]
}]
