[h: log.info ("args: " + json.indent (macro.args))]
[h: log.info ("Selected = " + getSelected())]

[h: action = json.get (macro.args, "action")]
[h, if (action != "OK"): abort (0); ""]
[h: selectedTokens = getSelected("json")]
[h, if (json.length (selectedTokens) != 1), code: {
	[broadcast ("<font color='red'>Exactly one token was not selected!</font>")]
	[return (0, "Aborted")]
}]
[h: selectedToken = json.get (selectedTokens, 0)]
<!-- Rename it -->
[h: setName ("Lib:CampaignPreferences", selectedToken)]
[h: macroCommand = "[h: prefObj = getLibProperty ('_dnd5e_campaignPreferences', 'Lib:CampaignPreferences')]
[h, if (encode (prefObj) == ''): prefObj = '{}'; '']
[h: macro.return = prefObj]"]
[h: macros = getMacroIndexes ("getCampaignPreferences", ",", selectedToken)]
[h, token (selectedToken), if (encode (macros) == ""): createMacro ("getCampaignPreferences", macroCommand, json.set ("", "playerEditable", 0)); ""]
[h: macroCommand = "[h, if (json.length (macro.args) == 0), code: {
[h: broadcast ('No!', 'self')]
[h: return (0, '')]
};{''}]
[h: preferences = arg (0)]
[h: setLibProperty ('_dnd5e_campaignPreferences', preferences, 'Lib:CampaignPreferences')]"]

[h: macros = getMacroIndexes ("setCampaignPreferences", ",", selectedToken)]
[h, token (selectedToken), if (encode (macros) == ""): createMacro ("setCampaignPreferences", macroCommand, json.set ("", "playerEditable", 0));""]


[h: input (" junk | A new library token has been created: Lib:CampaignPreferences | | Label | span=true",
" junk | <html><b>Do not rename, replace, or delete it unless you intend to re-configure your preferences</b></html> || Label | span=true")]
