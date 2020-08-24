[h: prefKey = arg (0)]

[h: userPreferences = dnd5e_Preferences_getUserPreferences ()]

<!-- Null protect -->
[h, if (encode (userPreferences) == ""): userPreferences = "{}"; ""]

<!-- get campaign preference -->
[h, macro ("getCampaignPreferences@Lib:CampaignPreferences"): ""]
[h: campaignPref = macro.return]
[h: log.debug ("campaignPref: " + campaignPref)]
[h: preference = ""]

<!-- iterate through the three preferences in order of least significant to most. Set the value only when
	it's non-null -->
[h: prefList = json.append ("", userPreferences, campaignPref)]
[h, foreach (prefObj, prefList), code: {
	[h: log.debug ("prefObj: " + prefObj)]
	[h: tempValue = json.get (prefObj, prefKey)]
	[h, if (tempValue != ""): preference = tempValue; ""]
}]
<!-- Never return "", replace it with 0 so it can easily be used in a boolean -->
[h, if (preference == ""): preference = 0; ""]
[h: macro.return = preference]