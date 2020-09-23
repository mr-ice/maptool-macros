[h, if (json.length (macro.args) > 0): targetSpellName = arg (0); targetSpellName = ""]

[h: basicToon = dndb_getBasicToon ()]

[h: spells = json.get (basicToon, "spells")]
[h, if (targetSpellName == ""), code: {
	[macro.return = spells]
}; {
	[spellObj = json.get (spells, encode (targetSpellName))]
	[macro.return = spellObj]
}]
