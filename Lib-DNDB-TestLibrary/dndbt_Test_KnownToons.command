[h: toonNames = "atumash_raging,BhelduhrBallrotterThrahak,Blurrier,Bob,BodeMikbodephace," + 
				"GeeWiz,KazRedrum,KetdelleDankil,Nibbles,RexRedrum,Zairali,Yaichi"]

[h: report = json.append ("", "dndbt_Test_KnownToons Report:")]
[h, foreach (toonName, json.fromList (toonNames)), code: {
	[h: log.warn ("Testing known state for " + toonName)]
	[h: report = json.append (report, "Testing known state for " + toonName)]
	[h: functionName = "[h: builtToon = dndb_buildBasicToon ('dndbt_" + toonName + "')]"]
	[h: evalMacro (functionName)]
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
		[h: reportName = toonName + " - " + field]
		[h: reportObject = dnd5et_Util_assertEqual (macroValue, builtValue, reportName)]
		[h: reportMsg = json.get (reportObject, reportName)]
		[h, if (reportMsg != "Test passed"): report = json.append (report, messageObject)]
	}]
}]
[h: reportObj = json.set ("", "dndbt_Test_KnownToons", report)]
[h: macro.return = reportObj]