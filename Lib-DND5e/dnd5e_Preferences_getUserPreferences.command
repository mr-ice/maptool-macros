<!-- Constants -->
[h: USER_PREFERENCES = "_dnd5e_Preferences_User"]

<!-- Get preferences -->
[h, if (currentToken () == ""): userPreferences = "{}"; userPreferences = getProperty (USER_PREFERENCES)]

[h: macro.return = userPreferences]