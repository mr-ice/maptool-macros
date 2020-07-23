[h: prefObj = getLibProperty ('_dnd5e_campaignPreferences', 'Lib:CampaignPreferences')]
[h, if (encode (prefObj) == ''): prefObj = '{}'; '']
[h: macro.return = prefObj]