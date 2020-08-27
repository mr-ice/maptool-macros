[h: userPreferences = arg (0)]

[h: existingPreferences = dnd5e_Preferences_getGMPreferences()]
[h, if (encode (existingPreferences) == ""): existingPreferences = "{}"; ""]
[h: mergedPreferences = json.merge (existingPreferences, userPreferences)]
[h, macro ("setCampaignPreferences@Lib:CampaignPreferences"): mergedPreferences]