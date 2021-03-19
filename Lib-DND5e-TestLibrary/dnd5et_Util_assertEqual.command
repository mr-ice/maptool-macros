[h: actual = arg(0)]
[h: expected = arg(1)]
[h: reportName = arg(2)]
[h: reportResults = json.set ("", reportName, "Test passed")]
[h: actualObj = json.set ("", "actual", actual)]
[h: expectedObj = json.set ("", "expected", expected)]
[h, if (json.type (actual) != json.type (expected)), code: { 
	[reportResults = json.set (reportResults, reportName, json.append ("",
			"Object types do not match", actualObj, expectedObj))]
	[return (0, reportResults)]
}]
[h, if (json.type (actual) == "UNKNOWN"), code: {
	<!-- regular equals check -->
	[if (actual != expected): reportResults = json.set (reportResults, reportName,
		json.append ("", "Values are not equal (==)", actualObj, expectedObj))]
	[return (0, reportResults)]
}]
<!-- JSON values (either Array or Objects) -->
[h, if (!json.equals (actual, expected)), code: {
	[reportResults = json.set (reportResults, reportName, 
		json.append ("", "Objects are not equal (.equals)", actualObj, expectedObj))]
	[return (0, reportResults)]
}]
[h: macro.return = reportResults]