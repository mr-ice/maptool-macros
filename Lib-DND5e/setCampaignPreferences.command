[h, if (json.length (macro.args) == 0), code: {
[h: broadcast ('No!', 'self')]
[h: return (0, '')]
};{''}]
[h: preferences = arg (0)]
[h: setLibProperty ('_dnd5e_campaignPreferences', preferences, 'Lib:CampaignPreferences')]