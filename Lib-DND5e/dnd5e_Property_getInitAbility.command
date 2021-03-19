[h: defaultAbility = "Dexterity"]
[h: initAbility = dnd5e_Preferences_getPreference ("initiativeAbilityOverride")]
[h: log.debug (getMacroName() + "## initAbility from pref = " + initAbility)]
[h: abilities = json.append ("Strength", "Dexterity", "Constitution",
	"Intelligence", "Wisdom", "Charisma")]
[h, if (!json.contains (abilities, initAbility)), code: {
	[selected = currentToken()]
	[if (selected != ""): initAbility = getProperty ("ability.initiative", selected); initAbility = defaultAbility]
	[log.debug (getMacroName() + "## selected = " + selected + "; initAbility = " + initAbility)]
}]
[h: log.debug (getMacroName() + "## initAbility = " + initAbility)]
[h: macro.return = initAbility]