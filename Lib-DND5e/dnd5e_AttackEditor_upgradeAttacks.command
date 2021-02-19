[h: dnd5e_AE2_getConstants()]
[h: tokenVersion = getProperty (AE_VERSION_PROPERTY)]
<!-- From 0.0 to 0.15, we formalized how Types work. Old AE1 attacks need to be adorned with these types -->
[h: versioned = dnd5e_Util_checkVersion (tokenVersion, "0.15")]
[h, if (!versioned), code: {
	[atkObj = getProperty("attackExpressionJSON")]
	[updatedAtkObj = "{}"]
	[foreach (actionKey, json.fields (atkObj)), code: {
		[action = json.get (atkObj, actionKey)]
		<!-- AE2 upgrader is the same thing we need to do -->
		[updatedAtk = dnd5e_AE2_adornActionTypes (action)]
		[updatedAtkObj = json.set (updatedAtkObj, actionKey, updatedAtk)]
	}]
	[setProperty ("attackExpressionJSON", updatedAtkObj)]
}; {}]

[h: setProperty (AE_VERSION_PROPERTY, AE_CURRENT_VERSION)]
[h: broadcast ("<font color='green'><b>Attacks Updated!</b></font>", "self")]