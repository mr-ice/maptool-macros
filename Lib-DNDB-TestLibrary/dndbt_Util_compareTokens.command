[h: tokenId1 = arg (0)]
[h: tokenId2 = arg (1)]

[h: token1Label = getName (tokenId1)]
[h: token2Label = getName (tokenId2)]
[h: log.debug (getMacroName() + "## token1: " + token1Label + "; token2: " 
		+ token2Label)]
[h: reportName = "Token compare report for " + token1Label + "::" + token2Label]
[h: reportArry = "[]"]
<!-- Compare properties, stick to Basic -->
[h: properties = getAllPropertyNames ("Basic", "json")]
[h: properties = json.removeAll (properties, "Character ID")]
[h, foreach (property, properties), code: {
	
	[h: prop1 = getProperty (property, tokenId1)]
	[h: prop2 = getProperty (property, tokenId2)]
	[h: reportName = "Compare Token - " + property]
	[h: testResult = dnd5et_Util_assertEqual (prop1, prop2, reportName)]
	[h: resultMsg = json.get (testResult, reportName)]
	[h: log.debug (getMacroName() + "## " + property + ": " + resultMsg)]
	[h, if (resultMsg != "Test passed"): reportArry = json.append (reportArry, testResult)]
}]
<!-- Compare Bars -->


<!-- Compare States -->
[h: report = json.set ("{}", reportName, reportArry)]
[h: macro.return = report]