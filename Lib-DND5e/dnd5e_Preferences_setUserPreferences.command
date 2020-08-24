[h: userPreferences = arg (0)]
<!-- Constants -->
[h: USER_PREFERENCES = "_dnd5e_Preferences_User"]
[h: existingPreferences = dnd5e_Preferences_getUserPreferences()]
[h, if (encode (existingPreferences) == ""): existingPreferences = "{}"; ""]
[h: mergedPreferences = json.merge (existingPreferences, userPreferences)]
[h: setProperty (USER_PREFERENCES, mergedPreferences)]
