[h: o5e_ExtDB_Constants(getMacroName())]
[h: dbTokenObj = o5e_ExtDB_getDBToken()]
[h: tokenId = json.get (dbTokenObj, "tokenId")]
[h: assert (tokenId != "", "<font color='red'><b>Database token not found: " + PROXY_TOKEN_NAME +"</b></font>")]
[h: extDb = o5e_ExtDB_getDB()]
[h: NEW_ENTRY = "-- New Entry --"]
[h: entryMap = "{}"]
[h: entrySlugs = json.fields (extDb, "json")]
[h: log.debug (CATEGORY + "entrySlugs = " + entrySlugs)]
[h, foreach (entrySlug, entrySlugs), code: {
	[name = json.path.read (extDb, entrySlug + ".name")]
	[entryMap = json.set (entryMap, name, entrySlug)]
}]
[h: names = json.sort (json.fields (entryMap, "json"))]
[h: entryMap = json.set (entryMap, NEW_ENTRY, "")]
[h: log.debug (CATEGORY + "entryMap = " + entryMap)]
[h: names = json.merge (json.append ("[]", NEW_ENTRY), names)]
[h: inputStr = "junkVar | Select an entry to edit or " + NEW_ENTRY + " to create a new entry" +
		" | | LABEL | span=true"]
[h: inputStr = inputStr + "## selectedName | " + names + " | Entries | " +
		" LIST | value=string delimiter=json"]
[h: inputStr = inputStr +  "## deleteEntry | 0 | Delete Entry | CHECK"]
[h: abort (input (inputStr))]
[h: slug = json.get (entryMap, selectedName)]
[h, if (deleteEntry), code: {
	[if (slug != ""): extDb = json.remove (extDb, slug)]
}; {
	[extDb = o5e_ExtDB_Editor (slug)]
}]
[h: o5e_ExtDB_setDB (extDb)]