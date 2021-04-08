[h: l4m.disableLineParser()]
[h: dnd5e_PartyPanel_Constants (getMacroName())]
[h, token (LIB_TOKEN): tokenId = currentToken()]
[h, if (tokenId == ""), code: {
	[selectedTokens = getSelected ("json")]
	[if (json.length (selectedTokens) > 0): tokenId = json.get (selectedTokens, 0)]
}]
[h: assert (tokenId != "", "<font style='color:red'><b>Select one or more tokens before executing</b></font>", 0)]
[h: cfg = dnd5e_PartyPanel_getConfig ()]
[h: log.trace (CATEGORY + "## cfg = " + cfg)]
[h: displayNames = "[]"]
[h: valueNames = json.fields (TOKEN_LABEL_MAP, "json")]
[h, foreach (valueName, valueNames): 
		displayNames = json.append (displayNames, json.get (TOKEN_LABEL_MAP, valueName))]
[h: log.debug (CATEGORY + "## valueNames = " + valueNames + "; displayNames = " + displayNames)]

[h: tokenProperty = json.get (cfg, CONFIGURATION_TOKEN_PROP_KEY)]

[h: propertySelected = 0]
[h: selectedDisplayName = json.get (TOKEN_LABEL_MAP, tokenProperty)]

[h: propertySelected = json.indexOf (displayNames, selectedDisplayName)]
[h: log.debug (CATEGORY + "## selectedDisplayName = " + selectedDisplayName + "; propertySelected = " + propertySelected)]
[h: inputStr = "junk | <html><B>Token Property:</B> Property to read when display tokennames<br>||" +
		"LABEL | span=true"]
[h: inputStr = inputStr + "##tokenProperty | " + displayNames + " | Token Propery | List | delimiter=json select=" + propertySelected]
[h: inputStrx = inputStr + "##junk | <html><b>Example Property</b></html> | <html><b>Property Name Value</b></html> | LABEL"]
[h: inputStr = inputStr + "##junk | ------------------------------------------------------------------------------- | | label | span=true"]
[h: selectedProperties = json.get (cfg, CONFIGURATION_SELECTED_PROPERTIES_KEY)]
[h: log.trace (CATEGORY + "## selectedProperties = " + selectedProperties)]
[h, foreach (selectedProperty, selectedProperties, ""), code: {
	<!-- strip spaces -->
	[inputtedProperty = replace (selectedProperty, "\\s", "")]
	[propertyCfg = json.get (selectedProperties, selectedProperty)]
	[log.debug (CATEGORY + "##selectedProperty = " + selectedProperty + "; propertyCfg = " + propertyCfg)]
	[isSelected = json.get (propertyCfg, CONFIGURATION_SELECTED_KEY)]
	[isChecked = json.get (propertyCfg, CONFIGURATION_CHECKED_KEY)]
	[exampleValue = getProperty (selectedProperty, tokenId)]
	[displayValue = if (json.contains (propertyCfg, CONFIGURATION_DISPLAY_NAME_KEY), 
				json.get (propertyCfg, CONFIGURATION_DISPLAY_NAME_KEY),
				selectedProperty)]
	[token (LIB_TOKEN), if (isChecked): exampleValue = dnd5e_PartyPanel_Panel_formatBonus(exampleValue)]
	[inputStr = inputStr + "##isSelected." + inputtedProperty + " | " + isSelected + " |" + displayValue + " | check"]
	[inputStr = inputStr + "##junk | <html><pre>" + exampleValue + "</pre></html> | " + selectedProperty + " | label | span=true"]

	<!-- Not currently showing a configurable subObject. But leaving the code around, just in case -->
	[strPropCfg = json.toStrProp (propertyCfg)]
	[log.debug (CATEGORY + "## strPropCfg = " + strPropCfg)]
	[inputStrx = inputStr + "## junk | " + strPropCfg + " | <html><pre>" + exampleValue + "</pre></html> | props"]
	
}]

[h: log.trace (CATEGORY + "## inputStr = " + inputStr)]

[h: abort (input (inputStr))]

[h: selectedTokenProperty = json.get (valueNames, tokenProperty)]
[h: log.debug (CATEGORY + "## after input, tokenProperty = " + tokenProperty + 
		"; selectedTokenProperty = " + selectedTokenProperty)]
[h: newCfg = json.set ("", CONFIGURATION_TOKEN_PROP_KEY, selectedTokenProperty) ]
[h, foreach (selectedProperty, selectedProperties, ""), code: {
	[inputtedProperty = replace (selectedProperty, "\\s", "")]
	[propertyCfg = json.get (selectedProperties, selectedProperty)]
	[evalMacro ("[h: isChecked = isSelected." + inputtedProperty + "]")]
	[log.debug (CATEGORY + "## " + selectedProperty + " isChecked = " + isChecked)]
	[propertyCfg = json.set (propertyCfg, CONFIGURATION_SELECTED_KEY, isChecked)]
	[selectedProperties = json.set (selectedProperties, selectedProperty, propertyCfg)]
}]
[h: newCfg = json.set (newCfg, CONFIGURATION_SELECTED_PROPERTIES_KEY, selectedProperties)]
[h: log.trace (CATEGORY + "## newCfg = " + newCfg)]
[h: dnd5e_PartyPanel_setConfig (newCfg)]
<!-- If the panel is showing, refresh it -->
[h: dnd5e_PartyPanel_refreshPanel()]