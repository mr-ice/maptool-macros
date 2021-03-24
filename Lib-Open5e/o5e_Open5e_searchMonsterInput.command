<!-- prompt for search term -->
[h, if (json.length (macro.args) > 0): searchString = arg (0); ""]
[h: o5e_Constants(getMacroName())]
[h, if (searchString == ""): searchString = "Adult Donkey"; ""]
[h: found = 0]
[h: monsterJson = "{}"]
[h, while (!found), code: {
<!-- search and parse results -->
	[abort (input ("searchString | " + searchString + " | Monster name to search for | text"))]
	[searchResult = o5e_Open5e_searchMonster (searchString)]
	[resultCount = json.get (searchResult, "count")]
	[resultMsg = "Found " + resultCount + " results."]
	[resultArray = json.get (searchResult, "results")]
	[nameArray = "[]"]
	[records = 0]
	[foreach (resultObj, resultArray), code: {
		[monsterName = json.get (resultObj, "name")]
		<!-- Remove commas from monster names -->
		[monsterName = replace (monsterName, ",", "")]
		[nameArray = json.append (nameArray, monsterName)]
		[records = records + 1]
	}]
<!-- prompt for confirmation or search refinement; retstart w/ refinement -->
    [if (records < resultCount): resultMsg = resultMsg + " Showing " + records + " entries."; ""]
    [inputString = "junk | " + resultMsg + " | | LABEL | span=true"]
	[inputString = inputString + "## nameSelection | " + json.toList(nameArray) + " | Select Name or Cancel to refine search | List "]

	[overwriteName = dnd5e_Preferences_getPreference (PREF_OVERWRITE_NAME)]
	[useGmName = dnd5e_Preferences_getPreference (PREF_USE_GM_NAME)]
	[inputString = inputString + "## overwriteName | " + overwriteName + " | Overwrite token name | CHECK"]
	[inputString = inputString + "## useGmName | " + useGmName + " | Populate GM Name Instead | CHECK"]
	[hitPointsRoll = dnd5e_Preferences_getPreference (PREF_HIT_DICE_ROLL)]
	[inputString = inputString  + "## hitPointsRoll | " + VALUES_HIT_DICE_ROLL + " | Hit Points Value | LIST | select=" + hitPointsRoll + " delimiter=json"]
	
	[if (resultCount): found = input (inputString); 
		input ("junk|No results found for " + searchString + "| | Label | span=true")]
	[if (found): monsterJson = json.get (resultArray, nameSelection); ""]
	[dnd5e_Preferences_setPreference (PREF_OVERWRITE_NAME, overwriteName, 1)]
	[dnd5e_Preferences_setPreference (PREF_USE_GM_NAME, useGmName, 1)]
	[dnd5e_Preferences_setPreference (PREF_HIT_DICE_ROLL, hitPointsRoll, 1)]
}]
<!-- return monster json -->
[h: log.debug (getMacroName() + ": monsterJson = " + monsterJson)]
[h: macro.return = monsterJson]