[h: json.toVars (dnd5e_AE2_getConstants())]
[h: tokenVersion = getProperty (VERSION_PROPERTY)]
<!-- From 0.0 to 0.15, we formalized how Types work. Old AE2 actions need to be adorned with these types -->
[h: versioned = dnd5e_Util_checkVersion (tokenVersion, "0.15")]
[h, if (!versioned), code: {
	[actionObj = getProperty("_AE2_Actions")]
	[updatedActionObj = "{}"]
	[foreach (actionKey, json.fields (actionObj)), code: {
		[action = json.get (actionObj, actionKey)]
		[updatedAction = dnd5e_AE2_adornActionTypes (action)]
		[updatedActionObj = json.set (updatedActionObj, actionKey, updatedAction)]
	}]
	[setProperty ("_AE2_Actions", updatedActionObj)]
}; {}]

[h: setProperty (VERSION_PROPERTY, AE2_CURRENT_VERSION)]
[h: broadcast ("<font color='green'><b>Actions Updated!</b></font>", "self")]