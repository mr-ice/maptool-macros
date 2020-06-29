<!-- Use the Live characters for these tests -->
<!-- Assumes DTO tests are passing -->
[h: toonNames = "30957877,30957978,30959709,30960137"]

<!-- Since called macros will run against the selected toon, my only
     effective option is to use Lib as the test token... oh well -->
[h: thisTokenId = currentToken ()]
[h: report = "[]"]
[h, foreach (toonName, toonNames), code: {
	<!-- Clean the token, then rename it to toonName -->
	[h, macro ("Clean Token@Lib:DNDB-TestLibrary"):""]

	<!-- Set basic toon to dndb_basicToon and run Reset Properties -->
	[h: basicToon = dndb_buildBasicToon (toonName)]
	[h: setProperty ("dndb_BasicToon", basicToon)]
	[h, macro ("Reset Properties@Campaign"):"1"]

	<!-- Compare with "Base Token toonName" -->
	[h: testTokenName = "Base Token " + toonName]
	[h, token (testTokenName): testTokenId = currentToken ()]
	[h, if (thisTokenId == testTokenId): report = json.append (report, "Tokens are equal! " + thisTokenId + ":" + testTokenId)]
	[h: report = json.append (report, dndbt_Util_compareTokens (thisTokenId, testTokenId))]
}]
[h: myLabel = getName ()]
[h, if (myLabel == "Lib:DNDB-TestLibrary"), code: {
	[h, macro ("Clean Token@Lib:DNDB-TestLibrary"):""]
};{""}]
[h: log.info (report)]
[h: macro.return = report]