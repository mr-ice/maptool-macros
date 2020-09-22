[h: prefKey = arg (0)]
[h: prefValue = arg (1)]
[h, if (json.length (macro.args) > 2): isGmPref = arg (2); isGmPref = 0]
[h, if (isGmPref): userPref = dnd5e_Preferences_getGMPreferences();
                   userPref = dnd5e_Preferences_getUserPreferences ()]
[h: userPref = json.set (userPref, prefKey, prefValue)]
[h, if (isGmPref): dnd5e_Preferences_setGMPreferences (userPref);
                   dnd5e_Preferences_setUserPreferences (userPref)]