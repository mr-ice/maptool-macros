[h: toonNames = "30957877,30957978,30959709,30960137"]

[h: report = json.append ("", "dndbt_Test_KnownLiveToons Report:")]
[h, foreach (toonName, json.fromList (toonNames)), code: {
	[h: log.warn ("Testing known state for " + toonName)]
	[h: report = json.append (report, "Testing known state for live toon " + toonName)]
	[h: builtToon = dndb_buildBasicToon (toonName)]
	[h: macroIdx = getMacroIndexes ("data_BasicToon_" + toonName)]
	[h: macroCoded = getMacroCommand (macroIdx)]
	[h: builtCoded = base64.encode (builtToon)]
	[h, if (macroCoded != builtCoded), code: {
		[h: report = json.append (report, toonName + ": Differences found in Toon!")]
	}]
	[h: macroToon = base64.decode (macroCoded)]
	[h: fieldDiffs = json.difference (macroToon, builtToon)]
	[h, if (json.length (fieldDiffs) > 0): report = json.append (report, toonName + ": field differences = " + fieldDiffs); ""]
	[h: macroFields = json.fields (macroToon)]
	[h, foreach (field, macroFields), code: {

		[h: log.warn ("Testing field " + field)]
		[h: macroValue = json.get (macroToon, field)]
		[h: builtValue = json.get (builtToon, field)]
		[h: goodMessageObject = json.set ("", field, json.append ("", "macro = " + macroValue, "built = " + builtValue))]
		[h: messageObject = json.set ("", field, json.append ("",
						json.set ("", "macro", macroValue),
						json.set ("", "built", builtValue)
						)
					)
		]
		[h, if (encode (macroValue) != encode (builtValue)): report = json.append (report, messageObject); ""]
	}]
}]
[h: reportObj = json.set ("", "dndbt_Test_KnownToons", report)]
[h: log.info (reportObj)]
[h: macro.return = reportObj]