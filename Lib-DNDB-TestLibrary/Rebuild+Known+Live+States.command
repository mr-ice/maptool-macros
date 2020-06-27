[h: toonNames = "30957877,30957978,30959709,30960137"]
[h, foreach (toonName, toonNames), code: {
	[h: builtToon = dndb_buildBasicToon (toonName)]
	[h: dndbt_CreateDataMacro (builtToon, toonName)]
}]
[h: log.info ("Build Known States, done")]