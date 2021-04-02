[h: spellBlock = arg(0)]
[h: o5e_Constants (getMacroName())]
<!-- Eace line is new-line separated. at the beginning of each line is either:
Cantrips (at will):
1st level (4 slots):
At will:
1/day each:

Followed by a comma-delimited list of spells
-->
[h: spellDataList = json.fromList (spellBlock, "\\n")]
[h: log.debug (CATEGORY + "## spellDataList = " + spellDataList)]
[h: SPELL_DATA_PATTERN = "([^:]*):(.*)"]
[h: spellObj = "{}"]
[h, foreach (spellData, spellDataList), code: {
	[log.debug (CATEGORY + "## spellData = " + spellData)]
	[findId = strfind (spellData, SPELL_DATA_PATTERN)]
	[if (getFindCount (findId) > 0), code: {
		[log.debug (CATEGORY + "## Matched")]
		[key = getGroup (findId, 1, 1)]
		[spellStrList = getGroup (findId, 1, 2)]
		[spellObj = json.set (spellObj, key, json.fromList (spellStrList, ","))]
	}; {
		[log.debug (CATEGORY + "## No match")]
	}]
}]
[h: log.debug (CATEGORY + "## spellObj = " + spellObj)]
[h: macro.return = spellObj]