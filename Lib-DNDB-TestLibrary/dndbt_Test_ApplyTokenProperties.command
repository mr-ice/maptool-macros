<!-- Use the Live characters for these tests -->
<!-- Assumes DTO tests are passing -->
[h: toonNames = "30957877,30957978,30959709,30960137"]
[h: narp_toonNames = "30957978"]
[h: doFinalClean = 1]
[h: libTokenId = currentToken()]

[h: compToken = "TestComparisonToken"]
[h, token (compToken): compTokenId = currentToken ()]
[h: log.info (getMacroName() + ": compTokenId = " + compTokenId)]
[h: selectTokens (compTokenId, 0)]
[h, if (compTokenId == libTokenId), code: {
	[broadcast ("Token named '" + compToken + "' must be a visible token on the map!")]
	[reportResult = json.set ("{}", getMacroName(), "FAILED: No comparison token")]
	[return (0, reportResult)]
}; {}]
[h: reportArry = "[]"]
[h, foreach (toonName, toonNames), code: {
	<!-- Clean the token, then rename it to toonName -->
	[h, token (compToken): dndbt_CleanToken()]

	<!-- Set basic toon to dndb_basicToon and run Reset Properties -->
	[h: basicToon = dndb_buildBasicToon (toonName)]
	[h, token (compToken): setProperty ("dndb_BasicToon", basicToon)]
	[h, token (compToken): dndbt_ResetProperties ("1")]

	<!-- Compare with "Base Token toonName" -->
	[h: testTokenName = "Base Token " + toonName]
	[h, token (testTokenName): testTokenId = currentToken ()]
	[h, if (compTokenId == testTokenId): report = json.append (report, "Tokens are equal! " + compTokenId + ":" + testTokenId)]
	[h: reportArry = json.append (reportArry, dndbt_Util_compareTokens (compTokenId, testTokenId))]
}]
[h, token (compToken), if (doFinalClean): dndbt_CleanToken()]
[h: report = json.set ("{}", getMacroName(), reportArry)]
[h: log.info (report)]
[h: macro.return = report]