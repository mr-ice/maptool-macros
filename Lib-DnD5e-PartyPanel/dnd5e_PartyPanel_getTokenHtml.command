[h: tokenId = arg(0)]
[h: dnd5e_PartyPanel_Constants (getMacroName())]
[h: cfg = dnd5e_PartyPanel_getConfig()]
[h: html = "<tr>"]

[h: tokenValue = json.get (cfg, CONFIGURATION_TOKEN_PROP_KEY)]
[h, if (tokenId != ""), token (tokenId), code: { 
	[tokenValue = evalMacro ("[r:" + tokenValue + "]")]
	[html = concat (html, "<th>" + tokenValue + "</th>")]
}; {
	[html = concat (html, "<th>PC</th>")]
}]

[h: selectedProperties = json.get (cfg, CONFIGURATION_SELECTED_PROPERTIES_KEY)]

[h, foreach (selectedProperty, selectedProperties), code: {
	[propertyCfg = json.get (selectedProperties, selectedProperty)]
	[isSelected = json.get (propertyCfg, CONFIGURATION_SELECTED_KEY)]
	[displayValue = json.get (propertyCfg, CONFIGURATION_DISPLAY_NAME_KEY)]
	[if (displayValue == ""): displayValue = selectedProperty]
	[if (isSelected), code: {
		[if (tokenId != ""): 
			propertyValue = getProperty (selectedProperty, tokenId);
			propertyValue = displayValue]
		[isCheck = json.get (propertyCfg, CONFIGURATION_CHECKED_KEY)]
		[if (isCheck && tokenId != ""): 
			propertyValue = dnd5e_PartyPanel_getRollLink (
					selectedProperty,
					tokenId,
					dnd5e_PartyPanel_Panel_formatBonus (propertyValue))]
		[if (tokenId != ""):
			html = concat (html, "<td>" + propertyValue + "</td>");
			html = if (isCheck, 
					html + "<th>" + dnd5e_PartyPanel_getRollLink (selectedProperty, "",  propertyValue) + "</th>",
					html + "<th>" + propertyValue + "</th>")]
	}]	
}]

[h: html = concat (html, "</tr>")]
[h: macro.return = html]