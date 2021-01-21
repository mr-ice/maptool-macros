[h: requiredMinVersion = arg (0)]
[h, if (argCount() > 1): requiredMaxVersion = arg (1); requiredMaxVersion = -1]

[h, macro ("dnd5e_Util_getCampaignPropertiesVersion@this"): ""]
[h: campaignVersion = macro.return]
[h, macro ("dnd5e_Util_checkVersion@this"): json.append ("", campaignVersion, requiredMinVersion, requiredMaxVersion)]
[h: isValid = macro.return]
[h, if (!isValid), code: {
	[msg = "<font color='red'><b>Invalid campaign properties. Requires:</b></font> " + requiredMinVersion]
	[if (requiredMaxVersion != -1): msg = msg + " - " + requiredMaxVersion; ""]
	[msg = msg + "<br>Current version: " + campaignVersion]
	[broadcast (msg)]
	[abort (0)]
}; {}]
