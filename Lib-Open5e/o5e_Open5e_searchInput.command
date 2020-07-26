<!-- prompt for search term -->
[h, if (json.length (macro.args) > 0): searchString = arg (0); ""]
[h, if (searchString == ""): searchString = "Adult Donkey"; ""]
[h: found = 0]
[h: monsterJson = "{}"]
[h, while (!found), code: {
<!-- search and parse results -->
	[abort (input ("searchString | " + searchString + " | Monster name to search for | text"))]
	[searchResult = o5e_Open5e_searchMonster (searchString)]
	[resultCount = json.get (searchResult, "count")]
	[resultMsg = "Found " + resultCount + " results"]
	[resultArray = json.get (searchResult, "results")]
	[nameArray = "[]"]
	[foreach (resultObj, resultArray), code: {
		[monsterName = json.get (resultObj, "name")]
		[nameArray = json.append (nameArray, monsterName)]
	}]
<!-- prompt for confirmation or search refinement; retstart w/ refinement -->
	[inputString = "nameSelection | " + json.toList(nameArray) + " | Select Name or Cancel to refine search | List "]
	[if (resultCount): found = input (inputString); 
		input ("junk|No results found for " + searchString + "| | Label | span=true")]
	[if (found): monsterJson = json.get (resultArray, nameSelection); ""]

}]
<!-- return monster json -->
[h: log.debug (getMacroName() + ": monsterJson = " + monsterJson)]
[h: macro.return = monsterJson]