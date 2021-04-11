[h: dnd5e_PartyPanel_Constants(getMacroName())]
[h: cfg = dnd5e_Preferences_getPreference (PROPERTY_PARTY_PANEL_CONFIG)]
[h, if (json.type (cfg) != "OBJECT"): cfg = CONFIGURATION_DEFAULT_CONFIG]
[h: macro.return = cfg]